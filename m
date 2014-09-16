Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176AbaIPARw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 20:17:52 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:39027 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525AbaIPARu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 20:17:50 -0400
Message-ID: <541781AB.1050903@linaro.org>
Date: Mon, 15 Sep 2014 17:17:47 -0700
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "eparis@redhat.com" <eparis@redhat.com>,
        "rgb@redhat.com" <rgb@redhat.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-audit@redhat.com" <linux-audit@redhat.com>
Subject: Re: [PATCH v2] arm: prevent BUG_ON in audit_syscall_entry()
References: <1410238199-956-1-git-send-email-takahiro.akashi@linaro.org> <20140911163736.GV6158@arm.com>
In-Reply-To: <20140911163736.GV6158@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will,

Sorry for not responding quickly.

On 09/11/2014 09:37 AM, Will Deacon wrote:
> Hi Akashi,
>
> On Tue, Sep 09, 2014 at 05:49:59AM +0100, AKASHI Takahiro wrote:
>> BUG_ON() in audit_syscall_entry() will be hit if user issues syscall(-1)
>> while syscall auditing is enabled (that is, by starting auditd).
>
> [...]
>
>> diff --git a/arch/arm/include/asm/traps.h b/arch/arm/include/asm/traps.h
>> index f555bb3..de01145 100644
>> --- a/arch/arm/include/asm/traps.h
>> +++ b/arch/arm/include/asm/traps.h
>> @@ -49,6 +49,7 @@ static inline int in_exception_text(unsigned long ptr)
>>   extern void __init early_trap_init(void *);
>>   extern void dump_backtrace_entry(unsigned long where, unsigned long from, unsigned long frame);
>>   extern void ptrace_break(struct task_struct *tsk, struct pt_regs *regs);
>> +extern int arm_syscall(int no, struct pt_regs *regs);
>>
>>   extern void *vectors_page;
>>
>> diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
>> index e52fe5a..28d3931 100644
>> --- a/arch/arm/kernel/entry-common.S
>> +++ b/arch/arm/kernel/entry-common.S
>> @@ -426,7 +426,6 @@ ENTRY(vector_swi)
>>   local_restart:
>>   	ldr	r10, [tsk, #TI_FLAGS]		@ check for syscall tracing
>>   	stmdb	sp!, {r4, r5}			@ push fifth and sixth args
>> -
>
> You don't need this cosmetic change.

Typo. I will fix it.

>>   	tst	r10, #_TIF_SYSCALL_WORK		@ are we tracing syscalls?
>>   	bne	__sys_trace
>>
>> @@ -476,10 +475,11 @@ __sys_trace:
>>   	cmp	scno, #-1			@ skip the syscall?
>>   	bne	2b
>>   	add	sp, sp, #S_OFF			@ restore stack
>> -	b	ret_slow_syscall
>> +	b	__sys_trace_return_skipped
>
> Can't you just remove the add as well, them fall-through here?

I'm afraid that we can't remove this branch because we don't want to override
a value of r0 in regs which a tracer may have already changed while skipping
a syscall.

>>
>>   __sys_trace_return:
>>   	str	r0, [sp, #S_R0 + S_OFF]!	@ save returned r0
>> +__sys_trace_return_skipped:
>>   	mov	r0, sp
>>   	bl	syscall_trace_exit
>>   	b	ret_slow_syscall
>> diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
>> index 0c27ed6..68b42cd 100644
>> --- a/arch/arm/kernel/ptrace.c
>> +++ b/arch/arm/kernel/ptrace.c
>> @@ -930,7 +930,9 @@ static void tracehook_report_syscall(struct pt_regs *regs,
>>
>>   asmlinkage int syscall_trace_enter(struct pt_regs *regs, int scno)
>>   {
>> -	current_thread_info()->syscall = scno;
>> +	int orig_scno;
>> +
>> +	current_thread_info()->syscall = orig_scno = scno;
>>
>>   	/* Do the secure computing check first; failures should be fast. */
>>   	if (secure_computing(scno) == -1)
>> @@ -941,31 +943,40 @@ asmlinkage int syscall_trace_enter(struct pt_regs *regs, int scno)
>>
>>   	scno = current_thread_info()->syscall;
>>
>> -	if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
>> -		trace_sys_enter(regs, scno);
>> +	if (scno >= 0 && scno < NR_syscalls) {
>
> Is this supposed to work for OABI? If so, better use __NR_SYSCALL_BASE.

Good point. I'm not quite sure how it works for OABI, but looking into entry-comon.S,
there is some code:
 > #if defined(CONFIG_OABI_COMPAT)
 >         bics    r10, r10, #0xff000000
 >         eorne   scno, r10, #__NR_OABI_SYSCALL_BASE
 >         ldrne   tbl, =sys_oabi_call_table
 > #elif !defined(CONFIG_AEABI)
 >         bic     scno, scno, #0xff000000         @ mask off SWI op-code
 >         eor     scno, scno, #__NR_SYSCALL_BASE  @ check OS number
 > #endif
 >
 > local_restart:

It seems to me that scno, actually r7 in regs, is already offset.

>> +		if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
>> +			trace_sys_enter(regs, scno);
>> +
>> +		audit_syscall_entry(AUDIT_ARCH_ARM, scno,
>> +				    regs->ARM_r0, regs->ARM_r1,
>> +				    regs->ARM_r2, regs->ARM_r3);
>> +	}
>>
>> -	audit_syscall_entry(AUDIT_ARCH_ARM, scno, regs->ARM_r0, regs->ARM_r1,
>> -			    regs->ARM_r2, regs->ARM_r3);
>> +	/* user-issued syscall of -1 */
>> +	if (scno == -1 && orig_scno == -1)
>
> Make this an else if, for clarity?

Sure. I will fix it.

>> +		arm_syscall(scno, regs);
>
> Doesn't this always result in bad_syscall being called, which sends a SIGILL
> to the task? Shouldn't we simply return -ENOSYS instead? You could do that
> in the assembly code.

I meant so (that is, resulting in bad_syscall).
As I mentioned earlier, a task calling syscall(-1, or whatever native value) is always
signaled on arm. Meanwhile, whether it is intended or not, this behavior is not simulated
in the current arm64 compat syscalls.

>>   	return scno;
>>   }
>>
>>   asmlinkage void syscall_trace_exit(struct pt_regs *regs)
>>   {
>> -	/*
>> -	 * Audit the syscall before anything else, as a debugger may
>> -	 * come in and change the current registers.
>> -	 */
>> -	audit_syscall_exit(regs);
>> +	if (current_thread_info()->syscall < NR_syscalls) {
>
> Again, not going to work for OABI.

The same comment above.

Thanks,
-Takahiro AKASHI


> Will
>
