Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbaIWPix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 11:38:53 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:48085 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992AbaIWPiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 11:38:51 -0400
MIME-Version: 1.0
In-Reply-To: <1411031032-20649-1-git-send-email-gvormayr@gmail.com>
References: <1411031032-20649-1-git-send-email-gvormayr@gmail.com>
Date: Tue, 23 Sep 2014 17:38:51 +0200
Message-ID: <CACRpkdZJajGr+Y4OTBf0W697G9ipBKH-y67EU69C-6cCiVbSRw@mail.gmail.com>
Subject: Re: [PATCH 1/1] gpio: Fix ngpio in gpio-xilinx driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Gernot Vormayr <gvormayr@gmail.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 11:03 AM, Gernot Vormayr <gvormayr@gmail.com> wrote:

> If one adds 'gpio-controller;' to the chip in the devicetree, then
> initialization fails with 'gpiochip_find_base: cannot find free range',
> because ngpio is 0. This patch fixes the bug.
>
> Tested on ml507 board.
>
> Signed-off-by: Gernot Vormayr <gvormayr@gmail.com>
> ---
>  drivers/gpio/gpio-xilinx.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/gpio/gpio-xilinx.c b/drivers/gpio/gpio-xilinx.c
> index 1248186..4606ad2 100644
> --- a/drivers/gpio/gpio-xilinx.c
> +++ b/drivers/gpio/gpio-xilinx.c
> @@ -197,6 +197,7 @@ static int xgpio_of_probe(struct device_node *np)
>         struct xgpio_instance *chip;
>         int status = 0;
>         const u32 *tree_info;
> +       u32 ngpio;
>
>         chip = kzalloc(sizeof(*chip), GFP_KERNEL);
>         if (!chip)
> @@ -215,8 +216,9 @@ static int xgpio_of_probe(struct device_node *np)
>         chip->mmchip.gc.ngpio = 32;

Delete that line ^

>
>         /* Check device node and parent device node for device width */
> -       of_property_read_u32(np, "xlnx,gpio-width",
> -                             (u32 *)&chip->mmchip.gc.ngpio);
> +       status = of_property_read_u32(np, "xlnx,gpio-width", &ngpio);
> +       if (status == 0)
> +               chip->mmchip.gc.ngpio = (u16)ngpio;

Rewrite like this:

if (of_property_read_u32(np, "xlnx,gpio-width", &ngpio))
    ngpio = 32;
chip->mmchip.gc.ngpio = (u16)ngpio;

>
>         spin_lock_init(&chip->gpio_lock);
>
> @@ -262,8 +264,9 @@ static int xgpio_of_probe(struct device_node *np)
>                 chip->mmchip.gc.ngpio = 32;
>
>                 /* Check device node and parent device node for device width */
> -               of_property_read_u32(np, "xlnx,gpio2-width",
> -                                    (u32 *)&chip->mmchip.gc.ngpio);
> +               status = of_property_read_u32(np, "xlnx,gpio2-width", &ngpio);
> +               if (status == 0)
> +                       chip->mmchip.gc.ngpio = (u16)ngpio;

Same comment.

The fact that the same code appears in two places tells us something
is not quite right. Can you look into consolidating this (in a separate
patch)?

Yours,
Linus Walleij
