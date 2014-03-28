Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbaC1Vum (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 17:50:42 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:64824 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbaC1Vuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 17:50:40 -0400
MIME-Version: 1.0
In-Reply-To: <1395933906-2268-1-git-send-email-harinik@xilinx.com>
References: <1395933906-2268-1-git-send-email-harinik@xilinx.com>
Date: Fri, 28 Mar 2014 22:50:39 +0100
Message-ID: <CACRpkdbU35xG1QtagB+9e9vxvehf1UQFaF4PikJhsPNAMw=D1Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] GPIO: Add driver for Zynq GPIO controller
From: Linus Walleij <linus.walleij@linaro.org>
To: Harini Katakam <harinik@xilinx.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        michals@xilinx.com, Ulf Hansson <ulf.hansson@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2014 at 4:25 PM, Harini Katakam <harinik@xilinx.com> wrote:

> Add support for GPIO controller used by Xilinx Zynq
>
> Signed-off-by: Harini Katakam <harinik@xilinx.com>

This will not be integrated before v3.16 so we have some time to
think things over.

> +config GPIO_ZYNQ
> +       bool "Xilinx ZYNQ GPIO support"
> +       depends on ARCH_ZYNQ
> +       select GENERIC_IRQ_CHIP

I think that rather than selecting GENERIC_IRQ_CHIP,
select my new GPIOLIB_IRQCHIP and use the new helpers
gpiochip_irqchip_add() and gpiochip_set_chained_irqchip().

Look in drivers/gpio/gpio-pl061.c for example usage.

This is available in the "devel" or "for-next" branch of my
gpio tree at
https://git.kernel.org/cgit/linux/kernel/git/linusw/linux-gpio.git/

> +#include <linux/clk.h>
> +#include <linux/gpio.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/irq.h>
> +#include <linux/irqchip/chained_irq.h>
> +#include <linux/irqdomain.h>

These three are auto-included with GPIOLIB_IRQCHIP.

> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/pm_runtime.h>
> +
> +#define DRIVER_NAME "zynq-gpio"
> +#define ZYNQ_GPIO_NR_GPIOS     118
> +
> +static struct irq_domain *irq_domain;

Static global variables are a no-no. This goes away with
GPIOLIB_IRQCHIP, but read about state containers in
Documentation/driver-model/design-patterns.txt

> +/* Read/Write access to the GPIO PS registers */
> +static inline u32 zynq_gpio_readreg(void __iomem *offset)
> +{
> +       return readl_relaxed(offset);
> +}
> +
> +static inline void zynq_gpio_writereg(void __iomem *offset, u32 val)
> +{
> +       writel_relaxed(val, offset);
> +}

I think this is unnecessary and confusing indirection.
Just use the readl_relaxed/writel_relaxed functions directly in
the code.

> +static unsigned int zynq_gpio_pin_table[] = {
> +       31, /* 0 - 31 */
> +       53, /* 32 - 53 */
> +       85, /* 54 - 85 */
> +       117 /* 86 - 117 */
> +};

This is an indication that you may be writing a pin control
driver rather than a GPIO driver. Please consule
Documentation/pinctrl.txt for a brief overview of what we
mean by this.

> +/* Maximum banks */
> +#define ZYNQ_GPIO_MAX_BANK     4
> +
> +/* Disable all interrupts mask */
> +#define ZYNQ_GPIO_IXR_DISABLE_ALL      0xFFFFFFFF
> +
> +/* GPIO pin high */
> +#define ZYNQ_GPIO_PIN_HIGH 1

This looks like pin config business.

> +/* Mid pin number of a bank */
> +#define ZYNQ_GPIO_MID_PIN_NUM 16
> +
> +/* GPIO upper 16 bit mask */
> +#define ZYNQ_GPIO_UPPER_MASK 0xFFFF0000
> +
> +/**
> + * struct zynq_gpio - gpio device private data structure
> + * @chip:      instance of the gpio_chip
> + * @base_addr: base address of the GPIO device
> + * @irq:       irq associated with the controller
> + * @irq_base:  base of IRQ number for interrupt
> + * @clk:       clock resource for this controller
> + */
> +struct zynq_gpio {
> +       struct gpio_chip chip;
> +       void __iomem *base_addr;
> +       unsigned int irq;
> +       unsigned int irq_base;

Using a base offset for IRQs is just wrong if you're using irqdomain.
BTW you will be using chip->irqdomain after converting to
GPIOLIB_IRQCHIP.

> +       struct clk *clk;
> +};
> +
> +/**
> + * zynq_gpio_get_bank_pin - Get the bank number and pin number within that bank
> + * for a given pin in the GPIO device
> + * @pin_num:   gpio pin number within the device
> + * @bank_num:  an output parameter used to return the bank number of the gpio
> + *             pin
> + * @bank_pin_num: an output parameter used to return pin number within a bank
> + *               for the given gpio pin
> + *
> + * Returns the bank number.
> + */
> +static inline void zynq_gpio_get_bank_pin(unsigned int pin_num,
> +                                         unsigned int *bank_num,
> +                                         unsigned int *bank_pin_num)
> +{
> +       for (*bank_num = 0; *bank_num < ZYNQ_GPIO_MAX_BANK; (*bank_num)++)
> +               if (pin_num <= zynq_gpio_pin_table[*bank_num])
> +                       break;
> +
> +       if (!(*bank_num))
> +               *bank_pin_num = pin_num;
> +       else
> +               *bank_pin_num = pin_num %
> +                               (zynq_gpio_pin_table[*bank_num - 1] + 1);
> +}

This is reimplementing gpio ranges from the pin control
subsystem. Consult e.g.
drivers/pinctrl/pinctrl-baytrail.c

For another simple driver using GPIO ranges from pin control
for this. And implement it that way.

> +/**
> + * zynq_gpio_get_value - Get the state of the specified pin of GPIO device
> + * @chip:      gpio_chip instance to be worked on
> + * @pin:       gpio pin number within the device
> + *
> + * This function reads the state of the specified pin of the GPIO device.
> + *
> + * Return: 0 if the pin is low, 1 if pin is high.
> + */
> +static int zynq_gpio_get_value(struct gpio_chip *chip, unsigned int pin)
> +{
> +       unsigned int bank_num, bank_pin_num, data;
> +       struct zynq_gpio *gpio = container_of(chip, struct zynq_gpio, chip);
> +
> +       zynq_gpio_get_bank_pin(pin, &bank_num, &bank_pin_num);
> +
> +       data = zynq_gpio_readreg(gpio->base_addr +
> +                                ZYNQ_GPIO_DATA_OFFSET(bank_num));
> +       return (data >> bank_pin_num) & ZYNQ_GPIO_PIN_HIGH;
> +}

Instead of fiddling around with the banks like this, consider registering
one gpiochip per bank, so one instance of the device per bank, and
be done with it. Maybe it's hard to do that so not a firm requirement,
but think about it.

(...)
> +/**
> + * zynq_gpio_dir_in - Set the direction of the specified GPIO pin as input
> + * @chip:      gpio_chip instance to be worked on
> + * @pin:       gpio pin number within the device
> + *
> + * This function uses the read-modify-write sequence to set the direction of
> + * the gpio pin as input.
> + *
> + * Return: 0 always
> + */
> +static int zynq_gpio_dir_in(struct gpio_chip *chip, unsigned int pin)
> +{
> +       unsigned int reg, bank_num, bank_pin_num;
> +       struct zynq_gpio *gpio = container_of(chip, struct zynq_gpio, chip);
> +
> +       zynq_gpio_get_bank_pin(pin, &bank_num, &bank_pin_num);
> +       /* clear the bit in direction mode reg to set the pin as input */
> +       reg = zynq_gpio_readreg(gpio->base_addr +
> +                               ZYNQ_GPIO_DIRM_OFFSET(bank_num));
> +       reg &= ~(1 << bank_pin_num);

In such cases I usually do:

#include <linux/bitops.h>

reg &= ~BIT(bank_pin_num);

(Applied everywhere.)

(...)
> +/**
> + * zynq_gpio_dir_out - Set the direction of the specified GPIO pin as output
> + * @chip:      gpio_chip instance to be worked on
> + * @pin:       gpio pin number within the device
> + * @state:     value to be written to specified pin
> + *
> + * This function sets the direction of specified GPIO pin as output, configures
> + * the Output Enable register for the pin and uses zynq_gpio_set to set
> + * the state of the pin to the value specified.
> + *
> + * Return: 0 always
> + */
> +static int zynq_gpio_dir_out(struct gpio_chip *chip, unsigned int pin,
> +                            int state)
> +{
> +       struct zynq_gpio *gpio = container_of(chip, struct zynq_gpio, chip);
> +       unsigned int reg, bank_num, bank_pin_num;
> +
> +       zynq_gpio_get_bank_pin(pin, &bank_num, &bank_pin_num);
> +
> +       /* set the GPIO pin as output */
> +       reg = zynq_gpio_readreg(gpio->base_addr +
> +                               ZYNQ_GPIO_DIRM_OFFSET(bank_num));
> +       reg |= 1 << bank_pin_num;

Like here:
reg |= BIT(bank_pin_num);

> +static int zynq_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
> +{
> +       return irq_find_mapping(irq_domain, offset);
> +}

Goes away with GPIOLIB_IRQCHIP which does this in the
gpiolib.

(...)
> +/**
> + * zynq_gpio_irqhandler - IRQ handler for the gpio banks of a gpio device
> + * @irq:       irq number of the gpio bank where interrupt has occurred
> + * @desc:      irq descriptor instance of the 'irq'
> + *
> + * This function reads the Interrupt Status Register of each bank to get the
> + * gpio pin number which has triggered an interrupt. It then acks the triggered
> + * interrupt and calls the pin specific handler set by the higher layer
> + * application for that pin.
> + * Note: A bug is reported if no handler is set for the gpio pin.
> + */
> +static void zynq_gpio_irqhandler(unsigned int irq, struct irq_desc *desc)
> +{
> +       struct zynq_gpio *gpio = (struct zynq_gpio *)irq_get_handler_data(irq);
> +       int gpio_irq = gpio->irq_base;

Using a base offset for the IRQ goes totally against the idea of
using an irqdomain!

> +       unsigned int int_sts, int_enb, bank_num;
> +       struct irq_desc *gpio_irq_desc;
> +       struct irq_chip *chip = irq_desc_get_chip(desc);
> +
> +       chained_irq_enter(chip, desc);
> +
> +       for (bank_num = 0; bank_num < ZYNQ_GPIO_MAX_BANK; bank_num++) {
> +               int_sts = zynq_gpio_readreg(gpio->base_addr +
> +                                           ZYNQ_GPIO_INTSTS_OFFSET(bank_num));
> +               int_enb = zynq_gpio_readreg(gpio->base_addr +
> +                                           ZYNQ_GPIO_INTMASK_OFFSET(bank_num));
> +               int_sts &= ~int_enb;
> +
> +               for (; int_sts != 0; int_sts >>= 1, gpio_irq++) {

Here increase from zero on the offset, then use
irq_find_mapping() to translate the hwirq to a Linux IRQ.

> +                       if (!(int_sts & 1))
> +                               continue;
> +                       gpio_irq_desc = irq_to_desc(gpio_irq);
> +                       BUG_ON(!gpio_irq_desc);
> +                       chip = irq_desc_get_chip(gpio_irq_desc);
> +                       BUG_ON(!chip);
> +                       chip->irq_ack(&gpio_irq_desc->irq_data);
> +
> +                       /* call the pin specific handler */
> +                       generic_handle_irq(gpio_irq);
> +               }
> +               /* shift to first virtual irq of next bank */
> +               gpio_irq = gpio->irq_base + zynq_gpio_pin_table[bank_num] + 1;

This is also pretty convoluted. Are you sure you don't want to
implement one gpiochip per bank instead? I guess the final "+1"
means there is actually one IRQ per bank even?

> +       }
> +
> +       chip = irq_desc_get_chip(desc);
> +       chained_irq_exit(chip, desc);
> +}

(...)
> +static int zynq_gpio_request(struct gpio_chip *chip, unsigned offset)
> +{
> +       int ret;
> +
> +       ret = pm_runtime_get_sync(chip->dev);
> +
> +       /*
> +        * If the device is already active pm_runtime_get() will return 1 on
> +        * success, but gpio_request still needs to return 0.
> +        */
> +       return ret < 0 ? ret : 0;
> +}
> +
> +static void zynq_gpio_free(struct gpio_chip *chip, unsigned offset)
> +{
> +       pm_runtime_put_sync(chip->dev);
> +}
> +
> +static const struct dev_pm_ops zynq_gpio_dev_pm_ops = {
> +       SET_SYSTEM_SLEEP_PM_OPS(zynq_gpio_suspend, zynq_gpio_resume)
> +       SET_RUNTIME_PM_OPS(zynq_gpio_runtime_suspend, zynq_gpio_runtime_resume,
> +                          zynq_gpio_idle)
> +};

Is this runtime PM implementation aligned with Ulf Hansson's recent
new helpers to simplify suspend+runtime PM coexistance?

> +/**
> + * zynq_gpio_probe - Initialization method for a zynq_gpio device
> + * @pdev:      platform device instance
> + *
> + * This function allocates memory resources for the gpio device and registers
> + * all the banks of the device. It will also set up interrupts for the gpio
> + * pins.
> + * Note: Interrupts are disabled for all the banks during initialization.
> + *
> + * Return: 0 on success, negative error otherwise.
> + */
> +static int zynq_gpio_probe(struct platform_device *pdev)
> +{
> +       int ret, pin_num, bank_num, gpio_irq;
> +       unsigned int irq_num;
> +       struct zynq_gpio *gpio;
> +       struct gpio_chip *chip;
> +       struct resource *res;
> +
> +       gpio = devm_kzalloc(&pdev->dev, sizeof(*gpio), GFP_KERNEL);
> +       if (!gpio)
> +               return -ENOMEM;
> +
> +       platform_set_drvdata(pdev, gpio);
> +
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       gpio->base_addr = devm_ioremap_resource(&pdev->dev, res);
> +       if (IS_ERR(gpio->base_addr))
> +               return PTR_ERR(gpio->base_addr);
> +
> +       irq_num = platform_get_irq(pdev, 0);
> +       gpio->irq = irq_num;

>From the code I get the sense that you are passing a single
IRQ as resource but there are actually as many IRQs as there
are banks, is this correct? Then pass *all* IRQs as resources.

> +
> +       /* configure the gpio chip */
> +       chip = &gpio->chip;
> +       chip->label = "zynq_gpio";
> +       chip->owner = THIS_MODULE;
> +       chip->dev = &pdev->dev;
> +       chip->get = zynq_gpio_get_value;
> +       chip->set = zynq_gpio_set_value;
> +       chip->request = zynq_gpio_request;
> +       chip->free = zynq_gpio_free;
> +       chip->direction_input = zynq_gpio_dir_in;
> +       chip->direction_output = zynq_gpio_dir_out;
> +       chip->to_irq = zynq_gpio_to_irq;

Not needed with GPIOLIB_IRQCHIP

> +       chip->dbg_show = NULL;
> +       chip->base = 0;         /* default pin base */

The GPIO numberspace is not the same as the pin number space.
This is only going to work if you have no other GPIO controllers
on your system. Use -1 as base so you get dynamic allocation
of a GPIO number range instead.

Make sure to use the new descriptor API for defining and accessing
GPIOs in all drivers and it will not matter which base you get.
(Good eh? :-)

As it appears you're using device tree, it is all transparent and
you need not worry.

> +       chip->ngpio = ZYNQ_GPIO_NR_GPIOS;
> +       chip->can_sleep = 0;
> +

>From here:

> +       gpio->irq_base = irq_alloc_descs(-1, 0, chip->ngpio, 0);
> +       if (gpio->irq_base < 0) {
> +               dev_err(&pdev->dev, "Couldn't allocate IRQ numbers\n");
> +               return -ENODEV;
> +       }
> +
> +       irq_domain = irq_domain_add_legacy(pdev->dev.of_node,
> +                                          chip->ngpio, gpio->irq_base, 0,
> +                                          &irq_domain_simple_ops, NULL);

To here, goes away with GPIOLIB_IRQCHIP

> +
> +       /* report a bug if gpio chip registration fails */
> +       ret = gpiochip_add(chip);
> +       if (ret < 0)
> +               return ret;
> +
> +       /* Enable GPIO clock */
> +       gpio->clk = devm_clk_get(&pdev->dev, NULL);
> +       if (IS_ERR(gpio->clk)) {
> +               dev_err(&pdev->dev, "input clock not found.\n");
> +               if (gpiochip_remove(chip))
> +                       dev_err(&pdev->dev, "Failed to remove gpio chip\n");
> +               return PTR_ERR(gpio->clk);
> +       }
> +       ret = clk_prepare_enable(gpio->clk);
> +       if (ret) {
> +               dev_err(&pdev->dev, "Unable to enable clock.\n");
> +               if (gpiochip_remove(chip))
> +                       dev_err(&pdev->dev, "Failed to remove gpio chip\n");
> +               return ret;
> +       }

You should probably get and enable the clock *before* you add the
gpiochip.

> +       /* disable interrupts for all banks */
> +       for (bank_num = 0; bank_num < ZYNQ_GPIO_MAX_BANK; bank_num++) {
> +               zynq_gpio_writereg(gpio->base_addr +
> +                                  ZYNQ_GPIO_INTDIS_OFFSET(bank_num),
> +                                  ZYNQ_GPIO_IXR_DISABLE_ALL);
> +       }

>From here:

> +       /*
> +        * set the irq chip, handler and irq chip data for callbacks for
> +        * each pin
> +        */
> +       for (pin_num = 0; pin_num < min_t(int, ZYNQ_GPIO_NR_GPIOS,
> +                                         (int)chip->ngpio); pin_num++) {
> +               gpio_irq = irq_find_mapping(irq_domain, pin_num);
> +               irq_set_chip_and_handler(gpio_irq, &zynq_gpio_irqchip,
> +                                        handle_simple_irq);
> +               irq_set_chip_data(gpio_irq, (void *)gpio);
> +               set_irq_flags(gpio_irq, IRQF_VALID);
> +       }
> +
> +       irq_set_handler_data(irq_num, (void *)gpio);
> +       irq_set_chained_handler(irq_num, zynq_gpio_irqhandler);

To here goes away with GPIOLIB_IRQCHIP

> +/**
> + * zynq_gpio_remove - Driver removal function
> + * @pdev:      platform device instance
> + *
> + * Return: 0 always
> + */
> +static int zynq_gpio_remove(struct platform_device *pdev)
> +{
> +       struct zynq_gpio *gpio = platform_get_drvdata(pdev);
> +
> +       clk_disable_unprepare(gpio->clk);
> +       device_set_wakeup_capable(&pdev->dev, 0);
> +       return 0;

You forgot to remove the gpiochip.

Yours,
Linus Walleij
