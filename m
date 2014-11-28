Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751350AbaK1NaM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 08:30:12 -0500
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:56651 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbaK1NaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 08:30:10 -0500
X-ME-Helo: beldin
X-ME-Date: Fri, 28 Nov 2014 14:30:08 +0100
X-ME-IP: 90.11.113.15
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Daniel Mack <daniel@zonque.org>, Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: pxa: fix lubbock interrupts handling
References: <1417113721-9062-1-git-send-email-robert.jarzmik@free.fr>
	<alpine.DEB.2.11.1411272258010.3961@nanos>
X-URL: http://belgarath.falguerolles.org/
Date: Fri, 28 Nov 2014 14:30:05 +0100
In-Reply-To: <alpine.DEB.2.11.1411272258010.3961@nanos> (Thomas Gleixner's
	message of "Thu, 27 Nov 2014 23:03:10 +0100 (CET)")
Message-ID: <87r3wn1mhu.fsf@free.fr>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:

> So what is the relationship between installing that chained handler
> and that gpio-pxa probe stuff?
The relation is in gpio-pxa probe, look at the extract of pxa_gpio_probe() :
pxa_gpio_probe()
		irq = gpio_to_irq(0);
		irq_set_chip_and_handler(irq, &pxa_muxed_gpio_chip,
					 handle_edge_irq);
		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
		irq_set_chained_handler(IRQ_GPIO0, pxa_gpio_demux_handler);

Now look at the extract from the former lubbock_init_irq() :
lubbock_init_irq()
		irq = PXA_GPIO_TO_IRQ(0);
		irq_set_chained_handler(irq, lubbock_irq_handler);
		irq_set_irq_type(irq, IRQ_TYPE_EDGE_FALLING);

Given that gpio_to_irq(0) = PXA_GPIO_TO_IRQ(0), see how these 2 are fighting to
install the handler, and how the resulting installed handler depends on the
order of execution of pxa_gpio_to_irq() wrt lubbock_init_irq().

> And why is the GPIO0 interrupt handled from arch code rather than from
> a regular driver setup, which depends on the availablity of the GPIO
> driver?
Ah that's a good question. Maybe the answer is that there is no driver in this
case.
When I say "no driver", it's because this interrupt is a consequence of the
IO-Board (or motherboard) wiring topology.

I think I need to add a bit of context, so pardon my crude ascii-art style, and
see in the lubbock case, we have this wiring (list of IPs not exhaustive, and
gates to mask each XXX irq not added) :

IPs on Motherboard          Gates on motherboard                       SoC

+-------------+              +-------+
|  SMC Lan    | --lan irq--- | Latch | -
+-------------+              |       |  \                      +------PXA-----+
                             |       |   \                     |              |
+-------------+              |       |                         |+----------+  |
|   UDC Vbus  | --vbus irq-- | Latch | -- NOR gate -- GPIO0 -- ||GPIO block|  |
+-------------+              |       |                line     |+----------+  |
                             |       |   /                     |              |
+-------------+              |       |  /                      +--------------+
|   SA1111    | --sa11x irq--| Latch | -
+-------------+              +-------+

The "gates on motherboard" is what lubbock.c is describing, ie. the
interconnection on the motherboard. I don't see the device/driver model fitting
to describe these gates, do you ?

Cheers.

-- 
Robert
