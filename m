Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbaJ1PcN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 11:32:13 -0400
Received: from www.linutronix.de ([62.245.132.108]:49423 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaJ1PcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 11:32:11 -0400
Date: Tue, 28 Oct 2014 16:32:07 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Marc Zyngier <marc.zyngier@arm.com>
cc: Jason Cooper <jason@lakedaemon.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/3] genirq: Add support for priority-drop/deactivate
 interrupt controllers
In-Reply-To: <544E67D8.3020504@arm.com>
Message-ID: <alpine.DEB.2.11.1410272158160.5308@nanos>
References: <1414235215-10468-1-git-send-email-marc.zyngier@arm.com> <1414235215-10468-2-git-send-email-marc.zyngier@arm.com> <alpine.DEB.2.11.1410252144170.5308@nanos> <544E67D8.3020504@arm.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2014, Marc Zyngier wrote:
> On 25/10/14 21:27, Thomas Gleixner wrote:
> > On Sat, 25 Oct 2014, Marc Zyngier wrote:
> >> +{
> >> +	struct irq_chip *chip = desc->irq_data.chip;
> >> +
> >> +	/* If we can do priority drop, then masking comes for free */
> >> +	if (chip->irq_priority_drop)
> >> +		irq_state_set_masked(desc);
> >> +	else
> >> +		mask_irq(desc);
> >> +}
> > 
> >>  void unmask_irq(struct irq_desc *desc)
> >>  {
> >> -	if (desc->irq_data.chip->irq_unmask) {
> >> -		desc->irq_data.chip->irq_unmask(&desc->irq_data);
> >> +	struct irq_chip *chip = desc->irq_data.chip;
> >> +
> >> +	if (chip->irq_unmask && !chip->irq_priority_drop)
> >> +		chip->irq_unmask(&desc->irq_data);
> > 
> > I have a hard time to understand that logic. Assume the interrupt
> > being masked at the hardware level after boot. Now at request_irq()
> > time what is going to unmask that very interrupt? Ditto for masking
> > after disable_irq(). Probably not what you really want.
> 
> Peering at the code (and assuming I'm finally awake), request_irq() uses
> irq_startup() -> irq_enable() -> chip->irq_unmask().

Right. That's the default implementation.

> But you're perfectly right, it breaks an independent use of
> unmask_irq(), which is pretty bad.

Indeed.
 
> >> +static void eoi_irq(struct irq_desc *desc, struct irq_chip *chip)
> >> +{
> >> +	if (chip->irq_priority_drop)
> >> +		chip->irq_priority_drop(&desc->irq_data);
> >> +	if (chip->irq_eoi)
> >> +		chip->irq_eoi(&desc->irq_data);
> >> +}
> > 
> > So if you are using that priority drop stuff, you need both calls even
> > for the non threaded case?
> 
> Yes. This is a global property (all interrupt lines for this irqchip are
> affected), so even the non-threaded case has to issue both calls.

Ok.
 
> > Can you please explain detailed how this "priority drop" mode
> > works? 
> 
> The basics of this mode are pretty simple:
> - Interrupt signalled, CPU enter the GIC code
> - Read the IAR register, interrupt becomes active:
>   -> no other interrupt can be taken
> - Run whatever interrupt handler
> - Write to the EOI register:
>   -> interrupt is still active, and cannot be taken again, but other
> interrupts can now be taken
> - Write to the DIR register:
>   -> interrupt is now inactive, and can be taken again.
> 
> A few interesting things here:
> - EOI (which causes priority drop) acts as a mask
> - DIR (which causes deactivate) acts as unmask+EOI

Let me make a few assumptions and correct me if I'm wrong as usual.

1) The startup/shutdown procedure for such an interrupt is the
   expensive mask/unmask which you want to avoid for the actual
   handling case

2) In case of an actual interrupt the flow (ignoring locking) is:

   handle_xxx_irq()

	mask_irq();	/* chip->irq_mask() maps to EOI */

	if (!action || irq_disabled())
	   return;

	handle_actions();

	if (irq_threads_active() || irq_disabled())
	   return;

	unmask_irq();	/* chip->irq_unmask() maps to DIR */

  So that is handle_level_irq() with the chip callbacks being:

   irq_startup  = gic_unmask
   irq_shutdown = gic_mask
   irq_unmask	= gic_dir
   irq_mask	= gic_eoi

3) In the threaded case as seen above finalize_oneshot() will call
   chip->unmask_irq() which maps to the DIR write and gets things
   going again.

4) In the lazy irq disable case if the interrupt fires mask_irq()
   [EOI] is good enough to silence it.

   Though in the enable_irq() case you cannot rely on the automatic
   resend of the interrupt when you unmask [DIR]. So we need to make
   sure that even in the level case (dunno whether that's supported in
   that mode) we end up calling the irq_retrigger() callback. But
   that's rather simple to achieve with a new chip flag.

You might have to look at the suspend/resume implications, but if I
did not miss anything crucial that should be fine as well.

Thanks,

	tglx

