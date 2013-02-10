Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab3BJKcx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 05:32:53 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:51860 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab3BJKcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 05:32:51 -0500
MIME-Version: 1.0
In-Reply-To: <1359714465-6297-2-git-send-email-zhong@linux.vnet.ibm.com>
References: <1359714465-6297-1-git-send-email-zhong@linux.vnet.ibm.com>
	<1359714465-6297-2-git-send-email-zhong@linux.vnet.ibm.com>
Date: Sun, 10 Feb 2013 11:32:49 +0100
Message-ID: <CAFTL4hzpwLO--SRUzpJz=zKbupSEYirNcO-KM=ShOMwjoJ0LvA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/5] powerpc: Syscall hooks for context tracking subsystem
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        paulmck@linux.vnet.ibm.com, benh@kernel.crashing.org, paulus@samba.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/1 Li Zhong <zhong@linux.vnet.ibm.com>:
> This is the syscall slow path hooks for context tracking subsystem,
> corresponding to
> [PATCH] x86: Syscall hooks for userspace RCU extended QS
>   commit bf5a3c13b939813d28ce26c01425054c740d6731
>
> TIF_MEMDIE is moved to the second 16-bits (with value 17), as it seems there
> is no asm code using it. TIF_NOHZ is added to _TIF_SYCALL_T_OR_A, so it is
> better for it to be in the same 16 bits with others in the group, so in the
> asm code, andi. with this group could work.
>
> Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>

Looks good. Thanks.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

> ---
>  arch/powerpc/include/asm/thread_info.h |    7 +++++--
>  arch/powerpc/kernel/ptrace.c           |    5 +++++
>  2 files changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/arch/powerpc/include/asm/thread_info.h b/arch/powerpc/include/asm/thread_info.h
> index 406b7b9..414a261 100644
> --- a/arch/powerpc/include/asm/thread_info.h
> +++ b/arch/powerpc/include/asm/thread_info.h
> @@ -97,7 +97,7 @@ static inline struct thread_info *current_thread_info(void)
>  #define TIF_PERFMON_CTXSW      6       /* perfmon needs ctxsw calls */
>  #define TIF_SYSCALL_AUDIT      7       /* syscall auditing active */
>  #define TIF_SINGLESTEP         8       /* singlestepping active */
> -#define TIF_MEMDIE             9       /* is terminating due to OOM killer */
> +#define TIF_NOHZ               9       /* in adaptive nohz mode */
>  #define TIF_SECCOMP            10      /* secure computing */
>  #define TIF_RESTOREALL         11      /* Restore all regs (implies NOERROR) */
>  #define TIF_NOERROR            12      /* Force successful syscall return */
> @@ -106,6 +106,7 @@ static inline struct thread_info *current_thread_info(void)
>  #define TIF_SYSCALL_TRACEPOINT 15      /* syscall tracepoint instrumentation */
>  #define TIF_EMULATE_STACK_STORE        16      /* Is an instruction emulation
>                                                 for stack store? */
> +#define TIF_MEMDIE             17      /* is terminating due to OOM killer */
>
>  /* as above, but as bit values */
>  #define _TIF_SYSCALL_TRACE     (1<<TIF_SYSCALL_TRACE)
> @@ -124,8 +125,10 @@ static inline struct thread_info *current_thread_info(void)
>  #define _TIF_UPROBE            (1<<TIF_UPROBE)
>  #define _TIF_SYSCALL_TRACEPOINT        (1<<TIF_SYSCALL_TRACEPOINT)
>  #define _TIF_EMULATE_STACK_STORE       (1<<TIF_EMULATE_STACK_STORE)
> +#define _TIF_NOHZ              (1<<TIF_NOHZ)
>  #define _TIF_SYSCALL_T_OR_A    (_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | \
> -                                _TIF_SECCOMP | _TIF_SYSCALL_TRACEPOINT)
> +                                _TIF_SECCOMP | _TIF_SYSCALL_TRACEPOINT | \
> +                                _TIF_NOHZ)
>
>  #define _TIF_USER_WORK_MASK    (_TIF_SIGPENDING | _TIF_NEED_RESCHED | \
>                                  _TIF_NOTIFY_RESUME | _TIF_UPROBE)
> diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
> index c497000..62238dd 100644
> --- a/arch/powerpc/kernel/ptrace.c
> +++ b/arch/powerpc/kernel/ptrace.c
> @@ -32,6 +32,7 @@
>  #include <trace/syscall.h>
>  #include <linux/hw_breakpoint.h>
>  #include <linux/perf_event.h>
> +#include <linux/context_tracking.h>
>
>  #include <asm/uaccess.h>
>  #include <asm/page.h>
> @@ -1745,6 +1746,8 @@ long do_syscall_trace_enter(struct pt_regs *regs)
>  {
>         long ret = 0;
>
> +       user_exit();
> +
>         secure_computing_strict(regs->gpr[0]);
>
>         if (test_thread_flag(TIF_SYSCALL_TRACE) &&
> @@ -1789,4 +1792,6 @@ void do_syscall_trace_leave(struct pt_regs *regs)
>         step = test_thread_flag(TIF_SINGLESTEP);
>         if (step || test_thread_flag(TIF_SYSCALL_TRACE))
>                 tracehook_report_syscall_exit(regs, step);
> +
> +       user_enter();
>  }
> --
> 1.7.9.5
>
