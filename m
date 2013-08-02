Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297Ab3HBLfQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 07:35:16 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:63368 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750740Ab3HBLfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 07:35:14 -0400
Date: Fri, 2 Aug 2013 12:34:40 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4] gpio: Add MOXA ART GPIO driver
Message-ID: <20130802113440.GJ2884@e106331-lin.cambridge.arm.com>
References: <1374053693-6166-1-git-send-email-jonas.jensen@gmail.com>
 <1375103161-12460-1-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375103161-12460-1-git-send-email-jonas.jensen@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 02:06:01PM +0100, Jonas Jensen wrote:
> Add GPIO driver for MOXA ART SoCs.
> 
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
> ---
> 
> Notes:
>     Changes since v3:
> 
>     1. use local struct device *dev pointer, replace "&pdev->dev" with "dev"
> 
>     device tree bindings document:
>     2. describe compatible variable "Must be" instead of "Should be".
> 
>     Applies to next-20130729
> 
>  .../devicetree/bindings/gpio/moxa,moxart-gpio.txt  |  23 +++
>  drivers/gpio/Kconfig                               |   7 +
>  drivers/gpio/Makefile                              |   1 +
>  drivers/gpio/gpio-moxart.c                         | 189 +++++++++++++++++++++
>  4 files changed, 220 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/gpio/moxa,moxart-gpio.txt
>  create mode 100644 drivers/gpio/gpio-moxart.c
> 
> diff --git a/Documentation/devicetree/bindings/gpio/moxa,moxart-gpio.txt b/Documentation/devicetree/bindings/gpio/moxa,moxart-gpio.txt
> new file mode 100644
> index 0000000..795afab
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/gpio/moxa,moxart-gpio.txt
> @@ -0,0 +1,23 @@
> +MOXA ART GPIO Controller
> +
> +Required properties:
> +
> +- #gpio-cells : Should be 2

Could you elaborate on what those cells represent?

> +- compatible : Must be "moxa,moxart-gpio"
> +- reg : Should contain registers location and length
> +       index 0 : input, output, and direction control
> +       index 1 : enable/disable individual pins, pin 0-31

These seem rather fine-grained. Are they not part of a larger bank of
registers? The example seems to indicate otherwise, but I don't trust
examples :)

> +- gpio-ready-led : ready LED gpio, with zero flags
> +- gpio-reset-switch : reset switch gpio, with zero flags

I'm not sure about these. It feels odd for the gpio node to refer to
itself in this way. Why is the use of these gpios a concern of the gpio
controller. Surely an external user described elsewhere in dt will be
assigned these (even if it's general platform code rather than a
specific hardware driver)?

I thought there were some conventions for gpio-driven LEDs...

Also, I believe the convention is to have ${NAME}-gpios, or just gpios.

[...]

> +static int moxart_gpio_probe(struct platform_device *pdev)
> +{
> +       struct device *dev = &pdev->dev;
> +       struct resource *res;
> +       int ret, gpio_ready_led, gpio_reset_switch;
> +
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       moxart_gpio_base = devm_ioremap_resource(dev, res);
> +       if (IS_ERR(moxart_gpio_base)) {
> +               dev_err(dev, "%s: devm_ioremap_resource res_gpio failed\n",
> +                       dev->of_node->full_name);
> +               return PTR_ERR(moxart_gpio_base);
> +       }
> +
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +       moxart_pincontrol_base = devm_ioremap_resource(dev, res);
> +       if (IS_ERR(moxart_pincontrol_base)) {
> +               dev_err(dev, "%s: devm_ioremap_resource res_pmu failed\n",
> +                       dev->of_node->full_name);
> +               return PTR_ERR(moxart_pincontrol_base);
> +       }
> +
> +       moxart_gpio_chip.dev = dev;
> +
> +       ret = gpiochip_add(&moxart_gpio_chip);
> +       if (ret)
> +               dev_err(dev, "%s: gpiochip_add failed\n",
> +                       dev->of_node->full_name);
> +
> +
> +       gpio_ready_led = of_get_named_gpio(dev->of_node,
> +                                          "gpio-ready-led", 0);
> +       if (!gpio_is_valid(gpio_ready_led)) {
> +               dev_err(dev, "invalid gpio (gpio-ready-led): %d\n",
> +                       gpio_ready_led);
> +               return gpio_ready_led;
> +       }
> +
> +       gpio_reset_switch = of_get_named_gpio(dev->of_node,
> +                                             "gpio-reset-switch", 0);
> +       if (!gpio_is_valid(gpio_reset_switch)) {
> +               dev_err(dev, "invalid gpio (gpio-reset-switch): %d\n",
> +                       gpio_reset_switch);
> +               return gpio_reset_switch;
> +       }
> +
> +       moxart_gpio_enable(gpio_ready_led | gpio_reset_switch);
> +
> +       moxart_gpio_direction_input(&moxart_gpio_chip, gpio_reset_switch);

We never seem to do anything else with the reset switch. Is it used
elsewhere? Surely the "real" user should call in to initialise this.

> +
> +       /*
> +        * gpio_ready_led=0 ready LED on
> +        * gpio_ready_led=1 ready LED off
> +        */
> +       moxart_gpio_direction_output(&moxart_gpio_chip, gpio_ready_led, 0);
> +       moxart_gpio_set(&moxart_gpio_chip, gpio_ready_led, 0);
> +
> +       return 0;
> +}
> +
> +static const struct of_device_id moxart_gpio_match[] = {
> +       { .compatible = "moxa,moxart-gpio" },
> +       { }
> +};
> +
> +static struct platform_driver moxart_gpio_driver = {
> +       .driver = {
> +               .name           = "moxart-gpio",
> +               .owner          = THIS_MODULE,
> +               .of_match_table = moxart_gpio_match,
> +       },
> +       .probe  = moxart_gpio_probe,
> +};
> +
> +static int __init moxart_gpio_init(void)
> +{
> +       return platform_driver_register(&moxart_gpio_driver);
> +}
> +
> +postcore_initcall(moxart_gpio_init);
> +
> +MODULE_DESCRIPTION("MOXART GPIO chip driver");
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Jonas Jensen <jonas.jensen@gmail.com>");
> --
> 1.8.2.1
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
