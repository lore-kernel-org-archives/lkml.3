Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862AbaKTMPF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 07:15:05 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:43986 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbaKTMPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 07:15:03 -0500
Message-ID: <546DDB40.6040604@hitachi.com>
Date: Thu, 20 Nov 2014 21:14:56 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Wang Nan <wangnan0@huawei.com>
Cc: tixy@linaro.org, linux@arm.linux.org.uk, will.deacon@arm.com,
        dave.long@linaro.org, taras.kondratiuk@linaro.org,
        ben.dooks@codethink.co.uk, cl@linux.com, rabin@rab.in,
        davem@davemloft.net, lizefan@huawei.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/3] ARM: kprobes: introduces checker
References: <1416291582-74982-1-git-send-email-wangnan0@huawei.com> <1416291582-74982-2-git-send-email-wangnan0@huawei.com>
In-Reply-To: <1416291582-74982-2-git-send-email-wangnan0@huawei.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/18 15:19), Wang Nan wrote:
> diff --git a/arch/arm/kernel/kprobes.c b/arch/arm/kernel/kprobes.c
> index 6d64420..f114a3f 100644
> --- a/arch/arm/kernel/kprobes.c
> +++ b/arch/arm/kernel/kprobes.c
> @@ -61,6 +61,7 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
>  	kprobe_decode_insn_t *decode_insn;
>  	const union decode_action *actions;
>  	int is;
> +	const struct decode_checker **checkers;
>  
>  	if (in_exception_text(addr))
>  		return -EINVAL;
> @@ -74,9 +75,11 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
>  		insn = __opcode_thumb32_compose(insn, inst2);
>  		decode_insn = thumb32_probes_decode_insn;
>  		actions = kprobes_t32_actions;
> +		checkers = kprobes_t32_checkers;
>  	} else {
>  		decode_insn = thumb16_probes_decode_insn;
>  		actions = kprobes_t16_actions;
> +		checkers = kprobes_t16_checkers;
>  	}
>  #else /* !CONFIG_THUMB2_KERNEL */
>  	thumb = false;
> @@ -85,12 +88,13 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
>  	insn = __mem_to_opcode_arm(*p->addr);
>  	decode_insn = arm_probes_decode_insn;
>  	actions = kprobes_arm_actions;
> +	checkers = kprobes_arm_checkers;
>  #endif
>  
>  	p->opcode = insn;
>  	p->ainsn.insn = tmp_insn;
>  
> -	switch ((*decode_insn)(insn, &p->ainsn, true, actions)) {
> +	switch ((*decode_insn)(insn, &p->ainsn, true, actions, NULL)) {

BTW, even if checkers always empty at this point, we should pass the checkers to this function.

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


