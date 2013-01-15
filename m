Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536Ab3AOSgu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:36:50 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:42954 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757439Ab3AOSgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:36:43 -0500
Message-ID: <50F5A1B7.20504@wwwdotorg.org>
Date: Tue, 15 Jan 2013 11:36:39 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Patrice Chotard <patrice.chotard@st.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 3/4] pinctrl: add abx500 pinctrl driver core
References: <1358242984-5160-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1358242984-5160-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2013 02:43 AM, Linus Walleij wrote:
> From: Patrice Chotard <patrice.chotard@st.com>
> 
> This adds the AB8500 core driver, which will be utilized by
> the follow-on drivers for different ABx500 variants.
> Sselect the driver from the DBX500_SOC, as this chip is
> powering and clocking that SoC.

> diff --git a/drivers/pinctrl/pinctrl-abx500.c b/drivers/pinctrl/pinctrl-abx500.c

> +static int abx500_gpio_get(struct gpio_chip *chip, unsigned offset)

Shouldn't this call abx500_gpio_get_bit(), just like abx500_gpio_set()
calls abx500_gpio_set_bit()?

> +static int abx500_gpio_direction_output(struct gpio_chip *chip,
> +					unsigned offset,
> +					int val)
...
> +	/* disable pull down */
...
> +	/* if supported, disable both pull down and pull up */

Why the need to override those options?

> +static u8 abx500_get_mode(struct pinctrl_dev *pctldev, struct gpio_chip *chip,
> +		unsigned gpio)

> +	if (af.gpiosel_bit == UNUSED)
> +		return ABX500_DEFAULT;

That's odd; abx500_set_mode() seems to allow setting the mode to
something other than default even if (af.gpiosel_bit == UNUSED). Are
set_mode/get_mode actually correct inverses of each-other?

> +static int abx500_gpio_irq_init(struct abx500_pinctrl *pct)
...
> +#ifdef CONFIG_ARM
> +		set_irq_flags(irq, IRQF_VALID);
> +#else
> +		irq_set_noprobe(irq);
> +#endif

I assume that ifdef is always set one particular way?

> +static void abx500_gpio_irq_remove(struct abx500_pinctrl *pct)
...
> +#ifdef CONFIG_ARM
> +		set_irq_flags(irq, 0);
> +#endif

Same there.

> +static void abx500_pmx_disable(struct pinctrl_dev *pctldev,
> +			    unsigned function, unsigned group)
> +{
> +	struct abx500_pinctrl *pct = pinctrl_dev_get_drvdata(pctldev);
> +	const struct abx500_pingroup *g;
> +
> +	g = &pct->soc->groups[group];
> +	if (g->altsetting < 0)
> +		return;
> +
> +	/* Poke out the mux, set the pin to some default state? */
> +	dev_dbg(pct->dev, "disable group %s, %u pins\n", g->name, g->npins);
> +}

That looks basically unimplemented, and the comment seems like a FIXME?

> +int abx500_gpio_request_enable(struct pinctrl_dev *pctldev,
> +			    struct pinctrl_gpio_range *range,
> +			    unsigned offset)
...
> +	/*
> +	 * by default, for ABx5xx family, GPIO mode is selected by
> +	 * writing 1 in GPIOSELx registers
> +	 */
> +	ret = abx500_mask_and_set_register_interruptible(pct->dev,
> +		AB8500_MISC, reg, 1 << pos, 1 << pos);

It sounds like this should be implemented using abx500_set_mode()?

> +int abx500_pin_config_set(struct pinctrl_dev *pctldev,
> +		       unsigned pin,
> +		       unsigned long config)

> +	switch (param) {
> +	case PIN_CONFIG_BIAS_PULL_DOWN:
> +		/*
> +		 * if argument = 1 set the pull down
> +		 * else clear the pull down
> +		 */
> +		ret = abx500_gpio_direction_input(chip, offset);

That looks odd; why force the pin to be a GPIO just to enable a pull down?

> +		/* check if pin supports pull updown feature */
> +		if (pullud && pin >= pullud->first_pin	&& pin <= pullud->last_pin)
> +			ret = abx500_config_pull_updown(pct,
> +				offset,
> +				argument ? ABX500_GPIO_PULL_DOWN : ABX500_GPIO_PULL_NONE);
> +		else
> +			ret = abx500_gpio_set_bits(chip, AB8500_GPIO_PUD1_REG,
> +				offset, argument ? 0 : 1);

Hmm. Wouldn't it be better to remove the if statement, and just store
ABX500_GPIO_PULL_DOWN or 0, and ABX500_GPIO_PULL_NONE or 1, in the soc_data?

> +static int __devinit abx500_gpio_probe(struct platform_device *pdev)

> +	/* Poke in other ASIC variants here */
> +	switch (platid->driver_data) {
> +	case PINCTRL_AB8500:
> +		abx500_pinctrl_ab8500_init(&pct->soc);
> +		break;
> +	case PINCTRL_AB8540:
> +		abx500_pinctrl_ab8540_init(&pct->soc);
> +		break;
> +	case PINCTRL_AB9540:
> +		abx500_pinctrl_ab9540_init(&pct->soc);
> +		break;
> +	case PINCTRL_AB8505:
> +		abx500_pinctrl_ab8505_init(&pct->soc);
> +		break;
> +	default:
> +		dev_err(&pdev->dev, "Unsupported pinctrl sub driver (%d)\n",
> +				(int) platid->driver_data);
> +		return -EINVAL;
> +	}

Most of those functions don't exist yet. I see there are dummy inlines
below for them if the /config/ options aren't turned on, but what's to
stop somebody turning on the config option before the real
implementation exists?

In the past, Arnd requested that each variant had a separate top-level
driver object that called into a utility probe() function, rather than
having a probe() function that knew about all the SoC variants, and
dispatched out to a variant-specific function.

> +static int __devexit abx500_gpio_remove(struct platform_device *pdev)

> +	platform_set_drvdata(pdev, NULL);

There's no point doing that; nothing should touch the drvdata while the
device doesn't exist (or isn't probed rather).

> +	mutex_destroy(&pct->lock);
> +	kfree(pct);

That was allocated using devm_kzalloc(). There's no point freeing it
here, and if there were, devm_kfree() should be used, or a double-free
will occur.
