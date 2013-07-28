Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab3G1KH4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 06:07:56 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:36504 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab3G1KHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 06:07:54 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Walleij <linus.walleij@linaro.org>, linux-gpio@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: How to create IRQ mappings in a GPIO driver that doesn't control its IRQ domain ?
Date: Sun, 28 Jul 2013 12:07:48 +0200
Message-ID: <12170068.F0utKQgh5l@flatron>
User-Agent: KMail/4.10.5 (Linux/3.10.1-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1624911.6TtmtVmU1T@avalon>
References: <1624911.6TtmtVmU1T@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Wednesday 24 of July 2013 01:21:44 Laurent Pinchart wrote:
> Hello,
> 
> I'm running into an issue on several Renesas SoC with IRQ domains and
> GPIOs.
> 
> On sh73a0, r8a73a4 and r8a7740, GPIOs and external interrupts are
> handled by two separate IP cores, namely the PFC (Pin Function
> Controller) and INTC (Interrupt Controller). The former is handled by
> the sh-pfc driver (drivers/pinctrl/sh-pfc) and the later by the
> irq-renesas-intc-irqpin driver (drivers/irqchip), referred to below as
> the irqpin driver.

Is the INTC used for anything more than just external interrupts on GPIO 
lines?

> The sh73a0, for instance, has 32 external interrupt lines that are
> multiplexed on pins usable as GPIOs. Both the GPIO and external
> interrupt functions are usable at the same time, which allows reading
> the state of the interrupt lines.
> 
> These external interrupts are for MMC/SD support, among other devices.
> In this specific case the MMC/SD Card Detect signal is wired to one of
> the external interrupt signals, and the corresponding GPIO is passed to
> the MMC/SD controller driver. Depending on other configuration
> parameters the driver can then either poll the Card Detect signal, or
> register an interrupt handler to detect changes in the signal state.
> This features is implemented by the MMC/SD core, which call
> gpio_to_irq() on the GPIO to retrieve the corresponding IRQ number.
> 
> On non-DT systems the external IRQs are statically mapped at a known
> offset. The sh-pfc driver, to implement the gpio_to_irq() function
> (through its gpiochip .to_irq() handler), simply searches a
> SoC-specific lookup table for the fixed IRQ number associated with a
> given GPIO.
> 
> However, on DT systems, IRQs are mapped dynamically on demand. The
> irqpin driver registers a simple IRQ domain, and the
> irq_create_mapping() function can then be used to map a given IRQ,
> specified as an offset in the domain. This is where the problem
> appears, as the irqchip .to_irq() function is implemented in the sh-pfc

I assume it should be s/irqchip/gpiochip/ in the line above, shouldn't it?

> driver, which doesn't have access to the IRQ domain registered by the
> irqpin driver.
> 
> I could hack around this by exporting a function in the irqpin driver
> that would map an IRQ, and call that function from the sh-pfc driver.
> I'd rather avoid that solution as it would add a direct dependency
> between the two drivers.

If you could just get the IRQ domain registered by irqpin driver and use 
it in sh-pfc, then I guess it would solve your problem, as you could 
simply call irq_create_mapping() with the domain and hwirq as args in your 
gpiochip .to_irq() callback.

I'm not sure if it's not a hack, but you could add a property to the node 
of your pin controller that would contain a phandle to your interrupt 
controller. Then you could use of_parse_phandle() to get to device node of 
the INTC and then irq_find_host() to retrieve irq domain associated with 
it.

> Has anyone run into a similar issue ? My gut feeling is that the
> architecture isn't right somewhere, but I can't really pinpoint where.
> As the external IRQs are handled by an IP core separate from the PFC

Well, the fact that it's separate doesn't mean anything yet. Here my 
question whether it's used exclusively for GPIO interrupts or not becomes 
significant. If yes, maybe it could be simply moved to the pinctrl driver?

Best regards,
Tomasz

