Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303Ab3LCIke (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 03:40:34 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:37867 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab3LCIkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 03:40:33 -0500
Date: Tue, 3 Dec 2013 08:40:26 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, broonie@kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [alsa-devel] [PATCH 3/3] ASoC: ux500: Dynamically fill DAI
 driver data on probe
Message-ID: <20131203084026.GC11828@lee--X1>
References: <1386007222-10081-1-git-send-email-lee.jones@linaro.org>
 <1386007222-10081-3-git-send-email-lee.jones@linaro.org>
 <529CCD2F.3060206@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <529CCD2F.3060206@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Dec 2013, Lars-Peter Clausen wrote:

> On 12/02/2013 07:00 PM, Lee Jones wrote:
> [...]
> > +void ux500_msp_populate_dai_drv(struct snd_soc_dai_driver *ux500_msp_dai_drv)
> > +{
> > +	ux500_msp_dai_drv->probe                 = ux500_msp_dai_probe;
> > +	ux500_msp_dai_drv->suspend               = NULL;
> > +	ux500_msp_dai_drv->resume                = NULL;
> > +	ux500_msp_dai_drv->playback.channels_min = UX500_MSP_MIN_CHANNELS;
> > +	ux500_msp_dai_drv->playback.channels_max = UX500_MSP_MAX_CHANNELS;
> > +	ux500_msp_dai_drv->playback.rates        = UX500_I2S_RATES;
> > +	ux500_msp_dai_drv->playback.formats      = UX500_I2S_FORMATS;
> > +	ux500_msp_dai_drv->capture.channels_min  = UX500_MSP_MIN_CHANNELS;
> > +	ux500_msp_dai_drv->capture.channels_max  = UX500_MSP_MAX_CHANNELS;
> > +	ux500_msp_dai_drv->capture.rates         = UX500_I2S_RATES;
> > +	ux500_msp_dai_drv->capture.formats       = UX500_I2S_FORMATS;
> > +	ux500_msp_dai_drv->ops                   = ux500_msp_dai_ops;
> >  };
> 
> You can just use the same static driver for all devices. No need to
> dynamically allocate it.

How do you mean? Just create a 'static struct' instead?

> >  static const struct snd_soc_component_driver ux500_msp_component = {
> > @@ -809,6 +742,7 @@ static const struct snd_soc_component_driver ux500_msp_component = {
> >  static int ux500_msp_drv_probe(struct platform_device *pdev)
> >  {
> >  	struct ux500_msp_i2s_drvdata *drvdata;
> > +	struct snd_soc_dai_driver *ux500_msp_dai_drv;
> >  	int ret = 0;
> >  
> >  	dev_dbg(&pdev->dev, "%s: Enter (pdev->name = %s).\n", __func__,
> > @@ -863,8 +797,18 @@ static int ux500_msp_drv_probe(struct platform_device *pdev)
> >  	}
> >  	dev_set_drvdata(&pdev->dev, drvdata);
> >  
> > +	ux500_msp_dai_drv = devm_kzalloc(&pdev->dev,
> > +					 sizeof(*ux500_msp_dai_drv),
> > +					 GFP_KERNEL);
> > +	if (!ux500_msp_dai_drv) {
> > +		ret = -ENOMEM;
> > +		goto err_init_msp;
> > +	}
> > +
> > +	ux500_msp_populate_dai_drv(ux500_msp_dai_drv);
> > +
> >  	ret = snd_soc_register_component(&pdev->dev, &ux500_msp_component,
> > -					 &ux500_msp_dai_drv[drvdata->msp->id], 1);
> > +					 ux500_msp_dai_drv, 1);
> >  	if (ret < 0) {
> >  		dev_err(&pdev->dev, "Error: %s: Failed to register MSP%d!\n",
> >  			__func__, drvdata->msp->id);
> > 
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
