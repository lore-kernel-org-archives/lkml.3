Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932647AbaGWPNa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:13:30 -0400
Received: from mail-oi0-f47.google.com ([209.85.218.47]:47316 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932596AbaGWPN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:13:26 -0400
MIME-Version: 1.0
In-Reply-To: <53CF5E53.3060409@linaro.org>
References: <1406020499-5537-1-git-send-email-takahiro.akashi@linaro.org>
	<1406020499-5537-2-git-send-email-takahiro.akashi@linaro.org>
	<CAGXu5jKkJUGn_MpEEr8U=n_A+iW9s8vSX1WoVNzRJMVyGQRjpA@mail.gmail.com>
	<53CF5E53.3060409@linaro.org>
Date: Wed, 23 Jul 2014 08:13:25 -0700
X-Google-Sender-Auth: 6ya6AI74KJNLT0hMIoAqflb6rqY
Message-ID: <CAGXu5jKhn+a9mpNkkyUmdjtXpkhjQtwDkFh+BYU76xDttDoszA@mail.gmail.com>
Subject: Re: [PATCH v5 1/3] arm64: ptrace: reload a syscall number after
 ptrace operations
From: Kees Cook <keescook@chromium.org>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Will Drewry <wad@chromium.org>, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, dsaxena@linaro.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linaro-kernel@lists.linaro.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 12:03 AM, AKASHI Takahiro
<takahiro.akashi@linaro.org> wrote:
> On 07/23/2014 05:15 AM, Kees Cook wrote:
>>
>> On Tue, Jul 22, 2014 at 2:14 AM, AKASHI Takahiro
>> <takahiro.akashi@linaro.org> wrote:
>>>
>>> Arm64 holds a syscall number in w8(x8) register. Ptrace tracer may change
>>> its value either to:
>>>    * any valid syscall number to alter a system call, or
>>>    * -1 to skip a system call
>>>
>>> This patch implements this behavior by reloading that value into
>>> syscallno
>>> in struct pt_regs after tracehook_report_syscall_entry() or
>>> secure_computing(). In case of '-1', a return value of system call can
>>> also
>>> be changed by the tracer setting the value to x0 register, and so
>>> sys_ni_nosyscall() should not be called.
>>>
>>> See also:
>>>      42309ab4, ARM: 8087/1: ptrace: reload syscall number after
>>>                secure_computing() check
>>>
>>> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
>>> ---
>>>   arch/arm64/kernel/entry.S  |    2 ++
>>>   arch/arm64/kernel/ptrace.c |   13 +++++++++++++
>>>   2 files changed, 15 insertions(+)
>>>
>>> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
>>> index 5141e79..de8bdbc 100644
>>> --- a/arch/arm64/kernel/entry.S
>>> +++ b/arch/arm64/kernel/entry.S
>>> @@ -628,6 +628,8 @@ ENDPROC(el0_svc)
>>>   __sys_trace:
>>>          mov     x0, sp
>>>          bl      syscall_trace_enter
>>> +       cmp     w0, #-1                         // skip syscall?
>>> +       b.eq    ret_to_user
>>>          adr     lr, __sys_trace_return          // return address
>>>          uxtw    scno, w0                        // syscall number
>>> (possibly new)
>>>          mov     x1, sp                          // pointer to regs
>>> diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
>>> index 70526cf..100d7d1 100644
>>> --- a/arch/arm64/kernel/ptrace.c
>>> +++ b/arch/arm64/kernel/ptrace.c
>>> @@ -21,6 +21,7 @@
>>>
>>>   #include <linux/audit.h>
>>>   #include <linux/compat.h>
>>> +#include <linux/errno.h>
>>>   #include <linux/kernel.h>
>>>   #include <linux/sched.h>
>>>   #include <linux/mm.h>
>>> @@ -1109,9 +1110,21 @@ static void tracehook_report_syscall(struct
>>> pt_regs *regs,
>>>
>>>   asmlinkage int syscall_trace_enter(struct pt_regs *regs)
>>>   {
>>> +       unsigned long saved_x0, saved_x8;
>>> +
>>> +       saved_x0 = regs->regs[0];
>>> +       saved_x8 = regs->regs[8];
>>> +
>>>          if (test_thread_flag(TIF_SYSCALL_TRACE))
>>>                  tracehook_report_syscall(regs, PTRACE_SYSCALL_ENTER);
>>>
>>> +       regs->syscallno = regs->regs[8];
>>> +       if ((long)regs->syscallno == ~0UL) { /* skip this syscall */
>>> +               regs->regs[8] = saved_x8;
>>> +               if (regs->regs[0] == saved_x0) /* not changed by user */
>>> +                       regs->regs[0] = -ENOSYS;
>>
>>
>> I'm not sure this is right compared to other architectures. Generally
>> when a tracer performs a syscall skip, it's up to them to also adjust
>> the return value. They may want to be faking a syscall, and what if
>> the value they want to return happens to be what x0 was going into the
>> tracer? It would have no way to avoid this -ENOSYS case. I think
>> things are fine without this test.
>
>
> Yeah, I know this issue, but was not sure that setting a return value
> is mandatory. (x86 seems to return -ENOSYS by default if not explicitly
> specified.)
> Is "fake a system call" a more appropriate word than "skip"?

I think this is just a matter of semantics and perspective. From the
kernel's perspective, it's always a "skip" since the syscall is never
actually executed. But from the perspective of userspace, it's really
up to the tracer to decide how it should be seen: the tracer could
return -ENOSYS, or a fake return value, etc. But generally, I think
"skip" is the most accurate term for this.

-Kees

-- 
Kees Cook
Chrome OS Security
