Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751241AbaKXUi5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 15:38:57 -0500
Received: from www.linutronix.de ([62.245.132.108]:41210 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbaKXUiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 15:38:55 -0500
Date: Mon, 24 Nov 2014 21:38:49 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Thompson <daniel.thompson@linaro.org>
cc: linaro-kernel@lists.linaro.org, Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, patches@linaro.org,
        Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3.18-rc3 v8 1/4] irqchip: gic: Make gic_raise_softirq()
 FIQ-safe
In-Reply-To: <alpine.DEB.2.11.1411241928300.6439@nanos>
Message-ID: <alpine.DEB.2.11.1411242101130.6439@nanos>
References: <1415183260-6389-1-git-send-email-daniel.thompson@linaro.org> <1415968543-29469-1-git-send-email-daniel.thompson@linaro.org> <1415968543-29469-2-git-send-email-daniel.thompson@linaro.org> <alpine.DEB.2.11.1411241918090.6439@nanos>
 <alpine.DEB.2.11.1411241928300.6439@nanos>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Nov 2014, Thomas Gleixner wrote:
> On Mon, 24 Nov 2014, Thomas Gleixner wrote:
> > On Fri, 14 Nov 2014, Daniel Thompson wrote:
> > > diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
> > > index 38493ff28fa5..0db62a6f1ee3 100644
> > > --- a/drivers/irqchip/irq-gic.c
> > > +++ b/drivers/irqchip/irq-gic.c
> > > @@ -73,6 +73,13 @@ struct gic_chip_data {
> > >  static DEFINE_RAW_SPINLOCK(irq_controller_lock);
> > >  
> > >  /*
> > > + * This lock may be locked for reading by FIQ handlers. Thus although
> > > + * read locking may be used liberally, write locking must only take
> > > + * place only when local FIQ handling is disabled.
> > > + */
> > > +static DEFINE_RWLOCK(fiq_safe_cpu_map_lock);
> > > +
> > > +/*
> > >   * The GIC mapping of CPU interfaces does not necessarily match
> > >   * the logical CPU numbering.  Let's use a mapping as returned
> > >   * by the GIC itself.
> > > @@ -624,7 +631,7 @@ static void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
> > >  	int cpu;
> > >  	unsigned long flags, map = 0;
> > >  
> > > -	raw_spin_lock_irqsave(&irq_controller_lock, flags);
> > > +	read_lock_irqsave(&fiq_safe_cpu_map_lock, flags);
> > 
> > Just for the record:
> > 
> > You might have noticed that you replace a raw lock with a non raw
> > one. That's not an issue on mainline, but that pretty much renders
> > that code broken for RT.
> >   
> > Surely nothing I worry too much about given the current state of RT.
> 
> And having a second thought here. Looking at the protection scope
> independent of the spin vs. rw lock
> 
> gic_raise_softirq()
> 
> 	lock();
> 
> 	/* Does not need any protection */
> 	for_each_cpu(cpu, mask)
>                 map |= gic_cpu_map[cpu];
> 
> 	/*
> 	 * Can be outside the lock region as well as it makes sure
> 	 * that previous writes (usually the IPI data) are visible
> 	 * before the write to the SOFTINT register.
> 	 */
> 	 dmb(ishst);
> 
> 	/* Why needs this protection? */
> 	write(map, gic_data_dist_base(&gic_data[0]) + GIC_DIST_SOFTINT));
> 
> 	unlock();
> 
> gic_migrate_target()
> 
> 	....
> 	lock();
> 
> 	/* Migrate all peripheral interrupts */
> 
> 	unlock();
> 
> So what's the point of that protection?
> 
> gic_raise_softirq() is used to send IPIs, which are PPIs on the target
> CPUs so they are not affected from the migration of the peripheral
> interrupts at all.
> 
> The write to the SOFTINT register in gic_migrate_target() is not
> inside the lock region. So what's serialized by the lock in
> gic_raise_softirq() at all?
> 
> Either I'm missing something really important here or this locking
> exercise in gic_raise_softirq() and therefor the rwlock conversion is
> completely pointless.

Thanks to Marc I figured it out now what I'm missing. That stuff is
part of the bl switcher horror. Well documented as all of that ...

So the lock protects against an IPI being sent to the current cpu
while the target map is redirected and the pending state of the
current cpu is migrated to another cpu.

It's not your fault, that the initial authors of that just abused
irq_controller_lock for that purpose instead of introducing a seperate
lock with a clear description of the protection scope in the first
place.

Now you came up with the rw lock to handle the following FIQ related
case:
    	gic_raise_softirq()
	   lock(x);
---> FIQ
        handle_fiq()
	   gic_raise_softirq()
	      lock(x);		<-- Live lock

Now the rwlock lets you avoid that, and it only lets you avoid that
because rwlocks are not fair.

So while I cannot come up with a brilliant replacement, it would be
really helpful documentation wise if you could do the following:

1) Create a patch which introduces irq_migration_lock as a raw
   spinlock and replaces the usage of irq_controller_lock in
   gic_raise_softirq() and gic_migrate_target() along with a proper
   explanation in the code and the changelog of course.

2) Make the rwlock conversion on top of that with a proper
   documentation in the code of the only relevant reason (See above).

   The protection scope which prevents IPIs being sent while switching
   over is still the same and not affected.

That's not the first time that I stumble over this bl switcher mess
which got boltet into the kernel mindlessly.

If the scope of the issue would have been clear up front, I wouldn't
have complained about the RT relevance for this as it is simple to
either disable FIQs for RT or just handle the above case differently.

Thanks,

	tglx

