Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260AbaAHO7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 09:59:19 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:58474 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755224AbaAHO7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 09:59:15 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdbAPYs=48RXr6r5kqkYj2V9GitRMT2BRKkn4_gT77wUEg@mail.gmail.com>
References: <1387814889-16670-1-git-send-email-lpapp@kde.org>
	<1387814889-16670-4-git-send-email-lpapp@kde.org>
	<CACRpkdbAPYs=48RXr6r5kqkYj2V9GitRMT2BRKkn4_gT77wUEg@mail.gmail.com>
Date: Wed, 8 Jan 2014 14:59:14 +0000
X-Google-Sender-Auth: N2L5sWw-Cn3onwNvlgoUsb8VC1E
Message-ID: <CAOMwXhNcmbk92TsNTGVQdfWrbVycVW++-+46+8onDZ5xPCD-Jw@mail.gmail.com>
Subject: Re: [PATCH 3/3] gpio: MAX6650/6651 support
From: Laszlo Papp <lpapp@kde.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Guenter Roeck <linux@roeck-us.net>, Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 7, 2014 at 2:33 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Mon, Dec 23, 2013 at 5:08 PM, Laszlo Papp <lpapp@kde.org> wrote:
>
>> These ICs already have hwmon driver support, but they also have some gpio
>> functionality which this addition tries to address. Later on, there would be an
>> MFD driver added as well.
>>
>> Signed-off-by: Laszlo Papp <lpapp@kde.org>
>
> As mentioned please augment the MFD device to use I2C regmap access.
>
>> +++ b/drivers/gpio/gpio-max6651.c
> (...)
>> +#define PIN_NUMBER 5
>
> As I can see this is really a GPIO+pin control driver it shall be
> moved to drivers/pinctrl.

Hmm, but then I am not sure why the gpio-max*.c are similar in the
drivers/gpio area. Could you please elaborate? They are somewhat
similar to my understanding, but perhaps there is some fundamental
difference I am not aware of?

>> +static int max6651_probe(struct platform_device *pdev)
>> +{
>> +    struct max665x_gpio *gpio;
>> +    struct da9055_pdata *pdata;
>> +       int ret;
>> +
>> +       gpio = devm_kzalloc(&pdev->dev, sizeof(struct max665x_gpio), GFP_KERNEL);
>> +       if (!gpio)
>> +               return -ENOMEM;
>> +
>> +    gpio->gp.ngpio = PIN_NUMBER;
>> +
>> +       ret = __max665x_probe(gpio);
>
> Do you *really* have to split up this handling into two files with
> criss-cross calls like this?

I personally think it is a bit excessive, so I agree with you. I
wished to stay somewhat consistent to the following drivers:

* gpio-max730x.c
* gpio-max7300.c
* gpio-max7301.c

Are you OK with that then if I do not follow the consistency?

> Anyway if you absolutely have to do
> this don't use "__" prefixes, those are for the preprocessor.
> Just max665x_probe() is fine.

This is because of the same reason as above: consistency. I can drop
it if you wish?

>> +static struct platform_driver max6651_driver = {
>> +       .driver = {
>> +               .name = "gpio-max6651",
>> +               .owner = THIS_MODULE,
>> +       },
>> +       .probe = max6651_probe,
>> +       .remove = max6651_remove,
>> +       .id_table = max6651_id,
>> +};
>> +
>> +static int __init max6651_init(void)
>> +{
>> +       return platform_driver_register(&max6651_driver);
>> +}
>> +subsys_initcall(max6651_init);
>
> Why does it have to be subsys_initcall? Please try to avoid
> this.

It is for consistency just as before. :-) Could you please elaborate
why it is better to be avoided, or at least point me to some
documentation?

>> +static void __exit max6651_exit(void)
>> +{
>> +       platform_driver_unregister(&max6651_driver);
>> +}
>> +module_exit(max6651_exit);
>
> Because then this can just be a module_platform_driver() macro.

Hmm.

>> +MODULE_AUTHOR("Laszlo Papp");
>> +MODULE_LICENSE("GPL v2");
>> +MODULE_DESCRIPTION("MAX6651 fan controller");
>
> And *why* should I have a fan controller in the GPIO subsystem?
> I don't quite get this.

The MAX6651 chip is multifunctional, but it is ultimate a fan
controller IC as per Kconfig guided text. If you prefer, I can rename
the term here to refer to the GPIO subfunctionality, or you had
something else in mind?

>> +++ b/drivers/gpio/gpio-max665x.c
> (...)
>> +#define MAX665X_REG_GPIO_DEF    0x04
>> +#define MAX665X_REG_GPIO_STAT   0x14
>> +
>> +/*
>> + * Gpio Def register bits
>> + */
>> +
>> +#define PIN0_CONFIG_MASK    0x03
>> +#define PIN1_CONFIG_MASK    0x0C
>> +#define PIN2_CONFIG_MASK    0x30
>> +#define PIN3_CONFIG_MASK    0x40
>> +#define PIN4_CONFIG_MASK    0x80
>> +
>> +#define PIN0_CONFIG_OUT_LOW  0x02
>> +#define PIN1_CONFIG_OUT_LOW  0x08
>> +#define PIN2_CONFIG_OUT_LOW  0x20
>
> Since this is really pin configuration the driver should support more
> stuff in the long run, and then it should be in drivers/pinctrl.

Could you please elaborate what more stuff you have in mind for this?

> If it is "just" GPIO, then rename all PIN* prefixes to LINE*

I am actually not sure about the difference... I will have a look.

>> +struct max665x_platform_data {
>> +    /* number assigned to the first GPIO */
>> +    unsigned    base;
>> +    /*
>> +     * bitmask controlling the pullup configuration,
>> +     *
>> +     * _note_ the 3 highest  bits are unused, because there can be maximum up
>> +     * to five gpio pins on the MAX6651 chip (three on MAX6650).
>> +     */
>> +    u8     input_pullup_active;
>
> So obviously this is not just GPIO but also pin control.
>
> Read Documentation/pinctrl.txt, you will only need to
> implement a pin config interface since it seems you have
> no muxing in this component.

Ah, getting somewhat clearer (maybe) ...

>
> - In drivers/pinctrl/Kconfig for your driver select
>   GENERIC_PINCONF
>
> - Implement a pinctrl and pinconf interface apart from
>   the GPIOlib interface you already have.
>
> - Supply pin control tables to set up biasing.
>
>> +static int max665x_direction_input_or_output_high(struct gpio_chip *chip, unsigned offset)
>
> That sounds like an odd combination.

Perhaps, but that is how the chip behaves after all.

>> +static int max665x_get_level(struct max665x_gpio *gpio, unsigned offset, unsigned gpio_value)
>> +{
>> +    int ret;
>> +
>> +    if (offset < 3) {
>> +        switch (gpio_value) {
>> +        case 0:
>> +        case 3:
>> +            if (gpio->input_pullup_active & (1 << offset)) {
>
> Why does this only work if pullup is active?
>
> Describe with a comment why this is so.

OK.

>> +                max6651_read_reg(gpio->iodev->i2c, MAX665X_REG_GPIO_STAT, &ret);
>> +                ret &= (offset + 1);
>> +            } else {
>> +                ret = 1;
>> +            }
>> +            break;
>> +        case 2:
>> +            ret = 0;
>> +            break;
>
> Describe with a comment this special case and why it behaves like that.

OK.

>
>> +        default:
>> +            ret = 0;
>> +            dev_err(gpio->iodev->i2c, "Failed to obtain the gpio %d value\n", offset);
>> +            break;
>> +        }
>> +    } else {
>> +        if (gpio_value) {
>> +            if (gpio->input_pullup_active & (1 << offset)) {
>> +                max6651_read_reg(gpio->iodev->i2c, MAX665X_REG_GPIO_STAT, &ret);
>
> Same thing...

OK.

>> +static int max665x_get(struct gpio_chip *chip, unsigned offset)
>> +{
>> +       struct max665x_gpio *gpio = to_max665x_gpio(chip);
>> +    int level = -EINVAL;
>> +       u8 config;
>> +
>> +       mutex_lock(&gpio->iodev->iolock);
>> +
>> +       max6651_read_reg(gpio->iodev->i2c, MAX665X_REG_GPIO_DEF, &config);
>> +
>> +    switch (offset) {
>> +    case 0:
>> +        level = max665x_get_level(gpio, offset, config & PIN0_CONFIG_MASK);
>> +        break;
>> +    case 1:
>> +        level = max665x_get_level(gpio, offset, (config & PIN1_CONFIG_MASK) >> 2);
>> +        break;
>> +    case 2:
>> +        level = max665x_get_level(gpio, offset, (config & PIN2_CONFIG_MASK) >> 4);
>> +        break;
>> +    case 3:
>> +        level = max665x_get_level(gpio, offset, (config & PIN3_CONFIG_MASK) >> 5);
>> +        break;
>> +    case 4:
>> +        level = max665x_get_level(gpio, offset, (config & PIN3_CONFIG_MASK) >> 6);
>> +        break;
>
> This looks like it could be made a lot simpler using a table.

How exactly would you like to have it?

>> +int __max665x_probe(struct max665x_gpio *gpio)
>> +{
>> +       struct max665x_platform_data *pdata = dev_get_drvdata(gpio->iodev->dev);
>> +       int offset, ret;
>> +
>> +       mutex_init(&gpio->iodev->iolock);
>> +       dev_set_drvdata(gpio->iodev->dev, gpio);
>> +
>> +    if (pdata) {
>> +        gpio->input_pullup_active = pdata->input_pullup_active;
>
> No way. No custom interfaces for setting pullups, use generic pin config.

What do you mean here? Could you please elaborate a bit more? The pull
up trait depends on the given hardware. It must be coming from
platform data, e.g. we can supply the right variant from our custom
board file.

>> +        gpio->gp.base = pdata->base;
>
> Why can't you always use dynamic assignments of GPIO numbers?

Because this information is board related.

>> +    } else {
>> +        gpio->gp.base = -1;
>
> Like this?

See above.

>> +    }
>> +       gpio->gp.label = gpio->iodev->dev->driver->name;
>
> = dev_name(gpio->iodev->dev); I think.
>
>> +    /*
>> +     * initialize input pullups according to platform data.
>> +     */
>
> No, this shall be done using a pinctrl table.

I will have a look...

>
>> +       ret = gpiochip_add(&gpio->gp);
>> +       if (ret)
>> +               goto exit_destroy;
>
> When implementing the pinctrl interface, you may want to use
> gpiochip_add_pin_range() to cross-reference between GPIOs
> and pinctrl.

Well, Guenter wanted to go through the gpio system... Perhaps, it was
not made clear that pinctrl would be better. I just followed the GPIO
generic guideline. :)

>
>> +EXPORT_SYMBOL_GPL(__max665x_probe);
>> +
>> +int __max665x_remove(struct device *dev)
>
> Argh these __underscores, get rid of them.

OK.

>> +++ b/include/linux/mfd/max6651-private.h
> (...)
>> +struct max665x_gpio {
>> +    u8     input_pullup_active;
>
> No way.

Why so? How would you make it customizable by board files otherwise?

>
>> +    struct max6651_dev *iodev;
>> +    struct gpio_chip gp;
>> +};
>> +
>> +extern int __max665x_remove(struct device *dev);
>> +extern int __max665x_probe(struct max665x_gpio *ts);
>
> Seems overengineered, try to keep all in one file.

OK?
