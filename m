Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538AbaJFIFO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 04:05:14 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:57613 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaJFIFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 04:05:08 -0400
Message-ID: <54324D29.8050804@linaro.org>
Date: Mon, 06 Oct 2014 17:04:57 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Kees Cook <keescook@chromium.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Deepak Saxena <dsaxena@linaro.org>, "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 2/6] arm64: ptrace: allow tracer to skip a system call
References: <1408611405-8943-1-git-send-email-takahiro.akashi@linaro.org> <1408611405-8943-3-git-send-email-takahiro.akashi@linaro.org> <CAGXu5jJCyqpXkdvNDCu+eMr0qnqwbqUUo4u+2p_7DvFMzfKoEw@mail.gmail.com> <53F69045.7010301@linaro.org> <20140826175128.GD23445@arm.com> <542BE095.3010107@linaro.org> <20141003152328.GB32451@arm.com>
In-Reply-To: <20141003152328.GB32451@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2014 12:23 AM, Will Deacon wrote:
> On Wed, Oct 01, 2014 at 12:08:05PM +0100, AKASHI Takahiro wrote:
>> Will,
>>
>> When I was looking into syscall_trace_exit() more closely, I found
>> another (big) problem.
>> There are two system calls, execve() and rt_sigreturn(), which change
>> 'syscallno' in pt_regs to -1 in start_thread() and restore_sigframe(),
>> respectively.

I need to correct my mis-understandings here:

>> Since syscallno is not valid anymore in syscall_trace_exit() for these
>> system calls, we cannot create a correct syscall exit record for tracepoint
>> in trace_sys_exit() (=> ftrace_syscall_exit())

This is true, but since rt_sigreturn() doesn't have a syscall tracepoint (and so
there is no entry under /sys/kernel/tracing/events/syscalls/), it cannot be
traced anyway.

>> and for audit in audit_syscall_exit().

not true. Since a syscall number is saved as 'major' in a per-thread audit context
at audit_syscall_exit(), we will see a correct audit log for both system calls.

>> This does not happen on arm because syscall numbers are kept in
>> thread_info on arm.
>>
>> How can we deal with this issue?
>
> How is this handled on other architectures? x86, for example, seems to zero
> orig_ax when restoring the sigcontext, but leaves it alone in start_thread.

> What is the impact of this problem? AFAICT, we just miss some exits, right
> (as opposed to an OOPs or the like)?

So the impacts here are:
1) We just miss a syscall exit for execve tracepoint (syscalls:sys_exit_execve).
    (no fatal errors like kernel panic)
    (FYI, on x86, there is no tracepoint entry for execve nor sigreturn.)

2) From the viewpoint of my seccomp patch, we cannot skip some syscall exit tracing
    for invalid system calls by adding a check for syscallno in the following way:
    (I'm not quite sure this might cause a threat with DDoS attach as Russell suggested.)

    syscall_trace_exit(struct pt_regs *regs) {
       if (regs->syscallno < NR_syscalls) { /* Adding this check */
          audit_syscall_exit(regs);
          if (test_thread_flags(TIF_SYSCALL_TRACEPOINT))
             trace_sys_exit(regs, regs_return_value(regs));
       }
       ...
    }

    As you can imagine, any system call after execve() will hit BUG_ON()
    in audit_syscall_exit() since audit_syscall_exit() is not called for execve().

Thanks,
-Takahiro AKASHI

> Will
>
