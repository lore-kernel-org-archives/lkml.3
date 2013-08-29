Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab3H2OuR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 10:50:17 -0400
Received: from queue01a.mail.zen.net.uk ([212.23.3.234]:48642 "EHLO
	queue01a.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab3H2OuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 10:50:14 -0400
Message-ID: <1377785344.3529.38.camel@linaro1.home>
Subject: Re: [PATCH 8/9] ARM: Add "action" table for kprobes/uprobes
 instruction
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: David Long <dave.long@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
        linux-kernel@vger.kernel.org
Date: Thu, 29 Aug 2013 15:09:04 +0100
In-Reply-To: <1375400753-3454-9-git-send-email-dave.long@linaro.org>
References: <1375400753-3454-1-git-send-email-dave.long@linaro.org>
	 <1375400753-3454-9-git-send-email-dave.long@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01d-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-01 at 19:45 -0400, David Long wrote:
> From: "David A. Long" <dave.long@linaro.org>
> 
> Add a table of functions used by the (previously) kprobes instruction
> parsing code so that it can also be used by uprobes. kprobes and
> (eventually) uprobes will each provide their own unique table of
> actions for each category of instruction recognized by the parser.
> 
> Signed-off-by: David A. Long <dave.long@linaro.org>
> ---

This is rather difficult to follow and I think it would be a lot easier
to understand if if was broken down into separate steps. E.g.

- A step which introduces the action enumeration to replace the function
  pointer (what the commit message to this patch implies it's doing).
- A step to add the extra 'void *d' argument to the decode functions, though
  I think this should be 'struct decode_header' not void as that's clearer
  and should avoid any user having to cast it.
- A step to add the 'usermode' to probes_decode_insn, and 'modify' 
  to decode_regs

More specific comments about this patch are inline below....



>  arch/arm/kernel/kprobes-arm.c    | 188 +++++++++++++++++----------------
>  arch/arm/kernel/kprobes-common.c |   3 +-
>  arch/arm/kernel/kprobes-thumb.c  | 217 +++++++++++++++++++++++++--------------
>  arch/arm/kernel/kprobes.c        |  11 +-
>  arch/arm/kernel/kprobes.h        |  64 ++++++------
>  arch/arm/kernel/probes-arm.c     |   2 +-
>  arch/arm/kernel/probes-arm.h     |  60 +++++++++++
>  arch/arm/kernel/probes-thumb.h   |  59 +++++++++++
>  arch/arm/kernel/probes.c         |  99 ++++++++++++------
>  arch/arm/kernel/probes.h         |  12 +++
>  10 files changed, 488 insertions(+), 227 deletions(-)
>  create mode 100644 arch/arm/kernel/probes-arm.h
>  create mode 100644 arch/arm/kernel/probes-thumb.h
> 
> diff --git a/arch/arm/kernel/kprobes-arm.c b/arch/arm/kernel/kprobes-arm.c
> index d6503cc..0620eba 100644
> --- a/arch/arm/kernel/kprobes-arm.c
> +++ b/arch/arm/kernel/kprobes-arm.c
> @@ -62,38 +62,50 @@
>  #include <linux/kprobes.h>
>  #include <linux/module.h>
>  
> -#include "probes.h"
>  #include "kprobes.h"
> -
> -/*
> - * To avoid the complications of mimicing single-stepping on a
> - * processor without a Next-PC or a single-step mode, and to
> - * avoid having to deal with the side-effects of boosting, we
> - * simulate or emulate (almost) all ARM instructions.
> - *
> - * "Simulation" is where the instruction's behavior is duplicated in
> - * C code.  "Emulation" is where the original instruction is rewritten
> - * and executed, often by altering its registers.
> - *
> - * By having all behavior of the kprobe'd instruction completed before
> - * returning from the kprobe_handler(), all locks (scheduler and
> - * interrupt) can safely be released.  There is no need for secondary
> - * breakpoints, no race with MP or preemptable kernels, nor having to
> - * clean up resources counts at a later time impacting overall system
> - * performance.  By rewriting the instruction, only the minimum registers
> - * need to be loaded and saved back optimizing performance.
> - *
> - * Calling the insnslot_*_rwflags version of a function doesn't hurt
> - * anything even when the CPSR flags aren't updated by the
> - * instruction.  It's just a little slower in return for saving
> - * a little space by not having a duplicate function that doesn't
> - * update the flags.  (The same optimization can be said for
> - * instructions that do or don't perform register writeback)
> - * Also, instructions can either read the flags, only write the
> - * flags, or read and write the flags.  To save combinations
> - * rather than for sheer performance, flag functions just assume
> - * read and write of flags.
> - */

Any reason to delete the above comment? I think it is still relevant and
has useful rational in.

> +#include "probes.h"
> +#include "probes-arm.h"
> +
> +const union decode_item kprobes_probes_actions[] = {

I think it's best if we don't reuse the decode_item type here, this is a
different sort of table so probably best to have it's own union. Also,
if we do that, then decode_item can be simplified as it won't need to
have function pointers in it, i.e. we could end up with...

typedef enum kprobe_insn (kprobe_custom_decode_t)(kprobe_opcode_t,
						  struct arch_specific_insn *,
						  void *);

union decode_action {
	kprobe_insn_handler_t	*handler;
	kprobe_custom_decode_t	*decoder;
};

union decode_item {
	u32			bits;
	const union decode_item	*table;
};



> +	[PROBES_EMULATE_NONE] = {.handler = probes_emulate_none},
> +	[PROBES_SIMULATE_NOP] = {.handler = probes_simulate_nop},
> +	[PROBES_PRELOAD_IMM] = {.handler = probes_simulate_nop},
> +	[PROBES_PRELOAD_REG] = {.handler = probes_simulate_nop},
> +	[PROBES_BRANCH_IMM] = {.handler = simulate_blx1},
> +	[PROBES_MRS] = {.handler = simulate_mrs},
> +	[PROBES_BRANCH_REG] = {.handler = simulate_blx2bx},
> +	[PROBES_CLZ] = {.handler = emulate_rd12rm0_noflags_nopc},
> +	[PROBES_SATURATING_ARITHMETIC] = {
> +		.handler = emulate_rd12rn16rm0_rwflags_nopc},
> +	[PROBES_MUL1] = {.handler = emulate_rdlo12rdhi16rn0rm8_rwflags_nopc},
> +	[PROBES_MUL2] = {.handler = emulate_rd16rn12rm0rs8_rwflags_nopc},
> +	[PROBES_SWP] = {.handler = emulate_rd12rn16rm0_rwflags_nopc},
> +	[PROBES_LDRSTRD] = {.handler = emulate_ldrdstrd},
> +	[PROBES_LOAD_EXTRA] = {.handler = emulate_ldr},
> +	[PROBES_LOAD] = {.handler = emulate_ldr},
> +	[PROBES_STORE_EXTRA] = {.handler = emulate_str},
> +	[PROBES_STORE] = {.handler = emulate_str},
> +	[PROBES_MOV_IP_SP] = {.handler = simulate_mov_ipsp},
> +	[PROBES_DATA_PROCESSING_REG] = {
> +		.handler = emulate_rd12rn16rm0rs8_rwflags},
> +	[PROBES_DATA_PROCESSING_IMM] = {
> +		.handler = emulate_rd12rn16rm0rs8_rwflags},
> +	[PROBES_MOV_HALFWORD] = {.handler = emulate_rd12rm0_noflags_nopc},
> +	[PROBES_SEV] = {.handler = probes_emulate_none},
> +	[PROBES_WFE] = {.handler = probes_simulate_nop},
> +	[PROBES_SATURATE] = {.handler = emulate_rd12rn16rm0_rwflags_nopc},
> +	[PROBES_REV] = {.handler = emulate_rd12rm0_noflags_nopc},
> +	[PROBES_MMI] = {.handler = emulate_rd12rn16rm0_rwflags_nopc},
> +	[PROBES_PACK] = {.handler = emulate_rd12rn16rm0_rwflags_nopc},
> +	[PROBES_EXTEND] = {.handler = emulate_rd12rm0_noflags_nopc},
> +	[PROBES_EXTEND_ADD] = {.handler = emulate_rd12rn16rm0_rwflags_nopc},
> +	[PROBES_MUL_ADD_LONG] = {
> +		.handler = emulate_rdlo12rdhi16rn0rm8_rwflags_nopc},
> +	[PROBES_MUL_ADD] = {.handler = emulate_rd16rn12rm0rs8_rwflags_nopc},
> +	[PROBES_BITFIELD] = {.handler = emulate_rd12rm0_noflags_nopc},
> +	[PROBES_BRANCH] = {.handler = simulate_bbl},
> +	[PROBES_LDMSTM] = {.decoder = kprobe_decode_ldmstm}
> +};
>  
>  /*
>   * For the instruction masking and comparisons in all the "space_*"
> @@ -112,16 +124,16 @@ static const union decode_item arm_1111_table[] = {
>  	/* PLDI (immediate)	1111 0100 x101 xxxx xxxx xxxx xxxx xxxx */
>  	/* PLDW (immediate)	1111 0101 x001 xxxx xxxx xxxx xxxx xxxx */
>  	/* PLD (immediate)	1111 0101 x101 xxxx xxxx xxxx xxxx xxxx */
> -	DECODE_SIMULATE	(0xfe300000, 0xf4100000, probes_simulate_nop),
> +	DECODE_SIMULATE	(0xfe300000, 0xf4100000, PROBES_PRELOAD_IMM),
>  
>  	/* memory hint		1111 0110 x001 xxxx xxxx xxxx xxx0 xxxx */
>  	/* PLDI (register)	1111 0110 x101 xxxx xxxx xxxx xxx0 xxxx */
>  	/* PLDW (register)	1111 0111 x001 xxxx xxxx xxxx xxx0 xxxx */
>  	/* PLD (register)	1111 0111 x101 xxxx xxxx xxxx xxx0 xxxx */
> -	DECODE_SIMULATE	(0xfe300010, 0xf6100000, probes_simulate_nop),
> +	DECODE_SIMULATE	(0xfe300010, 0xf6100000, PROBES_PRELOAD_REG),
>  
>  	/* BLX (immediate)	1111 101x xxxx xxxx xxxx xxxx xxxx xxxx */
> -	DECODE_SIMULATE	(0xfe000000, 0xfa000000, simulate_blx1),
> +	DECODE_SIMULATE	(0xfe000000, 0xfa000000, PROBES_BRANCH_IMM),
>  
>  	/* CPS			1111 0001 0000 xxx0 xxxx xxxx xx0x xxxx */
>  	/* SETEND		1111 0001 0000 0001 xxxx xxxx 0000 xxxx */
> @@ -145,25 +157,25 @@ static const union decode_item arm_cccc_0001_0xx0____0xxx_table[] = {
>  	/* Miscellaneous instructions					*/
>  
>  	/* MRS cpsr		cccc 0001 0000 xxxx xxxx xxxx 0000 xxxx */
> -	DECODE_SIMULATEX(0x0ff000f0, 0x01000000, simulate_mrs,
> +	DECODE_SIMULATEX(0x0ff000f0, 0x01000000, PROBES_MRS,
>  						 REGS(0, NOPC, 0, 0, 0)),
>  
>  	/* BX			cccc 0001 0010 xxxx xxxx xxxx 0001 xxxx */
> -	DECODE_SIMULATE	(0x0ff000f0, 0x01200010, simulate_blx2bx),
> +	DECODE_SIMULATE	(0x0ff000f0, 0x01200010, PROBES_BRANCH_REG),
>  
>  	/* BLX (register)	cccc 0001 0010 xxxx xxxx xxxx 0011 xxxx */
> -	DECODE_SIMULATEX(0x0ff000f0, 0x01200030, simulate_blx2bx,
> +	DECODE_SIMULATEX(0x0ff000f0, 0x01200030, PROBES_BRANCH_REG,
>  						 REGS(0, 0, 0, 0, NOPC)),
>  
>  	/* CLZ			cccc 0001 0110 xxxx xxxx xxxx 0001 xxxx */
> -	DECODE_EMULATEX	(0x0ff000f0, 0x01600010, emulate_rd12rm0_noflags_nopc,
> +	DECODE_EMULATEX	(0x0ff000f0, 0x01600010, PROBES_CLZ,
>  						 REGS(0, NOPC, 0, 0, NOPC)),
>  
>  	/* QADD			cccc 0001 0000 xxxx xxxx xxxx 0101 xxxx */
>  	/* QSUB			cccc 0001 0010 xxxx xxxx xxxx 0101 xxxx */
>  	/* QDADD		cccc 0001 0100 xxxx xxxx xxxx 0101 xxxx */
>  	/* QDSUB		cccc 0001 0110 xxxx xxxx xxxx 0101 xxxx */
> -	DECODE_EMULATEX	(0x0f9000f0, 0x01000050, emulate_rd12rn16rm0_rwflags_nopc,
> +	DECODE_EMULATEX	(0x0f9000f0, 0x01000050, PROBES_SATURATING_ARITHMETIC,
>  						 REGS(NOPC, NOPC, 0, 0, NOPC)),
>  
>  	/* BXJ			cccc 0001 0010 xxxx xxxx xxxx 0010 xxxx */
> @@ -179,19 +191,19 @@ static const union decode_item arm_cccc_0001_0xx0____1xx0_table[] = {
>  	/* Halfword multiply and multiply-accumulate			*/
>  
>  	/* SMLALxy		cccc 0001 0100 xxxx xxxx xxxx 1xx0 xxxx */
> -	DECODE_EMULATEX	(0x0ff00090, 0x01400080, emulate_rdlo12rdhi16rn0rm8_rwflags_nopc,
> +	DECODE_EMULATEX	(0x0ff00090, 0x01400080, PROBES_MUL1,
>  						 REGS(NOPC, NOPC, NOPC, 0, NOPC)),
>  
>  	/* SMULWy		cccc 0001 0010 xxxx xxxx xxxx 1x10 xxxx */
>  	DECODE_OR	(0x0ff000b0, 0x012000a0),
>  	/* SMULxy		cccc 0001 0110 xxxx xxxx xxxx 1xx0 xxxx */
> -	DECODE_EMULATEX	(0x0ff00090, 0x01600080, emulate_rd16rn12rm0rs8_rwflags_nopc,
> +	DECODE_EMULATEX	(0x0ff00090, 0x01600080, PROBES_MUL2,
>  						 REGS(NOPC, 0, NOPC, 0, NOPC)),
>  
>  	/* SMLAxy		cccc 0001 0000 xxxx xxxx xxxx 1xx0 xxxx */
>  	DECODE_OR	(0x0ff00090, 0x01000080),
>  	/* SMLAWy		cccc 0001 0010 xxxx xxxx xxxx 1x00 xxxx */
> -	DECODE_EMULATEX	(0x0ff000b0, 0x01200080, emulate_rd16rn12rm0rs8_rwflags_nopc,
> +	DECODE_EMULATEX	(0x0ff000b0, 0x01200080, PROBES_MUL2,
>  						 REGS(NOPC, NOPC, NOPC, 0, NOPC)),
>  
>  	DECODE_END
> @@ -202,14 +214,14 @@ static const union decode_item arm_cccc_0000_____1001_table[] = {
>  
>  	/* MUL			cccc 0000 0000 xxxx xxxx xxxx 1001 xxxx */
>  	/* MULS			cccc 0000 0001 xxxx xxxx xxxx 1001 xxxx */
> -	DECODE_EMULATEX	(0x0fe000f0, 0x00000090, emulate_rd16rn12rm0rs8_rwflags_nopc,
> +	DECODE_EMULATEX	(0x0fe000f0, 0x00000090, PROBES_MUL2,
>  						 REGS(NOPC, 0, NOPC, 0, NOPC)),
>  
>  	/* MLA			cccc 0000 0010 xxxx xxxx xxxx 1001 xxxx */
>  	/* MLAS			cccc 0000 0011 xxxx xxxx xxxx 1001 xxxx */
>  	DECODE_OR	(0x0fe000f0, 0x00200090),
>  	/* MLS			cccc 0000 0110 xxxx xxxx xxxx 1001 xxxx */
> -	DECODE_EMULATEX	(0x0ff000f0, 0x00600090, emulate_rd16rn12rm0rs8_rwflags_nopc,
> +	DECODE_EMULATEX	(0x0ff000f0, 0x00600090, PROBES_MUL2,
>  						 REGS(NOPC, NOPC, NOPC, 0, NOPC)),
>  
>  	/* UMAAL		cccc 0000 0100 xxxx xxxx xxxx 1001 xxxx */
> @@ -222,7 +234,7 @@ static const union decode_item arm_cccc_0000_____1001_table[] = {
>  	/* SMULLS		cccc 0000 1101 xxxx xxxx xxxx 1001 xxxx */
>  	/* SMLAL		cccc 0000 1110 xxxx xxxx xxxx 1001 xxxx */
>  	/* SMLALS		cccc 0000 1111 xxxx xxxx xxxx 1001 xxxx */
> -	DECODE_EMULATEX	(0x0f8000f0, 0x00800090, emulate_rdlo12rdhi16rn0rm8_rwflags_nopc,
> +	DECODE_EMULATEX	(0x0f8000f0, 0x00800090, PROBES_MUL1,
>  						 REGS(NOPC, NOPC, NOPC, 0, NOPC)),
>  
>  	DECODE_END
> @@ -234,7 +246,7 @@ static const union decode_item arm_cccc_0001_____1001_table[] = {
>  #if __LINUX_ARM_ARCH__ < 6
>  	/* Deprecated on ARMv6 and may be UNDEFINED on v7		*/
>  	/* SMP/SWPB		cccc 0001 0x00 xxxx xxxx xxxx 1001 xxxx */
> -	DECODE_EMULATEX	(0x0fb000f0, 0x01000090, emulate_rd12rn16rm0_rwflags_nopc,
> +	DECODE_EMULATEX	(0x0fb000f0, 0x01000090, PROBES_SWP,
>  						 REGS(NOPC, NOPC, 0, 0, NOPC)),
>  #endif
>  	/* LDREX/STREX{,D,B,H}	cccc 0001 1xxx xxxx xxxx xxxx 1001 xxxx */
> @@ -257,32 +269,32 @@ static const union decode_item arm_cccc_000x_____1xx1_table[] = {
>  
>  	/* LDRD (register)	cccc 000x x0x0 xxxx xxxx xxxx 1101 xxxx */
>  	/* STRD (register)	cccc 000x x0x0 xxxx xxxx xxxx 1111 xxxx */
> -	DECODE_EMULATEX	(0x0e5000d0, 0x000000d0, emulate_ldrdstrd,
> +	DECODE_EMULATEX	(0x0e5000d0, 0x000000d0, PROBES_LDRSTRD,
>  						 REGS(NOPCWB, NOPCX, 0, 0, NOPC)),
>  
>  	/* LDRD (immediate)	cccc 000x x1x0 xxxx xxxx xxxx 1101 xxxx */
>  	/* STRD (immediate)	cccc 000x x1x0 xxxx xxxx xxxx 1111 xxxx */
> -	DECODE_EMULATEX	(0x0e5000d0, 0x004000d0, emulate_ldrdstrd,
> +	DECODE_EMULATEX	(0x0e5000d0, 0x004000d0, PROBES_LDRSTRD,
>  						 REGS(NOPCWB, NOPCX, 0, 0, 0)),
>  
>  	/* STRH (register)	cccc 000x x0x0 xxxx xxxx xxxx 1011 xxxx */
> -	DECODE_EMULATEX	(0x0e5000f0, 0x000000b0, emulate_str,
> +	DECODE_EMULATEX	(0x0e5000f0, 0x000000b0, PROBES_STORE_EXTRA,
>  						 REGS(NOPCWB, NOPC, 0, 0, NOPC)),
>  
>  	/* LDRH (register)	cccc 000x x0x1 xxxx xxxx xxxx 1011 xxxx */
>  	/* LDRSB (register)	cccc 000x x0x1 xxxx xxxx xxxx 1101 xxxx */
>  	/* LDRSH (register)	cccc 000x x0x1 xxxx xxxx xxxx 1111 xxxx */
> -	DECODE_EMULATEX	(0x0e500090, 0x00100090, emulate_ldr,
> +	DECODE_EMULATEX	(0x0e500090, 0x00100090, PROBES_LOAD_EXTRA,
>  						 REGS(NOPCWB, NOPC, 0, 0, NOPC)),
>  
>  	/* STRH (immediate)	cccc 000x x1x0 xxxx xxxx xxxx 1011 xxxx */
> -	DECODE_EMULATEX	(0x0e5000f0, 0x004000b0, emulate_str,
> +	DECODE_EMULATEX	(0x0e5000f0, 0x004000b0, PROBES_STORE_EXTRA,
>  						 REGS(NOPCWB, NOPC, 0, 0, 0)),
>  
>  	/* LDRH (immediate)	cccc 000x x1x1 xxxx xxxx xxxx 1011 xxxx */
>  	/* LDRSB (immediate)	cccc 000x x1x1 xxxx xxxx xxxx 1101 xxxx */
>  	/* LDRSH (immediate)	cccc 000x x1x1 xxxx xxxx xxxx 1111 xxxx */
> -	DECODE_EMULATEX	(0x0e500090, 0x00500090, emulate_ldr,
> +	DECODE_EMULATEX	(0x0e500090, 0x00500090, PROBES_LOAD_EXTRA,
>  						 REGS(NOPCWB, NOPC, 0, 0, 0)),
>  
>  	DECODE_END
> @@ -295,18 +307,18 @@ static const union decode_item arm_cccc_000x_table[] = {
>  	DECODE_REJECT	(0x0e10f000, 0x0010f000),
>  
>  	/* MOV IP, SP		1110 0001 1010 0000 1100 0000 0000 1101 */
> -	DECODE_SIMULATE	(0xffffffff, 0xe1a0c00d, simulate_mov_ipsp),
> +	DECODE_SIMULATE	(0xffffffff, 0xe1a0c00d, PROBES_MOV_IP_SP),
>  
>  	/* TST (register)	cccc 0001 0001 xxxx xxxx xxxx xxx0 xxxx */
>  	/* TEQ (register)	cccc 0001 0011 xxxx xxxx xxxx xxx0 xxxx */
>  	/* CMP (register)	cccc 0001 0101 xxxx xxxx xxxx xxx0 xxxx */
>  	/* CMN (register)	cccc 0001 0111 xxxx xxxx xxxx xxx0 xxxx */
> -	DECODE_EMULATEX	(0x0f900010, 0x01100000, emulate_rd12rn16rm0rs8_rwflags,
> +	DECODE_EMULATEX	(0x0f900010, 0x01100000, PROBES_DATA_PROCESSING_REG,
>  						 REGS(ANY, 0, 0, 0, ANY)),
>  
>  	/* MOV (register)	cccc 0001 101x xxxx xxxx xxxx xxx0 xxxx */
>  	/* MVN (register)	cccc 0001 111x xxxx xxxx xxxx xxx0 xxxx */
> -	DECODE_EMULATEX	(0x0fa00010, 0x01a00000, emulate_rd12rn16rm0rs8_rwflags,
> +	DECODE_EMULATEX	(0x0fa00010, 0x01a00000, PROBES_DATA_PROCESSING_REG,
>  						 REGS(0, ANY, 0, 0, ANY)),
>  
>  	/* AND (register)	cccc 0000 000x xxxx xxxx xxxx xxx0 xxxx */
> @@ -319,19 +331,19 @@ static const union decode_item arm_cccc_000x_table[] = {
>  	/* RSC (register)	cccc 0000 111x xxxx xxxx xxxx xxx0 xxxx */
>  	/* ORR (register)	cccc 0001 100x xxxx xxxx xxxx xxx0 xxxx */
>  	/* BIC (register)	cccc 0001 110x xxxx xxxx xxxx xxx0 xxxx */
> -	DECODE_EMULATEX	(0x0e000010, 0x00000000, emulate_rd12rn16rm0rs8_rwflags,
> +	DECODE_EMULATEX	(0x0e000010, 0x00000000, PROBES_DATA_PROCESSING_REG,
>  						 REGS(ANY, ANY, 0, 0, ANY)),
>  
>  	/* TST (reg-shift reg)	cccc 0001 0001 xxxx xxxx xxxx 0xx1 xxxx */
>  	/* TEQ (reg-shift reg)	cccc 0001 0011 xxxx xxxx xxxx 0xx1 xxxx */
>  	/* CMP (reg-shift reg)	cccc 0001 0101 xxxx xxxx xxxx 0xx1 xxxx */
>  	/* CMN (reg-shift reg)	cccc 0001 0111 xxxx xxxx xxxx 0xx1 xxxx */
> -	DECODE_EMULATEX	(0x0f900090, 0x01100010, emulate_rd12rn16rm0rs8_rwflags,
> +	DECODE_EMULATEX	(0x0f900090, 0x01100010, PROBES_DATA_PROCESSING_REG,
>  						 REGS(ANY, 0, NOPC, 0, ANY)),
>  
>  	/* MOV (reg-shift reg)	cccc 0001 101x xxxx xxxx xxxx 0xx1 xxxx */
>  	/* MVN (reg-shift reg)	cccc 0001 111x xxxx xxxx xxxx 0xx1 xxxx */
> -	DECODE_EMULATEX	(0x0fa00090, 0x01a00010, emulate_rd12rn16rm0rs8_rwflags,
> +	DECODE_EMULATEX	(0x0fa00090, 0x01a00010, PROBES_DATA_PROCESSING_REG,
>  						 REGS(0, ANY, NOPC, 0, ANY)),
>  
>  	/* AND (reg-shift reg)	cccc 0000 000x xxxx xxxx xxxx 0xx1 xxxx */
> @@ -344,7 +356,7 @@ static const union decode_item arm_cccc_000x_table[] = {
>  	/* RSC (reg-shift reg)	cccc 0000 111x xxxx xxxx xxxx 0xx1 xxxx */
>  	/* ORR (reg-shift reg)	cccc 0001 100x xxxx xxxx xxxx 0xx1 xxxx */
>  	/* BIC (reg-shift reg)	cccc 0001 110x xxxx xxxx xxxx 0xx1 xxxx */
> -	DECODE_EMULATEX	(0x0e000090, 0x00000010, emulate_rd12rn16rm0rs8_rwflags,
> +	DECODE_EMULATEX	(0x0e000090, 0x00000010, PROBES_DATA_PROCESSING_REG,
>  						 REGS(ANY, ANY, NOPC, 0, ANY)),
>  
>  	DECODE_END
> @@ -355,17 +367,17 @@ static const union decode_item arm_cccc_001x_table[] = {
>  
>  	/* MOVW			cccc 0011 0000 xxxx xxxx xxxx xxxx xxxx */
>  	/* MOVT			cccc 0011 0100 xxxx xxxx xxxx xxxx xxxx */
> -	DECODE_EMULATEX	(0x0fb00000, 0x03000000, emulate_rd12rm0_noflags_nopc,
> +	DECODE_EMULATEX	(0x0fb00000, 0x03000000, PROBES_DATA_PROCESSING_IMM,
>  						 REGS(0, NOPC, 0, 0, 0)),
>  
>  	/* YIELD		cccc 0011 0010 0000 xxxx xxxx 0000 0001 */
>  	DECODE_OR	(0x0fff00ff, 0x03200001),
>  	/* SEV			cccc 0011 0010 0000 xxxx xxxx 0000 0100 */
> -	DECODE_EMULATE	(0x0fff00ff, 0x03200004, probes_emulate_none),
> +	DECODE_EMULATE	(0x0fff00ff, 0x03200004, PROBES_EMULATE_NONE),
>  	/* NOP			cccc 0011 0010 0000 xxxx xxxx 0000 0000 */
>  	/* WFE			cccc 0011 0010 0000 xxxx xxxx 0000 0010 */
>  	/* WFI			cccc 0011 0010 0000 xxxx xxxx 0000 0011 */
> -	DECODE_SIMULATE	(0x0fff00fc, 0x03200000, probes_simulate_nop),
> +	DECODE_SIMULATE	(0x0fff00fc, 0x03200000, PROBES_SIMULATE_NOP),
>  	/* DBG			cccc 0011 0010 0000 xxxx xxxx ffff xxxx */
>  	/* unallocated hints	cccc 0011 0010 0000 xxxx xxxx xxxx xxxx */
>  	/* MSR (immediate)	cccc 0011 0x10 xxxx xxxx xxxx xxxx xxxx */
> @@ -378,12 +390,12 @@ static const union decode_item arm_cccc_001x_table[] = {
>  	/* TEQ (immediate)	cccc 0011 0011 xxxx xxxx xxxx xxxx xxxx */
>  	/* CMP (immediate)	cccc 0011 0101 xxxx xxxx xxxx xxxx xxxx */
>  	/* CMN (immediate)	cccc 0011 0111 xxxx xxxx xxxx xxxx xxxx */
> -	DECODE_EMULATEX	(0x0f900000, 0x03100000, emulate_rd12rn16rm0rs8_rwflags,
> +	DECODE_EMULATEX	(0x0f900000, 0x03100000, PROBES_DATA_PROCESSING_IMM,
>  						 REGS(ANY, 0, 0, 0, 0)),
>  
>  	/* MOV (immediate)	cccc 0011 101x xxxx xxxx xxxx xxxx xxxx */
>  	/* MVN (immediate)	cccc 0011 111x xxxx xxxx xxxx xxxx xxxx */
> -	DECODE_EMULATEX	(0x0fa00000, 0x03a00000, emulate_rd12rn16rm0rs8_rwflags,
> +	DECODE_EMULATEX	(0x0fa00000, 0x03a00000, PROBES_DATA_PROCESSING_IMM,
>  						 REGS(0, ANY, 0, 0, 0)),
>  
>  	/* AND (immediate)	cccc 0010 000x xxxx xxxx xxxx xxxx xxxx */
> @@ -396,7 +408,7 @@ static const union decode_item arm_cccc_001x_table[] = {
>  	/* RSC (immediate)	cccc 0010 111x xxxx xxxx xxxx xxxx xxxx */
>  	/* ORR (immediate)	cccc 0011 100x xxxx xxxx xxxx xxxx xxxx */
>  	/* BIC (immediate)	cccc 0011 110x xxxx xxxx xxxx xxxx xxxx */
> -	DECODE_EMULATEX	(0x0e000000, 0x02000000, emulate_rd12rn16rm0rs8_rwflags,
> +	DECODE_EMULATEX	(0x0e000000, 0x02000000, PROBES_DATA_PROCESSING_IMM,
>  						 REGS(ANY, ANY, 0, 0, 0)),
>  
>  	DECODE_END
> @@ -406,7 +418,7 @@ static const union decode_item arm_cccc_0110_____xxx1_table[] = {
>  	/* Media instructions						*/
>  
>  	/* SEL			cccc 0110 1000 xxxx xxxx xxxx 1011 xxxx */
> -	DECODE_EMULATEX	(0x0ff000f0, 0x068000b0, emulate_rd12rn16rm0_rwflags_nopc,
> +	DECODE_EMULATEX	(0x0ff000f0, 0x068000b0, PROBES_SATURATE,
>  						 REGS(NOPC, NOPC, 0, 0, NOPC)),
>  
>  	/* SSAT			cccc 0110 101x xxxx xxxx xxxx xx01 xxxx */
> @@ -414,14 +426,14 @@ static const union decode_item arm_cccc_0110_____xxx1_table[] = {
>  	DECODE_OR(0x0fa00030, 0x06a00010),
>  	/* SSAT16		cccc 0110 1010 xxxx xxxx xxxx 0011 xxxx */
>  	/* USAT16		cccc 0110 1110 xxxx xxxx xxxx 0011 xxxx */
> -	DECODE_EMULATEX	(0x0fb000f0, 0x06a00030, emulate_rd12rn16rm0_rwflags_nopc,
> +	DECODE_EMULATEX	(0x0fb000f0, 0x06a00030, PROBES_SATURATE,
>  						 REGS(0, NOPC, 0, 0, NOPC)),
>  
>  	/* REV			cccc 0110 1011 xxxx xxxx xxxx 0011 xxxx */
>  	/* REV16		cccc 0110 1011 xxxx xxxx xxxx 1011 xxxx */
>  	/* RBIT			cccc 0110 1111 xxxx xxxx xxxx 0011 xxxx */
>  	/* REVSH		cccc 0110 1111 xxxx xxxx xxxx 1011 xxxx */
> -	DECODE_EMULATEX	(0x0fb00070, 0x06b00030, emulate_rd12rm0_noflags_nopc,
> +	DECODE_EMULATEX	(0x0fb00070, 0x06b00030, PROBES_REV,
>  						 REGS(0, NOPC, 0, 0, NOPC)),
>  
>  	/* ???			cccc 0110 0x00 xxxx xxxx xxxx xxx1 xxxx */
> @@ -466,12 +478,12 @@ static const union decode_item arm_cccc_0110_____xxx1_table[] = {
>  	/* UHSUB16		cccc 0110 0111 xxxx xxxx xxxx 0111 xxxx */
>  	/* UHADD8		cccc 0110 0111 xxxx xxxx xxxx 1001 xxxx */
>  	/* UHSUB8		cccc 0110 0111 xxxx xxxx xxxx 1111 xxxx */
> -	DECODE_EMULATEX	(0x0f800010, 0x06000010, emulate_rd12rn16rm0_rwflags_nopc,
> +	DECODE_EMULATEX	(0x0f800010, 0x06000010, PROBES_MMI,
>  						 REGS(NOPC, NOPC, 0, 0, NOPC)),
>  
>  	/* PKHBT		cccc 0110 1000 xxxx xxxx xxxx x001 xxxx */
>  	/* PKHTB		cccc 0110 1000 xxxx xxxx xxxx x101 xxxx */
> -	DECODE_EMULATEX	(0x0ff00030, 0x06800010, emulate_rd12rn16rm0_rwflags_nopc,
> +	DECODE_EMULATEX	(0x0ff00030, 0x06800010, PROBES_PACK,
>  						 REGS(NOPC, NOPC, 0, 0, NOPC)),
>  
>  	/* ???			cccc 0110 1001 xxxx xxxx xxxx 0111 xxxx */
> @@ -484,7 +496,7 @@ static const union decode_item arm_cccc_0110_____xxx1_table[] = {
>  	/* UXTB16		cccc 0110 1100 1111 xxxx xxxx 0111 xxxx */
>  	/* UXTB			cccc 0110 1110 1111 xxxx xxxx 0111 xxxx */
>  	/* UXTH			cccc 0110 1111 1111 xxxx xxxx 0111 xxxx */
> -	DECODE_EMULATEX	(0x0f8f00f0, 0x068f0070, emulate_rd12rm0_noflags_nopc,
> +	DECODE_EMULATEX	(0x0f8f00f0, 0x068f0070, PROBES_EXTEND,
>  						 REGS(0, NOPC, 0, 0, NOPC)),
>  
>  	/* SXTAB16		cccc 0110 1000 xxxx xxxx xxxx 0111 xxxx */
> @@ -493,7 +505,7 @@ static const union decode_item arm_cccc_0110_____xxx1_table[] = {
>  	/* UXTAB16		cccc 0110 1100 xxxx xxxx xxxx 0111 xxxx */
>  	/* UXTAB		cccc 0110 1110 xxxx xxxx xxxx 0111 xxxx */
>  	/* UXTAH		cccc 0110 1111 xxxx xxxx xxxx 0111 xxxx */
> -	DECODE_EMULATEX	(0x0f8000f0, 0x06800070, emulate_rd12rn16rm0_rwflags_nopc,
> +	DECODE_EMULATEX	(0x0f8000f0, 0x06800070, PROBES_EXTEND_ADD,
>  						 REGS(NOPCX, NOPC, 0, 0, NOPC)),
>  
>  	DECODE_END
> @@ -507,7 +519,7 @@ static const union decode_item arm_cccc_0111_____xxx1_table[] = {
>  
>  	/* SMLALD		cccc 0111 0100 xxxx xxxx xxxx 00x1 xxxx */
>  	/* SMLSLD		cccc 0111 0100 xxxx xxxx xxxx 01x1 xxxx */
> -	DECODE_EMULATEX	(0x0ff00090, 0x07400010, emulate_rdlo12rdhi16rn0rm8_rwflags_nopc,
> +	DECODE_EMULATEX	(0x0ff00090, 0x07400010, PROBES_MUL_ADD_LONG,
>  						 REGS(NOPC, NOPC, NOPC, 0, NOPC)),
>  
>  	/* SMUAD		cccc 0111 0000 xxxx 1111 xxxx 00x1 xxxx */
> @@ -516,7 +528,7 @@ static const union decode_item arm_cccc_0111_____xxx1_table[] = {
>  	/* SMMUL		cccc 0111 0101 xxxx 1111 xxxx 00x1 xxxx */
>  	DECODE_OR	(0x0ff0f0d0, 0x0750f010),
>  	/* USAD8		cccc 0111 1000 xxxx 1111 xxxx 0001 xxxx */
> -	DECODE_EMULATEX	(0x0ff0f0f0, 0x0780f010, emulate_rd16rn12rm0rs8_rwflags_nopc,
> +	DECODE_EMULATEX	(0x0ff0f0f0, 0x0780f010, PROBES_MUL_ADD,
>  						 REGS(NOPC, 0, NOPC, 0, NOPC)),
>  
>  	/* SMLAD		cccc 0111 0000 xxxx xxxx xxxx 00x1 xxxx */
> @@ -525,24 +537,24 @@ static const union decode_item arm_cccc_0111_____xxx1_table[] = {
>  	/* SMMLA		cccc 0111 0101 xxxx xxxx xxxx 00x1 xxxx */
>  	DECODE_OR	(0x0ff000d0, 0x07500010),
>  	/* USADA8		cccc 0111 1000 xxxx xxxx xxxx 0001 xxxx */
> -	DECODE_EMULATEX	(0x0ff000f0, 0x07800010, emulate_rd16rn12rm0rs8_rwflags_nopc,
> +	DECODE_EMULATEX	(0x0ff000f0, 0x07800010, PROBES_MUL_ADD,
>  						 REGS(NOPC, NOPCX, NOPC, 0, NOPC)),
>  
>  	/* SMMLS		cccc 0111 0101 xxxx xxxx xxxx 11x1 xxxx */
> -	DECODE_EMULATEX	(0x0ff000d0, 0x075000d0, emulate_rd16rn12rm0rs8_rwflags_nopc,
> +	DECODE_EMULATEX	(0x0ff000d0, 0x075000d0, PROBES_MUL_ADD,
>  						 REGS(NOPC, NOPC, NOPC, 0, NOPC)),
>  
>  	/* SBFX			cccc 0111 101x xxxx xxxx xxxx x101 xxxx */
>  	/* UBFX			cccc 0111 111x xxxx xxxx xxxx x101 xxxx */
> -	DECODE_EMULATEX	(0x0fa00070, 0x07a00050, emulate_rd12rm0_noflags_nopc,
> +	DECODE_EMULATEX	(0x0fa00070, 0x07a00050, PROBES_BITFIELD,
>  						 REGS(0, NOPC, 0, 0, NOPC)),
>  
>  	/* BFC			cccc 0111 110x xxxx xxxx xxxx x001 1111 */
> -	DECODE_EMULATEX	(0x0fe0007f, 0x07c0001f, emulate_rd12rm0_noflags_nopc,
> +	DECODE_EMULATEX	(0x0fe0007f, 0x07c0001f, PROBES_BITFIELD,
>  						 REGS(0, NOPC, 0, 0, 0)),
>  
>  	/* BFI			cccc 0111 110x xxxx xxxx xxxx x001 xxxx */
> -	DECODE_EMULATEX	(0x0fe00070, 0x07c00010, emulate_rd12rm0_noflags_nopc,
> +	DECODE_EMULATEX	(0x0fe00070, 0x07c00010, PROBES_BITFIELD,
>  						 REGS(0, NOPC, 0, 0, NOPCX)),
>  
>  	DECODE_END
> @@ -562,22 +574,22 @@ static const union decode_item arm_cccc_01xx_table[] = {
>  
>  	/* STR (immediate)	cccc 010x x0x0 xxxx xxxx xxxx xxxx xxxx */
>  	/* STRB (immediate)	cccc 010x x1x0 xxxx xxxx xxxx xxxx xxxx */
> -	DECODE_EMULATEX	(0x0e100000, 0x04000000, emulate_str,
> +	DECODE_EMULATEX	(0x0e100000, 0x04000000, PROBES_STORE,
>  						 REGS(NOPCWB, ANY, 0, 0, 0)),
>  
>  	/* LDR (immediate)	cccc 010x x0x1 xxxx xxxx xxxx xxxx xxxx */
>  	/* LDRB (immediate)	cccc 010x x1x1 xxxx xxxx xxxx xxxx xxxx */
> -	DECODE_EMULATEX	(0x0e100000, 0x04100000, emulate_ldr,
> +	DECODE_EMULATEX	(0x0e100000, 0x04100000, PROBES_LOAD,
>  						 REGS(NOPCWB, ANY, 0, 0, 0)),
>  
>  	/* STR (register)	cccc 011x x0x0 xxxx xxxx xxxx xxxx xxxx */
>  	/* STRB (register)	cccc 011x x1x0 xxxx xxxx xxxx xxxx xxxx */
> -	DECODE_EMULATEX	(0x0e100000, 0x06000000, emulate_str,
> +	DECODE_EMULATEX	(0x0e100000, 0x06000000, PROBES_STORE,
>  						 REGS(NOPCWB, ANY, 0, 0, NOPC)),
>  
>  	/* LDR (register)	cccc 011x x0x1 xxxx xxxx xxxx xxxx xxxx */
>  	/* LDRB (register)	cccc 011x x1x1 xxxx xxxx xxxx xxxx xxxx */
> -	DECODE_EMULATEX	(0x0e100000, 0x06100000, emulate_ldr,
> +	DECODE_EMULATEX	(0x0e100000, 0x06100000, PROBES_LOAD,
>  						 REGS(NOPCWB, ANY, 0, 0, NOPC)),
>  
>  	DECODE_END
> @@ -588,7 +600,7 @@ static const union decode_item arm_cccc_100x_table[] = {
>  
>  	/* LDM			cccc 100x x0x1 xxxx xxxx xxxx xxxx xxxx */
>  	/* STM			cccc 100x x0x0 xxxx xxxx xxxx xxxx xxxx */
> -	DECODE_CUSTOM	(0x0e400000, 0x08000000, kprobe_decode_ldmstm),
> +	DECODE_CUSTOM	(0x0e400000, 0x08000000, PROBES_LDMSTM),
>  
>  	/* STM (user registers)	cccc 100x x1x0 xxxx xxxx xxxx xxxx xxxx */
>  	/* LDM (user registers)	cccc 100x x1x1 xxxx 0xxx xxxx xxxx xxxx */
> @@ -668,7 +680,7 @@ const union decode_item kprobe_decode_arm_table[] = {
>  
>  	/* B			cccc 1010 xxxx xxxx xxxx xxxx xxxx xxxx */
>  	/* BL			cccc 1011 xxxx xxxx xxxx xxxx xxxx xxxx */
> -	DECODE_SIMULATE	(0x0e000000, 0x0a000000, simulate_bbl),
> +	DECODE_SIMULATE	(0x0e000000, 0x0a000000, PROBES_BRANCH),
>  
>  	/*
>  	 * Supervisor Call, and coprocessor instructions
> @@ -709,9 +721,11 @@ static void __kprobes arm_singlestep(struct kprobe *p, struct pt_regs *regs)
>   *   should also be very rare.
>   */
>  enum kprobe_insn __kprobes
> -arm_kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi)
> +arm_kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
> +			bool usermode, const union decode_item *actions)
>  {
>  	asi->insn_singlestep = arm_singlestep;
>  	asi->insn_check_cc = kprobe_condition_checks[insn>>28];
> -	return kprobe_decode_insn(insn, asi, kprobe_decode_arm_table, false);
> +	return probes_decode_insn(insn, asi, kprobe_decode_arm_table, false,
> +				  usermode, actions);
>  }
> diff --git a/arch/arm/kernel/kprobes-common.c b/arch/arm/kernel/kprobes-common.c
> index b66e9f7..4e19498 100644
> --- a/arch/arm/kernel/kprobes-common.c
> +++ b/arch/arm/kernel/kprobes-common.c
> @@ -268,7 +268,8 @@ emulate_ldm_r3_15(struct kprobe *p, struct pt_regs *regs)
>  }
>  
>  enum kprobe_insn __kprobes
> -kprobe_decode_ldmstm(kprobe_opcode_t insn, struct arch_specific_insn *asi)
> +kprobe_decode_ldmstm(kprobe_opcode_t insn, struct arch_specific_insn *asi,
> +		     void *d)
>  {
>  	kprobe_insn_handler_t *handler = 0;
>  	unsigned reglist = insn & 0xffff;
> diff --git a/arch/arm/kernel/kprobes-thumb.c b/arch/arm/kernel/kprobes-thumb.c
> index 173b2bc..f5d57a8 100644
> --- a/arch/arm/kernel/kprobes-thumb.c
> +++ b/arch/arm/kernel/kprobes-thumb.c
> @@ -13,6 +13,8 @@
>  #include <linux/module.h>
>  
>  #include "kprobes.h"
> +#include "probes.h"
> +#include "probes-thumb.h"
>  
> 
>  /*
> @@ -83,7 +85,8 @@ t32_simulate_cond_branch(struct kprobe *p, struct pt_regs *regs)
>  }
>  
>  static enum kprobe_insn __kprobes
> -t32_decode_cond_branch(kprobe_opcode_t insn, struct arch_specific_insn *asi)
> +t32_decode_cond_branch(kprobe_opcode_t insn, struct arch_specific_insn *asi,
> +		       void *d)
>  {
>  	int cc = (insn >> 22) & 0xf;
>  	asi->insn_check_cc = kprobe_condition_checks[cc];
> @@ -158,9 +161,10 @@ t32_simulate_ldr_literal(struct kprobe *p, struct pt_regs *regs)
>  }
>  
>  static enum kprobe_insn __kprobes
> -t32_decode_ldmstm(kprobe_opcode_t insn, struct arch_specific_insn *asi)
> +t32_decode_ldmstm(kprobe_opcode_t insn, struct arch_specific_insn *asi,
> +		  void *d)
>  {
> -	enum kprobe_insn ret = kprobe_decode_ldmstm(insn, asi);
> +	enum kprobe_insn ret = kprobe_decode_ldmstm(insn, asi, d);
>  
>  	/* Fixup modified instruction to have halfwords in correct order...*/
>  	insn = asi->insn[0];
> @@ -344,7 +348,7 @@ static const union decode_item t32_table_1110_100x_x0xx[] = {
>  	/* LDMIA		1110 1000 10x1 xxxx xxxx xxxx xxxx xxxx */
>  	/* STMDB		1110 1001 00x0 xxxx xxxx xxxx xxxx xxxx */
>  	/* LDMDB		1110 1001 00x1 xxxx xxxx xxxx xxxx xxxx */
> -	DECODE_CUSTOM	(0xfe400000, 0xe8000000, t32_decode_ldmstm),
> +	DECODE_CUSTOM	(0xfe400000, 0xe8000000, PROBES_T32_LDMSTM),
>  
>  	DECODE_END
>  };
> @@ -357,12 +361,12 @@ static const union decode_item t32_table_1110_100x_x1xx[] = {
>  	DECODE_OR	(0xff600000, 0xe8600000),
>  	/* STRD (immediate)	1110 1001 x1x0 xxxx xxxx xxxx xxxx xxxx */
>  	/* LDRD (immediate)	1110 1001 x1x1 xxxx xxxx xxxx xxxx xxxx */
> -	DECODE_EMULATEX	(0xff400000, 0xe9400000, t32_emulate_ldrdstrd,
> +	DECODE_EMULATEX	(0xff400000, 0xe9400000, PROBES_T32_LDRDSTRD,
>  						 REGS(NOPCWB, NOSPPC, NOSPPC, 0, 0)),
>  
>  	/* TBB			1110 1000 1101 xxxx xxxx xxxx 0000 xxxx */
>  	/* TBH			1110 1000 1101 xxxx xxxx xxxx 0001 xxxx */
> -	DECODE_SIMULATEX(0xfff000e0, 0xe8d00000, t32_simulate_table_branch,
> +	DECODE_SIMULATEX(0xfff000e0, 0xe8d00000, PROBES_T32_TABLE_BRANCH,
>  						 REGS(NOSP, 0, 0, 0, NOSPPC)),
>  
>  	/* STREX		1110 1000 0100 xxxx xxxx xxxx xxxx xxxx */
> @@ -382,18 +386,18 @@ static const union decode_item t32_table_1110_101x[] = {
>  
>  	/* TST			1110 1010 0001 xxxx xxxx 1111 xxxx xxxx */
>  	/* TEQ			1110 1010 1001 xxxx xxxx 1111 xxxx xxxx */
> -	DECODE_EMULATEX	(0xff700f00, 0xea100f00, t32_emulate_rd8rn16rm0_rwflags,
> +	DECODE_EMULATEX	(0xff700f00, 0xea100f00, PROBES_T32_TST,
>  						 REGS(NOSPPC, 0, 0, 0, NOSPPC)),
>  
>  	/* CMN			1110 1011 0001 xxxx xxxx 1111 xxxx xxxx */
>  	DECODE_OR	(0xfff00f00, 0xeb100f00),
>  	/* CMP			1110 1011 1011 xxxx xxxx 1111 xxxx xxxx */
> -	DECODE_EMULATEX	(0xfff00f00, 0xebb00f00, t32_emulate_rd8rn16rm0_rwflags,
> +	DECODE_EMULATEX	(0xfff00f00, 0xebb00f00, PROBES_T32_TST,
>  						 REGS(NOPC, 0, 0, 0, NOSPPC)),
>  
>  	/* MOV			1110 1010 010x 1111 xxxx xxxx xxxx xxxx */
>  	/* MVN			1110 1010 011x 1111 xxxx xxxx xxxx xxxx */
> -	DECODE_EMULATEX	(0xffcf0000, 0xea4f0000, t32_emulate_rd8rn16rm0_rwflags,
> +	DECODE_EMULATEX	(0xffcf0000, 0xea4f0000, PROBES_T32_MOV,
>  						 REGS(0, 0, NOSPPC, 0, NOSPPC)),
>  
>  	/* ???			1110 1010 101x xxxx xxxx xxxx xxxx xxxx */
> @@ -408,7 +412,7 @@ static const union decode_item t32_table_1110_101x[] = {
>  
>  	/* ADD/SUB SP, SP, Rm, LSL #0..3				*/
>  	/*			1110 1011 x0xx 1101 x000 1101 xx00 xxxx */
> -	DECODE_EMULATEX	(0xff4f7f30, 0xeb0d0d00, t32_emulate_rd8rn16rm0_rwflags,
> +	DECODE_EMULATEX	(0xff4f7f30, 0xeb0d0d00, PROBES_T32_ADDSUB,
>  						 REGS(SP, 0, SP, 0, NOSPPC)),
>  
>  	/* ADD/SUB SP, SP, Rm, shift					*/
> @@ -417,7 +421,7 @@ static const union decode_item t32_table_1110_101x[] = {
>  
>  	/* ADD/SUB Rd, SP, Rm, shift					*/
>  	/*			1110 1011 x0xx 1101 xxxx xxxx xxxx xxxx */
> -	DECODE_EMULATEX	(0xff4f0000, 0xeb0d0000, t32_emulate_rd8rn16rm0_rwflags,
> +	DECODE_EMULATEX	(0xff4f0000, 0xeb0d0000, PROBES_T32_ADDSUB,
>  						 REGS(SP, 0, NOPC, 0, NOSPPC)),
>  
>  	/* AND			1110 1010 000x xxxx xxxx xxxx xxxx xxxx */
> @@ -431,7 +435,7 @@ static const union decode_item t32_table_1110_101x[] = {
>  	/* SBC			1110 1011 011x xxxx xxxx xxxx xxxx xxxx */
>  	/* SUB			1110 1011 101x xxxx xxxx xxxx xxxx xxxx */
>  	/* RSB			1110 1011 110x xxxx xxxx xxxx xxxx xxxx */
> -	DECODE_EMULATEX	(0xfe000000, 0xea000000, t32_emulate_rd8rn16rm0_rwflags,
> +	DECODE_EMULATEX	(0xfe000000, 0xea000000, PROBES_T32_LOGICAL,
>  						 REGS(NOSPPC, 0, NOSPPC, 0, NOSPPC)),
>  
>  	DECODE_END
> @@ -442,18 +446,18 @@ static const union decode_item t32_table_1111_0x0x___0[] = {
>  
>  	/* TST			1111 0x00 0001 xxxx 0xxx 1111 xxxx xxxx */
>  	/* TEQ			1111 0x00 1001 xxxx 0xxx 1111 xxxx xxxx */
> -	DECODE_EMULATEX	(0xfb708f00, 0xf0100f00, t32_emulate_rd8rn16rm0_rwflags,
> +	DECODE_EMULATEX	(0xfb708f00, 0xf0100f00, PROBES_T32_TST,
>  						 REGS(NOSPPC, 0, 0, 0, 0)),
>  
>  	/* CMN			1111 0x01 0001 xxxx 0xxx 1111 xxxx xxxx */
>  	DECODE_OR	(0xfbf08f00, 0xf1100f00),
>  	/* CMP			1111 0x01 1011 xxxx 0xxx 1111 xxxx xxxx */
> -	DECODE_EMULATEX	(0xfbf08f00, 0xf1b00f00, t32_emulate_rd8rn16rm0_rwflags,
> +	DECODE_EMULATEX	(0xfbf08f00, 0xf1b00f00, PROBES_T32_CMP,
>  						 REGS(NOPC, 0, 0, 0, 0)),
>  
>  	/* MOV			1111 0x00 010x 1111 0xxx xxxx xxxx xxxx */
>  	/* MVN			1111 0x00 011x 1111 0xxx xxxx xxxx xxxx */
> -	DECODE_EMULATEX	(0xfbcf8000, 0xf04f0000, t32_emulate_rd8rn16rm0_rwflags,
> +	DECODE_EMULATEX	(0xfbcf8000, 0xf04f0000, PROBES_T32_MOV,
>  						 REGS(0, 0, NOSPPC, 0, 0)),
>  
>  	/* ???			1111 0x00 101x xxxx 0xxx xxxx xxxx xxxx */
> @@ -470,7 +474,7 @@ static const union decode_item t32_table_1111_0x0x___0[] = {
>  
>  	/* ADD Rd, SP, #imm	1111 0x01 000x 1101 0xxx xxxx xxxx xxxx */
>  	/* SUB Rd, SP, #imm	1111 0x01 101x 1101 0xxx xxxx xxxx xxxx */
> -	DECODE_EMULATEX	(0xfb4f8000, 0xf10d0000, t32_emulate_rd8rn16rm0_rwflags,
> +	DECODE_EMULATEX	(0xfb4f8000, 0xf10d0000, PROBES_T32_ADDSUB,
>  						 REGS(SP, 0, NOPC, 0, 0)),
>  
>  	/* AND			1111 0x00 000x xxxx 0xxx xxxx xxxx xxxx */
> @@ -483,7 +487,7 @@ static const union decode_item t32_table_1111_0x0x___0[] = {
>  	/* SBC			1111 0x01 011x xxxx 0xxx xxxx xxxx xxxx */
>  	/* SUB			1111 0x01 101x xxxx 0xxx xxxx xxxx xxxx */
>  	/* RSB			1111 0x01 110x xxxx 0xxx xxxx xxxx xxxx */
> -	DECODE_EMULATEX	(0xfa008000, 0xf0000000, t32_emulate_rd8rn16rm0_rwflags,
> +	DECODE_EMULATEX	(0xfa008000, 0xf0000000, PROBES_T32_LOGICAL,
>  						 REGS(NOSPPC, 0, NOSPPC, 0, 0)),
>  
>  	DECODE_END
> @@ -495,44 +499,44 @@ static const union decode_item t32_table_1111_0x1x___0[] = {
>  	/* ADDW Rd, PC, #imm	1111 0x10 0000 1111 0xxx xxxx xxxx xxxx */
>  	DECODE_OR	(0xfbff8000, 0xf20f0000),
>  	/* SUBW	Rd, PC, #imm	1111 0x10 1010 1111 0xxx xxxx xxxx xxxx */
> -	DECODE_EMULATEX	(0xfbff8000, 0xf2af0000, t32_emulate_rd8pc16_noflags,
> +	DECODE_EMULATEX	(0xfbff8000, 0xf2af0000, PROBES_T32_ADDWSUBW_PC,
>  						 REGS(PC, 0, NOSPPC, 0, 0)),
>  
>  	/* ADDW SP, SP, #imm	1111 0x10 0000 1101 0xxx 1101 xxxx xxxx */
>  	DECODE_OR	(0xfbff8f00, 0xf20d0d00),
>  	/* SUBW	SP, SP, #imm	1111 0x10 1010 1101 0xxx 1101 xxxx xxxx */
> -	DECODE_EMULATEX	(0xfbff8f00, 0xf2ad0d00, t32_emulate_rd8rn16_noflags,
> +	DECODE_EMULATEX	(0xfbff8f00, 0xf2ad0d00, PROBES_T32_ADDWSUBW,
>  						 REGS(SP, 0, SP, 0, 0)),
>  
>  	/* ADDW			1111 0x10 0000 xxxx 0xxx xxxx xxxx xxxx */
>  	DECODE_OR	(0xfbf08000, 0xf2000000),
>  	/* SUBW			1111 0x10 1010 xxxx 0xxx xxxx xxxx xxxx */
> -	DECODE_EMULATEX	(0xfbf08000, 0xf2a00000, t32_emulate_rd8rn16_noflags,
> +	DECODE_EMULATEX	(0xfbf08000, 0xf2a00000, PROBES_T32_ADDWSUBW,
>  						 REGS(NOPCX, 0, NOSPPC, 0, 0)),
>  
>  	/* MOVW			1111 0x10 0100 xxxx 0xxx xxxx xxxx xxxx */
>  	/* MOVT			1111 0x10 1100 xxxx 0xxx xxxx xxxx xxxx */
> -	DECODE_EMULATEX	(0xfb708000, 0xf2400000, t32_emulate_rd8rn16_noflags,
> +	DECODE_EMULATEX	(0xfb708000, 0xf2400000, PROBES_T32_MOVW,
>  						 REGS(0, 0, NOSPPC, 0, 0)),
>  
>  	/* SSAT16		1111 0x11 0010 xxxx 0000 xxxx 00xx xxxx */
>  	/* SSAT			1111 0x11 00x0 xxxx 0xxx xxxx xxxx xxxx */
>  	/* USAT16		1111 0x11 1010 xxxx 0000 xxxx 00xx xxxx */
>  	/* USAT			1111 0x11 10x0 xxxx 0xxx xxxx xxxx xxxx */
> -	DECODE_EMULATEX	(0xfb508000, 0xf3000000, t32_emulate_rd8rn16rm0_rwflags,
> +	DECODE_EMULATEX	(0xfb508000, 0xf3000000, PROBES_T32_SAT,
>  						 REGS(NOSPPC, 0, NOSPPC, 0, 0)),
>  
>  	/* SFBX			1111 0x11 0100 xxxx 0xxx xxxx xxxx xxxx */
>  	/* UFBX			1111 0x11 1100 xxxx 0xxx xxxx xxxx xxxx */
> -	DECODE_EMULATEX	(0xfb708000, 0xf3400000, t32_emulate_rd8rn16_noflags,
> +	DECODE_EMULATEX	(0xfb708000, 0xf3400000, PROBES_T32_BITFIELD,
>  						 REGS(NOSPPC, 0, NOSPPC, 0, 0)),
>  
>  	/* BFC			1111 0x11 0110 1111 0xxx xxxx xxxx xxxx */
> -	DECODE_EMULATEX	(0xfbff8000, 0xf36f0000, t32_emulate_rd8rn16_noflags,
> +	DECODE_EMULATEX	(0xfbff8000, 0xf36f0000, PROBES_T32_BITFIELD,
>  						 REGS(0, 0, NOSPPC, 0, 0)),
>  
>  	/* BFI			1111 0x11 0110 xxxx 0xxx xxxx xxxx xxxx */
> -	DECODE_EMULATEX	(0xfbf08000, 0xf3600000, t32_emulate_rd8rn16_noflags,
> +	DECODE_EMULATEX	(0xfbf08000, 0xf3600000, PROBES_T32_BITFIELD,
>  						 REGS(NOSPPCX, 0, NOSPPC, 0, 0)),
>  
>  	DECODE_END
> @@ -544,14 +548,14 @@ static const union decode_item t32_table_1111_0xxx___1[] = {
>  	/* YIELD		1111 0011 1010 xxxx 10x0 x000 0000 0001 */
>  	DECODE_OR	(0xfff0d7ff, 0xf3a08001),
>  	/* SEV			1111 0011 1010 xxxx 10x0 x000 0000 0100 */
> -	DECODE_EMULATE	(0xfff0d7ff, 0xf3a08004, probes_emulate_none),
> +	DECODE_EMULATE	(0xfff0d7ff, 0xf3a08004, PROBES_T32_SEV),
>  	/* NOP			1111 0011 1010 xxxx 10x0 x000 0000 0000 */
>  	/* WFE			1111 0011 1010 xxxx 10x0 x000 0000 0010 */
>  	/* WFI			1111 0011 1010 xxxx 10x0 x000 0000 0011 */
> -	DECODE_SIMULATE	(0xfff0d7fc, 0xf3a08000, probes_simulate_nop),
> +	DECODE_SIMULATE	(0xfff0d7fc, 0xf3a08000, PROBES_T32_WFE),
>  
>  	/* MRS Rd, CPSR		1111 0011 1110 xxxx 10x0 xxxx xxxx xxxx */
> -	DECODE_SIMULATEX(0xfff0d000, 0xf3e08000, t32_simulate_mrs,
> +	DECODE_SIMULATEX(0xfff0d000, 0xf3e08000, PROBES_T32_MRS,
>  						 REGS(0, 0, NOSPPC, 0, 0)),
>  
>  	/*
> @@ -573,13 +577,13 @@ static const union decode_item t32_table_1111_0xxx___1[] = {
>  	DECODE_REJECT	(0xfb80d000, 0xf3808000),
>  
>  	/* Bcc			1111 0xxx xxxx xxxx 10x0 xxxx xxxx xxxx */
> -	DECODE_CUSTOM	(0xf800d000, 0xf0008000, t32_decode_cond_branch),
> +	DECODE_CUSTOM	(0xf800d000, 0xf0008000, PROBES_T32_BRANCH_COND),
>  
>  	/* BLX			1111 0xxx xxxx xxxx 11x0 xxxx xxxx xxx0 */
>  	DECODE_OR	(0xf800d001, 0xf000c000),
>  	/* B			1111 0xxx xxxx xxxx 10x1 xxxx xxxx xxxx */
>  	/* BL			1111 0xxx xxxx xxxx 11x1 xxxx xxxx xxxx */
> -	DECODE_SIMULATE	(0xf8009000, 0xf0009000, t32_simulate_branch),
> +	DECODE_SIMULATE	(0xf8009000, 0xf0009000, PROBES_T32_BRANCH),
>  
>  	DECODE_END
>  };
> @@ -589,7 +593,7 @@ static const union decode_item t32_table_1111_100x_x0x1__1111[] = {
>  
>  	/* PLD (literal)	1111 1000 x001 1111 1111 xxxx xxxx xxxx */
>  	/* PLI (literal)	1111 1001 x001 1111 1111 xxxx xxxx xxxx */
> -	DECODE_SIMULATE	(0xfe7ff000, 0xf81ff000, probes_simulate_nop),
> +	DECODE_SIMULATE	(0xfe7ff000, 0xf81ff000, PROBES_T32_PLDI),
>  
>  	/* PLD{W} (immediate)	1111 1000 10x1 xxxx 1111 xxxx xxxx xxxx */
>  	DECODE_OR	(0xffd0f000, 0xf890f000),
> @@ -598,13 +602,13 @@ static const union decode_item t32_table_1111_100x_x0x1__1111[] = {
>  	/* PLI (immediate)	1111 1001 1001 xxxx 1111 xxxx xxxx xxxx */
>  	DECODE_OR	(0xfff0f000, 0xf990f000),
>  	/* PLI (immediate)	1111 1001 0001 xxxx 1111 1100 xxxx xxxx */
> -	DECODE_SIMULATEX(0xfff0ff00, 0xf910fc00, probes_simulate_nop,
> +	DECODE_SIMULATEX(0xfff0ff00, 0xf910fc00, PROBES_T32_PLDI,
>  						 REGS(NOPCX, 0, 0, 0, 0)),
>  
>  	/* PLD{W} (register)	1111 1000 00x1 xxxx 1111 0000 00xx xxxx */
>  	DECODE_OR	(0xffd0ffc0, 0xf810f000),
>  	/* PLI (register)	1111 1001 0001 xxxx 1111 0000 00xx xxxx */
> -	DECODE_SIMULATEX(0xfff0ffc0, 0xf910f000, probes_simulate_nop,
> +	DECODE_SIMULATEX(0xfff0ffc0, 0xf910f000, PROBES_T32_PLDI,
>  						 REGS(NOPCX, 0, 0, 0, NOSPPC)),
>  
>  	/* Other unallocated instructions...				*/
> @@ -640,7 +644,7 @@ static const union decode_item t32_table_1111_100x[] = {
>  	DECODE_REJECT	(0xff10f000, 0xf800f000),
>  
>  	/* LDR (literal)	1111 1000 x101 1111 xxxx xxxx xxxx xxxx */
> -	DECODE_SIMULATEX(0xff7f0000, 0xf85f0000, t32_simulate_ldr_literal,
> +	DECODE_SIMULATEX(0xff7f0000, 0xf85f0000, PROBES_T32_LDR_LIT,
>  						 REGS(PC, ANY, 0, 0, 0)),
>  
>  	/* STR (immediate)	1111 1000 0100 xxxx xxxx 1xxx xxxx xxxx */
> @@ -648,19 +652,19 @@ static const union decode_item t32_table_1111_100x[] = {
>  	DECODE_OR	(0xffe00800, 0xf8400800),
>  	/* STR (immediate)	1111 1000 1100 xxxx xxxx xxxx xxxx xxxx */
>  	/* LDR (immediate)	1111 1000 1101 xxxx xxxx xxxx xxxx xxxx */
> -	DECODE_EMULATEX	(0xffe00000, 0xf8c00000, t32_emulate_ldrstr,
> +	DECODE_EMULATEX	(0xffe00000, 0xf8c00000, PROBES_T32_LDRSTR,
>  						 REGS(NOPCX, ANY, 0, 0, 0)),
>  
>  	/* STR (register)	1111 1000 0100 xxxx xxxx 0000 00xx xxxx */
>  	/* LDR (register)	1111 1000 0101 xxxx xxxx 0000 00xx xxxx */
> -	DECODE_EMULATEX	(0xffe00fc0, 0xf8400000, t32_emulate_ldrstr,
> +	DECODE_EMULATEX	(0xffe00fc0, 0xf8400000, PROBES_T32_LDRSTR,
>  						 REGS(NOPCX, ANY, 0, 0, NOSPPC)),
>  
>  	/* LDRB (literal)	1111 1000 x001 1111 xxxx xxxx xxxx xxxx */
>  	/* LDRSB (literal)	1111 1001 x001 1111 xxxx xxxx xxxx xxxx */
>  	/* LDRH (literal)	1111 1000 x011 1111 xxxx xxxx xxxx xxxx */
>  	/* LDRSH (literal)	1111 1001 x011 1111 xxxx xxxx xxxx xxxx */
> -	DECODE_SIMULATEX(0xfe5f0000, 0xf81f0000, t32_simulate_ldr_literal,
> +	DECODE_SIMULATEX(0xfe5f0000, 0xf81f0000, PROBES_T32_LDR_LIT,
>  						 REGS(PC, NOSPPCX, 0, 0, 0)),
>  
>  	/* STRB (immediate)	1111 1000 0000 xxxx xxxx 1xxx xxxx xxxx */
> @@ -676,7 +680,7 @@ static const union decode_item t32_table_1111_100x[] = {
>  	/* LDRSB (immediate)	1111 1001 1001 xxxx xxxx xxxx xxxx xxxx */
>  	/* LDRH (immediate)	1111 1000 1011 xxxx xxxx xxxx xxxx xxxx */
>  	/* LDRSH (immediate)	1111 1001 1011 xxxx xxxx xxxx xxxx xxxx */
> -	DECODE_EMULATEX	(0xfec00000, 0xf8800000, t32_emulate_ldrstr,
> +	DECODE_EMULATEX	(0xfec00000, 0xf8800000, PROBES_T32_LDRSTR,
>  						 REGS(NOPCX, NOSPPCX, 0, 0, 0)),
>  
>  	/* STRB (register)	1111 1000 0000 xxxx xxxx 0000 00xx xxxx */
> @@ -685,7 +689,7 @@ static const union decode_item t32_table_1111_100x[] = {
>  	/* LDRSB (register)	1111 1001 0001 xxxx xxxx 0000 00xx xxxx */
>  	/* LDRH (register)	1111 1000 0011 xxxx xxxx 0000 00xx xxxx */
>  	/* LDRSH (register)	1111 1001 0011 xxxx xxxx 0000 00xx xxxx */
> -	DECODE_EMULATEX	(0xfe800fc0, 0xf8000000, t32_emulate_ldrstr,
> +	DECODE_EMULATEX	(0xfe800fc0, 0xf8000000, PROBES_T32_LDRSTR,
>  						 REGS(NOPCX, NOSPPCX, 0, 0, NOSPPC)),
>  
>  	/* Other unallocated instructions...				*/
> @@ -704,7 +708,7 @@ static const union decode_item t32_table_1111_1010___1111[] = {
>  	/* UXTB16		1111 1010 0011 1111 1111 xxxx 1xxx xxxx */
>  	/* SXTB			1111 1010 0100 1111 1111 xxxx 1xxx xxxx */
>  	/* UXTB			1111 1010 0101 1111 1111 xxxx 1xxx xxxx */
> -	DECODE_EMULATEX	(0xff8ff080, 0xfa0ff080, t32_emulate_rd8rn16rm0_rwflags,
> +	DECODE_EMULATEX	(0xff8ff080, 0xfa0ff080, PROBES_T32_SIGN_EXTEND,
>  						 REGS(0, 0, NOSPPC, 0, NOSPPC)),
>  
> 
> @@ -777,7 +781,7 @@ static const union decode_item t32_table_1111_1010___1111[] = {
>  	/* LSR			1111 1010 001x xxxx 1111 xxxx 0000 xxxx */
>  	/* ASR			1111 1010 010x xxxx 1111 xxxx 0000 xxxx */
>  	/* ROR			1111 1010 011x xxxx 1111 xxxx 0000 xxxx */
> -	DECODE_EMULATEX	(0xff80f0f0, 0xfa00f000, t32_emulate_rd8rn16rm0_rwflags,
> +	DECODE_EMULATEX	(0xff80f0f0, 0xfa00f000, PROBES_T32_MEDIA,
>  						 REGS(NOSPPC, 0, NOSPPC, 0, NOSPPC)),
>  
>  	/* CLZ			1111 1010 1010 xxxx 1111 xxxx 1000 xxxx */
> @@ -787,7 +791,7 @@ static const union decode_item t32_table_1111_1010___1111[] = {
>  	/* REV16		1111 1010 1001 xxxx 1111 xxxx 1001 xxxx */
>  	/* RBIT			1111 1010 1001 xxxx 1111 xxxx 1010 xxxx */
>  	/* REVSH		1111 1010 1001 xxxx 1111 xxxx 1011 xxxx */
> -	DECODE_EMULATEX	(0xfff0f0c0, 0xfa90f080, t32_emulate_rd8rn16_noflags,
> +	DECODE_EMULATEX	(0xfff0f0c0, 0xfa90f080, PROBES_T32_REVERSE,
>  						 REGS(NOSPPC, 0, NOSPPC, 0, SAMEAS16)),
>  
>  	/* Other unallocated instructions...				*/
> @@ -810,7 +814,7 @@ static const union decode_item t32_table_1111_1011_0[] = {
>  	/* SMUSD{X}		1111 1011 0100 xxxx 1111 xxxx 000x xxxx */
>  	/* SMMUL{R}		1111 1011 0101 xxxx 1111 xxxx 000x xxxx */
>  	/* USAD8		1111 1011 0111 xxxx 1111 xxxx 0000 xxxx */
> -	DECODE_EMULATEX	(0xff80f0e0, 0xfb00f000, t32_emulate_rd8rn16rm0_rwflags,
> +	DECODE_EMULATEX	(0xff80f0e0, 0xfb00f000, PROBES_T32_MUL_ADD,
>  						 REGS(NOSPPC, 0, NOSPPC, 0, NOSPPC)),
>  
>  	/* ???			1111 1011 0111 xxxx xxxx xxxx 0001 xxxx */
> @@ -826,7 +830,7 @@ static const union decode_item t32_table_1111_1011_0[] = {
>  	/* SMMLA{R}		1111 1011 0101 xxxx xxxx xxxx 000x xxxx */
>  	/* SMMLS{R}		1111 1011 0110 xxxx xxxx xxxx 000x xxxx */
>  	/* USADA8		1111 1011 0111 xxxx xxxx xxxx 0000 xxxx */
> -	DECODE_EMULATEX	(0xff8000c0, 0xfb000000, t32_emulate_rd8rn16rm0ra12_noflags,
> +	DECODE_EMULATEX	(0xff8000c0, 0xfb000000,  PROBES_T32_MUL_ADD2,
>  						 REGS(NOSPPC, NOSPPCX, NOSPPC, 0, NOSPPC)),
>  
>  	/* Other unallocated instructions...				*/
> @@ -847,7 +851,7 @@ static const union decode_item t32_table_1111_1011_1[] = {
>  	/* UMULL		1111 1011 1010 xxxx xxxx xxxx 0000 xxxx */
>  	/* SMLAL		1111 1011 1100 xxxx xxxx xxxx 0000 xxxx */
>  	/* UMLAL		1111 1011 1110 xxxx xxxx xxxx 0000 xxxx */
> -	DECODE_EMULATEX	(0xff9000f0, 0xfb800000, t32_emulate_rdlo12rdhi8rn16rm0_noflags,
> +	DECODE_EMULATEX	(0xff9000f0, 0xfb800000, PROBES_T32_MUL_ADD_LONG,
>  						 REGS(NOSPPC, NOSPPC, NOSPPC, 0, NOSPPC)),
>  
>  	/* SDIV			1111 1011 1001 xxxx xxxx xxxx 1111 xxxx */
> @@ -1046,7 +1050,7 @@ t16_singlestep_it(struct kprobe *p, struct pt_regs *regs)
>  }
>  
>  static enum kprobe_insn __kprobes
> -t16_decode_it(kprobe_opcode_t insn, struct arch_specific_insn *asi)
> +t16_decode_it(kprobe_opcode_t insn, struct arch_specific_insn *asi, void *d)
>  {
>  	asi->insn_singlestep = t16_singlestep_it;
>  	return INSN_GOOD_NO_SLOT;
> @@ -1063,7 +1067,8 @@ t16_simulate_cond_branch(struct kprobe *p, struct pt_regs *regs)
>  }
>  
>  static enum kprobe_insn __kprobes
> -t16_decode_cond_branch(kprobe_opcode_t insn, struct arch_specific_insn *asi)
> +t16_decode_cond_branch(kprobe_opcode_t insn, struct arch_specific_insn *asi,
> +		       void *d)
>  {
>  	int cc = (insn >> 8) & 0xf;
>  	asi->insn_check_cc = kprobe_condition_checks[cc];
> @@ -1149,7 +1154,7 @@ t16_emulate_hiregs(struct kprobe *p, struct pt_regs *regs)
>  }
>  
>  static enum kprobe_insn __kprobes
> -t16_decode_hiregs(kprobe_opcode_t insn, struct arch_specific_insn *asi)
> +t16_decode_hiregs(kprobe_opcode_t insn, struct arch_specific_insn *asi, void *d)
>  {
>  	insn &= ~0x00ff;
>  	insn |= 0x001; /* Set Rdn = R1 and Rm = R0 */
> @@ -1175,7 +1180,7 @@ t16_emulate_push(struct kprobe *p, struct pt_regs *regs)
>  }
>  
>  static enum kprobe_insn __kprobes
> -t16_decode_push(kprobe_opcode_t insn, struct arch_specific_insn *asi)
> +t16_decode_push(kprobe_opcode_t insn, struct arch_specific_insn *asi, void *d)
>  {
>  	/*
>  	 * To simulate a PUSH we use a Thumb-2 "STMDB R9!, {registers}"
> @@ -1225,7 +1230,7 @@ t16_emulate_pop_pc(struct kprobe *p, struct pt_regs *regs)
>  }
>  
>  static enum kprobe_insn __kprobes
> -t16_decode_pop(kprobe_opcode_t insn, struct arch_specific_insn *asi)
> +t16_decode_pop(kprobe_opcode_t insn, struct arch_specific_insn *asi, void *d)
>  {
>  	/*
>  	 * To simulate a POP we use a Thumb-2 "LDMDB R9!, {registers}"
> @@ -1244,11 +1249,11 @@ static const union decode_item t16_table_1011[] = {
>  
>  	/* ADD (SP plus immediate)	1011 0000 0xxx xxxx */
>  	/* SUB (SP minus immediate)	1011 0000 1xxx xxxx */
> -	DECODE_SIMULATE	(0xff00, 0xb000, t16_simulate_add_sp_imm),
> +	DECODE_SIMULATE	(0xff00, 0xb000, PROBES_T16_ADD_SP),
>  
>  	/* CBZ				1011 00x1 xxxx xxxx */
>  	/* CBNZ				1011 10x1 xxxx xxxx */
> -	DECODE_SIMULATE	(0xf500, 0xb100, t16_simulate_cbz),
> +	DECODE_SIMULATE	(0xf500, 0xb100, PROBES_T16_CBZ),
>  
>  	/* SXTH				1011 0010 00xx xxxx */
>  	/* SXTB				1011 0010 01xx xxxx */
> @@ -1259,12 +1264,12 @@ static const union decode_item t16_table_1011[] = {
>  	/* ???				1011 1010 10xx xxxx */
>  	/* REVSH			1011 1010 11xx xxxx */
>  	DECODE_REJECT	(0xffc0, 0xba80),
> -	DECODE_EMULATE	(0xf500, 0xb000, t16_emulate_loregs_rwflags),
> +	DECODE_EMULATE	(0xf500, 0xb000, PROBES_T16_SIGN_EXTEND),
>  
>  	/* PUSH				1011 010x xxxx xxxx */
> -	DECODE_CUSTOM	(0xfe00, 0xb400, t16_decode_push),
> +	DECODE_CUSTOM	(0xfe00, 0xb400, PROBES_T16_PUSH),
>  	/* POP				1011 110x xxxx xxxx */
> -	DECODE_CUSTOM	(0xfe00, 0xbc00, t16_decode_pop),
> +	DECODE_CUSTOM	(0xfe00, 0xbc00, PROBES_T16_POP),
>  
>  	/*
>  	 * If-Then, and hints
> @@ -1274,15 +1279,15 @@ static const union decode_item t16_table_1011[] = {
>  	/* YIELD			1011 1111 0001 0000 */
>  	DECODE_OR	(0xffff, 0xbf10),
>  	/* SEV				1011 1111 0100 0000 */
> -	DECODE_EMULATE	(0xffff, 0xbf40, probes_emulate_none),
> +	DECODE_EMULATE	(0xffff, 0xbf40, PROBES_T16_SEV),
>  	/* NOP				1011 1111 0000 0000 */
>  	/* WFE				1011 1111 0010 0000 */
>  	/* WFI				1011 1111 0011 0000 */
> -	DECODE_SIMULATE	(0xffcf, 0xbf00, probes_simulate_nop),
> +	DECODE_SIMULATE	(0xffcf, 0xbf00, PROBES_T16_WFE),
>  	/* Unassigned hints		1011 1111 xxxx 0000 */
>  	DECODE_REJECT	(0xff0f, 0xbf00),
>  	/* IT				1011 1111 xxxx xxxx */
> -	DECODE_CUSTOM	(0xff00, 0xbf00, t16_decode_it),
> +	DECODE_CUSTOM	(0xff00, 0xbf00, PROBES_T16_IT),
>  
>  	/* SETEND			1011 0110 010x xxxx */
>  	/* CPS				1011 0110 011x xxxx */
> @@ -1299,7 +1304,7 @@ const union decode_item kprobe_decode_thumb16_table[] = {
>  	 */
>  
>  	/* CMP (immediate)		0010 1xxx xxxx xxxx */
> -	DECODE_EMULATE	(0xf800, 0x2800, t16_emulate_loregs_rwflags),
> +	DECODE_EMULATE	(0xf800, 0x2800, PROBES_T16_CMP),
>  
>  	/* ADD (register)		0001 100x xxxx xxxx */
>  	/* SUB (register)		0001 101x xxxx xxxx */
> @@ -1311,7 +1316,7 @@ const union decode_item kprobe_decode_thumb16_table[] = {
>  	/* MOV (immediate)		0010 0xxx xxxx xxxx */
>  	/* ADD (immediate, Thumb)	0011 0xxx xxxx xxxx */
>  	/* SUB (immediate, Thumb)	0011 1xxx xxxx xxxx */
> -	DECODE_EMULATE	(0xc000, 0x0000, t16_emulate_loregs_noitrwflags),
> +	DECODE_EMULATE	(0xc000, 0x0000, PROBES_T16_ADDSUB),
>  
>  	/*
>  	 * 16-bit Thumb data-processing instructions
> @@ -1319,10 +1324,10 @@ const union decode_item kprobe_decode_thumb16_table[] = {
>  	 */
>  
>  	/* TST (register)		0100 0010 00xx xxxx */
> -	DECODE_EMULATE	(0xffc0, 0x4200, t16_emulate_loregs_rwflags),
> +	DECODE_EMULATE	(0xffc0, 0x4200, PROBES_T16_CMP),
>  	/* CMP (register)		0100 0010 10xx xxxx */
>  	/* CMN (register)		0100 0010 11xx xxxx */
> -	DECODE_EMULATE	(0xff80, 0x4280, t16_emulate_loregs_rwflags),
> +	DECODE_EMULATE	(0xff80, 0x4280, PROBES_T16_CMP),
>  	/* AND (register)		0100 0000 00xx xxxx */
>  	/* EOR (register)		0100 0000 01xx xxxx */
>  	/* LSL (register)		0100 0000 10xx xxxx */
> @@ -1336,7 +1341,7 @@ const union decode_item kprobe_decode_thumb16_table[] = {
>  	/* MUL				0100 0011 00xx xxxx */
>  	/* BIC (register)		0100 0011 10xx xxxx */
>  	/* MVN (register)		0100 0011 10xx xxxx */
> -	DECODE_EMULATE	(0xfc00, 0x4000, t16_emulate_loregs_noitrwflags),
> +	DECODE_EMULATE	(0xfc00, 0x4000, PROBES_T16_LOGICAL),
>  
>  	/*
>  	 * Special data instructions and branch and exchange
> @@ -1348,7 +1353,7 @@ const union decode_item kprobe_decode_thumb16_table[] = {
>  
>  	/* BX (register)		0100 0111 0xxx xxxx */
>  	/* BLX (register)		0100 0111 1xxx xxxx */
> -	DECODE_SIMULATE (0xff00, 0x4700, t16_simulate_bxblx),
> +	DECODE_SIMULATE (0xff00, 0x4700, PROBES_T16_BLX),
>  
>  	/* ADD pc, pc			0100 0100 1111 1111 */
>  	DECODE_REJECT	(0xffff, 0x44ff),
> @@ -1356,13 +1361,13 @@ const union decode_item kprobe_decode_thumb16_table[] = {
>  	/* ADD (register)		0100 0100 xxxx xxxx */
>  	/* CMP (register)		0100 0101 xxxx xxxx */
>  	/* MOV (register)		0100 0110 xxxx xxxx */
> -	DECODE_CUSTOM	(0xfc00, 0x4400, t16_decode_hiregs),
> +	DECODE_CUSTOM	(0xfc00, 0x4400, PROBES_T16_HIREGOPS),
>  
>  	/*
>  	 * Load from Literal Pool
>  	 * LDR (literal)		0100 1xxx xxxx xxxx
>  	 */
> -	DECODE_SIMULATE	(0xf800, 0x4800, t16_simulate_ldr_literal),
> +	DECODE_SIMULATE	(0xf800, 0x4800, PROBES_T16_LDR_LIT),
>  
>  	/*
>  	 * 16-bit Thumb Load/store instructions
> @@ -1383,20 +1388,20 @@ const union decode_item kprobe_decode_thumb16_table[] = {
>  	/* LDR (immediate, Thumb)	0110 1xxx xxxx xxxx */
>  	/* STRB (immediate, Thumb)	0111 0xxx xxxx xxxx */
>  	/* LDRB (immediate, Thumb)	0111 1xxx xxxx xxxx */
> -	DECODE_EMULATE	(0xc000, 0x4000, t16_emulate_loregs_rwflags),
> +	DECODE_EMULATE	(0xc000, 0x4000, PROBES_T16_LDRHSTRH),
>  	/* STRH (immediate, Thumb)	1000 0xxx xxxx xxxx */
>  	/* LDRH (immediate, Thumb)	1000 1xxx xxxx xxxx */
> -	DECODE_EMULATE	(0xf000, 0x8000, t16_emulate_loregs_rwflags),
> +	DECODE_EMULATE	(0xf000, 0x8000, PROBES_T16_LDRHSTRH),
>  	/* STR (immediate, Thumb)	1001 0xxx xxxx xxxx */
>  	/* LDR (immediate, Thumb)	1001 1xxx xxxx xxxx */
> -	DECODE_SIMULATE	(0xf000, 0x9000, t16_simulate_ldrstr_sp_relative),
> +	DECODE_SIMULATE	(0xf000, 0x9000, PROBES_T16_LDRSTR),
>  
>  	/*
>  	 * Generate PC-/SP-relative address
>  	 * ADR (literal)		1010 0xxx xxxx xxxx
>  	 * ADD (SP plus immediate)	1010 1xxx xxxx xxxx
>  	 */
> -	DECODE_SIMULATE	(0xf000, 0xa000, t16_simulate_reladr),
> +	DECODE_SIMULATE	(0xf000, 0xa000, PROBES_T16_ADR),
>  
>  	/*
>  	 * Miscellaneous 16-bit instructions
> @@ -1406,7 +1411,7 @@ const union decode_item kprobe_decode_thumb16_table[] = {
>  
>  	/* STM				1100 0xxx xxxx xxxx */
>  	/* LDM				1100 1xxx xxxx xxxx */
> -	DECODE_EMULATE	(0xf000, 0xc000, t16_emulate_loregs_rwflags),
> +	DECODE_EMULATE	(0xf000, 0xc000, PROBES_T16_LDMSTM),
>  
>  	/*
>  	 * Conditional branch, and Supervisor Call
> @@ -1417,16 +1422,70 @@ const union decode_item kprobe_decode_thumb16_table[] = {
>  	DECODE_REJECT	(0xfe00, 0xde00),
>  
>  	/* Conditional branch		1101 xxxx xxxx xxxx */
> -	DECODE_CUSTOM	(0xf000, 0xd000, t16_decode_cond_branch),
> +	DECODE_CUSTOM	(0xf000, 0xd000, PROBES_T16_BRANCH_COND),
>  
>  	/*
>  	 * Unconditional branch
>  	 * B				1110 0xxx xxxx xxxx
>  	 */
> -	DECODE_SIMULATE	(0xf800, 0xe000, t16_simulate_branch),
> +	DECODE_SIMULATE	(0xf800, 0xe000, PROBES_T16_BRANCH),
>  
>  	DECODE_END
>  };
> +
> +const union decode_item kprobes_t32_actions[] = {

I wonder if it would be a good idea to make sure these arrays are the
size we expect by adding an entry at the end of the relevant enumeration
and using that it set the size of the arrays. E.g. for this one

enum probes_t32_action {
	...
	...
	NUM_PROBES_T32_ACTIONS
};

and then use it like

const union decode_item kprobes_t32_actions[NUM_PROBES_T32_ACTIONS]

that way, we at least make any uninitialised entries are null (i
assume?) which is safer than accidentally indexing beyond the array.

> +	[PROBES_T32_LDMSTM] = {.decoder = t32_decode_ldmstm},
> +	[PROBES_T32_LDRDSTRD] = {.handler = t32_emulate_ldrdstrd},
> +	[PROBES_T32_TABLE_BRANCH] = {.handler = t32_simulate_table_branch},
> +	[PROBES_T32_TST] = {.handler = t32_emulate_rd8rn16rm0_rwflags},
> +	[PROBES_T32_MOV] = {.handler = t32_emulate_rd8rn16rm0_rwflags},
> +	[PROBES_T32_ADDSUB] = {.handler = t32_emulate_rd8rn16rm0_rwflags},
> +	[PROBES_T32_LOGICAL] = {.handler = t32_emulate_rd8rn16rm0_rwflags},
> +	[PROBES_T32_CMP] = {.handler = t32_emulate_rd8rn16rm0_rwflags},
> +	[PROBES_T32_ADDWSUBW_PC] = {.handler = t32_emulate_rd8pc16_noflags,},
> +	[PROBES_T32_ADDWSUBW] = {.handler = t32_emulate_rd8rn16_noflags},
> +	[PROBES_T32_MOVW] = {.handler = t32_emulate_rd8rn16_noflags},
> +	[PROBES_T32_SAT] = {.handler = t32_emulate_rd8rn16rm0_rwflags},
> +	[PROBES_T32_BITFIELD] = {.handler = t32_emulate_rd8rn16_noflags},
> +	[PROBES_T32_SEV] = {.handler = probes_emulate_none},
> +	[PROBES_T32_WFE] = {.handler = probes_simulate_nop},
> +	[PROBES_T32_MRS] = {.handler = t32_simulate_mrs},
> +	[PROBES_T32_BRANCH_COND] = {.decoder = t32_decode_cond_branch},
> +	[PROBES_T32_BRANCH] = {.handler = t32_simulate_branch},
> +	[PROBES_T32_PLDI] = {.handler = probes_simulate_nop},
> +	[PROBES_T32_LDR_LIT] = {.handler = t32_simulate_ldr_literal},
> +	[PROBES_T32_LDRSTR] = {.handler = t32_emulate_ldrstr},
> +	[PROBES_T32_SIGN_EXTEND] = {.handler = t32_emulate_rd8rn16rm0_rwflags},
> +	[PROBES_T32_MEDIA] = {.handler = t32_emulate_rd8rn16rm0_rwflags},
> +	[PROBES_T32_REVERSE] = {.handler = t32_emulate_rd8rn16_noflags},
> +	[PROBES_T32_MUL_ADD] = {.handler = t32_emulate_rd8rn16rm0_rwflags},
> +	[PROBES_T32_MUL_ADD2] = {.handler = t32_emulate_rd8rn16rm0ra12_noflags},
> +	[PROBES_T32_MUL_ADD_LONG] = {.handler = t32_emulate_rdlo12rdhi8rn16rm0_noflags},
> +};
> +
> +const union decode_item kprobes_t16_actions[] = {
> +	[PROBES_T16_ADD_SP] = {.handler = t16_simulate_add_sp_imm},
> +	[PROBES_T16_CBZ] = {.handler = t16_simulate_cbz},
> +	[PROBES_T16_SIGN_EXTEND] = {.handler = t16_emulate_loregs_rwflags},
> +	[PROBES_T16_PUSH] = {.decoder = t16_decode_push},
> +	[PROBES_T16_POP] = {.decoder = t16_decode_pop},
> +	[PROBES_T16_SEV] = {.handler = probes_emulate_none},
> +	[PROBES_T16_WFE] = {.handler = probes_simulate_nop},
> +	[PROBES_T16_IT] = {.decoder = t16_decode_it},
> +	[PROBES_T16_CMP] = {.handler = t16_emulate_loregs_rwflags},
> +	[PROBES_T16_ADDSUB] = {.handler = t16_emulate_loregs_noitrwflags},
> +	[PROBES_T16_LOGICAL] = {.handler = t16_emulate_loregs_noitrwflags},
> +	[PROBES_T16_LDR_LIT] = {.handler = t16_simulate_ldr_literal},
> +	[PROBES_T16_BLX] = {.handler = t16_simulate_bxblx},
> +	[PROBES_T16_HIREGOPS] = {.decoder = t16_decode_hiregs},
> +	[PROBES_T16_LDRHSTRH] = {.handler = t16_emulate_loregs_rwflags},
> +	[PROBES_T16_LDRSTR] = {.handler = t16_simulate_ldrstr_sp_relative},
> +	[PROBES_T16_ADR] = {.handler = t16_simulate_reladr},
> +	[PROBES_T16_LDMSTM] = {.handler = t16_emulate_loregs_rwflags},
> +	[PROBES_T16_BRANCH_COND] = {.decoder = t16_decode_cond_branch},
> +	[PROBES_T16_BRANCH] = {.handler = t16_simulate_branch},
> +};
> +
>  #ifdef CONFIG_ARM_KPROBES_TEST_MODULE
>  EXPORT_SYMBOL_GPL(kprobe_decode_thumb16_table);
>  #endif
> @@ -1453,17 +1512,21 @@ static void __kprobes thumb32_singlestep(struct kprobe *p, struct pt_regs *regs)
>  }
>  
>  enum kprobe_insn __kprobes
> -thumb16_kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi)
> +thumb16_kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
> +			   bool usermode, const union decode_item *actions)
>  {
>  	asi->insn_singlestep = thumb16_singlestep;
>  	asi->insn_check_cc = thumb_check_cc;
> -	return kprobe_decode_insn(insn, asi, kprobe_decode_thumb16_table, true);
> +	return probes_decode_insn(insn, asi, kprobe_decode_thumb16_table, true,
> +				  usermode, actions);
>  }
>  
>  enum kprobe_insn __kprobes
> -thumb32_kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi)
> +thumb32_kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
> +			   bool usermode, const union decode_item *actions)
>  {
>  	asi->insn_singlestep = thumb32_singlestep;
>  	asi->insn_check_cc = thumb_check_cc;
> -	return kprobe_decode_insn(insn, asi, kprobe_decode_thumb32_table, true);
> +	return probes_decode_insn(insn, asi, kprobe_decode_thumb32_table, true,
> +				  usermode, actions);
>  }
> diff --git a/arch/arm/kernel/kprobes.c b/arch/arm/kernel/kprobes.c
> index 170e9f3..7b484d3 100644
> --- a/arch/arm/kernel/kprobes.c
> +++ b/arch/arm/kernel/kprobes.c
> @@ -29,6 +29,7 @@
>  #include <asm/cacheflush.h>
>  
>  #include "kprobes.h"
> +#include "probes.h"
>  #include "patch.h"
>  
>  #define MIN_STACK_SIZE(addr) 				\
> @@ -54,6 +55,7 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
>  	unsigned long addr = (unsigned long)p->addr;
>  	bool thumb;
>  	kprobe_decode_insn_t *decode_insn;
> +	const union decode_item *actions;
>  	int is;
>  
>  	if (in_exception_text(addr))
> @@ -67,20 +69,25 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
>  		insn <<= 16;
>  		insn |= ((u16 *)addr)[1];
>  		decode_insn = thumb32_kprobe_decode_insn;
> -	} else
> +		actions = kprobes_t32_actions;
> +	} else {
>  		decode_insn = thumb16_kprobe_decode_insn;
> +		actions = kprobes_t16_actions;
> +	}
>  #else /* !CONFIG_THUMB2_KERNEL */
>  	thumb = false;
>  	if (addr & 0x3)
>  		return -EINVAL;
>  	insn = *p->addr;
>  	decode_insn = arm_kprobe_decode_insn;
> +	actions = kprobes_probes_actions;
>  #endif
>  
>  	p->opcode = insn;
>  	p->ainsn.insn = tmp_insn;
>  
> -	switch ((*decode_insn)(insn, &p->ainsn)) {
> +	switch ((*decode_insn)(insn, &p->ainsn, false,
> +			       actions)) {
>  	case INSN_REJECTED:	/* not supported */
>  		return -EINVAL;
>  
> diff --git a/arch/arm/kernel/kprobes.h b/arch/arm/kernel/kprobes.h
> index 9aa2f15..6ca1cbe 100644
> --- a/arch/arm/kernel/kprobes.h
> +++ b/arch/arm/kernel/kprobes.h
> @@ -34,22 +34,6 @@ enum kprobe_insn {
>  	INSN_GOOD_NO_SLOT
>  };
>  
> -typedef enum kprobe_insn (kprobe_decode_insn_t)(kprobe_opcode_t,
> -						struct arch_specific_insn *);
> -
> -#ifdef CONFIG_THUMB2_KERNEL
> -
> -enum kprobe_insn thumb16_kprobe_decode_insn(kprobe_opcode_t,
> -						struct arch_specific_insn *);
> -enum kprobe_insn thumb32_kprobe_decode_insn(kprobe_opcode_t,
> -						struct arch_specific_insn *);
> -
> -#else /* !CONFIG_THUMB2_KERNEL */
> -
> -enum kprobe_insn arm_kprobe_decode_insn(kprobe_opcode_t,
> -					struct arch_specific_insn *);
> -#endif
> -
>  void __init arm_kprobe_decode_init(void);
>  
>  extern kprobe_check_cc * const kprobe_condition_checks[16];
> @@ -161,11 +145,9 @@ static inline void __kprobes alu_write_pc(long pcv, struct pt_regs *regs)
>  }
>  
> 
> -void __kprobes probes_simulate_nop(struct kprobe *p, struct pt_regs *regs);
> -void __kprobes probes_emulate_none(struct kprobe *p, struct pt_regs *regs);
> -
>  enum kprobe_insn __kprobes
> -kprobe_decode_ldmstm(kprobe_opcode_t insn, struct arch_specific_insn *asi);
> +kprobe_decode_ldmstm(kprobe_opcode_t insn, struct arch_specific_insn *asi,
> +		     void *d);
>  
>  /*
>   * Test if load/store instructions writeback the address register.
> @@ -331,7 +313,9 @@ union decode_item {
>  	u32			bits;
>  	const union decode_item	*table;
>  	kprobe_insn_handler_t	*handler;
> -	kprobe_decode_insn_t	*decoder;
> +	enum kprobe_insn (*decoder)(kprobe_opcode_t,
> +				    struct arch_specific_insn *,
> +				    void *d);
>  };
>  
> 
> @@ -368,7 +352,7 @@ struct decode_custom {
>  
>  #define DECODE_CUSTOM(_mask, _value, _decoder)			\
>  	DECODE_HEADER(DECODE_TYPE_CUSTOM, _mask, _value, 0),	\
> -	{.decoder = (_decoder)}
> +	{.bits = (_decoder)}

'bits' looks a bit funny here. I've been trying to think of a way of
making it nicer but it's difficult. The actual value is one of three
different enums, so if we were to add another members to decode_item it
would just have to be "int action", at least that would read nicer in
these macros and where it gets read out in probes_decode_insn.

>  
> 
>  struct decode_simulate {
> @@ -378,7 +362,7 @@ struct decode_simulate {
>  
>  #define DECODE_SIMULATEX(_mask, _value, _handler, _regs)		\
>  	DECODE_HEADER(DECODE_TYPE_SIMULATE, _mask, _value, _regs),	\
> -	{.handler = (_handler)}
> +	{.bits = (_handler)}
>  
>  #define DECODE_SIMULATE(_mask, _value, _handler)	\
>  	DECODE_SIMULATEX(_mask, _value, _handler, 0)
> @@ -391,12 +375,11 @@ struct decode_emulate {
>  
>  #define DECODE_EMULATEX(_mask, _value, _handler, _regs)			\
>  	DECODE_HEADER(DECODE_TYPE_EMULATE, _mask, _value, _regs),	\
> -	{.handler = (_handler)}
> +	{.bits = (_handler)}
>  
>  #define DECODE_EMULATE(_mask, _value, _handler)		\
>  	DECODE_EMULATEX(_mask, _value, _handler, 0)
>  
> -
>  struct decode_or {
>  	struct decode_header	header;
>  };
> @@ -413,16 +396,39 @@ struct decode_reject {
>  	DECODE_HEADER(DECODE_TYPE_REJECT, _mask, _value, 0)
>  
> 
> +typedef enum kprobe_insn (kprobe_decode_insn_t)(kprobe_opcode_t,
> +						struct arch_specific_insn *,
> +						bool usermode,
> +						const union decode_item *actions);
> +
>  #ifdef CONFIG_THUMB2_KERNEL
> +
> +enum kprobe_insn thumb16_kprobe_decode_insn(kprobe_opcode_t,
> +					    struct arch_specific_insn *,
> +					    bool usermode,
> +					    const union decode_item *actions);
> +
> +enum kprobe_insn thumb32_kprobe_decode_insn(kprobe_opcode_t,
> +					    struct arch_specific_insn *,
> +					    bool usermode,
> +					    const union decode_item *actions);
> +
>  extern const union decode_item kprobe_decode_thumb16_table[];
>  extern const union decode_item kprobe_decode_thumb32_table[];
> -#else
> -extern const union decode_item kprobe_decode_arm_table[];
> -#endif
> +extern const union decode_item kprobes_t32_actions[];
> +extern const union decode_item kprobes_t16_actions[];
>  
> +#else
>  
>  int kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
> -			const union decode_item *table, bool thumb16);
> +			const union decode_item *table, bool thumb16,
> +			bool usermode,
> +			const union decode_item *actions);
> +
> +extern const union decode_item kprobe_decode_arm_table[];
> +extern const union decode_item kprobes_probes_actions[];
> +
> +#endif
>  
> 
>  #endif /* _ARM_KERNEL_KPROBES_H */
> diff --git a/arch/arm/kernel/probes-arm.c b/arch/arm/kernel/probes-arm.c
> index e1b1a6e..e67bf3f 100644
> --- a/arch/arm/kernel/probes-arm.c
> +++ b/arch/arm/kernel/probes-arm.c
> @@ -18,8 +18,8 @@
>  #include <linux/kernel.h>
>  #include <linux/kprobes.h>
>  
> -#include "probes.h"
>  #include "kprobes.h"
> +#include "probes.h"

Minor nitpick, perhaps it would have been best to added the include in
the right place in the earlier patch rather than move it here.


>  #define sign_extend(x, signbit) ((x) | (0 - ((x) & (1 << (signbit)))))
>  
> diff --git a/arch/arm/kernel/probes-arm.h b/arch/arm/kernel/probes-arm.h
> new file mode 100644
> index 0000000..b1690878
> --- /dev/null
> +++ b/arch/arm/kernel/probes-arm.h
> @@ -0,0 +1,60 @@
> +#ifndef _ARM_KERNEL_PROBES_ARM_H
> +#define  _ARM_KERNEL_PROBES_ARM_H
> +
> +enum probes_action {
> +	PROBES_EMULATE_NONE,
> +	PROBES_SIMULATE_NOP,
> +	PROBES_PRELOAD_IMM,
> +	PROBES_PRELOAD_REG,
> +	PROBES_BRANCH_IMM,
> +	PROBES_BRANCH_REG,
> +	PROBES_MRS,
> +	PROBES_CLZ,
> +	PROBES_SATURATING_ARITHMETIC,
> +	PROBES_MUL1,
> +	PROBES_MUL2,
> +	PROBES_SWP,
> +	PROBES_LDRSTRD,
> +	PROBES_LOAD,
> +	PROBES_STORE,
> +	PROBES_LOAD_EXTRA,
> +	PROBES_STORE_EXTRA,
> +	PROBES_MOV_IP_SP,
> +	PROBES_DATA_PROCESSING_REG,
> +	PROBES_DATA_PROCESSING_IMM,
> +	PROBES_MOV_HALFWORD,
> +	PROBES_SEV,
> +	PROBES_WFE,
> +	PROBES_SATURATE,
> +	PROBES_REV,
> +	PROBES_MMI,
> +	PROBES_PACK,
> +	PROBES_EXTEND,
> +	PROBES_EXTEND_ADD,
> +	PROBES_MUL_ADD_LONG,
> +	PROBES_MUL_ADD,
> +	PROBES_BITFIELD,
> +	PROBES_BRANCH,
> +	PROBES_LDMSTM
> +};
> +
> +void __kprobes simulate_bbl(struct kprobe *p, struct pt_regs *regs);
> +void __kprobes simulate_blx1(struct kprobe *p, struct pt_regs *regs);
> +void __kprobes simulate_blx2bx(struct kprobe *p, struct pt_regs *regs);
> +void __kprobes simulate_mrs(struct kprobe *p, struct pt_regs *regs);
> +void __kprobes simulate_mov_ipsp(struct kprobe *p, struct pt_regs *regs);
> +void __kprobes emulate_ldrdstrd(struct kprobe *p, struct pt_regs *regs);
> +void __kprobes emulate_ldr(struct kprobe *p, struct pt_regs *regs);
> +void __kprobes emulate_str(struct kprobe *p, struct pt_regs *regs);
> +void __kprobes emulate_rd12rn16rm0rs8_rwflags(struct kprobe *p,
> +					      struct pt_regs *regs);
> +void __kprobes emulate_rd12rn16rm0_rwflags_nopc(struct kprobe *p,
> +						struct pt_regs *regs);
> +void __kprobes emulate_rd16rn12rm0rs8_rwflags_nopc(struct kprobe *p,
> +						   struct pt_regs *regs);
> +void __kprobes emulate_rd12rm0_noflags_nopc(struct kprobe *p,
> +					    struct pt_regs *regs);
> +void __kprobes emulate_rdlo12rdhi16rn0rm8_rwflags_nopc(struct kprobe *p,
> +						       struct pt_regs *regs);
> +
> +#endif
> diff --git a/arch/arm/kernel/probes-thumb.h b/arch/arm/kernel/probes-thumb.h
> new file mode 100644
> index 0000000..4b9365c
> --- /dev/null
> +++ b/arch/arm/kernel/probes-thumb.h
> @@ -0,0 +1,59 @@
> +#ifndef _ARM_KERNEL_PROBES_THUMB_H
> +#define  _ARM_KERNEL_PROBES_THUMB_H
> +
> +enum probes_t32_action {
> +	PROBES_T32_EMULATE_NONE,
> +	PROBES_T32_SIMULATE_NOP,
> +	PROBES_T32_LDMSTM,
> +	PROBES_T32_LDRDSTRD,
> +	PROBES_T32_TABLE_BRANCH,
> +	PROBES_T32_TST,
> +	PROBES_T32_CMP,
> +	PROBES_T32_MOV,
> +	PROBES_T32_ADDSUB,
> +	PROBES_T32_LOGICAL,
> +	PROBES_T32_ADDWSUBW_PC,
> +	PROBES_T32_ADDWSUBW,
> +	PROBES_T32_MOVW,
> +	PROBES_T32_SAT,
> +	PROBES_T32_BITFIELD,
> +	PROBES_T32_SEV,
> +	PROBES_T32_WFE,
> +	PROBES_T32_MRS,
> +	PROBES_T32_BRANCH_COND,
> +	PROBES_T32_BRANCH,
> +	PROBES_T32_PLDI,
> +	PROBES_T32_LDR_LIT,
> +	PROBES_T32_LDRSTR,
> +	PROBES_T32_SIGN_EXTEND,
> +	PROBES_T32_MEDIA,
> +	PROBES_T32_REVERSE,
> +	PROBES_T32_MUL_ADD,
> +	PROBES_T32_MUL_ADD2,
> +	PROBES_T32_MUL_ADD_LONG
> +};
> +
> +enum probes_t16_action {
> +	PROBES_T16_ADD_SP,
> +	PROBES_T16_CBZ,
> +	PROBES_T16_SIGN_EXTEND,
> +	PROBES_T16_PUSH,
> +	PROBES_T16_POP,
> +	PROBES_T16_SEV,
> +	PROBES_T16_WFE,
> +	PROBES_T16_IT,
> +	PROBES_T16_CMP,
> +	PROBES_T16_ADDSUB,
> +	PROBES_T16_LOGICAL,
> +	PROBES_T16_BLX,
> +	PROBES_T16_HIREGOPS,
> +	PROBES_T16_LDR_LIT,
> +	PROBES_T16_LDRHSTRH,
> +	PROBES_T16_LDRSTR,
> +	PROBES_T16_ADR,
> +	PROBES_T16_LDMSTM,
> +	PROBES_T16_BRANCH_COND,
> +	PROBES_T16_BRANCH
> +};
> +
> +#endif
> diff --git a/arch/arm/kernel/probes.c b/arch/arm/kernel/probes.c
> index 86c63f3..8cff27a 100644
> --- a/arch/arm/kernel/probes.c
> +++ b/arch/arm/kernel/probes.c
> @@ -1,23 +1,8 @@
> -/*
> - * arch/arm/kernel/probes.c
> - *
> - * Some contents moved here from arch/arm/include/asm/kprobes-common.c
> - *
> - * Copyright (C) 2011 Jon Medhurst <tixy@yxit.co.uk>.
> - *
> - * Some contents moved here from arch/arm/include/asm/kprobes-arm.c which is
> - * Copyright (C) 2006, 2007 Motorola Inc.
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 as
> - * published by the Free Software Foundation.
> - */
> -

Any reason why this is deleted?

>  #include <linux/kernel.h>
>  #include <linux/kprobes.h>
>  
> -#include "probes.h"
>  #include "kprobes.h"
> +#include "probes.h"
>  
>  void __kprobes probes_simulate_nop(struct kprobe *p, struct pt_regs *regs)
>  {
> @@ -28,6 +13,47 @@ void __kprobes probes_emulate_none(struct kprobe *p, struct pt_regs *regs)
>  	p->ainsn.insn_fn();
>  }
>  
> +#define sign_extend(x, signbit) ((x) | (0 - ((x) & (1 << (signbit)))))
> +
> +#define branch_displacement(insn) sign_extend(((insn) & 0xffffff) << 2, 25)
> +
> +#if  __LINUX_ARM_ARCH__ >= 6
> +#define BLX(reg)	"blx	"reg"		\n\t"
> +#else
> +#define BLX(reg)	"mov	lr, pc		\n\t"	\
> +			"mov	pc, "reg"	\n\t"
> +#endif
> +
> +/*
> + * To avoid the complications of mimicing single-stepping on a
> + * processor without a Next-PC or a single-step mode, and to
> + * avoid having to deal with the side-effects of boosting, we
> + * simulate or emulate (almost) all ARM instructions.
> + *
> + * "Simulation" is where the instruction's behavior is duplicated in
> + * C code.  "Emulation" is where the original instruction is rewritten
> + * and executed, often by altering its registers.
> + *
> + * By having all behavior of the kprobe'd instruction completed before
> + * returning from the kprobe_handler(), all locks (scheduler and
> + * interrupt) can safely be released.  There is no need for secondary
> + * breakpoints, no race with MP or preemptable kernels, nor having to
> + * clean up resources counts at a later time impacting overall system
> + * performance.  By rewriting the instruction, only the minimum registers
> + * need to be loaded and saved back optimizing performance.
> + *
> + * Calling the insnslot_*_rwflags version of a function doesn't hurt
> + * anything even when the CPSR flags aren't updated by the
> + * instruction.  It's just a little slower in return for saving
> + * a little space by not having a duplicate function that doesn't
> + * update the flags.  (The same optimization can be said for
> + * instructions that do or don't perform register writeback)
> + * Also, instructions can either read the flags, only write the
> + * flags, or read and write the flags.  To save combinations
> + * rather than for sheer performance, flag functions just assume
> + * read and write of flags.
> + */
> +

The whole added block above looks spurious, probably a mistake when
re-factoring patches?

>  /*
>   * Prepare an instruction slot to receive an instruction for emulating.
>   * This is done by placing a subroutine return after the location where the
> @@ -97,7 +123,7 @@ set_emulated_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
>   * non-zero value, the corresponding nibble in pinsn is validated and modified
>   * according to the type.
>   */
> -static bool __kprobes decode_regs(kprobe_opcode_t *pinsn, u32 regs)
> +static bool __kprobes decode_regs(kprobe_opcode_t *pinsn, u32 regs, bool modify)
>  {
>  	kprobe_opcode_t insn = *pinsn;
>  	kprobe_opcode_t mask = 0xf; /* Start at least significant nibble */
> @@ -158,12 +184,16 @@ static bool __kprobes decode_regs(kprobe_opcode_t *pinsn, u32 regs)
>  			break;
>  		}
>  
> -		/* Replace value of nibble with new register number... */
> -		insn &= ~mask;
> -		insn |= new_bits & mask;
> +		if (modify) {
> +			/* Replace value of nibble with new register number */
> +			insn &= ~mask;
> +			insn |= new_bits & mask;
> +		}
>  	}
>  
> -	*pinsn = insn;
> +	if (modify)
> +		*pinsn = insn;
> +
>  	return true;
>  
>  reject:
> @@ -223,14 +253,17 @@ static const int decode_struct_sizes[NUM_DECODE_TYPES] = {
>   *
>   */
>  int __kprobes
> -kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
> -				const union decode_item *table, bool thumb)
> +probes_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
> +				const union decode_item *table, bool thumb,
> +				bool usermode,
> +				const union decode_item *actions)
>  {
>  	const struct decode_header *h = (struct decode_header *)table;
>  	const struct decode_header *next;
>  	bool matched = false;
>  
> -	insn = prepare_emulated_insn(insn, asi, thumb);
> +	if (!usermode)
> +		insn = prepare_emulated_insn(insn, asi, thumb);
>  
>  	for (;; h = next) {
>  		enum decode_type type = h->type_regs.bits & DECODE_TYPE_MASK;
> @@ -242,14 +275,14 @@ kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
>  		next = (struct decode_header *)
>  				((uintptr_t)h + decode_struct_sizes[type]);
>  
> -		if (!matched && (insn & h->mask.bits) != h->value.bits)
> +		if (!matched &&
> +		    (insn & h->mask.bits) != h->value.bits)
>  			continue;

Any reason for splitting the line?

> -		if (!decode_regs(&insn, regs))
> +		if (!decode_regs(&insn, regs, !usermode))
>  			return INSN_REJECTED;
>  
>  		switch (type) {struct decode_header
> -
>  		case DECODE_TYPE_TABLE: {
>  			struct decode_table *d = (struct decode_table *)h;
>  			next = (struct decode_header *)d->table.table;
> @@ -258,18 +291,24 @@ kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
>  
>  		case DECODE_TYPE_CUSTOM: {
>  			struct decode_custom *d = (struct decode_custom *)h;
> -			return (*d->decoder.decoder)(insn, asi);
> +
> +			return actions[d->decoder.bits].decoder(insn, asi, d);
>  		}
>  
>  		case DECODE_TYPE_SIMULATE: {
>  			struct decode_simulate *d = (struct decode_simulate *)h;
> -			asi->insn_handler = d->handler.handler;
> +			asi->insn_handler = actions[d->handler.bits].handler;
>  			return INSN_GOOD_NO_SLOT;
>  		}
>  
>  		case DECODE_TYPE_EMULATE: {
>  			struct decode_emulate *d = (struct decode_emulate *)h;
> -			asi->insn_handler = d->handler.handler;
> +
> +			if (usermode)
> +				return actions[d->handler.bits].decoder(insn,
> +									asi, d);
> +
> +			asi->insn_handler = actions[d->handler.bits].handler;

This change of behaviour depending on usermode seems to indicate that we
haven't quite got the abstractions right. But at the moment I can't think
about a possible alternative though.

>  			set_emulated_insn(insn, asi, thumb);
>  			return INSN_GOOD;
>  		}
> diff --git a/arch/arm/kernel/probes.h b/arch/arm/kernel/probes.h
> index 56eec12..bc03c690 100644
> --- a/arch/arm/kernel/probes.h
> +++ b/arch/arm/kernel/probes.h
> @@ -1,6 +1,18 @@
>  #ifndef _ARM_KERNEL_PROBES_H
>  #define  _ARM_KERNEL_PROBES_H
>  
> +int __kprobes
> +probes_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
> +				const union decode_item *table, bool thumb,
> +				bool usermode,
> +				const union decode_item *actions);
> +enum kprobe_insn arm_kprobe_decode_insn(kprobe_opcode_t,
> +					struct arch_specific_insn *,
> +					bool usermode,
> +					const union decode_item *actions);
> +
> +void __kprobes probes_simulate_nop(struct kprobe *p, struct pt_regs *regs);
> +void __kprobes probes_emulate_none(struct kprobe *p, struct pt_regs *regs);
>  void __kprobes simulate_bbl(struct kprobe *p, struct pt_regs *regs);
>  void __kprobes simulate_blx1(struct kprobe *p, struct pt_regs *regs);
>  void __kprobes simulate_blx2bx(struct kprobe *p, struct pt_regs *regs);

-- 
Tixy




