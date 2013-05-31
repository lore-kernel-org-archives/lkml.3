Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657Ab3EaMnP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:43:15 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:65099 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756573Ab3EaMnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:43:01 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCHv2 3/3] gpio: msm: Add device tree and irqdomain support for gpio-msm-v2
To: Rohit Vaswani <rvaswani@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Rohit Vaswani <rvaswani@codeaurora.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
In-Reply-To: <1369268964-28304-4-git-send-email-rvaswani@codeaurora.org>
References: <1369268964-28304-1-git-send-email-rvaswani@codeaurora.org> <1369268964-28304-4-git-send-email-rvaswani@codeaurora.org>
Date: Fri, 31 May 2013 13:42:56 +0100
Message-Id: <20130531124256.D269C3E0901@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 May 2013 17:29:24 -0700, Rohit Vaswani <rvaswani@codeaurora.org> wrote:
> This cleans up the gpio-msm-v2 driver of all the global define usage.
> The number of gpios are now defined in the device tree. This enables
> adding irqdomain support as well.
> 
> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>

Hi Rohit,

Comments below on this driver...

> ---
>  .../devicetree/bindings/gpio/gpio-msm.txt          |   26 +++
>  arch/arm/boot/dts/msm8660-surf.dts                 |   11 ++
>  arch/arm/boot/dts/msm8960-cdp.dts                  |   11 ++
>  drivers/gpio/Kconfig                               |    2 +-
>  drivers/gpio/gpio-msm-v2.c                         |  168 +++++++++++++-------
>  5 files changed, 157 insertions(+), 61 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/gpio/gpio-msm.txt
> 
> diff --git a/Documentation/devicetree/bindings/gpio/gpio-msm.txt b/Documentation/devicetree/bindings/gpio/gpio-msm.txt
> new file mode 100644
> index 0000000..ac20e68
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/gpio/gpio-msm.txt
> @@ -0,0 +1,26 @@
> +MSM GPIO controller bindings
> +
> +Required properties:
> +- compatible:
> +  - "qcom,msm-gpio" for MSM controllers
> +- #gpio-cells : Should be two.
> +  - first cell is the pin number
> +  - second cell is used to specify optional parameters (unused)
> +- gpio-controller : Marks the device node as a GPIO controller.
> +- #interrupt-cells : Should be 2.
> +- interrupt-controller: Mark the device node as an interrupt controller
> +- interrupts : Specify the TLMM summary interrupt number
> +- ngpio : Specify the number of MSM GPIOs
> +
> +Example:
> +
> +	msmgpio: gpio@fd510000 {
> +		compatible = "qcom,msm-gpio";
> +		gpio-controller;
> +		#gpio-cells = <2>;
> +		interrupt-controller;
> +		#interrupt-cells = <2>;
> +		reg = <0xfd510000 0x4000>;
> +		interrupts = <0 208 0>;
> +		ngpio = <150>;
> +	};
> diff --git a/arch/arm/boot/dts/msm8660-surf.dts b/arch/arm/boot/dts/msm8660-surf.dts
> index 9bf49b3..8931906 100644
> --- a/arch/arm/boot/dts/msm8660-surf.dts
> +++ b/arch/arm/boot/dts/msm8660-surf.dts
> @@ -26,6 +26,17 @@
>  		cpu-offset = <0x40000>;
>  	};
>  
> +	msmgpio: gpio@800000 {
> +		compatible = "qcom,msm-gpio";
> +		reg = <0x00800000 0x1000>;
> +		gpio-controller;
> +		#gpio-cells = <2>;
> +		ngpio = <173>;
> +		interrupts = <0 32 0x4>;
> +		interrupt-controller;
> +		#interrupt-cells = <2>;
> +	};
> +
>  	serial@19c400000 {
>  		compatible = "qcom,msm-hsuart", "qcom,msm-uart";
>  		reg = <0x19c40000 0x1000>,
> diff --git a/arch/arm/boot/dts/msm8960-cdp.dts b/arch/arm/boot/dts/msm8960-cdp.dts
> index 2e4d87a..52fe253 100644
> --- a/arch/arm/boot/dts/msm8960-cdp.dts
> +++ b/arch/arm/boot/dts/msm8960-cdp.dts
> @@ -26,6 +26,17 @@
>  		cpu-offset = <0x80000>;
>  	};
>  
> +	msmgpio: gpio@fd510000 {
> +		compatible = "qcom,msm-gpio";
> +		gpio-controller;
> +		#gpio-cells = <2>;
> +		ngpio = <150>;
> +		interrupts = <0 32 0x4>;
> +		interrupt-controller;
> +		#interrupt-cells = <2>;
> +		reg = <0xfd510000 0x4000>;
> +	};
> +
>  	serial@19c400000 {
>  		compatible = "qcom,msm-hsuart", "qcom,msm-uart";
>  		reg = <0x16440000 0x1000>,
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index 87d5670..9ef3b04 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -165,7 +165,7 @@ config GPIO_MSM_V1
>  
>  config GPIO_MSM_V2
>  	tristate "Qualcomm MSM GPIO v2"
> -	depends on GPIOLIB && ARCH_MSM
> +	depends on GPIOLIB && OF
>  	help
>  	  Say yes here to support the GPIO interface on ARM v7 based
>  	  Qualcomm MSM chips.  Most of the pins on the MSM can be
> diff --git a/drivers/gpio/gpio-msm-v2.c b/drivers/gpio/gpio-msm-v2.c
> index 75cc821..025c11a 100644
> --- a/drivers/gpio/gpio-msm-v2.c
> +++ b/drivers/gpio/gpio-msm-v2.c
> @@ -19,17 +19,22 @@
>  
>  #include <linux/bitmap.h>
>  #include <linux/bitops.h>
> +#include <linux/err.h>
>  #include <linux/gpio.h>
>  #include <linux/init.h>
>  #include <linux/interrupt.h>
>  #include <linux/io.h>
>  #include <linux/irqchip/chained_irq.h>
>  #include <linux/irq.h>
> +#include <linux/irqdomain.h>
>  #include <linux/module.h>
> +#include <linux/of_address.h>
>  #include <linux/platform_device.h>
>  #include <linux/spinlock.h>
> +#include <linux/slab.h>
>  
> -#include <mach/msm_iomap.h>
> +static int summary_irq;
> +void __iomem *msm_tlmm_base;

Making this a global means there can only be one instance of this chip
in a system. That may not be a concern for you, but I generally
recommend to driver authors not to use any global variables if possible.
Instead, things like base address should be stored in the msm_gpio_dev
structure.

>  
>  /* Bits of interest in the GPIO_IN_OUT register.
>   */
> @@ -77,11 +82,11 @@ enum {
>  };
>  
>  
> -#define GPIO_INTR_CFG_SU(gpio)    (MSM_TLMM_BASE + 0x0400 + (0x04 * (gpio)))
> -#define GPIO_CONFIG(gpio)         (MSM_TLMM_BASE + 0x1000 + (0x10 * (gpio)))
> -#define GPIO_IN_OUT(gpio)         (MSM_TLMM_BASE + 0x1004 + (0x10 * (gpio)))
> -#define GPIO_INTR_CFG(gpio)       (MSM_TLMM_BASE + 0x1008 + (0x10 * (gpio)))
> -#define GPIO_INTR_STATUS(gpio)    (MSM_TLMM_BASE + 0x100c + (0x10 * (gpio)))
> +#define GPIO_INTR_CFG_SU(gpio)    (msm_tlmm_base + 0x0400 + (0x04 * (gpio)))
> +#define GPIO_CONFIG(gpio)         (msm_tlmm_base + 0x1000 + (0x10 * (gpio)))
> +#define GPIO_IN_OUT(gpio)         (msm_tlmm_base + 0x1004 + (0x10 * (gpio)))
> +#define GPIO_INTR_CFG(gpio)       (msm_tlmm_base + 0x1008 + (0x10 * (gpio)))
> +#define GPIO_INTR_STATUS(gpio)    (msm_tlmm_base + 0x100c + (0x10 * (gpio)))
>  
>  /**
>   * struct msm_gpio_dev: the MSM8660 SoC GPIO device structure
> @@ -101,9 +106,10 @@ enum {
>   */
>  struct msm_gpio_dev {
>  	struct gpio_chip gpio_chip;
> -	DECLARE_BITMAP(enabled_irqs, NR_GPIO_IRQS);
> -	DECLARE_BITMAP(wake_irqs, NR_GPIO_IRQS);
> -	DECLARE_BITMAP(dual_edge_irqs, NR_GPIO_IRQS);
> +	unsigned long *enabled_irqs;
> +	unsigned long *wake_irqs;
> +	unsigned long *dual_edge_irqs;

See my comments below, but because these are merely bitmaps they are
pretty small arrays. 3 arrays of <173 bits. That's merely 72 bytes. It
is more expensive to dynamically allocate that much space.

> +	struct irq_domain *domain;
>  };
>  
>  static DEFINE_SPINLOCK(tlmm_lock);
> @@ -168,18 +174,20 @@ static void msm_gpio_free(struct gpio_chip *chip, unsigned offset)
>  
>  static int msm_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
>  {
> -	return MSM_GPIO_TO_INT(chip->base + offset);
> +	struct msm_gpio_dev *g_dev = to_msm_gpio_dev(chip);
> +	struct irq_domain *domain = g_dev->domain;
> +	return irq_create_mapping(domain, offset);
>  }
>  
>  static inline int msm_irq_to_gpio(struct gpio_chip *chip, unsigned irq)
>  {
> -	return irq - MSM_GPIO_TO_INT(chip->base);
> +	struct irq_data *irq_data = irq_get_irq_data(irq);
> +	return irq_data->hwirq;
>  }
>  
>  static struct msm_gpio_dev msm_gpio = {
>  	.gpio_chip = {
>  		.base             = 0,
> -		.ngpio            = NR_GPIO_IRQS,
>  		.direction_input  = msm_gpio_direction_input,
>  		.direction_output = msm_gpio_direction_output,
>  		.get              = msm_gpio_get,
> @@ -226,9 +234,9 @@ static void msm_gpio_update_dual_edge_pos(unsigned gpio)
>  		if (intstat || val == val2)
>  			return;
>  	} while (loop_limit-- > 0);
> -	pr_err("dual-edge irq failed to stabilize, "
> +	pr_err("%s: dual-edge irq failed to stabilize, "
>  	       "interrupts dropped. %#08x != %#08x\n",
> -	       val, val2);
> +	       __func__, val, val2);
>  }
>  
>  static void msm_gpio_irq_ack(struct irq_data *d)
> @@ -312,10 +320,11 @@ static void msm_summary_irq_handler(unsigned int irq, struct irq_desc *desc)
>  {
>  	unsigned long i;
>  	struct irq_chip *chip = irq_desc_get_chip(desc);
> +	int ngpio = msm_gpio.gpio_chip.ngpio;
>  
>  	chained_irq_enter(chip, desc);
>  
> -	for_each_set_bit(i, msm_gpio.enabled_irqs, NR_GPIO_IRQS) {
> +	for_each_set_bit(i, msm_gpio.enabled_irqs, ngpio) {
>  		if (readl(GPIO_INTR_STATUS(i)) & BIT(INTR_STATUS))
>  			generic_handle_irq(msm_gpio_to_irq(&msm_gpio.gpio_chip,
>  							   i));
> @@ -327,15 +336,16 @@ static void msm_summary_irq_handler(unsigned int irq, struct irq_desc *desc)
>  static int msm_gpio_irq_set_wake(struct irq_data *d, unsigned int on)
>  {
>  	int gpio = msm_irq_to_gpio(&msm_gpio.gpio_chip, d->irq);
> +	int ngpio = msm_gpio.gpio_chip.ngpio;
>  
>  	if (on) {
> -		if (bitmap_empty(msm_gpio.wake_irqs, NR_GPIO_IRQS))
> -			irq_set_irq_wake(TLMM_SCSS_SUMMARY_IRQ, 1);
> +		if (bitmap_empty(msm_gpio.wake_irqs, ngpio))
> +			irq_set_irq_wake(summary_irq, 1);
>  		set_bit(gpio, msm_gpio.wake_irqs);
>  	} else {
>  		clear_bit(gpio, msm_gpio.wake_irqs);
> -		if (bitmap_empty(msm_gpio.wake_irqs, NR_GPIO_IRQS))
> -			irq_set_irq_wake(TLMM_SCSS_SUMMARY_IRQ, 0);
> +		if (bitmap_empty(msm_gpio.wake_irqs, ngpio))
> +			irq_set_irq_wake(summary_irq, 0);
>  	}
>  
>  	return 0;
> @@ -350,30 +360,93 @@ static struct irq_chip msm_gpio_irq_chip = {
>  	.irq_set_wake	= msm_gpio_irq_set_wake,
>  };
>  
> -static int msm_gpio_probe(struct platform_device *dev)
> +static struct lock_class_key msm_gpio_lock_class;
> +
> +static int msm_gpio_irq_domain_map(struct irq_domain *d, unsigned int irq,
> +				   irq_hw_number_t hwirq)
>  {
> -	int i, irq, ret;
> +	irq_set_lockdep_class(irq, &msm_gpio_lock_class);
> +	irq_set_chip_and_handler(irq, &msm_gpio_irq_chip,
> +			handle_level_irq);
> +	set_irq_flags(irq, IRQF_VALID);
> +
> +	return 0;
> +}
> +
> +static const struct irq_domain_ops msm_gpio_irq_domain_ops = {
> +	.xlate = irq_domain_xlate_twocell,
> +	.map = msm_gpio_irq_domain_map,
> +};
> +
> +static int msm_gpio_irqdomain_init(struct device_node *node, int ngpio)
> +{
> +	msm_gpio.domain = irq_domain_add_linear(node, ngpio,
> +			&msm_gpio_irq_domain_ops, &msm_gpio);
> +	if (!msm_gpio.domain)
> +		return -ENOMEM;
> +
> +	return 0;
> +}

No need to split this into a separate function. All
irq_domain_add_linear() directly please.

> +
> +static int msm_gpio_probe(struct platform_device *pdev)
> +{
> +	int ret, ngpio;
> +	struct resource *res;
> +
> +	msm_gpio.gpio_chip.label = pdev->name;
> +	msm_gpio.gpio_chip.dev = &pdev->dev;
> +	if (!of_property_read_u32(pdev->dev.of_node, "ngpio", &ngpio)) {
> +		dev_err(&pdev->dev, "%s: ngpio property missing\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	msm_gpio.gpio_chip.ngpio = ngpio;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	msm_tlmm_base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(msm_tlmm_base))
> +		return PTR_ERR(msm_tlmm_base);
> +
> +	msm_gpio.enabled_irqs = devm_kzalloc(&pdev->dev,
> +						sizeof(unsigned long) * ngpio,
> +						GFP_KERNEL);
> +	msm_gpio.wake_irqs = devm_kzalloc(&pdev->dev,
> +						sizeof(unsigned long) * ngpio,
> +						GFP_KERNEL);
> +	msm_gpio.dual_edge_irqs = devm_kzalloc(&pdev->dev,
> +						sizeof(unsigned long) * ngpio,
> +						GFP_KERNEL);

It's expensive to call devm_kzalloc multiple times when you don't need
to. do this instead:

	msm_gpio.enabled_irqs = devm_kzalloc(&pdev->dev,
					sizeof(unsigned long) * ngpio * 3,
					GFP_KERNEL);
	msm_gpio.wake_irqs = &msm_gpio.enable_irqs[ngpio];
	msm_gpio.dual_edge_irqs = &msm_gpio.enable_irqs[ngpio*2];

(I wrote the above comment before looking closely at the bitmaps, so the
above is irrelevant if you revert to the static bitmap table.)

> +	bitmap_zero(msm_gpio.enabled_irqs, ngpio);
> +	bitmap_zero(msm_gpio.wake_irqs, ngpio);
> +	bitmap_zero(msm_gpio.dual_edge_irqs, ngpio);

Umm... this looks wrong. You've allocated an array with one unsigned
long for each gpio, but then are using it as a bitmask (an array of one
/bit/ for each gpio) meaning most of the array is unused.

Besides, if you've kzalloced the memory, then the bitmap is already
zeroed.  :)

What is the maximum number of gpios that this controller can have? From
the dts fragments above it looks to be 173, which would be 5 banks of
32 bits each.

>  
> -	bitmap_zero(msm_gpio.enabled_irqs, NR_GPIO_IRQS);
> -	bitmap_zero(msm_gpio.wake_irqs, NR_GPIO_IRQS);
> -	bitmap_zero(msm_gpio.dual_edge_irqs, NR_GPIO_IRQS);
> -	msm_gpio.gpio_chip.label = dev->name;
>  	ret = gpiochip_add(&msm_gpio.gpio_chip);
> -	if (ret < 0)
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "gpiochip_add failed with error %d\n", ret);
>  		return ret;
> +	}
>  
> -	for (i = 0; i < msm_gpio.gpio_chip.ngpio; ++i) {
> -		irq = msm_gpio_to_irq(&msm_gpio.gpio_chip, i);
> -		irq_set_chip_and_handler(irq, &msm_gpio_irq_chip,
> -					 handle_level_irq);
> -		set_irq_flags(irq, IRQF_VALID);
> +	summary_irq = platform_get_irq(pdev, 0);
> +	if (summary_irq < 0) {
> +		dev_err(&pdev->dev, "No Summary irq defined for msmgpio\n");
> +		return summary_irq;
>  	}
>  
> -	irq_set_chained_handler(TLMM_SCSS_SUMMARY_IRQ,
> -				msm_summary_irq_handler);
> +	ret = msm_gpio_irqdomain_init(pdev->dev.of_node,
> +					msm_gpio.gpio_chip.ngpio);
> +	if (ret)
> +		return ret;
> +
> +	irq_set_chained_handler(summary_irq, msm_summary_irq_handler);
> +
>  	return 0;
>  }
>  
> +static struct of_device_id msm_gpio_of_match[] = {
> +	{ .compatible = "qcom,msm-gpio", },
> +	{ },
> +};
> +
>  static int msm_gpio_remove(struct platform_device *dev)
>  {
>  	int ret = gpiochip_remove(&msm_gpio.gpio_chip);
> @@ -392,36 +465,11 @@ static struct platform_driver msm_gpio_driver = {
>  	.driver = {
>  		.name = "msmgpio",
>  		.owner = THIS_MODULE,
> +		.of_match_table = of_match_ptr(msm_gpio_of_match),

You don't need the of_match_ptr() macro if msm_gpio_of_match[] is
unconditionally present (which in this patch it is)

>  	},
>  };
>  
> -static struct platform_device msm_device_gpio = {
> -	.name = "msmgpio",
> -	.id   = -1,
> -};
> -
> -static int __init msm_gpio_init(void)
> -{
> -	int rc;
> -
> -	rc = platform_driver_register(&msm_gpio_driver);
> -	if (!rc) {
> -		rc = platform_device_register(&msm_device_gpio);
> -		if (rc)
> -			platform_driver_unregister(&msm_gpio_driver);
> -	}
> -
> -	return rc;
> -}
> -
> -static void __exit msm_gpio_exit(void)
> -{
> -	platform_device_unregister(&msm_device_gpio);
> -	platform_driver_unregister(&msm_gpio_driver);
> -}
> -
> -postcore_initcall(msm_gpio_init);
> -module_exit(msm_gpio_exit);
> +module_platform_driver(msm_gpio_driver)
>  
>  MODULE_AUTHOR("Gregory Bean <gbean@codeaurora.org>");
>  MODULE_DESCRIPTION("Driver for Qualcomm MSM TLMMv2 SoC GPIOs");
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
