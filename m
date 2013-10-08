Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab3JHHsJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 03:48:09 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:60681 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889Ab3JHHsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 03:48:03 -0400
MIME-Version: 1.0
X-Originating-IP: [111.240.48.148]
In-Reply-To: <1381217481-17252-1-git-send-email-sonic.adi@gmail.com>
References: <1381217481-17252-1-git-send-email-sonic.adi@gmail.com>
Date: Tue, 8 Oct 2013 15:48:02 +0800
Message-ID: <CAFRkauBxP-R2GB+DAYCXt1jf5UQY_cY8X7HqO4ZHkN6Njd8buw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: pinctrl-adi2: GPIO output value should be set
 after the GPIO interrupt is disabled.
From: Axel Lin <axel.lin@ingics.com>
To: Sonic Zhang <sonic.adi@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/8 Sonic Zhang <sonic.adi@gmail.com>:
> From: Sonic Zhang <sonic.zhang@analog.com>
>
> Use BIT macro as well.
>
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> ---
>  drivers/pinctrl/pinctrl-adi2.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/pinctrl/pinctrl-adi2.c b/drivers/pinctrl/pinctrl-adi2.c
> index a74e6f4..7a39562 100644
> --- a/drivers/pinctrl/pinctrl-adi2.c
> +++ b/drivers/pinctrl/pinctrl-adi2.c
> @@ -766,9 +766,9 @@ static void adi_gpio_set_value(struct gpio_chip *chip, unsigned offset,
>         spin_lock_irqsave(&port->lock, flags);
>
>         if (value)
> -               writew(1 << offset, &regs->data_set);
> +               writew(BIT(offset), &regs->data_set);
>         else
> -               writew(1 << offset, &regs->data_clear);
> +               writew(BIT(offset), &regs->data_clear);
>
>         spin_unlock_irqrestore(&port->lock, flags);
>  }
> @@ -780,12 +780,14 @@ static int adi_gpio_direction_output(struct gpio_chip *chip, unsigned offset,
>         struct gpio_port_t *regs = port->regs;
>         unsigned long flags;
>
> -       adi_gpio_set_value(chip, offset, value);
> -
>         spin_lock_irqsave(&port->lock, flags);
>
> -       writew(readw(&regs->inen) & ~(1 << offset), &regs->inen);
> -       writew(1 << offset, &regs->dir_set);
> +       writew(readw(&regs->inen) & ~BIT(offset), &regs->inen);
> +       if (value)
> +               writew(BIT(offset), &regs->data_set);
> +       else
> +               writew(BIT(offset), &regs->data_clear);

I think we can add an unlocked version of adi_gpio_set_value() to
avoid duplicated code.
