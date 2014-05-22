Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbaEVPvo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 11:51:44 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60482 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbaEVPvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 11:51:42 -0400
Message-ID: <537E1D0A.6020303@wwwdotorg.org>
Date: Thu, 22 May 2014 09:51:38 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tushar Behera <tushar.behera@linaro.org>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
CC: tiwai@suse.de, perex@perex.cz, broonie@kernel.org, dianders@chromium.org,
        jerry.wong@maximintegrated.com
Subject: Re: [PATCH 1/2] ASoC: max98090: Add master clock handling
References: <1400750228-13750-1-git-send-email-tushar.behera@linaro.org> <1400750228-13750-2-git-send-email-tushar.behera@linaro.org>
In-Reply-To: <1400750228-13750-2-git-send-email-tushar.behera@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2014 03:17 AM, Tushar Behera wrote:
> If master clock is provided through device tree, then update
> the master clock frequency during set_sysclk.
> 
> Documentation has been updated to reflect the change.

> diff --git a/sound/soc/codecs/max98090.c b/sound/soc/codecs/max98090.c

> @@ -1929,6 +1930,11 @@ static int max98090_dai_set_sysclk(struct snd_soc_dai *dai,
>  	if (freq == max98090->sysclk)
>  		return 0;
>  
> +	if (!IS_ERR(max98090->mclk)) {
> +		freq = clk_round_rate(max98090->mclk, freq);
> +		clk_set_rate(max98090->mclk, freq);
> +	}

What are the intended semantics of set_sysclk()?
sound/soc/tegra/tegra_wm98090.c assumes that set_sysclk() is a
notification to the CODEC driver to tell it what rate the MCLK input is
set to (the rate is set before calling set_sysclk), whereas the code
above assumes that this function is to tell the CODEC to somehow
configure its input clock to be a particular rate. I have a feeling the
code above might fail on Tegra.

