Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653AbaFCIIH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 04:08:07 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:57496 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635AbaFCIIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 04:08:01 -0400
MIME-Version: 1.0
In-Reply-To: <5387E915.4000008@linux.intel.com>
References: <1400810423-14067-1-git-send-email-lejun.zhu@linux.intel.com>
	<CAAVeFu+F=nHDCpL6Vfmq26QNr74mfRD5p9at_osB3R97v7xBSA@mail.gmail.com>
	<538459E8.6010701@ti.com>
	<20140527084615.GC1801@lahna.fi.intel.com>
	<53847F39.2010503@ti.com>
	<CACRpkdbe1=Yt3UDm9f4ZmZ+K2ZB9nVL+RNr7eU_TbnK-CmNY+A@mail.gmail.com>
	<5387E915.4000008@linux.intel.com>
Date: Tue, 3 Jun 2014 10:08:00 +0200
Message-ID: <CACRpkdaRP9UpBd0stX+qgTRcaHN2108yeak3FvZeHaayyc6uWg@mail.gmail.com>
Subject: Re: [PATCH v4] gpio: Add support for Intel SoC PMIC (Crystal Cove)
From: Linus Walleij <linus.walleij@linaro.org>
To: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jacob.jun.pan@linux.intel.com, bin.yang@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 4:12 AM, Zhu, Lejun <lejun.zhu@linux.intel.com> wrote:

>         retval = gpiochip_add(&cg->chip);
>         if (retval) {
>                 dev_warn(&pdev->dev, "add gpio chip error: %d\n", retval);
>                 return ret;
>         }
>
>         gpiochip_irqchip_add(&cg->chip, &crystalcove_irqchip, 0,
>                              handle_simple_irq, IRQ_TYPE_NONE);
>
>         retval = request_threaded_irq(irq, NULL, crystalcove_gpio_irq_handler,
>                                       IRQF_ONESHOT, KBUILD_MODNAME, cg);

You should request the interrupt before you add the irqchip
I think. But it shouldn't really matter, mainly to avoid tearing
down the irqchip if getting the irq should fail.

> But this code will trigger a crash in gpiolib-acpi. Currently at the end
> of gpiochip_add(), it calls:
>
> gpiochip_add() -> acpi_gpiochip_add() -> acpi_gpiochip_request_interrupts()
>
> acpi_gpiochip_request_interrupts() needs ->to_irq to work. Without having
> called gpiochip_irqchip_add() already, this will be NULL:
>
>         if (!chip->to_irq)
>                 return;    <-- It will return here.
>
>         INIT_LIST_HEAD(&acpi_gpio->events);
>
> In the tear down path, acpi_gpiochip_free_interrupts() will find to_irq is
> no longer NULL, then it will walk an uninitialized list.
>
> So, should this be fixed in gpiolib-acpi?

Maybe, maybe in the drivers. I think Mika has a proposed solution...

Yours,
Linus Walleij
