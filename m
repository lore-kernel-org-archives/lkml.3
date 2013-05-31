Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab3EaRcu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 13:32:50 -0400
Received: from www.linutronix.de ([62.245.132.108]:39075 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061Ab3EaRcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 13:32:41 -0400
Date: Fri, 31 May 2013 19:32:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christian Ruppert <christian.ruppert@abilis.com>
cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>
Subject: Re: [PATCH V3] irqchip: Add TB10x interrupt controller driver
In-Reply-To: <1370014348-21121-1-git-send-email-christian.ruppert@abilis.com>
Message-ID: <alpine.LFD.2.02.1305311835040.2905@ionos>
References: <20130530211944.05F4D3E0A90@localhost> <1370014348-21121-1-git-send-email-christian.ruppert@abilis.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 May 2013, Christian Ruppert wrote:

> The SOC interrupt controller driver for the Abilis Systems TB10x series of
> SOCs based on ARC700 CPUs.
> 
> This patch depends on commits eb76bdd407d8a90e59a06cb0158886df390e5d1c and
> 712bc93df9e7f14b8a163148d2aa7c778e151627 from branch irq/for-arm of
> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git.

That branch can be pulled into ARC as well. It only contains the
changes, which are necessary for the irq domain support of the generic
irq chip.

> +static void tb10x_irq_cascade(unsigned int irq, struct irq_desc *desc)
> +{
> +	struct irq_domain *domain = irq_desc_get_handler_data(desc);
> +
> +	generic_handle_irq(irq_find_mapping(domain, irq));
> +}

...

> +	for (i = 0; i < nrirqs; i++) {
> +		unsigned int irq = irq_of_parse_and_map(ictl, i);
> +
> +		irq_set_handler_data(irq, domain);
> +		irq_set_chained_handler(irq, tb10x_irq_cascade);
> +	}

I might be completely confused, but this does not make any sense at
all.

You allocate a linear domain and then map the interrupts in the
domain. The mapping function retrieves the hardware interrupt number
and creates a virtual interrupt number, installs the chip and the
handler for the interrupt and finally returns the virtual interrupt
number.

Now you take that virtual interrupt number and install
tb10x_irq_cascade as the handler. irq_set_chained_handler() will
startup (unmask) the interrupt right away.

In the cascade handler you take the virtual interrupt number, which
you get as argument, and find the mapping, i.e. the matching VIRTUAL
interrupt number for the VIRTUAL interrupt number and then call the
handler.

How is this supposed to work?

Thanks,

	tglx
