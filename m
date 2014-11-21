Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712AbaKURSz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 12:18:55 -0500
Received: from smarthost01c.mail.zen.net.uk ([212.23.1.5]:45429 "EHLO
	smarthost01c.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758514AbaKURSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 12:18:54 -0500
Message-ID: <1416590308.1827.3.camel@linaro.org>
Subject: Re: [PATCH v3 2/3] ARM: kprobes: collects stack consumption for
 store instructions
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Wang Nan <wangnan0@huawei.com>
Cc: masami.hiramatsu.pt@hitachi.com, linux@arm.linux.org.uk,
        will.deacon@arm.com, taras.kondratiuk@linaro.org,
        ben.dooks@codethink.co.uk, cl@linux.com, rabin@rab.in,
        davem@davemloft.net, lizefan@huawei.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Fri, 21 Nov 2014 17:18:28 +0000
In-Reply-To: <1416551731-50777-3-git-send-email-wangnan0@huawei.com>
References: <1416551731-50777-1-git-send-email-wangnan0@huawei.com>
	 <1416551731-50777-3-git-send-email-wangnan0@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01c-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-21 at 14:35 +0800, Wang Nan wrote:
> This patch uses the previously introduced checker functionality on
> store instructions to record their stack consumption information to
> arch_probes_insn.
> 
> Signed-off-by: Wang Nan <wangnan0@huawei.com>
> Signed-off-by: Jon Medhurst <tixy@linaro.org>
> Reviewed-by: Jon Medhurst <tixy@linaro.org>
> 
> ---

During testing of these patches I found a couple of bugs in the 32-bit
thumb instruction decoding...

[...]
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
> +		/*                                    | Rn | Rt |         | Rm |*/
> +		/* STR (register)	1111 1000 0100 xxxx xxxx 0000 00xx xxxx */
> +		/* STRB (register)	1111 1000 0000 xxxx xxxx 0000 00xx xxxx */
> +		/* STRH (register)	1111 1000 0010 xxxx xxxx 0000 00xx xxxx */
> +		/* INVALID INSN		1111 1000 0110 xxxx xxxx 0000 00xx xxxx */
> +		/* By Introducing INVALID INSN, bit 21 and 22 can be ignored. */
> +		DECODE_OR	(0xff9f0fc0, 0xf80d0000),
> +		DECODE_CUSTOM	(0xff900fcf, 0xf800000d, STACK_USE_UNKNOWN),
> +
> +
> +		/*                                    | Rn | Rt | PUW|   imm8  |*/
> +		/* STR (imm 8)		1111 1000 0100 xxxx xxxx 110x xxxx xxxx */
> +		/* STRB (imm 8)		1111 1000 0000 xxxx xxxx 110x xxxx xxxx */
> +		/* STRH (imm 8)		1111 1000 0010 xxxx xxxx 110x xxxx xxxx */
> +		/* INVALID INSN		1111 1000 0110 xxxx xxxx 110x xxxx xxxx */
> +		/* Only consider U == 0 and P == 1: strx rx, [sp, #-<imm>] */
> +		DECODE_CUSTOM	(0xff9f0e00, 0xf80d0c00, STACK_USE_FIXED_0XX),
> +
> +		/* For STR{,B,H} (imm 12), offset is always positive, so ignore them. */
> +
> +		/*                              P U W | Rn | Rt | Rt2|   imm8  |*/
> +		/* STRD (immediate)	1110 1001 01x0 1101 xxxx xxxx xxxx xxxx */
> +		/* Only consider U == 0 and P == 1 */
> +		DECODE_CUSTOM	(0xffdf0000, 0xe94d0000, STACK_USE_FIXED_0XX),

For the encoding of LDRD, the 8 bit immediate value is the number of
words not bytes and so needs multiplying by 4. This will need an
additional enum and function to handle that.


> +
> +		/*                                    | Rn | */
> +		/* STMDB		1110 1001 00x0 1101 xxxx xxxx xxxx xxxx */
> +		DECODE_CUSTOM	(0xffdf0000, 0xe94d0000, STACK_USE_STMDX),

The match value is incorrect (the same as used for LDRD), this should
be 

		DECODE_CUSTOM	(0xffdf0000, 0xe90d0000, STACK_USE_STMDX),


-- 
Tixy


