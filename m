Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab3ETJez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 05:34:55 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:56490 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925Ab3ETJex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 05:34:53 -0400
Message-ID: <5199ED83.5040804@linux.vnet.ibm.com>
Date: Mon, 20 May 2013 15:01:47 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>, Borislav Petkov <bp@alien8.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
CC: Michael Wang <wangyun@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, Tony Luck <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: NOHZ: WARNING: at arch/x86/kernel/smp.c:123 native_smp_send_reschedule,
 round 2
References: <alpine.LNX.2.00.1305091423460.23038@pobox.suse.cz> <20130509125040.GF27333@pd.tnic>	<20130509125859.GG27333@pd.tnic> <20130515184528.GO4442@linux.vnet.ibm.com>	<20130515224358.GF11783@pd.tnic> <20130515235512.GT4442@linux.vnet.ibm.com>	<20130517135641.GF23035@pd.tnic> <51999591.8030401@linux.vnet.ibm.com>	<20130520045023.GA12690@pd.tnic> <CAFTL4hwm4Cox=ynVcO-oLG=Jt_1Lro+hbcpEE5hiAYEJGipaLA@mail.gmail.com>
In-Reply-To: <CAFTL4hwm4Cox=ynVcO-oLG=Jt_1Lro+hbcpEE5hiAYEJGipaLA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052009-7014-0000-0000-0000030BE517
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2013 01:40 PM, Frederic Weisbecker wrote:
> 2013/5/20 Borislav Petkov <bp@alien8.de>:
>> On Mon, May 20, 2013 at 11:16:33AM +0800, Michael Wang wrote:
>>> I suppose the reason is that the cpu we passed to
>>> mod_delayed_work_on() has a chance to become offline before we
>>> disabled irq, what about check it before send resched ipi? like:
>>
>> I think this is only addressing the symptoms - what we should be doing
>> instead is asking ourselves why are we even scheduling work on a cpu if
>> the machine goes offline?
>>
>> I don't know though who should be responsible for killing all that
>> work - the workqueue itself or the guy who created it, i.e. cpufreq
>> governor...
>>
>> Hmmm.
> 
> Let's look at this portion of cpu_down():
> 
> 	err = __stop_machine(take_cpu_down, &tcd_param, cpumask_of(cpu));
> 	if (err) {
> 		/* CPU didn't die: tell everyone.  Can't complain. */
> 		smpboot_unpark_threads(cpu);
> 		cpu_notify_nofail(CPU_DOWN_FAILED | mod, hcpu);
> 		goto out_release;
> 	}
> 	BUG_ON(cpu_online(cpu));
> 
> 	/*
> 	 * The migration_call() CPU_DYING callback will have removed all
> 	 * runnable tasks from the cpu, there's only the idle task left now
> 	 * that the migration thread is done doing the stop_machine thing.
> 	 *
> 	 * Wait for the stop thread to go away.
> 	 */
> 	while (!idle_cpu(cpu))
> 		cpu_relax();
> 	/* This actually kills the CPU. */
> 	__cpu_die(cpu);
> 
> 	/* CPU is completely dead: tell everyone.  Too late to complain. */
> 	cpu_notify_nofail(CPU_DEAD | mod, hcpu);
> 
> 	check_for_tasks(cpu);
> 
> The CPU is considered offline after the take_cpu_down stop machine job
> completes. But the struct timer_list timers are migrated later through
> CPU_DEAD notification. Only once that's completed we check for illegal
> residual tasks in the CPU.  So there is a little window between the
> stop machine thing and __cpu_die() where a timer can fire with
> cpu_online(cpu) == 1.
> 

Nope, the dying CPU is removed from the cpu_online_mask in the very first
stages of stop_machine(), specifically in the __cpu_disable() function.
__cpu_die() is just a dummy.

> Now concerning the workqueue I don't know. I guess the per cpu ones
> are not migrated due to their affinity. Apparently they can still wake
> up and execute works due to the timers...

The interesting thing is that the cpufreq governor actually _cancels_ the
queued work in CPU_DOWN_PREPARE stage, as far as I understand.

cpufreq_cpu_callback()
  -> __cpufreq_remove_dev()
    -> __cpufreq_governor(data, CPUFREQ_GOV_STOP);
      -> od_cpufreq_governor_dbs()
	 -> cpufreq_governor_dbs(), which has the following case statement:


        case CPUFREQ_GOV_STOP:
                if (dbs_data->cdata->governor == GOV_CONSERVATIVE)
                        cs_dbs_info->enable = 0;

                gov_cancel_work(dbs_data, policy);

                mutex_lock(&dbs_data->mutex);
                mutex_destroy(&cpu_cdbs->timer_mutex);

                mutex_unlock(&dbs_data->mutex);

                break;


But recently I removed the call to __cpufreq_remove_dev() in the suspend/resume
path (tasks frozen), in commit a66b2e503 (cpufreq: Preserve sysfs files across
suspend/resume). So I'm curious to know if this is affecting in any way.

So Boris, do you see the warnings during regular hotplug also (via sysfs) or
only during suspend/shutdown? [Actually shutdown doesn't freeze tasks, so that is
already a hint that this warning can be triggered via sysfs also, but it would
be good to get a confirmation.]

And Viresh, in the regular hotplug paths, the call to gov_cancel_work() is
supposed to kill any pending workqueue functions pertaining to offline CPUs
right? Could there be a synchronization bug somewhere due to which this
might not be happening properly?

Regards,
Srivatsa S. Bhat

