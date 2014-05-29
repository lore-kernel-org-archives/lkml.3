Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934552AbaE2Nvf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 09:51:35 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:44207 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933630AbaE2Nva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:51:30 -0400
MIME-Version: 1.0
In-Reply-To: <1401348092-24468-1-git-send-email-lejun.zhu@linux.intel.com>
References: <1401348092-24468-1-git-send-email-lejun.zhu@linux.intel.com>
Date: Thu, 29 May 2014 15:51:30 +0200
Message-ID: <CACRpkdbWtj7FqTr2QqCoKQh_u5OEZN1Vwx0UTP+sJ9S5NwCiwg@mail.gmail.com>
Subject: Re: [PATCH] gpio: Add support for Intel Crystal Cove PMIC
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

On Thu, May 29, 2014 at 9:21 AM, Zhu, Lejun <lejun.zhu@linux.intel.com> wrote:

> Devices based on Intel SoC products such as Baytrail have a Power
> Management IC. In the PMIC there are subsystems for voltage regulation,
> A/D conversion, GPIO and PWMs. The PMIC in Baytrail-T platform is
> called Crystal Cove.
>
> This patch adds support for the GPIO function in Crystal Cove.
>
> Signed-off-by: Yang, Bin <bin.yang@intel.com>
> Signed-off-by: Zhu, Lejun <lejun.zhu@linux.intel.com>

You have gotten several Reviewed-by and Acked-by tags for this
driver have you not? Please collect them here so I don't have to
do it.

> ---
> v2:
> - Use IRQ chip helper to provide irqdomain.
> - Implement .remove and can now build as a module.
> - Various fix for unreadable or ugly code pieces.
> v3:
> - More fix in irq_handler and probe.
> v4:
> - Minor fix of one return statement.
> v5:
> - intel_soc_pmic_readb/writeb/setb/clearb are removed from the MFD
>   driver, so use regmap_* API here instead.
> - Check for unsupported IRQ type and return -EINVAL.
> - Create to_cg() and to_reg() inline functions to make the code
>   readable.

Pretty cool eh? :-)

> +#include <linux/mfd/intel_soc_pmic.h>

As you realize I cannot merge this patch until that
header file exists, so the MFD core patch needs to go
in first.

> +
> +#define NUM_GPIO               16

Too generic name, say CRYSTAL_NUM_GPIO or something.

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

As mentioned, swap these around.

But the driver is looking real good now, if you just fix the above
you have my Reviewed-by so you can merge it along with the
MFD patch in the MFD tree if you like.

Yours,
Linus Walleij
