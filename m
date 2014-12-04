Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbaLDMpt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 07:45:49 -0500
Received: from smtp-out-020.synserver.de ([212.40.185.20]:1066 "EHLO
	smtp-out-017.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753908AbaLDMpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 07:45:47 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 5949
Message-ID: <5480577D.4010106@metafoo.de>
Date: Thu, 04 Dec 2014 13:45:49 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Mike Looijmans <mike.looijmans@topic.nl>
CC: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sound/soc/adi/axi-spdif.c: Support programmable master
 clock
References: <1417675940-3754-1-git-send-email-mike.looijmans@topic.nl>
In-Reply-To: <1417675940-3754-1-git-send-email-mike.looijmans@topic.nl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2014 07:52 AM, Mike Looijmans wrote:
> If the master clock supports programmable rates, program it to generate
> the desired frequency. Only apply constraints when the clock is fixed.
> This allows proper clock generation for both 44100 and 48000 Hz based
> sampling rates if the platform supports it.
>
> The clock frequency must be set before enabling it. Enabling the clock
> was done in "startup", but that occurs before "hw_params" where the rate
> is known. Move the clock start to the hw_params routine, and keep track
> of whether the clock has been started, because shutdown may be called
> without having called hw_params first.

Usually that shouldn't be a problem. If your clock chip requires it to be 
disabled in order to be reprogrammed than the CLK_SET_RATE_GATE flag should 
be set. This will tell the core to disable the clock before changing it.

[...]
>   static const struct snd_soc_dai_ops axi_spdif_dai_ops = {
> @@ -216,14 +227,17 @@ static int axi_spdif_probe(struct platform_device *pdev)
>   	spdif->dma_data.addr_width = 4;
>   	spdif->dma_data.maxburst = 1;
>
> -	spdif->ratnum.num = clk_get_rate(spdif->clk_ref) / 128;
> -	spdif->ratnum.den_step = 1;
> -	spdif->ratnum.den_min = 1;
> -	spdif->ratnum.den_max = 64;
> -
> -	spdif->rate_constraints.rats = &spdif->ratnum;
> -	spdif->rate_constraints.nrats = 1;
> +	/* Determine if the clock rate is fixed. If it cannot change frequency,
> +	 * it returns an error here. */
> +	if (clk_round_rate(spdif->clk_ref, 128 * 44100) < 0) {

I don't think this works. For a fixed clock clk_round_rate() will return the 
fixed rate rather than an error. I tried the patch and even though I have a 
fixed clock the constraints are no longer set.

There is unfortunately no good way to enumerate which frequencies are 
supported by a clock other than just calling round_rate for all possible rates.

I think the best way to implement this for now is to try e.g. 32000 * 128, 
44100 * 128, 48000 * 128 and then check if clk_round_rate returns the 
expected rate and if it does set up a rate constraint for that rate.
