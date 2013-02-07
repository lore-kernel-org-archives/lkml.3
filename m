Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840Ab3BGTDI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 14:03:08 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:40307 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758580Ab3BGTDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 14:03:07 -0500
MIME-Version: 1.0
In-Reply-To: <1360261079-24361-1-git-send-email-tobetter@gmail.com>
References: <1360261079-24361-1-git-send-email-tobetter@gmail.com>
Date: Thu, 7 Feb 2013 20:03:05 +0100
Message-ID: <CACRpkdb7gFAr=-WbeMv98t6wcM+T2yJ+BqhLxiSY=Oq=9fnLYQ@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: No bus setup if default pinctrl is used
From: Linus Walleij <linus.walleij@linaro.org>
To: Dongjin Kim <tobetter@gmail.com>
Cc: Thomas Abraham <thomas.ab@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 7, 2013 at 7:17 PM, Dongjin Kim <tobetter@gmail.com> wrote:

> Legacy gpio based bus setup is failed when the bus pins are listed with the
> property 'pinctrl-0' and 'pinctrl-names', instead of 'gpios'. The default
> pinctrls are handled by device core before probe, no need to configure the
> pins again in a device driver.

Aha.

>  {
>         int idx, gpio, ret;
> +       int nr_pins = NUM_PINS(bus_width);
>
>         if (!slot_np)
>                 return -EINVAL;
>
> +#if defined(CONFIG_PINCTRL)
> +       /* Default pinctrl is used */
> +       if (!IS_ERR(host->dev->pins->default_state))
> +               nr_pins = 0;
> +#endif

Use:

if (IS_ENABLED(CONFIG_PINCTRL))
   nr_pins = 0;

Without ifdefs. Grep kernel for examples.
Read <linux/kconfig.h> for explanations.

Put a comment above this to explain exactly why
you do this.

> +
>         /* cmd + clock + bus-width pins */
> -       for (idx = 0; idx < NUM_PINS(bus_width); idx++) {
> +       for (idx = 0; idx < nr_pins; idx++) {
>                 gpio = of_get_gpio(slot_np, idx);
>                 if (!gpio_is_valid(gpio)) {
>                         dev_err(host->dev, "invalid gpio: %d\n", gpio);

This looks kludgy, is it so that the driver falls back to GPIO
if it cannot use pinctrl? Can't it just depend on CONFIG_PINCTRL
in Kconfig or do you absolutely have to support both cases?

I was under the impression that the Exynos requires pinctrl.

Yours,
Linus Walleij
