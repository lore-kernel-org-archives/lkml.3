Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932487AbaDVM1Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 08:27:24 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:50050 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755662AbaDVM1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 08:27:21 -0400
MIME-Version: 1.0
In-Reply-To: <1397174424-30855-1-git-send-email-tim.kryger@linaro.org>
References: <1397174424-30855-1-git-send-email-tim.kryger@linaro.org>
Date: Tue, 22 Apr 2014 14:27:20 +0200
Message-ID: <CACRpkdav_7x9Ei1pG9JfUvBGzgCO+w3qe2m+_9o1FM9i8_4Jbw@mail.gmail.com>
Subject: Re: [PATCH] gpio: bcm-kona: Add irq_set_wake method
From: Linus Walleij <linus.walleij@linaro.org>
To: Tim Kryger <tim.kryger@linaro.org>
Cc: Markus Mayer <markus.mayer@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Broadcom Kernel Feedback List 
	<bcm-kernel-feedback-list@broadcom.com>,
        Linux GPIO Mailing List <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 2:00 AM, Tim Kryger <tim.kryger@linaro.org> wrote:

> If a consumer of a GPIO-based IRQ identifies itself as wanting to
> have the capability to wake up the system through that interrupt,
> update the flags to keep that interrupt enabled in suspend.
>
> Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
(...)
> +#ifdef CONFIG_SUSPEND
> +static int bcm_kona_gpio_irq_set_wake(struct irq_data *d, unsigned int on)
> +{
> +
> +       struct irq_desc *desc = container_of(d, struct irq_desc, irq_data);
> +
> +       if (on)
> +               desc->action->flags |= IRQF_NO_SUSPEND;
> +       else
> +               desc->action->flags &= ~IRQF_NO_SUSPEND;
> +
> +       return 0;
> +}
> +#else
> +#define bcm_kona_gpio_irq_set_wake NULL
> +#endif

Tglx: is this generally speaking the right thing to do for a cascaded
irqchip? (It looks a bit odd but makes some sense.)

>  static void bcm_kona_gpio_irq_mask(struct irq_data *d)
>  {
>         struct bcm_kona_gpio *kona_gpio;
> @@ -494,6 +512,7 @@ static struct irq_chip bcm_gpio_irq_chip = {
>         .irq_set_type = bcm_kona_gpio_irq_set_type,
>         .irq_request_resources = bcm_kona_gpio_irq_reqres,
>         .irq_release_resources = bcm_kona_gpio_irq_relres,
> +       .irq_set_wake = bcm_kona_gpio_irq_set_wake,
>  };

So I have introduced the generic GPIO irqchip helpers in order to avoid
fixing exactly this type of bug in 200 different places.

Can you take this action:

(A) Convert the BCM kona driver to use the genric GPIO irqchip
helpers e.g. in the manner of this patch:
http://marc.info/?l=linux-gpio&m=139696011031186&w=2

(B) Make exactly this bug fix in the gpiolib irqchip helpers,
by partching drivers/gpio/gpiolib.c instead?

That way we solve the problem for *several* chips in one go.

Yours,
Linus Walleij
