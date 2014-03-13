Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbaCMQ1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 12:27:17 -0400
Received: from www.linutronix.de ([62.245.132.108]:52300 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351AbaCMQ1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 12:27:15 -0400
Date: Thu, 13 Mar 2014 17:27:21 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Hans de Goede <hdegoede@redhat.com>
cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        devicetree <devicetree@vger.kernel.org>, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 4/4] irqchip: sun4i: Use handle_fasteoi_late_irq for
 the ENMI (irq 0)
In-Reply-To: <5321CB12.3090704@redhat.com>
Message-ID: <alpine.DEB.2.02.1403131725230.18573@ionos.tec.linutronix.de>
References: <1394644627-12315-1-git-send-email-hdegoede@redhat.com> <1394644627-12315-5-git-send-email-hdegoede@redhat.com> <alpine.DEB.2.02.1403131542060.18573@ionos.tec.linutronix.de> <5321CB12.3090704@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2014, Hans de Goede wrote:
> On 03/13/2014 03:46 PM, Thomas Gleixner wrote:
> >>  static int sun4i_irq_map(struct irq_domain *d, unsigned int virq,
> >>  			 irq_hw_number_t hw)
> >>  {
> >> -	irq_set_chip_and_handler(virq, &sun4i_irq_chip,
> >> -				 handle_level_irq);
> >> +	if (hw == 0) /* IRQ 0, the ENMI needs special handling */
> >> +		irq_set_chip_and_handler(virq, &sun4i_irq_chip,
> >> +					 handle_fasteoi_late_irq);
> >> +	else
> >> +		irq_set_chip_and_handler(virq, &sun4i_irq_chip,
> >> +					 handle_level_irq);
> > 
> > I wonder what happens when you use the fasteoi handler for all of
> > them.
> 
> As mentioned in my previous mail doing an ack (or an eio) seems to
> be unnecessary for all but IRQ 0.
> 
> I do wonder if handle_level_irq is the right handle*irq function
> to use in this case, since this is strictly used in the non smp
> case I think that the mask / unmask done by handle_level_irq is
> not necessary for non threaded handlers. So what would be the
> correct handle*irq function to use in this case ?
> 
> Note the irqs are level irqs. IOW they may stay asserted while
> the handler runs because of the handler and a new irq raising.

Right. You could be creative and use fasteoi plus an empty eoi
callback in the chip for irq 1-N. That way you only mask and unmask in
the threaded case.

Thanks,

	tglx
