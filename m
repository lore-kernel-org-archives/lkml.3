Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbaIJRmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 13:42:21 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35344 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbaIJRmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 13:42:19 -0400
Date: Wed, 10 Sep 2014 10:42:04 -0700
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: Shengjiu Wang <shengjiu.wang@freescale.com>
Cc: timur@tabi.org, Li.Xiubo@freescale.com, lgirdwood@gmail.com,
        broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, mpa@pengutronix.de
Subject: Re: [PATCH V1] ASoC: fsl_ssi: refine ipg clock usage in this module
Message-ID: <20140910174204.GA4628@Asurada>
References: <e5a50d8bfde3aea5fcd092118da5aea4072c7e2f.1410254125.git.shengjiu.wang@freescale.com>
 <20140909183804.GA6944@Asurada>
 <20140910081251.GA14662@audiosh1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140910081251.GA14662@audiosh1>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 04:12:53PM +0800, Shengjiu Wang wrote:
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

> what is the open() and close()? do you mean the fsl_ssi_startup()
> and fsl_ssi_shutdown()?

Yea.

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

> If this probe() is fsl_ssi_imx_probe(), I think no need to add
> clk_prepare_enable() or clk_disable_unprepare(), seems there is no 
> registers accessing in this probe.

This is trying to be safe, especially for such a driver being used
by multiple platforms. You can omit this as long as the patch can
pass the test on old imx, PowerPC, and AC97 platforms.

>

And another risk just came to my mind is that there would be a
possibility that a machine driver would call set_dai_fmt() early,
after SSI's probe() and before SSI's startup(), if the machine
driver contains dai_fmt assignment in its probe(). Then, without
regmap_mmio_clk(), it'll be tough for us over here because we may
also need to add clock enable/disable for set_dai_fmt/set_sysclk(),
even if there might be still tiny risk that we missed something.

Then there could be a selfish approach to circumvent it is to use
regmap_mmio_clk() with "ipg" at the beginning and call regmap_mmio()
without "ipg" if getting a failed return value from regmap_mmio_clk,
and meanwhile to keep the clock always enabled for the regmap_mmio()
case just like what the current driver is doing. This may result
those non-ipg-clk platforms can't benefit from this refinement
unless they update their DT bindings -- use "ipg" for core clock
This might be the safest and simplest way for us, I'm not sure
everyone would be comfortable with this idea though.

Best regards,
Nicolin
