Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbaIOKWx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 06:22:53 -0400
Received: from mail-bl2on0139.outbound.protection.outlook.com ([65.55.169.139]:9680
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753862AbaIOKWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 06:22:51 -0400
Date: Mon, 15 Sep 2014 18:22:27 +0800
From: Shengjiu Wang <shengjiu.wang@freescale.com>
To: Markus Pargmann <mpa@pengutronix.de>
CC: <timur@tabi.org>, <nicoleotsuka@gmail.com>, <Li.Xiubo@freescale.com>,
        <lgirdwood@gmail.com>, <broonie@kernel.org>, <perex@perex.cz>,
        <tiwai@suse.de>, <alsa-devel@alsa-project.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3] ASoC: fsl_ssi: refine ipg clock usage in this module
Message-ID: <20140915102224.GA23877@audiosh1>
References: <894383e00876763f22988fc5f3f9f232f939f923.1410517971.git.shengjiu.wang@freescale.com>
 <20140915100541.GD8844@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140915100541.GD8844@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(24454002)(199003)(51704005)(54534003)(106466001)(54356999)(76176999)(105606002)(110136001)(50986999)(107046002)(97756001)(20776003)(97736003)(92726001)(99396002)(86362001)(33656002)(47776003)(46102001)(83072002)(4396001)(6806004)(95666004)(85852003)(76482001)(83322001)(19580395003)(92566001)(33716001)(26826002)(102836001)(44976005)(87936001)(19580405001)(68736004)(31966008)(74502001)(74662001)(90102001)(77982001)(83506001)(15202345003)(15975445006)(104016003)(84676001)(85306004)(81542001)(23726002)(21056001)(79102001)(46406003)(80022001)(64706001)(50466002)(81342001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0615;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03355EE97E
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=shengjiu.wang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 12:05:41PM +0200, Markus Pargmann wrote:
> On Fri, Sep 12, 2014 at 06:35:15PM +0800, Shengjiu Wang wrote:
> > Check if ipg clock is in clock-names property, then we can move the
> > ipg clock enable and disable operation to startup and shutdown, that
> > is only enable ipg clock when ssi is working and keep clock is disabled
> > when ssi is in idle.
> > But when the checking is failed, remain the clock control as before.
> > 
> > Signed-off-by: Shengjiu Wang <shengjiu.wang@freescale.com>
> > ---
> > V3 change log:
> > update patch according Nicolin and markus's comments
> > 
> > 
> >  sound/soc/fsl/fsl_ssi.c |   53 ++++++++++++++++++++++++++++++++++++++++-------
> >  1 file changed, 45 insertions(+), 8 deletions(-)
> > 
> > diff --git a/sound/soc/fsl/fsl_ssi.c b/sound/soc/fsl/fsl_ssi.c
> > index 2fc3e66..6d1dfd5 100644
> > --- a/sound/soc/fsl/fsl_ssi.c
> > +++ b/sound/soc/fsl/fsl_ssi.c
> > @@ -169,6 +169,7 @@ struct fsl_ssi_private {
> >  	u8 i2s_mode;
> >  	bool use_dma;
> >  	bool use_dual_fifo;
> > +	bool has_ipg_clk_name;
> >  	unsigned int fifo_depth;
> >  	struct fsl_ssi_rxtx_reg_val rxtx_reg_val;
> >  
> > @@ -530,6 +531,11 @@ static int fsl_ssi_startup(struct snd_pcm_substream *substream,
> >  	struct snd_soc_pcm_runtime *rtd = substream->private_data;
> >  	struct fsl_ssi_private *ssi_private =
> >  		snd_soc_dai_get_drvdata(rtd->cpu_dai);
> > +	int ret;
> > +
> > +	ret = clk_prepare_enable(ssi_private->clk);
> > +	if (ret)
> > +		return ret;
> >  
> >  	/* When using dual fifo mode, it is safer to ensure an even period
> >  	 * size. If appearing to an odd number while DMA always starts its
> > @@ -544,6 +550,21 @@ static int fsl_ssi_startup(struct snd_pcm_substream *substream,
> >  }
> >  
> >  /**
> > + * fsl_ssi_shutdown: shutdown the SSI
> > + *
> > + */
> > +static void fsl_ssi_shutdown(struct snd_pcm_substream *substream,
> > +                             struct snd_soc_dai *dai)
> > +{
> > +	struct snd_soc_pcm_runtime *rtd = substream->private_data;
> > +	struct fsl_ssi_private *ssi_private =
> > +		snd_soc_dai_get_drvdata(rtd->cpu_dai);
> > +
> > +	clk_disable_unprepare(ssi_private->clk);
> > +
> > +}
> > +
> > +/**
> >   * fsl_ssi_set_bclk - configure Digital Audio Interface bit clock
> >   *
> >   * Note: This function can be only called when using SSI as DAI master
> > @@ -1043,6 +1064,7 @@ static int fsl_ssi_dai_probe(struct snd_soc_dai *dai)
> >  
> >  static const struct snd_soc_dai_ops fsl_ssi_dai_ops = {
> >  	.startup	= fsl_ssi_startup,
> > +	.shutdown       = fsl_ssi_shutdown,
> >  	.hw_params	= fsl_ssi_hw_params,
> >  	.hw_free	= fsl_ssi_hw_free,
> >  	.set_fmt	= fsl_ssi_set_dai_fmt,
> > @@ -1168,17 +1190,22 @@ static int fsl_ssi_imx_probe(struct platform_device *pdev,
> >  	u32 dmas[4];
> >  	int ret;
> >  
> > -	ssi_private->clk = devm_clk_get(&pdev->dev, NULL);
> > +	if (ssi_private->has_ipg_clk_name)
> > +		ssi_private->clk = devm_clk_get(&pdev->dev, "ipg");
> > +	else
> > +		ssi_private->clk = devm_clk_get(&pdev->dev, NULL);
> >  	if (IS_ERR(ssi_private->clk)) {
> >  		ret = PTR_ERR(ssi_private->clk);
> >  		dev_err(&pdev->dev, "could not get clock: %d\n", ret);
> >  		return ret;
> >  	}
> >  
> > -	ret = clk_prepare_enable(ssi_private->clk);
> > -	if (ret) {
> > -		dev_err(&pdev->dev, "clk_prepare_enable failed: %d\n", ret);
> > -		return ret;
> > +	if (!ssi_private->has_ipg_clk_name) {
> > +		ret = clk_prepare_enable(ssi_private->clk);
> > +		if (ret) {
> > +			dev_err(&pdev->dev, "clk_prepare_enable failed: %d\n", ret);
> > +			return ret;
> > +		}
> >  	}
> >  
> >  	/* For those SLAVE implementations, we ingore non-baudclk cases
> > @@ -1236,8 +1263,9 @@ static int fsl_ssi_imx_probe(struct platform_device *pdev,
> >  	return 0;
> >  
> >  error_pcm:
> > -	clk_disable_unprepare(ssi_private->clk);
> >  
> > +	if (!ssi_private->has_ipg_clk_name)
> > +		clk_disable_unprepare(ssi_private->clk);
> >  	return ret;
> >  }
> >  
> > @@ -1246,7 +1274,8 @@ static void fsl_ssi_imx_clean(struct platform_device *pdev,
> >  {
> >  	if (!ssi_private->use_dma)
> >  		imx_pcm_fiq_exit(pdev);
> > -	clk_disable_unprepare(ssi_private->clk);
> > +	if (!ssi_private->has_ipg_clk_name)
> > +		clk_disable_unprepare(ssi_private->clk);
> >  }
> >  
> >  static int fsl_ssi_probe(struct platform_device *pdev)
> > @@ -1321,8 +1350,16 @@ static int fsl_ssi_probe(struct platform_device *pdev)
> >  		return -ENOMEM;
> >  	}
> >  
> > -	ssi_private->regs = devm_regmap_init_mmio(&pdev->dev, iomem,
> > +	ret = of_property_match_string(np, "clock-names", "ipg");
> > +	if (ret < 0) {
> > +		ssi_private->has_ipg_clk_name = false;
> > +		ssi_private->regs = devm_regmap_init_mmio(&pdev->dev, iomem,
> >  			&fsl_ssi_regconfig);
> 
> Sorry if I was unclear about that. My suggestion was to enable the clock
> right here:
> 		clk_prepare_enable(ssi_private->clk);
> 
> Then you can remove ssi_private->has_ipg_clk_name and all
> clk_prepare_enable() and clk_disable_unprepare() from above. Also you
> can move the devm_clk_get() into this block.
>

ipg clock not only need to be enabled when accessing register, but also 
need to be enabled when ssi is working. So I add clk_enable in startup.
 
> It seems you really want to implement this for devicetrees where the
> "ipg" clock-name is missing, but I don't understand why? I really can't
> see any benefit of adding all these clk_prepare_enable() calls for all
> cornercases that may occure. For example the clocks for AC97 are still
> missing in this version.

When ipg clock-name is missing, I just remain the code logic as before.
So AC97 case is same as before too. 
When have ipg clock-name, register it to regmap for accessing register,
and enabling ipg clock in startup also is useful for AC97.

I don't understand why you think clock for AC97 is still missing?

wang shengjiu

> 
> Best regards,
> 
> Markus
> 
> > +	} else {
> > +		ssi_private->has_ipg_clk_name = true;
> > +		ssi_private->regs = devm_regmap_init_mmio_clk(&pdev->dev,
> > +			"ipg", iomem, &fsl_ssi_regconfig);
> > +	}
> >  	if (IS_ERR(ssi_private->regs)) {
> >  		dev_err(&pdev->dev, "Failed to init register map\n");
> >  		return PTR_ERR(ssi_private->regs);
> > -- 
> > 1.7.9.5
> > 
> > 
> 
> -- 
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |


