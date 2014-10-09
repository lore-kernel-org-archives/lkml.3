Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751103AbaJIE3w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 00:29:52 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:38080 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbaJIE3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 00:29:46 -0400
Message-ID: <54360F2D.3090602@linaro.org>
Date: Thu, 09 Oct 2014 13:29:33 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "keescook@chromium.org" <keescook@chromium.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 2/6] arm64: ptrace: allow tracer to skip a system call
References: <1412243176-16192-1-git-send-email-takahiro.akashi@linaro.org> <1412243176-16192-3-git-send-email-takahiro.akashi@linaro.org> <20141008142328.GR26140@arm.com>
In-Reply-To: <20141008142328.GR26140@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2014 11:23 PM, Will Deacon wrote:
> On Thu, Oct 02, 2014 at 10:46:12AM +0100, AKASHI Takahiro wrote:
>> If tracer specifies -1 as a syscall number, this traced system call should
>> be skipped with a value in x0 used as a return value.
>> This patch implements this semantics, but there is one restriction here:
>>
>>     when syscall(-1) is issued by user, tracer cannot skip this system call
>>     and modify a return value at syscall entry.
>>
>> In order to ease this flavor, we need to take whatever value x0 has as
>> a return value, but this might result in a bogus value being returned,
>> especially when tracer doesn't do anything against this syscall.
>> So we always return ENOSYS instead, while we still have another chance to
>> change a return value at syscall exit.
>>
>> Please also note:
>> * syscall entry tracing and syscall exit tracing (ftrace tracepoint and
>>    audit) are always executed, if enabled, even when skipping a system call
>>    (that is, -1).
>>    In this way, we can avoid a potential bug where audit_syscall_entry()
>>    might be called without audit_syscall_exit() at the previous system call
>>    being called, that would cause OOPs in audit_syscall_entry().
>>
>> * syscallno may also be set to -1 if a fatal signal (SIGKILL) is detected
>>    in tracehook_report_syscall_entry(), but since a value set to x0 (ENOSYS)
>>    is not used in this case, we may neglect the case.
>>
>> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
>> ---
>>   arch/arm64/include/asm/ptrace.h |    8 ++++++++
>>   arch/arm64/kernel/entry.S       |    4 ++++
>>   arch/arm64/kernel/ptrace.c      |   23 ++++++++++++++++++++++-
>>   3 files changed, 34 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
>> index 41ed9e1..736ebc3 100644
>> --- a/arch/arm64/include/asm/ptrace.h
>> +++ b/arch/arm64/include/asm/ptrace.h
>> @@ -65,6 +65,14 @@
>>   #define COMPAT_PT_TEXT_ADDR		0x10000
>>   #define COMPAT_PT_DATA_ADDR		0x10004
>>   #define COMPAT_PT_TEXT_END_ADDR		0x10008
>> +
>> +/*
>> + * System call will be skipped if a syscall number is changed to -1
>> + * with ptrace(PTRACE_SET_SYSCALL).
>> + * Upper 32-bit should be ignored for safe check.
>> + */
>> +#define IS_SKIP_SYSCALL(no)	((int)(no & 0xffffffff) == -1)
>
> I don't think this macro is very useful, especially considering that we
> already use ~0UL explicitly in other places. Just move the comment into
> syscall_trace_enter and be done with it. I also don't think you need the
> mask (the cast is enough).

I remember it was necessary for compat PTRACE_SET_SYSCALL, but
will double-check it anyway.

>> +
>>   #ifndef __ASSEMBLY__
>>
>>   /* sizeof(struct user) for AArch32 */
>> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
>> index f0b5e51..b53a1c5 100644
>> --- a/arch/arm64/kernel/entry.S
>> +++ b/arch/arm64/kernel/entry.S
>> @@ -25,6 +25,7 @@
>>   #include <asm/asm-offsets.h>
>>   #include <asm/errno.h>
>>   #include <asm/esr.h>
>> +#include <asm/ptrace.h>
>>   #include <asm/thread_info.h>
>>   #include <asm/unistd.h>
>>
>> @@ -671,6 +672,8 @@ ENDPROC(el0_svc)
>>   __sys_trace:
>>   	mov	x0, sp
>>   	bl	syscall_trace_enter
>> +	cmp	w0, #-1				// skip the syscall?
>> +	b.eq	__sys_trace_return_skipped
>>   	adr	lr, __sys_trace_return		// return address
>>   	uxtw	scno, w0			// syscall number (possibly new)
>>   	mov	x1, sp				// pointer to regs
>> @@ -685,6 +688,7 @@ __sys_trace:
>>
>>   __sys_trace_return:
>>   	str	x0, [sp]			// save returned x0
>> +__sys_trace_return_skipped:
>>   	mov	x0, sp
>>   	bl	syscall_trace_exit
>>   	b	ret_to_user
>> diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
>> index 2842f9f..6b11c6a 100644
>> --- a/arch/arm64/kernel/ptrace.c
>> +++ b/arch/arm64/kernel/ptrace.c
>> @@ -1126,6 +1126,8 @@ static void tracehook_report_syscall(struct pt_regs *regs,
>>
>>   asmlinkage int syscall_trace_enter(struct pt_regs *regs)
>>   {
>> +	unsigned int orig_syscallno = regs->syscallno;
>> +
>>   	if (test_thread_flag(TIF_SYSCALL_TRACE))
>>   		tracehook_report_syscall(regs, PTRACE_SYSCALL_ENTER);
>>
>> @@ -1133,7 +1135,26 @@ asmlinkage int syscall_trace_enter(struct pt_regs *regs)
>>   		trace_sys_enter(regs, regs->syscallno);
>>
>>   	audit_syscall_entry(syscall_get_arch(), regs->syscallno,
>> -		regs->orig_x0, regs->regs[1], regs->regs[2], regs->regs[3]);
>> +			regs->orig_x0, regs->regs[1],
>> +			regs->regs[2], regs->regs[3]);
>> +
>> +	if (IS_SKIP_SYSCALL(regs->syscallno) &&
>> +			IS_SKIP_SYSCALL(orig_syscallno)) {
>> +		/*
>> +		 * For compatibility, we handles user-issued syscall(-1).
>
> Compatibility with what? arch/arm/?

with the case where a process is *not* traced (including audit).

>> +		 *
>> +		 * RESTRICTION: we can't modify a return value here in this
>> +		 * specific case. In order to ease this flavor, we have to
>> +		 * take whatever value x0 has as a return value, but this
>> +		 * might result in a bogus value being returned.
>
> This comment isn't helping me. Are we returning a bogus value or not? If so,
> why is that acceptable?

I mean that syscall(-1) always returns -1 with ENOSYS.

Let's think about the case that we didn't have this 'if' statement.
If a debugger catches an user-issued syscall(-1), but let it go without
doing anything (especially changing a value in x0), this syscall will
return an original value in x0, which is the first argument of syscall(-1).
I mentioned this as "bogus."
In this way, a traced process would see a different behavior of syscall(-1).
(On arm, this doesn't happen because syscall(-1) is supposed to raise SIGILL.)
(On x86, this doesn't happen, probably, because syscall arguments are passed
via a stack and we can set a default return value in a register to ENOSYS.)

To avoid this incompatibility, there is no way but to always return -1 in this path
because the kernel doesn't know whether a debugger let x0 unchanged on purpose or not.
This is also the reason why I wanted to have a dedicated ptrace command to set
a return value in skipping a system call.

If we don't care about such erroneous (and exceptional) behaviors, we don't
need this 'if' statement.

Did I make it clear?

>> +		 * NOTE: syscallno may also be set to -1 if fatal signal
>> +		 * is detected in tracehook_report_syscall(ENTRY),
>> +		 * but since a value set to x0 here is not used in this
>> +		 * case, we may neglect the case.
>> +		 */
>
> I think can you remove thise NOTE, it's not very informative.

Okey.
Also remove descriptions from a commit message.

-Takahiro AKASHI

> Will
>
