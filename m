Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751272AbaJOHMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 03:12:42 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:41276 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbaJOHMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 03:12:40 -0400
MIME-Version: 1.0
In-Reply-To: <1411726047-3224-4-git-send-email-rebecca.swee.fun.chang@intel.com>
References: <1411726047-3224-1-git-send-email-rebecca.swee.fun.chang@intel.com>
	<1411726047-3224-4-git-send-email-rebecca.swee.fun.chang@intel.com>
Date: Wed, 15 Oct 2014 09:12:40 +0200
Message-ID: <CACRpkdY=FmMR2Gg-yaasMxMkjmVz2TOWDAVb8DJak9CXWtnk7A@mail.gmail.com>
Subject: Re: [PATCHv2 3/3] gpio: sch: Enable IRQ support for Quark X1000
From: Linus Walleij <linus.walleij@linaro.org>
To: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>,
        Denis Turischev <denis.turischev@compulab.co.il>
Cc: Mika Westerberg <mika.westerberg@intel.com>,
        GPIO Subsystem Mailing List <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 12:07 PM, Chang Rebecca Swee Fun
<rebecca.swee.fun.chang@intel.com> wrote:

> Intel Quark X1000 GPIO controller supports interrupt handling for
> both core power well and resume power well. This patch is to enable
> the IRQ support and provide IRQ handling for Intel Quark X1000
> GPIO-SCH device driver.
>
> This piece of work is derived from Dan O'Donovan's initial work for
> Quark X1000 enabling.
>
> Signed-off-by: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
(...)

This patch needs to be rebased on the gpio git "devel" branch or
Torvalds' HEAD before I can apply it.

>  #define GEN    0x00
>  #define GIO    0x04
>  #define GLV    0x08
> +#define GTPE   0x0C
> +#define GTNE   0x10
> +#define GGPE   0x14
> +#define GSMI   0x18
> +#define GTS    0x1C
> +#define CGNMIEN        0x40
> +#define RGNMIEN        0x44

So the initial SCH driver for the Intel Poulsbo was submitted by Denis
Turischev in 2010.

Does these registers exist and work on the Poulsbo as well?

Is it really enough to distinguish between these variants by
checking if we're getting an IRQ resource on the device or not?
Is there some version register or so?

>  struct sch_gpio {
>         struct gpio_chip chip;
> +       struct irq_data data;
>         spinlock_t lock;
>         unsigned short iobase;
>         unsigned short core_base;
>         unsigned short resume_base;
> +       int irq_base;
> +       int irq_num;
> +       int irq_support;

Isn't that a bool?

> +       irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> +       sch->irq_support = !!irq;

Yeah, it's a bool....

> +       if (sch->irq_support) {
> +               sch->irq_num = irq->start;
> +               if (sch->irq_num < 0) {
> +                       dev_warn(&pdev->dev,
> +                                "failed to obtain irq number for device\n");
> +                       sch->irq_support = 0;

= false;

> +       if (sch->irq_support) {
> +               sch->irq_base = irq_alloc_descs(-1, 0, sch->chip.ngpio,
> +                                               NUMA_NO_NODE);
> +               if (sch->irq_base < 0) {
> +                       dev_err(&pdev->dev,
> +                               "failed to add GPIO IRQ descs\n");

Failed to *allocate* actually...

> +                       sch->irq_base = -1;

This is overzealous. Drop it.

> +                       goto err_sch_intr_chip;

You're bailing out anyway, see.

>  static int sch_gpio_remove(struct platform_device *pdev)
>  {
>         struct sch_gpio *sch = platform_get_drvdata(pdev);
> +       int err;
>
> -       gpiochip_remove(&sch->chip);
> -       return 0;
> +       if (sch->irq_support) {
> +               sch_gpio_irqs_deinit(sch, sch->chip.ngpio);
> +
> +               if (sch->irq_num >= 0)
> +                       free_irq(sch->irq_num, sch);
> +
> +               irq_free_descs(sch->irq_base, sch->chip.ngpio);
> +       }
> +
> +       err = gpiochip_remove(&sch->chip);
> +       if (err)
> +               dev_err(&pdev->dev,
> +                       "%s gpiochip_remove() failed\n", __func__);

So gpiochip_remove() does *NOT* return an error in the current
kernel. We just removed that return value from the SCH driver in the
previous cycle for the reason that we were killing off the return type.
commit 9f5132ae82fdbb047cc187bf689a81c8cc0de7fa
"gpio: remove all usage of gpio_remove retval in driver/gpio"

So don't reintroduce stuff we're actively trying to get rid of.

Apart from this is looks OK, Mika can you ACK the end result?

Yours,
Linus Walleij
