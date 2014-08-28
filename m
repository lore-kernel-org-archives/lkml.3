Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965613AbaH1JXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 05:23:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:38687 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934704AbaH1JXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 05:23:18 -0400
Date: Thu, 28 Aug 2014 11:23:11 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: Peter Zijlstra <peterz@infradead.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Dmitry Torokhov <dtor@google.com>, Aubrey Li <aubrey.li@intel.com>
Subject: Re: [PATCH 2/5 v3] irq / PM: Make wakeup interrupts work with
 suspend-to-idle
In-Reply-To: <7346724.A5YknVMkmd@vostro.rjw.lan>
Message-ID: <alpine.DEB.2.10.1408281109110.23342@nanos>
References: <26580319.OZP7jvJnA9@vostro.rjw.lan> <16387974.EqoNYrShmO@vostro.rjw.lan> <alpine.DEB.2.10.1408272130350.3323@nanos> <7346724.A5YknVMkmd@vostro.rjw.lan>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2014, Rafael J. Wysocki wrote:
> On Wednesday, August 27, 2014 10:32:23 PM Thomas Gleixner wrote:
> > void suspend_device_irqs(void)
> > {
> > 	for_each_irq_desc(irq, desc) {
> > 		/* Disable the interrupt unconditionally */	       
> > 		disable_irq(irq);
> 
> We still need to skip the IRQF_NO_SUSPEND stuff (eg. timers), so I guess
> everything left disabled here needs to be IRQS_SUSPENDED, so we know which
> ones to re-enable in resume_device_irqs().

Right. I skipped that one for simplicity. I wanted to look into the
whole maze today again with brain awake. I think it's simple to
integrate the no suspend magic here and have a separate handler for
it.

> > 
> > 		/* Is the irq a wakeup source? */
> > 		if (!irqd_is_wakeup_set(&desc->irq_data))
> > 			continue;
> > 
> > 		/* Replace the handler */
> > 		raw_spin_lock_irqsave(&desc->lock, flags);
> > 	     	desc->saved_handler = desc->handler;
> > 		desc->handler = handle_wakeup_irq;
> 
> Hmm.  There's no handler field in struct irq_desc (/me is puzzled).
> 
> Did you mean handle_irq (I think you did)?

Yup.
 
> There is quite some ugliness related to resume_irqs(), the want_early thing
> and IRQF_EARLY_RESUME / IRQF_FORCE_RESUME.  I guess that needs to be preserved?

Probably. Did not look into the madness of that yet.

Thanks,

	tglx
