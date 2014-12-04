Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311AbaLDIn7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 03:43:59 -0500
Received: from mail-ig0-f182.google.com ([209.85.213.182]:48949 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbaLDIn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 03:43:57 -0500
MIME-Version: 1.0
In-Reply-To: <1416977280-27319-2-git-send-email-rebecca.swee.fun.chang@intel.com>
References: <1416977280-27319-1-git-send-email-rebecca.swee.fun.chang@intel.com>
 <1416977280-27319-2-git-send-email-rebecca.swee.fun.chang@intel.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 4 Dec 2014 17:43:36 +0900
Message-ID: <CAAVeFuLRbouvGXYUZ5nM-+X+2S3nyJdziHTz-yrZo49PHSp7XQ@mail.gmail.com>
Subject: Re: [PATCHv4 1/3] gpio: sch: Consolidate similar algorithms
To: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GPIO Subsystem Mailing List <linux-gpio@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@intel.com>,
        Denis Turischev <denis.turischev@compulab.co.il>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-26 13:47 GMT+09:00 Chang Rebecca Swee Fun
<rebecca.swee.fun.chang@intel.com>:
> Consolidating similar algorithms into common functions to make
> GPIO SCH simpler and manageable.
>
> Signed-off-by: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
> ---
>  drivers/gpio/gpio-sch.c |   81 ++++++++++++++++-------------------------------
>  1 file changed, 28 insertions(+), 53 deletions(-)

Your v3 had this:

 drivers/gpio/gpio-sch.c |   95 ++++++++++++++++++++++++++---------------------
 1 file changed, 53 insertions(+), 42 deletions(-)

Just looking at these two lines we can already tell this v4 is going
to be *much* better. :)

>
> diff --git a/drivers/gpio/gpio-sch.c b/drivers/gpio/gpio-sch.c
> index 99720c8..7967f14 100644
> --- a/drivers/gpio/gpio-sch.c
> +++ b/drivers/gpio/gpio-sch.c
> @@ -63,75 +63,59 @@ static unsigned sch_gpio_bit(struct sch_gpio *sch, unsigned gpio)
>         return gpio % 8;
>  }
>
> -static void sch_gpio_enable(struct sch_gpio *sch, unsigned gpio)
> +static int sch_gpio_reg_get(struct gpio_chip *gc, unsigned gpio, unsigned reg)
>  {
> +       struct sch_gpio *sch = to_sch_gpio(gc);
>         unsigned short offset, bit;
> -       u8 enable;
> -
> -       spin_lock(&sch->lock);
> +       u8 curr_dirs;

This name sounds weird in this function. It has been copied from the
direction setting functions, but this function is much more generic.
So maybe come with a more generic name as well?

>
> -       offset = sch_gpio_offset(sch, gpio, GEN);
> +       offset = sch_gpio_offset(sch, gpio, reg);
>         bit = sch_gpio_bit(sch, gpio);
>
> -       enable = inb(sch->iobase + offset);
> -       if (!(enable & (1 << bit)))
> -               outb(enable | (1 << bit), sch->iobase + offset);
> +       curr_dirs = !!(inb(sch->iobase + offset) & BIT(bit));
>
> -       spin_unlock(&sch->lock);
> +       return curr_dirs;
>  }
>
> -static int sch_gpio_direction_in(struct gpio_chip *gc, unsigned  gpio_num)
> +static void sch_gpio_reg_set(struct gpio_chip *gc, unsigned gpio, unsigned reg,
> +                            int val)
>  {
>         struct sch_gpio *sch = to_sch_gpio(gc);
> -       u8 curr_dirs;
>         unsigned short offset, bit;
> +       u8 curr_dirs;

Same here.

Meh, I guess that's my only complain... This really makes the driver
easier to understand, so after fixing this minor issue and rebasing on
Linus' devel branch, feel free to add my

Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
