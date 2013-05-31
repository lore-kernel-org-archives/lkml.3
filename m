Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446Ab3EaWS0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 18:18:26 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:37110 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757394Ab3EaWSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 18:18:18 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH V3] irqchip: Add TB10x interrupt controller driver
To: Thomas Gleixner <tglx@linutronix.de>,
        Christian Ruppert <christian.ruppert@abilis.com>
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>
In-Reply-To: <alpine.LFD.2.02.1305311835040.2905@ionos>
References: <20130530211944.05F4D3E0A90@localhost> <1370014348-21121-1-git-send-email-christian.ruppert@abilis.com> <alpine.LFD.2.02.1305311835040.2905@ionos>
Date: Fri, 31 May 2013 23:18:14 +0100
Message-Id: <20130531221814.534DF3E08FE@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 May 2013 19:32:34 +0200 (CEST), Thomas Gleixner <tglx@linutronix.de> wrote:
> On Fri, 31 May 2013, Christian Ruppert wrote:
> 
> > The SOC interrupt controller driver for the Abilis Systems TB10x series of
> > SOCs based on ARC700 CPUs.
> > 
> > This patch depends on commits eb76bdd407d8a90e59a06cb0158886df390e5d1c and
> > 712bc93df9e7f14b8a163148d2aa7c778e151627 from branch irq/for-arm of
> > git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git.
> 
> That branch can be pulled into ARC as well. It only contains the
> changes, which are necessary for the irq domain support of the generic
> irq chip.
> 
> > +static void tb10x_irq_cascade(unsigned int irq, struct irq_desc *desc)
> > +{
> > +	struct irq_domain *domain = irq_desc_get_handler_data(desc);
> > +
> > +	generic_handle_irq(irq_find_mapping(domain, irq));
> > +}
> 
> ...
> 
> > +	for (i = 0; i < nrirqs; i++) {
> > +		unsigned int irq = irq_of_parse_and_map(ictl, i);
> > +
> > +		irq_set_handler_data(irq, domain);
> > +		irq_set_chained_handler(irq, tb10x_irq_cascade);
> > +	}
> 
> I might be completely confused, but this does not make any sense at
> all.
> 
> You allocate a linear domain and then map the interrupts in the
> domain. The mapping function retrieves the hardware interrupt number
> and creates a virtual interrupt number, installs the chip and the
> handler for the interrupt and finally returns the virtual interrupt
> number.
> 
> Now you take that virtual interrupt number and install
> tb10x_irq_cascade as the handler. irq_set_chained_handler() will
> startup (unmask) the interrupt right away.
> 
> In the cascade handler you take the virtual interrupt number, which
> you get as argument, and find the mapping, i.e. the matching VIRTUAL
> interrupt number for the VIRTUAL interrupt number and then call the
> handler.
> 
> How is this supposed to work?

I think what is going on here is that the tb10x interrupt controller
appears to be more of a front-end to another interrupt controller with
each input wired up 1:1 to the interrupt inputs of the other controller.
(I don't know why someone would design an interrupt controller that way,
but that's another issue). The loop above is mapping each of the
interrupt inputs on the parent controller so that each child controller
can be chained to it as an input. I can't think of how else it could be
set up with the current code if the drivers were kept separate.

Christian, what is the parent interrupt controller for this SoC? It
really feels like the tb10x-ictl belongs as part of the parent
controller. I went and looked at the parent node, and I saw this:

		intc: interrupt-controller {
				compatible = "snps,arc700-intc";
				interrupt-controller;
				#interrupt-cells = <1>;
		};

I noticed the conspicuous absence of a reg property. Is this something
architectural? If I were working on this system I'd drop the
snps,arc700-intc node entirely and have a single abilis,tb10x-intc that
encapsulated the properties of both (you would of course want to share
handler functions for the 'normal' inputs without the custom features).
That would eliminate the goofyness of listing 27 separate interrupts in
the abilis,tb10x-ictl interrupts property.

g.

