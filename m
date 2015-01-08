Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240AbbAHSo0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 13:44:26 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36021 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750844AbbAHSoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 13:44:24 -0500
Date: Thu, 8 Jan 2015 18:43:34 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Suzuki Poulose <suzpou01@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "yexl@marvell.com" <yexl@marvell.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "leo.yan@linaro.org" <leo.yan@linaro.org>
Subject: Re: [PATCH 2/2] arm64: Emulate SETEND for AArch32 tasks
Message-ID: <20150108184258.GB31280@leverpostej>
References: <1420647405-3907-1-git-send-email-suzuki.poulose@arm.com>
 <1420647405-3907-3-git-send-email-suzuki.poulose@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420647405-3907-3-git-send-email-suzuki.poulose@arm.com>
Thread-Topic: [PATCH 2/2] arm64: Emulate SETEND for AArch32 tasks
Accept-Language: en-GB, en-US
Content-Language: en-US
acceptlanguage: en-GB, en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suzuki,

On Wed, Jan 07, 2015 at 04:16:45PM +0000, Suzuki K. Poulose wrote:
> From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
> 
> Emulate deprecated 'setend' instruction for AArch32 bit tasks.
> 
> 	setend [le/be] - Sets the endianness of EL0
> 
> The hardware support for the instruction can be enabled by setting the
> SCTLR_EL1.SED bit. Like the other emulated instructions it is controlled by
> an entry in /proc/sys/abi/. For more information see :
> 	Documentation/arm64/legacy_instructions.txt
> 
> The instruction is emulated by setting/clearing the SPSR_EL1.E bit, which
> will be reflected in the PSTATE.E in AArch32 context.

A "fun" problem with emulating setend is that it will not always work
unless we emulate the entire instruction set when userspace wants to be
in an unsupported endianness.

For implementations which are not bi-endian at EL0 (i.e. where
ID_AA64MMFR0_EL1.BigEndEL0 == 0), SCTLR_EL1.E0E has a fixed value which
we cannot change. The field names are misleading: in a BE-only system
ID_AA64MMFR0_EL1.{BigEnd,BigEndEL0} == {0,0} and SCTLR_EL1.{EE,E0E} are
fixed to {1,1}.

I think we need to detect when EL0 has a fixed endianness such that we
can treat the setend instruction as undefined. Otherwise we will
silently fail to change EL0 endianness, advance the PC, and return to
userspace in the wrong endianness, which will be very painful to debug.
Userspace has the option of handling the resulting SIGILL in such cases.

That means we need to be able to fail to transition into INSN_EMULATE
mode as we currently can when transitioning to INSN_HW.

> This patch also restores the native endianness for the execution of signal
> handlers, since the process could have changed the endianness.
> 
> Signed-off-by: Suzuki K. Poulose <suzuki.poulose@arm.com>
> ---
>  Documentation/arm64/legacy_instructions.txt |    5 ++
>  arch/arm64/Kconfig                          |   10 ++++
>  arch/arm64/include/asm/ptrace.h             |    7 +++
>  arch/arm64/kernel/armv8_deprecated.c        |   75 +++++++++++++++++++++++++++
>  arch/arm64/kernel/signal32.c                |    5 +-
>  5 files changed, 101 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/arm64/legacy_instructions.txt b/Documentation/arm64/legacy_instructions.txt
> index a3b3da2..20e5621 100644
> --- a/Documentation/arm64/legacy_instructions.txt
> +++ b/Documentation/arm64/legacy_instructions.txt
> @@ -43,3 +43,8 @@ Default: Undef (0)
>  Node: /proc/sys/abi/cp15_barrier
>  Status: Deprecated
>  Default: Emulate (1)
> +
> +* SETEND
> +Node: /proc/sys/abi/setend
> +Status: Deprecated
> +Default: Emulate (1)

Given we can't always emulate SETEND, should we document "Emulate where
possible" or something to that effect?

> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index b1f9a20..c6d1fd9 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -540,6 +540,16 @@ config CP15_BARRIER_EMULATION
>  
>  	  If unsure, say Y
>  
> +config SETEND_EMULATION
> +	bool "Emulate SETEND instruction"
> +	help
> +	  The SETEND instruction alters the data-endianness of the
> +	  AArch32 EL0, and is deprecated in ARMv8.
> +
> +	  Say Y here to enable software emulation of the instruction
> +	  for AArch32 userspace code.
> +
> +	  If unsure, say Y
>  endif
>  
>  endmenu
> diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
> index 41ed9e1..d6dd9fd 100644
> --- a/arch/arm64/include/asm/ptrace.h
> +++ b/arch/arm64/include/asm/ptrace.h
> @@ -58,6 +58,13 @@
>  #define COMPAT_PSR_Z_BIT	0x40000000
>  #define COMPAT_PSR_N_BIT	0x80000000
>  #define COMPAT_PSR_IT_MASK	0x0600fc00	/* If-Then execution state mask */
> +
> +#ifdef CONFIG_CPU_BIG_ENDIAN
> +#define COMPAT_PSR_ENDSTATE	COMPAT_PSR_E_BIT
> +#else
> +#define COMPAT_PSR_ENDSTATE	0
> +#endif
> +
>  /*
>   * These are 'magic' values for PTRACE_PEEKUSR that return info about where a
>   * process is located in memory.
> diff --git a/arch/arm64/kernel/armv8_deprecated.c b/arch/arm64/kernel/armv8_deprecated.c
> index 9054447..dc91bac 100644
> --- a/arch/arm64/kernel/armv8_deprecated.c
> +++ b/arch/arm64/kernel/armv8_deprecated.c
> @@ -477,6 +477,7 @@ ret:
>  }
>  
>  #define SCTLR_EL1_CP15BEN 	(1 << 5)
> +#define SCTLR_EL1_SED		(1 << 8)
>  
>  static inline void config_sctlr_el1(u32 clear, u32 set)
>  {
> @@ -521,6 +522,77 @@ static struct insn_emulation_ops cp15_barrier_ops = {
>  	.set_hw_mode = cp15_barrier_set_hw_mode,
>  };
>  
> +static void setend_set_hw_mode(void *enable)
> +{
> +	if (enable)
> +		config_sctlr_el1(SCTLR_EL1_SED, 0);
> +	else
> +		config_sctlr_el1(0, SCTLR_EL1_SED);
> +}
> +
> +static int compat_setend_handler(struct pt_regs *regs, u32 endian)

If we s/endian/big_endian/ here we can drop the comments within the
function as the test will be easier to read. We could also s/u32/bool/.

> +{
> +	char insn[16] = "setend _e";

Elsewhere (e.g. in cp15barrier_handler) we write these out in full
rather than modifying a string on the stack. I think we should do the
same here (we can change insn to a char * and assign the full relevant
string in either branch).

Doing so will mean grepping for '"setend be"' finds this function, which
is handy.

Thanks,
Mark.

> +
> +	perf_sw_event(PERF_COUNT_SW_EMULATION_FAULTS, 1, regs, regs->pc);
> +
> +	if (endian) {
> +		/* Big Endian */
> +		insn[7] = 'b';
> +		regs->pstate |= COMPAT_PSR_E_BIT;
> +	} else {
> +		/* Little Endian */
> +		insn[7] = 'l';
> +		regs->pstate &= ~COMPAT_PSR_E_BIT;
> +	}
> +
> +	trace_instruction_emulation(insn, regs->pc);
> +	pr_warn_ratelimited("\"%s\" (%ld) uses deprecated setend instruction at 0x%llx\n",
> +			current->comm, (unsigned long)current->pid, regs->pc);
> +
> +	return 0;
> +}
> +
> +static int a32_setend_handler(struct pt_regs *regs, u32 instr)
> +{
> +	int rc = compat_setend_handler(regs, (instr >> 9) & 1);
> +	regs->pc += 4;
> +	return rc;
> +}
> +
> +static int t16_setend_handler(struct pt_regs *regs, u32 instr)
> +{
> +	int rc = compat_setend_handler(regs, (instr >> 3) & 1);
> +	regs->pc += 2;
> +	return rc;
> +}
> +
> +static struct undef_hook setend_hooks[] = {
> +	{
> +		.instr_mask	= 0xfffffdff,
> +		.instr_val	= 0xf1010000,
> +		.pstate_mask	= COMPAT_PSR_MODE_MASK,
> +		.pstate_val	= COMPAT_PSR_MODE_USR,
> +		.fn		= a32_setend_handler,
> +	},
> +	{
> +		/* Thumb mode */
> +		.instr_mask	= 0x0000fff7,
> +		.instr_val	= 0x0000b650,
> +		.pstate_mask	= (COMPAT_PSR_T_BIT | COMPAT_PSR_MODE_MASK),
> +		.pstate_val	= (COMPAT_PSR_T_BIT | COMPAT_PSR_MODE_USR),
> +		.fn		= t16_setend_handler,
> +	},
> +	{}
> +};
> +
> +static struct insn_emulation_ops setend_ops = {
> +	.name = "setend",
> +	.status = INSN_DEPRECATED,
> +	.hooks = setend_hooks,
> +	.set_hw_mode = setend_set_hw_mode,
> +};
> +
>  static int insn_cpu_hotplug_notify(struct notifier_block *b,
>  			      unsigned long action, void *hcpu)
>  {
> @@ -545,6 +617,9 @@ static int __init armv8_deprecated_init(void)
>  	if (IS_ENABLED(CONFIG_CP15_BARRIER_EMULATION))
>  		register_insn_emulation(&cp15_barrier_ops);
>  
> +	if (IS_ENABLED(CONFIG_SETEND_EMULATION))
> +		register_insn_emulation(&setend_ops);
> +
>  	register_cpu_notifier(&insn_cpu_hotplug_notifier);
>  	register_insn_emulation_sysctl(ctl_abi);
>  
> diff --git a/arch/arm64/kernel/signal32.c b/arch/arm64/kernel/signal32.c
> index 5a1ba6e..aa763a5 100644
> --- a/arch/arm64/kernel/signal32.c
> +++ b/arch/arm64/kernel/signal32.c
> @@ -440,7 +440,7 @@ static void compat_setup_return(struct pt_regs *regs, struct k_sigaction *ka,
>  {
>  	compat_ulong_t handler = ptr_to_compat(ka->sa.sa_handler);
>  	compat_ulong_t retcode;
> -	compat_ulong_t spsr = regs->pstate & ~PSR_f;
> +	compat_ulong_t spsr = regs->pstate & ~(PSR_f | COMPAT_PSR_E_BIT);
>  	int thumb;
>  
>  	/* Check if the handler is written for ARM or Thumb */
> @@ -454,6 +454,9 @@ static void compat_setup_return(struct pt_regs *regs, struct k_sigaction *ka,
>  	/* The IT state must be cleared for both ARM and Thumb-2 */
>  	spsr &= ~COMPAT_PSR_IT_MASK;
>  
> +	/* Restore the original endianness */
> +	spsr |= COMPAT_PSR_ENDSTATE;
> +
>  	if (ka->sa.sa_flags & SA_RESTORER) {
>  		retcode = ptr_to_compat(ka->sa.sa_restorer);
>  	} else {
> -- 
> 1.7.9.5
> 
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
