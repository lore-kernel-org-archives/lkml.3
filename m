Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798AbaIRLRM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 07:17:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:7044 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756339AbaIRLRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 07:17:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,546,1406617200"; 
   d="scan'208";a="575016577"
Date: Thu, 18 Sep 2014 14:17:05 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] gpio: sch: Consolidate similar algorithms
Message-ID: <20140918111705.GM10854@lahna.fi.intel.com>
References: <1410943745-9354-1-git-send-email-rebecca.swee.fun.chang@intel.com>
 <1410943745-9354-2-git-send-email-rebecca.swee.fun.chang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410943745-9354-2-git-send-email-rebecca.swee.fun.chang@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 04:49:03PM +0800, Chang Rebecca Swee Fun wrote:
> Consolidating similar algorithms into common functions to make
> GPIO SCH simpler and manageable.
> 
> Signed-off-by: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
> ---
>  drivers/gpio/gpio-sch.c |   95 ++++++++++++++++++++++++++---------------------
>  1 file changed, 53 insertions(+), 42 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-sch.c b/drivers/gpio/gpio-sch.c
> index 99720c8..2189c22 100644
> --- a/drivers/gpio/gpio-sch.c
> +++ b/drivers/gpio/gpio-sch.c
> @@ -43,6 +43,8 @@ struct sch_gpio {
>  
>  #define to_sch_gpio(c)	container_of(c, struct sch_gpio, chip)
>  
> +static void sch_gpio_set(struct gpio_chip *gc, unsigned gpio_num, int val);
> +

Is it possible to move the sch_gpio_set() function here instead of
forward declaring it?

>  static unsigned sch_gpio_offset(struct sch_gpio *sch, unsigned gpio,
>  				unsigned reg)
>  {
> @@ -63,94 +65,89 @@ static unsigned sch_gpio_bit(struct sch_gpio *sch, unsigned gpio)
>  	return gpio % 8;
>  }
>  
> -static void sch_gpio_enable(struct sch_gpio *sch, unsigned gpio)
> +static void sch_gpio_enable(struct sch_gpio *sch, unsigned gpio, unsigned reg)

I don't see much value in doing this.

To me sch_gpio_enable(sch, gpio) is more intuitive than
sch_gpio_enable(sch, gpio, GEN). Why do I need to pass register to
enable function in the first place? It should know better how to enable
the GPIO, right?

Same goes for others.

>  {
>  	unsigned short offset, bit;
>  	u8 enable;
>  
>  	spin_lock(&sch->lock);
>  
> -	offset = sch_gpio_offset(sch, gpio, GEN);
> +	offset = sch_gpio_offset(sch, gpio, reg);
>  	bit = sch_gpio_bit(sch, gpio);
>  
>  	enable = inb(sch->iobase + offset);
> -	if (!(enable & (1 << bit)))
> -		outb(enable | (1 << bit), sch->iobase + offset);
> +	if (!(enable & BIT(bit)))
> +		outb(enable | BIT(bit), sch->iobase + offset);
>  
>  	spin_unlock(&sch->lock);
>  }
>  
> -static int sch_gpio_direction_in(struct gpio_chip *gc, unsigned  gpio_num)
> +static void sch_gpio_disable(struct sch_gpio *sch, unsigned gpio, unsigned reg)
>  {
> -	struct sch_gpio *sch = to_sch_gpio(gc);
> -	u8 curr_dirs;
>  	unsigned short offset, bit;
> +	u8 disable;
>  
>  	spin_lock(&sch->lock);
>  
> -	offset = sch_gpio_offset(sch, gpio_num, GIO);
> -	bit = sch_gpio_bit(sch, gpio_num);
> -
> -	curr_dirs = inb(sch->iobase + offset);
> +	offset = sch_gpio_offset(sch, gpio, reg);
> +	bit = sch_gpio_bit(sch, gpio);
>  
> -	if (!(curr_dirs & (1 << bit)))
> -		outb(curr_dirs | (1 << bit), sch->iobase + offset);
> +	disable = inb(sch->iobase + offset);
> +	if (disable & BIT(bit))
> +		outb(disable & ~BIT(bit), sch->iobase + offset);
>  
>  	spin_unlock(&sch->lock);
> -	return 0;
>  }
>  
> -static int sch_gpio_get(struct gpio_chip *gc, unsigned gpio_num)
> +static int sch_gpio_reg_get(struct gpio_chip *gc, unsigned gpio, unsigned reg)
>  {
>  	struct sch_gpio *sch = to_sch_gpio(gc);
> -	int res;
>  	unsigned short offset, bit;
> +	u8 curr_dirs;
>  
> -	offset = sch_gpio_offset(sch, gpio_num, GLV);
> -	bit = sch_gpio_bit(sch, gpio_num);
> +	offset = sch_gpio_offset(sch, gpio, reg);
> +	bit = sch_gpio_bit(sch, gpio);
>  
> -	res = !!(inb(sch->iobase + offset) & (1 << bit));
> +	curr_dirs = !!(inb(sch->iobase + offset) & BIT(bit));
>  
> -	return res;
> +	return curr_dirs;
>  }
>  
> -static void sch_gpio_set(struct gpio_chip *gc, unsigned gpio_num, int val)
> +static void sch_gpio_reg_set(struct gpio_chip *gc, unsigned gpio, unsigned reg,
> +			     int val)
>  {
>  	struct sch_gpio *sch = to_sch_gpio(gc);
> -	u8 curr_vals;
>  	unsigned short offset, bit;
> +	u8 curr_dirs;
>  
> -	spin_lock(&sch->lock);
> -
> -	offset = sch_gpio_offset(sch, gpio_num, GLV);
> -	bit = sch_gpio_bit(sch, gpio_num);
> +	offset = sch_gpio_offset(sch, gpio, reg);
> +	bit = sch_gpio_bit(sch, gpio);
>  
> -	curr_vals = inb(sch->iobase + offset);
> +	curr_dirs = inb(sch->iobase + offset);
>  
>  	if (val)
> -		outb(curr_vals | (1 << bit), sch->iobase + offset);
> +		outb(curr_dirs | BIT(bit), sch->iobase + offset);
>  	else
> -		outb((curr_vals & ~(1 << bit)), sch->iobase + offset);
> +		outb((curr_dirs & ~BIT(bit)), sch->iobase + offset);
> +}
> +
> +static int sch_gpio_direction_in(struct gpio_chip *gc, unsigned gpio_num)
> +{
> +	struct sch_gpio *sch = to_sch_gpio(gc);
>  
> +	spin_lock(&sch->lock);
> +	sch_gpio_enable(sch, gpio_num, GIO);
>  	spin_unlock(&sch->lock);
> +	return 0;
>  }
>  
>  static int sch_gpio_direction_out(struct gpio_chip *gc, unsigned gpio_num,
>  				  int val)
>  {
>  	struct sch_gpio *sch = to_sch_gpio(gc);
> -	u8 curr_dirs;
> -	unsigned short offset, bit;
>  
>  	spin_lock(&sch->lock);
> -
> -	offset = sch_gpio_offset(sch, gpio_num, GIO);
> -	bit = sch_gpio_bit(sch, gpio_num);
> -
> -	curr_dirs = inb(sch->iobase + offset);
> -	if (curr_dirs & (1 << bit))
> -		outb(curr_dirs & ~(1 << bit), sch->iobase + offset);
> -
> +	sch_gpio_disable(sch, gpio_num, GIO);
>  	spin_unlock(&sch->lock);
>  
>  	/*
> @@ -166,6 +163,20 @@ static int sch_gpio_direction_out(struct gpio_chip *gc, unsigned gpio_num,
>  	return 0;
>  }
>  
> +static int sch_gpio_get(struct gpio_chip *gc, unsigned gpio_num)
> +{
> +	return sch_gpio_reg_get(gc, gpio_num, GLV);
> +}
> +
> +static void sch_gpio_set(struct gpio_chip *gc, unsigned gpio_num, int val)
> +{
> +	struct sch_gpio *sch = to_sch_gpio(gc);
> +
> +	spin_lock(&sch->lock);
> +	sch_gpio_reg_set(gc, gpio_num, GLV, val);
> +	spin_unlock(&sch->lock);
> +}
> +
>  static struct gpio_chip sch_gpio_chip = {
>  	.label			= "sch_gpio",
>  	.owner			= THIS_MODULE,
> @@ -209,13 +220,13 @@ static int sch_gpio_probe(struct platform_device *pdev)
>  		 * GPIO7 is configured by the CMC as SLPIOVR
>  		 * Enable GPIO[9:8] core powered gpios explicitly
>  		 */
> -		sch_gpio_enable(sch, 8);
> -		sch_gpio_enable(sch, 9);
> +		sch_gpio_enable(sch, 8, GEN);
> +		sch_gpio_enable(sch, 9, GEN);

For example here, which one is more readable?

>  		/*
>  		 * SUS_GPIO[2:0] enabled by default
>  		 * Enable SUS_GPIO3 resume powered gpio explicitly
>  		 */
> -		sch_gpio_enable(sch, 13);
> +		sch_gpio_enable(sch, 13, GEN);

Or here?

>  		break;
>  
>  	case PCI_DEVICE_ID_INTEL_ITC_LPC:
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
