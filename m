Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965512AbaH1Jv2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 05:51:28 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:46855 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936483AbaH1Jv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 05:51:27 -0400
Message-ID: <53FEFB93.2010009@hitachi.com>
Date: Thu, 28 Aug 2014 18:51:15 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Wang Nan <wangnan0@huawei.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        "David A. Long" <dave.long@linaro.org>, Jon Medhurst <tixy@linaro.org>,
        Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Will Deacon <will.deacon@arm.com>, Pei Feiyue <peifeiyue@huawei.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/3] ARM: probes: check stack operation when decoding
References: <1409144552-12751-1-git-send-email-wangnan0@huawei.com> <1409144552-12751-2-git-send-email-wangnan0@huawei.com>
In-Reply-To: <1409144552-12751-2-git-send-email-wangnan0@huawei.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/08/27 22:02), Wang Nan wrote:
> This patch improves arm instruction decoder, allows it check whether an
> instruction is a stack store operation. This information is important
> for kprobe optimization.
> 
> For normal str instruction, this patch add a series of _SP_STACK
> register indicator in the decoder to test the base and offset register
> in ldr <Rt>, [<Rn>, <Rm>] against sp.
> 
> For stm instruction, it check sp register in instruction specific
> decoder.

OK, reviewed. but since I'm not so sure about arm32 ISA,
I need help from ARM32 maintainer to ack this.

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you,

> 
> Signed-off-by: Wang Nan <wangnan0@huawei.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: "David A. Long" <dave.long@linaro.org> 
> Cc: Jon Medhurst <tixy@linaro.org>
> Cc: Taras Kondratiuk <taras.kondratiuk@linaro.org>
> Cc: Ben Dooks <ben.dooks@codethink.co.uk>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Will Deacon <will.deacon@arm.com>
> 
> ---
>  arch/arm/include/asm/probes.h    |  1 +
>  arch/arm/kernel/kprobes-common.c |  4 ++++
>  arch/arm/kernel/probes-arm.c     |  4 ++--
>  arch/arm/kernel/probes-thumb.c   |  6 +++---
>  arch/arm/kernel/probes.c         | 20 ++++++++++++++++++--
>  arch/arm/kernel/probes.h         |  6 ++++++
>  6 files changed, 34 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm/include/asm/probes.h b/arch/arm/include/asm/probes.h
> index 806cfe6..3f6912c 100644
> --- a/arch/arm/include/asm/probes.h
> +++ b/arch/arm/include/asm/probes.h
> @@ -38,6 +38,7 @@ struct arch_probes_insn {
>  	probes_check_cc			*insn_check_cc;
>  	probes_insn_singlestep_t	*insn_singlestep;
>  	probes_insn_fn_t		*insn_fn;
> +	bool				is_stack_operation;
>  };
>  
>  #endif
> diff --git a/arch/arm/kernel/kprobes-common.c b/arch/arm/kernel/kprobes-common.c
> index 0bf5d64..4e8b918 100644
> --- a/arch/arm/kernel/kprobes-common.c
> +++ b/arch/arm/kernel/kprobes-common.c
> @@ -133,6 +133,10 @@ kprobe_decode_ldmstm(probes_opcode_t insn, struct arch_probes_insn *asi,
>  	int is_ldm = insn & 0x100000;
>  	int rn = (insn >> 16) & 0xf;
>  
> +	/* whether this is a push instruction? */
> +	if ((rn == 0xd) && (!is_ldm))
> +		asi->is_stack_operation = true;
> +
>  	if (rn <= 12 && (reglist & 0xe000) == 0) {
>  		/* Instruction only uses registers in the range R0..R12 */
>  		handler = emulate_generic_r0_12_noflags;
> diff --git a/arch/arm/kernel/probes-arm.c b/arch/arm/kernel/probes-arm.c
> index 8eaef81..5c187ba 100644
> --- a/arch/arm/kernel/probes-arm.c
> +++ b/arch/arm/kernel/probes-arm.c
> @@ -577,7 +577,7 @@ static const union decode_item arm_cccc_01xx_table[] = {
>  	/* STR (immediate)	cccc 010x x0x0 xxxx xxxx xxxx xxxx xxxx */
>  	/* STRB (immediate)	cccc 010x x1x0 xxxx xxxx xxxx xxxx xxxx */
>  	DECODE_EMULATEX	(0x0e100000, 0x04000000, PROBES_STORE,
> -						 REGS(NOPCWB, ANY, 0, 0, 0)),
> +						 REGS(NOPCWB_SP_STACK, ANY, 0, 0, 0)),
>  
>  	/* LDR (immediate)	cccc 010x x0x1 xxxx xxxx xxxx xxxx xxxx */
>  	/* LDRB (immediate)	cccc 010x x1x1 xxxx xxxx xxxx xxxx xxxx */
> @@ -587,7 +587,7 @@ static const union decode_item arm_cccc_01xx_table[] = {
>  	/* STR (register)	cccc 011x x0x0 xxxx xxxx xxxx xxxx xxxx */
>  	/* STRB (register)	cccc 011x x1x0 xxxx xxxx xxxx xxxx xxxx */
>  	DECODE_EMULATEX	(0x0e100000, 0x06000000, PROBES_STORE,
> -						 REGS(NOPCWB, ANY, 0, 0, NOPC)),
> +						 REGS(NOPCWB_SP_STACK, ANY, 0, 0, NOPC_SP_STACK)),
>  
>  	/* LDR (register)	cccc 011x x0x1 xxxx xxxx xxxx xxxx xxxx */
>  	/* LDRB (register)	cccc 011x x1x1 xxxx xxxx xxxx xxxx xxxx */
> diff --git a/arch/arm/kernel/probes-thumb.c b/arch/arm/kernel/probes-thumb.c
> index 4131351..d0d30d8 100644
> --- a/arch/arm/kernel/probes-thumb.c
> +++ b/arch/arm/kernel/probes-thumb.c
> @@ -54,7 +54,7 @@ static const union decode_item t32_table_1110_100x_x1xx[] = {
>  	/* STRD (immediate)	1110 1001 x1x0 xxxx xxxx xxxx xxxx xxxx */
>  	/* LDRD (immediate)	1110 1001 x1x1 xxxx xxxx xxxx xxxx xxxx */
>  	DECODE_EMULATEX	(0xff400000, 0xe9400000, PROBES_T32_LDRDSTRD,
> -						 REGS(NOPCWB, NOSPPC, NOSPPC, 0, 0)),
> +						 REGS(NOPCWB_SP_STACK, NOSPPC, NOSPPC, 0, 0)),
>  
>  	/* TBB			1110 1000 1101 xxxx xxxx xxxx 0000 xxxx */
>  	/* TBH			1110 1000 1101 xxxx xxxx xxxx 0001 xxxx */
> @@ -345,12 +345,12 @@ static const union decode_item t32_table_1111_100x[] = {
>  	/* STR (immediate)	1111 1000 1100 xxxx xxxx xxxx xxxx xxxx */
>  	/* LDR (immediate)	1111 1000 1101 xxxx xxxx xxxx xxxx xxxx */
>  	DECODE_EMULATEX	(0xffe00000, 0xf8c00000, PROBES_T32_LDRSTR,
> -						 REGS(NOPCX, ANY, 0, 0, 0)),
> +						 REGS(NOPCX_SP_STACK, ANY, 0, 0, 0)),
>  
>  	/* STR (register)	1111 1000 0100 xxxx xxxx 0000 00xx xxxx */
>  	/* LDR (register)	1111 1000 0101 xxxx xxxx 0000 00xx xxxx */
>  	DECODE_EMULATEX	(0xffe00fc0, 0xf8400000, PROBES_T32_LDRSTR,
> -						 REGS(NOPCX, ANY, 0, 0, NOSPPC)),
> +						 REGS(NOPCX_SP_STACK, ANY, 0, 0, NOSPPC)),
>  
>  	/* LDRB (literal)	1111 1000 x001 1111 xxxx xxxx xxxx xxxx */
>  	/* LDRSB (literal)	1111 1001 x001 1111 xxxx xxxx xxxx xxxx */
> diff --git a/arch/arm/kernel/probes.c b/arch/arm/kernel/probes.c
> index 1c77b8d..f811cac 100644
> --- a/arch/arm/kernel/probes.c
> +++ b/arch/arm/kernel/probes.c
> @@ -258,7 +258,9 @@ set_emulated_insn(probes_opcode_t insn, struct arch_probes_insn *asi,
>   * non-zero value, the corresponding nibble in pinsn is validated and modified
>   * according to the type.
>   */
> -static bool __kprobes decode_regs(probes_opcode_t *pinsn, u32 regs, bool modify)
> +static bool __kprobes decode_regs(probes_opcode_t *pinsn,
> +		struct arch_probes_insn *asi,
> +		u32 regs, bool modify)
>  {
>  	probes_opcode_t insn = *pinsn;
>  	probes_opcode_t mask = 0xf; /* Start at least significant nibble */
> @@ -307,11 +309,14 @@ static bool __kprobes decode_regs(probes_opcode_t *pinsn, u32 regs, bool modify)
>  				goto reject;
>  			break;
>  
> +		case REG_TYPE_NOPCWB_SP_STACK:
>  		case REG_TYPE_NOPCWB:
>  			if (!is_writeback(insn))
>  				break; /* No writeback, so any register is OK */
>  			/* fall through... */
> +		case REG_TYPE_NOPC_SP_STACK:
>  		case REG_TYPE_NOPC:
> +		case REG_TYPE_NOPCX_SP_STACK:
>  		case REG_TYPE_NOPCX:
>  			/* Reject PC (R15) */
>  			if (((insn ^ 0xffffffff) & mask) == 0)
> @@ -319,6 +324,15 @@ static bool __kprobes decode_regs(probes_opcode_t *pinsn, u32 regs, bool modify)
>  			break;
>  		}
>  
> +		/* check stack operation */
> +		switch (regs & 0xf) {
> +			case REG_TYPE_NOPCWB_SP_STACK:
> +			case REG_TYPE_NOPC_SP_STACK:
> +			case REG_TYPE_NOPCX_SP_STACK:
> +				if (((insn ^ 0xdddddddd) & mask) == 0)
> +					asi->is_stack_operation = true;
> +		}
> +
>  		/* Replace value of nibble with new register number... */
>  		insn &= ~mask;
>  		insn |= new_bits & mask;
> @@ -394,6 +408,8 @@ probes_decode_insn(probes_opcode_t insn, struct arch_probes_insn *asi,
>  	const struct decode_header *next;
>  	bool matched = false;
>  
> +	asi->is_stack_operation = false;
> +
>  	if (emulate)
>  		insn = prepare_emulated_insn(insn, asi, thumb);
>  
> @@ -410,7 +426,7 @@ probes_decode_insn(probes_opcode_t insn, struct arch_probes_insn *asi,
>  		if (!matched && (insn & h->mask.bits) != h->value.bits)
>  			continue;
>  
> -		if (!decode_regs(&insn, regs, emulate))
> +		if (!decode_regs(&insn, asi, regs, emulate))
>  			return INSN_REJECTED;
>  
>  		switch (type) {
> diff --git a/arch/arm/kernel/probes.h b/arch/arm/kernel/probes.h
> index dba9f24..568fd01 100644
> --- a/arch/arm/kernel/probes.h
> +++ b/arch/arm/kernel/probes.h
> @@ -278,13 +278,19 @@ enum decode_reg_type {
>  	REG_TYPE_NOSP,	   /* Register must not be SP */
>  	REG_TYPE_NOSPPC,   /* Register must not be SP or PC */
>  	REG_TYPE_NOPC,	   /* Register must not be PC */
> +	REG_TYPE_NOPC_SP_STACK,	   /* REG_TYPE_NOPC and if this reg is sp
> +				      then this is a stack operation */
>  	REG_TYPE_NOPCWB,   /* No PC if load/store write-back flag also set */
> +	REG_TYPE_NOPCWB_SP_STACK,   /* REG_TYPE_NOPCWB and, if this reg is sp
> +				       then this is a stack operation */
>  
>  	/* The following types are used when the encoding for PC indicates
>  	 * another instruction form. This distiction only matters for test
>  	 * case coverage checks.
>  	 */
>  	REG_TYPE_NOPCX,	   /* Register must not be PC */
> +	REG_TYPE_NOPCX_SP_STACK,	   /* REG_TYPE_NOPCX and if this reg is sp
> +					      then this is a stack operation */
>  	REG_TYPE_NOSPPCX,  /* Register must not be SP or PC */
>  
>  	/* Alias to allow '0' arg to be used in REGS macro. */
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


