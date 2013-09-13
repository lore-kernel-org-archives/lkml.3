Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599Ab3IMOYe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 10:24:34 -0400
Received: from www.linutronix.de ([62.245.132.108]:36747 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932249Ab3IMOYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 10:24:32 -0400
Date: Fri, 13 Sep 2013 16:24:29 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
cc: Sricharan R <r.sricharan@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        LAK <linux-arm-kernel@lists.infradead.org>, linux-omap@vger.kernel.org,
        linus.walleij@linaro.org, Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, rnayak@ti.com
Subject: Re: [RFC PATCH 1/4] DRIVERS: IRQCHIP: Add crossbar irqchip driver
In-Reply-To: <52326D6B.2010003@ti.com>
Message-ID: <alpine.DEB.2.02.1309131142540.4089@ionos.tec.linutronix.de>
References: <1379000351-15672-1-git-send-email-r.sricharan@ti.com> <1379000351-15672-2-git-send-email-r.sricharan@ti.com> <alpine.DEB.2.02.1309122201530.4089@ionos.tec.linutronix.de> <523228B5.5070507@ti.com> <alpine.DEB.2.02.1309122335440.4089@ionos.tec.linutronix.de>
 <5232457A.8080709@ti.com> <alpine.DEB.2.02.1309130138550.4089@ionos.tec.linutronix.de> <52326D6B.2010003@ti.com>
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
> On Thursday 12 September 2013 08:26 PM, Thomas Gleixner wrote:
> > Let me summarize:
> > 
> >    - GIC supports up to 160 interrupts
> > 
> >    - CROSSBAR supports up to 250 interrupts 
> > 
> >    - CROSSBAR routes up to 160 out of 250 interrupts to the GIC ones
> > 
> >    - Drivers request a CROSSBAR interrupt number which must be mapped
> >      to some arbitrary available GIC irq number
> > 
> Correct.
> 
> > So basically the CROSSBAR mechanism is pretty much the same as MSI[X]
> > just in a different flavour and with a different set of semantics and
> > limitations, i.e. poor mans MSI[X] with a new level of bogosity.
> > 
> > So if CROSSBAR is going to be the new fangled SoC MSI[X] long term
> > equivalent then you better provide some infrastructure for that and
> > make the drivers ready to use it. Maybe check with the PCI/MSI folks
> > to share some of the interfaces.
> >
> > If that whole thing is another onetime HW designers wet dream, then
> > please go back to the limited but completely functional (Who is going
> > to use more than 160 peripheral interrupts????) device tree model. I
> > really have no interest to support hardware designer brain farts.
> > 
> Thanks for clear NAK for irqchip approach. I should have looped you
> in the discussion where I was also suggesting against the irqchip
> approach. We will try to look at MSI stuff but if its get too
> complicated am going to fall-back to the initial probe based
> approach to achieve the functionality.

Before you dig into MSI, lets talk about irq domains first.

GIC implements a legacy irq domain, i.e. a linear domain of all
possible GIC interrupts with a 1:1 mapping.

So why can't you make use of irq domains and have the whole routing
business implemented sanely?

What's needed is in gic_init_bases():

       if (of_property_read(node, "routable_irqs", &nr_routable_irqs) {
       	  irq_domain_add_legacy(nr_gic_irqs);
       } else {
       	  irq_domain_add_legacy(nr_per_cpu_irqs);
	  irq_domain_add_linear(nr_routable_irqs);
       }

Now that separate domain has an xlate function which grabs a free GIC
irq from a bitmap and returns the hardware irq number in the gic
space. The map/unmap callbacks take care of setting up / tearing down
the route in the crossbar.

Thoughts?

Thanks,

	tglx
