Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933092Ab3CMOPU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 10:15:20 -0400
Received: from mail-ia0-f182.google.com ([209.85.210.182]:38028 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932356Ab3CMOPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 10:15:17 -0400
MIME-Version: 1.0
In-Reply-To: <1362662276-20792-7-git-send-email-ian@slimlogic.co.uk>
References: <1362662276-20792-1-git-send-email-ian@slimlogic.co.uk>
	<1362662276-20792-7-git-send-email-ian@slimlogic.co.uk>
Date: Wed, 13 Mar 2013 15:15:16 +0100
Message-ID: <CACRpkdaNs+NmAbuwRYzn1xgjHy=7ZknJa-GD1+Q8HBsu53KQqQ@mail.gmail.com>
Subject: Re: [PATCH v8 07/12] gpio: palmas: add in GPIO support for palmas charger
From: Linus Walleij <linus.walleij@linaro.org>
To: Ian Lartey <ian@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-leds@vger.kernel.org,
        linux-watchdog@vger.kernel.org, swarren@wwwdotorg.org,
        grant.likely@secretlab.ca, broonie@opensource.wolfsonmicro.com,
        rob.herring@calxeda.com, rob@landley.net, mturquette@linaro.org,
        cooloney@gmail.com, rpurdie@rpsys.net, sameo@linux.intel.com,
        wim@iguana.be, lgirdwood@gmail.com, gg@slimlogic.co.uk,
        j-keerthy@ti.com, ldewangan@nvidia.com, t-kristo@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for slow replies :-(

On Thu, Mar 7, 2013 at 2:17 PM, Ian Lartey <ian@slimlogic.co.uk> wrote:

> +static int palmas_gpio_read(struct palmas *palmas, unsigned int reg,
> +               int gpio, unsigned int *dest)

I don't like "int gpio" here, please use "int offset".

This is not a global GPIO number, it is an offset in the local gpio_chip,
right?

> +{
> +       /* registers for second bank are identical and offset by 0x9 */
> +       if (gpio > 7)
> +               reg += PALMAS_GPIO_DATA_IN2;
> +
> +       return palmas_read(palmas, PALMAS_GPIO_BASE, reg, dest);
> +}
> +
> +static int palmas_gpio_write(struct palmas *palmas, unsigned int reg,
> +               int gpio, unsigned int data)
> +{
> +       /* registers for second bank are identical and offset by 0x9 */
> +       if (gpio > 7)
> +               reg += PALMAS_GPIO_DATA_IN2;
> +
> +       return palmas_write(palmas, PALMAS_GPIO_BASE, reg, data);
> +}
> +
> +static int palmas_gpio_update_bits(struct palmas *palmas, unsigned int reg,
> +               int gpio, unsigned int mask, unsigned int data)
> +{
> +       /* registers for second bank are identical and offset by 0x9 */
> +       if (gpio > 7)
> +               reg += PALMAS_GPIO_DATA_IN2;
> +
> +       return palmas_update_bits(palmas, PALMAS_GPIO_BASE, reg, mask, data);
> +}


> -       ret = palmas_read(palmas, PALMAS_GPIO_BASE, PALMAS_GPIO_DATA_IN, &val);
> +       ret = palmas_gpio_read(palmas, PALMAS_GPIO_DATA_IN, offset, &val);

(Obviously you are passing the offset.)

> +               ret = palmas_gpio_write(palmas, PALMAS_GPIO_SET_DATA_OUT,
> +                               offset, BIT(offset % 8));
(..)
> +               ret = palmas_gpio_write(palmas, PALMAS_GPIO_CLEAR_DATA_OUT,
> +                               offset, BIT(offset % 8));
(...)
> +       ret = palmas_gpio_update_bits(palmas, PALMAS_GPIO_DATA_DIR,
> +                       offset, 1 << (offset % 8), 1 << (offset % 8));

Why aren't you using the BIT() macro here too?

Further: if these functions are always used like this, with offset
and some BIT() or (1 << (offset % 8)) why don't you move that
latter part into the static helper and just pass offset into the
helper?

Yours,
Linus Walleij
