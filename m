Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966759Ab3DQPNW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 11:13:22 -0400
Received: from mail-ia0-f172.google.com ([209.85.210.172]:45945 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966615Ab3DQPNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 11:13:19 -0400
MIME-Version: 1.0
In-Reply-To: <1365608728-30494-2-git-send-email-christian.ruppert@abilis.com>
References: <1365608728-30494-1-git-send-email-christian.ruppert@abilis.com>
	<1365608728-30494-2-git-send-email-christian.ruppert@abilis.com>
Date: Wed, 17 Apr 2013 17:13:16 +0200
Message-ID: <CACRpkdbF_-9D=K1yXqcR87MScD9nL9pbTd4Lzn_z1V=NWD1LPg@mail.gmail.com>
Subject: Re: [PATCH 2/2] GPIO: Add TB10x GPIO driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Christian Ruppert <christian.ruppert@abilis.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 5:45 PM, Christian Ruppert
<christian.ruppert@abilis.com> wrote:

> The GPIO driver for the Abilis Systems TB10x series of SOCs based on ARC700
> CPUs. It supports GPIO control and GPIO interrupt generation. This driver
> works in conjunction with the TB10x pinctrl driver.
>
> Signed-off-by: Sascha Leuenberger <sascha.leuenberger@abilis.com>
> Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>

(...)
> +++ b/Documentation/devicetree/bindings/gpio/abilis,tb10x-gpio.txt
> @@ -0,0 +1,34 @@
> +* Abilis TB10x GPIO controller
> +
> +Required Properties:
> +- compatible: Should be "abilis,tb10x-gpio"
> +- reg: Address and length of the register set for the device
> +- gpio-controller: Marks the device node as a gpio controller.
> +- #gpio-cells: Should be <1>;
> +- gpio-base: GPIO pin index of the first GPOI managed by this controller.

No, this is a Linux-specific number, it shall not be encoded into the
device tree at all. (Search the archive for previous discussions on this.)

If you use standard GPIO ranges this will fix itself, and you'll see how
nicely it all fits together. You do not need to know the global numbers
at all.

> +- gpio-pins: Pointer to the pin configuration node inside an
> +  "abilis,tb10x-iomux"-compatible pin controller this GPIO controller is
> +  managing.

No thanks, use the existing GPIO ranges and it will be much easier.

(...)
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index 93aaadf..7357dd5 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -309,6 +309,10 @@ config GPIO_LYNXPOINT
>           driver for GPIO functionality on Intel Lynxpoint PCH chipset
>           Requires ACPI device enumeration code to set up a platform device.
>
> +config GPIO_TB10X
> +       bool
> +       depends on PINCTRL_TB10X

Can't you just select it instead?

You probably want to select OF_GPIO too.

(...)
> +++ b/drivers/gpio/gpio-tb10x.c

> +#define TB10X_GPIO_DIR_IN      (0x00000000)
> +#define TB10X_GPIO_DIR_OUT     (0x00000001)
> +#define OFFSET_TO_REG_DDR      (0x00)
> +#define OFFSET_TO_REG_DATA     (0x04)
> +#define OFFSET_TO_REG_INT_EN   (0x08)
> +#define OFFSET_TO_REG_CHANGE   (0x0C)
> +#define OFFSET_TO_REG_WRMASK   (0x10)
> +#define OFFSET_TO_REG_INT_TYPE (0x14)
> +
> +struct tb10x_gpio {
> +       spinlock_t spinlock;
> +       void __iomem *regs;

If the other driver calls this "base" maybe you can
use the same name here?

> +       struct irq_domain *domain;
> +       int irq;
> +       struct gpio_chip gc;
> +       struct pinctrl_gpio_range gr;
> +};

Please add some brief kerneldoc to this struct.

(...)
> +static int tb10x_gpio_direction_in(struct gpio_chip *chip, unsigned offset)
> +{
> +       struct tb10x_gpio *tb10x_gpio = to_tb10x_gpio(chip);
> +       int mask = 1 << offset;

Everywhere you have code like that, please do it like this:

#include <linux/bitops.h>

int mask = BIT(offset);

> +       int val = TB10X_GPIO_DIR_IN << offset;
> +
> +       tb10x_set_bits(tb10x_gpio, OFFSET_TO_REG_DDR, mask, val);
> +
> +       return 0;
> +}

(...)
> +static int tb10x_gpio_request(struct gpio_chip *chip, unsigned offset)
> +{
> +       return pinctrl_request_gpio(chip->base + offset);
> +}
> +
> +static void tb10x_gpio_free(struct gpio_chip *chip, unsigned offset)
> +{
> +       pinctrl_free_gpio(chip->base + offset);
> +}

This is good!

> +static int tb10x_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
> +{
> +       struct tb10x_gpio *tb10x_gpio = to_tb10x_gpio(chip);

Newline here

> +       return irq_create_mapping(tb10x_gpio->domain, offset);
> +}

Very nice with this irqdomain and all.

> +#ifdef CONFIG_OF_GPIO
> +static int tb10x_gpio_xlate(struct gpio_chip *chip,
> +                       const struct of_phandle_args *gpiospec, u32 *flags)
> +{
> +       return gpiospec->args[0];
> +}
> +#endif

Why do you need to #ifdef this?

Just select OF_GPIO in the Kconfig.

> +static void tb10x_gpio_irq_ack(struct irq_data *data)
> +{
> +       struct tb10x_gpio *tb10x_gpio = irq_data_get_irq_chip_data(data);
> +       unsigned int hwirq = irqd_to_hwirq(data);

Newline.

> +       tb10x_reg_write(tb10x_gpio, OFFSET_TO_REG_CHANGE, 0x1 << hwirq);
> +}
> +
> +static void tb10x_gpio_irq_unmask(struct irq_data *data)
> +{
> +       struct tb10x_gpio *tb10x_gpio = irq_data_get_irq_chip_data(data);
> +       unsigned int hwirq = irqd_to_hwirq(data);
> +       u32 m = 0x1 << hwirq;
> +       u32 r = tb10x_reg_read(tb10x_gpio, OFFSET_TO_REG_INT_EN);

Newline.

> +       tb10x_reg_write(tb10x_gpio, OFFSET_TO_REG_CHANGE, m);
> +       tb10x_reg_write(tb10x_gpio, OFFSET_TO_REG_INT_EN, r | m);
> +}
> +
> +static void tb10x_gpio_irq_mask(struct irq_data *data)
> +{
> +       struct tb10x_gpio *tb10x_gpio = irq_data_get_irq_chip_data(data);
> +       unsigned int hwirq = irqd_to_hwirq(data);
> +       u32 m = 0x1 << hwirq;

Here too: u32 m = BIT(hwirq);

> +       u32 r = tb10x_reg_read(tb10x_gpio, OFFSET_TO_REG_INT_EN);

Newline.

> +       tb10x_reg_write(tb10x_gpio, OFFSET_TO_REG_INT_EN, r & ~m);
> +}

> +static int tb10x_gpio_irq_set_type(struct irq_data *data, unsigned int type)
> +{
> +       if ((type & IRQF_TRIGGER_MASK) != IRQ_TYPE_EDGE_BOTH) {
> +               pr_err("Cannot assign multiple trigger modes to GPIO IRQ.\n");

But...  the error message says the opposite of what the if() expression
is testing...? You test that both edges are requested.

(...)
> +static irqreturn_t tb10x_gpio_irq_cascade(int irq, void *data)
> +{
> +       struct tb10x_gpio *tb10x_gpio = data;
> +       u32 r = tb10x_reg_read(tb10x_gpio, OFFSET_TO_REG_CHANGE);
> +       u32 m = tb10x_reg_read(tb10x_gpio, OFFSET_TO_REG_INT_EN);
> +       int i;
> +       for (i = 0; i < 32; i++)

Use something like:

int offset;
for_each_set_bit(offset, &m, 32) {}...

> +               if (r & m & (1L << i))
> +                       generic_handle_irq(irq_find_mapping(tb10x_gpio->domain,
> +                                                               i));
> +       return IRQ_HANDLED;
> +}

(...)
> +static int tb10x_gpio_probe(struct platform_device *pdev)
> +{
> +       struct tb10x_gpio *tb10x_gpio;
> +       struct resource *mem;
> +       struct device_node *dn = pdev->dev.of_node;
> +       int ret = -EBUSY;
> +       u32 base;
> +       u32 phandle;
> +       struct device_node *pstate;
> +       struct pinctrl *pctl;
> +       struct tb10x_pinfuncgrp *pfg;
> +
> +       if (!dn)
> +               return -EINVAL;
> +
> +       if (of_property_read_u32(dn, "gpio-base", &base))
> +               return -EINVAL;

Remove, as explained above.

> +       mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       if (!mem) {
> +               dev_err(&pdev->dev, "No memory resource defined.\n");
> +               return -EINVAL;
> +       }
> +
> +       tb10x_gpio = kzalloc(sizeof(*tb10x_gpio), GFP_KERNEL);

Use devm_kzalloc().

> +       if (tb10x_gpio == NULL)
> +               return -ENOMEM;
> +
> +       spin_lock_init(&tb10x_gpio->spinlock);
> +
> +       if (!request_mem_region(mem->start, resource_size(mem), pdev->name)) {
> +               dev_err(&pdev->dev, "Request reg region failed.\n");
> +               goto fail_reg_req;
> +       }
> +
> +       tb10x_gpio->regs = ioremap(mem->start, resource_size(mem));
> +       if (!tb10x_gpio->regs) {
> +               dev_err(&pdev->dev, "Could not remap reg space.\n");
> +               goto fail_ioremap;
> +       }

Replace with devm_ioremap_resource().

> +       tb10x_gpio->gc.label            = of_node_full_name(dn);
> +       tb10x_gpio->gc.dev              = &pdev->dev;
> +       tb10x_gpio->gc.owner            = THIS_MODULE;
> +       tb10x_gpio->gc.direction_input  = tb10x_gpio_direction_in;
> +       tb10x_gpio->gc.get              = tb10x_gpio_get;
> +       tb10x_gpio->gc.direction_output = tb10x_gpio_direction_out;
> +       tb10x_gpio->gc.set              = tb10x_gpio_set;
> +       tb10x_gpio->gc.request          = tb10x_gpio_request;
> +       tb10x_gpio->gc.free             = tb10x_gpio_free;
> +#ifdef CONFIG_OF_GPIO
> +       tb10x_gpio->gc.of_xlate         = tb10x_gpio_xlate;
> +       tb10x_gpio->gc.of_gpio_n_cells  = 1;
> +#endif

select OF_GPIO in Kconfig and skip #ifdef:s.

> +
> +       tb10x_gpio->gc.can_sleep        = 0;
> +
> +       tb10x_gpio->gc.base             = base;
> +
> +       if (of_find_property(dn, "pinctrl-0", NULL)) {
> +               int idx, len;
> +               const __be32 *prop;
> +
> +               idx = of_property_match_string(dn, "pinctrl-names",
> +                                               PINCTRL_STATE_DEFAULT);
> +               if (idx < 0) {
> +                       ret = idx;
> +                       goto fail_pinctrl_setup;
> +               }
> +
> +               prop = of_get_property(dn, "pinctrl-0", &len);
> +               if (IS_ERR(prop)) {
> +                       ret = PTR_ERR(prop);
> +                       goto fail_pinctrl_setup;
> +               }
> +
> +               if (len <= idx) {
> +                       ret = -EINVAL;
> +                       goto fail_pinctrl_setup;
> +               }
> +               phandle = be32_to_cpu(prop[idx]);
> +
> +               pctl = devm_pinctrl_get_select_default(&pdev->dev);
> +               if (IS_ERR(pctl)) {
> +                       ret = PTR_ERR(pctl);
> +                       dev_err(&pdev->dev, "Could not set up pinctrl: %d\n",
> +                               ret);
> +                       goto fail_pinctrl_setup;
> +               }
> +       } else {
> +               ret = of_property_read_u32(dn, "gpio-pins", &phandle);
> +               if (ret)
> +                       goto fail_pinctrl_setup;
> +       }

No, this looks like a mishmash of pinctrl and GPIO responsibilities.

This kind of stuff should be done in the pinctrl driver, and it seems
redundant too, you are likely looking for exactly what commit
ab78029ecc347debbd737f06688d788bd9d60c1d
"drivers/pinctrl: grab default handles from device core"
is already doing for each and every driver if you just name your
states "default" instead.

> +       pstate = of_find_node_by_phandle(phandle);
> +       if (!pstate) {
> +               ret = -EINVAL;
> +               goto fail_pinctrl_setup;
> +       }
> +       of_node_put(pstate);
> +
> +       pfg = tb10x_prepare_gpio_range(pstate, &tb10x_gpio->gr);
> +       if (IS_ERR(pfg)) {
> +               ret = PTR_ERR(pfg);
> +               goto fail_pinctrl_setup;
> +       }

Again use the standard OF range mapping in the core gpiolib.

No cross-calling to the pinctrl driver please.

None of this code should be needed.

> +       ret = gpiochip_add(&tb10x_gpio->gc);
> +       if (ret < 0) {
> +               dev_err(&pdev->dev, "Could not add gpiochip.\n");
> +               goto fail_gpiochip_registration;
> +       }
> +
> +       tb10x_setup_gpio_range(pfg, &tb10x_gpio->gr);

Again you either use the gpiolib OF core range creation.

> +       if (of_find_property(dn, "interrupt-controller", NULL)) {
> +               ret = platform_get_irq(pdev, 0);
> +               if (ret < 0) {
> +                       dev_err(&pdev->dev, "No interrupt specified.\n");
> +                       goto fail_get_irq;
> +               }
> +               tb10x_gpio->gc.to_irq   = tb10x_gpio_to_irq;
> +               tb10x_gpio->irq         = ret;
> +               ret = request_irq(ret, tb10x_gpio_irq_cascade,

Use devm_request_irq().

> +                               IRQF_TRIGGER_FALLING | IRQF_SHARED,
> +                               dev_name(&pdev->dev), tb10x_gpio);
> +               if (ret != 0)
> +                       goto fail_request_irq;
> +
> +               tb10x_gpio->domain = irq_domain_add_linear(dn,
> +                                               tb10x_gpio->gr.npins,
> +                                               &irq_tb10x_gpio_domain_ops,
> +                                               tb10x_gpio);
> +               if (!tb10x_gpio->domain) {
> +                       ret = -ENOMEM;
> +                       goto fail_irq_domain;
> +               }
> +       }

This part looks nice!

> +fail_irq_domain:
> +       free_irq(tb10x_gpio->irq, tb10x_gpio);
> +fail_request_irq:
> +fail_get_irq:
> +       ret = gpiochip_remove(&tb10x_gpio->gc);
> +fail_gpiochip_registration:
> +fail_pinctrl_setup:
> +       iounmap(tb10x_gpio->regs);
> +fail_ioremap:
> +       release_mem_region(mem->start, resource_size(mem));
> +fail_reg_req:
> +       kfree(tb10x_gpio);

Cuts down cleanups after introducing devm_* managed resources.

> +static int __exit tb10x_gpio_remove(struct platform_device *pdev)
> +{
> +       struct tb10x_gpio *tb10x_gpio = platform_get_drvdata(pdev);
> +       struct resource *mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       int ret;
> +
> +       if (tb10x_gpio->gc.to_irq) {
> +               irq_domain_remove(tb10x_gpio->domain);
> +               free_irq(tb10x_gpio->irq, tb10x_gpio);
> +       }
> +       ret = gpiochip_remove(&tb10x_gpio->gc);
> +       if (ret)
> +               return ret;
> +
> +       iounmap(tb10x_gpio->regs);
> +       release_mem_region(mem->start, resource_size(mem));
> +       kfree(tb10x_gpio);

Dito.

> +
> +       return 0;
> +}
> +
> +static const struct of_device_id tb10x_gpio_dt_ids[] = {
> +       { .compatible = "abilis,tb10x-gpio" },

Hm here you're not using a #define for the compatible string, nice!

Yours,
Linus Walleij
