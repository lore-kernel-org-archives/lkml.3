Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbbAMO0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 09:26:53 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:53053 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbbAMO0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 09:26:50 -0500
MIME-Version: 1.0
In-Reply-To: <1418218575-17694-1-git-send-email-geert+renesas@glider.be>
References: <1418218575-17694-1-git-send-email-geert+renesas@glider.be>
Date: Tue, 13 Jan 2015 15:26:49 +0100
Message-ID: <CACRpkdbcdMYXOvFSENZ1f7-4JV9Op+xSqz24UDApetK_LDrY0g@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio: pcf857x: Propagate wake-up setting to parent
 irq controller
From: Linus Walleij <linus.walleij@linaro.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Alexandre Courbot <gnurou@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 2:36 PM, Geert Uytterhoeven
<geert+renesas@glider.be> wrote:

> The pcf857x GPIO and interrupt controller uses dummy_irq_chip, which
> does not implement irq_chip.irq_set_wake() and does not set
> IRQCHIP_SKIP_SET_WAKE.
>
> This causes two s2ram issues if wake-up is enabled for the pcf857x GPIO
> pins:
>   1. During resume from s2ram, the following warning is printed:
>
>      WARNING: CPU: 0 PID: 1046 at kernel/irq/manage.c:537 irq_set_irq_wake+0x9c/0xf8()
>      Unbalanced IRQ 113 wake disable
>
>   2. Wake-up through the pcf857x GPIO pins may fail, as the parent
>      interrupt controller may be suspended.
>
> Migrate the pcf857x GPIO and interrupt controller from dummy_irq_chip to
> its own irq_chip. This irq chip implements irq_chip.irq_set_wake() to
> propagate its wake-up setting to the parent interrupt controller.
>
> This fixes wake-up through gpio-keys on sh73a0/kzm9g, where the pcf857x
> interrupt is cascaded to irq-renesas-intc-irqpin, and the latter must
> not be suspended when wake-up is enabled.
>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
(...)
> +static struct irq_chip pcf857x_irq_chip = {
> +       .name           = "pcf857x",
> +       .irq_startup    = noop_ret,
> +       .irq_shutdown   = noop,
> +       .irq_enable     = noop,
> +       .irq_disable    = noop,
> +       .irq_ack        = noop,
> +       .irq_mask       = noop,
> +       .irq_unmask     = noop,
> +       .irq_set_wake   = pcf857x_irq_set_wake,
> +};

Argh this is so simplistic ... any GPIO irqchip worthy of it's name
shoult at least call gpiochip_lock_as_irq() in .irq_request_resources() and vice
versa mutatis mutandis in .irq_release_resources().

Isn't it possible to also migrate this to GPIOLIB_IRQCHIP when
you're at it can also cut out a big chunk of rusty code?

Yours,
Linus Walleij
