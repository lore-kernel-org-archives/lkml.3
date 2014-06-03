Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbaFCLGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:06:19 -0400
Received: from mga03.intel.com ([143.182.124.21]:9551 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbaFCLGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:06:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,964,1392192000"; 
   d="scan'208";a="440241118"
Date: Tue, 3 Jun 2014 14:06:00 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: eric.ernst@linux.intel.com
Cc: linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        mark.gross@intel.com
Subject: Re: [PATCH v2 1/1] PINCTRL: Warn if direct IRQ GPIO set to output
Message-ID: <20140603110600.GG1730@lahna.fi.intel.com>
References: <0140602191416.GD1730@lahna.fi.intel.com>
 <1401743527-47035-1-git-send-email-eric.ernst@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401743527-47035-1-git-send-email-eric.ernst@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 02:12:07PM -0700, eric.ernst@linux.intel.com wrote:
> From: Eric Ernst <eric.ernst@linux.intel.com>
> 
> For Baytrail, you should never set a GPIO set to direct_irq
> to output mode.  When direct_irq_en is set for a GPIO, it is
> tied directly to an APIC internally, and making the pad output
> does not make any sense. Assert a WARN() in the event this happens.

Subject should probably be:

pinctrl: baytrail: Warn if direct IRQ GPIO is set to output

> Signed-off-by: Eric Ernst <eric.ernst@linux.intel.com>
> ---
>  drivers/pinctrl/pinctrl-baytrail.c |   19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl-baytrail.c
> index e59983423991..fde3767df254 100644
> --- a/drivers/pinctrl/pinctrl-baytrail.c
> +++ b/drivers/pinctrl/pinctrl-baytrail.c
> @@ -47,6 +47,7 @@
>  #define BYT_TRIG_POS		BIT(25)
>  #define BYT_TRIG_LVL		BIT(24)
>  #define BYT_PIN_MUX		0x07
> +#define BYT_DIRECTIRQ		BIT(27)

Please move this definition to be first, like:

/* BYT_CONF0_REG register bits */
#define BYT_DIRECT_IRQ_EN	BIT(27)
#define BYT_TRIG_NEG		BIT(26)
#define BYT_TRIG_POS		BIT(25)

and I would call it BYT_DIRECT_IRQ_EN since it's name in datasheet is
"direct_irq_en".

>  
>  /* BYT_VAL_REG register bits */
>  #define BYT_INPUT_EN		BIT(2)  /* 0: input enabled (active low)*/
> @@ -256,19 +257,29 @@ static int byt_gpio_direction_output(struct gpio_chip *chip,
>  				     unsigned gpio, int value)
>  {
>  	struct byt_gpio *vg = to_byt_gpio(chip);
> -	void __iomem *reg = byt_gpio_reg(chip, gpio, BYT_VAL_REG);
> +	void __iomem *conf_reg = byt_gpio_reg(chip, gpio, BYT_CONF0_REG);
> +	void __iomem *value_reg = byt_gpio_reg(chip, gpio, BYT_VAL_REG);

Not sure if it is necessary to rename reg -> value_reg. It just makes
the patch bigger than it has to be since you also need to rename stuff
below.

Otherwise looks good.

>  	unsigned long flags;
>  	u32 reg_val;
>  
>  	spin_lock_irqsave(&vg->lock, flags);
>  
> -	reg_val = readl(reg) | BYT_DIR_MASK;
> +	/*
> +	 * Before making any direction modifications, do a check if gpio
> +	 * is set for direct IRQ.  On baytrail, setting GPIO to output does
> +	 * not make sense, so let's at least warn the caller before they shoot
> +	 * themselves in the foot.
> +	 */
> +	WARN((readl(conf_reg) & BYT_DIRECTIRQ),
> +		"Potential Error: Setting GPIO with direct_irq_en to output");
> +
> +	reg_val = readl(value_reg) | BYT_DIR_MASK;
>  	reg_val &= ~BYT_OUTPUT_EN;
>  
>  	if (value)
> -		writel(reg_val | BYT_LEVEL, reg);
> +		writel(reg_val | BYT_LEVEL, value_reg);
>  	else
> -		writel(reg_val & ~BYT_LEVEL, reg);
> +		writel(reg_val & ~BYT_LEVEL, value_reg);
>  
>  	spin_unlock_irqrestore(&vg->lock, flags);
>  
> -- 
> 1.7.9.5
