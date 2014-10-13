Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbaJMTYe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 15:24:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:51230 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937AbaJMTYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 15:24:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,712,1406617200"; 
   d="scan'208";a="588217004"
Date: Mon, 13 Oct 2014 12:24:04 -0700
From: David Cohen <david.a.cohen@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>
Cc: linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] pinctrl: baytrail: show output gpio state correctly on
 Intel Baytrail
Message-ID: <20141013192404.GB4034@psi-dev26.jf.intel.com>
References: <1412355319-18946-1-git-send-email-david.a.cohen@linux.intel.com>
 <1413224639-21552-1-git-send-email-david.a.cohen@linux.intel.com>
 <20141013191405.GB29810@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141013191405.GB29810@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2014 at 02:14:05PM -0500, Felipe Balbi wrote:
> On Mon, Oct 13, 2014 at 11:23:59AM -0700, David Cohen wrote:
> > Even if a gpio pin is set to output, we still need to set INPUT_EN bit
> 
> here you say you're setting that bit.
> 
> > to be able to read its value. Without this change, we'll always read low
> > level state.
> > 
> > Cc: <stable@vger.kernel.org> # v3.14+
> > Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> > ---
> > 
> > Hi,
> > 
> > I'm resending same v1 patch but now copying linux stable and linux gpio.
> > This patch is meant for all linux stable trees >= v3.14.
> > 
> > Br, David
> > ---
> > 
> >  drivers/pinctrl/pinctrl-baytrail.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl-baytrail.c
> > index e12e5b07f6d7..c23d8ded936d 100644
> > --- a/drivers/pinctrl/pinctrl-baytrail.c
> > +++ b/drivers/pinctrl/pinctrl-baytrail.c
> > @@ -318,7 +318,7 @@ static int byt_gpio_direction_output(struct gpio_chip *chip,
> >  		"Potential Error: Setting GPIO with direct_irq_en to output");
> >  
> >  	reg_val = readl(reg) | BYT_DIR_MASK;
> > -	reg_val &= ~BYT_OUTPUT_EN;
> > +	reg_val &= ~(BYT_OUTPUT_EN | BYT_INPUT_EN);
> 
> but code is clearing it. Also, you're not patching byt_gpio_get(), so
> you can't be 'reading its value' either. Quite frankly, this looks very
> fishy to me. Comments on BYT_OUTPUT_EN and BYT_INPUT_EN states that
> those bits are active low, meaning that clearing them enables that
> particular feature.
> 
> How can you enable a pin to be both OUTPUT and INPUT ? Look like what
> you really want is:
> 
> diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl-baytrail.c
> index e12e5b0..69f882d 100644
> --- a/drivers/pinctrl/pinctrl-baytrail.c
> +++ b/drivers/pinctrl/pinctrl-baytrail.c
> @@ -290,6 +290,7 @@ static int byt_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
>  
>  	value = readl(reg) | BYT_DIR_MASK;
>  	value &= ~BYT_INPUT_EN;		/* active low */
> +	value |= BYT_OUTPUT_EN;		/* disable output */
>  	writel(value, reg);
>  
>  	spin_unlock_irqrestore(&vg->lock, flags);
> @@ -319,6 +320,7 @@ static int byt_gpio_direction_output(struct gpio_chip *chip,
>  
>  	reg_val = readl(reg) | BYT_DIR_MASK;
>  	reg_val &= ~BYT_OUTPUT_EN;
> +	value |= BYT_INPUT_EN;		/* disable input */
>  
>  	if (value)
>  		writel(reg_val | BYT_LEVEL, reg);
> 
> completely untested however. Care to further explain why clearing both
> bits - thus enabling both INPUT and OUTPUT - is correct ?

Actually I really meant what I sent, but perhaps I misspoke during
explanation. We need to clear the bit to enable the functionality.

!BYT_INPUT_EN allows us to read the value. !BYT_OUTPUT_EN allows us to
set a value. If we want to set a value (acting as output) and still be
able to read via sysfs, we need to set both functionality (i.e. clear
both bits).

I'll resend the patch with a better comment.

Br, David

> 
> -- 
> balbi


