Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab3LQLLr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 06:11:47 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49979 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751410Ab3LQLLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 06:11:45 -0500
Date: Tue, 17 Dec 2013 11:11:26 +0000
From: Will Deacon <will.deacon@arm.com>
To: "jean.pihet@linaro.org" <jean.pihet@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Arnaldo <acme@ghostprotocols.net>,
        "patches@linaro.org" <patches@linaro.org>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/3] ARM64: perf: add support for perf registers API
Message-ID: <20131217111126.GB7602@mudshark.cambridge.arm.com>
References: <1387212562-8128-1-git-send-email-y>
 <52af2f24.41590e0a.0251.ffffd950@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52af2f24.41590e0a.0251.ffffd950@mx.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On Mon, Dec 16, 2013 at 04:49:20PM +0000, jean.pihet@linaro.org wrote:
> From: Jean Pihet <jean.pihet@linaro.org>
> 
> This patch implements the functions required for the perf registers API,
> allowing the perf tool to interface kernel register dumps with libunwind
> in order to provide userspace backtracing.
> Compat mode is also supported.
> 
> Only the general purpose user space registers are exported, i.e.:
>  PERF_REG_ARM_X0,
>  ...
>  PERF_REG_ARM_X28,
>  PERF_REG_ARM_FP,
>  PERF_REG_ARM_LR,
>  PERF_REG_ARM_SP,
>  PERF_REG_ARM_PC
> and not the PERF_REG_ARM_V* registers.
> 
> Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
> Cc: Will Deacon <will.deacon@arm.com>
> ---
>  arch/arm64/Kconfig                      |  2 ++
>  arch/arm64/include/asm/ptrace.h         |  1 +
>  arch/arm64/include/uapi/asm/Kbuild      |  1 +
>  arch/arm64/include/uapi/asm/perf_regs.h | 40 ++++++++++++++++++++++++++++
>  arch/arm64/kernel/Makefile              |  1 +
>  arch/arm64/kernel/perf_regs.c           | 46 +++++++++++++++++++++++++++++++++
>  6 files changed, 91 insertions(+)
>  create mode 100644 arch/arm64/include/uapi/asm/perf_regs.h
>  create mode 100644 arch/arm64/kernel/perf_regs.c
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 88c8b6c1..f8609dc 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -28,6 +28,8 @@ config ARM64
>  	select HAVE_HW_BREAKPOINT if PERF_EVENTS
>  	select HAVE_MEMBLOCK
>  	select HAVE_PERF_EVENTS
> +	select HAVE_PERF_REGS
> +	select HAVE_PERF_USER_STACK_DUMP
>  	select IRQ_DOMAIN
>  	select MODULES_USE_ELF_RELA
>  	select NO_BOOTMEM
> diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
> index 0e7fa49..fbb0020 100644
> --- a/arch/arm64/include/asm/ptrace.h
> +++ b/arch/arm64/include/asm/ptrace.h
> @@ -68,6 +68,7 @@
>  
>  /* Architecturally defined mapping between AArch32 and AArch64 registers */
>  #define compat_usr(x)	regs[(x)]
> +#define compat_fp	regs[11]
>  #define compat_sp	regs[13]
>  #define compat_lr	regs[14]
>  #define compat_sp_hyp	regs[15]
> diff --git a/arch/arm64/include/uapi/asm/Kbuild b/arch/arm64/include/uapi/asm/Kbuild
> index e4b78bd..942376d 100644
> --- a/arch/arm64/include/uapi/asm/Kbuild
> +++ b/arch/arm64/include/uapi/asm/Kbuild
> @@ -9,6 +9,7 @@ header-y += byteorder.h
>  header-y += fcntl.h
>  header-y += hwcap.h
>  header-y += kvm_para.h
> +header-y += perf_regs.h
>  header-y += param.h
>  header-y += ptrace.h
>  header-y += setup.h
> diff --git a/arch/arm64/include/uapi/asm/perf_regs.h b/arch/arm64/include/uapi/asm/perf_regs.h
> new file mode 100644
> index 0000000..06bf360
> --- /dev/null
> +++ b/arch/arm64/include/uapi/asm/perf_regs.h
> @@ -0,0 +1,40 @@
> +#ifndef _ASM_ARM_PERF_REGS_H
> +#define _ASM_ARM_PERF_REGS_H
> +
> +enum perf_event_arm_regs {
> +	PERF_REG_ARM_X0,
> +	PERF_REG_ARM_X1,
> +	PERF_REG_ARM_X2,
> +	PERF_REG_ARM_X3,
> +	PERF_REG_ARM_X4,
> +	PERF_REG_ARM_X5,
> +	PERF_REG_ARM_X6,
> +	PERF_REG_ARM_X7,
> +	PERF_REG_ARM_X8,
> +	PERF_REG_ARM_X9,
> +	PERF_REG_ARM_X10,
> +	PERF_REG_ARM_X11,
> +	PERF_REG_ARM_X12,
> +	PERF_REG_ARM_X13,
> +	PERF_REG_ARM_X14,
> +	PERF_REG_ARM_X15,
> +	PERF_REG_ARM_X16,
> +	PERF_REG_ARM_X17,
> +	PERF_REG_ARM_X18,
> +	PERF_REG_ARM_X19,
> +	PERF_REG_ARM_X20,
> +	PERF_REG_ARM_X21,
> +	PERF_REG_ARM_X22,
> +	PERF_REG_ARM_X23,
> +	PERF_REG_ARM_X24,
> +	PERF_REG_ARM_X25,
> +	PERF_REG_ARM_X26,
> +	PERF_REG_ARM_X27,
> +	PERF_REG_ARM_X28,
> +	PERF_REG_ARM_FP,
> +	PERF_REG_ARM_LR,
> +	PERF_REG_ARM_SP,
> +	PERF_REG_ARM_PC,
> +	PERF_REG_ARM_MAX,

I think these should be PERF_REG_ARM64_* to avoid name conflicts with
arch/arm/.

> +};
> +#endif /* _ASM_ARM_PERF_REGS_H */
> diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
> index 5ba2fd4..dffdd93 100644
> --- a/arch/arm64/kernel/Makefile
> +++ b/arch/arm64/kernel/Makefile
> @@ -15,6 +15,7 @@ arm64-obj-$(CONFIG_COMPAT)		+= sys32.o kuser32.o signal32.o 	\
>  					   sys_compat.o
>  arm64-obj-$(CONFIG_MODULES)		+= arm64ksyms.o module.o
>  arm64-obj-$(CONFIG_SMP)			+= smp.o smp_spin_table.o
> +arm64-obj-$(CONFIG_PERF_EVENTS)		+= perf_regs.o
>  arm64-obj-$(CONFIG_HW_PERF_EVENTS)	+= perf_event.o
>  arm64-obj-$(CONFIG_HAVE_HW_BREAKPOINT)+= hw_breakpoint.o
>  arm64-obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
> diff --git a/arch/arm64/kernel/perf_regs.c b/arch/arm64/kernel/perf_regs.c
> new file mode 100644
> index 0000000..d5c8fd7
> --- /dev/null
> +++ b/arch/arm64/kernel/perf_regs.c
> @@ -0,0 +1,46 @@
> +#include <linux/errno.h>
> +#include <linux/kernel.h>
> +#include <linux/perf_event.h>
> +#include <linux/bug.h>
> +#include <asm/perf_regs.h>
> +#include <asm/ptrace.h>
> +
> +u64 perf_reg_value(struct pt_regs *regs, int idx)
> +{
> +	if (WARN_ON_ONCE((u32)idx >= PERF_REG_ARM_MAX))
> +		return 0;
> +
> +	/*
> +	 * Compat (i.e. 32 bit) mode:
> +	 * - PC has been set in the pt_regs struct in kernel_entry,
> +	 * - Handle FP, SP and LR here.
> +	 */
> +	if (compat_user_mode(regs)) {
> +		if ((u32)idx == PERF_REG_ARM_FP)

This doesn't look right to me... why would a compat task be asking for
PERF_REG_ARM_FP, where that is greater than the arch/arm/ definition of
PERF_REG_ARM_MAX?

> +			return regs->compat_fp;

Also, why are you treating FP specially? The hardware doesn't do anything
special with it.

> +		if ((u32)idx == PERF_REG_ARM_SP)
> +			return regs->compat_sp;
> +		if ((u32)idx == PERF_REG_ARM_LR)
> +			return regs->compat_lr;
> +	}
> +
> +	return regs->regs[idx];
> +}
> +
> +#define REG_RESERVED (~((1ULL << PERF_REG_ARM_MAX) - 1))
> +
> +int perf_reg_validate(u64 mask)
> +{
> +	if (!mask || mask & REG_RESERVED)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +u64 perf_reg_abi(struct task_struct *task)
> +{
> +	if (test_tsk_thread_flag(task, TIF_32BIT))

  is_compat_thread(task_thread_info(task)) ?

Will
