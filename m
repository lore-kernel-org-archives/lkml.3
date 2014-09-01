Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345AbaIAP0w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 11:26:52 -0400
Received: from smarthost01d.mail.zen.net.uk ([212.23.1.7]:35547 "EHLO
	smarthost01d.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754284AbaIAP0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 11:26:50 -0400
Message-ID: <1409585190.2948.45.camel@linaro1.home>
Subject: Re: [PATCH] ARM: probes: return directly when emulate not set
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Wang Nan <wangnan0@huawei.com>
Cc: "David A. Long" <dave.long@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        peifeiyue@huawei.com
Date: Mon, 01 Sep 2014 16:26:30 +0100
In-Reply-To: <1409116109-67330-1-git-send-email-wangnan0@huawei.com>
References: <1409116109-67330-1-git-send-email-wangnan0@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01d-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-08-27 at 13:08 +0800, Wang Nan wrote:
> When kprobe decoding instruction, original code calls instruction
> specific decoder if emulate is set to false.  However, instructions with
> DECODE_TYPE_EMULATE are in fact don't have their decoder. What in the
> action table are in fact handlers.  For example:
> 
> 	/* LDRD (immediate)	cccc 000x x1x0 xxxx xxxx xxxx 1101 xxxx */
> 	/* STRD (immediate)	cccc 000x x1x0 xxxx xxxx xxxx 1111 xxxx */
> 	DECODE_EMULATEX	(0x0e5000d0, 0x004000d0, PROBES_LDRSTRD,
> 						 REGS(NOPCWB, NOPCX, 0, 0, 0)),
> 
> 	and
> 
> const union decode_action kprobes_arm_actions[NUM_PROBES_ARM_ACTIONS] = {
> 	...
> 	[PROBES_LDRSTRD] = {.handler = emulate_ldrdstrd},
> 	...
> 
> In this situation, original code calls 'emulate_ldrdstrd' as a decoder,
> which is obviously incorrect.

Except that situation can't occur because when arm_probes_decode_insn()
is called with kprobes_arm_actions then emulate is set to true (see
arch_prepare_kprobe).

For the situation where emulate is false, i.e. when called from
arch_uprobe_analyze_insn(), then this provides these actions...

const union decode_action uprobes_probes_actions[] = {
	...
	[PROBES_LDRSTRD] = {.decoder = decode_pc_ro},
	...

and we do want that decode function called. Basically, the code is
behaving as it was designed and when passed emulate=false it turns the
behaviour of emulated instruction forms into into the 'custom' action. 

> 
> This patch makes it returns INSN_GOOD directly when 'emulate' is not
> true.
> 
> Signed-off-by: Wang Nan <wangnan0@huawei.com>
> Cc: "David A. Long" <dave.long@linaro.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Jon Medhurst <tixy@linaro.org>
> Cc: Taras Kondratiuk <taras.kondratiuk@linaro.org>
> Cc: Ben Dooks <ben.dooks@codethink.co.uk>
> ---
>  arch/arm/kernel/probes.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/arm/kernel/probes.c b/arch/arm/kernel/probes.c
> index a8ab540..1c77b8d 100644
> --- a/arch/arm/kernel/probes.c
> +++ b/arch/arm/kernel/probes.c
> @@ -436,8 +436,7 @@ probes_decode_insn(probes_opcode_t insn, struct arch_probes_insn *asi,
>  			struct decode_emulate *d = (struct decode_emulate *)h;
>  
>  			if (!emulate)
> -				return actions[d->handler.action].decoder(insn,
> -					asi, h);
> +				return INSN_GOOD;
>  
>  			asi->insn_handler = actions[d->handler.action].handler;
>  			set_emulated_insn(insn, asi, thumb);

-- 
Tixy


