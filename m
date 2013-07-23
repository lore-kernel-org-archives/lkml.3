Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934249Ab3GWXUy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 19:20:54 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:48986 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933466Ab3GWXUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 19:20:53 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-kernel@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, linux-gpio@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: How to create IRQ mappings in a GPIO driver that doesn't control its IRQ domain ?
Date: Wed, 24 Jul 2013 01:21:44 +0200
Message-ID: <1624911.6TtmtVmU1T@avalon>
User-Agent: KMail/4.10.5 (Linux/3.8.13-gentoo; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm running into an issue on several Renesas SoC with IRQ domains and GPIOs.

On sh73a0, r8a73a4 and r8a7740, GPIOs and external interrupts are handled by 
two separate IP cores, namely the PFC (Pin Function Controller) and INTC 
(Interrupt Controller). The former is handled by the sh-pfc driver 
(drivers/pinctrl/sh-pfc) and the later by the irq-renesas-intc-irqpin driver 
(drivers/irqchip), referred to below as the irqpin driver.

The sh73a0, for instance, has 32 external interrupt lines that are multiplexed 
on pins usable as GPIOs. Both the GPIO and external interrupt functions are 
usable at the same time, which allows reading the state of the interrupt 
lines.

These external interrupts are for MMC/SD support, among other devices. In this 
specific case the MMC/SD Card Detect signal is wired to one of the external 
interrupt signals, and the corresponding GPIO is passed to the MMC/SD 
controller driver. Depending on other configuration parameters the driver can 
then either poll the Card Detect signal, or register an interrupt handler to 
detect changes in the signal state. This features is implemented by the MMC/SD 
core, which call gpio_to_irq() on the GPIO to retrieve the corresponding IRQ 
number.

On non-DT systems the external IRQs are statically mapped at a known offset. 
The sh-pfc driver, to implement the gpio_to_irq() function (through its 
gpiochip .to_irq() handler), simply searches a SoC-specific lookup table for 
the fixed IRQ number associated with a given GPIO.

However, on DT systems, IRQs are mapped dynamically on demand. The irqpin 
driver registers a simple IRQ domain, and the irq_create_mapping() function 
can then be used to map a given IRQ, specified as an offset in the domain. 
This is where the problem appears, as the irqchip .to_irq() function is 
implemented in the sh-pfc driver, which doesn't have access to the IRQ domain 
registered by the irqpin driver.

I could hack around this by exporting a function in the irqpin driver that 
would map an IRQ, and call that function from the sh-pfc driver. I'd rather 
avoid that solution as it would add a direct dependency between the two 
drivers.

Has anyone run into a similar issue ? My gut feeling is that the architecture 
isn't right somewhere, but I can't really pinpoint where. As the external IRQs 
are handled by an IP core separate from the PFC one could argue that the 
corresponding IRQs are not really GPIO IRQs, and that the PFC driver shouldn't 
implement the .to_irq() operation. However, this would push the problem down 
to all drivers that need a GPIO they can read and a (possibly optional) IRQ 
associated with the same signal, and that rely on gpio_to_irq() to retrieve 
the IRQ associated with the signal. If all those drivers were required to 
handle the GPIO and the IRQ separately, then we could as well completely 
remove gpio_to_irq() from the kernel, which doesn't sound like the right thing 
to do.

Advices and opinions will be welcome.

-- 
Regards,

Laurent Pinchart

