Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372AbaAHTBL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 14:01:11 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:42517 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757180AbaAHTBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 14:01:06 -0500
Message-ID: <1389207661.10754.42.camel@host5.omatika.ru>
Subject: Re: [PATCH v3 11/21] ARM: pxa: support ICP DAS LP-8x4x FPGA irq
From: Sergei Ianovich <ynvich@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
Date: Wed, 08 Jan 2014 23:01:01 +0400
In-Reply-To: <CACRpkdaY7xpoeeUqBBqUS2swe6Y5gKt67VYNvNRrsbFhyU=ATw@mail.gmail.com>
References: <1386901645-28895-1-git-send-email-ynvich@gmail.com>
	 <1387309071-22382-1-git-send-email-ynvich@gmail.com>
	 <1387309071-22382-12-git-send-email-ynvich@gmail.com>
	 <CACRpkdaY7xpoeeUqBBqUS2swe6Y5gKt67VYNvNRrsbFhyU=ATw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-02 at 13:32 +0100, Linus Walleij wrote:
> On Tue, Dec 17, 2013 at 8:37 PM, Sergei Ianovich <ynvich@gmail.com> wrote:
> Usually combined GPIO+IRQ controllers are put into drivers/gpio but
> this is a bit special as it seems to handle also non-GPIO-related IRQs
> so let's get some input on this.

This one is a plain IRQ controller. It has simple input lines, not GPIO
pins. The chip reports its status to upper level interrupt controller.
The upper level controller is PXA GPIO in this case.

(...)

> > +static struct irq_chip lp8x4x_irq_chip = {
> > +       .name                   = "FPGA",
> > +       .irq_ack                = lp8x4x_mask_irq,
> > +       .irq_mask               = lp8x4x_mask_irq,
> > +       .irq_mask_ack           = lp8x4x_mask_irq,
> > +       .irq_unmask             = lp8x4x_unmask_irq,
> > +};
> 
> After you have added your state container you will have
> a handle to your struct gpio_chip in the cookie passed to
> as irqdata.
> 
> Then you need to mark the GPIO lines used for IRQs by
> doing something similar to this patch in your startup()
> and shutdown() callbacks:
> http://marc.info/?l=linux-gpio&m=138547223832167&w=2

The chip requires no GPIO initialization. 

(...)

> > +       iowrite8(0, base + EOI);
> 
> This looks dangerous, what are you doing here?

This is done in kernel source which comes with the device. The
controller won't work without this line.

I cannot know for sure, as I don't have board datasheets or drawings. I
suspect, this clears GPIO line which reports interrupts to the upper
level controller.

(...)

> > +static int __init lp8x4x_irq_init(void)
> > +{
> > +       return platform_driver_register(&lp8x4x_irq_driver);
> > +}
> > +postcore_initcall(lp8x4x_irq_init);
> 
> Do you *have* to do it this early? I guess if it's used for
> the UARTs then yes, but make a case for it...

PXA isn't DT-only at the moment. As a result, it is impossible
to use IRQCHIP_DECLARE(). So drivers for the on-CPU IRQs and GPIO-IRQs
are loaded using postcore_initcall(). We need to have all irq domain
drivers loaded prior to DT parsing in order to allow normal
initialization of IRQ resources with DT. I'll update the commit message.

The rest of review comment are implemented. The changes don't affect any
other patches in the series. Should I repost the whole series?

Or only this patch?

Thanks.

