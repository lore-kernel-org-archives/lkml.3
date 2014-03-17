Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932737AbaCQKbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 06:31:20 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:50322 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932351AbaCQKbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 06:31:18 -0400
Message-ID: <5326CEF1.90109@gmail.com>
Date: Mon, 17 Mar 2014 11:31:13 +0100
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Bo Shen <voice.shen@atmel.com>, Mark Brown <broonie@kernel.org>,
        nicolas.ferre@atmel.com
CC: Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] ASoC: atmel: support CCF based clks
References: <1395049541-28128-1-git-send-email-voice.shen@atmel.com> <1395049541-28128-7-git-send-email-voice.shen@atmel.com>
In-Reply-To: <1395049541-28128-7-git-send-email-voice.shen@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 17/03/2014 10:45, Bo Shen a écrit :
> From: Boris BREZILLON <b.brezillon@overkiz.com>
>
> Provide dev to clk_get function if we're using CCF based clks.
> CCF based prog clks support automatic parent selection when asking for a
> specific rate: remove the clk32k clk retrieval if we're using these clks.
I would have split this patch:
1) make use of devm in the existing code
2) add CCF support


> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> [voice.shen@atmel.com: switch to devm manage function]
> Signed-off-by: Bo Shen <voice.shen@atmel.com>
>
> Signed-off-by: Bo Shen <voice.shen@atmel.com>
> ---
>
>   sound/soc/atmel/atmel_wm8904.c | 25 +++++++++++++------------
>   1 file changed, 13 insertions(+), 12 deletions(-)
>
> diff --git a/sound/soc/atmel/atmel_wm8904.c b/sound/soc/atmel/atmel_wm8904.c
> index b4e3690..a797d33 100644
> --- a/sound/soc/atmel/atmel_wm8904.c
> +++ b/sound/soc/atmel/atmel_wm8904.c
> @@ -170,25 +170,26 @@ static int atmel_asoc_wm8904_probe(struct platform_device *pdev)
>   		return ret;
>   	}
>   
> -	mclk = clk_get(NULL, "pck0");
> +	mclk = devm_clk_get(&pdev->dev, "pck0");

I wonder if we shouldn't change the requested clk name when using CCF.
After all this is a board decision to choose which programmable clk 
should be used.
The "pck0" implies that you're always connecting programmable clk 0 to 
the wm8904 chip.

What about "pck" instead of "pck0" ?


Best Regards,

Boris
>   	if (IS_ERR(mclk)) {
>   		dev_err(&pdev->dev, "failed to get pck0\n");
>   		ret = PTR_ERR(mclk);
>   		goto err_set_audio;
>   	}
>   
> -	clk_src = clk_get(NULL, "clk32k");
> -	if (IS_ERR(clk_src)) {
> -		dev_err(&pdev->dev, "failed to get clk32k\n");
> -		ret = PTR_ERR(clk_src);
> -		goto err_set_audio;
> -	}
> +	if (!IS_ENABLED(CONFIG_COMMON_CLK)) {
> +		clk_src = devm_clk_get(&pdev->dev, "clk32k");
> +		if (IS_ERR(clk_src)) {
> +			dev_err(&pdev->dev, "failed to get clk32k\n");
> +			ret = PTR_ERR(clk_src);
> +			goto err_set_audio;
> +		}
>   
> -	ret = clk_set_parent(mclk, clk_src);
> -	clk_put(clk_src);
> -	if (ret != 0) {
> -		dev_err(&pdev->dev, "failed to set MCLK parent\n");
> -		goto err_set_audio;
> +		ret = clk_set_parent(mclk, clk_src);
> +		if (ret != 0) {
> +			dev_err(&pdev->dev, "failed to set MCLK parent\n");
> +			goto err_set_audio;
> +		}
>   	}
>   
>   	dev_info(&pdev->dev, "setting pck0 to %dHz\n", MCLK_RATE);

