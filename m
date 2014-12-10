Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621AbaLJJer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 04:34:47 -0500
Received: from smtp-out-205.synserver.de ([212.40.185.205]:1068 "EHLO
	smtp-out-188.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750880AbaLJJep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 04:34:45 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 11107
Message-ID: <548813AC.1080105@metafoo.de>
Date: Wed, 10 Dec 2014 10:34:36 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Mike Looijmans <mike.looijmans@topic.nl>
CC: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] sound/soc/adi/axi-spdif.c: Support programmable master
 clock
References: <54806D4E.8040504@topic.nl> <1417783029-22492-1-git-send-email-mike.looijmans@topic.nl>
In-Reply-To: <1417783029-22492-1-git-send-email-mike.looijmans@topic.nl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2014 01:37 PM, Mike Looijmans wrote:
> If the master clock supports programmable rates, program it to generate
> the desired frequency. Only apply constraints when the clock is fixed.
> This allows proper clock generation for both 44100 and 48000 Hz based
> sampling rates if the platform supports it.
>
> The clock frequency must be set before enabling it. Enabling the clock
> was done in "startup", but that occurs before "hw_params" where the rate
> is known. Enabling a programmable clock without first setting a valid
> frequency may harm the system. Move the clock start to the hw_params
> routine, and keep track of whether the clock has been started, because
> shutdown may be called without having called hw_params first.
> Starting the clock and enabling the SPDIF output AFTER programming the
> dividers is a more logical order anyway.
>
> To detect if the source clock is fixed, the driver calls clk_round_rate
> for two frequencies. If the results are equal, or if the call returns
> an error, the driver assumes the clock is fixed.
>
> Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>

Hi,

Sorry for the delay.

[...]
>
> +	/* Try to set the master clock */
> +	clk_set_rate(spdif->clk_ref, rate * 128);
> +
>   	clkdiv = DIV_ROUND_CLOSEST(clk_get_rate(spdif->clk_ref),
>   			rate * 64 * 2) - 1;
>   	clkdiv <<= AXI_SPDIF_CTRL_CLKDIV_OFFSET;
> @@ -103,6 +108,14 @@ static int axi_spdif_hw_params(struct snd_pcm_substream *substream,
>   	regmap_update_bits(spdif->regmap, AXI_SPDIF_REG_CTRL,
>   		AXI_SPDIF_CTRL_CLKDIV_MASK, clkdiv);
>
> +	ret = clk_prepare_enable(spdif->clk_ref);

I'm still not convinced this is the right place. I do see your point. But it 
just feels wrong to enable the clock in hw_params. It's a bit of a dilemma. 
the startup callback is to early, hw_params is the wrong place and we can't 
put it in the trigger callback as the trigger callback can not sleep.

But in any way hwparmas can be called multiple times, so you need to handle 
the case where the clock is already enabled.

> +	if (ret)
> +		return ret;
> +	spdif->clk_ref_running = true;
> +
> +	regmap_update_bits(spdif->regmap, AXI_SPDIF_REG_CTRL,
> +		AXI_SPDIF_CTRL_TXEN, AXI_SPDIF_CTRL_TXEN);

This should probably be moved to the trigger callback though.

> +
>   	return 0;
>   }

