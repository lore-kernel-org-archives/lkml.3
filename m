Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779Ab3FXNfA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 09:35:00 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:65527 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab3FXNe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 09:34:58 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v3 2/4] gpio-tz1090: add TZ1090 gpio driver
To: James Hogan <james.hogan@imgtec.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, James Hogan <james.hogan@imgtec.com>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
In-Reply-To: <1371720391-21825-3-git-send-email-james.hogan@imgtec.com>
References: <1371720391-21825-1-git-send-email-james.hogan@imgtec.com> <1371720391-21825-3-git-send-email-james.hogan@imgtec.com>
Date: Mon, 24 Jun 2013 14:34:53 +0100
Message-Id: <20130624133453.8FC5D3E0A89@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jun 2013 10:26:28 +0100, James Hogan <james.hogan@imgtec.com> wrote:
> Add a GPIO driver for the main GPIOs found in the TZ1090 (Comet) SoC.
> This doesn't include low-power GPIOs as they're controlled separately
> via the Powerdown Controller (PDC) registers.
> 
> The driver is instantiated by device tree and supports interrupts for
> all GPIOs.
> 
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Rob Landley <rob@landley.net>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: linux-doc@vger.kernel.org
> Cc: devicetree-discuss@lists.ozlabs.org
> ---
> Changes in v3:
>  - separated from irq-imgpdc and removed arch/metag changes to allow
>    these patches to go upstream separately via the pinctrl[/gpio] trees
>    (particularly the pinctrl drivers depend on the new pinconf DT
>    bindings).
>  - some s/unsigned/unsigned int/.
>  - some s/unsigned int/bool/ and use of BIT().
>  - gpio-tz1090*: refer to <dt-bindings/gpio/gpio.h> and
>    <dt-bindings/interrupt-controller/irq.h> flags in bindings.
>  - gpio-tz1090*: move initcall from postcore to subsys.
>  - gpio-tz1090: add REG_ prefix to some constants for consistency.
>  - gpio-tz1090: add comment to explain tz1090_gpio_irq_next_edge
>    cunningness.
> 
> Changes in v2:
>  - gpio-tz1090: remove references to Linux flags in dt bindings
>  - gpio-tz1090: make use of BIT() from linux/bitops.h
>  - gpio-tz1090: make register accessors inline to match pinctrl
>  - gpio-tz1090: update gpio-ranges to use 3 cells after recent ABI
>    breakage
> 
>  .../devicetree/bindings/gpio/gpio-tz1090.txt       |  87 +++
>  drivers/gpio/Kconfig                               |   7 +
>  drivers/gpio/Makefile                              |   1 +
>  drivers/gpio/gpio-tz1090.c                         | 633 +++++++++++++++++++++
>  4 files changed, 728 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/gpio/gpio-tz1090.txt
>  create mode 100644 drivers/gpio/gpio-tz1090.c
> 
> diff --git a/Documentation/devicetree/bindings/gpio/gpio-tz1090.txt b/Documentation/devicetree/bindings/gpio/gpio-tz1090.txt
> new file mode 100644
> index 0000000..e017d4b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/gpio/gpio-tz1090.txt
> @@ -0,0 +1,87 @@
> +ImgTec TZ1090 GPIO Controller
> +
> +Required properties:
> +- compatible: Compatible property value should be "img,tz1090-gpio>".

typo at end of line

> +
> +- reg: Physical base address of the controller and length of memory mapped
> +  region.
> +
> +- #address-cells: Should be 1 (for bank subnodes)
> +
> +- #size-cells: Should be 0 (for bank subnodes)
> +
> +- Each bank of GPIOs should have a subnode to represent it.
> +
> +  Bank subnode required properties:
> +  - reg: Index of bank in the range 0 to 2.
> +
> +  - gpio-controller: Specifies that the node is a gpio controller.
> +
> +  - #gpio-cells: Should be 2. The syntax of the gpio specifier used by client
> +    nodes should have the following values.
> +       <[phandle of the gpio controller node]
> +        [gpio number within the gpio bank]
> +        [gpio flags]>
> +
> +    Values for gpio specifier:
> +    - GPIO number: a value in the range 0 to 29.
> +    - GPIO flags: bit field of flags, as defined in <dt-bindings/gpio/gpio.h>.
> +      Only the following flags are supported:
> +        GPIO_ACTIVE_HIGH
> +        GPIO_ACTIVE_LOW
> +
> +  Bank subnode optional properties:
> +  - gpio-ranges: Mapping to pin controller pins

This is specific to this binding. To avoid namespace colisions, add a
"img," prefix to the property name.

> +
> +  - interrupts: Interrupt for the entire bank
> +
> +  - interrupt-controller: Specifies that the node is an interrupt controller
> +
> +  - #interrupt-cells: Should be 2. The syntax of the interrupt specifier used by
> +    client nodes should have the following values.
> +       <[phandle of the interurupt controller]
> +        [gpio number within the gpio bank]
> +        [irq flags]>
> +
> +    Values for irq specifier:
> +    - GPIO number: a value in the range 0 to 29
> +    - IRQ flags: value to describe edge and level triggering, as defined in
> +      <dt-bindings/interrupt-controller/irq.h>. Only the following flags are
> +      supported:
> +        IRQ_TYPE_EDGE_RISING
> +        IRQ_TYPE_EDGE_FALLING
> +        IRQ_TYPE_EDGE_BOTH
> +        IRQ_TYPE_LEVEL_HIGH
> +        IRQ_TYPE_LEVEL_LOW
> +
> +
> +
> +Example:
> +
> +	gpios: gpio-controller@02005800 {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		compatible = "img,tz1090-gpio";
> +		reg = <0x02005800 0x90>;
> +
> +		/* bank 0 with an interrupt */
> +		gpios0: bank@0 {
> +			#gpio-cells = <2>;
> +			#interrupt-cells = <2>;
> +			reg = <0>;
> +			interrupts = <13 IRQ_TYPE_LEVEL_HIGH>;
> +			gpio-controller;
> +			gpio-ranges = <&pinctrl 0 30>;
> +			interrupt-controller;
> +		};
> +
> +		/* bank 2 without interrupt */
> +		gpios2: bank@2 {
> +			#gpio-cells = <2>;
> +			reg = <2>;
> +			gpio-controller;
> +			gpio-ranges = <&pinctrl 60 30>;
> +		};
> +	};
> +
> +
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index 573c449..ee27c2e 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -232,6 +232,13 @@ config GPIO_TS5500
>  	  blocks of the TS-5500: DIO1, DIO2 and the LCD port, and the TS-5600
>  	  LCD port.
>  
> +config GPIO_TZ1090
> +	bool "Toumaz Xenif TZ1090 GPIO support"
> +	depends on SOC_TZ1090
> +	default y
> +	help
> +	  Say yes here to support Toumaz Xenif TZ1090 GPIOs.
> +
>  config GPIO_XILINX
>  	bool "Xilinx GPIO support"
>  	depends on PPC_OF || MICROBLAZE
> diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
> index 0cb2d65..37bdc1e 100644
> --- a/drivers/gpio/Makefile
> +++ b/drivers/gpio/Makefile
> @@ -79,6 +79,7 @@ obj-$(CONFIG_GPIO_TPS65912)	+= gpio-tps65912.o
>  obj-$(CONFIG_GPIO_TS5500)	+= gpio-ts5500.o
>  obj-$(CONFIG_GPIO_TWL4030)	+= gpio-twl4030.o
>  obj-$(CONFIG_GPIO_TWL6040)	+= gpio-twl6040.o
> +obj-$(CONFIG_GPIO_TZ1090)	+= gpio-tz1090.o
>  obj-$(CONFIG_GPIO_UCB1400)	+= gpio-ucb1400.o
>  obj-$(CONFIG_GPIO_VIPERBOARD)	+= gpio-viperboard.o
>  obj-$(CONFIG_GPIO_VR41XX)	+= gpio-vr41xx.o
> diff --git a/drivers/gpio/gpio-tz1090.c b/drivers/gpio/gpio-tz1090.c
> new file mode 100644
> index 0000000..099a9ef
> --- /dev/null
> +++ b/drivers/gpio/gpio-tz1090.c
> @@ -0,0 +1,633 @@
> +/*
> + * Toumaz Xenif TZ1090 GPIO handling.
> + *
> + * Copyright (C) 2008-2013 Imagination Technologies Ltd.
> + *
> + *  Based on ARM PXA code and others.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/bitops.h>
> +#include <linux/export.h>
> +#include <linux/gpio.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/irq.h>
> +#include <linux/irqdomain.h>
> +#include <linux/kernel.h>
> +#include <linux/of_irq.h>
> +#include <linux/pinctrl/consumer.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/syscore_ops.h>
> +#include <asm/global_lock.h>
> +
> +/* Register offsets from bank base address */
> +#define REG_GPIO_DIR		0x00
> +#define REG_GPIO_IRQ_PLRT	0x20
> +#define REG_GPIO_IRQ_TYPE	0x30
> +#define REG_GPIO_IRQ_EN		0x40
> +#define REG_GPIO_IRQ_STS	0x50
> +#define REG_GPIO_BIT_EN		0x60
> +#define REG_GPIO_DIN		0x70
> +#define REG_GPIO_DOUT		0x80
> +
> +/* REG_GPIO_IRQ_PLRT */
> +#define REG_GPIO_IRQ_PLRT_LOW	0
> +#define REG_GPIO_IRQ_PLRT_HIGH	1
> +
> +/* REG_GPIO_IRQ_TYPE */
> +#define REG_GPIO_IRQ_TYPE_LEVEL	0
> +#define REG_GPIO_IRQ_TYPE_EDGE	1
> +
> +/**
> + * struct tz1090_gpio_bank - GPIO bank private data
> + * @chip:	Generic GPIO chip for GPIO bank
> + * @domain:	IRQ domain for GPIO bank (may be NULL)
> + * @reg:	Base of registers, offset for this GPIO bank
> + * @irq:	IRQ number for GPIO bank
> + * @label:	Debug GPIO bank label, used for storage of chip->label
> + *
> + * This is the main private data for a GPIO bank. It encapsulates a gpio_chip,
> + * and the callbacks for the gpio_chip can access the private data with the
> + * to_bank() macro below.
> + */
> +struct tz1090_gpio_bank {
> +	struct gpio_chip chip;
> +	struct irq_domain *domain;
> +	void __iomem *reg;
> +	int irq;
> +	char label[16];
> +};
> +#define to_bank(c)	container_of(c, struct tz1090_gpio_bank, chip)
> +
> +/**
> + * struct tz1090_gpio - Overall GPIO device private data
> + * @dev:	Device (from platform device)
> + * @reg:	Base of GPIO registers
> + *
> + * Represents the overall GPIO device. This structure is actually only
> + * temporary, and used during init.
> + */
> +struct tz1090_gpio {
> +	struct device *dev;
> +	void __iomem *reg;
> +};
> +
> +/**
> + * struct tz1090_gpio_bank_info - Temporary registration info for GPIO bank
> + * @priv:	Overall GPIO device private data
> + * @node:	Device tree node specific to this GPIO bank
> + * @index:	Index of bank in range 0-2
> + */
> +struct tz1090_gpio_bank_info {
> +	struct tz1090_gpio *priv;
> +	struct device_node *node;
> +	unsigned int index;
> +};
> +
> +/* Convenience register accessors */
> +static inline void tz1090_gpio_write(struct tz1090_gpio_bank *bank,
> +			      unsigned int reg_offs, u32 data)
> +{
> +	iowrite32(data, bank->reg + reg_offs);
> +}
> +
> +static inline u32 tz1090_gpio_read(struct tz1090_gpio_bank *bank,
> +			    unsigned int reg_offs)
> +{
> +	return ioread32(bank->reg + reg_offs);
> +}
> +
> +/* caller must hold LOCK2 */
> +static inline void _tz1090_gpio_clear_bit(struct tz1090_gpio_bank *bank,
> +					  unsigned int reg_offs,
> +					  unsigned int offset)
> +{
> +	u32 value;
> +
> +	value = tz1090_gpio_read(bank, reg_offs);
> +	value &= ~BIT(offset);
> +	tz1090_gpio_write(bank, reg_offs, value);
> +}
> +
> +static void tz1090_gpio_clear_bit(struct tz1090_gpio_bank *bank,
> +				  unsigned int reg_offs,
> +				  unsigned int offset)
> +{
> +	int lstat;
> +
> +	__global_lock2(lstat);
> +	_tz1090_gpio_clear_bit(bank, reg_offs, offset);
> +	__global_unlock2(lstat);
> +}
> +
> +/* caller must hold LOCK2 */
> +static inline void _tz1090_gpio_set_bit(struct tz1090_gpio_bank *bank,
> +					unsigned int reg_offs,
> +					unsigned int offset)
> +{
> +	u32 value;
> +
> +	value = tz1090_gpio_read(bank, reg_offs);
> +	value |= BIT(offset);
> +	tz1090_gpio_write(bank, reg_offs, value);
> +}
> +
> +static void tz1090_gpio_set_bit(struct tz1090_gpio_bank *bank,
> +				unsigned int reg_offs,
> +				unsigned int offset)
> +{
> +	int lstat;
> +
> +	__global_lock2(lstat);
> +	_tz1090_gpio_set_bit(bank, reg_offs, offset);
> +	__global_unlock2(lstat);
> +}
> +
> +/* caller must hold LOCK2 */
> +static inline void _tz1090_gpio_mod_bit(struct tz1090_gpio_bank *bank,
> +					unsigned int reg_offs,
> +					unsigned int offset,
> +					bool val)
> +{
> +	u32 value;
> +
> +	value = tz1090_gpio_read(bank, reg_offs);
> +	value &= ~BIT(offset);
> +	if (val)
> +		value |= BIT(offset);
> +	tz1090_gpio_write(bank, reg_offs, value);
> +}
> +
> +static void tz1090_gpio_mod_bit(struct tz1090_gpio_bank *bank,
> +				unsigned int reg_offs,
> +				unsigned int offset,
> +				bool val)
> +{
> +	int lstat;
> +
> +	__global_lock2(lstat);
> +	_tz1090_gpio_mod_bit(bank, reg_offs, offset, val);
> +	__global_unlock2(lstat);
> +}
> +
> +static inline int tz1090_gpio_read_bit(struct tz1090_gpio_bank *bank,
> +				       unsigned int reg_offs,
> +				       unsigned int offset)
> +{
> +	return tz1090_gpio_read(bank, reg_offs) & BIT(offset);
> +}
> +
> +/* GPIO chip callbacks */
> +
> +static int tz1090_gpio_direction_input(struct gpio_chip *chip,
> +				       unsigned int offset)
> +{
> +	struct tz1090_gpio_bank *bank = to_bank(chip);
> +	tz1090_gpio_set_bit(bank, REG_GPIO_DIR, offset);
> +
> +	return 0;
> +}
> +
> +static int tz1090_gpio_direction_output(struct gpio_chip *chip,
> +					unsigned int offset, int output_value)
> +{
> +	struct tz1090_gpio_bank *bank = to_bank(chip);
> +	int lstat;
> +
> +	__global_lock2(lstat);
> +	_tz1090_gpio_mod_bit(bank, REG_GPIO_DOUT, offset, output_value);
> +	_tz1090_gpio_clear_bit(bank, REG_GPIO_DIR, offset);
> +	__global_unlock2(lstat);
> +
> +	return 0;
> +}
> +
> +/*
> + * Return GPIO level
> + */
> +static int tz1090_gpio_get(struct gpio_chip *chip, unsigned int offset)
> +{
> +	struct tz1090_gpio_bank *bank = to_bank(chip);
> +
> +	return tz1090_gpio_read_bit(bank, REG_GPIO_DIN, offset);
> +}
> +
> +/*
> + * Set output GPIO level
> + */
> +static void tz1090_gpio_set(struct gpio_chip *chip, unsigned int offset,
> +			    int output_value)
> +{
> +	struct tz1090_gpio_bank *bank = to_bank(chip);
> +
> +	tz1090_gpio_mod_bit(bank, REG_GPIO_DOUT, offset, output_value);
> +}
> +
> +static int tz1090_gpio_request(struct gpio_chip *chip, unsigned int offset)
> +{
> +	struct tz1090_gpio_bank *bank = to_bank(chip);
> +	int ret;
> +
> +	ret = pinctrl_request_gpio(chip->base + offset);
> +	if (ret)
> +		return ret;
> +
> +	tz1090_gpio_set_bit(bank, REG_GPIO_DIR, offset);
> +	tz1090_gpio_set_bit(bank, REG_GPIO_BIT_EN, offset);
> +
> +	return 0;
> +}

Is it possible to use the gpio-generic.c hooks for manipulating the
gpio bits?

> +
> +static void tz1090_gpio_free(struct gpio_chip *chip, unsigned int offset)
> +{
> +	struct tz1090_gpio_bank *bank = to_bank(chip);
> +
> +	pinctrl_free_gpio(chip->base + offset);
> +
> +	tz1090_gpio_clear_bit(bank, REG_GPIO_BIT_EN, offset);
> +}
> +
> +static int tz1090_gpio_to_irq(struct gpio_chip *chip, unsigned int offset)
> +{
> +	struct tz1090_gpio_bank *bank = to_bank(chip);
> +
> +	if (!bank->domain)
> +		return -EINVAL;
> +
> +	return irq_create_mapping(bank->domain, offset);
> +}
> +
> +/* IRQ chip handlers */
> +
> +/* Get TZ1090 GPIO chip from irq data provided to generic IRQ callbacks */
> +static inline struct tz1090_gpio_bank *irqd_to_gpio_bank(struct irq_data *data)
> +{
> +	return (struct tz1090_gpio_bank *)data->domain->host_data;
> +}
> +
> +static void tz1090_gpio_irq_clear(struct tz1090_gpio_bank *bank,
> +				  unsigned int offset)
> +{
> +	tz1090_gpio_clear_bit(bank, REG_GPIO_IRQ_STS, offset);
> +}
> +
> +static void tz1090_gpio_irq_enable(struct tz1090_gpio_bank *bank,
> +				   unsigned int offset, bool enable)
> +{
> +	tz1090_gpio_mod_bit(bank, REG_GPIO_IRQ_EN, offset, enable);
> +}
> +
> +static void tz1090_gpio_irq_polarity(struct tz1090_gpio_bank *bank,
> +				     unsigned int offset, unsigned int polarity)
> +{
> +	tz1090_gpio_mod_bit(bank, REG_GPIO_IRQ_PLRT, offset, polarity);
> +}
> +
> +static int tz1090_gpio_valid_handler(struct irq_desc *desc)
> +{
> +	return desc->handle_irq == handle_level_irq ||
> +		desc->handle_irq == handle_edge_irq;
> +}
> +
> +static void tz1090_gpio_irq_type(struct tz1090_gpio_bank *bank,
> +				 unsigned int offset, unsigned int type)
> +{
> +	tz1090_gpio_mod_bit(bank, REG_GPIO_IRQ_TYPE, offset, type);
> +}
> +
> +/* set polarity to trigger on next edge, whether rising or falling */
> +static void tz1090_gpio_irq_next_edge(struct tz1090_gpio_bank *bank,
> +				      unsigned int offset)
> +{
> +	unsigned int value_p, value_i;
> +	int lstat;
> +
> +	/*
> +	 * Set the GPIO's interrupt polarity to the opposite of the current
> +	 * input value so that the next edge triggers an interrupt.
> +	 */
> +	__global_lock2(lstat);
> +	value_i = ~tz1090_gpio_read(bank, REG_GPIO_DIN);
> +	value_p = tz1090_gpio_read(bank, REG_GPIO_IRQ_PLRT);
> +	value_p &= ~BIT(offset);
> +	value_p |= value_i & BIT(offset);
> +	tz1090_gpio_write(bank, REG_GPIO_IRQ_PLRT, value_p);
> +	__global_unlock2(lstat);
> +}
> +
> +static void gpio_ack_irq(struct irq_data *data)
> +{
> +	struct tz1090_gpio_bank *bank = irqd_to_gpio_bank(data);
> +
> +	tz1090_gpio_irq_clear(bank, data->hwirq);
> +}
> +
> +static void gpio_mask_irq(struct irq_data *data)
> +{
> +	struct tz1090_gpio_bank *bank = irqd_to_gpio_bank(data);
> +
> +	tz1090_gpio_irq_enable(bank, data->hwirq, false);
> +}
> +
> +static void gpio_unmask_irq(struct irq_data *data)
> +{
> +	struct tz1090_gpio_bank *bank = irqd_to_gpio_bank(data);
> +
> +	tz1090_gpio_irq_enable(bank, data->hwirq, true);
> +}

Similarly, can this driver use the generic irq chip to eliminate the
above hooks?

[...]
> +
> +static void tz1090_gpio_register_banks(struct tz1090_gpio *priv)
> +{
> +	struct device_node *np = priv->dev->of_node;
> +	struct device_node *node;
> +
> +	for_each_available_child_of_node(np, node) {
> +		struct tz1090_gpio_bank_info info;
> +		const __be32 *addr;
> +		int len, ret;
> +
> +		addr = of_get_property(node, "reg", &len);
> +		if (!addr || (len < sizeof(int))) {
> +			dev_err(priv->dev, "invalid reg on %s\n",
> +				node->full_name);
> +			continue;
> +		}

Use of_property_read_u32(). It's safer and does the be32 conversion for you.

> +
> +		info.index = be32_to_cpup(addr);
> +		if (info.index >= 3) {
> +			dev_err(priv->dev, "index %u in %s out of range\n",
> +				info.index, node->full_name);
> +			continue;
> +		}
> +		info.node = of_node_get(node);
> +		info.priv = priv;
> +
> +		ret = tz1090_gpio_bank_probe(&info);
> +		if (ret) {
> +			dev_err(priv->dev, "failure registering %s\n",
> +				node->full_name);
> +			of_node_put(node);
> +			continue;
> +		}
> +	}
> +}
> +
> +static int tz1090_gpio_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	struct resource *res_regs;
> +	struct tz1090_gpio priv;
> +
> +	if (!np) {
> +		dev_err(&pdev->dev, "must be instantiated via devicetree\n");
> +		return -ENOENT;
> +	}
> +
> +	res_regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res_regs) {
> +		dev_err(&pdev->dev, "cannot find registers resource\n");
> +		return -ENOENT;
> +	}
> +
> +	priv.dev = &pdev->dev;
> +
> +	/* Ioremap the registers */
> +	priv.reg = devm_ioremap(&pdev->dev, res_regs->start,
> +				 res_regs->end - res_regs->start);
> +	if (!priv.reg) {
> +		dev_err(&pdev->dev, "unable to ioremap registers\n");
> +		return -ENOMEM;
> +	}
> +
> +	/* Look for banks */
> +	tz1090_gpio_register_banks(&priv);
> +
> +	return 0;
> +}
> +
> +static struct of_device_id tz1090_gpio_of_match[] = {
> +	{ .compatible = "img,tz1090-gpio" },
> +	{ },
> +};
> +
> +static struct platform_driver tz1090_gpio_driver = {
> +	.driver = {
> +		.name		= "tz1090-gpio",
> +		.owner		= THIS_MODULE,
> +		.of_match_table	= tz1090_gpio_of_match,
> +	},
> +	.probe		= tz1090_gpio_probe,
> +};
> +
> +static int __init tz1090_gpio_init(void)
> +{
> +	return platform_driver_register(&tz1090_gpio_driver);
> +}
> +subsys_initcall(tz1090_gpio_init);
> -- 
> 1.8.1.2
> 
> 

-- 
email sent from notmuch.vim plugin
