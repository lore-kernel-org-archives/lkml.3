Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab3JIMTW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 08:19:22 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:37508 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524Ab3JIMTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 08:19:18 -0400
MIME-Version: 1.0
In-Reply-To: <1381235122-23730-3-git-send-email-christian.ruppert@abilis.com>
References: <20131008122145.GA21985@ab42.lan>
	<1381235122-23730-3-git-send-email-christian.ruppert@abilis.com>
Date: Wed, 9 Oct 2013 14:19:17 +0200
Message-ID: <CACRpkdaMq1bzcTP6KZCGuWSm2MB0vSmJ4aRskuQNB8at4YnWRQ@mail.gmail.com>
Subject: Re: [PATCH 03/03] GPIO: Add TB10x GPIO driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Christian Ruppert <christian.ruppert@abilis.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 8, 2013 at 2:25 PM, Christian Ruppert
<christian.ruppert@abilis.com> wrote:

Overall this driver is looking very nice, we just need to figure out this
group range concept in the other patch.

> +Example:
> +
> +       gpioa: gpio@FF140000 {
> +               compatible = "abilis,tb10x-gpio";
> +               interrupt-controller;
> +               #interrupt-cells = <1>;
> +               interrupt-parent = <&tb10x_ictl>;
> +               interrupts = <27 2>;

So this is cascaded off some HWIRQ offset 27 on some interrupt
controller, OK...

> +               reg = <0xFF140000 0x1000>;
> +               gpio-controller;
> +               #gpio-cells = <2>;
> +               abilis,ngpio = <3>;
> +               gpio-ranges = <&iomux 0 0 0>;
> +               gpio-ranges-group-names = "gpioa_pins";
> +       };


But this thing:

(...)
> +static irqreturn_t tb10x_gpio_irq_cascade(int irq, void *data)
> +{
> +       struct tb10x_gpio *tb10x_gpio = data;
> +       u32 r = tb10x_reg_read(tb10x_gpio, OFFSET_TO_REG_CHANGE);
> +       u32 m = tb10x_reg_read(tb10x_gpio, OFFSET_TO_REG_INT_EN);
> +       const unsigned long bits = r & m;
> +       int i;
> +
> +       for_each_set_bit(i, &bits, 32)
> +               generic_handle_irq(irq_find_mapping(tb10x_gpio->domain, i));
> +
> +       return IRQ_HANDLED;
> +}

(...)
> +               ret = platform_get_irq(pdev, 0);
> +               if (ret < 0) {
> +                       dev_err(&pdev->dev, "No interrupt specified.\n");
> +                       goto fail_get_irq;
> +               }
> +
> +               tb10x_gpio->gc.to_irq   = tb10x_gpio_to_irq;
> +               tb10x_gpio->irq         = ret;
> +
> +               ret = devm_request_irq(&pdev->dev, ret, tb10x_gpio_irq_cascade,
> +                               IRQF_TRIGGER_NONE | IRQF_SHARED,
> +                               dev_name(&pdev->dev), tb10x_gpio);

Why aren't you simply using

irq_set_chained_handler()
irq_set_handler_data(tb10x_gpio);

And in the handler function that need a signature like
this:

static void tb10x_gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
{
   struct tb10x_gpio *tb10x_gpio = = irq_get_handler_data(irq);
   struct irq_chip *host_chip = irq_get_chip(irq);
   chained_irq_enter(host_chip, desc);
(...)
   chained_irq_exit(host_chip, desc);
}

?

It's not like I'm 100% certain on where to use one or the other
construct (a mechanism like the above is needed for threaded
IRQs I've noticed) but the chained handler seems more to the
point does it not?

The only downside I've seen is that the parent IRQ does not get
a name and the accumulated IRQ stats in /proc/interrupts but
surely we can live without that (or fix it).

Since I'm a bit rusty on chained IRQs correct me if I'm wrong...

Yours,
Linus Walleij
