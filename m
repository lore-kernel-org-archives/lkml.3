Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127AbaGIJcN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 05:32:13 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:46554 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645AbaGIJcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 05:32:08 -0400
MIME-Version: 1.0
In-Reply-To: <1404782785-1824-4-git-send-email-bjorn.andersson@sonymobile.com>
References: <1404782785-1824-1-git-send-email-bjorn.andersson@sonymobile.com>
	<1404782785-1824-4-git-send-email-bjorn.andersson@sonymobile.com>
Date: Wed, 9 Jul 2014 11:32:08 +0200
Message-ID: <CACRpkdYqzsbisK-X22dwCcLFdvRm6-uJjNoEjv-h1-Jn6Uy-iw@mail.gmail.com>
Subject: Re: [PATCH 3/3] pinctrl: Introduce pinctrl driver for Qualcomm pm8xxx
From: Linus Walleij <linus.walleij@linaro.org>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 8, 2014 at 3:26 AM, Bjorn Andersson
<bjorn.andersson@sonymobile.com> wrote:

> This introduces a pinctrl, pinconf, pinmux and gpio driver for the gpio
> block found in pm8018, pm8038, pm8058, pm8917 and pm8921 pmics from
> Qualcomm.
>
> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>

(...)

> +config PINCTRL_PM8XXX_GPIO
> +       tristate "Qualcomm PM8xxx gpio driver"

I would prefer PINCTRL_PM8XXX simply. GPIO is just one aspect of what
this block inside PM8XXX is doing, it is a bit confusing.

> +++ b/drivers/pinctrl/pinctrl-pm8xxx-gpio.c

Likewise name the file and all functions just pinctrl-pm8xxx or so, reserve
the "gpio" string in function names for functions that really just deal with
the gpiochip.

> +struct pm8xxx_gpio_pin {
> +       int irq;
> +
> +       u8 power_source;
> +       u8 direction;
> +       u8 output_buffer;
> +       u8 output_value;
> +       u8 bias;
> +       u8 output_strength;
> +       u8 disable;
> +       u8 function;
> +       u8 non_inverted;
> +};

This struct really needs kerneldoc, as I guess it is what will be reflected
in dbg_view messages etc too.

Some u8:s seem dubious. Like why isn't "disable" a bool?

Why is there a property "non_inverted", like being inverted was the
normal state? Isn't it a bool inverted rather?

"direction" also seems a bit bool ... even "output_value".

Such things.

> +struct pm8xxx_gpio_data {
> +       int ngpio;

Can this be negative or should it be unsigned?
Plus the usage in the code seems to be npins rather than
ngpio. It indicates the number of pins this driver can handle,
that they also do GPIO is just one aspect of their full pin potential...

> +       const int *power_sources;
> +       int npower_sources;

Dito.

> +};
> +
> +struct pm8xxx_gpio {
> +       struct device *dev;
> +       struct regmap *regmap;
> +       struct pinctrl_dev *pctrl;
> +       struct gpio_chip chip;
> +
> +       const struct pm8xxx_gpio_data *data;
> +
> +       struct pm8xxx_gpio_pin pins[PM8XXX_MAX_GPIOS];

No thanks. Use the .pins in struct pinctrl_desc.
(Details below.)

> +};
> +
> +static const char * const pm8xxx_gpio_groups[PM8XXX_MAX_GPIOS] = {
> +       "gpio1", "gpio2", "gpio3", "gpio4", "gpio5", "gpio6", "gpio7", "gpio8",
> +       "gpio9", "gpio10", "gpio11", "gpio12", "gpio13", "gpio14", "gpio15",
> +       "gpio16", "gpio17", "gpio18", "gpio19", "gpio20", "gpio21", "gpio22",
> +       "gpio23", "gpio24", "gpio25", "gpio26", "gpio27", "gpio28", "gpio29",
> +       "gpio30", "gpio31", "gpio32", "gpio33", "gpio34", "gpio35", "gpio36",
> +       "gpio37", "gpio38", "gpio39", "gpio40", "gpio41", "gpio42", "gpio43",
> +       "gpio44",
> +};
> +
> +static const char * const pm8xxx_gpio_functions[] = {
> +       "normal", "paired",
> +       "func1", "func2",
> +       "dtest1", "dtest2", "dtest3", "dtest4",
> +};

What is a bit strange is that the driver does not contain an array of the
actual pin names, just groups and functions? It is usually very helpful
to name all the individual pins.

> +static int pm8xxx_gpio_read(struct pm8xxx_gpio *pctrl, int pin, int bank)

I would prefer if this was named pm8xxx_pinctrl_read() or similar, so we
get the GPIO ambiguity out of the way.

> +{
> +       int reg = SSBI_REG_ADDR_GPIO(pin);

But I guess the registers may be named "GPIO" (something something)
in the datasheet because the HW and spec authors are in the gpiomode
pitfall we describe in the pinctrl.txt document. Like they think muxing
and electrical config is "something GPIO" you know. So if this is matching
a datasheet then keep that designation.

> +static int pm8xxx_gpio_get_groups_count(struct pinctrl_dev *pctldev)
> +{
> +       struct pm8xxx_gpio *pctrl = pinctrl_dev_get_drvdata(pctldev);
> +
> +       return pctrl->data->ngpio;
> +}

So I suggest renaming that ->npins.

> +static void pm8xxx_pinmux_disable(struct pinctrl_dev *pctldev,
> +                              unsigned function,
> +                              unsigned group)
> +{
> +       struct pm8xxx_gpio *pctrl = pinctrl_dev_get_drvdata(pctldev);
> +       struct pm8xxx_gpio_pin *pin = &pctrl->pins[group];
> +       u8 val;
> +
> +       pin->function = 0;
> +       val = pin->function << 1;
> +
> +       pm8xxx_gpio_write(pctrl, group, 4, val);
> +}

We just got rid of this function from the ops becuase it was just
causing trouble in the concepts so just delete it :-)

> +static int pm8xxx_gpio_config_get(struct pinctrl_dev *pctldev,
> +                         unsigned int offset,
> +                         unsigned long *config)
> +{

Kudos for using generic pinconf, that makes everything much easier.

> +       struct pm8xxx_gpio *pctrl = pinctrl_dev_get_drvdata(pctldev);
> +       struct pm8xxx_gpio_pin *pin = &pctrl->pins[offset];
> +       unsigned param = pinconf_to_config_param(*config);
> +       unsigned arg;
> +
> +       switch (param) {
> +       case PIN_CONFIG_BIAS_DISABLE:
> +               arg = pin->bias == PM8XXX_GPIO_BIAS_NP;
> +               break;
> +       case PIN_CONFIG_BIAS_PULL_DOWN:
> +               arg = pin->bias == PM8XXX_GPIO_BIAS_PD;
> +               break;
> +       case PIN_CONFIG_BIAS_PULL_UP:
> +               if (pin->bias >= PM8XXX_GPIO_BIAS_PU_30 &&
> +                   pin->bias <= PM8XXX_GPIO_BIAS_PU_1P5_30)
> +                       arg = PM8XXX_GPIO_PULL_UP_30 + pin->bias;
> +               else
> +                       arg = 0;
> +               break;

So here I expect SI unit conversion instead.

> +       case PIN_CONFIG_BIAS_HIGH_IMPEDANCE:
> +               arg = pin->disable;
> +               break;
> +       case PIN_CONFIG_INPUT_ENABLE:
> +               arg = pin->direction == PM8XXX_GPIO_DIR_IN;
> +               break;
> +       case PIN_CONFIG_OUTPUT:
> +               arg = pin->output_value;
> +               break;
> +       case PIN_CONFIG_POWER_SOURCE:
> +               arg = pin->power_source;
> +               break;
> +       case PIN_CONFIG_DRIVE_STRENGTH:
> +               arg = pin->output_strength;
> +               break;

And here.

> +       case PIN_CONFIG_DRIVE_PUSH_PULL:
> +               arg = pin->output_buffer == PM8XXX_GPIO_PUSH_PULL;
> +               break;
> +       case PIN_CONFIG_DRIVE_OPEN_DRAIN:
> +               arg = pin->output_buffer == PM8XXX_GPIO_OPEN_DRAIN;
> +               break;
> +       default:
> +               dev_err(pctrl->dev,
> +                       "unsupported config parameter: %x\n",
> +                       param);
> +               return -EINVAL;
> +       }
> +
> +       *config = pinconf_to_config_packed(param, arg);
> +
> +       return 0;
> +}

(...)
> +static int pm8xxx_gpio_config_set(struct pinctrl_dev *pctldev,
> +                                 unsigned int offset,
> +                                 unsigned long *configs,
> +                                 unsigned num_configs)
> +{
> +       struct pm8xxx_gpio *pctrl = pinctrl_dev_get_drvdata(pctldev);
> +       struct pm8xxx_gpio_pin *pin = &pctrl->pins[offset];
> +       unsigned param;
> +       unsigned arg;
> +       unsigned i;
> +       int ret;
> +       u8 banks = 0;
> +       u8 val;
> +
> +       for (i = 0; i < num_configs; i++) {
> +               param = pinconf_to_config_param(configs[i]);
> +               arg = pinconf_to_config_argument(configs[i]);
> +
> +               switch (param) {
> +               case PIN_CONFIG_BIAS_DISABLE:
> +                       pin->bias = PM8XXX_GPIO_BIAS_NP;
> +                       banks |= BIT(2);
> +                       pin->disable = 0;
> +                       banks |= BIT(3);
> +                       break;
> +               case PIN_CONFIG_BIAS_PULL_DOWN:
> +                       pin->bias = PM8XXX_GPIO_BIAS_PD;
> +                       banks |= BIT(2);
> +                       pin->disable = 0;
> +                       banks |= BIT(3);
> +                       break;
> +               case PIN_CONFIG_BIAS_PULL_UP:
> +                       if (arg < PM8XXX_GPIO_PULL_UP_30 ||
> +                           arg > PM8XXX_GPIO_PULL_UP_1P5_30) {
> +                               dev_err(pctrl->dev, "invalid pull-up level\n");
> +                               return -EINVAL;
> +                       }
> +                       pin->bias = arg - PM8XXX_GPIO_BIAS_PU_30;

Proper SI unit...

> +                       banks |= BIT(2);
> +                       pin->disable = 0;
> +                       banks |= BIT(3);
> +                       break;
> +               case PIN_CONFIG_BIAS_HIGH_IMPEDANCE:
> +                       pin->disable = 1;
> +                       banks |= BIT(3);
> +                       break;
> +               case PIN_CONFIG_INPUT_ENABLE:
> +                       pin->direction = PM8XXX_GPIO_DIR_IN;
> +                       banks |= BIT(1);
> +                       break;
> +               case PIN_CONFIG_OUTPUT:
> +                       pin->direction = PM8XXX_GPIO_DIR_OUT;
> +                       pin->output_value = !!arg;
> +                       banks |= BIT(1);
> +                       break;
> +               case PIN_CONFIG_POWER_SOURCE:
> +                       /* Sanity check the power source */
> +                       ret = resolve_power_source(pctrl, arg);
> +                       if (ret < 0)
> +                               return ret;
> +                       pin->power_source = arg;
> +                       banks |= BIT(0);
> +                       break;
> +               case PIN_CONFIG_DRIVE_STRENGTH:
> +                       if (arg > PM8XXX_GPIO_STRENGTH_LOW) {
> +                               dev_err(pctrl->dev, "invalid drive strength\n");
> +                               return -EINVAL;
> +                       }
> +                       pin->output_strength = arg;
> +                       banks |= BIT(3);
> +                       break;

SI units...

> +               case PIN_CONFIG_DRIVE_PUSH_PULL:
> +                       pin->output_buffer = PM8XXX_GPIO_PUSH_PULL;
> +                       banks |= BIT(1);
> +                       break;
> +               case PIN_CONFIG_DRIVE_OPEN_DRAIN:
> +                       pin->output_buffer = PM8XXX_GPIO_OPEN_DRAIN;
> +                       banks |= BIT(1);
> +                       break;
> +               default:
> +                       dev_err(pctrl->dev,
> +                                       "unsupported config parameter: %x\n",
> +                                       param);
> +                       return -EINVAL;
> +               }
> +       }

(...)

> +static struct pinctrl_desc pm8xxx_gpio_desc = {
> +       .pctlops = &pm8xxx_gpio_pinctrl_ops,
> +       .pmxops = &pm8xxx_pinmux_ops,
> +       .confops = &pm8xxx_gpio_pinconf_ops,
> +       .owner = THIS_MODULE,
> +};

So this (that should be named pm8xxx_pinctrl_desc) does not
contain .pins, .npins, or even .name (!). Why not?

.pins could be identical to the actually software-configurable
pins on the circuit, or a superset describing all pins on it
if you like. The .pins variable in the state container seems
to be sort of duplicating this.

Note:

struct pinctrl_pin_desc {
        unsigned number;
        const char *name;
        void *drv_data;
};

See .drv_data above? Instead of using your custom struct
for this, use pinctrl_pin_desc and dereference .drv_data.

Naming the pins is usually very helpful, and usually the debugfs
will look very nice, and the implementation of .pin_dbg_show() in
pinctrl_ops can print something meaningful.

> +static int pm8xxx_gpio_direction_input(struct gpio_chip *chip,
> +                                      unsigned offset)
> +{

These functions are OK to name with *gpio* infix as they relate to
the gpiochip.

> +static int pm8xxx_gpio_get(struct gpio_chip *chip, unsigned offset)
> +{
> +       struct pm8xxx_gpio *pctrl = container_of(chip, struct pm8xxx_gpio, chip);
> +       struct pm8xxx_gpio_pin *pin = &pctrl->pins[offset - 1];
> +
> +       if (pin->direction == PM8XXX_GPIO_DIR_OUT)
> +               return pin->output_value;
> +       else
> +               return pm8xxx_read_irq_status(pin->irq);

Yeah that thing... brrrr...

> +static int pm8xxx_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
> +{
> +       struct pm8xxx_gpio *pctrl = container_of(chip, struct pm8xxx_gpio, chip);
> +       struct pm8xxx_gpio_pin *pin = &pctrl->pins[offset - 1];
> +
> +       return pin->irq;
> +}

That's I guess proper if some totally different irqchip is managing the
IRQs and there is a line for each GPIO to its corresponding IRQ
on that irqchip.

> +static int pm8xxx_gpio_populate(struct pm8xxx_gpio *pctrl)
> +{
> +       const struct pm8xxx_gpio_data *data = pctrl->data;
> +       struct pm8xxx_gpio_pin *pin;
> +       int val;
> +       int i;
> +
> +       for (i = 0; i < pctrl->data->ngpio; i++) {
> +               pin = &pctrl->pins[i];
> +
> +               val = pm8xxx_gpio_read(pctrl, i, 0);
> +               if (val < 0)
> +                       return val;
> +
> +               pin->power_source = data->power_sources[(val >> 1) & 0x7];
> +
> +               val = pm8xxx_gpio_read(pctrl, i, 1);
> +               if (val < 0)
> +                       return val;
> +
> +               pin->direction = (val >> 2) & 0x3;
> +               pin->output_buffer = !!(val & BIT(1));
> +               pin->output_value = val & BIT(0);
> +
> +               val = pm8xxx_gpio_read(pctrl, i, 2);
> +               if (val < 0)
> +                       return val;
> +
> +               pin->bias = (val >> 1) & 0x7;
> +
> +               val = pm8xxx_gpio_read(pctrl, i, 3);
> +               if (val < 0)
> +                       return val;
> +
> +               pin->output_strength = (val >> 2) & 0x3;
> +               pin->disable = val & BIT(0);
> +
> +               val = pm8xxx_gpio_read(pctrl, i, 4);
> +               if (val < 0)
> +                       return val;
> +
> +               pin->function = (val >> 1) & 0x7;
> +
> +               val = pm8xxx_gpio_read(pctrl, i, 5);
> +               if (val < 0)
> +                       return val;
> +
> +               pin->non_inverted = !!(val & BIT(3));

See, it's bool, no u8. It seems the HW has the logic reversed here,
ho hum. Maybe it's right to name it "non_inverted" then.

That's all for now...

Yours,
Linus Walleij
