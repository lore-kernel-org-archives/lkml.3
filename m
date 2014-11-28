Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbaK1QCU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 11:02:20 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48680 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbaK1QCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 11:02:17 -0500
MIME-Version: 1.0
In-Reply-To: <87r3wn1mhu.fsf@free.fr>
References: <1417113721-9062-1-git-send-email-robert.jarzmik@free.fr>
	<alpine.DEB.2.11.1411272258010.3961@nanos>
	<87r3wn1mhu.fsf@free.fr>
Date: Sat, 29 Nov 2014 00:02:15 +0800
Message-ID: <CAN1soZzZ7nuvvHguaHVHZc8hXvv8SzvWY9Ejf-fYhA5yfbcM-w@mail.gmail.com>
Subject: Re: [PATCH] ARM: pxa: fix lubbock interrupts handling
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Thomas Gleixner <tglx@linutronix.de>, Daniel Mack <daniel@zonque.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 9:30 PM, Robert Jarzmik <robert.jarzmik@free.fr> wrote:
> Thomas Gleixner <tglx@linutronix.de> writes:
>
>> So what is the relationship between installing that chained handler
>> and that gpio-pxa probe stuff?
> The relation is in gpio-pxa probe, look at the extract of pxa_gpio_probe() :
> pxa_gpio_probe()
>                 irq = gpio_to_irq(0);
>                 irq_set_chip_and_handler(irq, &pxa_muxed_gpio_chip,
>                                          handle_edge_irq);
>                 set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
>                 irq_set_chained_handler(IRQ_GPIO0, pxa_gpio_demux_handler);
>
> Now look at the extract from the former lubbock_init_irq() :
> lubbock_init_irq()
>                 irq = PXA_GPIO_TO_IRQ(0);
>                 irq_set_chained_handler(irq, lubbock_irq_handler);
>                 irq_set_irq_type(irq, IRQ_TYPE_EDGE_FALLING);
>
> Given that gpio_to_irq(0) = PXA_GPIO_TO_IRQ(0), see how these 2 are fighting to
> install the handler, and how the resulting installed handler depends on the
> order of execution of pxa_gpio_to_irq() wrt lubbock_init_irq().
>
>> And why is the GPIO0 interrupt handled from arch code rather than from
>> a regular driver setup, which depends on the availablity of the GPIO
>> driver?
> Ah that's a good question. Maybe the answer is that there is no driver in this
> case.
> When I say "no driver", it's because this interrupt is a consequence of the
> IO-Board (or motherboard) wiring topology.
>
> I think I need to add a bit of context, so pardon my crude ascii-art style, and
> see in the lubbock case, we have this wiring (list of IPs not exhaustive, and
> gates to mask each XXX irq not added) :
>
> IPs on Motherboard          Gates on motherboard                       SoC
>
> +-------------+              +-------+
> |  SMC Lan    | --lan irq--- | Latch | -
> +-------------+              |       |  \                      +------PXA-----+
>                              |       |   \                     |              |
> +-------------+              |       |                         |+----------+  |
> |   UDC Vbus  | --vbus irq-- | Latch | -- NOR gate -- GPIO0 -- ||GPIO block|  |
> +-------------+              |       |                line     |+----------+  |
>                              |       |   /                     |              |
> +-------------+              |       |  /                      +--------------+
> |   SA1111    | --sa11x irq--| Latch | -
> +-------------+              +-------+
>
> The "gates on motherboard" is what lubbock.c is describing, ie. the
> interconnection on the motherboard. I don't see the device/driver model fitting
> to describe these gates, do you ?
>

I think that it's a kind of irq muxing, just like lots of PMIC (power
management IC).
We should move the lubbock board irqs to a mfd driver, and register them as
threaded irqs.

Best Regards
Haojian
