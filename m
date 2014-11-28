Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751071AbaK1LFQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 06:05:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:52997 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbaK1LFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 06:05:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,476,1413270000"; 
   d="scan'208";a="644968474"
Date: Fri, 28 Nov 2014 13:05:08 +0200
From: Mika Westerberg <mika.westerberg@intel.com>
To: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GPIO Subsystem Mailing List <linux-gpio@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Denis Turischev <denis.turischev@compulab.co.il>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCHv4 3/3] gpio: sch: Enable IRQ support for Quark X1000
Message-ID: <20141128110508.GR1304@lahna.fi.intel.com>
References: <1416977280-27319-1-git-send-email-rebecca.swee.fun.chang@intel.com>
 <1416977280-27319-4-git-send-email-rebecca.swee.fun.chang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416977280-27319-4-git-send-email-rebecca.swee.fun.chang@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 12:48:00PM +0800, Chang Rebecca Swee Fun wrote:
> ntel Quark X1000 GPIO controller supports interrupt handling for

Typo it should say Intel.

> both core power well and resume power well. This patch is to enable
> the IRQ support and provide IRQ handling for Intel Quark X1000
> GPIO-SCH device driver.
> 
> This piece of work is derived from Dan O'Donovan's initial work for
> Quark X1000 enabling.
> 
> Signed-off-by: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
> ---
>  drivers/gpio/gpio-sch.c |  231 +++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 224 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-sch.c b/drivers/gpio/gpio-sch.c
> index 1a465bb..498746c 100644
> --- a/drivers/gpio/gpio-sch.c
> +++ b/drivers/gpio/gpio-sch.c
> @@ -28,17 +28,30 @@
>  #include <linux/pci_ids.h>
>  
>  #include <linux/gpio.h>
> +#include <linux/interrupt.h>
> +#include <linux/irq.h>
>  
>  #define GEN	0x00
>  #define GIO	0x04
>  #define GLV	0x08
> +#define GTPE	0x0C
> +#define GTNE	0x10
> +#define GGPE	0x14
> +#define GSMI	0x18
> +#define GTS	0x1C
> +#define CGNMIEN	0x40
> +#define RGNMIEN	0x44
>  
>  struct sch_gpio {
>  	struct gpio_chip chip;
> +	struct irq_data data;
>  	spinlock_t lock;
>  	unsigned short iobase;
>  	unsigned short core_base;
>  	unsigned short resume_base;
> +	int irq;
> +	int irq_base;
> +	bool irq_support;
>  };
>  
>  #define to_sch_gpio(c)	container_of(c, struct sch_gpio, chip)
> @@ -98,10 +111,11 @@ static void sch_gpio_reg_set(struct gpio_chip *gc, unsigned gpio, unsigned reg,
>  static int sch_gpio_direction_in(struct gpio_chip *gc, unsigned gpio_num)
>  {
>  	struct sch_gpio *sch = to_sch_gpio(gc);
> +	unsigned long flags;
>  
> -	spin_lock(&sch->lock);
> +	spin_lock_irqsave(&sch->lock, flags);
>  	sch_gpio_reg_set(sch, gpio_num, GIO, 1);
> -	spin_unlock(&sch->lock);
> +	spin_unlock_irqrestore(&sch->lock, flags);
>  	return 0;
>  }
>  
> @@ -113,20 +127,22 @@ static int sch_gpio_get(struct gpio_chip *gc, unsigned gpio_num)
>  static void sch_gpio_set(struct gpio_chip *gc, unsigned gpio_num, int val)
>  {
>  	struct sch_gpio *sch = to_sch_gpio(gc);
> +	unsigned long flags;
>  
> -	spin_lock(&sch->lock);
> +	spin_lock_irqsave(&sch->lock, flags);
>  	sch_gpio_reg_set(gc, gpio_num, GLV, val);
> -	spin_unlock(&sch->lock);
> +	spin_unlock_irqrestore(&sch->lock, flags);
>  }
>  
>  static int sch_gpio_direction_out(struct gpio_chip *gc, unsigned gpio_num,
>  				  int val)
>  {
>  	struct sch_gpio *sch = to_sch_gpio(gc);
> +	unsigned long flags;
>  
> -	spin_lock(&sch->lock);
> +	spin_lock_irqsave(&sch->lock, flags);
>  	sch_gpio_reg_set(sch, gpio_num, GIO, 0);
> -	spin_unlock(&sch->lock);
> +	spin_unlock_irqrestore(&sch->lock, flags);
>  
>  	/*
>  	 * according to the datasheet, writing to the level register has no
> @@ -141,6 +157,13 @@ static int sch_gpio_direction_out(struct gpio_chip *gc, unsigned gpio_num,
>  	return 0;
>  }
>  
> +static int sch_gpio_to_irq(struct gpio_chip *gc, unsigned offset)
> +{
> +	struct sch_gpio *sch = to_sch_gpio(gc);
> +
> +	return sch->irq_base + offset;
> +}
> +
>  static struct gpio_chip sch_gpio_chip = {
>  	.label			= "sch_gpio",
>  	.owner			= THIS_MODULE,
> @@ -148,12 +171,155 @@ static struct gpio_chip sch_gpio_chip = {
>  	.get			= sch_gpio_get,
>  	.direction_output	= sch_gpio_direction_out,
>  	.set			= sch_gpio_set,
> +	.to_irq			= sch_gpio_to_irq,
> +};
> +
> +static void sch_gpio_irq_enable(struct irq_data *d)
> +{
> +	struct sch_gpio *sch = container_of(d, struct sch_gpio, data);
> +	u32 gpio_num;
> +
> +	gpio_num = d->irq - sch->irq_base;
> +	sch_gpio_reg_set(sch, gpio_num, GGPE, 1);

Don't you need to take the lock here before calling sch_gpio_reg_set()?

> +}
> +
> +static void sch_gpio_irq_disable(struct irq_data *d)
> +{
> +	struct sch_gpio *sch = container_of(d, struct sch_gpio, data);
> +	u32 gpio_num;
> +
> +	gpio_num = d->irq - sch->irq_base;
> +	sch_gpio_reg_set(sch, gpio_num, GGPE, 0);

Ditto

> +}
> +
> +static void sch_gpio_irq_ack(struct irq_data *d)
> +{
> +	struct sch_gpio *sch = container_of(d, struct sch_gpio, data);
> +	u32 gpio_num;
> +
> +	gpio_num = d->irq - sch->irq_base;
> +	sch_gpio_reg_set(&(sch->chip), gpio_num, GTS, 1);

Ditto

> +}
> +
> +static int sch_gpio_irq_type(struct irq_data *d, unsigned type)
> +{
> +	struct sch_gpio *sch = container_of(d, struct sch_gpio, data);
> +	unsigned long flags;
> +	u32 gpio_num;
> +
> +	gpio_num = d->irq - sch->irq_base;
> +
> +	spin_lock_irqsave(&sch->lock, flags);
> +
> +	switch (type) {
> +	case IRQ_TYPE_EDGE_RISING:
> +		sch_gpio_reg_set(sch, gpio_num, GTPE, 1);
> +		sch_gpio_reg_set(sch, gpio_num, GTNE, 0);
> +		break;
> +
> +	case IRQ_TYPE_EDGE_FALLING:
> +		sch_gpio_reg_set(sch, gpio_num, GTNE, 1);
> +		sch_gpio_reg_set(sch, gpio_num, GTPE, 0);
> +		break;
> +
> +	case IRQ_TYPE_EDGE_BOTH:
> +		sch_gpio_reg_set(sch, gpio_num, GTPE, 1);
> +		sch_gpio_reg_set(sch, gpio_num, GTNE, 1);
> +		break;
> +
> +	case IRQ_TYPE_NONE:
> +		sch_gpio_reg_set(sch, gpio_num, GTPE, 0);
> +		sch_gpio_reg_set(sch, gpio_num, GTNE, 0);
> +		break;
> +
> +	default:
> +		spin_unlock_irqrestore(&sch->lock, flags);
> +		return -EINVAL;
> +	}
> +
> +	spin_unlock_irqrestore(&sch->lock, flags);
> +
> +	return 0;
> +}
> +
> +static struct irq_chip sch_irq_chip = {
> +	.irq_enable	= sch_gpio_irq_enable,
> +	.irq_disable	= sch_gpio_irq_disable,
> +	.irq_ack	= sch_gpio_irq_ack,
> +	.irq_set_type	= sch_gpio_irq_type,
>  };
>  
> +static void sch_gpio_irqs_init(struct sch_gpio *sch, unsigned int num)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < num; i++) {
> +		irq_set_chip_data(i + sch->irq_base, sch);
> +		irq_set_chip_and_handler_name(i + sch->irq_base, &sch_irq_chip,
> +					handle_simple_irq, "sch_gpio_irq_chip");
> +	}
> +}
> +
> +static void sch_gpio_irqs_deinit(struct sch_gpio *sch, unsigned int num)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < num; i++) {
> +		irq_set_chip_data(i + sch->irq_base, 0);
> +		irq_set_chip_and_handler_name(i + sch->irq_base, 0, 0, 0);
> +	}
> +}
> +
> +static void sch_gpio_irq_disable_all(struct sch_gpio *sch, unsigned int num)
> +{
> +	unsigned long flags;
> +	unsigned int gpio_num;
> +
> +	spin_lock_irqsave(&sch->lock, flags);
> +
> +	for (gpio_num = 0; gpio_num < num; gpio_num++) {
> +		sch_gpio_reg_set(sch, gpio_num, GTPE, 0);
> +		sch_gpio_reg_set(sch, gpio_num, GTNE, 0);
> +		sch_gpio_reg_set(sch, gpio_num, GGPE, 0);
> +		sch_gpio_reg_set(sch, gpio_num, GSMI, 0);
> +
> +		if (gpio_num >= 2)
> +			sch_gpio_reg_set(sch, gpio_num, RGNMIEN, 0);
> +		else
> +			sch_gpio_reg_set(sch, gpio_num, CGNMIEN, 0);
> +
> +		/* clear any pending interrupts */
> +		sch_gpio_reg_set(&sch->chip, gpio_num, GTS, 1);
> +	}
> +
> +	spin_unlock_irqrestore(&sch->lock, flags);
> +}
> +
> +static irqreturn_t sch_gpio_irq_handler(int irq, void *dev_id)
> +{
> +	struct sch_gpio *sch = dev_id;
> +	int res;
> +	unsigned int i;
> +	int ret = IRQ_NONE;
> +
> +	for (i = 0; i < sch->chip.ngpio; i++) {
> +		res = sch_gpio_reg_get(&sch->chip, i, GTS);
> +		if (res) {
> +			/* clear by setting GTS to 1 */
> +			sch_gpio_reg_set(&sch->chip, i, GTS, 1);
> +			generic_handle_irq(sch->irq_base + i);
> +			ret = IRQ_HANDLED;
> +		}
> +	}
> +
> +	return ret;
> +}
> +
>  static int sch_gpio_probe(struct platform_device *pdev)
>  {
>  	struct sch_gpio *sch;
>  	struct resource *res;
> +	int err;
>  
>  	sch = devm_kzalloc(&pdev->dev, sizeof(*sch), GFP_KERNEL);
>  	if (!sch)
> @@ -167,6 +333,15 @@ static int sch_gpio_probe(struct platform_device *pdev)
>  				 pdev->name))
>  		return -EBUSY;
>  
> +	sch->irq = platform_get_irq(pdev, 0);
> +	if (sch->irq >= 0) {
> +		sch->irq_support = true;
> +	} else {
> +		dev_warn(&pdev->dev,
> +			 "failed to obtain irq number for device\n");

Why dev_warn()?

If I use this driver on Minnowboard which does not support interrupts,
this kind of warning makes me think that there is something wrong even
if it is actually OK.

> +		sch->irq_support = false;
> +	}
> +
>  	spin_lock_init(&sch->lock);
>  	sch->iobase = res->start;
>  	sch->chip = sch_gpio_chip;
> @@ -215,15 +390,57 @@ static int sch_gpio_probe(struct platform_device *pdev)
>  		return -ENODEV;
>  	}
>  
> +	gpiochip_add(&sch->chip);
> +
> +	if (sch->irq_support) {
> +		sch->irq_base = irq_alloc_descs(-1, 0, sch->chip.ngpio,
> +						NUMA_NO_NODE);
> +		if (sch->irq_base < 0) {
> +			dev_err(&pdev->dev,
> +				"failed to allocate GPIO IRQ descs\n");
> +			goto err_sch_intr_chip;
> +		}
> +
> +		/* disable interrupts */
> +		sch_gpio_irq_disable_all(sch, sch->chip.ngpio);
> +
> +		err = request_irq(sch->irq, sch_gpio_irq_handler, IRQF_SHARED,
> +				  KBUILD_MODNAME, sch);
> +		if (err) {
> +			dev_err(&pdev->dev,
> +				"%s failed to request IRQ\n", __func__);
> +			goto err_sch_request_irq;
> +		}
> +
> +		sch_gpio_irqs_init(sch, sch->chip.ngpio);
> +	}
> +
>  	platform_set_drvdata(pdev, sch);
>  
> -	return gpiochip_add(&sch->chip);
> +	return 0;
> +
> +err_sch_request_irq:
> +	irq_free_descs(sch->irq_base, sch->chip.ngpio);
> +
> +err_sch_intr_chip:
> +	gpiochip_remove(&sch->chip);
> +
> +	return err;
>  }
>  
>  static int sch_gpio_remove(struct platform_device *pdev)
>  {
>  	struct sch_gpio *sch = platform_get_drvdata(pdev);
>  
> +	if (sch->irq_support) {
> +		sch_gpio_irqs_deinit(sch, sch->chip.ngpio);
> +
> +		if (sch->irq >= 0)
> +			free_irq(sch->irq, sch);
> +
> +		irq_free_descs(sch->irq_base, sch->chip.ngpio);
> +	}
> +
>  	gpiochip_remove(&sch->chip);
>  	return 0;
>  }
> -- 
> 1.7.9.5
