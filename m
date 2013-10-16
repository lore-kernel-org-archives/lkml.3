Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760655Ab3JPKwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 06:52:24 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50546 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760492Ab3JPKwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 06:52:23 -0400
Date: Wed, 16 Oct 2013 11:51:42 +0100
From: Will Deacon <will.deacon@arm.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Jiang Liu <jiang.liu@huawei.com>, Marc Zyngier <Marc.Zyngier@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/7] arm64: introduce basic aarch64 instruction
 decoding helpers
Message-ID: <20131016105142.GD5403@mudshark.cambridge.arm.com>
References: <1381893492-7135-1-git-send-email-liuj97@gmail.com>
 <1381893492-7135-2-git-send-email-liuj97@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381893492-7135-2-git-send-email-liuj97@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 04:18:06AM +0100, Jiang Liu wrote:
> From: Jiang Liu <jiang.liu@huawei.com>
> 
> Introduce basic aarch64 instruction decoding helper
> aarch64_get_insn_class() and aarch64_insn_hotpatch_safe().
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: Jiang Liu <liuj97@gmail.com>
> ---
>  arch/arm64/include/asm/insn.h | 53 ++++++++++++++++++++++++++
>  arch/arm64/kernel/Makefile    |  2 +-
>  arch/arm64/kernel/insn.c      | 86 +++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 140 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm64/include/asm/insn.h
>  create mode 100644 arch/arm64/kernel/insn.c
> 
> diff --git a/arch/arm64/include/asm/insn.h b/arch/arm64/include/asm/insn.h
> new file mode 100644
> index 0000000..e7d1bc8
> --- /dev/null
> +++ b/arch/arm64/include/asm/insn.h
> @@ -0,0 +1,53 @@
> +/*
> + * Copyright (C) 2013 Huawei Ltd.
> + * Author: Jiang Liu <jiang.liu@huawei.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +#ifndef	_ASM_ARM64_INSN_H
> +#define	_ASM_ARM64_INSN_H
> +#include <linux/types.h>
> +
> +enum aarch64_insn_class {
> +	AARCH64_INSN_CLS_UNKNOWN,	/* UNALLOCATED */
> +	AARCH64_INSN_CLS_DP_IMM,	/* Data processing - immediate */
> +	AARCH64_INSN_CLS_DP_REG,	/* Data processing - register */
> +	AARCH64_INSN_CLS_DP_FPSIMD,	/* Data processing - SIMD and FP */
> +	AARCH64_INSN_CLS_LDST,		/* Loads and stores */
> +	AARCH64_INSN_CLS_BR_SYS,	/* Branch, exception generation and
> +					 * system instructions */
> +};

Strictly speaking, these are encoding groups, not instruction classes.

> +
> +#define	__AARCH64_INSN_FUNCS(abbr, mask, val)	\
> +static __always_inline bool aarch64_insn_is_##abbr(u32 code) \
> +{ return (code & (mask)) == (val); }	\
> +static __always_inline u32 aarch64_insn_get_##abbr##_mask(void) \
> +{ return (mask); } \
> +static __always_inline u32 aarch64_insn_get_##abbr##_value(void) \
> +{ return (val); }
> +
> +__AARCH64_INSN_FUNCS(b,		0xFC000000, 0x14000000)
> +__AARCH64_INSN_FUNCS(bl,	0xFC000000, 0x94000000)
> +__AARCH64_INSN_FUNCS(svc,	0xFFE0001F, 0xD4000001)
> +__AARCH64_INSN_FUNCS(hvc,	0xFFE0001F, 0xD4000002)
> +__AARCH64_INSN_FUNCS(smc,	0xFFE0001F, 0xD4000003)
> +__AARCH64_INSN_FUNCS(brk,	0xFFE0001F, 0xD4200000)
> +__AARCH64_INSN_FUNCS(nop,	0xFFFFFFFF, 0xD503201F)
> +
> +#undef	__AARCH64_INSN_FUNCS
> +
> +enum aarch64_insn_class aarch64_get_insn_class(u32 insn);
> +
> +bool aarch64_insn_hotpatch_safe(u32 old_insn, u32 new_insn);
> +
> +#endif	/* _ASM_ARM64_INSN_H */
> diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
> index 7b4b564..9af6cb3 100644
> --- a/arch/arm64/kernel/Makefile
> +++ b/arch/arm64/kernel/Makefile
> @@ -9,7 +9,7 @@ AFLAGS_head.o		:= -DTEXT_OFFSET=$(TEXT_OFFSET)
>  arm64-obj-y		:= cputable.o debug-monitors.o entry.o irq.o fpsimd.o	\
>  			   entry-fpsimd.o process.o ptrace.o setup.o signal.o	\
>  			   sys.o stacktrace.o time.o traps.o io.o vdso.o	\
> -			   hyp-stub.o psci.o
> +			   hyp-stub.o psci.o insn.o
>  
>  arm64-obj-$(CONFIG_COMPAT)		+= sys32.o kuser32.o signal32.o 	\
>  					   sys_compat.o
> diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
> new file mode 100644
> index 0000000..1be4d11
> --- /dev/null
> +++ b/arch/arm64/kernel/insn.c
> @@ -0,0 +1,86 @@
> +/*
> + * Copyright (C) 2013 Huawei Ltd.
> + * Author: Jiang Liu <jiang.liu@huawei.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +#include <linux/compiler.h>
> +#include <linux/kernel.h>
> +#include <asm/insn.h>
> +
> +/*
> + * ARM Architecture Reference Manual ARMv8, Section C3.1
> + * AARCH64 main encoding table

AArch64.

> + *  Bit position
> + *   28 27 26 25	Encoding Group
> + *   0  0  -  -		Unallocated
> + *   1  0  0  -		Data processing, immediate
> + *   1  0  1  -		Branch, exception generation and system instructions
> + *   -  1  -  0		Loads and stores
> + *   -  1  0  1		Data processing - register
> + *   0  1  1  1		Data processing - SIMD and floating point
> + *   1  1  1  1		Data processing - SIMD and floating point
> + * "-" means "don't care"
> + */

This comment would probably be better off in the header file, along with the
mask/value pairs you use there. Failing that, the table below should at
least live alongside the enum type and mask/value stuff.

> +static int aarch64_insn_cls[] = {
> +	AARCH64_INSN_CLS_UNKNOWN,
> +	AARCH64_INSN_CLS_UNKNOWN,
> +	AARCH64_INSN_CLS_UNKNOWN,
> +	AARCH64_INSN_CLS_UNKNOWN,
> +	AARCH64_INSN_CLS_LDST,
> +	AARCH64_INSN_CLS_DP_REG,
> +	AARCH64_INSN_CLS_LDST,
> +	AARCH64_INSN_CLS_DP_FPSIMD,
> +	AARCH64_INSN_CLS_DP_IMM,
> +	AARCH64_INSN_CLS_DP_IMM,
> +	AARCH64_INSN_CLS_BR_SYS,
> +	AARCH64_INSN_CLS_BR_SYS,
> +	AARCH64_INSN_CLS_LDST,
> +	AARCH64_INSN_CLS_DP_REG,
> +	AARCH64_INSN_CLS_LDST,
> +	AARCH64_INSN_CLS_DP_FPSIMD,
> +};
> +
> +enum aarch64_insn_class __kprobes aarch64_get_insn_class(u32 insn)
> +{
> +	return aarch64_insn_cls[(insn >> 25) & 0xf];
> +}
> +
> +static bool __kprobes __aarch64_insn_hotpatch_safe(u32 insn)
> +{
> +	if (aarch64_get_insn_class(insn) != AARCH64_INSN_CLS_BR_SYS)
> +		return false;
> +
> +	return	aarch64_insn_is_b(insn) ||
> +		aarch64_insn_is_bl(insn) ||
> +		aarch64_insn_is_svc(insn) ||
> +		aarch64_insn_is_hvc(insn) ||
> +		aarch64_insn_is_smc(insn) ||
> +		aarch64_insn_is_brk(insn) ||
> +		aarch64_insn_is_nop(insn);
> +}
> +
> +/*
> + * ARMv8-A Section B2.6.5:
> + * Concurrent modification and execution of instructions can lead to the
> + * resulting instruction performing any behavior that can be achieved by
> + * executing any sequence of instructions that can be executed from the
> + * same Exception level, except where the instruction before modification
> + * and the instruction after modification is a B, BL, NOP, BKPT, SVC, HVC,
> + * or SMC instruction.
> + */
> +bool __kprobes aarch64_insn_hotpatch_safe(u32 old_insn, u32 new_insn)
> +{
> +	return __aarch64_insn_hotpatch_safe(old_insn) &&
> +	       __aarch64_insn_hotpatch_safe(new_insn);

Take care here:

	- This doesn't guarantee that CPUs exclusively see new_insn (they
	  may see old_insn, even after patching)

	- If you patch a conditional branch and change both the target address
	  *and* the condition, you can get combinations of target/condition
	  between old_insn and new_insn.

Then again, the jump_label code should always be patching between B and NOP
instructions, right?

Will
