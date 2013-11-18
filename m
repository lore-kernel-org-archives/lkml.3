Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790Ab3KRNLj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 08:11:39 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36209 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab3KRNLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 08:11:33 -0500
MIME-Version: 1.0
In-Reply-To: <1383905510-31760-4-git-send-email-prabhakar.csengg@gmail.com>
References: <1383905510-31760-1-git-send-email-prabhakar.csengg@gmail.com>
	<1383905510-31760-4-git-send-email-prabhakar.csengg@gmail.com>
Date: Mon, 18 Nov 2013 14:11:32 +0100
Message-ID: <CACRpkdaJg4wqtD5xhPVrHJHxFoVwau6jidbOuQ9xFSK_6drxPQ@mail.gmail.com>
Subject: Re: [PATCH v5 3/7] gpio: davinci: use irqdomain
From: Linus Walleij <linus.walleij@linaro.org>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: Sekhar Nori <nsekhar@ti.com>, Grygorii Strashko <grygorii.strashko@ti.com>,
        LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 8, 2013 at 11:11 AM, Prabhakar Lad
<prabhakar.csengg@gmail.com> wrote:

> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>
> This patch converts the davinci gpio driver to use irqdomain
> support.
>
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

(...)
> @@ -282,8 +283,7 @@ gpio_irq_handler(unsigned irq, struct irq_desc *desc)
>         desc->irq_data.chip->irq_ack(&desc->irq_data);
>         while (1) {
>                 u32             status;
> -               int             n;
> -               int             res;
> +               int             bit;

Why is this an int? I think u8 would suffice.

>                 /* now demux them to the right lowlevel handler */
> -               n = d->irq_base;
> -               if (irq & 1) {
> -                       n += 16;
> -                       status >>= 16;
> -               }
> -
>                 while (status) {
> -                       res = ffs(status);
> -                       n += res;
> -                       generic_handle_irq(n - 1);
> -                       status >>= res;
> +                       bit = __ffs(status);
> +                       status &= ~(1 << bit);
> +                       generic_handle_irq(irq_find_mapping(d->irq_domain,
> +                                                           bit));

This is a nice hunk of the patch.

I would use <linux/bitops.h> and do:
status &= ~BIT(bit);


> @@ -313,10 +307,7 @@ static int gpio_to_irq_banked(struct gpio_chip *chip, unsigned offset)
>  {
>         struct davinci_gpio_controller *d = chip2controller(chip);
>
> -       if (d->irq_base >= 0)
> -               return d->irq_base + offset;
> -       else
> -               return -ENODEV;
> +       return irq_create_mapping(d->irq_domain, offset);
>  }

I think we recently established that map creating cannot be done
in gpio_to_irq* functions as that will not work properly if you request
an IRQ from device tree without first obtaining the IRQ from the GPIO
number with this function.

Instead call irq_create_mapping() on *all* used IRQ lines in the
probe function and use irq_find_mapping() here too.

> +       for (gpio = 0, bank = 0; gpio < ngpio; bank++, bank_irq++, gpio += 16) {
>                 /* disabled by default, enabled only as needed */
>                 g = gpio2regs(gpio);
>                 writel(~0, &g->clr_falling);
> @@ -467,14 +483,6 @@ static int davinci_gpio_irq_setup(struct platform_device *pdev)
>                  */
>                 irq_set_handler_data(bank_irq, &chips[gpio / 32]);

So for example here you could call iurq_create_mapping();

Also: please write a patch that marks the IRQ lines.
Call gpio_lock_as_irq(*gpio_chip, offset); in the
irqchip startup/shutdown functions. (Can be a separate
patch.)

Yours,
Linus Walleij
