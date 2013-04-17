Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966763Ab3DQOs6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 10:48:58 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:56457 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966531Ab3DQOs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 10:48:56 -0400
MIME-Version: 1.0
In-Reply-To: <1365608728-30494-1-git-send-email-christian.ruppert@abilis.com>
References: <1365608728-30494-1-git-send-email-christian.ruppert@abilis.com>
Date: Wed, 17 Apr 2013 16:48:55 +0200
Message-ID: <CACRpkdbTwqTijFcYSwmb-pzRwc8NqA4NAAC3KsBn+NRA1hne3w@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinmux: Add TB10x pinmux driver
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

> The pinmux driver of the Abilis Systems TB10x platform based on ARC700 CPUs.
> Used to control the pinmux and is a prerequisite for the GPIO driver.
>
> Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
> Signed-off-by: Pierrick Hascoet <pierrick.hascoet@abilis.com>

Please include Stephen Warren on cc for checking DT bindings for these
things, I feel a bit uncertain about such things time to time.

(...)
> +++ b/Documentation/devicetree/bindings/pinctrl/abilis,tb10x-iomux.txt
(...)
> +In case a driver requires a port to be mapped, the corresponding node should
> +be compatible with "abilis,simple-pinctrl" and define a pinctrl state named
> +"abilis,simple-default" pointing to the port's respective node inside the pin
> +controller.

Oh um.... I don't understand this.

> + Drivers managing pin controller states internally can be
> +configured normally as described in the pinctrl-bindings.txt.

I don't understand this either.

Do you mean this is opposed to using hogs or something?

Have your familiarized yourself with commit
ab78029ecc347debbd737f06688d788bd9d60c1d
"drivers/pinctrl: grab default handles from device core"
?

> +The pinmux driver is connected to the TB10x GPIO driver in a way that a GPIO
> +node managing a GPIO port can point to the respective pinmux subnode using
> +the gpio-pins property

NAK - this sounds like you're reinventing the GPIO ranges.

See:
Documentation/devicetree/bindings/gpio/gpio.txt, section
2.1) gpio-controller and pinctrl subsystem


> +Example
> +-------
> +
> +iomux: iomux@FF10601c {
> +       #address-cells = <1>;
> +       #size-cells = <1>;
> +       compatible = "abilis,tb10x-iomux";
> +       reg = <0xFF10601c 0x4>;
> +       pctl_gpio_a: pctl-gpio-a {
> +               pingrp = "gpioa_pins";
> +       };
> +       pctl_uart0: pctl-uart0 {
> +               pingrp = "uart0_pins";
> +       };
> +};
> +uart@FF100000 {
> +       compatible = "snps,dw-apb-uart",
> +                       "abilis,simple-pinctrl";

Why do you need this compatible property,
abilis,simple-pinctrl? And what is simple about it?

> +       reg = <0xFF100000 0x100>;
> +       clock-frequency = <166666666>;
> +       interrupts = <25 1>;
> +       reg-shift = <2>;
> +       reg-io-width = <4>;
> +       pinctrl-names = "abilis,simple-default";  /* <<<<<<<< */
> +       pinctrl-0 = <&pctl_uart0>;                /* <<<<<<<< */

I suggest you just put the name of the states into pinctrl-names
pinctrl-names = "default";

> +gpioa: gpio@FF140000 {
> +       compatible = "abilis,tb10x-gpio";
> +       reg = <0xFF140000 0x1000>;
> +       gpio-controller;
> +       #gpio-cells = <1>;
> +       gpio-count = <3>;
> +       gpio-base  = <0>;
> +       gpio-pins = <&pctl_gpio_a>;               /* <<<<<<<< */

And why doesn't this need a name?

(...)
> diff --git a/drivers/pinctrl/pinctrl-tb10x.c b/drivers/pinctrl/pinctrl-tb10x.c

> +#include <linux/stringify.h>
> +#include <linux/pinctrl/pinctrl.h>
> +#include <linux/pinctrl/pinmux.h>
> +#include <linux/pinctrl/machine.h>
> +#include <linux/platform_device.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/of.h>
> +#include <linux/slab.h>
> +#include <linux/pinctrl/pinctrl-tb10x.h>

No, put that into <linux/platform_data/pinctrl-tb10x.h>

> +static const struct pinctrl_pin_desc tb10x_pins[] = {
> +       /* Port 1 */
> +       PINCTRL_PIN(0 +  0, "MICLK_S0"),
> +       PINCTRL_PIN(0 +  1, "MISTRT_S0"),
> +       PINCTRL_PIN(0 +  2, "MIVAL_S0"),
> +       PINCTRL_PIN(0 +  3, "MDI_S0"),
> +       PINCTRL_PIN(0 +  4, "GPIOA0"),
> +       PINCTRL_PIN(0 +  5, "GPIOA1"),
> +       PINCTRL_PIN(0 +  6, "GPIOA2"),
> +       PINCTRL_PIN(0 +  7, "MDI_S1"),
> +       PINCTRL_PIN(0 +  8, "MIVAL_S1"),
> +       PINCTRL_PIN(0 +  9, "MISTRT_S1"),
> +       PINCTRL_PIN(0 + 10, "MICLK_S1"),

If you're using an offset like that in every such macro,
use a #define for the offset, like


#define TB10X_PORT0 0
#define TB10X_PORT1 16

Then

PINCTRL_PIN(TB10X_PORT0 +  0, "MICLK_S0"),

start to mean something when reading it.

(...)
> +/* Port 1 */
> +static const unsigned mis0_pins[]  = { 0,  1,  2,  3};
> +static const unsigned gpioa_pins[] = { 4,  5,  6};
> +static const unsigned mis1_pins[]  = { 7,  8,  9, 10};
> +static const unsigned mip1_pins[]  = { 0,  1,  2,  3,  4,  5,
> +                                       6,  7,  8,  9, 10};

Likewise you should use the same #defines here I guess.

static const unsigned mis0_pins[]  = { TB10X_PORT0 + 0,  TB10X_PORT0 + 1,
                                                        TB10X_PORT0 +
2, TB10X_PORT0 + 3};

An alternative is to just drop the offset everywhere above, but it needs
to be consistent. Do it one way: either offsets everywhere or just
plain numbers everywhere, not a mixture like now.

(...)
> +struct tb10x_pinctrl_state {

Usually I just call such structs "tb10x", it's quite clear
from the code that it stores the state.

> +       struct pinctrl_dev *pctl;
> +       void *iobase;

Just "base" is more common.

> +       const struct tb10x_pinfuncgrp *pingroups;
> +       unsigned int pinfuncgrpcnt;
> +       struct tb10x_of_pinfunc *pinfuncs;
> +       unsigned int pinfuncnt;
> +       struct mutex mutex;
> +       struct {
> +               unsigned int mode;
> +               unsigned int count;
> +       } ports[TB10X_PORTS];

Why is this struct anonymous? Can't you just declare it outside this struct?

> +       DECLARE_BITMAP(gpios, MAX_PIN + 1);
> +};

This struct needs kerneldoc added to it so we understand each member.

> +struct tb10x_pinfuncgrp *tb10x_prepare_gpio_range(struct device_node *dn,
> +                                               struct pinctrl_gpio_range *gr)
> +{
> +       const char *name;
> +       int ret;
> +       struct tb10x_pinfuncgrp *pfg;
> +
> +       ret = of_property_read_string(dn, "pingrp", &name);
> +       if (ret)
> +               return ERR_PTR(ret);
> +
> +       pfg = tb10x_get_pinfuncgrp(name);
> +
> +       if (!IS_ERR(pfg)) {
> +               if (!pfg->isgpio)
> +                       return ERR_PTR(-EINVAL);
> +
> +               if (!pfg->pctl)
> +                       return ERR_PTR(-EPROBE_DEFER);
> +
> +               gr->pin_base = pfg->pins[0];
> +               gr->npins    = pfg->pincnt;
> +       }
> +
> +       return pfg;
> +}
> +EXPORT_SYMBOL(tb10x_prepare_gpio_range);

No thanks, use the ranges we have already defined and implemented
in drivers/gpio/gpiolib-of.c, function of_gpiochip_add_pin_range

And you need none of the funky special way to register ranges.

> +static inline void tb10x_pinctrl_set_config(struct tb10x_pinctrl_state *state,
> +                               unsigned int port, unsigned int mode)
> +{
> +       u32 pcfg;
> +
> +       if (state->ports[port].count)
> +               return;
> +
> +       state->ports[port].mode = mode;
> +
> +       pcfg = ioread32(state->iobase) & ~(0x3 << (2 * port));
> +       iowrite32(pcfg | ((mode & 0x3) << (2 * port)), state->iobase);
> +}

What is 0x3 above? 2*port? Please use #define for the
magic constant 3 and explain with a comment why you do *=2.

(...)
> +static int tb10x_gpio_request_enable(struct pinctrl_dev *pctl,
> +                                       struct pinctrl_gpio_range *range,
> +                                       unsigned pin)
> +{
> +       struct tb10x_pinctrl_state *state = pinctrl_dev_get_drvdata(pctl);
> +       int muxport = -1;
> +       int muxmode = -1;
> +       int i;
> +
> +       mutex_lock(&state->mutex);
> +
> +       for (i = 0; i < ARRAY_SIZE(tb10x_pingroups); i++) {
> +               struct tb10x_pinfuncgrp *pfg = &tb10x_pingroups[i];
> +               unsigned int port = pfg->port;
> +               unsigned int mode = pfg->mode;
> +               int j;
> +
> +               if (port < 0)
> +                       continue;
> +
> +               if (pfg->isgpio) {
> +                       muxport = port;
> +                       muxmode = mode;
> +                       continue;
> +               }
> +
> +               for (j = 0; j < pfg->pincnt; j++) {
> +                       if (pin == pfg->pins[j]) {
> +                               if (state->ports[port].count
> +                                       && (state->ports[port].mode == mode)) {
> +                                       mutex_unlock(&state->mutex);
> +                                       return -EBUSY;
> +                               }
> +                               break;
> +                       }
> +               }
> +       }

This looks complicated.

I suggest trying to use:

struct pinctrl_gpio_range *range =
                pinctrl_find_gpio_range_from_pin(pctldev, pin);

Then use the range to figure out which GPIO to hit.

(...)
> +static void tb10x_pctl_disable(struct pinctrl_dev *pctl,
> +                       unsigned func_selector, unsigned group_selector)
> +{
> +       struct tb10x_pinctrl_state *state = pinctrl_dev_get_drvdata(pctl);
> +       const struct tb10x_pinfuncgrp *grp = &state->pingroups[group_selector];
> +
> +       if (grp->port < 0)
> +               return;
> +
> +       mutex_lock(&state->mutex);
> +
> +       state->ports[grp->port].count--;
> +
> +       mutex_unlock(&state->mutex);
> +}


Keeping refcounts like that looks complicated.

> +static int tb10x_pinctrl_probe(struct platform_device *pdev)
> +{
> +       int ret = -EINVAL;
> +       struct resource *mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       struct device_node *of_node = pdev->dev.of_node;
> +       struct device_node *child;
> +       struct tb10x_pinctrl_state *state;
> +       int i;
> +
> +       if (!of_node) {
> +               dev_err(&pdev->dev, "No device tree node found.\n");
> +               return -EINVAL;
> +       }
> +
> +       if (!mem) {
> +               dev_err(&pdev->dev, "No memory resource defined.\n");
> +               return -EINVAL;
> +       }
> +
> +       state = kzalloc(sizeof(struct tb10x_pinctrl_state) +

Use devm_kzalloc().

> +                       of_get_child_count(of_node)
> +                       * sizeof(struct tb10x_of_pinfunc),
> +                       GFP_KERNEL);
> +       if (!state)
> +               return -ENOMEM;
> +
> +       platform_set_drvdata(pdev, state);
> +       state->pinfuncs = (struct tb10x_of_pinfunc *)(state + 1);
> +       mutex_init(&state->mutex);
> +
> +       if (!request_mem_region(mem->start, resource_size(mem), pdev->name)) {

Use devm_ioremap_resource().

> +               dev_err(&pdev->dev, "Request register region failed.\n");
> +               ret = -EBUSY;
> +               goto request_mem_fail;
> +       }
> +
> +       state->iobase = ioremap(mem->start, resource_size(mem));
> +       if (!state->iobase) {
> +               dev_err(&pdev->dev, "Request register region failed.\n");
> +               ret = -EBUSY;
> +               goto ioremap_fail;
> +       }

And that will take care of this too.

> +       state->pingroups = tb10x_pingroups;
> +       state->pinfuncgrpcnt = ARRAY_SIZE(tb10x_pingroups);

Basically I don't like this because it looks like your driver is trying
to duplicate the job of the core: to keep track of groups and their
counts using the callback methods.

> +       state->pctl = pinctrl_register(&tb10x_pindesc, &pdev->dev, state);
> +       if (IS_ERR(state->pctl)) {
> +               dev_err(&pdev->dev, "could not register TB10x pin driver\n");
> +               ret = PTR_ERR(state->pctl);
> +               goto pinctrl_reg_fail;
> +       }
> +
> +       return 0;
> +
> +pinctrl_reg_fail:
> +       iounmap(state->iobase);
> +ioremap_fail:
> +       release_region(mem->start, resource_size(mem));
> +request_mem_fail:
> +       mutex_destroy(&state->mutex);
> +       kfree(state);
> +       return ret;


With devm_* allocators all of this goes away and you can
just return -ERRCODE; wherever there is a problem.

> +}
> +
> +static int tb10x_pinctrl_remove(struct platform_device *pdev)
> +{
> +       struct resource *mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       struct tb10x_pinctrl_state *state = platform_get_drvdata(pdev);
> +       int i;
> +
> +       pinctrl_unregister(state->pctl);
> +
> +       for (i = 0; i < ARRAY_SIZE(tb10x_pingroups); i++)
> +               if (tb10x_pingroups[i].pctl == state)
> +                       tb10x_pingroups[i].pctl = NULL;

I don't understand what this cleanup is doing.

> +
> +       iounmap(state->iobase);
> +
> +       release_region(mem->start, resource_size(mem));
> +
> +       mutex_destroy(&state->mutex);
> +
> +       kfree(state);

The above goes away with devm_* allocators.

> +static const struct of_device_id tb10x_pinctrl_dt_ids[] = {
> +       { .compatible = TB10X_IOMUX_COMPATIBLE },

Can you just inline the compat string here instead of using a #define?

Yours,
Linus Walleij
