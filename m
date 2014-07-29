Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbaG2NOy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 09:14:54 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:50521 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752101AbaG2NOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 09:14:52 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [RFC][PATCH] irq: Rework IRQF_NO_SUSPENDED
Date: Tue, 29 Jul 2014 15:33:23 +0200
Message-ID: <3042738.6Ohp3GcNCj@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.DEB.2.10.1407291445570.4129@nanos>
References: <20140724212620.GO3935@laptop> <1629826.p5Zlf8Riij@vostro.rjw.lan> <alpine.DEB.2.10.1407291445570.4129@nanos>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 29, 2014 02:46:41 PM Thomas Gleixner wrote:
> On Tue, 29 Jul 2014, Rafael J. Wysocki wrote:
> 
> > On Monday, July 28, 2014 11:53:15 PM Rafael J. Wysocki wrote:
> > > On Monday, July 28, 2014 02:33:41 PM Thomas Gleixner wrote:
> > > > On Mon, 28 Jul 2014, Peter Zijlstra wrote:
> > > > > On Sat, Jul 26, 2014 at 01:49:17PM +0200, Rafael J. Wysocki wrote:
> > 
> > [cut]
> > 
> > > > So we are not going to make everything a single stupid flag and limit
> > > > the usability of existing code. We rather go and try to remove the
> > > > stupid flag before it becomes more wide spread.
> > > > 
> > > > And we cannot treat the wakeup thing the same way as the
> > > > IRQF_NO_SUSPEND flag, because there is hardware where the irq line
> > > > must be disabled at the normal (non suspend) interrupt controller, and
> > > > the wake mechanism tells the PM microcontroller to monitor the
> > > > interrupt line and kick the machine back to life.
> > > > 
> > > > So we need to very carefully look at all the existing cases instead of
> > > > yelling crap and inflicting x86 specific horror on everyone. I said on
> > > > friday, that I need to look at ALL use cases first and I meant it.
> > > 
> > > Regardless of the use case, I don't think it is necessary to manipulate
> > > the interrupt controller settings before the syscore_suspend stage, because
> > > if an interrupt happens earlier, we need to handle it pretty much in a normal
> > > way, unless it has been suspended.
> > > 
> > > So I'd argue for not using anything like enable_irq_wake() that goes all
> > > the way to the hardware in drivers.  Instead, we could allow drivers to
> > > mark interrupts as "set this up for system wakeup" and really do the setup
> > > right before putting the platform into the final "suspended" state.  And that
> > > is totally independend of the IRQF_NO_SUSPEND thing.
> > 
> > In addition to that we need the interrupt handler of the driver that requested
> > the irq to be set up for system wakeup to be invoked after suspend_device_irqs()
> > in case there are interrupts that should abort the suspend transition or we
> > can lose a wakeup event.  So whatever interface we decide to use it has to
> > affect suspend/resume_device_irqs() pretty much in the same way as the
> > IRQF_NO_SUSPEND flag.
> 
> Right, that's a different issue. We probably want that even for the
> existing irq_wake() users.

I agree.

There's one more thing to consider here.  Going forward we'll want to avoid
touching runtime-suspended devices during system suspend.  Then, system wakeup
devices will need to mark their IRQs for system wakeup at the runtime suspend
time and I'm not sure if that's the right time for calling enable_irq_wake().

Rafael

