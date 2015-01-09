Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350AbbAIQJU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 11:09:20 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:49974 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232AbbAIQJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 11:09:18 -0500
MIME-Version: 1.0
In-Reply-To: <20150109155334.GE13637@pd.tnic>
References: <cover.1415403984.git.luto@amacapital.net> <1072a16a8d4ad1b11b8062f76e3236b9771b0fb6.1415403984.git.luto@amacapital.net>
 <20150109155334.GE13637@pd.tnic>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 9 Jan 2015 08:08:55 -0800
Message-ID: <CALCETrW8oH65mHsEj+MaWnZYYCR3m1VFFF4J5PYidNqbQHV9Rg@mail.gmail.com>
Subject: Re: [PATCH 3/3] x86_64,entry: Remove the syscall exit audit and
 schedule optimizations
To: Borislav Petkov <bp@alien8.de>
Cc: X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 9, 2015 at 7:53 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Fri, Nov 07, 2014 at 03:58:19PM -0800, Andy Lutomirski wrote:
>> We used to optimize rescheduling and audit on syscall exit.  Now that
>> the full slow path is reasonably fast, remove these optimizations.
>>
>> This adds something like 10ns to the previously optimized paths on my
>> computer, presumably due mostly to SAVE_REST / RESTORE_REST.
>>
>> I think that we should eventually replace both the syscall and
>> non-paranoid interrupt exit slow paths with a pair of C functions
>> along the lines of the syscall entry hooks.
>>
>> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>> ---
>>  arch/x86/kernel/entry_64.S | 52 +++++-----------------------------------------
>>  1 file changed, 5 insertions(+), 47 deletions(-)
>>
>> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
>> index a5afdf0f7fa4..222dc5c45ac3 100644
>> --- a/arch/x86/kernel/entry_64.S
>> +++ b/arch/x86/kernel/entry_64.S
>> @@ -427,15 +427,12 @@ system_call_fastpath:
>>   * Has incomplete stack frame and undefined top of stack.
>>   */
>>  ret_from_sys_call:
>> -     movl $_TIF_ALLWORK_MASK,%edi
>> -     /* edi: flagmask */
>> -sysret_check:
>> +     testl $_TIF_ALLWORK_MASK,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
>> +     jnz int_ret_from_sys_call_fixup /* Go the the slow path */
>> +
>>       LOCKDEP_SYS_EXIT
>>       DISABLE_INTERRUPTS(CLBR_NONE)
>>       TRACE_IRQS_OFF
>> -     movl TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET),%edx
>> -     andl %edi,%edx
>> -     jnz  sysret_careful
>>       CFI_REMEMBER_STATE
>>       /*
>>        * sysretq will re-enable interrupts:
>> @@ -449,49 +446,10 @@ sysret_check:
>>       USERGS_SYSRET64
>>
>>       CFI_RESTORE_STATE
>> -     /* Handle reschedules */
>> -     /* edx: work, edi: workmask */
>> -sysret_careful:
>> -     bt $TIF_NEED_RESCHED,%edx
>> -     jnc sysret_signal
>> -     TRACE_IRQS_ON
>> -     ENABLE_INTERRUPTS(CLBR_NONE)
>> -     pushq_cfi %rdi
>> -     SCHEDULE_USER
>> -     popq_cfi %rdi
>> -     jmp sysret_check
>>
>> -     /* Handle a signal */
>> -sysret_signal:
>> -     TRACE_IRQS_ON
>> -     ENABLE_INTERRUPTS(CLBR_NONE)
>> -#ifdef CONFIG_AUDITSYSCALL
>> -     bt $TIF_SYSCALL_AUDIT,%edx
>> -     jc sysret_audit
>> -#endif
>> -     /*
>> -      * We have a signal, or exit tracing or single-step.
>> -      * These all wind up with the iret return path anyway,
>> -      * so just join that path right now.
>> -      */
>> +int_ret_from_sys_call_fixup:
>>       FIXUP_TOP_OF_STACK %r11, -ARGOFFSET
>> -     jmp int_check_syscall_exit_work
>> -
>> -#ifdef CONFIG_AUDITSYSCALL
>> -     /*
>> -      * Return fast path for syscall audit.  Call __audit_syscall_exit()
>> -      * directly and then jump back to the fast path with TIF_SYSCALL_AUDIT
>> -      * masked off.
>> -      */
>> -sysret_audit:
>> -     movq RAX-ARGOFFSET(%rsp),%rsi   /* second arg, syscall return value */
>> -     cmpq $-MAX_ERRNO,%rsi   /* is it < -MAX_ERRNO? */
>> -     setbe %al               /* 1 if so, 0 if not */
>> -     movzbl %al,%edi         /* zero-extend that into %edi */
>> -     call __audit_syscall_exit
>> -     movl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT),%edi
>> -     jmp sysret_check
>> -#endif       /* CONFIG_AUDITSYSCALL */
>> +     jmp int_ret_from_sys_call
>
> Ok, dumb question: what is replacing that audit functionality now?
> Or are we remaining with the single path down syscall_trace_leave()?
> AFAICT, the intention is to direct everything to int_ret_from_sys_call
> after the syscall has been done so that paths can get simplified. Which
> is a good thing, AFAICT.

Exactly.  int_ret_from_sys_call calls into the audit code in
syscall_trace_leave.  IIRC the current code sometimes calls the audit
exit hook twice, which seems like a bug to me.

--Andy

>
> Acked-by: Borislav Petkov <bp@suse.de>
>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --



-- 
Andy Lutomirski
AMA Capital Management, LLC
