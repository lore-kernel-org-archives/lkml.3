Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab3LBSKX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 13:10:23 -0500
Received: from smtp-out-003.synserver.de ([212.40.185.3]:1056 "EHLO
	smtp-out-110.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752529Ab3LBSKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 13:10:22 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 14721
Message-ID: <529CCD2F.3060206@metafoo.de>
Date: Mon, 02 Dec 2013 19:10:55 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, broonie@kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [alsa-devel] [PATCH 3/3] ASoC: ux500: Dynamically fill DAI driver
 data on probe
References: <1386007222-10081-1-git-send-email-lee.jones@linaro.org> <1386007222-10081-3-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1386007222-10081-3-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2013 07:00 PM, Lee Jones wrote:
[...]
> +void ux500_msp_populate_dai_drv(struct snd_soc_dai_driver *ux500_msp_dai_drv)
> +{
> +	ux500_msp_dai_drv->probe                 = ux500_msp_dai_probe;
> +	ux500_msp_dai_drv->suspend               = NULL;
> +	ux500_msp_dai_drv->resume                = NULL;
> +	ux500_msp_dai_drv->playback.channels_min = UX500_MSP_MIN_CHANNELS;
> +	ux500_msp_dai_drv->playback.channels_max = UX500_MSP_MAX_CHANNELS;
> +	ux500_msp_dai_drv->playback.rates        = UX500_I2S_RATES;
> +	ux500_msp_dai_drv->playback.formats      = UX500_I2S_FORMATS;
> +	ux500_msp_dai_drv->capture.channels_min  = UX500_MSP_MIN_CHANNELS;
> +	ux500_msp_dai_drv->capture.channels_max  = UX500_MSP_MAX_CHANNELS;
> +	ux500_msp_dai_drv->capture.rates         = UX500_I2S_RATES;
> +	ux500_msp_dai_drv->capture.formats       = UX500_I2S_FORMATS;
> +	ux500_msp_dai_drv->ops                   = ux500_msp_dai_ops;
>  };

You can just use the same static driver for all devices. No need to
dynamically allocate it.

>  
>  static const struct snd_soc_component_driver ux500_msp_component = {
> @@ -809,6 +742,7 @@ static const struct snd_soc_component_driver ux500_msp_component = {
>  static int ux500_msp_drv_probe(struct platform_device *pdev)
>  {
>  	struct ux500_msp_i2s_drvdata *drvdata;
> +	struct snd_soc_dai_driver *ux500_msp_dai_drv;
>  	int ret = 0;
>  
>  	dev_dbg(&pdev->dev, "%s: Enter (pdev->name = %s).\n", __func__,
> @@ -863,8 +797,18 @@ static int ux500_msp_drv_probe(struct platform_device *pdev)
>  	}
>  	dev_set_drvdata(&pdev->dev, drvdata);
>  
> +	ux500_msp_dai_drv = devm_kzalloc(&pdev->dev,
> +					 sizeof(*ux500_msp_dai_drv),
> +					 GFP_KERNEL);
> +	if (!ux500_msp_dai_drv) {
> +		ret = -ENOMEM;
> +		goto err_init_msp;
> +	}
> +
> +	ux500_msp_populate_dai_drv(ux500_msp_dai_drv);
> +
>  	ret = snd_soc_register_component(&pdev->dev, &ux500_msp_component,
> -					 &ux500_msp_dai_drv[drvdata->msp->id], 1);
> +					 ux500_msp_dai_drv, 1);
>  	if (ret < 0) {
>  		dev_err(&pdev->dev, "Error: %s: Failed to register MSP%d!\n",
>  			__func__, drvdata->msp->id);
> 

