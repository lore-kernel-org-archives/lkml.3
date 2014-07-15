Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866AbaGOMjj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 08:39:39 -0400
Received: from webbox1416.server-home.net ([77.236.96.61]:45555 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758376AbaGOMjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 08:39:37 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "Li, Aubrey" <aubrey.li@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] PM / sleep / irq: Do not suspend wakeup interrupts
Date: Tue, 15 Jul 2014 14:36:46 +0200
Message-ID: <1983952.dL0Czm4hJT@ws-stein>
User-Agent: KMail/4.12.5 (Linux/3.12.21-gentoo-r1; KDE/4.12.5; x86_64; ; )
In-Reply-To: <1776825.8kf9TZPye4@vostro.rjw.lan>
References: <53A2340D.9030503@linux.intel.com> <2067046.JFGH9LUctP@ws-stein> <1776825.8kf9TZPye4@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 July 2014 14:50:28, Rafael J. Wysocki wrote:
> On Tuesday, July 15, 2014 02:22:25 PM Alexander Stein wrote:
> > On Thursday 10 July 2014 23:37:54, Rafael J. Wysocki wrote:
> > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > 
> > > If an IRQ has been configured for wakeup via enable_irq_wake(), the
> > > driver who has done that must be prepared for receiving interrupts
> > > after suspend_device_irqs() has returned, so there is no need to
> > > "suspend" such IRQs.  Moreover, if drivers using enable_irq_wake()
> > > actually want to receive interrupts after suspend_device_irqs() has
> > > returned, they need to add IRQF_NO_SUSPEND to the IRQ flags while
> > > requesting the IRQs, which shouldn't be necessary (it also goes a bit
> > > too far, as IRQF_NO_SUSPEND causes the IRQ to be ignored by
> > > suspend_device_irqs() all the time regardless of whether or not it
> > > has been configured for signaling wakeup).
> > > 
> > > For the above reasons, make __disable_irq() ignore IRQ descriptors
> > > with IRQD_WAKEUP_STATE set when its suspend argument is true which
> > > effectively causes them to behave like IRQs with IRQF_NO_SUSPEND
> > > set.
> > > 
> > > This also allows IRQs configured for wakeup via enable_irq_wake()
> > > to work as wakeup interrupts for the "freeze" (suspend-to-idle)
> > > sleep mode automatically just like for any other sleep states.
> > > 
> > > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > ---
> > >  kernel/irq/manage.c |    3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > 
> > > Index: linux-pm/kernel/irq/manage.c
> > > ===================================================================
> > > --- linux-pm.orig/kernel/irq/manage.c
> > > +++ linux-pm/kernel/irq/manage.c
> > > @@ -385,7 +385,8 @@ setup_affinity(unsigned int irq, struct
> > >  void __disable_irq(struct irq_desc *desc, unsigned int irq, bool suspend)
> > >  {
> > >  	if (suspend) {
> > > -		if (!desc->action || (desc->action->flags & IRQF_NO_SUSPEND))
> > > +		if (!desc->action || (desc->action->flags & IRQF_NO_SUSPEND)
> > > +		    || irqd_has_set(&desc->irq_data, IRQD_WAKEUP_STATE))
> > >  			return;
> > >  		desc->istate |= IRQS_SUSPENDED;
> > >  	}
> > 
> > Nice, this fixes my wakeup problem from freeze using gpio-keys. Unfortunately my SPI-attached touchscreen controller cannot be used for wakeup from freeze. Using it to wakeup from mem does work instead. Any ideas what might be wrong in this case?
> 
> Not without looking at the code in question.
> 
> One guess would be a missing call to enable_irq_wake().

No, ads7846.c does call 'enable_irq_wake(ts->spi->irq)'. So is this a platform or driver specific problem?

Regards,
Alexander

