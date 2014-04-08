Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361AbaDHPLZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 11:11:25 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:57223 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757207AbaDHPLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 11:11:16 -0400
MIME-Version: 1.0
In-Reply-To: <53427718.30406@linutronix.de>
References: <1395505004-22650-1-git-send-email-bigeasy@linutronix.de>
	<1395505004-22650-7-git-send-email-bigeasy@linutronix.de>
	<5331F6D5.7070809@gmail.com>
	<53427718.30406@linutronix.de>
Date: Tue, 8 Apr 2014 10:11:15 -0500
Message-ID: <CANk1AXSuBGj3vZ7knKmHTwDZLTkvVFT42Lt9ZTdk-E+sp=xQ+g@mail.gmail.com>
Subject: Re: [PATCH 6/7] gpio: dwapb: use a second irq chip
From: delicious quinoa <delicious.quinoa@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Alan Tull <atull@altera.com>, Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@altera.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 7, 2014 at 4:59 AM, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
> On 03/25/2014 10:36 PM, Sebastian Hesselbarth wrote:
>>> @@ -242,17 +244,28 @@ static void dwapb_configure_irqs(struct dwapb_gpio *gpio,
>>>      irq_gc->reg_base = gpio->regs;
>>>      irq_gc->private = gpio;
>>>
>>> -    ct = irq_gc->chip_types;
>>> -    ct->chip.irq_ack = irq_gc_ack_set_bit;
>>> -    ct->chip.irq_mask = irq_gc_mask_set_bit;
>>> -    ct->chip.irq_unmask = irq_gc_mask_clr_bit;
>>> -    ct->chip.irq_set_type = dwapb_irq_set_type;
>>> -    ct->chip.irq_enable = dwapb_irq_enable;
>>> -    ct->chip.irq_disable = dwapb_irq_disable;
>>> -    ct->chip.irq_request_resources = dwapb_irq_reqres;
>>> -    ct->chip.irq_release_resources = dwapb_irq_relres;
>>> -    ct->regs.ack = GPIO_PORTA_EOI;
>>> -    ct->regs.mask = GPIO_INTMASK;
>>> +    for (i = 0; i < 2; i++) {
>>> +
>>> +            ct = &irq_gc->chip_types[i];
>>> +            ct->chip.irq_ack = irq_gc_ack_set_bit;
>>> +            ct->chip.irq_mask = irq_gc_mask_set_bit;
>>> +            ct->chip.irq_unmask = irq_gc_mask_clr_bit;
>>> +            ct->chip.irq_set_type = dwapb_irq_set_type;
>>> +            ct->chip.irq_enable = dwapb_irq_enable;
>>> +            ct->chip.irq_disable = dwapb_irq_disable;
>>> +            ct->chip.irq_request_resources = dwapb_irq_reqres;
>>> +            ct->chip.irq_release_resources = dwapb_irq_relres;
>>> +            ct->regs.ack = GPIO_PORTA_EOI;
>>> +            ct->regs.mask = GPIO_INTMASK;
>>> +
>>> +            if (i == 0) {
>>> +                    ct->type = IRQ_TYPE_LEVEL_MASK;
>>> +                    ct->handler = handle_level_irq;
>>> +            } else {
>>> +                    ct->type = IRQ_TYPE_EDGE_BOTH;
>>> +                    ct->handler = handle_edge_irq;
>>> +            }
>>
>> Sebastian,
>>
>> IMHO the loop looks strange, especially with the (i == 0) check.
>
> how so?
>
>> How about unrolling it again and assign both chip_types independently?
>
> If more code makes you happy so be it. I will post the series soon with
> the loop unrolled.
>
>> Sebastian
>
> Sebastian

You could keep the loop but take out the if (i==0).   Set the type and
handler after the loop:

irq_gc->chip_types[0]->type = IRQ_TYPE_LEVEL_MASK;
irq_gc->chip_types[0]->handler = handle_level_irq;
irq_gc->chip_types[1]->type = IRQ_TYPE_EDGE_BOTH;
irq_gc->chip_types[1]->handler = handle_edge_irq;

Alan Tull
aka
delicious quinoa
