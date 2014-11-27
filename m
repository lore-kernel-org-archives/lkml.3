Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237AbaK0Kxe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 05:53:34 -0500
Received: from mail-yk0-f175.google.com ([209.85.160.175]:44750 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357AbaK0Kxc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 05:53:32 -0500
MIME-Version: 1.0
In-Reply-To: <1416977280-27319-4-git-send-email-rebecca.swee.fun.chang@intel.com>
References: <1416977280-27319-1-git-send-email-rebecca.swee.fun.chang@intel.com>
	<1416977280-27319-4-git-send-email-rebecca.swee.fun.chang@intel.com>
Date: Thu, 27 Nov 2014 12:53:31 +0200
Message-ID: <CAHp75Vfx=MXU_AV3MZS18xJicWUT8tpiZL+OsSDjLyiQVueOBA@mail.gmail.com>
Subject: Re: [PATCHv4 3/3] gpio: sch: Enable IRQ support for Quark X1000
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GPIO Subsystem Mailing List <linux-gpio@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@intel.com>,
        Denis Turischev <denis.turischev@compulab.co.il>,
        Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 6:48 AM, Chang Rebecca Swee Fun
<rebecca.swee.fun.chang@intel.com> wrote:
> ntel Quark X1000 GPIO controller supports interrupt handling for
> both core power well and resume power well. This patch is to enable
> the IRQ support and provide IRQ handling for Intel Quark X1000
> GPIO-SCH device driver.
>
> This piece of work is derived from Dan O'Donovan's initial work for
> Quark X1000 enabling.

Minor comments.

[]

>  static int sch_gpio_probe(struct platform_device *pdev)
>  {
>         struct sch_gpio *sch;
>         struct resource *res;
> +       int err;
>
>         sch = devm_kzalloc(&pdev->dev, sizeof(*sch), GFP_KERNEL);
>         if (!sch)
> @@ -167,6 +333,15 @@ static int sch_gpio_probe(struct platform_device *pdev)
>                                  pdev->name))
>                 return -EBUSY;
>
> +       sch->irq = platform_get_irq(pdev, 0);
> +       if (sch->irq >= 0) {
> +               sch->irq_support = true;

Do we need irq_support at all? Can we substitute it by sch->irq >= 0 or … < 0?

> +       } else {
> +               dev_warn(&pdev->dev,
> +                        "failed to obtain irq number for device\n");
> +               sch->irq_support = false;
> +       }
> +
>         spin_lock_init(&sch->lock);
>         sch->iobase = res->start;
>         sch->chip = sch_gpio_chip;
> @@ -215,15 +390,57 @@ static int sch_gpio_probe(struct platform_device *pdev)
>                 return -ENODEV;
>         }
>
> +       gpiochip_add(&sch->chip);
> +
> +       if (sch->irq_support) {
> +               sch->irq_base = irq_alloc_descs(-1, 0, sch->chip.ngpio,
> +                                               NUMA_NO_NODE);
> +               if (sch->irq_base < 0) {
> +                       dev_err(&pdev->dev,
> +                               "failed to allocate GPIO IRQ descs\n");
> +                       goto err_sch_intr_chip;
> +               }
> +
> +               /* disable interrupts */
> +               sch_gpio_irq_disable_all(sch, sch->chip.ngpio);
> +
> +               err = request_irq(sch->irq, sch_gpio_irq_handler, IRQF_SHARED,
> +                                 KBUILD_MODNAME, sch);
> +               if (err) {
> +                       dev_err(&pdev->dev,
> +                               "%s failed to request IRQ\n", __func__);
> +                       goto err_sch_request_irq;
> +               }
> +
> +               sch_gpio_irqs_init(sch, sch->chip.ngpio);
> +       }
> +
>         platform_set_drvdata(pdev, sch);
>
> -       return gpiochip_add(&sch->chip);
> +       return 0;
> +
> +err_sch_request_irq:
> +       irq_free_descs(sch->irq_base, sch->chip.ngpio);
> +
> +err_sch_intr_chip:
> +       gpiochip_remove(&sch->chip);
> +
> +       return err;
>  }
>
>  static int sch_gpio_remove(struct platform_device *pdev)
>  {
>         struct sch_gpio *sch = platform_get_drvdata(pdev);
>
> +       if (sch->irq_support) {
> +               sch_gpio_irqs_deinit(sch, sch->chip.ngpio);
> +
> +               if (sch->irq >= 0)

Is it possible to have irq_support = true and sch->irq < 0?

> +                       free_irq(sch->irq, sch);
> +
> +               irq_free_descs(sch->irq_base, sch->chip.ngpio);
> +       }
> +
>         gpiochip_remove(&sch->chip);
>         return 0;
>  }

-- 
With Best Regards,
Andy Shevchenko
