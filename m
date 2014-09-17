Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586AbaIQRms (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 13:42:48 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44784 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756556AbaIQRmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 13:42:47 -0400
Date: Wed, 17 Sep 2014 10:42:32 -0700
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: Shengjiu Wang <shengjiu.wang@freescale.com>
Cc: timur@tabi.org, Li.Xiubo@freescale.com, lgirdwood@gmail.com,
        broonie@kernel.org, perex@perex.cz, tiwai@suse.de, mpa@pengutronix.de,
        alsa-devel@alsa-project.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4] ASoC: fsl_ssi: refine ipg clock usage in this module
Message-ID: <20140917174231.GA6480@Asurada>
References: <5dc0f13cdb62904ae0f104f9112faec672adea6f.1410833402.git.shengjiu.wang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5dc0f13cdb62904ae0f104f9112faec672adea6f.1410833402.git.shengjiu.wang@freescale.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 10:13:16AM +0800, Shengjiu Wang wrote:
> Check if ipg clock is in clock-names property, then we can move the
> ipg clock enable and disable operation to startup and shutdown, that
> is only enable ipg clock when ssi is working and keep clock is disabled
> when ssi is in idle.
> But when the checking is failed, remain the clock control as before.
> 
> Tested-by: Markus Pargmann <mpa@pengutronix.de>
> Signed-off-by: Shengjiu Wang <shengjiu.wang@freescale.com>

Acked-by: Nicolin Chen <nicoleotsuka@gmail.com>

> ---
> v4 change log:
> fix the code indent issue.
> 
>  sound/soc/fsl/fsl_ssi.c |   53 ++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 45 insertions(+), 8 deletions(-)
> 
> diff --git a/sound/soc/fsl/fsl_ssi.c b/sound/soc/fsl/fsl_ssi.c
> index 2fc3e66..16a1361 100644
> --- a/sound/soc/fsl/fsl_ssi.c
> +++ b/sound/soc/fsl/fsl_ssi.c
> @@ -169,6 +169,7 @@ struct fsl_ssi_private {
>  	u8 i2s_mode;
>  	bool use_dma;
>  	bool use_dual_fifo;
> +	bool has_ipg_clk_name;
>  	unsigned int fifo_depth;
>  	struct fsl_ssi_rxtx_reg_val rxtx_reg_val;
>  
> @@ -530,6 +531,11 @@ static int fsl_ssi_startup(struct snd_pcm_substream *substream,
>  	struct snd_soc_pcm_runtime *rtd = substream->private_data;
>  	struct fsl_ssi_private *ssi_private =
>  		snd_soc_dai_get_drvdata(rtd->cpu_dai);
> +	int ret;
> +
> +	ret = clk_prepare_enable(ssi_private->clk);
> +	if (ret)
> +		return ret;
>  
>  	/* When using dual fifo mode, it is safer to ensure an even period
>  	 * size. If appearing to an odd number while DMA always starts its
> @@ -544,6 +550,21 @@ static int fsl_ssi_startup(struct snd_pcm_substream *substream,
>  }
>  
>  /**
> + * fsl_ssi_shutdown: shutdown the SSI
> + *
> + */
> +static void fsl_ssi_shutdown(struct snd_pcm_substream *substream,
> +				struct snd_soc_dai *dai)
> +{
> +	struct snd_soc_pcm_runtime *rtd = substream->private_data;
> +	struct fsl_ssi_private *ssi_private =
> +		snd_soc_dai_get_drvdata(rtd->cpu_dai);
> +
> +	clk_disable_unprepare(ssi_private->clk);
> +
> +}
> +
> +/**
>   * fsl_ssi_set_bclk - configure Digital Audio Interface bit clock
>   *
>   * Note: This function can be only called when using SSI as DAI master
> @@ -1043,6 +1064,7 @@ static int fsl_ssi_dai_probe(struct snd_soc_dai *dai)
>  
>  static const struct snd_soc_dai_ops fsl_ssi_dai_ops = {
>  	.startup	= fsl_ssi_startup,
> +	.shutdown       = fsl_ssi_shutdown,
>  	.hw_params	= fsl_ssi_hw_params,
>  	.hw_free	= fsl_ssi_hw_free,
>  	.set_fmt	= fsl_ssi_set_dai_fmt,
> @@ -1168,17 +1190,22 @@ static int fsl_ssi_imx_probe(struct platform_device *pdev,
>  	u32 dmas[4];
>  	int ret;
>  
> -	ssi_private->clk = devm_clk_get(&pdev->dev, NULL);
> +	if (ssi_private->has_ipg_clk_name)
> +		ssi_private->clk = devm_clk_get(&pdev->dev, "ipg");
> +	else
> +		ssi_private->clk = devm_clk_get(&pdev->dev, NULL);
>  	if (IS_ERR(ssi_private->clk)) {
>  		ret = PTR_ERR(ssi_private->clk);
>  		dev_err(&pdev->dev, "could not get clock: %d\n", ret);
>  		return ret;
>  	}
>  
> -	ret = clk_prepare_enable(ssi_private->clk);
> -	if (ret) {
> -		dev_err(&pdev->dev, "clk_prepare_enable failed: %d\n", ret);
> -		return ret;
> +	if (!ssi_private->has_ipg_clk_name) {
> +		ret = clk_prepare_enable(ssi_private->clk);
> +		if (ret) {
> +			dev_err(&pdev->dev, "clk_prepare_enable failed: %d\n", ret);
> +			return ret;
> +		}
>  	}
>  
>  	/* For those SLAVE implementations, we ingore non-baudclk cases
> @@ -1236,8 +1263,9 @@ static int fsl_ssi_imx_probe(struct platform_device *pdev,
>  	return 0;
>  
>  error_pcm:
> -	clk_disable_unprepare(ssi_private->clk);
>  
> +	if (!ssi_private->has_ipg_clk_name)
> +		clk_disable_unprepare(ssi_private->clk);
>  	return ret;
>  }
>  
> @@ -1246,7 +1274,8 @@ static void fsl_ssi_imx_clean(struct platform_device *pdev,
>  {
>  	if (!ssi_private->use_dma)
>  		imx_pcm_fiq_exit(pdev);
> -	clk_disable_unprepare(ssi_private->clk);
> +	if (!ssi_private->has_ipg_clk_name)
> +		clk_disable_unprepare(ssi_private->clk);
>  }
>  
>  static int fsl_ssi_probe(struct platform_device *pdev)
> @@ -1321,8 +1350,16 @@ static int fsl_ssi_probe(struct platform_device *pdev)
>  		return -ENOMEM;
>  	}
>  
> -	ssi_private->regs = devm_regmap_init_mmio(&pdev->dev, iomem,
> +	ret = of_property_match_string(np, "clock-names", "ipg");
> +	if (ret < 0) {
> +		ssi_private->has_ipg_clk_name = false;
> +		ssi_private->regs = devm_regmap_init_mmio(&pdev->dev, iomem,
>  			&fsl_ssi_regconfig);
> +	} else {
> +		ssi_private->has_ipg_clk_name = true;
> +		ssi_private->regs = devm_regmap_init_mmio_clk(&pdev->dev,
> +			"ipg", iomem, &fsl_ssi_regconfig);
> +	}
>  	if (IS_ERR(ssi_private->regs)) {
>  		dev_err(&pdev->dev, "Failed to init register map\n");
>  		return PTR_ERR(ssi_private->regs);
> -- 
> 1.7.9.5
> 
