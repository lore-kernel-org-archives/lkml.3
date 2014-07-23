Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034AbaGWPGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:06:09 -0400
Received: from mail-oi0-f48.google.com ([209.85.218.48]:39879 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757371AbaGWPGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:06:04 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Jul 2014 11:06:03 EDT
MIME-Version: 1.0
In-Reply-To: <20140721024624.GA25469@udknight>
References: <20140721024624.GA25469@udknight>
Date: Wed, 23 Jul 2014 16:59:22 +0200
Message-ID: <CACRpkdYUkTWxzqX0AqvEUcCNVtbMeg=zmYDWd5fe3-SRnSTs8Q@mail.gmail.com>
Subject: Re: [PATCH v3] usb:serial:pl2303: add GPIOs interface on PL2303
From: Linus Walleij <linus.walleij@linaro.org>
To: Wang YanQing <udknight@gmail.com>, Greg KH <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Johan Hovold <jhovold@gmail.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        andi@lisas.de, dforsi@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 4:46 AM, Wang YanQing <udknight@gmail.com> wrote:

> PL2303HX has two GPIOs, this patch add interface for it.
>
> Signed-off-by: Wang YanQing <udknight@gmail.com>
> ---
>  Changes v2-v3:
>  1: fix errors and warnings reported by Daniele Forsi checked with checkpatch.pl
>  2: fix missing GPIOLIB dependence in Kconfig
>  3: fix pl2303_gpio_get can't work
>
>  Known issue:
>  If gpios are in use(export to userspace through sysfs interface, etc),
>  then call pl2303_release(unplug usb-serial convertor, modprobe -r, etc),
>  will cause trouble, so we need to make sure there is no gpio user before
>  call pl2303_release.

The sysfs ABI is not sound, using it is a recipe for trouble.
IIRC it was merged at a time when drivers/gpio was unmaintained :-(

(...)
> +static struct gpio_chip template_chip = {
> +       .label                  = "pl2303-gpio",
> +       .owner                  = THIS_MODULE,
> +       .direction_input        = pl2303_gpio_direction_in,
> +       .get                    = pl2303_gpio_get,
> +       .direction_output       = pl2303_gpio_direction_out,
> +       .set                    = pl2303_gpio_set,
> +       .can_sleep              = 1,

This is a bool so use = true,

> +#ifdef CONFIG_USB_SERIAL_PL2303_GPIO
> +       if (spriv && spriv->gpio) {
> +               if (gpiochip_remove(&spriv->gpio->gpio_chip))
> +                       dev_err(&serial->interface->dev,
> +                               "unable to remove gpio_chip?\n");

I'm getting rid of the return code from gpiochip_remove() and have removed
the __must_check tag in the gpio tree, so just call gpiochip_remove()
unconditionally and ignore any compile error messages for now.

Yours,
Linus Walleij
