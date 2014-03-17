Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713AbaCQJ4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 05:56:31 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:14252 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932407AbaCQJ4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 05:56:24 -0400
Message-ID: <5326C6AA.7030200@atmel.com>
Date: Mon, 17 Mar 2014 17:55:54 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, <nicolas.ferre@atmel.com>
CC: Boris BREZILLON <b.brezillon@overkiz.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/8] ASoC: atmel: support CCF based clks
References: <1395049541-28128-1-git-send-email-voice.shen@atmel.com> <1395049541-28128-7-git-send-email-voice.shen@atmel.com>
In-Reply-To: <1395049541-28128-7-git-send-email-voice.shen@atmel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2014 05:45 PM, Bo Shen wrote:
> From: Boris BREZILLON <b.brezillon@overkiz.com>
>
> Provide dev to clk_get function if we're using CCF based clks.
> CCF based prog clks support automatic parent selection when asking for a
> specific rate: remove the clk32k clk retrieval if we're using these clks.
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> [voice.shen@atmel.com: switch to devm manage function]
> Signed-off-by: Bo Shen <voice.shen@atmel.com>
>
> Signed-off-by: Bo Shen <voice.shen@atmel.com>

Oh, sorry for multi SOBs. Please remove it when apply.

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
>

Best Regards,
Bo Shen
