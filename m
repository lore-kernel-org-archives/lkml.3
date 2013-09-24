Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab3IXMwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 08:52:54 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:61930 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab3IXMwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 08:52:50 -0400
MIME-Version: 1.0
In-Reply-To: <1380023921-29867-3-git-send-email-ldewangan@nvidia.com>
References: <1380023921-29867-1-git-send-email-ldewangan@nvidia.com>
	<1380023921-29867-3-git-send-email-ldewangan@nvidia.com>
Date: Tue, 24 Sep 2013 14:52:48 +0200
Message-ID: <CACRpkda3m4ipTsS8FZoU1QDwrvwmKFn4awyfXOy2VOiuV63y6A@mail.gmail.com>
Subject: Re: [rtc-linux] [PATCH V3 2/3] pincntrl: add support for AMS AS3722
 pin control driver
From: Linus Walleij <linus.walleij@linaro.org>
To: "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Rob Landley <rob@landley.net>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Florian Lobmaier <florian.lobmaier@ams.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 1:58 PM, Laxman Dewangan <ldewangan@nvidia.com> wrote:
> The AS3722 is a compact system PMU suitable for mobile phones, tablets etc.
>
> Add a driver to support accessing the GPIO, pinmux and pin configuration
> of 8 GPIO pins found on the AMS AS3722 through pin control driver and
> gpiolib.
>
> The driver will register itself as the pincontrol driver and gpio driver.
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> Signed-off-by: Florian Lobmaier <florian.lobmaier@ams.com>

That was quick! :-)

This is starting to look a lot better.

> +static int as3722_pinconf_group_get(struct pinctrl_dev *pctldev,
> +                               unsigned group, unsigned long *config)
> +{
> +       dev_err(pctldev->dev, "as3722_pinconf_group_get op not supported\n");
> +       return -ENOTSUPP;
> +}
> +
> +static int as3722_pinconf_group_set(struct pinctrl_dev *pctldev,
> +                               unsigned group, unsigned long *configs,
> +                               unsigned num_configs)
> +{
> +       dev_err(pctldev->dev, "as3722_pinconf_group_set op not supported\n");
> +       return -ENOTSUPP;
> +}
> +
> +static const struct pinconf_ops as3722_pinconf_ops = {
> +       .pin_config_get = as3722_pinconf_get,
> +       .pin_config_set = as3722_pinconf_set,
> +       .pin_config_group_get = as3722_pinconf_group_get,
> +       .pin_config_group_set = as3722_pinconf_group_set,

Can't you just leave .pin_config_group_[get|set] undefined as
you don't support that?

> +static struct pinctrl_desc as3722_pinctrl_desc = {
> +       .pctlops = (struct pinctrl_ops *)&as3722_pinctrl_ops,
> +       .pmxops = (struct pinmux_ops *)&as3722_pinmux_ops,
> +       .confops = (struct pinconf_ops *)&as3722_pinconf_ops,

Why do you need these casts? Should not be necessary.

> +static int as_pci_direction_input(struct gpio_chip *chip, unsigned offset)
> +{
> +       struct as3722_pctrl_info *as_pci = to_as_pci(chip);
> +       struct as3722 *as3722 = as_pci->as3722;
> +       int mode;
> +
> +       mode = as_pci_get_mode(as_pci->gpio_control[offset].mode_prop,
> +                       true);
> +       if (mode < 0) {
> +               dev_err(as_pci->dev,
> +                       "Input direction for GPIO %d not supported\n", offset);
> +               return mode;
> +       }
> +
> +       if (as_pci->gpio_control[offset].enable_gpio_invert)
> +               mode |= AS3722_GPIO_INV;
> +
> +       return as3722_write(as3722, AS3722_GPIOn_CONTROL_REG(offset), mode);
> +}

Why is this function not calling
pinctrl_gpio_direction_input(chip->base + offset) instea of setting up
the mode intself?

The GPIO part of the driver should use the pinctrl part of the
driver as back-end.

> +static int as_pci_direction_output(struct gpio_chip *chip,
> +               unsigned offset, int value)
> +{
> +       struct as3722_pctrl_info *as_pci = to_as_pci(chip);
> +       struct as3722 *as3722 = as_pci->as3722;
> +       int mode;
> +
> +       mode = as_pci_get_mode(as_pci->gpio_control[offset].mode_prop,
> +                       false);
> +       if (mode < 0) {
> +               dev_err(as_pci->dev,
> +                       "Output direction for GPIO %d not supported\n", offset);
> +               return mode;
> +       }
> +
> +       as_pci_set(chip, offset, value);
> +       if (as_pci->gpio_control[offset].enable_gpio_invert)
> +               mode |= AS3722_GPIO_INV;
> +       return as3722_write(as3722, AS3722_GPIOn_CONTROL_REG(offset), mode);
> +}

Dito:
pinctrl_gpio_direction_output()

> +static int as_pci_to_irq(struct gpio_chip *chip, unsigned offset)
> +{
> +       struct as3722_pctrl_info *as_pci = to_as_pci(chip);
> +
> +       return as3722_irq_get_virq(as_pci->as3722, offset);
> +}
> +
> +static int as_pci_request(struct gpio_chip *chip, unsigned offset)
> +{
> +       struct as3722_pctrl_info *as_pci = to_as_pci(chip);
> +
> +       if (as_pci->gpio_control[offset].io_function)
> +               return -EBUSY;
> +       return 0;
> +}

Why is this not calling pinctrl_request_gpio(as_pci->chip.base + offset)
instead of just checking if we happen to be GPIO and failing if
we are not?

I would implement .free calling pinctrl_free_gpio(gpio) as well.

See e.g. pinctrl-abx500.c

> +static const struct gpio_chip as_pci_chip = {
> +       .label                  = "as3722-gpio",
> +       .owner                  = THIS_MODULE,
> +       .direction_input        = as_pci_direction_input,
> +       .get                    = as_pci_get,
> +       .direction_output       = as_pci_direction_output,
> +       .set                    = as_pci_set,
> +       .to_irq                 = as_pci_to_irq,
> +       .request                = as_pci_request,
> +       .can_sleep              = 1,
> +       .ngpio                  = AS3722_PIN_NUM,
> +       .base                   = -1,
> +};
> +
> +static int as3722_pinctrl_probe(struct platform_device *pdev)
> +{
> +       struct as3722_pctrl_info *as_pci;
> +       int ret;
> +
> +       as_pci = devm_kzalloc(&pdev->dev, sizeof(*as_pci), GFP_KERNEL);
> +       if (!as_pci)
> +               return -ENOMEM;
> +
> +       as_pci->dev = &pdev->dev;
> +       as_pci->dev->of_node = pdev->dev.parent->of_node;
> +       as_pci->as3722 = dev_get_drvdata(pdev->dev.parent);
> +       platform_set_drvdata(pdev, as_pci);
> +
> +       as_pci->pins = as3722_pins_desc;
> +       as_pci->num_pins = ARRAY_SIZE(as3722_pins_desc);
> +       as_pci->functions = as3722_pin_function;
> +       as_pci->num_functions = ARRAY_SIZE(as3722_pin_function);
> +       as_pci->pin_groups = as3722_pingroups;
> +       as_pci->num_pin_groups = ARRAY_SIZE(as3722_pingroups);
> +       as3722_pinctrl_desc.name = dev_name(&pdev->dev);
> +       as3722_pinctrl_desc.pins = as3722_pins_desc;
> +       as3722_pinctrl_desc.npins = ARRAY_SIZE(as3722_pins_desc);
> +       as_pci->pctl = pinctrl_register(&as3722_pinctrl_desc,
> +                                       &pdev->dev, as_pci);
> +       if (!as_pci->pctl) {
> +               dev_err(&pdev->dev, "Couldn't register pinctrl driver\n");
> +               return -ENODEV;
> +       }
> +
> +       as_pci->gpio_chip = as_pci_chip;
> +       as_pci->gpio_chip.dev = &pdev->dev;
> +       as_pci->gpio_chip.of_node = pdev->dev.parent->of_node;
> +       ret = gpiochip_add(&as_pci->gpio_chip);
> +       if (ret < 0) {
> +               dev_err(&pdev->dev, "Could not register gpiochip, %d\n", ret);
> +               goto scrub;
> +       }

Right here you should register a GPIO range using
gpiochip_add_pin_range() so that all calls from the gpio_chip
side can happily fall through to the pinctrl driver and set up
pins as GPIO.

It's very nice how you contained the driver in one state container.

Yours,
Linus Walleij
