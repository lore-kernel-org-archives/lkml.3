Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab3ARTWf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 14:22:35 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:49354 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab3ARTWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 14:22:33 -0500
MIME-Version: 1.0
In-Reply-To: <1357681398-23956-3-git-send-email-maxime.ripard@free-electrons.com>
References: <1357681398-23956-1-git-send-email-maxime.ripard@free-electrons.com>
	<1357681398-23956-3-git-send-email-maxime.ripard@free-electrons.com>
Date: Fri, 18 Jan 2013 20:22:32 +0100
Message-ID: <CACRpkdb9ZGUy4Fa3pLLEDe71Goix6k_tXKs6nnffCeTnW6YAUA@mail.gmail.com>
Subject: Re: [PATCH 2/7] ARM: sunxi: Add pinctrl driver for Allwinner SoCs
From: Linus Walleij <linus.walleij@linaro.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org, Stefan Roese <sr@denx.de>,
        Alejandro Mery <amery@geeks.cl>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 8, 2013 at 10:43 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:

> +config PINCTRL_SUNXI
> +       bool
> +       select PINMUX
> +       select GENERIC_PINCONF

Very nice that you use generic pinconf!

> +++ b/drivers/pinctrl/pinctrl-sunxi.c
(...)
> +       switch (pinconf_to_config_param(config)) {
> +       case PIN_CONFIG_DRIVE_STRENGTH:
> +               strength = pinconf_to_config_argument(config);
> +               /*
> +                * We convert from mA to what the register expects:
> +                *   - 0: 10mA
> +                *   - 1: 20mA
> +                *   - 2: 30mA
> +                *   - 3: 40mA
> +                */

Nitpick: remove the "-" (dash), some newcomer will invariably
interpret the numbers as negative :-/

Don't you want some bounds checking here?

if (strength > 40) { bail out }

> +               dlevel = strength / 10 - 1;
> +               val = readl(pctl->membase + sunxi_dlevel_reg(g->pin));
> +               mask = ((1 << DLEVEL_PINS_BITS) - 1) << sunxi_dlevel_offset(g->pin);

Uhhh ... ((1 << DLEVEL_PINS_BITS) - 1) ...

Which in this case is ((1 << 4) - 1). So ...

10000 - 1 = 01111

So this is a way to say "mask four lowest bits".

What about just adding this instead then:

#define DLEVEL_PINS_MASK 0x0f

> +               val &= ~mask;
> +               val |= dlevel << sunxi_dlevel_offset(g->pin);
> +               writel(val, pctl->membase + sunxi_dlevel_reg(g->pin));
> +               break;
> +       case PIN_CONFIG_BIAS_PULL_UP:
> +               val = readl(pctl->membase + sunxi_pull_reg(g->pin));
> +               mask = ((1 << PULL_PINS_BITS) - 1) << sunxi_pull_offset(g->pin);

Same. #define a MASK.

> +               val &= ~mask;
> +               val |= 1 << sunxi_pull_offset(g->pin);
> +               writel(val, pctl->membase + sunxi_pull_reg(g->pin));
> +               break;
> +       case PIN_CONFIG_BIAS_PULL_DOWN:
> +               val = readl(pctl->membase + sunxi_pull_reg(g->pin));
> +               mask = ((1 << PULL_PINS_BITS) - 1) << sunxi_pull_offset(g->pin);

Dito.

> +               val &= ~mask;
> +               val |= 2 << sunxi_pull_offset(g->pin);
> +               writel(val, pctl->membase + sunxi_pull_reg(g->pin));
> +               break;
> +       default:
> +               break;
> +       }
> +
> +       /* cache the config value */
> +       g->config = config;
> +
> +       return 0;
> +}
(...)
> +static void sunxi_pmx_set(struct pinctrl_dev *pctldev,
> +                                unsigned pin,
> +                                u8 config)
> +{
> +       struct sunxi_pinctrl *pctl = pinctrl_dev_get_drvdata(pctldev);
> +
> +       u32 val = readl(pctl->membase + sunxi_mux_reg(pin));
> +       u32 mask = ((1 << MUX_PINS_BITS) - 1) << sunxi_mux_offset(pin);

Dito.

> +       writel((val & ~mask) | config << sunxi_mux_offset(pin),
> +               pctl->membase + sunxi_mux_reg(pin));
> +}
(...)
> +static struct of_device_id sunxi_pinctrl_match[] __devinitconst = {
> +       {}
> +};

What is this supposed to match?

Maybe I don't understand DT boilerplate at all times, bear with me.

> +MODULE_DEVICE_TABLE(of, sunxi_pinctrl_match);
(...)
> +static int __devinit sunxi_pinctrl_add_function(struct sunxi_pinctrl *pctl,
> +                                       const char *name)

__devinit is deleted in the kernel so I would get a regression if I
tried to apply this patch. Just remove __devinit.

(...)
> +static int __devinit sunxi_pinctrl_build_state(struct platform_device *pdev)

Dito.

(...)
> +static int __devinit sunxi_pinctrl_probe(struct platform_device *pdev)

Dito.

(...)
> +++ b/drivers/pinctrl/pinctrl-sunxi.h
(...)
> +/*
> + * The sunXi PIO registers are organized as is:
> + * 0x00 - 0x0c Muxing values.
> + *             8 pins per register, each pin having a 4bits value
> + * 0x10                Pin values
> + *             32 bits per register, each pin corresponding to one bit
> + * 0x14 - 0x18 Drive level
> + *             16 pins per register, each pin having a 2bits value
> + * 0x1c - 0x20 Pull-Up values
> + *             16 pins per register, each pin having a 2bits value
> + *
> + * This is for the first bank. Each bank will have the same layout,
> + * with an offset being a multiple of 0x24.
> + *
> + * The following functions calculate from the pin number the register
> + * and the bit offset that we should access.
> + */

Very nice with this documentation!

Yours,
Linus Walleij
