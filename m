Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759958Ab3CGXfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 18:35:51 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:45285 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab3CGXft convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 18:35:49 -0500
MIME-Version: 1.0
In-Reply-To: <20130211143529.GB2749@pd.tnic>
References: <1357610913-1080-1-git-send-email-fweisbec@gmail.com>
	<1357610913-1080-8-git-send-email-fweisbec@gmail.com>
	<20130211143529.GB2749@pd.tnic>
Date: Fri, 8 Mar 2013 00:35:47 +0100
Message-ID: <CAFTL4hx1BzTtYSBp8zP+E1DNwgtErJJHN_aqagbss8SCryZBYg@mail.gmail.com>
Subject: Re: [PATCH 07/33] nohz: Basic full dynticks interface
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/11 Borislav Petkov <bp@alien8.de>:
> On Tue, Jan 08, 2013 at 03:08:07AM +0100, Frederic Weisbecker wrote:
>
> [ … ]
>
>> diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
>> index 8601f0d..dc6381d 100644
>> --- a/kernel/time/Kconfig
>> +++ b/kernel/time/Kconfig
>> @@ -70,6 +70,15 @@ config NO_HZ
>>         only trigger on an as-needed basis both when the system is
>>         busy and when the system is idle.
>>
>> +config NO_HZ_FULL
>> +       bool "Full tickless system"
>
> I think you want to say here "Almost-completely tickless system".
> "Almost" because of that one CPU outside of the range :-)

I think that "Full dynticks system" would express well what happens?

>
>> +       depends on NO_HZ && RCU_USER_QS && VIRT_CPU_ACCOUNTING_GEN && RCU_NOCB_CPU && SMP
>> +       select CONTEXT_TRACKING_FORCE
>> +       help
>> +         Try to be tickless everywhere, not just in idle. (You need
>> +      to fill up the full_nohz_mask boot parameter).
>> +
>> +
>>  config HIGH_RES_TIMERS
>>       bool "High Resolution Timer Support"
>>       depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
>> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
>> index 314b9ee..494a2aa 100644
>> --- a/kernel/time/tick-sched.c
>> +++ b/kernel/time/tick-sched.c
>> @@ -142,6 +142,29 @@ static void tick_sched_handle(struct tick_sched *ts, struct pt_regs *regs)
>>       profile_tick(CPU_PROFILING);
>>  }
>>
>> +#ifdef CONFIG_NO_HZ_FULL
>> +static cpumask_var_t full_nohz_mask;
>> +bool have_full_nohz_mask;
>> +
>> +int tick_nohz_full_cpu(int cpu)
>> +{
>> +     if (!have_full_nohz_mask)
>> +             return 0;
>> +
>> +     return cpumask_test_cpu(cpu, full_nohz_mask);
>> +}
>> +
>> +/* Parse the boot-time nohz CPU list from the kernel parameters. */
>> +static int __init tick_nohz_full_setup(char *str)
>> +{
>> +     alloc_bootmem_cpumask_var(&full_nohz_mask);
>> +     have_full_nohz_mask = true;
>> +     cpulist_parse(str, full_nohz_mask);
>
> Don't you want to check retval of cpulist_parse first here before
> assigning have_full_nohz_mask and allocating cpumask var?
>
> We don't trust userspace, you know.

Yeah sure. I was really in draft/laboratory mode until now. But I
guess I need to start thinking about such details, since nobody seem
to oppose with the whole design. Time to zoom in.

>
>> +     return 1;
>> +}
>> +__setup("full_nohz=", tick_nohz_full_setup);
>
> I'd guess this kernel parameter needs to go into
> Documentation/kernel-parameters.txt along with a referral to
> Documentation/cputopology.txt which explains how to specify cpulists for
> n00bs like me :-)

Sure, I'll add that on my TODO list.

Thanks!
