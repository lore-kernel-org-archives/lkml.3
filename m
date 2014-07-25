Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431AbaGYJht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 05:37:49 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:56889 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759853AbaGYJhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 05:37:47 -0400
Message-ID: <53D2255C.9050006@linaro.org>
Date: Fri, 25 Jul 2014 18:37:32 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Deepak Saxena <dsaxena@linaro.org>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>, linaro-kernel@lists.linaro.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 3/3] arm64: Add seccomp support
References: <1406020499-5537-1-git-send-email-takahiro.akashi@linaro.org> <1406020499-5537-4-git-send-email-takahiro.akashi@linaro.org> <53D082E9.8090303@amacapital.net> <53D09C4F.9010104@linaro.org> <CALCETrWTDS7VSyuR5wgGxpu-_YMWVUVmv9ht6t1tCSX=GA46cQ@mail.gmail.com>
In-Reply-To: <CALCETrWTDS7VSyuR5wgGxpu-_YMWVUVmv9ht6t1tCSX=GA46cQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2014 12:00 AM, Andy Lutomirski wrote:
> On Jul 23, 2014 10:40 PM, "AKASHI Takahiro" <takahiro.akashi@linaro.org> wrote:
>>
>> On 07/24/2014 12:52 PM, Andy Lutomirski wrote:
>>>
>>> On 07/22/2014 02:14 AM, AKASHI Takahiro wrote:
>>>>
>>>> secure_computing() should always be called first in syscall_trace_enter().
>>>>
>>>> If secure_computing() returns -1, we should stop further handling. Then
>>>> that system call may eventually fail with a specified return value (errno),
>>>> be trapped or the process itself be killed depending on loaded rules.
>>>> In these cases, syscall_trace_enter() also returns -1, that results in
>>>> skiping a normal syscall handling as well as syscall_trace_exit().
>>>>
>>>> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
>>>> ---
>>>>    arch/arm64/Kconfig               |   14 ++++++++++++++
>>>>    arch/arm64/include/asm/seccomp.h |   25 +++++++++++++++++++++++++
>>>>    arch/arm64/include/asm/unistd.h  |    3 +++
>>>>    arch/arm64/kernel/ptrace.c       |    5 +++++
>>>>    4 files changed, 47 insertions(+)
>>>>    create mode 100644 arch/arm64/include/asm/seccomp.h
>>>>
>>>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>>>> index 3a18571..eeac003 100644
>>>> --- a/arch/arm64/Kconfig
>>>> +++ b/arch/arm64/Kconfig
>>>> @@ -32,6 +32,7 @@ config ARM64
>>>>        select HAVE_ARCH_AUDITSYSCALL
>>>>        select HAVE_ARCH_JUMP_LABEL
>>>>        select HAVE_ARCH_KGDB
>>>> +    select HAVE_ARCH_SECCOMP_FILTER
>>>>        select HAVE_ARCH_TRACEHOOK
>>>>        select HAVE_C_RECORDMCOUNT
>>>>        select HAVE_DEBUG_BUGVERBOSE
>>>> @@ -259,6 +260,19 @@ config ARCH_HAS_CACHE_LINE_SIZE
>>>>
>>>>    source "mm/Kconfig"
>>>>
>>>> +config SECCOMP
>>>> +    bool "Enable seccomp to safely compute untrusted bytecode"
>>>> +    ---help---
>>>> +      This kernel feature is useful for number crunching applications
>>>> +      that may need to compute untrusted bytecode during their
>>>> +      execution. By using pipes or other transports made available to
>>>> +      the process as file descriptors supporting the read/write
>>>> +      syscalls, it's possible to isolate those applications in
>>>> +      their own address space using seccomp. Once seccomp is
>>>> +      enabled via prctl(PR_SET_SECCOMP), it cannot be disabled
>>>> +      and the task is only allowed to execute a few safe syscalls
>>>> +      defined by each seccomp mode.
>>>> +
>>>>    config XEN_DOM0
>>>>        def_bool y
>>>>        depends on XEN
>>>> diff --git a/arch/arm64/include/asm/seccomp.h b/arch/arm64/include/asm/seccomp.h
>>>> new file mode 100644
>>>> index 0000000..c76fac9
>>>> --- /dev/null
>>>> +++ b/arch/arm64/include/asm/seccomp.h
>>>> @@ -0,0 +1,25 @@
>>>> +/*
>>>> + * arch/arm64/include/asm/seccomp.h
>>>> + *
>>>> + * Copyright (C) 2014 Linaro Limited
>>>> + * Author: AKASHI Takahiro <takahiro.akashi@linaro.org>
>>>> + *
>>>> + * This program is free software; you can redistribute it and/or modify
>>>> + * it under the terms of the GNU General Public License version 2 as
>>>> + * published by the Free Software Foundation.
>>>> + */
>>>> +#ifndef _ASM_SECCOMP_H
>>>> +#define _ASM_SECCOMP_H
>>>> +
>>>> +#include <asm/unistd.h>
>>>> +
>>>> +#ifdef CONFIG_COMPAT
>>>> +#define __NR_seccomp_read_32        __NR_compat_read
>>>> +#define __NR_seccomp_write_32        __NR_compat_write
>>>> +#define __NR_seccomp_exit_32        __NR_compat_exit
>>>> +#define __NR_seccomp_sigreturn_32    __NR_compat_rt_sigreturn
>>>> +#endif /* CONFIG_COMPAT */
>>>> +
>>>> +#include <asm-generic/seccomp.h>
>>>> +
>>>> +#endif /* _ASM_SECCOMP_H */
>>>> diff --git a/arch/arm64/include/asm/unistd.h b/arch/arm64/include/asm/unistd.h
>>>> index c980ab7..729c155 100644
>>>> --- a/arch/arm64/include/asm/unistd.h
>>>> +++ b/arch/arm64/include/asm/unistd.h
>>>> @@ -31,6 +31,9 @@
>>>>     * Compat syscall numbers used by the AArch64 kernel.
>>>>     */
>>>>    #define __NR_compat_restart_syscall    0
>>>> +#define __NR_compat_exit        1
>>>> +#define __NR_compat_read        3
>>>> +#define __NR_compat_write        4
>>>>    #define __NR_compat_sigreturn        119
>>>>    #define __NR_compat_rt_sigreturn    173
>>>>
>>>> diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
>>>> index 100d7d1..e477f6f 100644
>>>> --- a/arch/arm64/kernel/ptrace.c
>>>> +++ b/arch/arm64/kernel/ptrace.c
>>>> @@ -28,6 +28,7 @@
>>>>    #include <linux/smp.h>
>>>>    #include <linux/ptrace.h>
>>>>    #include <linux/user.h>
>>>> +#include <linux/seccomp.h>
>>>>    #include <linux/security.h>
>>>>    #include <linux/init.h>
>>>>    #include <linux/signal.h>
>>>> @@ -1115,6 +1116,10 @@ asmlinkage int syscall_trace_enter(struct pt_regs *regs)
>>>>        saved_x0 = regs->regs[0];
>>>>        saved_x8 = regs->regs[8];
>>>>
>>>> +    if (secure_computing(regs->syscallno) == -1)
>>>> +        /* seccomp failures shouldn't expose any additional code. */
>>>> +        return -1;
>>>> +
>>>
>>>
>>> This will conflict with the fastpath stuff in Kees' tree.  (Actually, it's likely to apply cleanly, but fail to
>>> compile.)  The fix is trivial, but, given that the fastpath stuff is new, can you take a look and see if arm64 can use
>>> it effectively?
>>
>>
>> I will look into the code later.
>>
>>
>>> I suspect that the performance considerations are rather different on arm64 as compared to x86 (I really hope that x86
>>> is the only architecture with the absurd sysret vs. iret distinction), but at least the seccomp_data stuff ought to help
>>> anywhere.  (It looks like there's a distinct fast path, too, so the two-phase thing might also be a fairly large win if
>>> it's supportable.)
>>>
>>> See:
>>>
>>> https://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/log/?h=seccomp/fastpath
>>>
>>> Also, I'll ask the usual question?  What are all of the factors other than nr and args that affect syscall execution?
>>> What are the audit arch values?  Do they match correctly?
>>
>>
>> As far as I know,
>>
>>
>>> For example, it looks like, if arm64 adds OABI support, you'll have a problem.  (Note that arm currently disables audit
>>> and seccomp if OABI is enabled for exactly this reason.)
>>
>>
>> I don't think that arm64 will add OABI support in the future.
>>
>>
>>> Do any syscall implementations care whether the user code is LE or BE? Are the arguments encoded the same way?
>>
>>
>> when I implemented audit for arm64, the assumptions were
>> * If userspace is LE, then the kernel is also LE and if BE, then the kernel is BE.
>> * the syscall numbers and how arguments are encoded are the same btw BE and LE.
>> So syscall_get_arch() always return the same value.
>
> If arm64 ever adds support for mixed-endian userspace, this could
> become awkward.  Hmm.
>
> IMO this matters more for seccomp than for audit.  The audit code
> doesn't seem to do anything terribly interesting w/ the arch field, at
> least in terms of interpretation of syscall args.

I digged into libseccomp source files, and found that there is some
endianness-dependent code. Especially, "classic" BPF interpreter handles
only 32-bit accumulator/registers, and so special care should be taken
when a filter wants to check a 64-bit argument of system call.
If we don't support mixed-endianness, this issue can be fixed by statically
compiling the library with BYTE_ORDER macro. But otherwise
syscall_get_arch() should return a dedicated value for BE kernel and this change
will also have some impact on audit commands.

>>
>>
>>> An arm-specific question: will there be any confusion as a result of the fact that compat syscalls seems to stick nr in
>>> w7, but arm64 puts them somewhere else?
>>
>>
>> I don't know, but syscall_get_arch() returns ARCH_ARM for 32-bit tasks.
>
> Will 32-bit tracers be compatible between arm and arm64 kernels?  That
> is, if a 32-bit program installs a seccomp filter with a trace action
> and traces a 32-bit process, will everything work correctly?  (Kees'
> and Will's tests should work for this, I think.)

I found a bug in my current patch (v5). When 32-bit tracer skips a system call,
we should not update syscallno from x8 since syscallno is re-written directly
via ptrace(PTRACE_SET_SYSCALL).
I'm sure that my next version should work with 32/64-bit tracers on 64-bit kernel.

Thanks,
-Takahiro AKASHI

> --Andy
>
