Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab3LJDJc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 22:09:32 -0500
Received: from mail-qe0-f51.google.com ([209.85.128.51]:37604 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab3LJDJa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 22:09:30 -0500
MIME-Version: 1.0
In-Reply-To: <1386642265.6996.9.camel@localhost.localdomain>
References: <1386642265.6996.9.camel@localhost.localdomain>
From: Matt Turner <mattst88@gmail.com>
Date: Mon, 9 Dec 2013 19:09:09 -0800
Message-ID: <CAEdQ38Fyrr6Dg8A50+JzAF1qXUbVnsWdEjAQxePozhqWJvN=Tw@mail.gmail.com>
Subject: Re: [alpha PATCH] enable syscall audit function at alpha architecture
To: zhenglong.cai@cs2c.com.cn
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-alpha <linux-alpha@vger.kernel.org>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 9, 2013 at 6:24 PM, ²ÌÕýÁú <zhenglong.cai@cs2c.com.cn> wrote:
> Enable system-call auditing support at alpha architecture
>
> Signed-off-by: Zhenglong.cai <zhenglong.cai@cs2c.com.cn>
>
>  arch/alpha/Kconfig                   |    3 +++
>  arch/alpha/include/asm/ptrace.h      |    5 +++++
>  arch/alpha/include/asm/thread_info.h |    2 ++
>  arch/alpha/kernel/Makefile           |    1 +
>  arch/alpha/kernel/entry.S            |    6 +++++-
>  arch/alpha/kernel/ptrace.c           |    4 ++++
>  6 files changed, 20 insertions(+), 1 deletions(-)
>
> diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
> index d39dc9b..f23ab8b 100644
> --- a/arch/alpha/Kconfig
> +++ b/arch/alpha/Kconfig
> @@ -16,6 +16,7 @@ config ALPHA
>         select ARCH_WANT_IPC_PARSE_VERSION
>         select ARCH_HAVE_NMI_SAFE_CMPXCHG
>         select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
> +       select AUDIT_ARCH
>         select GENERIC_CLOCKEVENTS
>         select GENERIC_SMP_IDLE_THREAD
>         select GENERIC_STRNCPY_FROM_USER
> @@ -76,6 +77,8 @@ config GENERIC_ISA_DMA
>  source "init/Kconfig"
>  source "kernel/Kconfig.freezer"
>
> +config AUDIT_ARCH
> +       bool
>
>  menu "System setup"
>
> diff --git a/arch/alpha/include/asm/ptrace.h
> b/arch/alpha/include/asm/ptrace.h
> index 2112850..9047c2f 100644
> --- a/arch/alpha/include/asm/ptrace.h
> +++ b/arch/alpha/include/asm/ptrace.h
> @@ -19,4 +19,9 @@
>
>  #define force_successful_syscall_return() (current_pt_regs()->r0 = 0)
>
> +static inline unsigned long regs_return_value(struct pt_regs *regs)
> +{
> +       return regs->r0;
> +}
> +
>  #endif
> diff --git a/arch/alpha/include/asm/thread_info.h
> b/arch/alpha/include/asm/thread_info.h
> index 453597b..3d6ce6d 100644
> --- a/arch/alpha/include/asm/thread_info.h
> +++ b/arch/alpha/include/asm/thread_info.h
> @@ -70,6 +70,7 @@ register struct thread_info *__current_thread_info
> __asm__("$8");
>  #define TIF_NOTIFY_RESUME      1       /* callback before returning to user */
>  #define TIF_SIGPENDING         2       /* signal pending */
>  #define TIF_NEED_RESCHED       3       /* rescheduling necessary */
> +#define TIF_SYSCALL_AUDIT      4       /* syscall audit active */
>  #define TIF_DIE_IF_KERNEL      9       /* dik recursion lock */
>  #define TIF_MEMDIE             13      /* is terminating due to OOM killer */
>
> @@ -77,6 +78,7 @@ register struct thread_info *__current_thread_info
> __asm__("$8");
>  #define _TIF_SIGPENDING                (1<<TIF_SIGPENDING)
>  #define _TIF_NEED_RESCHED      (1<<TIF_NEED_RESCHED)
>  #define _TIF_NOTIFY_RESUME     (1<<TIF_NOTIFY_RESUME)
> +#define _TIF_SYSCALL_AUDIT     (1<<TIF_SYSCALL_AUDIT)
>
>  /* Work to do on interrupt/exception return.  */
>  #define _TIF_WORK_MASK         (_TIF_SIGPENDING | _TIF_NEED_RESCHED | \
> diff --git a/arch/alpha/kernel/Makefile b/arch/alpha/kernel/Makefile
> index 0d54650..3ecac01 100644
> --- a/arch/alpha/kernel/Makefile
> +++ b/arch/alpha/kernel/Makefile
> @@ -17,6 +17,7 @@ obj-$(CONFIG_SRM_ENV) += srm_env.o
>  obj-$(CONFIG_MODULES)  += module.o
>  obj-$(CONFIG_PERF_EVENTS) += perf_event.o
>  obj-$(CONFIG_RTC_DRV_ALPHA) += rtc.o
> +obj-$(CONFIG_AUDIT)    += audit.o
>
>  ifdef CONFIG_ALPHA_GENERIC
>
> diff --git a/arch/alpha/kernel/entry.S b/arch/alpha/kernel/entry.S
> index a969b95..98703d9 100644
> --- a/arch/alpha/kernel/entry.S
> +++ b/arch/alpha/kernel/entry.S
> @@ -465,7 +465,11 @@ entSys:
>         .cfi_rel_offset $16, SP_OFF+24
>         .cfi_rel_offset $17, SP_OFF+32
>         .cfi_rel_offset $18, SP_OFF+40
> -       blbs    $3, strace
> +#ifdef CONFIG_AUDITSYSCALL
> +       lda     $6, _TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT
> +       and     $3, $6, $3
> +#endif
> +       bne     $3, strace
>         beq     $4, 1f
>         ldq     $27, 0($5)
>  1:     jsr     $26, ($27), alpha_ni_syscall
> diff --git a/arch/alpha/kernel/ptrace.c b/arch/alpha/kernel/ptrace.c
> index 2a4a80f..86d8351 100644
> --- a/arch/alpha/kernel/ptrace.c
> +++ b/arch/alpha/kernel/ptrace.c
> @@ -14,6 +14,7 @@
>  #include <linux/security.h>
>  #include <linux/signal.h>
>  #include <linux/tracehook.h>
> +#include <linux/audit.h>
>
>  #include <asm/uaccess.h>
>  #include <asm/pgtable.h>
> @@ -316,15 +317,18 @@ long arch_ptrace(struct task_struct *child, long
> request,
>  asmlinkage unsigned long syscall_trace_enter(void)
>  {
>         unsigned long ret = 0;
> +       struct pt_regs *regs = current_pt_regs();
>         if (test_thread_flag(TIF_SYSCALL_TRACE) &&
>             tracehook_report_syscall_entry(current_pt_regs()))
>                 ret = -1UL;
> +       audit_syscall_entry(AUDIT_ARCH_ALPHA, regs->r0, regs->r16, regs->r17,
> regs->r18, regs->r19);

Looks like this line was wrapped. No problem, I'll fix it before applying it.

Thanks for the patch. This should allow pam support on alpha, which is
pretty cool.

I'll test and add it to my tree if all goes well.

Thanks!
Matt
