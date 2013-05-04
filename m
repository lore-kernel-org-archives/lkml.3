Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763698Ab3EDCag (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 22:30:36 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:41509 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759028Ab3EDCae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 22:30:34 -0400
Message-ID: <518472C4.5080209@gmail.com>
Date: Sat, 04 May 2013 04:30:28 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Arnd Bergmann <arnd@arndb.de>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        Gerlando Falauto <gerlando.falauto@keymile.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC patch 7/8] genirq: generic chip: Add linear irq domain support
References: <alpine.LFD.2.02.1305031514230.2886@ionos> <20130503212258.385818955@linutronix.de> <20130503214629.810207749@linutronix.de>
In-Reply-To: <20130503214629.810207749@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2013 11:50 PM, Thomas Gleixner wrote:
 > Provide infrastructure for irq chip implementations which work on
 > linear irq domains.

Thomas,

I am happy that I put you into rant mode. It took me little more
than an hour to read through your patches, prepare orion irqchip
driver on top of them and finally got it working.

Anyway, I found some more issues.

 > Index: linux-2.6/kernel/irq/generic-chip.c
 > ===================================================================
 > --- linux-2.6.orig/kernel/irq/generic-chip.c
 > +++ linux-2.6/kernel/irq/generic-chip.c
 > @@ -7,6 +7,7 @@
[...]
 > +int irq_alloc_domain_generic_chips(struct irq_domain *d, int 
irqs_per_chip,
 > +				   int num_ct, const char *name,
 > +				   irq_flow_handler_t handler,
 > +				   unsigned int clr, unsigned int set,
 > +				   enum irq_gc_flags gcflags)
 > +{
 > +	struct irq_domain_chip_generic *dgc;
 > +	struct irq_chip_generic *gc;
 > +	int numchips, sz, i;
 > +	unsigned long flags;
 > +
 > +	if (d->gc)
 > +		return -EBUSY;
 > +
 > +	if (d->revmap_type != IRQ_DOMAIN_MAP_LINEAR)
 > +		return -EINVAL;
 > +
 > +	numchips = d->revmap_data.linear.size / irqs_per_chip;
 > +	if (!numchips)
 > +		return -EINVAL;
 > +
 > +	sz = sizeof(*gc) + num_ct * sizeof(struct irq_chip_type);
 > +	sz *= numchips;
 > +	sz += sizeof(*dgc);
 > +
 > +	dgc = kzalloc(sz, GFP_KERNEL);
 > +	if (!dgc)
 > +		return -ENOMEM;
 > +	dgc->irqs_per_chip = irqs_per_chip;
 > +	dgc->num_chips = numchips;
 > +	dgc->irq_flags_to_set = set;
 > +	dgc->irq_flags_to_clear = clr;
 > +	dgc->gc_flags = gcflags;
 > +	gc = dgc->gc;
 > +
 > +	for (i = 0; i < numchips; i++, gc++) {

The memory you allocated for gc, num_ct * ct, and dgc doesn't allow
to increment through gc. gc is struct irq_chip_generic * but next
gc is at sizeof(*gc) + num_ct * sizeof(struct irq_chip_type).
This also affects indexing dgc->gc later.

I chose to fix it by having an index helper but that first maps
dgc-gc to unsigned char * and then adds the correct offset. Not
nice but it works. Maybe having real array of ptr to gc is more
intuitive here even if we will have to have split kzallocs.

 > +		irq_init_generic_chip(gc, name, num_ct, i * irqs_per_chip,
 > +				      NULL, handler);

irq_init_generic_chip does not take care of initalizing ct
mask_cache ptr. This should be done here.

 > +		gc->domain = d;
 > +		raw_spin_lock_irqsave(&gc_lock, flags);
 > +		list_add_tail(&gc->list, &gc_list);
 > +		raw_spin_unlock_irqrestore(&gc_lock, flags);
 > +	}
 > +	d->gc = dgc;

Moving this assignment above the for loop allows to get
gc by index as indexing helper relies on domain, not domain
generic chip.

You want me to prepare patches for the above? Maybe you can
split your RFC into 1-6 and 7-8. Then you can have 1-6 applied
independently of irq_domain_generic_chip stuff.

Thanks for the RFC again!

Sebastian
