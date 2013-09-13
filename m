Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316Ab3IMA0J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 20:26:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:33283 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab3IMA0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 20:26:06 -0400
Date: Fri, 13 Sep 2013 02:26:03 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
cc: Sricharan R <r.sricharan@ti.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linus.walleij@linaro.org, linux@arm.linux.org.uk, tony@atomide.com,
        rnayak@ti.com
Subject: Re: [RFC PATCH 1/4] DRIVERS: IRQCHIP: Add crossbar irqchip driver
In-Reply-To: <5232457A.8080709@ti.com>
Message-ID: <alpine.DEB.2.02.1309130138550.4089@ionos.tec.linutronix.de>
References: <1379000351-15672-1-git-send-email-r.sricharan@ti.com> <1379000351-15672-2-git-send-email-r.sricharan@ti.com> <alpine.DEB.2.02.1309122201530.4089@ionos.tec.linutronix.de> <523228B5.5070507@ti.com> <alpine.DEB.2.02.1309122335440.4089@ionos.tec.linutronix.de>
 <5232457A.8080709@ti.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Sep 2013, Santosh Shilimkar wrote:
> On Thursday 12 September 2013 06:22 PM, Thomas Gleixner wrote:
> > Now the real question is, how that expansion mechanism is supposed to
> > work. There are two possible scenarios:
> > 
> > 1) Expand the number of handled interrupts beyond the GIC capacity:
> > 
> >    That requires a mechanism in CROSSBAR to map several CROSSBAR
> >    interrupts to a particular GIC interrupt and provide a demux
> >    mechanism to invoke the shared handlers.
> > 
> This is not possible in hardware and not supported. Hardware has
> no notion of muxing multiple IRQ's to generate 1 IRQ or ack etc
> functionality. Its a simple MUX to tie knots between input and output
> wires.

It's not a MUX. It's a ROUTING mechanism. That's similar to the
mechanisms which are used by MSI[X]. We assign arbitrary interrupt
numbers to a device and route them to some underlying limited hardware
interrupt controller.

> > 2) Provide a mapping mechanism between possibly 250 interrupt numbers
> >    and a limitation of a total 160 active interrupts by the underlying
> >    GIC.
> > 
> This is the need and problem we are trying to solve.

Let me summarize:

   - GIC supports up to 160 interrupts

   - CROSSBAR supports up to 250 interrupts 

   - CROSSBAR routes up to 160 out of 250 interrupts to the GIC ones

   - Drivers request a CROSSBAR interrupt number which must be mapped
     to some arbitrary available GIC irq number

So basically the CROSSBAR mechanism is pretty much the same as MSI[X]
just in a different flavour and with a different set of semantics and
limitations, i.e. poor mans MSI[X] with a new level of bogosity.

So if CROSSBAR is going to be the new fangled SoC MSI[X] long term
equivalent then you better provide some infrastructure for that and
make the drivers ready to use it. Maybe check with the PCI/MSI folks
to share some of the interfaces.

If that whole thing is another onetime HW designers wet dream, then
please go back to the limited but completely functional (Who is going
to use more than 160 peripheral interrupts????) device tree model. I
really have no interest to support hardware designer brain farts.

Thanks,

	tglx


