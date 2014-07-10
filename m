Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547AbaGJGay (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 02:30:54 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:39402 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbaGJGax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 02:30:53 -0400
Message-ID: <53BE32FF.80601@ti.com>
Date: Thu, 10 Jul 2014 09:30:23 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Himangi Saraogi <himangi774@gmail.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        <linux-omap@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>
CC: <julia.lawall@lip6.fr>
Subject: Re: [PATCH] ASoC: omap-dmic: use managed interfaces
References: <20140709212112.GA11848@himangi-Dell>
In-Reply-To: <20140709212112.GA11848@himangi-Dell>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2014 12:21 AM, Himangi Saraogi wrote:
> This patch moves data allocated using clk_put and
> snd_soc_register_component to the corresponding managed interfaces and
> does away with the functions to free memory in the probe and remove
> functions. The probe function is no longer required and is completely
> removed.

Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>
> ---
>  sound/soc/omap/omap-dmic.c | 35 ++++++++---------------------------
>  1 file changed, 8 insertions(+), 27 deletions(-)
> 
> diff --git a/sound/soc/omap/omap-dmic.c b/sound/soc/omap/omap-dmic.c
> index 6925d71..b315b27 100644
> --- a/sound/soc/omap/omap-dmic.c
> +++ b/sound/soc/omap/omap-dmic.c
> @@ -466,7 +466,7 @@ static int asoc_dmic_probe(struct platform_device *pdev)
>  
>  	mutex_init(&dmic->mutex);
>  
> -	dmic->fclk = clk_get(dmic->dev, "fck");
> +	dmic->fclk = devm_clk_get(dmic->dev, "fck");
>  	if (IS_ERR(dmic->fclk)) {
>  		dev_err(dmic->dev, "cant get fck\n");
>  		return -ENODEV;
> @@ -475,8 +475,7 @@ static int asoc_dmic_probe(struct platform_device *pdev)
>  	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "dma");
>  	if (!res) {
>  		dev_err(dmic->dev, "invalid dma memory resource\n");
> -		ret = -ENODEV;
> -		goto err_put_clk;
> +		return -ENODEV;
>  	}
>  	dmic->dma_data.addr = res->start + OMAP_DMIC_DATA_REG;
>  
> @@ -484,34 +483,17 @@ static int asoc_dmic_probe(struct platform_device *pdev)
>  
>  	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "mpu");
>  	dmic->io_base = devm_ioremap_resource(&pdev->dev, res);
> -	if (IS_ERR(dmic->io_base)) {
> -		ret = PTR_ERR(dmic->io_base);
> -		goto err_put_clk;
> -	}
> -
> +	if (IS_ERR(dmic->io_base))
> +		return PTR_ERR(dmic->io_base);
>  
> -	ret = snd_soc_register_component(&pdev->dev, &omap_dmic_component,
> -					 &omap_dmic_dai, 1);
> +	ret = devm_snd_soc_register_component(&pdev->dev, &omap_dmic_component,
> +					      &omap_dmic_dai, 1);
>  	if (ret)
> -		goto err_put_clk;
> +		return ret;
>  
>  	ret = omap_pcm_platform_register(&pdev->dev);
>  	if (ret)
> -		goto err_put_clk;
> -
> -	return 0;
> -
> -err_put_clk:
> -	clk_put(dmic->fclk);
> -	return ret;
> -}
> -
> -static int asoc_dmic_remove(struct platform_device *pdev)
> -{
> -	struct omap_dmic *dmic = platform_get_drvdata(pdev);
> -
> -	snd_soc_unregister_component(&pdev->dev);
> -	clk_put(dmic->fclk);
> +		return ret;
>  
>  	return 0;
>  }
> @@ -529,7 +511,6 @@ static struct platform_driver asoc_dmic_driver = {
>  		.of_match_table = omap_dmic_of_match,
>  	},
>  	.probe = asoc_dmic_probe,
> -	.remove = asoc_dmic_remove,
>  };
>  
>  module_platform_driver(asoc_dmic_driver);
> 


-- 
Péter
