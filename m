Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897AbaIRLb2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 07:31:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:14629 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756307AbaIRLb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 07:31:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,546,1406617200"; 
   d="scan'208";a="601552653"
Date: Thu, 18 Sep 2014 14:31:22 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] gpio: sch: Enable IRQ support for Quark X1000
Message-ID: <20140918113122.GO10854@lahna.fi.intel.com>
References: <1410943745-9354-1-git-send-email-rebecca.swee.fun.chang@intel.com>
 <1410943745-9354-4-git-send-email-rebecca.swee.fun.chang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410943745-9354-4-git-send-email-rebecca.swee.fun.chang@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 04:49:05PM +0800, Chang Rebecca Swee Fun wrote:
> Intel Quark X1000 GPIO controller supports interrupt handling for
> both core power well and resume power well. This patch is to enable
> the IRQ support and provide IRQ handling for Intel Quark X1000
> GPIO-SCH device driver.
> 
> This piece of work is derived from Dan O'Donovan's initial work for
> Quark X1000 enabling.
> 
> Signed-off-by: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
> ---
>  drivers/gpio/gpio-sch.c |  267 ++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 253 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-sch.c b/drivers/gpio/gpio-sch.c
> index 38d6e74..c6c64a5 100644
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
> +	int irq_base;
> +	int irq_num;
> +	int irq_support;
>  };
>  
>  #define to_sch_gpio(c)	container_of(c, struct sch_gpio, chip)
> @@ -67,10 +80,11 @@ static unsigned sch_gpio_bit(struct sch_gpio *sch, unsigned gpio)
>  
>  static void sch_gpio_enable(struct sch_gpio *sch, unsigned gpio, unsigned reg)
>  {
> +	unsigned long flags;
>  	unsigned short offset, bit;
>  	u8 enable;
>  
> -	spin_lock(&sch->lock);
> +	spin_lock_irqsave(&sch->lock, flags);
>  
>  	offset = sch_gpio_offset(sch, gpio, reg);
>  	bit = sch_gpio_bit(sch, gpio);
> @@ -79,15 +93,16 @@ static void sch_gpio_enable(struct sch_gpio *sch, unsigned gpio, unsigned reg)
>  	if (!(enable & BIT(bit)))
>  		outb(enable | BIT(bit), sch->iobase + offset);
>  
> -	spin_unlock(&sch->lock);
> +	spin_unlock_irqrestore(&sch->lock, flags);
>  }
>  
>  static void sch_gpio_disable(struct sch_gpio *sch, unsigned gpio, unsigned reg)
>  {
> +	unsigned long flags;
>  	unsigned short offset, bit;
>  	u8 disable;
>  
> -	spin_lock(&sch->lock);
> +	spin_lock_irqsave(&sch->lock, flags);
>  
>  	offset = sch_gpio_offset(sch, gpio, reg);
>  	bit = sch_gpio_bit(sch, gpio);
> @@ -96,7 +111,7 @@ static void sch_gpio_disable(struct sch_gpio *sch, unsigned gpio, unsigned reg)
>  	if (disable & BIT(bit))
>  		outb(disable & ~BIT(bit), sch->iobase + offset);
>  
> -	spin_unlock(&sch->lock);
> +	spin_unlock_irqrestore(&sch->lock, flags);
>  }
>  
>  static int sch_gpio_reg_get(struct gpio_chip *gc, unsigned gpio, unsigned reg)
> @@ -134,10 +149,11 @@ static void sch_gpio_reg_set(struct gpio_chip *gc, unsigned gpio, unsigned reg,
>  static int sch_gpio_direction_in(struct gpio_chip *gc, unsigned gpio_num)
>  {
>  	struct sch_gpio *sch = to_sch_gpio(gc);
> +	unsigned long flags;
>  
> -	spin_lock(&sch->lock);
> +	spin_lock_irqsave(&sch->lock, flags);
>  	sch_gpio_enable(sch, gpio_num, GIO);
> -	spin_unlock(&sch->lock);
> +	spin_unlock_irqrestore(&sch->lock, flags);
>  	return 0;
>  }
>  
> @@ -145,10 +161,11 @@ static int sch_gpio_direction_out(struct gpio_chip *gc, unsigned gpio_num,
>  				  int val)
>  {
>  	struct sch_gpio *sch = to_sch_gpio(gc);
> +	unsigned long flags;
>  
> -	spin_lock(&sch->lock);
> +	spin_lock_irqsave(&sch->lock, flags);
>  	sch_gpio_disable(sch, gpio_num, GIO);
> -	spin_unlock(&sch->lock);
> +	spin_unlock_irqrestore(&sch->lock, flags);
>  
>  	/*
>  	 * according to the datasheet, writing to the level register has no
> @@ -171,10 +188,18 @@ static int sch_gpio_get(struct gpio_chip *gc, unsigned gpio_num)
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
> +}
> +
> +static int sch_gpio_to_irq(struct gpio_chip *gc, unsigned offset)
> +{
> +	struct sch_gpio *sch = to_sch_gpio(gc);
> +
> +	return sch->irq_base + offset;
>  }
>  
>  static struct gpio_chip sch_gpio_chip = {
> @@ -184,12 +209,160 @@ static struct gpio_chip sch_gpio_chip = {
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
> +	sch_gpio_enable(sch, gpio_num, GGPE);
> +}
> +
> +static void sch_gpio_irq_disable(struct irq_data *d)
> +{
> +	struct sch_gpio *sch = container_of(d, struct sch_gpio, data);
> +	u32 gpio_num;
> +
> +	gpio_num = d->irq - sch->irq_base;
> +	sch_gpio_disable(sch, gpio_num, GGPE);
> +}
> +
> +static void sch_gpio_irq_ack(struct irq_data *d)
> +{
> +	struct sch_gpio *sch = container_of(d, struct sch_gpio, data);
> +	u32 gpio_num;
> +
> +	gpio_num = d->irq - sch->irq_base;
> +	sch_gpio_reg_set(&(sch->chip), gpio_num, GTS, 1);
> +}
> +
> +static int sch_gpio_irq_type(struct irq_data *d, unsigned type)
> +{
> +	struct sch_gpio *sch = container_of(d, struct sch_gpio, data);
> +	unsigned long flags;
> +	u32 gpio_num;
> +
> +	if (d == NULL)
> +		return -EINVAL;
> +
> +	gpio_num = d->irq - sch->irq_base;
> +
> +	spin_lock_irqsave(&sch->lock, flags);
> +
> +	switch (type) {
> +	case IRQ_TYPE_EDGE_RISING:
> +		sch_gpio_enable(sch, gpio_num, GTPE);
> +		sch_gpio_disable(sch, gpio_num, GTNE);
> +		break;
> +
> +	case IRQ_TYPE_EDGE_FALLING:
> +		sch_gpio_enable(sch, gpio_num, GTNE);
> +		sch_gpio_disable(sch, gpio_num, GTPE);
> +		break;
> +
> +	case IRQ_TYPE_EDGE_BOTH:
> +		sch_gpio_enable(sch, gpio_num, GTPE);
> +		sch_gpio_enable(sch, gpio_num, GTNE);
> +		break;
> +
> +	case IRQ_TYPE_NONE:
> +		sch_gpio_disable(sch, gpio_num, GTPE);
> +		sch_gpio_disable(sch, gpio_num, GTNE);
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
> +		irq_set_chip_and_handler_name(i + sch->irq_base,
> +					      &sch_irq_chip,
> +					      handle_simple_irq,
> +					      "sch_gpio_irq_chip");
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
> +		sch_gpio_disable(sch, gpio_num, GTPE);
> +		sch_gpio_disable(sch, gpio_num, GTNE);
> +		sch_gpio_disable(sch, gpio_num, GGPE);
> +		sch_gpio_disable(sch, gpio_num, GSMI);
> +
> +		if (gpio_num >= 2)
> +			sch_gpio_disable(sch, gpio_num, RGNMIEN);
> +		else
> +			sch_gpio_disable(sch, gpio_num, CGNMIEN);
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
> -	struct resource *res;
> +	struct resource *res, *irq;
> +	int err;
>  
>  	sch = devm_kzalloc(&pdev->dev, sizeof(*sch), GFP_KERNEL);
>  	if (!sch)
> @@ -203,6 +376,17 @@ static int sch_gpio_probe(struct platform_device *pdev)
>  				 pdev->name))
>  		return -EBUSY;
>  
> +	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> +	sch->irq_support = !!irq;
> +	if (sch->irq_support) {
> +		sch->irq_num = irq->start;
> +		if (sch->irq_num < 0) {
> +			dev_warn(&pdev->dev,
> +				 "failed to obtain irq number for device\n");
> +			sch->irq_support = 0;
> +		}
> +	}
> +
>  	spin_lock_init(&sch->lock);
>  	sch->iobase = res->start;
>  	sch->chip = sch_gpio_chip;
> @@ -251,17 +435,72 @@ static int sch_gpio_probe(struct platform_device *pdev)
>  		return -ENODEV;
>  	}
>  
> +	err = gpiochip_add(&sch->chip);
> +	if (err < 0)
> +		goto err_sch_gpio;
> +
> +	if (sch->irq_support) {
> +		sch->irq_base = irq_alloc_descs(-1, 0, sch->chip.ngpio,
> +						NUMA_NO_NODE);
> +		if (sch->irq_base < 0) {
> +			dev_err(&pdev->dev,
> +				"failed to add GPIO IRQ descs\n");
> +			sch->irq_base = -1;
> +			goto err_sch_intr_chip;
> +		}

Was there some reason why you can't use gpiochip_irqchip_* helpers here?

> +
> +		/* disable interrupts */
> +		sch_gpio_irq_disable_all(sch, sch->chip.ngpio);
> +
> +		err = request_irq(sch->irq_num, sch_gpio_irq_handler,
> +				  IRQF_SHARED, KBUILD_MODNAME, sch);

This seems weird, typically irqchip drivers don't call request_irq()
directly but instead irq_set_chained_handler() or similar. With
gpiochip_irqchip_* stuff you don't need even that.

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
> +	if (gpiochip_remove(&sch->chip))
> +		dev_err(&pdev->dev,
> +			"%s gpiochip_remove() failed\n", __func__);
> +
> +err_sch_gpio:
> +	release_region(res->start, resource_size(res));
> +
> +	return err;
>  }
>  
>  static int sch_gpio_remove(struct platform_device *pdev)
>  {
>  	struct sch_gpio *sch = platform_get_drvdata(pdev);
> +	int err;
>  
> -	gpiochip_remove(&sch->chip);
> -	return 0;
> +	if (sch->irq_support) {
> +		sch_gpio_irqs_deinit(sch, sch->chip.ngpio);
> +
> +		if (sch->irq_num >= 0)
> +			free_irq(sch->irq_num, sch);
> +
> +		irq_free_descs(sch->irq_base, sch->chip.ngpio);
> +	}
> +
> +	err = gpiochip_remove(&sch->chip);
> +	if (err)
> +		dev_err(&pdev->dev,
> +			"%s gpiochip_remove() failed\n", __func__);
> +
> +	return err;
>  }
>  
>  static struct platform_driver sch_gpio_driver = {
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
