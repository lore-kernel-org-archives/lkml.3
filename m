Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab3EHIs4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 04:48:56 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:33977 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab3EHIsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 04:48:52 -0400
Date: Wed, 8 May 2013 09:48:46 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Subject: Re: [PATCH 3/6] ASoC: ux500: Drop pinctrl sleep support
Message-ID: <20130508084846.GB3459@gmail.com>
References: <1367997261-32048-1-git-send-email-fabio.baltieri@linaro.org>
 <1367997261-32048-4-git-send-email-fabio.baltieri@linaro.org>
 <20130508080708.GH3102@gmail.com>
 <20130508082017.GA1526@balto.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130508082017.GA1526@balto.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 May 2013, Fabio Baltieri wrote:

> On Wed, May 08, 2013 at 09:07:08AM +0100, Lee Jones wrote:
> > On Wed, 08 May 2013, Fabio Baltieri wrote:
> > 
> > > Drop pinctrl default/sleep state switching code, as it was breaking the
> > > capture interface by putting the I2S pins in hi-z mode regardless of its
> > > usage status, and not giving any real benefit.
> > > 
> > > Pinctrl default mode configuration is already managed automatically by a
> > > specific pinctrl hog.
> > 
> > I'm sure we should support pinctrl though shouldn't we?
> > 
> > Is there no way of fixing the implementation instead of ripping it out?
> 
> Yes, but requesting the default pinctrl configuration should be enough,
> and as those pins are shared with multiple device ids, a "hog"
> configuration should be the cleanest.
> 
> Actually I asked Linus an opinion before doing this, so maybe he can ack
> this patch or suggest a better way of doing this, such as declaring the
> same pins for multiple device ids, but I'm not sure that would work as
> expected.

Linus is on vacation at the moment, but I agree he should have the
final say on this. Better wait until he returns.

> > > Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> > > ---
> > >  sound/soc/ux500/ux500_msp_i2s.c | 56 ++---------------------------------------
> > >  sound/soc/ux500/ux500_msp_i2s.h |  6 -----
> > >  2 files changed, 2 insertions(+), 60 deletions(-)
> > > 
> > > diff --git a/sound/soc/ux500/ux500_msp_i2s.c b/sound/soc/ux500/ux500_msp_i2s.c
> > > index 964cfd6..8512c78 100644
> > > --- a/sound/soc/ux500/ux500_msp_i2s.c
> > > +++ b/sound/soc/ux500/ux500_msp_i2s.c
> > > @@ -15,7 +15,6 @@
> > >  
> > >  #include <linux/module.h>
> > >  #include <linux/platform_device.h>
> > > -#include <linux/pinctrl/consumer.h>
> > >  #include <linux/delay.h>
> > >  #include <linux/slab.h>
> > >  #include <linux/io.h>
> > > @@ -28,9 +27,6 @@
> > >  
> > >  #include "ux500_msp_i2s.h"
> > >  
> > > -/* MSP1/3 Tx/Rx usage protection */
> > > -static DEFINE_SPINLOCK(msp_rxtx_lock);
> > > -
> > >   /* Protocol desciptors */
> > >  static const struct msp_protdesc prot_descs[] = {
> > >  	{ /* I2S */
> > > @@ -358,24 +354,8 @@ static int configure_multichannel(struct ux500_msp *msp,
> > >  
> > >  static int enable_msp(struct ux500_msp *msp, struct ux500_msp_config *config)
> > >  {
> > > -	int status = 0, retval = 0;
> > > +	int status = 0;
> > >  	u32 reg_val_DMACR, reg_val_GCR;
> > > -	unsigned long flags;
> > > -
> > > -	/* Check msp state whether in RUN or CONFIGURED Mode */
> > > -	if (msp->msp_state == MSP_STATE_IDLE) {
> > > -		spin_lock_irqsave(&msp_rxtx_lock, flags);
> > > -		if (msp->pinctrl_rxtx_ref == 0 &&
> > > -			!(IS_ERR(msp->pinctrl_p) || IS_ERR(msp->pinctrl_def))) {
> > > -			retval = pinctrl_select_state(msp->pinctrl_p,
> > > -						msp->pinctrl_def);
> > > -			if (retval)
> > > -				pr_err("could not set MSP defstate\n");
> > > -		}
> > > -		if (!retval)
> > > -			msp->pinctrl_rxtx_ref++;
> > > -		spin_unlock_irqrestore(&msp_rxtx_lock, flags);
> > > -	}
> > >  
> > >  	/* Configure msp with protocol dependent settings */
> > >  	configure_protocol(msp, config);
> > > @@ -632,8 +612,7 @@ int ux500_msp_i2s_trigger(struct ux500_msp *msp, int cmd, int direction)
> > >  
> > >  int ux500_msp_i2s_close(struct ux500_msp *msp, unsigned int dir)
> > >  {
> > > -	int status = 0, retval = 0;
> > > -	unsigned long flags;
> > > +	int status = 0;
> > >  
> > >  	dev_dbg(msp->dev, "%s: Enter (dir = 0x%01x).\n", __func__, dir);
> > >  
> > > @@ -645,18 +624,6 @@ int ux500_msp_i2s_close(struct ux500_msp *msp, unsigned int dir)
> > >  			       (~(FRAME_GEN_ENABLE | SRG_ENABLE))),
> > >  			      msp->registers + MSP_GCR);
> > >  
> > > -		spin_lock_irqsave(&msp_rxtx_lock, flags);
> > > -		WARN_ON(!msp->pinctrl_rxtx_ref);
> > > -		msp->pinctrl_rxtx_ref--;
> > > -		if (msp->pinctrl_rxtx_ref == 0 &&
> > > -			!(IS_ERR(msp->pinctrl_p) || IS_ERR(msp->pinctrl_sleep))) {
> > > -			retval = pinctrl_select_state(msp->pinctrl_p,
> > > -						msp->pinctrl_sleep);
> > > -			if (retval)
> > > -				pr_err("could not set MSP sleepstate\n");
> > > -		}
> > > -		spin_unlock_irqrestore(&msp_rxtx_lock, flags);
> > > -
> > >  		writel(0, msp->registers + MSP_GCR);
> > >  		writel(0, msp->registers + MSP_TCF);
> > >  		writel(0, msp->registers + MSP_RCF);
> > > @@ -745,25 +712,6 @@ int ux500_msp_i2s_init_msp(struct platform_device *pdev,
> > >  	dev_dbg(&pdev->dev, "I2S device-name: '%s'\n", i2s_cont->name);
> > >  	msp->i2s_cont = i2s_cont;
> > >  
> > > -	msp->pinctrl_p = pinctrl_get(msp->dev);
> > > -	if (IS_ERR(msp->pinctrl_p))
> > > -		dev_err(&pdev->dev, "could not get MSP pinctrl\n");
> > > -	else {
> > > -		msp->pinctrl_def = pinctrl_lookup_state(msp->pinctrl_p,
> > > -						PINCTRL_STATE_DEFAULT);
> > > -		if (IS_ERR(msp->pinctrl_def)) {
> > > -			dev_err(&pdev->dev,
> > > -				"could not get MSP defstate (%li)\n",
> > > -				PTR_ERR(msp->pinctrl_def));
> > > -		}
> > > -		msp->pinctrl_sleep = pinctrl_lookup_state(msp->pinctrl_p,
> > > -						PINCTRL_STATE_SLEEP);
> > > -		if (IS_ERR(msp->pinctrl_sleep))
> > > -			dev_err(&pdev->dev,
> > > -				"could not get MSP idlestate (%li)\n",
> > > -				PTR_ERR(msp->pinctrl_def));
> > > -	}
> > > -
> > >  	return 0;
> > >  }
> > >  
> > > diff --git a/sound/soc/ux500/ux500_msp_i2s.h b/sound/soc/ux500/ux500_msp_i2s.h
> > > index 1311c0d..1ce336f 100644
> > > --- a/sound/soc/ux500/ux500_msp_i2s.h
> > > +++ b/sound/soc/ux500/ux500_msp_i2s.h
> > > @@ -530,12 +530,6 @@ struct ux500_msp {
> > >  	int loopback_enable;
> > >  	u32 backup_regs[MAX_MSP_BACKUP_REGS];
> > >  	unsigned int f_bitclk;
> > > -	/* Pin modes */
> > > -	struct pinctrl *pinctrl_p;
> > > -	struct pinctrl_state *pinctrl_def;
> > > -	struct pinctrl_state *pinctrl_sleep;
> > > -	/* Reference Count */
> > > -	int pinctrl_rxtx_ref;
> > >  };
> > >  
> > >  struct ux500_msp_dma_params {
> 

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
