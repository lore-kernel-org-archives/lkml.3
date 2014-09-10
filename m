Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808AbaIJINN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 04:13:13 -0400
Received: from mail-bn1bn0109.outbound.protection.outlook.com ([157.56.110.109]:51261
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751260AbaIJINK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 04:13:10 -0400
X-Greylist: delayed 82758 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Sep 2014 04:13:10 EDT
Date: Wed, 10 Sep 2014 16:12:53 +0800
From: Shengjiu Wang <shengjiu.wang@freescale.com>
To: Nicolin Chen <nicoleotsuka@gmail.com>
CC: <timur@tabi.org>, <Li.Xiubo@freescale.com>, <lgirdwood@gmail.com>,
        <broonie@kernel.org>, <perex@perex.cz>, <tiwai@suse.de>,
        <alsa-devel@alsa-project.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <mpa@pengutronix.de>
Subject: Re: [PATCH V1] ASoC: fsl_ssi: refine ipg clock usage in this module
Message-ID: <20140910081251.GA14662@audiosh1>
References: <e5a50d8bfde3aea5fcd092118da5aea4072c7e2f.1410254125.git.shengjiu.wang@freescale.com>
 <20140909183804.GA6944@Asurada>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140909183804.GA6944@Asurada>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019019)(6009001)(199003)(51704005)(24454002)(189002)(105606002)(84676001)(83322001)(81156004)(95666004)(76482001)(77982001)(79102001)(107046002)(83506001)(85852003)(64706001)(85306004)(110136001)(106466001)(69596002)(1411001)(50466002)(26826002)(46102001)(68736004)(99396002)(90102001)(33716001)(74662001)(102836001)(33656002)(74502001)(97756001)(50986999)(4396001)(6806004)(47776003)(83072002)(104016003)(92726001)(87936001)(21056001)(20776003)(92566001)(44976005)(23726002)(80022001)(54356999)(81542001)(97736003)(46406003)(86362001)(76176999)(81342001)(31966008)(21314002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0610;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 033054F29A
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=shengjiu.wang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 11:38:05AM -0700, Nicolin Chen wrote:
> On Tue, Sep 09, 2014 at 05:18:07PM +0800, Shengjiu Wang wrote:
> > @@ -1321,7 +1333,11 @@ static int fsl_ssi_probe(struct platform_device *pdev)
> >  		return -ENOMEM;
> >  	}
> >  
> > -	ssi_private->regs = devm_regmap_init_mmio(&pdev->dev, iomem,
> > +	if (ssi_private->soc->imx)
> > +		ssi_private->regs = devm_regmap_init_mmio_clk(&pdev->dev,
> > +			"ipg", iomem, &fsl_ssi_regconfig);
> > +	else
> > +		ssi_private->regs = devm_regmap_init_mmio(&pdev->dev, iomem,
> 
> As Markus mentioned, the key point here is to be compatible with those
> non-clock-name platforms.
> 
> I think it would be safer to keep the current code while adding an extra
> clk_disable_unprepare() at the end of probe() as a common routine. And
> meantime, make sure to have the call for imx only because it seems that
> the other platforms do not depend on the clock. //a bit guessing here :)
> 
> Then we can get a patch like:
> open() {
> +	clk_prepare_enable();
> 	....
> }
> 
> close() {
> 	....
> +	clk_disable_unprepare()
> }
what is the open() and close()? do you mean the fsl_ssi_startup()
and fsl_ssi_shutdown()?
> 
> probe() {
> 	clk_get();
> 	clk_prepare_enable();
> 	....
> 	if (xxx)
> -		goto err_xx;
> +		return ret;
> 	....
> +	clk_disable_unprepare();
> 	return 0;
> -err_xx:
> -	clk_disable_unprepare()
> }
If this probe() is fsl_ssi_imx_probe(), I think no need to add
clk_prepare_enable() or clk_disable_unprepare(), seems there is no 
registers accessing in this probe.
> 
> remove() {
> 	....
> -	clk_disable_unprepare()
> }
> 
> As long as you make the subject clear as 'Don't enable core/ipg clock
> when SSI's idle', I'm sure you can make them within a single patch.
> 
> And an alternative way for open() and close() is to put those code into
> pm_runtime_resume/suspend() instead (since we might have some internal
> code need to be added by using pm_runtime as well), which would make
> the further code neater IMO.
> 
> Thank you
> Nicolin
