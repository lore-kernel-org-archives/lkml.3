Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbaKQLZD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 06:25:03 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:54720 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbaKQLY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 06:24:59 -0500
MIME-Version: 1.0
In-Reply-To: <1414677578-27412-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1414677578-27412-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
	<1414677578-27412-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Date: Mon, 17 Nov 2014 12:24:56 +0100
X-Google-Sender-Auth: BHtoHrQ630x6phibL4aYfHk5X3o
Message-ID: <CAMuHMdUaTU1MvmjuSMKohz1Nh0BmsfCW-JcPejOOsRCAjXwquA@mail.gmail.com>
Subject: Re: [PATCH 3/3] i2c: core: Map OF IRQ at probe time
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Linux I2C <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Thu, Oct 30, 2014 at 2:59 PM, Laurent Pinchart
<laurent.pinchart+renesas@ideasonboard.com> wrote:
> I2C clients instantiated from OF get their IRQ mapped at device
> registration time. This leads to the IRQ being silently ignored if the
> related irqchip hasn't been proved yet.
>
> Fix this by moving IRQ mapping at probe time using of_get_irq(). The
> function operates as irq_of_parse_and_map() but additionally returns
> -EPROBE_DEFER if the irqchip isn't available, allowing us to defer I2C
> client probing.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  drivers/i2c/i2c-core.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> index 258765b29684..c6694f232240 100644
> --- a/drivers/i2c/i2c-core.c
> +++ b/drivers/i2c/i2c-core.c
> @@ -631,6 +631,15 @@ static int i2c_device_probe(struct device *dev)
>         if (!client)
>                 return 0;
>
> +       if (!client->irq && dev->of_node) {
> +               int irq = of_irq_get(dev->of_node, 0);
> +
> +               if (irq < 0)
> +                       return irq;

This change broke all i2c slaves not having interrupts (e.g. da9210 and at24
on r8a7791/koelsch), which now fail to probe:

-DA9210: 1000 mV at 4600 mA
 ...
 i2c /dev entries driver
-at24 2-0050: 256 byte 24c02 EEPROM, writable, 16 bytes/write
+at24: probe of 2-0050 failed with error -22
 i2c-rcar e6530000.i2c: probed
 ...
+da9210: probe of 6-0068 failed with error -22
+i2c-sh_mobile e60b0000.i2c: I2C adapter 6, bus speed 100000 Hz, DMA=y

i2c_device_probe() fails because of_irq_get() returns -EINVAL,
originating from of_irq_parse_one() not finding an "interrupts" property
(there is none).

Apparently you overlooked a difference between irq_of_parse_and_map()
and of_get_irq(): the former returns 0 if there's no "interrupts" property,
while the latter forwards the error code from of_irq_parse_one.

I see two ways to fix this:
  1. Make of_get_irq() return 0 if no "interrupts" property was found, to
     make it behave more similar to irq_of_parse_and_map().
     Does any code rely on the error forwarding?
  2. Make i2c_device_probe() only return if -EPROBE_DEFER, and ignore
     all other error codes.
     It seems irq_create_of_mapping() never returns an error code, but
     0 in case of failures?

As platform_get_irq{,_byname}() do the latter, I'll cook a patch
to do that.

> +               client->irq = irq;
> +       }
> +
>         driver = to_i2c_driver(dev->driver);
>         if (!driver->probe || !driver->id_table)
>                 return -ENODEV;
> @@ -1412,7 +1421,6 @@ static void of_i2c_register_devices(struct i2c_adapter *adap)
>                         continue;
>                 }
>
> -               info.irq = irq_of_parse_and_map(node, 0);
>                 info.of_node = of_node_get(node);
>                 info.archdata = &dev_ad;
>
> @@ -1426,7 +1434,6 @@ static void of_i2c_register_devices(struct i2c_adapter *adap)
>                         dev_err(&adap->dev, "of_i2c: Failure registering %s\n",
>                                 node->full_name);
>                         of_node_put(node);
> -                       irq_dispose_mapping(info.irq);
>                         continue;
>                 }
>         }

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
