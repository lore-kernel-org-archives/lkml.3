Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbbAMPBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:01:17 -0500
Received: from smarthost01d.mail.zen.net.uk ([212.23.1.7]:36721 "EHLO
	smarthost01d.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752272AbbAMPBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:01:15 -0500
Message-ID: <1421161268.4215.56.camel@linaro.org>
Subject: Re: [PATCH v19 10/11] ARM: kprobes: check register usage for probed
 instruction.
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Wang Nan <wangnan0@huawei.com>
Cc: masami.hiramatsu.pt@hitachi.com, linux@arm.linux.org.uk,
        lizefan@huawei.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Tue, 13 Jan 2015 15:01:08 +0000
In-Reply-To: <1420457384-77449-1-git-send-email-wangnan0@huawei.com>
References: <1420457284-76923-1-git-send-email-wangnan0@huawei.com>
	 <1420457384-77449-1-git-send-email-wangnan0@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01d-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-05 at 19:29 +0800, Wang Nan wrote:
> This patch utilizes previous introduced checker to check register usage
> for probed ARM instruction and saves it in a mask. Futher patch will
> use such information to avoid simuation or emulation.

There's a couple of spelling mistakes above and minor grammar nitpicks,
my suggestion to improve those would be to add the bits in [] in the
following...

  This patch utilizes [the] previous[ly] introduced checker to check
  register usage for probed ARM instruction and saves it in a mask. [A]
  fu[r]ther patch will use such information to avoid simu[l]ation or
  emulation.

My comments on the code below are mostly suggestions on how to simplify
things, though the code is already quite re is one bug.

> Signed-off-by: Wang Nan <wangnan0@huawei.com>
> ---
>  arch/arm/include/asm/probes.h          |  10 +++
>  arch/arm/probes/decode.c               |   7 ++
>  arch/arm/probes/kprobes/actions-arm.c  |   2 +-
>  arch/arm/probes/kprobes/checkers-arm.c | 124 +++++++++++++++++++++++++++++++++
>  arch/arm/probes/kprobes/checkers.h     |   1 +
>  5 files changed, 143 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/include/asm/probes.h b/arch/arm/include/asm/probes.h
> index f0a1ee8..27b65b7 100644
> --- a/arch/arm/include/asm/probes.h
> +++ b/arch/arm/include/asm/probes.h
> @@ -41,6 +41,16 @@ struct arch_probes_insn {
>  	probes_insn_singlestep_t	*insn_singlestep;
>  	probes_insn_fn_t		*insn_fn;
>  	int stack_space;
> +
> +	/* Use 1 bit for a register. */
> +#define REG_NO_USE	(0)
> +#define REG_USE		(1)

No need for () around the 0 and 1

> +#define __register_usage_flag(n, f)	((f) << (n))
> +#define __clean_register_flag(m, n)	((m) & (~(1 << (n))))
> +#define __set_register_flag(m, n, f)	(__clean_register_flag(m, n) | __register_usage_flag(n, f))
> +#define set_register_nouse(m, n)	do {(m) = __set_register_flag(m, n, REG_NO_USE);} while(0)
> +#define set_register_use(m, n)		do {(m) = __set_register_flag(m, n, REG_USE);} while(0)

All these macros seem a bit convoluted to me, and I don't think it makes
things any clearer than open coding a bit set operation like

	|= 1 << reg

especially as I don't thing those macros will end up getting much use.

> +	unsigned long register_usage_flag;

To nit-pick, as this isn't a single flag I would add an 's' to make the
name plural, i.e. 'register_usage_flags'

>  };
>  
>  #endif /* __ASSEMBLY__ */
> diff --git a/arch/arm/probes/decode.c b/arch/arm/probes/decode.c
> index f9d7c42..40f9402 100644
> --- a/arch/arm/probes/decode.c
> +++ b/arch/arm/probes/decode.c
> @@ -435,6 +435,13 @@ probes_decode_insn(probes_opcode_t insn, struct arch_probes_insn *asi,
>  	 */
>  	asi->stack_space = 0;
>  
> +	/*
> +	 * Similay to stack_space, register_usage_flag is filled by

Typo, s/Similay/Similarly/

> +	 * checkers. Its default value is set to ~0, which is 'all
> +	 * registers are used', to prevent any potential optimization.
> +	 */
> +	asi->register_usage_flag = ~(0UL);

No need for () around 0UL

> +
>  	if (emulate)
>  		insn = prepare_emulated_insn(insn, asi, thumb);
>  
> diff --git a/arch/arm/probes/kprobes/actions-arm.c b/arch/arm/probes/kprobes/actions-arm.c
> index 4fedd4c..26e435b 100644
> --- a/arch/arm/probes/kprobes/actions-arm.c
> +++ b/arch/arm/probes/kprobes/actions-arm.c
> @@ -340,4 +340,4 @@ const union decode_action kprobes_arm_actions[NUM_PROBES_ARM_ACTIONS] = {
>  	[PROBES_LDMSTM] = {.decoder = kprobe_decode_ldmstm}
>  };
>  
> -const struct decode_checker *kprobes_arm_checkers[] = {arm_stack_checker, NULL};
> +const struct decode_checker *kprobes_arm_checkers[] = {arm_stack_checker, arm_regs_checker, NULL};
> diff --git a/arch/arm/probes/kprobes/checkers-arm.c b/arch/arm/probes/kprobes/checkers-arm.c
> index f817663..1929225 100644
> --- a/arch/arm/probes/kprobes/checkers-arm.c
> +++ b/arch/arm/probes/kprobes/checkers-arm.c
> @@ -97,3 +97,127 @@ const struct decode_checker arm_stack_checker[NUM_PROBES_ARM_ACTIONS] = {
>  	[PROBES_STORE] = {.checker = arm_check_stack},
>  	[PROBES_LDMSTM] = {.checker = arm_check_stack},
>  };
> +
> +static enum probes_insn __kprobes arm_check_regs_nouse(probes_opcode_t insn,
> +		struct arch_probes_insn *asi,
> +		const struct decode_header *h)
> +{
> +	asi->register_usage_flag = 0;
> +	return INSN_GOOD;
> +}
> +
> +static void __arm_check_regs(probes_opcode_t insn,
> +		const struct decode_header *h,
> +		int *quintuple)
> +{
> +	int i;
> +	u32 regs = h->type_regs.bits >> DECODE_TYPE_BITS;
> +	probes_opcode_t mask, shifted;
> +
> +	memset(quintuple, 0xff, sizeof(int) * 5);

Not sure that filling with 0xff is a C standard compliant way of
initialising int's to a negative value. Anyway, memset isn't really
needed, see next comment.

> +	for (i = 0, shifted = insn, mask = 0xf; regs != 0;
> +			regs >>= 4, mask <<= 4, shifted >>= 4, i++)
> +		if (regs & 0xf)
> +			quintuple[i] = shifted & 0xf;

Looks a bit complicated, the last 6 lines could be more simply expressed
as:
	for (i = 0; i < 5; regs >>= 4, insn >>= 4, i++)
		quintuple[i] = regs & 0xf ? insn & 0xf : -1;

Though I think that this function may be a bit overkill anyway, it is
only really needed in one place, so may as well be inlined there, that
is the function below... 

> +}
> +
> +static enum probes_insn arm_check_regs_normal(probes_opcode_t insn,
> +		struct arch_probes_insn *asi,
> +		const struct decode_header *h)
> +{
> +	int quintuple[5], i;
> +	asi->register_usage_flag = 0;
> +	__arm_check_regs(insn, h, quintuple);
> +	for (i = 0; i < 5; i++) {
> +		int r = quintuple[i];
> +		if (r < 0)
> +			continue;
> +		set_register_use(asi->register_usage_flag, r);
> +	}
> +

The above can be as simply written without using _arm_check_regs like...

	u32 regs = h->type_regs.bits >> DECODE_TYPE_BITS;
	int i;

	asi->register_usage_flag = 0;
	for (i = 0; i < 5; regs >>= 4, insn >>= 4, i++)
		if (regs & 0xf)
			asi->register_usage_flag |= 1 << (insn & 0xf);


> +	return INSN_GOOD;
> +}
> +
> +static enum probes_insn arm_check_regs_ldmstm(probes_opcode_t insn,
> +		struct arch_probes_insn *asi,
> +		const struct decode_header *h)
> +{
> +	unsigned int reglist = insn & 0xffff;
> +	unsigned int rn = (insn >> 16) & 0xf;
> +	int i;
> +

Think you forgot to clear asi->register_usage_flag here, it will still
contain 0xffffffff set by from probes_decode_insn(). However, we don't
need this if we follow my next suggestion.

> +	set_register_use(asi->register_usage_flag, rn);
> +	for (i = 0; reglist > 0; i++, reglist >>= 1)
> +		if (reglist & 1)
> +			set_register_use(asi->register_usage_flag, i);

The preceding 5 lines are equivalent to

	asi->register_usage_flag = reglist | (1 << rn);

so how about we just use that?

> +	return INSN_GOOD;
> +}
> +
> +static enum probes_insn arm_check_regs_mov_ip_sp(probes_opcode_t insn,
> +		struct arch_probes_insn *asi,
> +		const struct decode_header *h)
> +{
> +	/* should be 'mov ip, sp' */
> +	set_register_use(asi->register_usage_flag, 12);
> +	set_register_use(asi->register_usage_flag, 13);

register_usage_flag needs setting to zero before setting the flags. Or
we could just write this function as

	/* Instruction is 'mov ip, sp' i.e. 'mov r12, r13' */
	asi->register_usage_flag = (1 << 12) | (1<< 13);

> +	return INSN_GOOD;
> +}
> +
> +/*
> + *                                    | Rn |Rt/d|         | Rm |
> + * LDRD (register)      cccc 000x x0x0 xxxx xxxx xxxx 1101 xxxx
> + * STRD (register)      cccc 000x x0x0 xxxx xxxx xxxx 1111 xxxx
> + *                                    | Rn |Rt/d|         |imm4L|
> + * LDRD (immediate)     cccc 000x x1x0 xxxx xxxx xxxx 1101 xxxx
> + * STRD (immediate)     cccc 000x x1x0 xxxx xxxx xxxx 1111 xxxx
> + *
> + * Such instructions access Rt/d and its next register, so different
> + * from others, a specific checker is required for Rt/d and Rt2/d2.
> + */
> +static enum probes_insn arm_check_regs_ldrdstrd(probes_opcode_t insn,
> +		struct arch_probes_insn *asi,
> +		const struct decode_header *h)
> +{
> +	int quintuple[5], rn, rdt, rm;
> +	asi->register_usage_flag = 0;
> +	__arm_check_regs(insn, h, quintuple);
> +
> +	rn = quintuple[4];
> +	rdt = quintuple[3];
> +	rm = quintuple[0];
> +        set_register_use(asi->register_usage_flag, rn);
> +        set_register_use(asi->register_usage_flag, rdt);
> +        set_register_use(asi->register_usage_flag, rdt + 1);
> +	if (rm >= 0)
> +		set_register_use(asi->register_usage_flag, rm);
> +

We can avoid most of this code if we reuse arm_check_regs_normal and
then add in the use of rdt+1, i.e. this function can be simply...

	int rdt = (insn >> 12) & 0xf;
	arm_check_regs_normal(insn, asi, h);
	asi->register_usage_flag |= 1 << (rdt + 1);


> +	return INSN_GOOD;
> +}
> +
> +
> +const struct decode_checker arm_regs_checker[NUM_PROBES_ARM_ACTIONS] = {
> +	[PROBES_EMULATE_NONE] = {.checker = arm_check_regs_nouse},
> +	[PROBES_SIMULATE_NOP] = {.checker = arm_check_regs_nouse},
> +	[PROBES_MRS] = {.checker = arm_check_regs_normal},
> +	[PROBES_SATURATING_ARITHMETIC] = {.checker = arm_check_regs_normal},
> +	[PROBES_MUL1] = {.checker = arm_check_regs_normal},
> +	[PROBES_MUL2] = {.checker = arm_check_regs_normal},
> +	[PROBES_MUL_ADD_LONG] = {.checker = arm_check_regs_normal},
> +	[PROBES_MUL_ADD] = {.checker = arm_check_regs_normal},
> +	[PROBES_LOAD] = {.checker = arm_check_regs_normal},
> +	[PROBES_LOAD_EXTRA] = {.checker = arm_check_regs_normal},
> +	[PROBES_STORE] = {.checker = arm_check_regs_normal},
> +	[PROBES_STORE_EXTRA] = {.checker = arm_check_regs_normal},
> +	[PROBES_DATA_PROCESSING_REG] = {.checker = arm_check_regs_normal},
> +	[PROBES_DATA_PROCESSING_IMM] = {.checker = arm_check_regs_normal},
> +	[PROBES_SATURATE] = {.checker = arm_check_regs_normal},
> +	[PROBES_REV] = {.checker = arm_check_regs_normal},
> +	[PROBES_MMI] = {.checker = arm_check_regs_normal},
> +	[PROBES_PACK] = {.checker = arm_check_regs_normal},
> +	[PROBES_EXTEND] = {.checker = arm_check_regs_normal},
> +	[PROBES_EXTEND_ADD] = {.checker = arm_check_regs_normal},
> +	[PROBES_BITFIELD] = {.checker = arm_check_regs_normal},
> +	[PROBES_LDMSTM] = {.checker = arm_check_regs_ldmstm},
> +	[PROBES_MOV_IP_SP] = {.checker = arm_check_regs_mov_ip_sp},
> +	[PROBES_LDRSTRD] = {.checker = arm_check_regs_ldrdstrd},
> +};
> diff --git a/arch/arm/probes/kprobes/checkers.h b/arch/arm/probes/kprobes/checkers.h
> index bddfa0e..cf6c9e7 100644
> --- a/arch/arm/probes/kprobes/checkers.h
> +++ b/arch/arm/probes/kprobes/checkers.h
> @@ -47,6 +47,7 @@ extern const union decode_action stack_check_actions[];
>  
>  #ifndef CONFIG_THUMB2_KERNEL
>  extern const struct decode_checker arm_stack_checker[];
> +extern const struct decode_checker arm_regs_checker[];
>  #else
>  #endif
>  extern const struct decode_checker t32_stack_checker[];

I've made a lot, of suggestions for code changes, so I think it's best
if I follow up to this email with a new version of this patch which
applies them all so we can see what the bigger picture is...

-- 
Tixy


