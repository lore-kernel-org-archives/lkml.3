Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbaCMQ2w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 12:28:52 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:53426 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753233AbaCMQ2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 12:28:51 -0400
Date: Thu, 13 Mar 2014 16:25:48 +0000
From: Will Deacon <will.deacon@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "tim.bird@sonymobile.com" <tim.bird@sonymobile.com>,
        "gkulkarni@caviumnetworks.com" <gkulkarni@caviumnetworks.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 7/7] arm64: ftrace: Add system call tracepoint
Message-ID: <20140313162548.GD25472@mudshark.cambridge.arm.com>
References: <1393564724-3966-1-git-send-email-takahiro.akashi@linaro.org>
 <1394705630-12384-1-git-send-email-takahiro.akashi@linaro.org>
 <1394705630-12384-8-git-send-email-takahiro.akashi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394705630-12384-8-git-send-email-takahiro.akashi@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 10:13:50AM +0000, AKASHI Takahiro wrote:
> This patch allows system call entry or exit to be traced as ftrace events,
> ie. sys_enter_*/sys_exit_*, if CONFIG_FTRACE_SYSCALLS is enabled.
> Those events appear and can be controlled under
>     ${sysfs}/tracing/events/syscalls/
> 
> Please note that we can't trace compat system calls here because
> AArch32 mode does not share the same syscall table with AArch64.
> Just define ARCH_TRACE_IGNORE_COMPAT_SYSCALLS in order to avoid unexpected
> results (bogus syscalls reported or even hang-up).
> 
> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
> ---
>  arch/arm64/Kconfig               |    1 +
>  arch/arm64/include/asm/ftrace.h  |   20 ++++++++++++++++
>  arch/arm64/include/asm/syscall.h |    1 +
>  arch/arm64/include/asm/unistd.h  |    2 ++
>  arch/arm64/kernel/ptrace.c       |   48 ++++++++++++++++++++++----------------
>  5 files changed, 52 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 6954959..b1dcdb4 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -43,6 +43,7 @@ config ARM64
>  	select HAVE_MEMBLOCK
>  	select HAVE_PATA_PLATFORM
>  	select HAVE_PERF_EVENTS
> +	select HAVE_SYSCALL_TRACEPOINTS
>  	select IRQ_DOMAIN
>  	select MODULES_USE_ELF_RELA
>  	select NO_BOOTMEM
> diff --git a/arch/arm64/include/asm/ftrace.h b/arch/arm64/include/asm/ftrace.h
> index c44c4b1..4ef06f1 100644
> --- a/arch/arm64/include/asm/ftrace.h
> +++ b/arch/arm64/include/asm/ftrace.h
> @@ -44,6 +44,26 @@ static inline unsigned long ftrace_call_adjust(unsigned long addr)
>  #define CALLER_ADDR4 ((unsigned long)return_address(4))
>  #define CALLER_ADDR5 ((unsigned long)return_address(5))
>  #define CALLER_ADDR6 ((unsigned long)return_address(6))
> +
> +#include <asm/compat.h>
> +
> +/*
> + * Because AArch32 mode does not share the same syscall table with AArch64,
> + * tracing compat syscalls may result in reporting bogus syscalls or even
> + * hang-up, so just do not trace them.
> + * See kernel/trace/trace_syscalls.c
> + *
> + * x86 code says:
> + * If the user realy wants these, then they should use the
> + * raw syscall tracepoints with filtering.

Fair enough.

> + */
> +#define ARCH_TRACE_IGNORE_COMPAT_SYSCALLS 1

You don't need the '1' here.

> +static inline bool arch_trace_is_compat_syscall(struct pt_regs *regs)
> +{
> +        if (is_compat_task())
> +                return true;
> +        return false;
> +}

return is_compat_task();

>  #endif /* ifndef __ASSEMBLY__ */
>  
>  #endif /* __ASM_FTRACE_H */
> diff --git a/arch/arm64/include/asm/syscall.h b/arch/arm64/include/asm/syscall.h
> index 70ba9d4..383771e 100644
> --- a/arch/arm64/include/asm/syscall.h
> +++ b/arch/arm64/include/asm/syscall.h
> @@ -18,6 +18,7 @@
>  
>  #include <linux/err.h>
>  
> +extern const void *sys_call_table[];
>  
>  static inline int syscall_get_nr(struct task_struct *task,
>  				 struct pt_regs *regs)
> diff --git a/arch/arm64/include/asm/unistd.h b/arch/arm64/include/asm/unistd.h
> index 82ce217..c335479 100644
> --- a/arch/arm64/include/asm/unistd.h
> +++ b/arch/arm64/include/asm/unistd.h
> @@ -28,3 +28,5 @@
>  #endif
>  #define __ARCH_WANT_SYS_CLONE
>  #include <uapi/asm/unistd.h>
> +
> +#define NR_syscalls (__NR_syscalls)
> diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
> index 9993a8f..9c52b3e 100644
> --- a/arch/arm64/kernel/ptrace.c
> +++ b/arch/arm64/kernel/ptrace.c
> @@ -41,6 +41,9 @@
>  #include <asm/traps.h>
>  #include <asm/system_misc.h>
>  
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/syscalls.h>
> +
>  /*
>   * TODO: does not yet catch signals sent when the child dies.
>   * in exit.c or in signal.c.
> @@ -1062,29 +1065,31 @@ asmlinkage int syscall_trace_enter(struct pt_regs *regs)
>  {
>  	unsigned long saved_reg;
>  
> -	if (!test_thread_flag(TIF_SYSCALL_TRACE))
> -		return regs->syscallno;
> +	if (test_thread_flag(TIF_SYSCALL_TRACE)) {
> +		/*
> +		 * A scrach register (ip(r12) on AArch32, x7 on AArch64) is
> +		 * used to denote syscall entry/exit:
> +		 *   0 -> entry
> +		 */
> +		if (is_compat_task()) {

if (arch_trace_is_compat_syscall())

With those changes:

  Acked-by: Will Deacon <will.deacon@arm.com>

Will
