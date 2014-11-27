Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751146AbaK0V4a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 16:56:30 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:63557 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaK0V43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 16:56:29 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1411271609510.3961@nanos>
References: <65CD3FC07F3BF942ABE211646D72D770356EACA5@IRSMSX110.ger.corp.intel.com>
 <1417099205-13309-1-git-send-email-emmanuel.berthier@intel.com> <alpine.DEB.2.11.1411271609510.3961@nanos>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 27 Nov 2014 13:56:07 -0800
Message-ID: <CALCETrWKiTdzSQ6kKPaufHoW2aTjPtqkQy9cyq_YiBwoowe-+g@mail.gmail.com>
Subject: Re: [PATCH v2] [LBR] Dump LBRs on Exception
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Emmanuel Berthier <emmanuel.berthier@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        robert.jarzmik@intel.com, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 1:22 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Thu, 27 Nov 2014, Emmanuel Berthier wrote:
>> diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
>> index 45fa730..0a69365 100644
>> --- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
>> +++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
>> @@ -4,7 +4,7 @@
>>  #include <asm/perf_event.h>
>>  #include <asm/msr.h>
>>  #include <asm/insn.h>
>> -
>
> This newline is intentional to seperate asm includes from the local
> one.
>
>>  static void __intel_pmu_lbr_enable(void)
>>  {
>>       u64 debugctl;
>>       struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
>>
>> +     lbr_set_used_by_perf(true);
>
> This cannot work.
>
> CPU0                                    CPU1
>
> __intel_pmu_lbr_enable()
>    lbr_set_used_by_perf(true);
>                                         __intel_pmu_lbr_disable()
>                                           lbr_set_used_by_perf(false);
>
> This is a per cpu property.
>
> And there is more to that. Let's look at a single CPU.
>
> lbr for oops is enabled
>
> context switch()
>    __intel_pmu_lbr_enable()     -> LBR used by perf, oops dumper disabled
>
> context switch()
>    __intel_pmu_lbr_disable()    -> LBR not longer used by perf, oops
>                                    dumper enabled
>
> So after that context switch we crash in the kernel and LBR is empty
> because we did disable it at the context switch.
>
> So you need per cpu state, which handles the LBR dumper state:
>
> #define LBR_OOPS_DISABLED 0x01
> #define LBR_PERF_USAGE    0x02
>
> DEFINE_PER_CPU(unsigned long, lbr_dump_state) = LBR_OOPS_DISABLED;
>
> lbr_perf_enable()
>         this_cpu_add(lbr_dump_state, LBR_PERF_USAGE);
>
> lbr_perf_disable()
>         if (!this_cpu_sub_return(lbr_dump_state, LBR_PERF_USAGE))
>                 enable_lbr_oops();
>
> Now of course you need to handle this in the exception path per cpu as
> well.
>
>>  /*
>>   * Exception entry points.
>>   */
>> @@ -1063,6 +1103,8 @@ ENTRY(\sym)
>>       subq $ORIG_RAX-R15, %rsp
>>       CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
>>
>> +     STOP_LBR
>
> We really cannot do this unconditionally for every exception. This
> wants to be conditional, i.e.
>
>        .if \stop_lbr
>        cond_stop_lbr
>        .endif
>
> So we can select which exceptions actually get that treatment.
> do_page_fault is probably the only one which is interesting
> here.
>
> Now looking at your macro maze, I really wonder whether we can do it a
> little bit less convoluted. We need to push/pop registers. error_entry
> saves the registers already and has a (admitedly convoluted)
> kernel/user space check. But we might be able to do something sane
> there. Cc'ing Andy as he is the master of that universe.
>

Can one of you give me some context as to what this code is intended
to do?  I haven't followed the thread.

In particular, knowing why this needs to be in asm instead of in C
would be nice, because asm in entry_64.S has an amazing ability to
have little bugs hiding for years.

There's also the caveat that, especialy for the IST exceptions, you're
running in a weird context in which lots of things that are usually
safe are verboten.  Page faults can be tricky too, though.

--Andy

> Thanks,
>
>         tglx
>
>
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
