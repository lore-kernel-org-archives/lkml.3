Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab3ETIKH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 04:10:07 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:41937 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820Ab3ETIKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 04:10:04 -0400
MIME-Version: 1.0
In-Reply-To: <20130520045023.GA12690@pd.tnic>
References: <alpine.LNX.2.00.1305091423460.23038@pobox.suse.cz>
	<20130509125040.GF27333@pd.tnic>
	<20130509125859.GG27333@pd.tnic>
	<20130515184528.GO4442@linux.vnet.ibm.com>
	<20130515224358.GF11783@pd.tnic>
	<20130515235512.GT4442@linux.vnet.ibm.com>
	<20130517135641.GF23035@pd.tnic>
	<51999591.8030401@linux.vnet.ibm.com>
	<20130520045023.GA12690@pd.tnic>
Date: Mon, 20 May 2013 10:10:02 +0200
Message-ID: <CAFTL4hwm4Cox=ynVcO-oLG=Jt_1Lro+hbcpEE5hiAYEJGipaLA@mail.gmail.com>
Subject: Re: NOHZ: WARNING: at arch/x86/kernel/smp.c:123 native_smp_send_reschedule,
 round 2
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Michael Wang <wangyun@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, Tony Luck <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/5/20 Borislav Petkov <bp@alien8.de>:
> On Mon, May 20, 2013 at 11:16:33AM +0800, Michael Wang wrote:
>> I suppose the reason is that the cpu we passed to
>> mod_delayed_work_on() has a chance to become offline before we
>> disabled irq, what about check it before send resched ipi? like:
>
> I think this is only addressing the symptoms - what we should be doing
> instead is asking ourselves why are we even scheduling work on a cpu if
> the machine goes offline?
>
> I don't know though who should be responsible for killing all that
> work - the workqueue itself or the guy who created it, i.e. cpufreq
> governor...
>
> Hmmm.

Let's look at this portion of cpu_down():

	err = __stop_machine(take_cpu_down, &tcd_param, cpumask_of(cpu));
	if (err) {
		/* CPU didn't die: tell everyone.  Can't complain. */
		smpboot_unpark_threads(cpu);
		cpu_notify_nofail(CPU_DOWN_FAILED | mod, hcpu);
		goto out_release;
	}
	BUG_ON(cpu_online(cpu));

	/*
	 * The migration_call() CPU_DYING callback will have removed all
	 * runnable tasks from the cpu, there's only the idle task left now
	 * that the migration thread is done doing the stop_machine thing.
	 *
	 * Wait for the stop thread to go away.
	 */
	while (!idle_cpu(cpu))
		cpu_relax();
	/* This actually kills the CPU. */
	__cpu_die(cpu);

	/* CPU is completely dead: tell everyone.  Too late to complain. */
	cpu_notify_nofail(CPU_DEAD | mod, hcpu);

	check_for_tasks(cpu);

The CPU is considered offline after the take_cpu_down stop machine job
completes. But the struct timer_list timers are migrated later through
CPU_DEAD notification. Only once that's completed we check for illegal
residual tasks in the CPU.  So there is a little window between the
stop machine thing and __cpu_die() where a timer can fire with
cpu_online(cpu) == 1.

Now concerning the workqueue I don't know. I guess the per cpu ones
are not migrated due to their affinity. Apparently they can still wake
up and execute works due to the timers...
