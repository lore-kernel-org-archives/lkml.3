Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbaCLKsl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 06:48:41 -0400
Received: from www.linutronix.de ([62.245.132.108]:40215 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528AbaCLKsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 06:48:40 -0400
Date: Wed, 12 Mar 2014 11:48:45 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Hans de Goede <hdegoede@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Carlo Caione <carlo.caione@gmail.com>
Subject: Re: [PATCH] irq: Add a new IRQF_ACK_BEFORE_UNMASK irq flag
In-Reply-To: <20140312104523.GE21483@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.02.1403121147420.18573@ionos.tec.linutronix.de>
References: <1394579583-29316-1-git-send-email-hdegoede@redhat.com> <alpine.DEB.2.02.1403120944270.18573@ionos.tec.linutronix.de> <20140312104523.GE21483@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2014, Russell King - ARM Linux wrote:

> On Wed, Mar 12, 2014 at 11:38:24AM +0100, Thomas Gleixner wrote:
> > If the interrupt chip has this behaviour then handle_level_irq as the
> > flow handler is the wrong thing to start with because it always acks
> > before calling the handler.
> 
> This sounds like the situation with the Dove PMC irqchip too, except
> that it has the additional complication that "acking" any interrupt is
> potentially distructive to other pending interrupts, so should be done
> as infrequently as possible.

Right. I was wondering about that, but then reminded myself that the
"ack" on that chip is total clusterf*ck.
 
> > +void unmask_threaded_irq(struct irq_desc *desc)
> > +{
> > +	struct irq_chip *chip = desc->irq_data.chip;
> > +
> > +	if (chip->flags & IRQCHIP_EOI_THREADED)
> > +		chip->irq_eoi(&desc->irq_data);
> > +
> > +	if (chip->irq_unmask) {
> > +		desc->irq_data.chip->irq_unmask(&desc->irq_data);
> 
> ITYM:
> 		chip->irq_unmask(&desc->irq_data);

True.

Thanks,

	tglx
