Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478AbaGNWsa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 18:48:30 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:32808 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756976AbaGNWs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 18:48:27 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdYqzsbisK-X22dwCcLFdvRm6-uJjNoEjv-h1-Jn6Uy-iw@mail.gmail.com>
References: <1404782785-1824-1-git-send-email-bjorn.andersson@sonymobile.com>
	<1404782785-1824-4-git-send-email-bjorn.andersson@sonymobile.com>
	<CACRpkdYqzsbisK-X22dwCcLFdvRm6-uJjNoEjv-h1-Jn6Uy-iw@mail.gmail.com>
Date: Mon, 14 Jul 2014 15:48:26 -0700
Message-ID: <CAJAp7Ojgf6iuSKtRnvyTCOxj5AwDA6W4eOeCpsfRqGAxcMPM1w@mail.gmail.com>
Subject: Re: [PATCH 3/3] pinctrl: Introduce pinctrl driver for Qualcomm pm8xxx
From: Bjorn Andersson <bjorn@kryo.se>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 9, 2014 at 2:32 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Tue, Jul 8, 2014 at 3:26 AM, Bjorn Andersson
[...]
>> +config PINCTRL_PM8XXX_GPIO
>> +       tristate "Qualcomm PM8xxx gpio driver"
>
> I would prefer PINCTRL_PM8XXX simply. GPIO is just one aspect of what
> this block inside PM8XXX is doing, it is a bit confusing.
>

There are two different blocks within these pmics, a block named "gpio" and a
block named "mpp" (multi purpose pins). Both are reasonable to model using
pinctrl + gpiolib, but I split them because I felt that the pinconf and pinmux
did not match up nicely.

Unless we merge them into one I feel that it makes sense to keep this naming.

>> +++ b/drivers/pinctrl/pinctrl-pm8xxx-gpio.c
>
> Likewise name the file and all functions just pinctrl-pm8xxx or so, reserve
> the "gpio" string in function names for functions that really just deal with
> the gpiochip.
>

The function naming is annoying and as it's all local functions anyways I think
I'll do so even if we have two "copies" of this.

>> +struct pm8xxx_gpio_pin {
>> +       int irq;
>> +
>> +       u8 power_source;
>> +       u8 direction;
>> +       u8 output_buffer;
>> +       u8 output_value;
>> +       u8 bias;
>> +       u8 output_strength;
>> +       u8 disable;
>> +       u8 function;
>> +       u8 non_inverted;
>> +};
>
> This struct really needs kerneldoc, as I guess it is what will be reflected
> in dbg_view messages etc too.
>

Agreed.

> Some u8:s seem dubious. Like why isn't "disable" a bool?
>

Agreed, sorry for being lazy here.

> Why is there a property "non_inverted", like being inverted was the
> normal state? Isn't it a bool inverted rather?
>

The magical line in the 3.4 codeaurora tree is:

  (param->inv_int_pol ? 0 : PM_GPIO_NON_INT_POL_INV);

It might be more logical to just name it "inverted" and do the flipping when
reading/writing the value though.

> "direction" also seems a bit bool ... even "output_value".
>

"direction" is 2 bits that can be both be set, unfortunately it's not entirely
clear to me what's expected when setting both; so I've copied the logic as good
as possible from the codeaurora driver.

"output_value" is bool.

> Such things.
>
>> +struct pm8xxx_gpio_data {
>> +       int ngpio;
>
> Can this be negative or should it be unsigned?
> Plus the usage in the code seems to be npins rather than
> ngpio. It indicates the number of pins this driver can handle,
> that they also do GPIO is just one aspect of their full pin potential...
>

unsigned npins it is.

>> +       const int *power_sources;
>> +       int npower_sources;
>
> Dito.
>
>> +};
>> +
>> +struct pm8xxx_gpio {
>> +       struct device *dev;
>> +       struct regmap *regmap;
>> +       struct pinctrl_dev *pctrl;
>> +       struct gpio_chip chip;
>> +
>> +       const struct pm8xxx_gpio_data *data;
>> +
>> +       struct pm8xxx_gpio_pin pins[PM8XXX_MAX_GPIOS];
>
> No thanks. Use the .pins in struct pinctrl_desc.
> (Details below.)
>

Will give it a spin and see how it turns out.

>> +};
>> +
>> +static const char * const pm8xxx_gpio_groups[PM8XXX_MAX_GPIOS] = {
>> +       "gpio1", "gpio2", "gpio3", "gpio4", "gpio5", "gpio6", "gpio7", "gpio8",
>> +       "gpio9", "gpio10", "gpio11", "gpio12", "gpio13", "gpio14", "gpio15",
>> +       "gpio16", "gpio17", "gpio18", "gpio19", "gpio20", "gpio21", "gpio22",
>> +       "gpio23", "gpio24", "gpio25", "gpio26", "gpio27", "gpio28", "gpio29",
>> +       "gpio30", "gpio31", "gpio32", "gpio33", "gpio34", "gpio35", "gpio36",
>> +       "gpio37", "gpio38", "gpio39", "gpio40", "gpio41", "gpio42", "gpio43",
>> +       "gpio44",
>> +};
>> +
>> +static const char * const pm8xxx_gpio_functions[] = {
>> +       "normal", "paired",
>> +       "func1", "func2",
>> +       "dtest1", "dtest2", "dtest3", "dtest4",
>> +};
>
> What is a bit strange is that the driver does not contain an array of the
> actual pin names, just groups and functions? It is usually very helpful
> to name all the individual pins.
>

Stephen is looking into whether we can find these lists for each of the
supported pmics.

>> +static int pm8xxx_gpio_read(struct pm8xxx_gpio *pctrl, int pin, int bank)
>
> I would prefer if this was named pm8xxx_pinctrl_read() or similar, so we
> get the GPIO ambiguity out of the way.
>
>> +{
>> +       int reg = SSBI_REG_ADDR_GPIO(pin);
>
> But I guess the registers may be named "GPIO" (something something)
> in the datasheet because the HW and spec authors are in the gpiomode
> pitfall we describe in the pinctrl.txt document. Like they think muxing
> and electrical config is "something GPIO" you know. So if this is matching
> a datasheet then keep that designation.
>

Unfortunately that's exactly what we face...

[...]
>> +static int pm8xxx_gpio_config_get(struct pinctrl_dev *pctldev,
>> +                         unsigned int offset,
>> +                         unsigned long *config)
>> +{
>
> Kudos for using generic pinconf, that makes everything much easier.
>

Thanks, I hope we can figure out the SI units and keep it this way.

[...]
>> +static struct pinctrl_desc pm8xxx_gpio_desc = {
>> +       .pctlops = &pm8xxx_gpio_pinctrl_ops,
>> +       .pmxops = &pm8xxx_pinmux_ops,
>> +       .confops = &pm8xxx_gpio_pinconf_ops,
>> +       .owner = THIS_MODULE,
>> +};
>
> So this (that should be named pm8xxx_pinctrl_desc) does not
> contain .pins, .npins, or even .name (!). Why not?
>

Because I turned them into pingroups instead, as there was "no need" for pins.
We're facing the same thing here as in pinctrl-msm, that there is a list of
pins and then there's an identical list of pingroups. And if you look closely
at pinctrl-msm, the pins are really only there for shows because we do all
operations on the pingroups.

> .pins could be identical to the actually software-configurable
> pins on the circuit, or a superset describing all pins on it
> if you like. The .pins variable in the state container seems
> to be sort of duplicating this.
>
> Note:
>
> struct pinctrl_pin_desc {
>         unsigned number;
>         const char *name;
>         void *drv_data;
> };
>
> See .drv_data above? Instead of using your custom struct
> for this, use pinctrl_pin_desc and dereference .drv_data.
>

I would still need the same custom struct, just that the reference would be
indirect via the pin_desc. But as I add a list of pins I will give it a spin.

> Naming the pins is usually very helpful, and usually the debugfs
> will look very nice, and the implementation of .pin_dbg_show() in
> pinctrl_ops can print something meaningful.
>

Maybe the fact that my gpio_chip->dbg_show() is doing this makes me not see
that point, I'll give it a spin and see if I can keep the gpio output related
to the gpio parts instead(?).

Regarding naming pins, we used to have actual ball names in the schematics but
as you always needed some other translation table it stopped and these days you
would only find something like PM8921_GPIO1 there. This is why the names end up
being "gpio1" or similar.

>> +static int pm8xxx_gpio_direction_input(struct gpio_chip *chip,
>> +                                      unsigned offset)
>> +{
>
> These functions are OK to name with *gpio* infix as they relate to
> the gpiochip.
>
>> +static int pm8xxx_gpio_get(struct gpio_chip *chip, unsigned offset)
>> +{
>> +       struct pm8xxx_gpio *pctrl = container_of(chip, struct pm8xxx_gpio, chip);
>> +       struct pm8xxx_gpio_pin *pin = &pctrl->pins[offset - 1];
>> +
>> +       if (pin->direction == PM8XXX_GPIO_DIR_OUT)
>> +               return pin->output_value;
>> +       else
>> +               return pm8xxx_read_irq_status(pin->irq);
>
> Yeah that thing... brrrr...
>
>> +static int pm8xxx_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
>> +{
>> +       struct pm8xxx_gpio *pctrl = container_of(chip, struct pm8xxx_gpio, chip);
>> +       struct pm8xxx_gpio_pin *pin = &pctrl->pins[offset - 1];
>> +
>> +       return pin->irq;
>> +}
>
> That's I guess proper if some totally different irqchip is managing the
> IRQs and there is a line for each GPIO to its corresponding IRQ
> on that irqchip.
>

I'm open to suggestions regarding this, but I found that this seem to solve my
problem at least ;)

Thanks for the review, I'll respin with some pins once we sorted out how to do
the bindings.

Regards,
Bjorn
