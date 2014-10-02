Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179AbaJBNic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 09:38:32 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:47699 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095AbaJBNiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 09:38:25 -0400
MIME-Version: 1.0
In-Reply-To: <1411443545-24951-3-git-send-email-srv_hongzhou.yang@mediatek.com>
References: <1411443545-24951-1-git-send-email-srv_hongzhou.yang@mediatek.com>
	<1411443545-24951-3-git-send-email-srv_hongzhou.yang@mediatek.com>
Date: Thu, 2 Oct 2014 15:38:24 +0200
Message-ID: <CACRpkdYY7e0OQL1YTEASxJw7E0FPAyOrPi0g93A9aRbfss0Vpw@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] ARM: mediatek: Add Pinctrl/GPIO driver for mt8135.
From: Linus Walleij <linus.walleij@linaro.org>
To: "Hongzhou.Yang" <srv_hongzhou.yang@mediatek.com>
Cc: Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>, srv_heupstream@mediatek.com,
        Sascha Hauer <kernel@pengutronix.de>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Hongzhou Yang <hongzhou.yang@mediatek.com>,
        "Joe.C" <yingjoe.chen@mediatek.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        dandan.he@mediatek.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 5:39 AM, Hongzhou.Yang
<srv_hongzhou.yang@mediatek.com> wrote:

> From: Hongzhou Yang <hongzhou.yang@mediatek.com>
>
> The mediatek SoCs have GPIO controller that handle both the muxing
> and GPIOs.
>
> The GPIO controller have pinmux, pull enable, pull select, direction
> and output high/low control.
>
> This driver include common and mt8135 part. It implements the pinctrl
> part and gpio part.
>
> Signed-off-by: Hongzhou Yang <hongzhou.yang@mediatek.com>
(...)
> diff --git a/drivers/pinctrl/mediatek/Kconfig b/drivers/pinctrl/mediatek/Kconfig
> new file mode 100644
> index 0000000..bae4be6
> --- /dev/null
> +++ b/drivers/pinctrl/mediatek/Kconfig
> @@ -0,0 +1,12 @@
> +if ARCH_MEDIATEK
> +
> +config PINCTRL_MTK_COMMON
> +       bool
> +       select PINMUX
> +       select GENERIC_PINCONF

This should most certainly select GPIOLIB_IRQCHIP, I'm
pretty sure you can use the common chained irqchip handling.

> +++ b/drivers/pinctrl/mediatek/pinctrl-mt8135.c
(...)
> +postcore_initcall(mtk_pinctrl_init);

Why? We prefer to use module_init() these days, and employ deferred
probe to order module probe order. Is there some problem with this?

> +++ b/drivers/pinctrl/mediatek/pinctrl-mtk-common.c
(...)
> +#include <linux/io.h>
> +#include <linux/gpio.h>
> +#include <linux/irqdomain.h>
> +#include <linux/irqchip/chained_irq.h>

These two includes go away with GPIOLIB_IRQCHIP

> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/of_device.h>
> +#include <linux/of_irq.h>
> +#include <linux/pinctrl/consumer.h>
> +#include <linux/pinctrl/machine.h>
> +#include <linux/pinctrl/pinctrl.h>
> +#include <linux/pinctrl/pinconf.h>
> +#include <linux/pinctrl/pinconf-generic.h>
> +#include <linux/pinctrl/pinmux.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <dt-bindings/pinctrl/mt65xx.h>
> +
> +#include "../pinconf.h"
> +#include "pinctrl-mtk-common.h"
> +
> +#define PINMUX_MAX_VAL 8
> +#define MAX_GPIO_MODE_PER_REG 5
> +#define GPIO_MODE_BITS        3
> +
> +static const char * const mt_gpio_functions[] = {
> +       "func0", "func1", "func2", "func3",
> +       "func4", "func5", "func6", "func7",
> +};
> +
> +static void __iomem *mt_get_base_addr(struct mt_pinctrl *pctl,
> +               unsigned long pin)
> +{
> +       if (pin >= pctl->devdata->type1_start && pin < pctl->devdata->type1_end)
> +               return pctl->membase2;
> +       return pctl->membase1;
> +}
> +
> +static void mt_pctrl_write_reg(struct mt_pinctrl *pctl,
> +               unsigned long pin,
> +               u32 reg, u32 d)
> +{
> +       writel(d, mt_get_base_addr(pctl, pin) + reg);
> +}

1) Don't you want to use writel_relaxed() and
2) What does this helper really buy you? I would prefer to
  inline this everywhere it's used. At the least tag this
  function as inline.

> +static unsigned int mt_get_port(unsigned long pin)
> +{
> +       return ((pin >> 4) & 0xf) << 4;

Isn't that equivalent to
return pin & 0xf0;

Add a comment explaining what's going on here.


> +static int mt_pmx_gpio_set_direction(struct pinctrl_dev *pctldev,
> +                       struct pinctrl_gpio_range *range,
> +                       unsigned offset,
> +                       bool input)
> +{
> +       unsigned int reg_addr;
> +       unsigned int bit;
> +       struct mt_pinctrl *pctl = pinctrl_dev_get_drvdata(pctldev);
> +
> +       reg_addr = mt_get_port(offset) + pctl->devdata->dir_offset;
> +       bit = 1 << (offset & 0xf);

#include <linux/bitops.h>

bit = BIT(offset & 0xf);

> +       if (input)
> +               reg_addr += (4 << 1);

What is wrong with reg_add += 8;

> +       else
> +               reg_addr += 4;
> +
> +       writel(bit, pctl->membase1 + reg_addr);

Note: here you're not using mt_pctrl_write_reg().
And I think you should use writel_relaxed().

> +static void mt_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
> +{
> +       unsigned int reg_addr;
> +       unsigned int bit;
> +       struct mt_pinctrl *pctl = dev_get_drvdata(chip->dev);
> +
> +       reg_addr = mt_get_port(offset) + pctl->devdata->dout_offset;
> +       bit = 1 << (offset & 0xf);

BIT(offset & 0xf)

> +       if (value)
> +               writel(bit, pctl->membase1 + reg_addr + 4);
> +       else
> +               writel(bit, pctl->membase1 + reg_addr + (4 << 1));

+8

> +static int mt_gpio_set_pull_conf(struct pinctrl_dev *pctldev,
> +               unsigned long pin, enum pin_config_param param,
> +               enum pin_config_param argument)
> +{
> +       unsigned int reg_pullen, reg_pullsel;
> +       unsigned int bit;
> +       struct mt_pinctrl *pctl = pinctrl_dev_get_drvdata(pctldev);
> +       int pullen = 0;
> +       int pullsel = 0;
> +
> +       bit = 1 << (pin & 0xf);

BIT

> +       switch (param) {
> +       case PIN_CONFIG_BIAS_DISABLE:
> +               pullen = 0;
> +               pullsel = 0;
> +               break;
> +       case PIN_CONFIG_BIAS_PULL_UP:
> +               mt_pmx_gpio_set_direction(pctldev, NULL, pin, 1);
> +               pullen = 1;
> +               pullsel = 1;
> +               break;
> +       case PIN_CONFIG_BIAS_PULL_DOWN:
> +               mt_pmx_gpio_set_direction(pctldev, NULL, pin, 1);
> +               pullen = 1;
> +               pullsel = 0;
> +               break;
> +
> +       case PIN_CONFIG_INPUT_ENABLE:
> +               mt_pmx_gpio_set_direction(pctldev, NULL, pin, 1);
> +               break;
> +
> +       case PIN_CONFIG_OUTPUT:
> +               mt_pmx_gpio_set_direction(pctldev, NULL, pin, 0);
> +               mt_gpio_set(pctl->chip, pin, argument);
> +               return 0;
> +
> +       default:
> +               return -EINVAL;
> +       }

Cut the whitespace newlines above I think.

> +       if (pullen)
> +               reg_pullen = mt_get_port(pin) +
> +                       pctl->devdata->pullen_offset + 4;
> +       else
> +               reg_pullen = mt_get_port(pin) +
> +                       pctl->devdata->pullen_offset + (4 << 1);

+8

> +
> +       if (pullsel)
> +               reg_pullsel = mt_get_port(pin) +
> +                       pctl->devdata->pullsel_offset + 4;
> +       else
> +               reg_pullsel = mt_get_port(pin) +
> +                       pctl->devdata->pullsel_offset + (4 << 1);

+8

> +       mt_pctrl_write_reg(pctl, pin, reg_pullen, bit);
> +       mt_pctrl_write_reg(pctl, pin, reg_pullsel, bit);
> +       return 0;
> +}
(...)
> +static int mt_pctrl_is_function_valid(struct mt_pinctrl *pctl,
> +               u32 pin_num, u32 fnum)

Return type should be bool.

> +{
> +       int i;
> +
> +       for (i = 0; i < pctl->devdata->npins; i++) {
> +               const struct mt_desc_pin *pin = pctl->devdata->pins + i;
> +
> +               if (pin->pin.number == pin_num) {
> +                       struct mt_desc_function *func = pin->functions + fnum;
> +
> +                       if (func->name)
> +                               return 1;
> +                       else
> +                               return 0;
> +               }
> +       }
> +
> +       return 0;
> +}

return true/false;

> +static int mt_pctrl_dt_node_to_map_func(struct mt_pinctrl *pctl, u32 pin,
> +               u32 fnum, struct pinctrl_map **maps)
> +static int mt_pctrl_dt_node_to_map_config(struct mt_pinctrl *pctl, u32 pin,
> +               unsigned long *configs, unsigned num_configs,
> +               struct pinctrl_map **maps)
> +static void mt_pctrl_dt_free_map(struct pinctrl_dev *pctldev,
> +                                   struct pinctrl_map *map,
> +                                   unsigned num_maps)
> +static int mt_pctrl_dt_node_to_map(struct pinctrl_dev *pctldev,
> +                                     struct device_node *node,
> +                                     struct pinctrl_map **map,
> +                                     unsigned *num_maps)

I'm worried about the escalating number of custom function->group
and pin config bindings, so I have submitted patches to fix this up and
allow for all-generic bindings to be used.

See:
http://marc.info/?l=devicetree&m=141223584006648&w=2
http://marc.info/?l=devicetree&m=141223586106655&w=2

> +       pins = of_find_property(node, "mediatek,pinfunc", NULL);

So I want to get rid of "mediatek,pinfunc" and just use "function"
for this.

> +       err = pinconf_generic_parse_dt_config(node, &configs, &num_configs);
> +       if (num_configs)
> +               has_config = 1;

This implicitly uses "pins", which is nice.

> +static int mt_gpio_set_mode(struct pinctrl_dev *pctldev,
> +               unsigned long pin, unsigned long mode)
> +{
> +       unsigned int reg_addr;
> +       unsigned char bit;
> +       unsigned int val;
> +       unsigned long flags;
> +       unsigned int mask = (1L << GPIO_MODE_BITS) - 1;
> +       struct mt_pinctrl *pctl = pinctrl_dev_get_drvdata(pctldev);
> +
> +       reg_addr = ((pin / 5) << 4) + pctl->devdata->pinmux_offset;

That 5 and 4 needs some explanation, or atleast being #defined
for readability.

> +       spin_lock_irqsave(&pctl->lock, flags);
> +       val = readl(pctl->membase1 + reg_addr);

readl_relaxed()?

> +static struct mt_desc_function *
> +mt_pctrl_desc_find_irq_by_name(struct mt_pinctrl *pctl,
> +                                        const char *pin_name)

Why is it called *find_irq_by_name if it returns a
function? Seems more like find_function_from_pin_name
really.

And I don't know if that is such a good idea.

> +{
> +       int i, j;
> +
> +       for (i = 0; i < pctl->devdata->npins; i++) {
> +               const struct mt_desc_pin *pin = pctl->devdata->pins + i;
> +
> +               if (!strcmp(pin->pin.name, pin_name)) {
> +                       struct mt_desc_function *func = pin->functions;
> +
> +                       for (j = 0; j < PINMUX_MAX_VAL; j++) {
> +                               if (func->irqnum != 255)

So why does it end at 255? Seems pretty arbitrary.

> +                                       return func;
> +
> +                               func++;
> +                       }
> +               }
> +       }
> +
> +       return NULL;
> +}


> +static int mt_pmx_enable(struct pinctrl_dev *pctldev,
> +                           unsigned function,
> +                           unsigned group)

This is typically named pmx_set_mux() nowadays, please
use the pin control development tree at this point, the change will
be upstream in v3.18.

> +static const struct pinmux_ops mt_pmx_ops = {
> +       .get_functions_count    = mt_pmx_get_funcs_cnt,
> +       .get_function_name      = mt_pmx_get_func_name,
> +       .get_function_groups    = mt_pmx_get_func_groups,
> +       .enable                 = mt_pmx_enable,

.set_mux =...

> +static int mt_gpio_request(struct gpio_chip *chip, unsigned offset)
> +{
> +       return pinctrl_request_gpio(chip->base + offset);
> +}
> +
> +static void mt_gpio_free(struct gpio_chip *chip, unsigned offset)
> +{
> +       pinctrl_free_gpio(chip->base + offset);
> +}
>
> +static int mt_gpio_direction_input(struct gpio_chip *chip,
> +                                       unsigned offset)
> +{
> +       return pinctrl_gpio_direction_input(chip->base + offset);
> +}
> +
> +static int mt_gpio_direction_output(struct gpio_chip *chip,
> +                                       unsigned offset, int value)
> +{
> +       return pinctrl_gpio_direction_output(chip->base + offset);
> +}

This is nice.

> +static int mt_gpio_get_direction(struct gpio_chip *chip, unsigned offset)
> +{
> +       unsigned int reg_addr;
> +       unsigned int bit;
> +       unsigned int read_val = 0;
> +
> +       struct mt_pinctrl *pctl = dev_get_drvdata(chip->dev);
> +
> +       reg_addr =  mt_get_port(offset) + pctl->devdata->dir_offset;
> +       bit = 1 << (offset & 0xf);

bit = BIT(offset & 0xf);

> +       read_val = readl(pctl->membase1 + reg_addr);
> +       return ((read_val & bit) != 0) ? 1 : 0;

No do it like this:

return !!(read_val & bit);

> +static int mt_gpio_get(struct gpio_chip *chip, unsigned offset)
> +{
> +       unsigned int reg_addr;
> +       unsigned int bit;
> +       unsigned int read_val = 0;
> +       struct mt_pinctrl *pctl = dev_get_drvdata(chip->dev);
> +
> +       if (mt_gpio_get_direction(chip, offset))
> +               reg_addr = mt_get_port(offset) + pctl->devdata->dout_offset;
> +       else
> +               reg_addr = mt_get_port(offset) + pctl->devdata->din_offset;
> +
> +       bit = 1 << (offset & 0xf);
> +       read_val = readl(pctl->membase1 + reg_addr);
> +       return ((read_val & bit) != 0) ? 1 : 0;
> +}

Same comments on this function.

> +static int mt_gpio_of_xlate(struct gpio_chip *gc,
> +                               const struct of_phandle_args *gpiospec,
> +                               u32 *flags)
> +{
> +       int pin;
> +
> +       pin = gpiospec->args[0];
> +
> +       if (pin > (gc->base + gc->ngpio))
> +               return -EINVAL;
> +
> +       if (flags)
> +               *flags = gpiospec->args[1];
> +
> +       return pin;
> +}

Why do you need your own xlate function to do this?

What is wrong with of_gpio_simple_xlate() which seems to do
the same thing?

Incidentally that is what you will get if you just leave this
pointer in the vtable as unassigned.

> +static int mt_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
> +{
> +       struct mt_pinctrl *pctl = dev_get_drvdata(chip->dev);
> +       struct mt_pinctrl_group *g = pctl->groups + offset;
> +       struct mt_desc_function *desc = mt_pctrl_desc_find_irq_by_name(
> +                       pctl, g->name);
> +       if (!desc)
> +               return -EINVAL;
> +
> +       mt_gpio_set_mode(pctl->pctl_dev, g->pin, desc->muxval);

No mode setting in the .to_irq() function, that makes the irqchip
not orthogonal to the gpio_chip.

> +       return desc->irqnum;
> +}

By the way use GPIOLIB_IRQCHIP for this and get rid
of .to_irq altogether.

(...)
> +static int mt_pctrl_build_state(struct platform_device *pdev)
> +{
> +       struct mt_pinctrl *pctl = platform_get_drvdata(pdev);
> +       int i;
> +
> +       pctl->ngroups = pctl->devdata->npins;
> +
> +       pctl->groups = devm_kzalloc(&pdev->dev,
> +                                   pctl->ngroups * sizeof(*pctl->groups),
> +                                   GFP_KERNEL);
> +       if (!pctl->groups)
> +               return -ENOMEM;
> +
> +       pctl->grp_names = devm_kzalloc(&pdev->dev,
> +                                   pctl->ngroups * sizeof(*pctl->grp_names),
> +                                   GFP_KERNEL);
> +       if (!pctl->grp_names)
> +               return -ENOMEM;
> +
> +       for (i = 0; i < pctl->devdata->npins; i++) {
> +               const struct mt_desc_pin *pin = pctl->devdata->pins + i;
> +               struct mt_pinctrl_group *group = pctl->groups + i;
> +               const char **func_grp;
> +
> +               group->name = pin->pin.name;
> +               group->pin = pin->pin.number;
> +
> +               func_grp = pctl->grp_names;
> +               while (*func_grp)
> +                       func_grp++;
> +
> +               *func_grp = pin->pin.name;
> +       }
> +
> +       return 0;
> +}

I don't understand what this function is doing so atleast it need
and explanation in kerneldoc above it.

(...)
> +       ret = gpiochip_add(pctl->chip);
> +       if (ret) {
> +               ret = -EINVAL;
> +               goto pctrl_error;
> +       }

Here  you should be using gpiochip_irqchip_add()
followed by gpiochip_set_chained_irqchip().

> +       for (i = 0; i < pctl->devdata->npins; i++) {
> +               const struct mt_desc_pin *pin = pctl->devdata->pins + i;
> +
> +               ret = gpiochip_add_pin_range(pctl->chip, dev_name(&pdev->dev),
> +                                            pin->pin.number,
> +                                            pin->pin.number, 1);
> +               if (ret) {
> +                       ret = -EINVAL;
> +                       goto chip_error;
> +               }

Seems complicated but I don't know how complicated
your GPIO ranges are indeed.

> +chip_error:
> +       if (gpiochip_remove(pctl->chip))

We have removed the return value from gpiochip_remove() so rebase
to upstream here. No if(..)

> diff --git a/drivers/pinctrl/mediatek/pinctrl-mtk-common.h b/drivers/pinctrl/mediatek/pinctrl-mtk-common.h
(...)
> +struct mt_desc_pin {
> +       struct pinctrl_pin_desc pin;
> +       const char *chip;
> +       struct mt_desc_function *functions;

Why does a pin need to know about functions...

> +};

Don't invent custom pin container structures. Look:

/**
 * struct pinctrl_pin_desc - boards/machines provide information on their
 * pins, pads or other muxable units in this struct
 * @number: unique pin number from the global pin number space
 * @name: a name for this pin
 * @drv_data: driver-defined per-pin data. pinctrl core does not touch this
 */
struct pinctrl_pin_desc {
        unsigned number;
        const char *name;
        void *drv_data;
};

You add your stuff to drv_data() rather than including this struct
into your own struct.

> +#define MT_PIN(_pin, _pad, _chip, ...)                         \
> +       {                                                       \
> +               .pin = _pin,                                    \
> +               .chip = _chip,                                  \
> +               .functions = (struct mt_desc_function[]){       \
> +                       __VA_ARGS__, { } },                     \
> +       }
> +
> +#define MT_FUNCTION(_val, _name)                               \
> +       {                                                       \
> +               .name = _name,                                  \
> +               .muxval = _val,                                 \
> +               .irqnum = 255,                                  \

255 eh?

> +       }
> +
> +#define MT_FUNCTION_IRQ(_val, _name, _irq)                     \
> +       {                                                       \
> +               .name = _name,                                  \
> +               .muxval = _val,                                 \
> +               .irqnum = _irq,                                 \
> +       }
> +
> +struct mt_pinctrl_group {
> +       const char      *name;
> +       unsigned long   config;
> +       unsigned        pin;
> +};
> +
> +struct mt_gpio_devdata {
> +       const struct mt_desc_pin *pins;
> +       int npins;
> +       unsigned int dir_offset;
> +       unsigned int ies_offset;
> +       unsigned int pullen_offset;
> +       unsigned int pullsel_offset;
> +       unsigned int drv_offset;
> +       unsigned int invser_offset;
> +       unsigned int dout_offset;
> +       unsigned int din_offset;
> +       unsigned int pinmux_offset;
> +       unsigned short type1_start;
> +       unsigned short type1_end;
> +};

Add some kerneldoc for this struct as it't not apparently
self-evident.

> +static const struct mt_desc_pin mt_pins_mt8135[] = {
> +       MT_PIN(
> +               PINCTRL_PIN(0, "MSDC0_DAT7"),
> +               "D21", "mt8135",
> +               MT_FUNCTION(0, "GPIO0"),
> +               MT_FUNCTION(1, "MSDC0_DAT7"),
> +               MT_FUNCTION_IRQ(2, "EINT49", 49),
> +               MT_FUNCTION(3, "I2SOUT_DAT"),
> +               MT_FUNCTION(4, "DAC_DAT_OUT"),
> +               MT_FUNCTION(5, "PCM1_DO"),
> +               MT_FUNCTION(6, "SPI1_MO"),
> +               MT_FUNCTION(7, "NALE")
> +       ),

I don't think this is a good idea and to encode all functions in a pin,
rather the revers is custom: define all functions and collect arrays
of pin numbers in the definitions of pin groups, then map the functions
and groups of pins together.

Look at other drivers for examples..

I don't like the device tree bindings for the very same reason: it moves
all this numeric encoding of pin-functions into the device tree instead
of combining group+function strings like most drivers do.

Is there some special reason to why you're turning this on its head?

Yours,
Linus Walleij
