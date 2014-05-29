Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933025AbaE2NkG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 09:40:06 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:32835 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932809AbaE2NkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:40:04 -0400
MIME-Version: 1.0
In-Reply-To: <1400734743-3154-1-git-send-email-lejun.zhu@linux.intel.com>
References: <1400734743-3154-1-git-send-email-lejun.zhu@linux.intel.com>
Date: Thu, 29 May 2014 15:40:03 +0200
Message-ID: <CACRpkdYXT7NR6kWyzBbo2aR_Cu0=9wOFbWTA0zZyN90nUb4CAw@mail.gmail.com>
Subject: Re: [PATCH v3] gpio: Add support for Intel SoC PMIC (Crystal Cove)
From: Linus Walleij <linus.walleij@linaro.org>
To: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        jacob.jun.pan@linux.intel.com, bin.yang@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 6:59 AM, Zhu, Lejun <lejun.zhu@linux.intel.com> wrote:

> Devices based on Intel SoC products such as Baytrail have a Power
> Management IC. In the PMIC there are subsystems for voltage regulation,
> A/D conversion, GPIO and PWMs. The PMIC in Baytrail-T platform is called
> Crystal Cove.
>
> This patch adds support for the GPIO function in Crystal Cove.
>
> v2:
> - Use IRQ chip helper to provide irqdomain.
> - Implement .remove and can now build as a module.
> - Various fix for unreadable or ugly code pieces.
> v3:
> - More fix in irq_handler and probe.

(...)

> +       gpiochip_irqchip_add(&cg->chip, &crystalcove_irqchip, 0,
> +                            handle_simple_irq, IRQ_TYPE_NONE);
> +
> +       retval = request_threaded_irq(irq, NULL, crystalcove_gpio_irq_handler,
> +                                     IRQF_ONESHOT, KBUILD_MODNAME, cg);
> +
> +       if (retval) {
> +               dev_warn(&pdev->dev, "request irq failed: %d\n", retval);
> +               goto out;
> +       }
> +
> +       retval = gpiochip_add(&cg->chip);
> +       if (retval) {
> +               dev_warn(&pdev->dev, "add gpio chip error: %d\n", retval);
> +               goto out_free_irq;
> +       }

As concluded from discussion, please switch the order of
gpiochip_irqchip_add() and gpiochip_add() so that the
gpiochip is added first, then the irqchip.

Yours,
Linus Walleij
