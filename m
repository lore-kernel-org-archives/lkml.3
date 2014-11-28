Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbaK1PPn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 10:15:43 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:42730 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbaK1PPm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 10:15:42 -0500
MIME-Version: 1.0
In-Reply-To: <65CD3FC07F3BF942ABE211646D72D770356EB2B2@IRSMSX110.ger.corp.intel.com>
References: <65CD3FC07F3BF942ABE211646D72D770356EACA5@IRSMSX110.ger.corp.intel.com>
 <1417099205-13309-1-git-send-email-emmanuel.berthier@intel.com>
 <alpine.DEB.2.11.1411271609510.3961@nanos> <CALCETrWKiTdzSQ6kKPaufHoW2aTjPtqkQy9cyq_YiBwoowe-+g@mail.gmail.com>
 <65CD3FC07F3BF942ABE211646D72D770356EB2B2@IRSMSX110.ger.corp.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 28 Nov 2014 07:15:20 -0800
Message-ID: <CALCETrWO5jVaXrvtMmxEtV0-9husbwFrm=FLWUvEJJev25KXmg@mail.gmail.com>
Subject: Re: [PATCH v2] [LBR] Dump LBRs on Exception
To: "Berthier, Emmanuel" <emmanuel.berthier@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        X86 ML <x86@kernel.org>, "Jarzmik, Robert" <robert.jarzmik@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 12:44 AM, Berthier, Emmanuel
<emmanuel.berthier@intel.com> wrote:
>> -----Original Message-----
>> From: Andy Lutomirski [mailto:luto@amacapital.net]
>> Sent: Thursday, November 27, 2014 10:56 PM
>> To: Thomas Gleixner
>> Cc: Berthier, Emmanuel; H. Peter Anvin; X86 ML; Jarzmik, Robert; LKML
>> Subject: Re: [PATCH v2] [LBR] Dump LBRs on Exception
>>
>> On Thu, Nov 27, 2014 at 1:22 PM, Thomas Gleixner <tglx@linutronix.de>
>> wrote:
>> >>  /*
>> >>   * Exception entry points.
>> >>   */
>> >> @@ -1063,6 +1103,8 @@ ENTRY(\sym)
>> >>       subq $ORIG_RAX-R15, %rsp
>> >>       CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
>> >>
>> >> +     STOP_LBR
>> >
>> > We really cannot do this unconditionally for every exception. This
>> > wants to be conditional, i.e.
>> >
>> >        .if \stop_lbr
>> >        cond_stop_lbr
>> >        .endif
>> >
>> > So we can select which exceptions actually get that treatment.
>> > do_page_fault is probably the only one which is interesting here.
>> >
>> > Now looking at your macro maze, I really wonder whether we can do it a
>> > little bit less convoluted. We need to push/pop registers. error_entry
>> > saves the registers already and has a (admitedly convoluted)
>> > kernel/user space check. But we might be able to do something sane
>> > there. Cc'ing Andy as he is the master of that universe.
>> >
>>
>> Can one of you give me some context as to what this code is intended to do?
>> I haven't followed the thread.
>>
>> In particular, knowing why this needs to be in asm instead of in C would be
>> nice, because asm in entry_64.S has an amazing ability to have little bugs
>> hiding for years.
>>
>> There's also the caveat that, especialy for the IST exceptions, you're running
>> in a weird context in which lots of things that are usually safe are verboten.
>> Page faults can be tricky too, though.
>>
>> --Andy
>
> Welcome Andy.
> The global purpose of this patch is to disable/enable LBR during exception handling and dump them later in the Panic process in order to get a small instruction trace which could help in case of stack corruption by example.
> This has to be done at the very early stage of exception handling as LBR contains few records (8 or 16) and we do not want to flush useful ones (those before the exception), so this code should avoid executing any jump/branch/call before stopping the LBR.
>
> The proposed patch regarding asm code is as follow:
>
>  diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S index df088bb..f39cded 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -1035,6 +1035,46 @@ apicinterrupt IRQ_WORK_VECTOR \
>         irq_work_interrupt smp_irq_work_interrupt  #endif
>
> +.macro STOP_LBR
> +#ifdef CONFIG_LBR_DUMP_ON_EXCEPTION
> +       testl $3,CS+8(%rsp)             /* Kernel Space? */
> +       jz 1f
> +       testl $1, lbr_dump_on_exception

Is there a guarantee that, if lbr_dump_on_exception is true, then LBR is on?

What happens if you schedule between stopping and resuming LBR?

> +       jz 1f
> +       push %rax
> +       push %rcx
> +       push %rdx
> +       movl $MSR_IA32_DEBUGCTLMSR, %ecx
> +       rdmsr
> +       and $~1, %eax                   /* Disable LBR recording */
> +       wrmsr

wrmsr is rather slow.  Have you checked whether this is faster than
just saving the LBR trace on exception entry?

--Andy

> +       pop %rdx
> +       pop %rcx
> +       pop %rax
> +1:
> +#endif
> +.endm
> +
> +.macro START_LBR
> +#ifdef CONFIG_LBR_DUMP_ON_EXCEPTION
> +       testl $3,CS+8(%rsp)             /* Kernel Space? */
> +       jz 1f
> +       testl $1, lbr_dump_on_exception
> +       jz 1f
> +       push %rax
> +       push %rcx
> +       push %rdx
> +       movl $MSR_IA32_DEBUGCTLMSR, %ecx
> +       rdmsr
> +       or $1, %eax                     /* Enable LBR recording */
> +       wrmsr
> +       pop %rdx
> +       pop %rcx
> +       pop %rax
> +1:
> +#endif
> +.endm
> +
>  /*
>   * Exception entry points.
>   */
> @@ -1063,6 +1103,8 @@ ENTRY(\sym)
>         subq $ORIG_RAX-R15, %rsp
>         CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
>
> +       STOP_LBR
> +
>         .if \paranoid
>         call save_paranoid
>         .else
> @@ -1094,6 +1136,8 @@ ENTRY(\sym)
>
>         call \do_sym
>
> +       START_LBR
> +
>         .if \shift_ist != -1
>         addq $EXCEPTION_STKSZ, INIT_TSS_IST(\shift_ist)
>         .endif
> --
> 1.7.9.5
>
> Thanks,
> Emmanuel.



-- 
Andy Lutomirski
AMA Capital Management, LLC
