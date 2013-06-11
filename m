Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab3FKL4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 07:56:47 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34067 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753802Ab3FKL4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 07:56:46 -0400
Message-ID: <51B71056.9010103@ti.com>
Date: Tue, 11 Jun 2013 17:26:06 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Philip Avinash <avinashphilip@ti.com>
CC: <khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
        <grant.likely@secretlab.ca>, <linus.walleij@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/11] gpio: davinci: Modify to platform driver
References: <1369206634-6778-1-git-send-email-avinashphilip@ti.com> <1369206634-6778-4-git-send-email-avinashphilip@ti.com>
In-Reply-To: <1369206634-6778-4-git-send-email-avinashphilip@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 5/22/2013 12:40 PM, Philip Avinash wrote:
> From: KV Sujith <sujithkv@ti.com>
> 
> Modify GPIO Davinci driver to be compliant to standard platform drivers.
> The driver did not have platform driver structure or a probe. Instead,
> had a davinci_gpio_setup() function which is called in the pure_init
> sequence. The function also had dependency on davinci_soc_info structure
> of the corresponding platform. For Device Tree(DT) implementation, we
> need to get rid of the dependency on the davinci_soc_info structure.
> Hence as a first stage of DT conversion, we implement a probe. Future
> commits shall modify the probe to read platform related data from DT.
> 
> - Add platform_driver structure and driver register function for davinci
>   GPIO driver. The driver registration is made to happen in
>   postcore_initcall. This is required since machine init functions like
>   da850_lcd_hw_init() make use of GPIO.
> - Convert the davinci_gpio_setup() to davinci_gpio_probe().
> - Remove access of members in soc_info structure. Instead, relevant data
>   are taken from davinci_gpio_platform_data structure pointed by
>   pdev->dev.platform_data.
> - Change clk_get() to devm_clk_get() as devm_clk_get() is a device
>   managed function and makes error handling simpler.
> - Change pr_err to dev_err for ngpio error reporting.
> - Arrange include files and variables in alphabetical order
> 
> Signed-off-by: KV Sujith <sujithkv@ti.com>
> [avinashphilip@ti.com: Move global definition for "struct
> davinci_gpio_controller" variable to local in probe and set it as driver
> data.]
> Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> ---
>  arch/arm/mach-davinci/include/mach/gpio-davinci.h |    2 +
>  drivers/gpio/gpio-davinci.c                       |  121 +++++++++++++++------
>  2 files changed, 87 insertions(+), 36 deletions(-)
> 
> diff --git a/arch/arm/mach-davinci/include/mach/gpio-davinci.h b/arch/arm/mach-davinci/include/mach/gpio-davinci.h
> index 1fdd1fd..b325a1d 100644
> --- a/arch/arm/mach-davinci/include/mach/gpio-davinci.h
> +++ b/arch/arm/mach-davinci/include/mach/gpio-davinci.h
> @@ -60,6 +60,8 @@ struct davinci_gpio_controller {
>  	void __iomem		*set_data;
>  	void __iomem		*clr_data;
>  	void __iomem		*in_data;
> +	int			gpio_unbanked;
> +	unsigned		gpio_irq;
>  };
>  
>  /* The __gpio_to_controller() and __gpio_mask() functions inline to constants
> diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
> index d308955..08830aa 100644
> --- a/drivers/gpio/gpio-davinci.c
> +++ b/drivers/gpio/gpio-davinci.c
> @@ -11,10 +11,17 @@
>   */
>  
>  #include <linux/clk.h>
> +#include <linux/device.h>
>  #include <linux/errno.h>
>  #include <linux/gpio.h>
>  #include <linux/io.h>
> +#include <linux/interrupt.h>
> +#include <linux/irqdomain.h>
>  #include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/platform_data/gpio-davinci.h>

> +#include <mach/gpio-davinci.h>

This include seems unnecessary.

>  
>  #include <asm/mach/irq.h>

While at it, you can get rid of this include and use <linux/irq.h> instead?

>  
> @@ -35,10 +42,9 @@ struct davinci_gpio_regs {
>  #define chip2controller(chip)	\
>  	container_of(chip, struct davinci_gpio_controller, chip)
>  
> -static struct davinci_gpio_controller ctlrs[DIV_ROUND_UP(DAVINCI_N_GPIO, 32)];
>  static void __iomem *gpio_base;
>  
> -static struct davinci_gpio_regs __iomem __init *gpio2regs(unsigned gpio)
> +static struct davinci_gpio_regs __iomem *gpio2regs(unsigned gpio)
>  {
>  	void __iomem *ptr;
>  
> @@ -64,7 +70,7 @@ static inline struct davinci_gpio_regs __iomem *irq2regs(int irq)
>  		irq_get_chip_data(irq);
>  }
>  
> -static int __init davinci_gpio_irq_setup(void);
> +static int davinci_gpio_irq_setup(struct platform_device *pdev);
>  
>  static inline int __davinci_direction(struct gpio_chip *chip,
>  			unsigned offset, bool out, int value)
> @@ -127,33 +133,52 @@ static void davinci_gpio_set(struct gpio_chip *chip, unsigned offset,
>  	__raw_writel((1 << offset), value ? &regs->set_data : &regs->clr_data);
>  }
>  
> -static int __init davinci_gpio_setup(void)
> +static int davinci_gpio_probe(struct platform_device *pdev)
>  {
>  	int i, base;
>  	unsigned ngpio;
> -	struct davinci_soc_info *soc_info = &davinci_soc_info;
> +	struct davinci_gpio_controller *ctlrs;
> +	struct davinci_gpio_platform_data *pdata;
>  	struct davinci_gpio_regs *regs;
> +	struct device *dev = &pdev->dev;
> +	struct resource *res;
>  
> -	if (soc_info->gpio_type != GPIO_TYPE_DAVINCI)
> -		return 0;
> +	pdata = dev->platform_data;
> +	if (!pdata) {
> +		dev_err(dev, "GPIO: No Platform Data Supplied\n");

dev_err should already tell that the error is coming from davinci-gpio
so no need to prefix GPIO: again.

> +		return -EINVAL;
> +	}
>  
>  	/*
>  	 * The gpio banks conceptually expose a segmented bitmap,
>  	 * and "ngpio" is one more than the largest zero-based
>  	 * bit index that's valid.
>  	 */
> -	ngpio = soc_info->gpio_num;
> +	ngpio = pdata->ngpio;
>  	if (ngpio == 0) {
> -		pr_err("GPIO setup:  how many GPIOs?\n");
> +		dev_err(dev, "GPIO Probe: how many GPIOs?\n");
>  		return -EINVAL;
>  	}
>  
>  	if (WARN_ON(DAVINCI_N_GPIO < ngpio))
>  		ngpio = DAVINCI_N_GPIO;
>  
> -	gpio_base = ioremap(soc_info->gpio_base, SZ_4K);
> -	if (WARN_ON(!gpio_base))
> +	ctlrs = devm_kzalloc(dev,
> +		ngpio * sizeof(struct davinci_gpio_controller), GFP_KERNEL);

Line break alignment needs fixing.

> +	if (!ctlrs) {
> +		dev_err(dev, "Memory alloc failed\n");
>  		return -ENOMEM;
> +	}
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (unlikely(!res)) {
> +		dev_err(dev, "Invalid mem resource\n");
> +		return -ENODEV;

-EBUSY is better if you cannot get the resource.

> +	}
> +
> +	gpio_base = devm_ioremap_resource(dev, res);
> +	if (!gpio_base)
> +		return -EADDRNOTAVAIL;

devm_ioremap_resource gives an error encoder pointer if it fails so
please use that instead of masking it.

>  
>  	for (i = 0, base = 0; base < ngpio; i++, base += 32) {
>  		ctlrs[i].chip.label = "DaVinci";
> @@ -179,13 +204,10 @@ static int __init davinci_gpio_setup(void)
>  		gpiochip_add(&ctlrs[i].chip);
>  	}
>  
> -	soc_info->gpio_ctlrs = ctlrs;

> -	soc_info->gpio_ctlrs_num = DIV_ROUND_UP(ngpio, 32);

You drop setting gpio_ctlrs_num here and don't introduce it anywhere
else in the patchset so in effect you render the inline gpio get/set API
useless. Looks like this initialization should be moved to platform code?

> -
> -	davinci_gpio_irq_setup();
> +	platform_set_drvdata(pdev, ctlrs);
> +	davinci_gpio_irq_setup(pdev);
>  	return 0;
>  }
> -pure_initcall(davinci_gpio_setup);
>  
>  /*
>   * We expect irqs will normally be set up as input pins, but they can also be
> @@ -297,14 +319,14 @@ static int gpio_to_irq_banked(struct gpio_chip *chip, unsigned offset)
>  
>  static int gpio_to_irq_unbanked(struct gpio_chip *chip, unsigned offset)
>  {
> -	struct davinci_soc_info *soc_info = &davinci_soc_info;
> +	struct davinci_gpio_controller *ctlr = chip2controller(chip);
>  
>  	/*
>  	 * NOTE:  we assume for now that only irqs in the first gpio_chip
>  	 * can provide direct-mapped IRQs to AINTC (up to 32 GPIOs).
>  	 */
> -	if (offset < soc_info->gpio_unbanked)
> -		return soc_info->gpio_irq + offset;
> +	if (offset < ctlr->irq_base)
> +		return ctlr->gpio_irq + offset;
>  	else
>  		return -ENODEV;
>  }
> @@ -313,12 +335,11 @@ static int gpio_irq_type_unbanked(struct irq_data *data, unsigned trigger)
>  {
>  	struct davinci_gpio_controller *ctlr;
>  	struct davinci_gpio_regs __iomem *regs;
> -	struct davinci_soc_info *soc_info = &davinci_soc_info;
>  	u32 mask;
>  
>  	ctlr = (struct davinci_gpio_controller *)data->handler_data;
>  	regs = (struct davinci_gpio_regs __iomem *)ctlr->regs;
> -	mask = __gpio_mask(data->irq - soc_info->gpio_irq);
> +	mask = __gpio_mask(data->irq - ctlr->gpio_irq);
>  
>  	if (trigger & ~(IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING))
>  		return -EINVAL;
> @@ -339,23 +360,33 @@ static int gpio_irq_type_unbanked(struct irq_data *data, unsigned trigger)
>   * (dm6446) can be set appropriately for GPIOV33 pins.
>   */
>  
> -static int __init davinci_gpio_irq_setup(void)
> +static int davinci_gpio_irq_setup(struct platform_device *pdev)
>  {
> -	u32		binten = 0;
> -	unsigned	gpio, irq, bank, ngpio, bank_irq;
> -	struct clk	*clk;
> +	u32 binten = 0;
> +	unsigned gpio, irq, bank, ngpio, bank_irq;
> +	struct clk *clk;
> +	struct davinci_gpio_controller *ctlrs = platform_get_drvdata(pdev);
> +	struct davinci_gpio_platform_data *pdata;
>  	struct davinci_gpio_regs __iomem *regs;
> -	struct davinci_soc_info *soc_info = &davinci_soc_info;
> +	struct device *dev = &pdev->dev;
> +	struct resource *res;
> +
> +	pdata = dev->platform_data;
> +	ngpio = pdata->ngpio;
> +	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> +	if (unlikely(!res)) {
> +		dev_err(dev, "Invalid IRQ resource\n");
> +		return -ENODEV;

-EBUSY again?

Thanks,
Sekhar
