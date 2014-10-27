Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbaJ0RT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 13:19:56 -0400
Received: from queue01a.mail.zen.net.uk ([212.23.3.234]:58247 "EHLO
	queue01a.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbaJ0RTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 13:19:55 -0400
Message-ID: <1414430259.1430.9.camel@linaro.org>
Subject: Re: [PATCH v6 0/7] ARM: kprobes: enable OPTPROBES for ARM 32.
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Wang Nan <wangnan0@huawei.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, linux@arm.linux.org.uk,
        will.deacon@arm.com, dave.long@linaro.org, taras.kondratiuk@linaro.org,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Christoph Lameter <cl@linux.com>, Rabin Vincent <rabin@rab.in>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Li Zefan <lizefan@huawei.com>
Date: Mon, 27 Oct 2014 17:17:39 +0000
In-Reply-To: <544B7228.9050200@huawei.com>
References: <1413977525-51480-1-git-send-email-wangnan0@huawei.com>
		 <5449A2BB.1020207@hitachi.com> <1414141323.1441.1.camel@linaro.org>
	 <544B7228.9050200@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.6-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01b-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-10-25 at 17:49 +0800, Wang Nan wrote:
[...]
> Anyway, I have done the separation. Please refer to:
> 
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-October/297031.html
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-October/297036.html
> 
> There is a big change in checker code in the first thread. Please help me review
> whether checker is acceptable.

I had started reviewing the previous version, I'll switch to the new
one.

I do prefer the new checker code better, and the only obvious
alternative I can think off would be to break down the decoding tables
into a lot more special cases of instruction forms, which I isn't as
scalable, so I don't like that idea.

However, I wonder if there is scope for the checker functions to
recursively call probes_decode_insn rather than decoding instructions in
C code. I don't know if that would be clearer and/or smaller or not.

Below is something I've just thrown together to get a feel of how it
could look. The decode table could possibly incorporate patterns to
cover instructions types that you split up in PATCH 1, e.g. so we might
not need separate PROBES_STORE and PROBES_STORE_EXTRA (depends if that
ends up making things simpler or not)...


int stack_use_none(probes_opcode_t insn,
		       struct arch_probes_insn *asi,
		       const struct decode_header *h)
{
	asi->stack_space = 0;
	return INSN_GOOD_NO_SLOT;
}

int stack_use_unknown(probes_opcode_t insn,
		       struct arch_probes_insn *asi,
		       const struct decode_header *h)
{
	asi->stack_space = -1;
	return INSN_GOOD_NO_SLOT;
}

int stack_use_imm_x0x(probes_opcode_t insn,
		       struct arch_probes_insn *asi,
		       const struct decode_header *h)
{
	asi->stack_space = ((insn & 0xf00) >> 4) + (insn & 0xf);
	return INSN_GOOD_NO_SLOT;
}

int stack_use_imm_xxx(probes_opcode_t insn,
		       struct arch_probes_insn *asi,
		       const struct decode_header *h)
{
	asi->stack_space = insn & 0xfff;
	return INSN_GOOD_NO_SLOT;
}

enum {
	STACK_USE_NONE,
	STACK_USE_UNKNOWN,
	STACK_USE_FIXED_X0X,
	STACK_USE_FIXED_XXX,
	NUM_STACK_USE_TYPES
};

static const union decode_action chk_stack_actions[] = {
	[STACK_USE_NONE] = {.handler = stack_use_none},
	[STACK_USE_UNKNOWN] = {.handler = stack_use_unknown},
	[STACK_USE_FIXED_X0X] = {.handler = stack_use_imm_x0x}
	[STACK_USE_FIXED_XXX] = {.handler = stack_use_imm_xxx}
}

enum probes_insn __kprobes chk_stack_use_arm(probes_opcode_t insn,
		       struct arch_probes_insn *asi,
		       const struct decode_header *h)
{
	static const union decode_item table[] = {
		/* Register indexed addressing modes with SP as index register (!)*/
		DECODE_OR	(0x0040000d, 0x0000000d),
		/* Register indexed addressing modes with SP as base register */
		DECODE_CUSTOM	(0x004f0000, 0x000d0000, STACK_USE_UNKOWN,
							 REGS(0, 0, 0, 0, 0)),

		/* STR{,B} with immediate pre-indexed addressing mode with SP base address */
		DECODE_CUSTOM	(0x05cf0000, 0x054d0000, STACK_USE_FIXED_XXX,
							 REGS(0, 0, 0, 0, 0)),

		/* STR{H,D} with immediate pre-indexed addressing mode with SP base address */
		DECODE_CUSTOM	(0x05cf0000, 0x014d0000, STACK_USE_FIXED_X0X,
							 REGS(0, 0, 0, 0, 0)),

		... other rules here, possibly including ...
		... REGS values like 'NOSP' to reject certain forms ...

		/* Catch all remaining cases */
		DECODE_CUSTOM	(0, 0, STACK_USE_NONE, REGS(0, 0, 0, 0, 0))
	}

	return probes_decode_insn(insn, asi, table, false, false, chk_stack_actions, NULL);
}

And in the dubious case that anyone wants to copy any of the above, it's
Signed-off-by: Jon Medhurst <tixy@linaro.org>

-- 
Tixy

