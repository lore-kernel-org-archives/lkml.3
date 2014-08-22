Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbaHVAf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 20:35:27 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:51190 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863AbaHVAf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 20:35:26 -0400
Message-ID: <53F69045.7010301@linaro.org>
Date: Fri, 22 Aug 2014 09:35:17 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Deepak Saxena <dsaxena@linaro.org>,
        arndb@arndb.de,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linaro-kernel@lists.linaro.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 2/6] arm64: ptrace: allow tracer to skip a system call
References: <1408611405-8943-1-git-send-email-takahiro.akashi@linaro.org>	<1408611405-8943-3-git-send-email-takahiro.akashi@linaro.org> <CAGXu5jJCyqpXkdvNDCu+eMr0qnqwbqUUo4u+2p_7DvFMzfKoEw@mail.gmail.com>
In-Reply-To: <CAGXu5jJCyqpXkdvNDCu+eMr0qnqwbqUUo4u+2p_7DvFMzfKoEw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2014 02:08 AM, Kees Cook wrote:
> On Thu, Aug 21, 2014 at 3:56 AM, AKASHI Takahiro
> <takahiro.akashi@linaro.org> wrote:
>> If tracer specifies -1 as a syscall number, this traced system call should
>> be skipped with a value in x0 used as a return value.
>> This patch enables this semantics, but there is a restriction here:
>>
>>     when syscall(-1) is issued by user, tracer cannot skip this system call
>>     and modify a return value at syscall entry.
>>
>> In order to ease this flavor, we need to treat whatever value in x0 as
>> a return value, but this might result in a bogus value being returned,
>> especially when tracer doesn't do anything at this syscall.
>> So we always return ENOSYS instead, while we have another chance to change
>> a return value at syscall exit.
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
>>   arch/arm64/kernel/ptrace.c      |   20 ++++++++++++++++++++
>>   3 files changed, 32 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
>> index 501000f..a58cf62 100644
>> --- a/arch/arm64/include/asm/ptrace.h
>> +++ b/arch/arm64/include/asm/ptrace.h
>> @@ -65,6 +65,14 @@
>>   #define COMPAT_PT_TEXT_ADDR            0x10000
>>   #define COMPAT_PT_DATA_ADDR            0x10004
>>   #define COMPAT_PT_TEXT_END_ADDR                0x10008
>> +
>> +/*
>> + * used to skip a system call when tracer changes its number to -1
>> + * with ptrace(PTRACE_SET_SYSCALL)
>> + */
>> +#define RET_SKIP_SYSCALL       -1
>> +#define IS_SKIP_SYSCALL(no)    ((int)(no & 0xffffffff) == -1)
>> +
>>   #ifndef __ASSEMBLY__
>>
>>   /* sizeof(struct user) for AArch32 */
>> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
>> index f0b5e51..fdd6eae 100644
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
>>          mov     x0, sp
>>          bl      syscall_trace_enter
>> +       cmp     w0, #RET_SKIP_SYSCALL           // skip syscall?
>> +       b.eq    __sys_trace_return_skipped
>>          adr     lr, __sys_trace_return          // return address
>>          uxtw    scno, w0                        // syscall number (possibly new)
>>          mov     x1, sp                          // pointer to regs
>> @@ -685,6 +688,7 @@ __sys_trace:
>>
>>   __sys_trace_return:
>>          str     x0, [sp]                        // save returned x0
>> +__sys_trace_return_skipped:                    // x0 already in regs[0]
>>          mov     x0, sp
>>          bl      syscall_trace_exit
>>          b       ret_to_user
>> diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
>> index 8876049..c54dbcc 100644
>> --- a/arch/arm64/kernel/ptrace.c
>> +++ b/arch/arm64/kernel/ptrace.c
>> @@ -1121,9 +1121,29 @@ static void tracehook_report_syscall(struct pt_regs *regs,
>>
>>   asmlinkage int syscall_trace_enter(struct pt_regs *regs)
>>   {
>> +       unsigned int saved_syscallno = regs->syscallno;
>> +
>>          if (test_thread_flag(TIF_SYSCALL_TRACE))
>>                  tracehook_report_syscall(regs, PTRACE_SYSCALL_ENTER);
>>
>> +       if (IS_SKIP_SYSCALL(regs->syscallno)) {
>> +               /*
>> +                * RESTRICTION: we can't modify a return value of user
>> +                * issued syscall(-1) here. In order to ease this flavor,
>> +                * we need to treat whatever value in x0 as a return value,
>> +                * but this might result in a bogus value being returned.
>> +                */
>> +               /*
>> +                * NOTE: syscallno may also be set to -1 if fatal signal is
>> +                * detected in tracehook_report_syscall_entry(), but since
>> +                * a value set to x0 here is not used in this case, we may
>> +                * neglect the case.
>> +                */
>> +               if (!test_thread_flag(TIF_SYSCALL_TRACE) ||
>> +                               (IS_SKIP_SYSCALL(saved_syscallno)))
>> +                       regs->regs[0] = -ENOSYS;
>> +       }
>> +
>
> I don't have a runtime environment yet for arm64, so I can't test this
> directly myself, so I'm just trying to eyeball this. :)
>
> Once the seccomp logic is added here, I don't think using -2 as a
> special value will work. Doesn't this mean the Oops is possible by the
> user issuing a "-2" syscall? As in, if TIF_SYSCALL_WORK is set, and
> the user passed -2 as the syscall, audit will be called only on entry,
> and then skipped on exit?

Oops, you're absolutely right. I didn't think of this case.
syscall_trace_enter() should not return a syscallno directly, but always
return -1 if syscallno < 0. (except when secure_computing() returns with -1)
This also implies that tracehook_report_syscall() should also have a return value.

Will, is this fine with you?

-Takahiro AKASHI


> -Kees
>
>>          if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
>>                  trace_sys_enter(regs, regs->syscallno);
>>
>> --
>> 1.7.9.5
>>
>
>
>
