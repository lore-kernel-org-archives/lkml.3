Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751190AbaIJGm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 02:42:27 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:64753 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbaIJGm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 02:42:26 -0400
Date: Tue, 9 Sep 2014 23:42:12 -0700
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: Markus Pargmann <mpa@pengutronix.de>
Cc: Shengjiu Wang <shengjiu.wang@freescale.com>, alsa-devel@alsa-project.org,
        lgirdwood@gmail.com, tiwai@suse.de, linux-kernel@vger.kernel.org,
        broonie@kernel.org, timur@tabi.org, Li.Xiubo@freescale.com,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [alsa-devel] [PATCH V1] ASoC: fsl_ssi: refine ipg clock usage in
 this module
Message-ID: <20140910064211.GA7652@Asurada>
References: <e5a50d8bfde3aea5fcd092118da5aea4072c7e2f.1410254125.git.shengjiu.wang@freescale.com>
 <20140909183804.GA6944@Asurada>
 <20140910062118.GA26348@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140910062118.GA26348@pengutronix.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
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

Thank you for the input. That's the exact part I couldn't be sure.
And I agree that adding a check for AC97 will be safer while this
may keeps itself removable if being unnecessary.

Thanks
Nicolin

