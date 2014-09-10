Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbaIJKa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 06:30:26 -0400
Received: from mail-by2on0143.outbound.protection.outlook.com ([207.46.100.143]:48697
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751690AbaIJKaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 06:30:24 -0400
Date: Wed, 10 Sep 2014 18:30:06 +0800
From: Shengjiu Wang <shengjiu.wang@freescale.com>
To: Markus Pargmann <mpa@pengutronix.de>
CC: Nicolin Chen <nicoleotsuka@gmail.com>, <timur@tabi.org>,
        <Li.Xiubo@freescale.com>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <perex@perex.cz>, <tiwai@suse.de>, <alsa-devel@alsa-project.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V1] ASoC: fsl_ssi: refine ipg clock usage in this module
Message-ID: <20140910103005.GB17326@audiosh1>
References: <e5a50d8bfde3aea5fcd092118da5aea4072c7e2f.1410254125.git.shengjiu.wang@freescale.com>
 <20140909183804.GA6944@Asurada> <20140910062118.GA26348@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140910062118.GA26348@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019019)(6009001)(51704005)(24454002)(199003)(189002)(31966008)(84676001)(15975445006)(83506001)(97756001)(74662001)(74502001)(104016003)(33716001)(97736003)(15202345003)(23726002)(106466001)(81156004)(105606002)(33656002)(54356999)(76176999)(99396002)(26826002)(102836001)(64706001)(20776003)(79102001)(47776003)(80022001)(77982001)(87936001)(50986999)(110136001)(21056001)(46406003)(76482001)(83322001)(44976005)(19580395003)(68736004)(6806004)(69596002)(81542001)(81342001)(107046002)(95666004)(85306004)(83072002)(50466002)(46102001)(92726001)(92566001)(85852003)(86362001)(4396001)(90102001)(21314002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0614;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 033054F29A
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=shengjiu.wang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 08:21:18AM +0200, Markus Pargmann wrote:
> On Tue, Sep 09, 2014 at 11:38:05AM -0700, Nicolin Chen wrote:
> > On Tue, Sep 09, 2014 at 05:18:07PM +0800, Shengjiu Wang wrote:
> > > @@ -1321,7 +1333,11 @@ static int fsl_ssi_probe(struct platform_device *pdev)
> > >  		return -ENOMEM;
> > >  	}
> > >  
> > > -	ssi_private->regs = devm_regmap_init_mmio(&pdev->dev, iomem,
> > > +	if (ssi_private->soc->imx)
> > > +		ssi_private->regs = devm_regmap_init_mmio_clk(&pdev->dev,
> > > +			"ipg", iomem, &fsl_ssi_regconfig);
> > > +	else
> > > +		ssi_private->regs = devm_regmap_init_mmio(&pdev->dev, iomem,
> > 
> > As Markus mentioned, the key point here is to be compatible with those
> > non-clock-name platforms.
> > 
> > I think it would be safer to keep the current code while adding an extra
> > clk_disable_unprepare() at the end of probe() as a common routine. And
> > meantime, make sure to have the call for imx only because it seems that
> > the other platforms do not depend on the clock. //a bit guessing here :)
> > 
> > Then we can get a patch like:
> > open() {
> > +	clk_prepare_enable();
> > 	....
> > }
> > 
> > close() {
> > 	....
> > +	clk_disable_unprepare()
> > }
> > 
> > probe() {
> > 	clk_get();
> > 	clk_prepare_enable();
> > 	....
> > 	if (xxx)
> > -		goto err_xx;
> > +		return ret;
> > 	....
> > +	clk_disable_unprepare();
> > 	return 0;
> > -err_xx:
> > -	clk_disable_unprepare()
> > }
> > 
> > remove() {
> > 	....
> > -	clk_disable_unprepare()
> > }
> 
> If I remember correctly, there may be AC97 communication with the codec
> before any substream is created. That's why we enable the SSI unit right
> at the beginning for AC97 in fsl_ssi_setup_reg_vals(). So we need to
> check for AC97 before disabling clocks.
> 
> Best regards,
> 
> Markus

hi Markus

I think if clk_prepare_enable() in startup(), and clk_disable_unprepare()
in shutdown can meet this requirement, right?


done:
        if (ssi_private->dai_fmt)
                _fsl_ssi_set_dai_fmt(ssi_private, ssi_private->dai_fmt);

I find that in end of probe, there is setting of dai_fmt. Can we remove this?
because this setting need to enable ipg clock, and if ac97, ipg clock can't be
disabled.

wang shengjiu
> 
> -- 
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |


