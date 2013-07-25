Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab3GYJlV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 05:41:21 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:58921 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab3GYJlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 05:41:17 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Walleij <linus.walleij@linaro.org>, linux-gpio@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: How to create IRQ mappings in a GPIO driver that doesn't control its IRQ domain ?
Date: Thu, 25 Jul 2013 11:42:10 +0200
Message-ID: <1963628.LyVehxJcEL@avalon>
User-Agent: KMail/4.10.5 (Linux/3.8.13-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130724202446.6CAF23E1313@localhost>
References: <1624911.6TtmtVmU1T@avalon> <20130724202446.6CAF23E1313@localhost>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

Thank you for your answer.

On Wednesday 24 July 2013 21:24:46 Grant Likely wrote:
> On Wed, 24 Jul 2013 01:21:44 +0200, Laurent Pinchart wrote:
> > Hello,
> > 
> > I'm running into an issue on several Renesas SoC with IRQ domains and
> > GPIOs.
> > 
> > On sh73a0, r8a73a4 and r8a7740, GPIOs and external interrupts are handled
> > by two separate IP cores, namely the PFC (Pin Function Controller) and
> > INTC (Interrupt Controller). The former is handled by the sh-pfc driver
> > (drivers/pinctrl/sh-pfc) and the later by the irq-renesas-intc-irqpin
> > driver (drivers/irqchip), referred to below as the irqpin driver.
> > 
> > The sh73a0, for instance, has 32 external interrupt lines that are
> > multiplexed on pins usable as GPIOs. Both the GPIO and external interrupt
> > functions are usable at the same time, which allows reading the state of
> > the interrupt lines.
> > 
> > These external interrupts are for MMC/SD support, among other devices. In
> > this specific case the MMC/SD Card Detect signal is wired to one of the
> > external interrupt signals, and the corresponding GPIO is passed to the
> > MMC/SD controller driver. Depending on other configuration parameters the
> > driver can then either poll the Card Detect signal, or register an
> > interrupt handler to detect changes in the signal state. This features is
> > implemented by the MMC/SD core, which call gpio_to_irq() on the GPIO to
> > retrieve the corresponding IRQ number.
> > 
> > On non-DT systems the external IRQs are statically mapped at a known
> > offset. The sh-pfc driver, to implement the gpio_to_irq() function
> > (through its gpiochip .to_irq() handler), simply searches a SoC-specific
> > lookup table for the fixed IRQ number associated with a given GPIO.
> > 
> > However, on DT systems, IRQs are mapped dynamically on demand. The irqpin
> > driver registers a simple IRQ domain, and the irq_create_mapping()
> > function can then be used to map a given IRQ, specified as an offset in
> > the domain. This is where the problem appears, as the irqchip .to_irq()
> > function is implemented in the sh-pfc driver, which doesn't have access to
> > the IRQ domain registered by the irqpin driver.
> > 
> > I could hack around this by exporting a function in the irqpin driver that
> > would map an IRQ, and call that function from the sh-pfc driver. I'd
> > rather avoid that solution as it would add a direct dependency between the
> > two drivers.
> 
> Well, the gpio controller really does need to know what irq is associated
> with a GPIO line. If the gpio controller driver doesn't have direct access
> to that information, then it needs to have a hook to set it up.

The GPIO controller knows what hardware IRQ is associated with a GPIO line. It 
can't however translate on its own that hardware IRQ number to a global IRQ 
number, as the global IRQ numbers are allocated dynamically through the IRQ 
mapping domain, which is local to the IRQ chip driver.

To summarize the issue, the GPIO API exports a GPIO to IRQ translation 
function, which requires two steps:

- translating from a GPIO number to an IRQ chip and an IRQ chip local hardware 
IRQ number

- translation from the hardware IRQ number to a global IRQ number

The second step currently requires information known to the IRQ chip driver 
only.

> In the past, I've seen gpio controllers have an interrupts property
> specifying which interrupts it is connected to and can use for GPIO events.
> That seems like a resonable scenario in this regard, but if GPIOS are 1:1
> mapped to irqs, then it means a lot of interrupt entries need to appear in
> the GPIO node. The other option is to add a hook directly to the gpio driver
> so that it knows to use a specific irq controller; but that feels wrong.
> Thought it may be a bit verbose, the addition of an interrupts property to
> the GPIO controller node is probably what is wanted.

That's a good idea. I don't actually need to specify all the interrupts 
associated with the GPIOs (there are 58 of them in the worst case), as the 
GPIO driver knows the hardware IRQ number of all interrupts associated with a 
GPIO. I could just specify the interrupt-parent in the GPIO DT node, and call 
irq_create_of_mapping() directly in my .to_irq() handler to translate the IRQ 
number using the interrupt-parent phandle as the controller argument. Would 
that be considered as an acceptable hack, or would it be preferred to specify 
the interrupts individually in the GPIO controller DT node ?

> There has also been a trend to make gpio controllers also interrupt
> controllers if they support being used directly as irq inputs, but that
> doesn't really help your problem.  :-)

Newer generations of the Renesas SoCs have a GPIO controller than also acts as 
an IRQ controller, but older generations unfortunately have two separate IP 
cores.

-- 
Regards,

Laurent Pinchart

