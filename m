Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027Ab3AUM0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 07:26:11 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:49996 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab3AUM0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 07:26:09 -0500
MIME-Version: 1.0
In-Reply-To: <50F5A1B7.20504@wwwdotorg.org>
References: <1358242984-5160-1-git-send-email-linus.walleij@stericsson.com>
	<50F5A1B7.20504@wwwdotorg.org>
Date: Mon, 21 Jan 2013 13:26:08 +0100
Message-ID: <CACRpkdYuCkE9fChHNKxYot6vYVW392vfT1tCCh-rSPr7t094+A@mail.gmail.com>
Subject: Re: [PATCH 3/4] pinctrl: add abx500 pinctrl driver core
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Patrice Chotard <patrice.chotard@st.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Patrice, jump in if I'm saying something wrong.]

On Tue, Jan 15, 2013 at 7:36 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 01/15/2013 02:43 AM, Linus Walleij wrote:
>> From: Patrice Chotard <patrice.chotard@st.com>
>>
>> This adds the AB8500 core driver, which will be utilized by
>> the follow-on drivers for different ABx500 variants.
>> Sselect the driver from the DBX500_SOC, as this chip is
>> powering and clocking that SoC.
>
>> diff --git a/drivers/pinctrl/pinctrl-abx500.c b/drivers/pinctrl/pinctrl-abx500.c
>
>> +static int abx500_gpio_get(struct gpio_chip *chip, unsigned offset)
>
> Shouldn't this call abx500_gpio_get_bit(), just like abx500_gpio_set()
> calls abx500_gpio_set_bit()?

OK done.

>> +static int abx500_gpio_direction_output(struct gpio_chip *chip,
>> +                                     unsigned offset,
>> +                                     int val)
> ...
>> +     /* disable pull down */
> ...
>> +     /* if supported, disable both pull down and pull up */
>
> Why the need to override those options?

Because of electronics, if you're going to use something as output
any pulling will just leak current through the resistor. These drivers
are push/pull and can't do fancy stuff like open collector/drain
so pulling something that is an output is strictly illegal.

Of course the pin config should never be set up like that in the
first place, but to be sure, or the case where said pin is not set
up in the pinmap, this adds additional security.

>> +static u8 abx500_get_mode(struct pinctrl_dev *pctldev, struct gpio_chip *chip,
>> +             unsigned gpio)
>
>> +     if (af.gpiosel_bit == UNUSED)
>> +             return ABX500_DEFAULT;
>
> That's odd; abx500_set_mode() seems to allow setting the mode to
> something other than default even if (af.gpiosel_bit == UNUSED). Are
> set_mode/get_mode actually correct inverses of each-other?

Well this clause is correct, because pins that do not use the GPIOSEL
register have only one possible function, which is also hardwired to
the pin, so you cannot select anything else.

But when you *set* the default mode, it is done in one of two
different ways, either by writing zero to the GPIOSEL register or
by writing 1 to the GPIOSEL register, depending on which
GPIO it is. (I didn't invent this hardware.)

The set() function does not disallow setting default mode on
pins that only have default mode though, so that's why that
code path is slightly longer.

But the sentinel in the beginning of the set() function still
explicitly disallows impossible combinations so it should be
safe.

I hope this make thinks clearer :-/

>> +static int abx500_gpio_irq_init(struct abx500_pinctrl *pct)
> ...
>> +#ifdef CONFIG_ARM
>> +             set_irq_flags(irq, IRQF_VALID);
>> +#else
>> +             irq_set_noprobe(irq);
>> +#endif
>
> I assume that ifdef is always set one particular way?
>
>> +static void abx500_gpio_irq_remove(struct abx500_pinctrl *pct)
> ...
>> +#ifdef CONFIG_ARM
>> +             set_irq_flags(irq, 0);
>> +#endif
>
> Same there.

It's not always set in a particular way unless we e.g. depend on
it in Kconfig.

Some time back the people doing x86_64 allyesconfig builds
told me to not unnecessarily disallow the compilation of my
drivers, so this gets some test compilation coverage also on
the standard builds like this, and I think that's one of the major
resons to why you find this in a few GPIO drivers & such.

I'm split about the thing, it's a small price for some nice compile-
coverage.

>> +static void abx500_pmx_disable(struct pinctrl_dev *pctldev,
>> +                         unsigned function, unsigned group)
>> +{
>> +     struct abx500_pinctrl *pct = pinctrl_dev_get_drvdata(pctldev);
>> +     const struct abx500_pingroup *g;
>> +
>> +     g = &pct->soc->groups[group];
>> +     if (g->altsetting < 0)
>> +             return;
>> +
>> +     /* Poke out the mux, set the pin to some default state? */
>> +     dev_dbg(pct->dev, "disable group %s, %u pins\n", g->name, g->npins);
>> +}
>
> That looks basically unimplemented, and the comment seems like a FIXME?

Yes well, I've put in a FIXME.

>> +int abx500_gpio_request_enable(struct pinctrl_dev *pctldev,
>> +                         struct pinctrl_gpio_range *range,
>> +                         unsigned offset)
> ...
>> +     /*
>> +      * by default, for ABx5xx family, GPIO mode is selected by
>> +      * writing 1 in GPIOSELx registers
>> +      */
>> +     ret = abx500_mask_and_set_register_interruptible(pct->dev,
>> +             AB8500_MISC, reg, 1 << pos, 1 << pos);
>
> It sounds like this should be implemented using abx500_set_mode()?

OK done.

>> +int abx500_pin_config_set(struct pinctrl_dev *pctldev,
>> +                    unsigned pin,
>> +                    unsigned long config)
>
>> +     switch (param) {
>> +     case PIN_CONFIG_BIAS_PULL_DOWN:
>> +             /*
>> +              * if argument = 1 set the pull down
>> +              * else clear the pull down
>> +              */
>> +             ret = abx500_gpio_direction_input(chip, offset);
>
> That looks odd; why force the pin to be a GPIO just to enable a pull down?

This is to avoid the situation where you drive current (when set as
output) through the pull-down resistor.

I.e. a way to avoid doing illegal things. Safety measure.

(As per above, no open drain/collector here, this is push/pull)

>> +             /* check if pin supports pull updown feature */
>> +             if (pullud && pin >= pullud->first_pin  && pin <= pullud->last_pin)
>> +                     ret = abx500_config_pull_updown(pct,
>> +                             offset,
>> +                             argument ? ABX500_GPIO_PULL_DOWN : ABX500_GPIO_PULL_NONE);
>> +             else
>> +                     ret = abx500_gpio_set_bits(chip, AB8500_GPIO_PUD1_REG,
>> +                             offset, argument ? 0 : 1);
>
> Hmm. Wouldn't it be better to remove the if statement, and just store
> ABX500_GPIO_PULL_DOWN or 0, and ABX500_GPIO_PULL_NONE or 1, in the soc_data?

So on some chips, some ranges of pins support both pull up and pull
down, and those are handled in the first branch of the clause.

Others just support pull down, and those are handled in the second
clause.

The "pullud" range is supposed to be reused when we implement
setting pull up as well, then it comes in handy.

But I added some comments so it's clear why we do this.

>> +static int __devinit abx500_gpio_probe(struct platform_device *pdev)
>
>> +     /* Poke in other ASIC variants here */
>> +     switch (platid->driver_data) {
>> +     case PINCTRL_AB8500:
>> +             abx500_pinctrl_ab8500_init(&pct->soc);
>> +             break;
>> +     case PINCTRL_AB8540:
>> +             abx500_pinctrl_ab8540_init(&pct->soc);
>> +             break;
>> +     case PINCTRL_AB9540:
>> +             abx500_pinctrl_ab9540_init(&pct->soc);
>> +             break;
>> +     case PINCTRL_AB8505:
>> +             abx500_pinctrl_ab8505_init(&pct->soc);
>> +             break;
>> +     default:
>> +             dev_err(&pdev->dev, "Unsupported pinctrl sub driver (%d)\n",
>> +                             (int) platid->driver_data);
>> +             return -EINVAL;
>> +     }
>
> Most of those functions don't exist yet.

Sorry about this, I'll strip the chips out and add them with
respective chip patch.

I want to get this core driver and AB8500 vanilla in first,
then proceed with the other variants.

> In the past, Arnd requested that each variant had a separate top-level
> driver object that called into a utility probe() function, rather than
> having a probe() function that knew about all the SoC variants, and
> dispatched out to a variant-specific function.

Yeah, as usual I'm happy with either approach as long as it's
straight-forward.

Is it a big issue?

>> +static int __devexit abx500_gpio_remove(struct platform_device *pdev)
>
>> +     platform_set_drvdata(pdev, NULL);
>
> There's no point doing that; nothing should touch the drvdata while the
> device doesn't exist (or isn't probed rather).

OK.

>> +     mutex_destroy(&pct->lock);
>> +     kfree(pct);
>
> That was allocated using devm_kzalloc(). There's no point freeing it
> here, and if there were, devm_kfree() should be used, or a double-free
> will occur.

OK.

Thanks a *lot* Stephen, I'll post v2 soon.

Yours,
Linus Walleij
