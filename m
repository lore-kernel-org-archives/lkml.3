Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbaJGNkj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 09:40:39 -0400
Received: from mail-yk0-f173.google.com ([209.85.160.173]:63368 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969AbaJGNkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 09:40:36 -0400
MIME-Version: 1.0
In-Reply-To: <1411726047-3224-2-git-send-email-rebecca.swee.fun.chang@intel.com>
References: <1411726047-3224-1-git-send-email-rebecca.swee.fun.chang@intel.com>
	<1411726047-3224-2-git-send-email-rebecca.swee.fun.chang@intel.com>
Date: Tue, 7 Oct 2014 16:40:35 +0300
Message-ID: <CAHp75VfV-yvSz1JuCnfL1ESbz-H6+yMqKvowJXKiOR3JftO60Q@mail.gmail.com>
Subject: Re: [PATCHv2 1/3] gpio: sch: Consolidate similar algorithms
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@intel.com>,
        GPIO Subsystem Mailing List <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 1:07 PM, Chang Rebecca Swee Fun
<rebecca.swee.fun.chang@intel.com> wrote:
> Consolidating similar algorithms into common functions to make
> GPIO SCH simpler and manageable.
>
> Signed-off-by: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
> ---
>  drivers/gpio/gpio-sch.c |   95 ++++++++++++++++++++++++++---------------------
>  1 file changed, 53 insertions(+), 42 deletions(-)
>
> diff --git a/drivers/gpio/gpio-sch.c b/drivers/gpio/gpio-sch.c
> index 99720c8..6e89be9 100644
> --- a/drivers/gpio/gpio-sch.c
> +++ b/drivers/gpio/gpio-sch.c
> @@ -63,94 +63,105 @@ static unsigned sch_gpio_bit(struct sch_gpio *sch, unsigned gpio)
>         return gpio % 8;
>  }
>
> -static void sch_gpio_enable(struct sch_gpio *sch, unsigned gpio)
> +static void sch_gpio_register_set(struct sch_gpio *sch, unsigned gpio,
> +                                 unsigned reg)
>  {
>         unsigned short offset, bit;
>         u8 enable;
>
>         spin_lock(&sch->lock);
>
> -       offset = sch_gpio_offset(sch, gpio, GEN);
> +       offset = sch_gpio_offset(sch, gpio, reg);
>         bit = sch_gpio_bit(sch, gpio);
>
>         enable = inb(sch->iobase + offset);
> -       if (!(enable & (1 << bit)))
> -               outb(enable | (1 << bit), sch->iobase + offset);
> +       if (!(enable & BIT(bit)))
> +               outb(enable | BIT(bit), sch->iobase + offset);
>
>         spin_unlock(&sch->lock);
>  }
>
> -static int sch_gpio_direction_in(struct gpio_chip *gc, unsigned  gpio_num)
> +static void sch_gpio_register_clear(struct sch_gpio *sch, unsigned gpio,
> +                                   unsigned reg)
>  {
> -       struct sch_gpio *sch = to_sch_gpio(gc);
> -       u8 curr_dirs;
>         unsigned short offset, bit;
> +       u8 disable;
>
>         spin_lock(&sch->lock);
>
> -       offset = sch_gpio_offset(sch, gpio_num, GIO);
> -       bit = sch_gpio_bit(sch, gpio_num);
> -
> -       curr_dirs = inb(sch->iobase + offset);
> +       offset = sch_gpio_offset(sch, gpio, reg);
> +       bit = sch_gpio_bit(sch, gpio);
>
> -       if (!(curr_dirs & (1 << bit)))
> -               outb(curr_dirs | (1 << bit), sch->iobase + offset);
> +       disable = inb(sch->iobase + offset);
> +       if (disable & BIT(bit))
> +               outb(disable & ~BIT(bit), sch->iobase + offset);
>
>         spin_unlock(&sch->lock);
> -       return 0;
>  }
>
> -static int sch_gpio_get(struct gpio_chip *gc, unsigned gpio_num)
> +static int sch_gpio_reg_get(struct gpio_chip *gc, unsigned gpio, unsigned reg)
>  {
>         struct sch_gpio *sch = to_sch_gpio(gc);
> -       int res;
>         unsigned short offset, bit;
> +       u8 curr_dirs;
>
> -       offset = sch_gpio_offset(sch, gpio_num, GLV);
> -       bit = sch_gpio_bit(sch, gpio_num);
> +       offset = sch_gpio_offset(sch, gpio, reg);
> +       bit = sch_gpio_bit(sch, gpio);
>
> -       res = !!(inb(sch->iobase + offset) & (1 << bit));
> +       curr_dirs = !!(inb(sch->iobase + offset) & BIT(bit));
>
> -       return res;
> +       return curr_dirs;
>  }
>
> -static void sch_gpio_set(struct gpio_chip *gc, unsigned gpio_num, int val)
> +static void sch_gpio_reg_set(struct gpio_chip *gc, unsigned gpio, unsigned reg,
> +                            int val)
>  {
>         struct sch_gpio *sch = to_sch_gpio(gc);
> -       u8 curr_vals;
>         unsigned short offset, bit;
> +       u8 curr_dirs;
>
> -       spin_lock(&sch->lock);
> -
> -       offset = sch_gpio_offset(sch, gpio_num, GLV);
> -       bit = sch_gpio_bit(sch, gpio_num);
> +       offset = sch_gpio_offset(sch, gpio, reg);
> +       bit = sch_gpio_bit(sch, gpio);
>
> -       curr_vals = inb(sch->iobase + offset);
> +       curr_dirs = inb(sch->iobase + offset);
>
>         if (val)
> -               outb(curr_vals | (1 << bit), sch->iobase + offset);
> +               outb(curr_dirs | BIT(bit), sch->iobase + offset);
>         else
> -               outb((curr_vals & ~(1 << bit)), sch->iobase + offset);
> +               outb((curr_dirs & ~BIT(bit)), sch->iobase + offset);

Looks like internal parentheses are redundant.

> +}
>
> +static int sch_gpio_direction_in(struct gpio_chip *gc, unsigned gpio_num)
> +{
> +       struct sch_gpio *sch = to_sch_gpio(gc);
> +
> +       spin_lock(&sch->lock);
> +       sch_gpio_register_set(sch, gpio_num, GIO);
>         spin_unlock(&sch->lock);
> +       return 0;
>  }
>
> -static int sch_gpio_direction_out(struct gpio_chip *gc, unsigned gpio_num,
> -                                 int val)
> +static int sch_gpio_get(struct gpio_chip *gc, unsigned gpio_num)
> +{
> +       return sch_gpio_reg_get(gc, gpio_num, GLV);
> +}
> +
> +static void sch_gpio_set(struct gpio_chip *gc, unsigned gpio_num, int val)
>  {
>         struct sch_gpio *sch = to_sch_gpio(gc);
> -       u8 curr_dirs;
> -       unsigned short offset, bit;
>
>         spin_lock(&sch->lock);
> +       sch_gpio_reg_set(gc, gpio_num, GLV, val);
> +       spin_unlock(&sch->lock);
> +}
>
> -       offset = sch_gpio_offset(sch, gpio_num, GIO);
> -       bit = sch_gpio_bit(sch, gpio_num);
> -
> -       curr_dirs = inb(sch->iobase + offset);
> -       if (curr_dirs & (1 << bit))
> -               outb(curr_dirs & ~(1 << bit), sch->iobase + offset);
> +static int sch_gpio_direction_out(struct gpio_chip *gc, unsigned gpio_num,
> +                                 int val)
> +{
> +       struct sch_gpio *sch = to_sch_gpio(gc);
>
> +       spin_lock(&sch->lock);
> +       sch_gpio_register_clear(sch, gpio_num, GIO);
>         spin_unlock(&sch->lock);
>
>         /*
> @@ -209,13 +220,13 @@ static int sch_gpio_probe(struct platform_device *pdev)
>                  * GPIO7 is configured by the CMC as SLPIOVR
>                  * Enable GPIO[9:8] core powered gpios explicitly
>                  */
> -               sch_gpio_enable(sch, 8);
> -               sch_gpio_enable(sch, 9);
> +               sch_gpio_register_set(sch, 8, GEN);
> +               sch_gpio_register_set(sch, 9, GEN);
>                 /*
>                  * SUS_GPIO[2:0] enabled by default
>                  * Enable SUS_GPIO3 resume powered gpio explicitly
>                  */
> -               sch_gpio_enable(sch, 13);
> +               sch_gpio_register_set(sch, 13, GEN);
>                 break;
>
>         case PCI_DEVICE_ID_INTEL_ITC_LPC:
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
With Best Regards,
Andy Shevchenko
