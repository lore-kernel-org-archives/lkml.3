Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133AbaEUTvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 15:51:43 -0400
Received: from smtp-69.nebula.fi ([83.145.220.69]:40381 "EHLO smtp.nebula.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098AbaEUTvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 15:51:42 -0400
Date: Wed, 21 May 2014 22:50:57 +0300
From: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux@openrisc.net,
        jonas@southpole.se, Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH v2] openrisc: irq: use irqchip framework
Message-ID: <20140521195056.GA14701@chokladfabriken.org>
References: <1400530303-29182-1-git-send-email-stefan.kristiansson@saunalahti.fi>
 <alpine.DEB.2.02.1405200809260.5204@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1405200809260.5204@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 08:18:16AM +0900, Thomas Gleixner wrote:
> On Mon, 19 May 2014, Stefan Kristiansson wrote:
> > +static void or1k_pic_ack(struct irq_data *data)
> > +{
> > +	/* EDGE-triggered interrupts need to be ack'ed in order to clear
> > +	 * the latch.
> > +	 * LEVEL-triggered interrupts do not need to be ack'ed; however,
> > +	 * ack'ing the interrupt has no ill-effect and is quicker than
> > +	 * trying to figure out what type it is...
> > +	 */
> 
> The right thing to do here is to have two interrupt chips. One for
> level and one for ack. So you do not need a runtime check and you
> avoid the ack for the level type.
> 
> > +	/* The OpenRISC 1000 spec says to write a 1 to the bit to ack the
> > +	 * interrupt, but the OR1200 does this backwards and requires a 0
> > +	 * to be written...
> > +	 */
> > +
> > +#ifdef CONFIG_OR1K_1200
> > +	/* There are two oddities with the OR1200 PIC implementation:
> > +	 * i)  LEVEL-triggered interrupts are latched and need to be cleared
> > +	 * ii) the interrupt latch is cleared by writing a 0 to the bit,
> > +	 *     as opposed to a 1 as mandated by the spec
> > +	 */
> > +
> > +	mtspr(SPR_PICSR, mfspr(SPR_PICSR) & ~(1UL << data->hwirq));
> > +#else
> > +	mtspr(SPR_PICSR, (1UL << data->hwirq));
> > +#endif
> 
> Again, you could set the write 1/0 variant at runtime.
> 
> > +static int or1k_map(struct irq_domain *d, unsigned int irq, irq_hw_number_t hw)
> > +{
> > +	irq_set_chip_and_handler_name(irq, &or1k_dev,
> > +				      handle_level_irq, "level");
> 
> It's wrong to use the level flow handler for edge type interrupts as
> you might lose edges.
> 

Right, this patch started of as a ~10 line small cleanup of the existing
OpenRISC irq code, so I didn't change more than an obvious bug when moving
the code into drivers/irqchip/ir1-or1k-pic.c.
But, I guess it's worthwile to fix things up a bit more at the same time.

To summarize your suggestions and the way the or1k-pic works,
we should introduce sepearate chips for level, edge and the odd OR1K_1200
implementation which tries to be something in between.
This makes sense to me, but the problem is that none of those can really
be probed, so runtime selection here means on a device-tree level.
That's fine I think, the three different variations can be seen as seperate
hardware implementations.

I see two paths to go to get there though, and here's where I'd like some input.
1) Define the three different implementations as seperate irqchips,
   with accompanying IRQCHIP_DECLARE.
2) Add custom device-tree bindings and determine the chip type from that.

What would be the best choice here?
I think I'm leaning towards 1) and I have a tentative patch for that,
but I wanted to went the question before posting it.

Stefan
