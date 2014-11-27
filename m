Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbaK0KJQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 05:09:16 -0500
Received: from [133.145.228.44] ([133.145.228.44]:43362 "EHLO
	mail9.hitachi.co.jp" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbaK0KJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 05:09:11 -0500
Message-ID: <5476F82B.7010006@hitachi.com>
Date: Thu, 27 Nov 2014 19:08:43 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Wang Nan <wangnan0@huawei.com>
Cc: tixy@linaro.org, linux@arm.linux.org.uk, will.deacon@arm.com,
        taras.kondratiuk@linaro.org, ben.dooks@codethink.co.uk, cl@linux.com,
        rabin@rab.in, davem@davemloft.net, lizefan@huawei.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 2/4] ARM: kprobes: collects stack consumption for
 store instructions
References: <1416645613-38904-1-git-send-email-wangnan0@huawei.com> <1416645613-38904-3-git-send-email-wangnan0@huawei.com>
In-Reply-To: <1416645613-38904-3-git-send-email-wangnan0@huawei.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/22 17:40), Wang Nan wrote:
> This patch uses the previously introduced checker functionality on
> store instructions to record their stack consumption information to
> arch_probes_insn.
> 
> Signed-off-by: Wang Nan <wangnan0@huawei.com>
> Signed-off-by: Jon Medhurst <tixy@linaro.org>
> Reviewed-by: Jon Medhurst <tixy@linaro.org>

>From the viewpoint of kprobes, this looks good to me. It's now nicely separated
from kprobes core code :)

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you,

> 
> ---
> 
> v1 -> v2:
>  - Bugfix and code improvements following Tixy's suggestion. See:
>    http://www.spinics.net/lists/arm-kernel/msg372912.html
> 
> v2 -> v3:
>  - Totaly reconstructed following Tixy' instruction. See:
>    https://lkml.org/lkml/2014/10/27/662 .
>    Add his SOB.
> 
> v3 -> v4:
>  - Commit message improvements.
>  - Comments improvements and code cleanup.
>  - A bug is found and fixed in decode table in arm_check_stack().
> 
> v4 -> v5:
>  - Bugs in thumb2 decoding table is found by Tixy and fixed.
> ---
>  arch/arm/include/asm/probes.h            |   1 +
>  arch/arm/kernel/Makefile                 |   6 +-
>  arch/arm/kernel/kprobes-arm.c            |   3 +-
>  arch/arm/kernel/kprobes-thumb.c          |   5 +-
>  arch/arm/kernel/probes-checkers-arm.c    |  99 ++++++++++++++++++++++++++++
>  arch/arm/kernel/probes-checkers-common.c | 101 ++++++++++++++++++++++++++++
>  arch/arm/kernel/probes-checkers-thumb.c  | 110 +++++++++++++++++++++++++++++++
>  arch/arm/kernel/probes-checkers.h        |  54 +++++++++++++++
>  arch/arm/kernel/probes.c                 |  10 +++
>  9 files changed, 383 insertions(+), 6 deletions(-)
>  create mode 100644 arch/arm/kernel/probes-checkers-arm.c
>  create mode 100644 arch/arm/kernel/probes-checkers-common.c
>  create mode 100644 arch/arm/kernel/probes-checkers-thumb.c
>  create mode 100644 arch/arm/kernel/probes-checkers.h
> 
> diff --git a/arch/arm/include/asm/probes.h b/arch/arm/include/asm/probes.h
> index 806cfe6..ccf9af3 100644
> --- a/arch/arm/include/asm/probes.h
> +++ b/arch/arm/include/asm/probes.h
> @@ -38,6 +38,7 @@ struct arch_probes_insn {
>  	probes_check_cc			*insn_check_cc;
>  	probes_insn_singlestep_t	*insn_singlestep;
>  	probes_insn_fn_t		*insn_fn;
> +	int stack_space;
>  };
>  
>  #endif
> diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
> index 38ddd9f..45aed4b 100644
> --- a/arch/arm/kernel/Makefile
> +++ b/arch/arm/kernel/Makefile
> @@ -52,11 +52,11 @@ obj-$(CONFIG_FUNCTION_GRAPH_TRACER)	+= ftrace.o insn.o
>  obj-$(CONFIG_JUMP_LABEL)	+= jump_label.o insn.o patch.o
>  obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o
>  obj-$(CONFIG_UPROBES)		+= probes.o probes-arm.o uprobes.o uprobes-arm.o
> -obj-$(CONFIG_KPROBES)		+= probes.o kprobes.o kprobes-common.o patch.o
> +obj-$(CONFIG_KPROBES)		+= probes.o kprobes.o kprobes-common.o patch.o probes-checkers-common.o
>  ifdef CONFIG_THUMB2_KERNEL
> -obj-$(CONFIG_KPROBES)		+= kprobes-thumb.o probes-thumb.o
> +obj-$(CONFIG_KPROBES)		+= kprobes-thumb.o probes-thumb.o probes-checkers-thumb.o
>  else
> -obj-$(CONFIG_KPROBES)		+= kprobes-arm.o probes-arm.o
> +obj-$(CONFIG_KPROBES)		+= kprobes-arm.o probes-arm.o probes-checkers-arm.o
>  endif
>  obj-$(CONFIG_ARM_KPROBES_TEST)	+= test-kprobes.o
>  test-kprobes-objs		:= kprobes-test.o
> diff --git a/arch/arm/kernel/kprobes-arm.c b/arch/arm/kernel/kprobes-arm.c
> index 5a81275..56f78ce 100644
> --- a/arch/arm/kernel/kprobes-arm.c
> +++ b/arch/arm/kernel/kprobes-arm.c
> @@ -64,6 +64,7 @@
>  
>  #include "kprobes.h"
>  #include "probes-arm.h"
> +#include "probes-checkers.h"
>  
>  #if  __LINUX_ARM_ARCH__ >= 6
>  #define BLX(reg)	"blx	"reg"		\n\t"
> @@ -342,4 +343,4 @@ const union decode_action kprobes_arm_actions[NUM_PROBES_ARM_ACTIONS] = {
>  	[PROBES_LDMSTM] = {.decoder = kprobe_decode_ldmstm}
>  };
>  
> -const struct decode_checker *kprobes_arm_checkers[] = {NULL};
> +const struct decode_checker *kprobes_arm_checkers[] = {arm_stack_checker, NULL};
> diff --git a/arch/arm/kernel/kprobes-thumb.c b/arch/arm/kernel/kprobes-thumb.c
> index b8ba7d2..dbfd3ca 100644
> --- a/arch/arm/kernel/kprobes-thumb.c
> +++ b/arch/arm/kernel/kprobes-thumb.c
> @@ -15,6 +15,7 @@
>  
>  #include "kprobes.h"
>  #include "probes-thumb.h"
> +#include "probes-checkers.h"
>  
>  /* These emulation encodings are functionally equivalent... */
>  #define t32_emulate_rd8rn16rm0ra12_noflags \
> @@ -665,5 +666,5 @@ const union decode_action kprobes_t32_actions[NUM_PROBES_T32_ACTIONS] = {
>  		.handler = t32_emulate_rdlo12rdhi8rn16rm0_noflags},
>  };
>  
> -const struct decode_checker *kprobes_t32_checkers[] = {NULL};
> -const struct decode_checker *kprobes_t16_checkers[] = {NULL};
> +const struct decode_checker *kprobes_t32_checkers[] = {t32_stack_checker, NULL};
> +const struct decode_checker *kprobes_t16_checkers[] = {t16_stack_checker, NULL};
> diff --git a/arch/arm/kernel/probes-checkers-arm.c b/arch/arm/kernel/probes-checkers-arm.c
> new file mode 100644
> index 0000000..53f6736
> --- /dev/null
> +++ b/arch/arm/kernel/probes-checkers-arm.c
> @@ -0,0 +1,99 @@
> +/*
> + * arch/arm/kernel/probes-checkers-arm.c
> + *
> + * Copyright (C) 2014 Huawei Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + */
> +
> +#include <linux/kernel.h>
> +#include "probes.h"
> +#include "probes-arm.h"
> +#include "probes-checkers.h"
> +
> +static enum probes_insn __kprobes arm_check_stack(probes_opcode_t insn,
> +		struct arch_probes_insn *asi,
> +		const struct decode_header *h)
> +{
> +	/*
> +	 * PROBES_LDRSTRD, PROBES_LDMSTM, PROBES_STORE,
> +	 * PROBES_STORE_EXTRA may get here. Simply mark all normal
> +	 * insns as STACK_USE_NONE.
> +	 */
> +	static const union decode_item table[] = {
> +		/*
> +		 * 'STR{,D,B,H}, Rt, [Rn, Rm]' should be marked as UNKNOWN
> +		 * if Rn or Rm is SP.
> +		 *                                 x
> +		 * STR (register)	cccc 011x x0x0 xxxx xxxx xxxx xxxx xxxx
> +		 * STRB (register)	cccc 011x x1x0 xxxx xxxx xxxx xxxx xxxx
> +		 */
> +		DECODE_OR	(0x0e10000f, 0x0600000d),
> +		DECODE_OR	(0x0e1f0000, 0x060d0000),
> +
> +		/*
> +		 *                                                     x
> +		 * STRD (register)	cccc 000x x0x0 xxxx xxxx xxxx 1111 xxxx
> +		 * STRH (register)	cccc 000x x0x0 xxxx xxxx xxxx 1011 xxxx
> +		 */
> +		DECODE_OR	(0x0e5000bf, 0x000000bd),
> +		DECODE_CUSTOM	(0x0e5f00b0, 0x000d00b0, STACK_USE_UNKNOWN),
> +
> +		/*
> +		 * For PROBES_LDMSTM, only stmdx sp, [...] need to examine
> +		 *
> +		 * Bit B/A (bit 24) encodes arithmetic operation order. 1 means
> +		 * before, 0 means after.
> +		 * Bit I/D (bit 23) encodes arithmetic operation. 1 means
> +		 * increment, 0 means decrement.
> +		 *
> +		 * So:
> +		 *                              B I
> +		 *                              / /
> +		 *                              A D   | Rn |
> +		 * STMDX SP, [...]	cccc 100x 00x0 xxxx xxxx xxxx xxxx xxxx
> +		 */
> +		DECODE_CUSTOM	(0x0edf0000, 0x080d0000, STACK_USE_STMDX),
> +
> +		/*                              P U W | Rn | Rt |     imm12    |*/
> +		/* STR (immediate)	cccc 010x x0x0 1101 xxxx xxxx xxxx xxxx */
> +		/* STRB (immediate)	cccc 010x x1x0 1101 xxxx xxxx xxxx xxxx */
> +		/*                              P U W | Rn | Rt |imm4|    |imm4|*/
> +		/* STRD (immediate)	cccc 000x x1x0 1101 xxxx xxxx 1111 xxxx */
> +		/* STRH (immediate)	cccc 000x x1x0 1101 xxxx xxxx 1011 xxxx */
> +		/*
> +		 * index = (P == '1'); add = (U == '1').
> +		 * Above insns with:
> +		 *    index == 0 (str{,d,h} rx, [sp], #+/-imm) or
> +		 *    add == 1 (str{,d,h} rx, [sp, #+<imm>])
> +		 * should be STACK_USE_NONE.
> +		 * Only str{,b,d,h} rx,[sp,#-n] (P == 1 and U == 0) are
> +		 * required to be examined.
> +		 */
> +		/* STR{,B} Rt,[SP,#-n]	cccc 0101 0xx0 1101 xxxx xxxx xxxx xxxx */
> +		DECODE_CUSTOM	(0x0f9f0000, 0x050d0000, STACK_USE_FIXED_XXX),
> +
> +		/* STR{D,H} Rt,[SP,#-n]	cccc 0001 01x0 1101 xxxx xxxx 1x11 xxxx */
> +		DECODE_CUSTOM	(0x0fdf00b0, 0x014d00b0, STACK_USE_FIXED_X0X),
> +
> +		/* fall through */
> +		DECODE_CUSTOM	(0, 0, STACK_USE_NONE),
> +		DECODE_END
> +	};
> +
> +	return probes_decode_insn(insn, asi, table, false, false, stack_check_actions, NULL);
> +}
> +
> +const struct decode_checker arm_stack_checker[NUM_PROBES_ARM_ACTIONS] = {
> +	[PROBES_LDRSTRD] = {.checker = arm_check_stack},
> +	[PROBES_STORE_EXTRA] = {.checker = arm_check_stack},
> +	[PROBES_STORE] = {.checker = arm_check_stack},
> +	[PROBES_LDMSTM] = {.checker = arm_check_stack},
> +};
> diff --git a/arch/arm/kernel/probes-checkers-common.c b/arch/arm/kernel/probes-checkers-common.c
> new file mode 100644
> index 0000000..e9fd1b3
> --- /dev/null
> +++ b/arch/arm/kernel/probes-checkers-common.c
> @@ -0,0 +1,101 @@
> +/*
> + * arch/arm/kernel/probes-checkers-common.c
> + *
> + * Copyright (C) 2014 Huawei Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + */
> +
> +#include <linux/kernel.h>
> +#include "probes.h"
> +#include "probes-arm.h"
> +#include "probes-checkers.h"
> +
> +enum probes_insn checker_stack_use_none(probes_opcode_t insn,
> +		struct arch_probes_insn *asi,
> +		const struct decode_header *h)
> +{
> +	asi->stack_space = 0;
> +	return INSN_GOOD_NO_SLOT;
> +}
> +
> +enum probes_insn checker_stack_use_unknown(probes_opcode_t insn,
> +		struct arch_probes_insn *asi,
> +		const struct decode_header *h)
> +{
> +	asi->stack_space = -1;
> +	return INSN_GOOD_NO_SLOT;
> +}
> +
> +#ifdef CONFIG_THUMB2_KERNEL
> +enum probes_insn checker_stack_use_imm_0xx(probes_opcode_t insn,
> +		struct arch_probes_insn *asi,
> +		const struct decode_header *h)
> +{
> +	int imm = insn & 0xff;
> +	asi->stack_space = imm;
> +	return INSN_GOOD_NO_SLOT;
> +}
> +
> +/*
> + * Different from other insn uses imm8, the real addressing offset of
> + * STRD in T32 encoding should be imm8 * 4. See ARMARM description.
> + */
> +enum probes_insn checker_stack_use_t32strd(probes_opcode_t insn,
> +		struct arch_probes_insn *asi,
> +		const struct decode_header *h)
> +{
> +	int imm = insn & 0xff;
> +	asi->stack_space = imm << 2;
> +	return INSN_GOOD_NO_SLOT;
> +}
> +#else
> +enum probes_insn checker_stack_use_imm_x0x(probes_opcode_t insn,
> +		struct arch_probes_insn *asi,
> +		const struct decode_header *h)
> +{
> +	int imm = ((insn & 0xf00) >> 4) + (insn & 0xf);
> +	asi->stack_space = imm;
> +	return INSN_GOOD_NO_SLOT;
> +}
> +#endif
> +
> +enum probes_insn checker_stack_use_imm_xxx(probes_opcode_t insn,
> +		struct arch_probes_insn *asi,
> +		const struct decode_header *h)
> +{
> +	int imm = insn & 0xfff;
> +	asi->stack_space = imm;
> +	return INSN_GOOD_NO_SLOT;
> +}
> +
> +enum probes_insn checker_stack_use_stmdx(probes_opcode_t insn,
> +		struct arch_probes_insn *asi,
> +		const struct decode_header *h)
> +{
> +	unsigned int reglist = insn & 0xffff;
> +	int pbit = insn & (1 << 24);
> +	asi->stack_space = (hweight32(reglist) - (!pbit ? 1 : 0)) * 4;
> +
> +	return INSN_GOOD_NO_SLOT;
> +}
> +
> +const union decode_action stack_check_actions[] = {
> +	[STACK_USE_NONE] = {.decoder = checker_stack_use_none},
> +	[STACK_USE_UNKNOWN] = {.decoder = checker_stack_use_unknown},
> +#ifdef CONFIG_THUMB2_KERNEL
> +	[STACK_USE_FIXED_0XX] = {.decoder = checker_stack_use_imm_0xx},
> +	[STACK_USE_T32STRD] = {.decoder = checker_stack_use_t32strd},
> +#else
> +	[STACK_USE_FIXED_X0X] = {.decoder = checker_stack_use_imm_x0x},
> +#endif
> +	[STACK_USE_FIXED_XXX] = {.decoder = checker_stack_use_imm_xxx},
> +	[STACK_USE_STMDX] = {.decoder = checker_stack_use_stmdx},
> +};
> diff --git a/arch/arm/kernel/probes-checkers-thumb.c b/arch/arm/kernel/probes-checkers-thumb.c
> new file mode 100644
> index 0000000..e43ac08
> --- /dev/null
> +++ b/arch/arm/kernel/probes-checkers-thumb.c
> @@ -0,0 +1,110 @@
> +/*
> + * arch/arm/kernel/probes-checkers-arm.c
> + *
> + * Copyright (C) 2014 Huawei Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + */
> +
> +#include <linux/kernel.h>
> +#include "probes.h"
> +#include "probes-thumb.h"
> +#include "probes-checkers.h"
> +
> +static enum probes_insn __kprobes t32_check_stack(probes_opcode_t insn,
> +		struct arch_probes_insn *asi,
> +		const struct decode_header *h)
> +{
> +	/*
> +	 * PROBES_T32_LDMSTM, PROBES_T32_LDRDSTRD and PROBES_T32_LDRSTR
> +	 * may get here. Simply mark all normal insns as STACK_USE_NONE.
> +	 */
> +	static const union decode_item table[] = {
> +
> +		/*
> +		 * First, filter out all ldr insns to make our life easier.
> +		 * Following load insns may come here:
> +		 * LDM, LDRD, LDR.
> +		 * In T32 encoding, bit 20 is enough for distinguishing
> +		 * load and store. All load insns have this bit set, when
> +		 * all store insns have this bit clear.
> +		 */
> +		DECODE_CUSTOM	(0x00100000, 0x00100000, STACK_USE_NONE),
> +
> +		/*
> +		 * Mark all 'STR{,B,H}, Rt, [Rn, Rm]' as STACK_USE_UNKNOWN
> +		 * if Rn or Rm is SP. T32 doesn't encode STRD.
> +		 */
> +		/*                                 xx | Rn | Rt |         | Rm |*/
> +		/* STR (register)	1111 1000 0100 xxxx xxxx 0000 00xx xxxx */
> +		/* STRB (register)	1111 1000 0000 xxxx xxxx 0000 00xx xxxx */
> +		/* STRH (register)	1111 1000 0010 xxxx xxxx 0000 00xx xxxx */
> +		/* INVALID INSN		1111 1000 0110 xxxx xxxx 0000 00xx xxxx */
> +		/* By Introducing INVALID INSN, bit 21 and 22 can be ignored. */
> +		DECODE_OR	(0xff9f0fc0, 0xf80d0000),
> +		DECODE_CUSTOM	(0xff900fcf, 0xf800000d, STACK_USE_UNKNOWN),
> +
> +
> +		/*                                 xx | Rn | Rt | PUW|   imm8  |*/
> +		/* STR (imm 8)		1111 1000 0100 1101 xxxx 110x xxxx xxxx */
> +		/* STRB (imm 8)		1111 1000 0000 1101 xxxx 110x xxxx xxxx */
> +		/* STRH (imm 8)		1111 1000 0010 1101 xxxx 110x xxxx xxxx */
> +		/* INVALID INSN		1111 1000 0110 1101 xxxx 110x xxxx xxxx */
> +		/* Only consider U == 0 and P == 1: strx rx, [sp, #-<imm>] */
> +		DECODE_CUSTOM	(0xff9f0e00, 0xf80d0c00, STACK_USE_FIXED_0XX),
> +
> +		/* For STR{,B,H} (imm 12), offset is always positive, so ignore them. */
> +
> +		/*                              P U W | Rn | Rt | Rt2|   imm8  |*/
> +		/* STRD (immediate)	1110 1001 01x0 1101 xxxx xxxx xxxx xxxx */
> +		/*
> +		 * Only consider U == 0 and P == 1.
> +		 * Also note that STRD in T32 encoding is special:
> +		 * imm = ZeroExtend(imm8:'00', 32)
> +		 */
> +		DECODE_CUSTOM	(0xffdf0000, 0xe94d0000, STACK_USE_T32STRD),
> +
> +		/*                                    | Rn | */
> +		/* STMDB		1110 1001 00x0 1101 xxxx xxxx xxxx xxxx */
> +		DECODE_CUSTOM	(0xffdf0000, 0xe90d0000, STACK_USE_STMDX),
> +
> +		/* fall through */
> +		DECODE_CUSTOM	(0, 0, STACK_USE_NONE),
> +		DECODE_END
> +	};
> +
> +	return probes_decode_insn(insn, asi, table, false, false, stack_check_actions, NULL);
> +}
> +
> +const struct decode_checker t32_stack_checker[NUM_PROBES_T32_ACTIONS] = {
> +	[PROBES_T32_LDMSTM] = {.checker = t32_check_stack},
> +	[PROBES_T32_LDRDSTRD] = {.checker = t32_check_stack},
> +	[PROBES_T32_LDRSTR] = {.checker = t32_check_stack},
> +};
> +
> +/*
> + * See following comments. This insn must be 'push'.
> + */
> +static enum probes_insn __kprobes t16_check_stack(probes_opcode_t insn,
> +		struct arch_probes_insn *asi,
> +		const struct decode_header *h)
> +{
> +	unsigned int reglist = insn & 0x1ff;
> +	asi->stack_space = hweight32(reglist) * 4;
> +	return INSN_GOOD;
> +}
> +
> +/*
> + * T16 encoding is simple: only the 'push' insn can need extra stack space.
> + * Other insns, like str, can only use r0-r7 as Rn.
> + */
> +const struct decode_checker t16_stack_checker[NUM_PROBES_T16_ACTIONS] = {
> +	[PROBES_T16_PUSH] = {.checker = t16_check_stack},
> +};
> diff --git a/arch/arm/kernel/probes-checkers.h b/arch/arm/kernel/probes-checkers.h
> new file mode 100644
> index 0000000..c92671b
> --- /dev/null
> +++ b/arch/arm/kernel/probes-checkers.h
> @@ -0,0 +1,54 @@
> +/*
> + * arch/arm/kernel/probes-checkers-common.c
> + *
> + * Copyright (C) 2014 Huawei Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + */
> +#ifndef _ARM_KERNEL_PROBES_CHECKERS_H
> +#define _ARM_KERNEL_PROBES_CHECKERS_H
> +
> +#include <linux/kernel.h>
> +#include <linux/types.h>
> +#include "probes.h"
> +
> +extern probes_check_t checker_stack_use_none;
> +extern probes_check_t checker_stack_use_unknown;
> +#ifdef CONFIG_THUMB2_KERNEL
> +extern probes_check_t checker_stack_use_imm_0xx;
> +#else
> +extern probes_check_t checker_stack_use_imm_x0x;
> +#endif
> +extern probes_check_t checker_stack_use_imm_xxx;
> +extern probes_check_t checker_stack_use_stmdx;
> +
> +enum {
> +	STACK_USE_NONE,
> +	STACK_USE_UNKNOWN,
> +#ifdef CONFIG_THUMB2_KERNEL
> +	STACK_USE_FIXED_0XX,
> +	STACK_USE_T32STRD,
> +#else
> +	STACK_USE_FIXED_X0X,
> +#endif
> +	STACK_USE_FIXED_XXX,
> +	STACK_USE_STMDX,
> +	NUM_STACK_USE_TYPES
> +};
> +
> +extern const union decode_action stack_check_actions[];
> +
> +#ifndef CONFIG_THUMB2_KERNEL
> +extern const struct decode_checker arm_stack_checker[];
> +#else
> +#endif
> +extern const struct decode_checker t32_stack_checker[];
> +extern const struct decode_checker t16_stack_checker[];
> +#endif
> diff --git a/arch/arm/kernel/probes.c b/arch/arm/kernel/probes.c
> index 6a7d92e..cc68986 100644
> --- a/arch/arm/kernel/probes.c
> +++ b/arch/arm/kernel/probes.c
> @@ -425,6 +425,16 @@ probes_decode_insn(probes_opcode_t insn, struct arch_probes_insn *asi,
>  	 */
>  	probes_opcode_t origin_insn = insn;
>  
> +	/*
> +	 * stack_space is initialized to 0 here. Checker functions
> +	 * should update is value if they find this is a stack store
> +	 * instruction: positive value means bytes of stack usage,
> +	 * negitive value means unable to determine stack usage
> +	 * statically. For instruction doesn't store to stack, checker
> +	 * do nothing with it.
> +	 */
> +	asi->stack_space = 0;
> +
>  	if (emulate)
>  		insn = prepare_emulated_insn(insn, asi, thumb);
>  
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


