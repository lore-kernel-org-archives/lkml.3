Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab3AXMCo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 07:02:44 -0500
Received: from mail-vb0-f50.google.com ([209.85.212.50]:54553 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065Ab3AXMCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 07:02:39 -0500
MIME-Version: 1.0
In-Reply-To: <1358856404-8975-7-git-send-email-stigge@antcom.de>
References: <1358856404-8975-1-git-send-email-stigge@antcom.de>
	<1358856404-8975-7-git-send-email-stigge@antcom.de>
Date: Thu, 24 Jan 2013 13:02:38 +0100
Message-ID: <CAOY=C6H5xETt5UNXUfRkGW9q+bj0y2R3sXNvW87XXvQcYoL_-g@mail.gmail.com>
Subject: Re: [PATCH 6/6 v14] gpio: Add block gpio to several gpio drivers
From: Stijn Devriendt <highguy@gmail.com>
To: Roland Stigge <stigge@antcom.de>
Cc: gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, plagnioj@jcrosoft.com,
        broonie@opensource.wolfsonmicro.com, daniel-gl@gmx.net,
        rmallon@gmail.com, sr@denx.de, wg@grandegger.com, mark.rutland@arm.com,
        nicolas.ferre@atmel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 1:06 PM, Roland Stigge <stigge@antcom.de> wrote:
> This patch adds block GPIO support to several gpio drivers.
>
> This implements block GPIO only for some selected drivers since block GPIO is
> an optional feature which may not be suitable for every GPIO hardware. (With
> automatic fallback to the single GPIO functions if not available in a driver.)
>
> Signed-off-by: Roland Stigge <stigge@antcom.de>
>
> For pinctrl-at91.c:
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>
> ---
>
> +static void lpc32xx_gpio_set_block_p3(struct gpio_chip *chip,
> +                                     unsigned long mask,
> +                                     unsigned long values)
> +{
> +       struct lpc32xx_gpio_chip *group = to_lpc32xx_gpio(chip);
> +       u32 set_bits = values & mask;
> +       u32 clr_bits = ~values & mask;
> +
> +       /* States of GPIO 0-5 start at bit 25 */
> +       set_bits <<= 25;
> +       clr_bits <<= 25;
> +
> +       /* Note: On LPC32xx, GPOs can only be set at once or cleared at once,
> +        *       but not set and cleared at once
> +        */
> +       if (set_bits)
> +               __raw_writel(set_bits, group->gpio_grp->outp_set);
> +       if (clr_bits)
> +               __raw_writel(clr_bits, group->gpio_grp->outp_clr);
> +}
> +

In my patch, I go out of the way of this kind of thing for a simple reason:
You may generate incorrect timing by doing this.

As a fictive example, consider the i2c-bitbang driver, which you could optimize
by using block-gpio with sda/scl in a single block. By offering the
block-gpio API
even when you cannot set all bits at once, you could cause timing issues.
You might be toggling the clock line before pushing out data, for example.

The same holds below, for a driver that has separate hi/lo bits.

Regards,
Stijn
