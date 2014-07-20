Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418AbaGTJUA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 05:20:00 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:33361 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbaGTJT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 05:19:58 -0400
MIME-Version: 1.0
In-Reply-To: <20140720063841.GA28059@udknight>
References: <20140720063841.GA28059@udknight>
Date: Sun, 20 Jul 2014 11:19:56 +0200
Message-ID: <CAN_we7Nuze_8tWqADGrhpeCtixssTzqf_wOZAYuAg+sv8nHJYA@mail.gmail.com>
Subject: Re: [PATCH v2] usb:serial:pl2303: add GPIOs interface on PL2303
From: Daniele Forsi <dforsi@gmail.com>
To: Wang YanQing <udknight@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linus.walleij@linaro.org, Johan Hovold <jhovold@gmail.com>,
        USB list <linux-usb@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-07-20 8:38 GMT+02:00 Wang YanQing:

> PL2303HX has two GPIOs, this patch add interface for it.

checkpatch.pl shows 2 errors:
ERROR: space required before the open parenthesis '('
#218: FILE: drivers/usb/serial/pl2303.c:309:
+ if(pl2303_vendor_read(gpio->serial, 0x0081, buf) < 1)

ERROR: that open brace { should be on the previous line
#248: FILE: drivers/usb/serial/pl2303.c:381:
+ if (type == TYPE_HX)
+ {

it also shows 3 warnings

> +#ifdef CONFIG_USB_SERIAL_PL2303_GPIO
> +struct pl2303_gpio {
> +       /*
> +        * 0..3: unknown (zero)
> +        * 4: gp0 output enable (1: gp0 pin is output, 0: gp0 pin is input)
> +        * 5: gp1 output enable (1: gp1 pin is output, 0: gp1 pin is input)
> +        * 6: gp0 pin value
> +        * 7: gp1 pin value
> +        */
> +       u8 index;
> +       struct usb_serial *serial;
> +       struct gpio_chip gpio_chip;
> +};
> +#endif

it would be nice to state what happens if you read pin 6 and 7 when
they are set for output

> @@ -262,6 +377,37 @@ static int pl2303_startup(struct usb_serial *serial)

> +                       gpio->gpio_chip.ngpio = 2;

you set ngpio but you don't use it
you would save some code if each function that use "index" has
if (index >= gpio->gpio_chip.ngpio)
  return -EINVAL;

and then read the constants from 2 arrays in file scope:
gpio_index_mask = {0x10, 0x20};
gpio_value_mask = {0x40, 0x80};

so you can change this:
> +       if (offset == 0) {
> +               gpio->index |= 0x10;
> +               if (value)
> +                       gpio->index |= 0x40;
> +               else
> +                       gpio->index &= ~0x40;
> +       } else if (offset == 1) {
> +               gpio->index |= 0x20;
> +               if (value)
> +                       gpio->index |= 0x80;
> +               else
> +                       gpio->index &= ~0x80;
> +       } else {
> +               return -EINVAL;
> +       }

to this:
               if (index >= gpio->gpio_chip.ngpio)
                       return -EINVAL;

              gpio->index |= gpio_index_mask[offset];
               if (value)
                       gpio->index |= gpio_value_mask[offset];
               else
                       gpio->index &= ~gpio_value_mask[offset];

do you find it less readable or less efficient?
-- 
Daniele Forsi
