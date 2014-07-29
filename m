Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079AbaG2MrB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 08:47:01 -0400
Received: from www.linutronix.de ([62.245.132.108]:48025 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbaG2Mq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 08:46:59 -0400
Date: Tue, 29 Jul 2014 14:46:41 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [RFC][PATCH] irq: Rework IRQF_NO_SUSPENDED
In-Reply-To: <1629826.p5Zlf8Riij@vostro.rjw.lan>
Message-ID: <alpine.DEB.2.10.1407291445570.4129@nanos>
References: <20140724212620.GO3935@laptop> <alpine.DEB.2.10.1407281412060.23352@nanos> <2706544.qjOZ3fREQ9@vostro.rjw.lan> <1629826.p5Zlf8Riij@vostro.rjw.lan>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2014, Rafael J. Wysocki wrote:

> On Monday, July 28, 2014 11:53:15 PM Rafael J. Wysocki wrote:
> > On Monday, July 28, 2014 02:33:41 PM Thomas Gleixner wrote:
> > > On Mon, 28 Jul 2014, Peter Zijlstra wrote:
> > > > On Sat, Jul 26, 2014 at 01:49:17PM +0200, Rafael J. Wysocki wrote:
> 
> [cut]
> 
> > > So we are not going to make everything a single stupid flag and limit
> > > the usability of existing code. We rather go and try to remove the
> > > stupid flag before it becomes more wide spread.
> > > 
> > > And we cannot treat the wakeup thing the same way as the
> > > IRQF_NO_SUSPEND flag, because there is hardware where the irq line
> > > must be disabled at the normal (non suspend) interrupt controller, and
> > > the wake mechanism tells the PM microcontroller to monitor the
> > > interrupt line and kick the machine back to life.
> > > 
> > > So we need to very carefully look at all the existing cases instead of
> > > yelling crap and inflicting x86 specific horror on everyone. I said on
> > > friday, that I need to look at ALL use cases first and I meant it.
> > 
> > Regardless of the use case, I don't think it is necessary to manipulate
> > the interrupt controller settings before the syscore_suspend stage, because
> > if an interrupt happens earlier, we need to handle it pretty much in a normal
> > way, unless it has been suspended.
> > 
> > So I'd argue for not using anything like enable_irq_wake() that goes all
> > the way to the hardware in drivers.  Instead, we could allow drivers to
> > mark interrupts as "set this up for system wakeup" and really do the setup
> > right before putting the platform into the final "suspended" state.  And that
> > is totally independend of the IRQF_NO_SUSPEND thing.
> 
> In addition to that we need the interrupt handler of the driver that requested
> the irq to be set up for system wakeup to be invoked after suspend_device_irqs()
> in case there are interrupts that should abort the suspend transition or we
> can lose a wakeup event.  So whatever interface we decide to use it has to
> affect suspend/resume_device_irqs() pretty much in the same way as the
> IRQF_NO_SUSPEND flag.

Right, that's a different issue. We probably want that even for the
existing irq_wake() users.

Thanks,

	tglx
