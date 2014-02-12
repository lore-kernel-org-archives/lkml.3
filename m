Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009AbaBLQRH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 11:17:07 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:47776 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbaBLQRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 11:17:04 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdYiC=nzVG4_nQuRVSNP9TB4W=3VL9QhBQjmqvLvmP6McA@mail.gmail.com>
References: <1391724370-30589-1-git-send-email-delicious.quinoa@gmail.com>
	<CACRpkdYiC=nzVG4_nQuRVSNP9TB4W=3VL9QhBQjmqvLvmP6McA@mail.gmail.com>
Date: Wed, 12 Feb 2014 10:17:02 -0600
Message-ID: <CANk1AXTnnhSnt_ayJYwDHRth44CWAwmxVA5kkbvnjqW39ssLQg@mail.gmail.com>
Subject: Re: [PATCH v11] gpio: add a driver for the Synopsys DesignWare APB
 GPIO block
From: delicious quinoa <delicious.quinoa@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Jamie Iles <jamie@jamieiles.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>, Alan Tull <atull@altera.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 5:06 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> Hi Alan, this is starting to look good. I's like an ACK from a DT
> maintainer on the bindings but can't see anything really controversial
> about them.
>
> On Thu, Feb 6, 2014 at 11:06 PM, Alan Tull <delicious.quinoa@gmail.com> wrote:
>
>> +static int dwapb_gpio_to_irq(struct gpio_chip *gc, unsigned offset)
>> +{
>> +       struct bgpio_chip *bgc = to_bgpio_chip(gc);
>> +       struct dwapb_gpio_port *port = container_of(bgc, struct
>> +                                                   dwapb_gpio_port, bgc);
>> +       struct dwapb_gpio *gpio = port->gpio;
>> +
>> +       return irq_create_mapping(gpio->domain, offset);
>> +}
>
> I think you want to call irq_find_mapping() here. irq_create_mapping()
> should be called for all valid IRQs on probe() instead.
>
>> +               ct = irq_gc->chip_types;
>> +               ct->chip.irq_ack = irq_gc_ack_set_bit;
>> +               ct->chip.irq_mask = irq_gc_mask_set_bit;
>> +               ct->chip.irq_unmask = irq_gc_mask_clr_bit;
>> +               ct->chip.irq_set_type = dwapb_irq_set_type;
>> +               ct->chip.irq_enable = dwapb_irq_enable;
>> +               ct->chip.irq_disable = dwapb_irq_disable;
>> +               ct->regs.ack = GPIO_PORTA_EOI;
>> +               ct->regs.mask = GPIO_INTMASK;
>
> Please add .startup() and .shutdown() callbacks marking the
> respective lines as IRQs, compare to recent patches in the
> GPIO subsystem such as this:
> http://marc.info/?l=linux-gpio&m=138546100215235&w=2
>
> You probably want to call irq_create_mapping() for each
> valid IRQ after registering the chip in this function.

Hi Linus,

Thanks for the feedback.  I am working on making these changes.  The
startup/shutdown were easy to add.

I am wondering about the change in usage of
irq_find_mapping/irq_create_mapping.  It seems like all the GPIO
drivers that use irq domains do it the way I was doing it (that's
where I got the idea in the first place): irq_create_mapping is used
in the to_irq() function.  I guess this is a general direction all the
other drivers will be encouraged to go in also?

Regards,
Alan


>
> Yours,
> Linus Walleij
