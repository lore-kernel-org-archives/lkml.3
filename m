Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbbAMRcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 12:32:19 -0500
Received: from www.linutronix.de ([62.245.132.108]:46285 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbbAMRcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 12:32:18 -0500
Date: Tue, 13 Jan 2015 18:31:56 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [RFC PATCH] irqchip: add dumb demultiplexer implementation
In-Reply-To: <20150113180017.66efeda7@bbrezillon>
Message-ID: <alpine.DEB.2.11.1501131831270.5526@nanos>
References: <alpine.DEB.2.11.1412162125000.17382@nanos> <1420725159-20720-1-git-send-email-boris.brezillon@free-electrons.com> <alpine.DEB.2.11.1501131117120.17382@nanos> <20150113180017.66efeda7@bbrezillon>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2015, Boris Brezillon wrote:
> On Tue, 13 Jan 2015 11:38:14 +0100 (CET)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> > 
> > > +/**
> > > + *	handle_dumb_demux_irq - Dumb demuxer irq handle function.
> > > + *	@irq:	the interrupt number
> > > + *	@desc:	the interrupt description structure for this irq
> > > + *
> > > + *	Dumb demux interrupts are sent from a demultiplexing interrupt handler
> > > + *	which is not able to decide which child interrupt interrupt handler
> > > + *	should be called.
> > > + *
> > > + *	Note: The caller is expected to handle the ack, clear, mask and
> > > + *	unmask issues if necessary.
> > > + */
> > > +irqreturn_t
> > > +handle_dumb_demux_irq(unsigned int irq, struct irq_desc *desc)
> > > +{
> > > +	irqreturn_t retval = IRQ_NONE;
> > > +
> > > +	raw_spin_lock(&desc->lock);
> > > +
> > > +	if (!irq_may_run(desc))
> > > +		goto out_unlock;
> > > +
> > > +	desc->istate &= ~(IRQS_REPLAY | IRQS_WAITING);
> > > +	kstat_incr_irqs_this_cpu(irq, desc);
> > > +
> > > +	if (unlikely(!desc->action || irqd_irq_disabled(&desc->irq_data))) {
> > > +		desc->istate |= IRQS_PENDING;
> > > +		goto out_unlock;
> > > +	}
> > > +
> > > +	retval = handle_irq_event_no_spurious_check(desc);
> > > +
> > > +out_unlock:
> > > +	raw_spin_unlock(&desc->lock);
> > > +
> > > +	return retval;
> > > +}
> > > +EXPORT_SYMBOL_GPL(handle_dumb_demux_irq);
> > 
> > This should go into the new file as well, so it gets compiled out when
> > not enabled.
> 
> Actually, I can't move that function out of kernel/irq/chip.c because
> it calls irq_may_run which is statically defined in this file.
> Should I export this function or just enclose it in a
> #ifdef DUMB_IRQ_DEMUX section ?

Missed that. Make it conditional then.
