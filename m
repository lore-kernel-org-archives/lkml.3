Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225AbaGWQEQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 12:04:16 -0400
Received: from cpc2-cwma8-2-0-cust224.7-3.cable.virginm.net ([82.20.154.225]:58840
	"EHLO alan.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757646AbaGWQEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 12:04:15 -0400
Date: Wed, 23 Jul 2014 17:03:14 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Wang YanQing <udknight@gmail.com>
Cc: gregkh@linuxfoundation.org, linus.walleij@linaro.org, jhovold@gmail.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] usb:serial:pl2303: add GPIOs interface on PL2303
Message-ID: <20140723170314.23864779@alan.etchedpixels.co.uk>
In-Reply-To: <20140720063841.GA28059@udknight>
References: <20140720063841.GA28059@udknight>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> --- a/drivers/usb/serial/pl2303.c
> +++ b/drivers/usb/serial/pl2303.c
> @@ -28,6 +28,9 @@
>  #include <linux/usb.h>
>  #include <linux/usb/serial.h>
>  #include <asm/unaligned.h>
> +#ifdef CONFIG_USB_SERIAL_PL2303_GPIO
> +#include <linux/gpio.h>
> +#endif
>  #include "pl2303.h"

Just include the file anyway it does no harm

>  
>  
> @@ -143,9 +146,27 @@ struct pl2303_type_data {
>  	unsigned long quirks;
>  };
>  
> +#ifdef CONFIG_USB_SERIAL_PL2303_GPIO
> +struct pl2303_gpio {
> +	/*
> +	 * 0..3: unknown (zero)
> +	 * 4: gp0 output enable (1: gp0 pin is output, 0: gp0 pin is input)
> +	 * 5: gp1 output enable (1: gp1 pin is output, 0: gp1 pin is input)
> +	 * 6: gp0 pin value
> +	 * 7: gp1 pin value
> +	 */
> +	u8 index;
> +	struct usb_serial *serial;
> +	struct gpio_chip gpio_chip;
> +};
> +#endif

Declaring the struct anyway does no harm


>  	struct pl2303_serial_private *spriv = usb_get_serial_data(serial);
>  
> +#ifdef CONFIG_USB_SERIAL_PL2303_GPIO
> +	if (spriv && spriv->gpio) {

Can spriv ever be NULL - how would that occur?


> +		if (gpiochip_remove(&spriv->gpio->gpio_chip))
> +			dev_err(&serial->interface->dev, "unable to remove gpio_chip?\n");
> +		kfree(spriv->gpio);
> +	}
> +#endif
>  	kfree(spriv);

Only other question I have - if I have multiple PL2303HX adapters how
will I work out which GPIO lines belong to which /dev/ttyUSB* interface ?

Do we need a way to actually ask the serial port for its GPIO range ?
