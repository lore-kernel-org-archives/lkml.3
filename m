Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab3LCIgI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 03:36:08 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:57961 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab3LCIgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 03:36:06 -0500
Date: Tue, 3 Dec 2013 08:36:00 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, broonie@kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [alsa-devel] [PATCH 2/3] ASoC: ux500_pcm: Differentiate between
 pdata and DT initialisation
Message-ID: <20131203083600.GB11828@lee--X1>
References: <1386007222-10081-1-git-send-email-lee.jones@linaro.org>
 <1386007222-10081-2-git-send-email-lee.jones@linaro.org>
 <529CCDAF.7050205@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <529CCDAF.7050205@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Dec 2013, Lars-Peter Clausen wrote:

> On 12/02/2013 07:00 PM, Lee Jones wrote:
> > If booting with full DT support (i.e. DMA too, the last piece of the
> > puzzle), then we don't need to use the compatible request channel call
> > back. We also require slightly different flags to inform the core that
> > we are booting with DT.
> 
> I don't think you need differentiate between DT and non-DT here.
> If the SND_DMAENGINE_PCM_FLAG_COMPAT is set and the
> SND_DMAENGINE_PCM_FLAG_NO_DT is not set it will first try to request the
> channels from the DT if that fails it will fallback to the compat path. So
> all this patch needs to do is remove the SND_DMAENGINE_PCM_FLAG_NO_DT, that
> should be it.

I have no way of testing that, as we are currently 80% through
shutting down platform data altogether. In fact, I think there is only
ASoC to be converted. Most of this stuff is going to be ripped out
within the next couple of weeks in any case. It will happen as soon as
I can find an hour or two to work on it.

For that reason I didn't want to disturb the current semantics. I've
already found that a bunch of he generic (oh, you can just use the
central) functions (for that) don't actually work for us for one
reason or another.

I plan to a) convert everything over to DT only and b) try to make the
generic functions work for us, so we can eliminate yet more code in
the very near future.

> > Cc: alsa-devel@alsa-project.org
> > Acked-by: Linus Walleij <linus.walleij@linaro.org>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  sound/soc/ux500/ux500_pcm.c | 26 +++++++++++++++++++++-----
> >  1 file changed, 21 insertions(+), 5 deletions(-)
> > 
> > diff --git a/sound/soc/ux500/ux500_pcm.c b/sound/soc/ux500/ux500_pcm.c
> > index 2f1bdb7..00cdd7b 100644
> > --- a/sound/soc/ux500/ux500_pcm.c
> > +++ b/sound/soc/ux500/ux500_pcm.c
> > @@ -134,15 +134,31 @@ static const struct snd_dmaengine_pcm_config ux500_dmaengine_pcm_config = {
> >  	.prepare_slave_config = ux500_pcm_prepare_slave_config,
> >  };
> >  
> > +static const struct snd_dmaengine_pcm_config ux500_dmaengine_of_pcm_config = {
> > +	.prepare_slave_config = ux500_pcm_prepare_slave_config,
> > +};
> > +
> >  int ux500_pcm_register_platform(struct platform_device *pdev)
> >  {
> > +	const struct snd_dmaengine_pcm_config *pcm_config;
> > +	struct device_node *np = pdev->dev.of_node;
> > +	unsigned int pcm_flags;
> >  	int ret;
> >  
> > -	ret = snd_dmaengine_pcm_register(&pdev->dev,
> > -			&ux500_dmaengine_pcm_config,
> > -			SND_DMAENGINE_PCM_FLAG_NO_RESIDUE |
> > -			SND_DMAENGINE_PCM_FLAG_COMPAT |
> > -			SND_DMAENGINE_PCM_FLAG_NO_DT);
> > +	if (np) {
> > +		pcm_config = &ux500_dmaengine_of_pcm_config;
> > +
> > +		pcm_flags = SND_DMAENGINE_PCM_FLAG_NO_RESIDUE |
> > +			SND_DMAENGINE_PCM_FLAG_COMPAT;
> > +	} else {
> > +		pcm_config = &ux500_dmaengine_pcm_config;
> > +
> > +		pcm_flags = SND_DMAENGINE_PCM_FLAG_NO_RESIDUE |
> > +			SND_DMAENGINE_PCM_FLAG_NO_DT |
> > +			SND_DMAENGINE_PCM_FLAG_COMPAT;
> > +	}
> > +
> > +	ret = snd_dmaengine_pcm_register(&pdev->dev, pcm_config, pcm_flags);
> >  	if (ret < 0) {
> >  		dev_err(&pdev->dev,
> >  			"%s: ERROR: Failed to register platform '%s' (%d)!\n",
> > 
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
