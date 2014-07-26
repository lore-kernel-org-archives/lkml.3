Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324AbaGZLfO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 07:35:14 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:55664 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750732AbaGZLfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 07:35:12 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [RFC][PATCH] irq: Rework IRQF_NO_SUSPENDED
Date: Sat, 26 Jul 2014 13:53:40 +0200
Message-ID: <2236655.gVi7MQeBBo@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <2368056.cLoWQWpTSo@vostro.rjw.lan>
References: <20140724212620.GO3935@laptop> <1663327.PISiM9sMHC@vostro.rjw.lan> <2368056.cLoWQWpTSo@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, July 26, 2014 01:49:17 PM Rafael J. Wysocki wrote:
> On Saturday, July 26, 2014 12:25:29 AM Rafael J. Wysocki wrote:
> > On Friday, July 25, 2014 11:00:12 PM Thomas Gleixner wrote:
> > > On Fri, 25 Jul 2014, Rafael J. Wysocki wrote:
> > > > On Friday, July 25, 2014 03:25:41 PM Peter Zijlstra wrote:
> > > > > OK, so Rafael said there's devices that keep on raising their interrupt
> > > > > until they get attention. Ideally this won't happen because the device
> > > > > is suspended etc.. But I'm sure there's some broken piece of hardware
> > > > > out there that'll make it go boom.
> > > > 
> > > > So here's an idea.
> > > > 
> > > > What about returning IRQ_NONE rather than IRQ_HANDLED for "suspended"
> > > > interrupts (after all, that's what a sane driver would do for a
> > > > suspended device I suppose)?
> > > > 
> > > > If the line is really shared and the interrupt is taken care of by
> > > > the other guy sharing the line, we'll be all fine.
> > > > 
> > > > If that is not the case, on the other hand, and something's really
> > > > broken, we'll end up disabling the interrupt and marking it as
> > > > IRQS_SPURIOUS_DISABLED (if I understand things correctly).
> > > 
> > > We should not wait 100k unhandled interrupts in that case. We know
> > > already at the first unhandled interrupt that the shit hit the fan.
> > 
> > The first one may be a bus glitch or some such.  Also I guess we still need to
> > allow the legitimate "no suspend" guy to handle his interrupts until it gets
> > too worse.
> > 
> > Also does it really hurt to rely on the generic mechanism here?  We regard
> > it as fine at all other times after all.
> > 
> > > I'll have a deeper look how we can sanitize the whole wake/no_suspend
> > > logic vs. shared interrupts.
> 
> One more idea, on top of the prototype patch that I posted
> (https://patchwork.kernel.org/patch/4625921/).
> 
> The problem with enable_irq_wake() is that it only takes one argument, so
> if that's a shared interrupt, we can't really say which irqaction is supposed
> to handle wakeup interrupts should they occur.
> 
> To address this we can introduce enable_device_irq_wake() that will take
> an additional dev_id argument (that must be the one passed to request_irq() or
> the operation will fail) that can be used to identify the irqaction for
> handling the wakeup interrupts.  It can work by setting IRQF_NO_SUSPEND
> for the irqaction in question and doing the rest along the lines of
> irq_set_irq_wake(irq, 1).  disable_device_irq_wake() will then clear
> IRQF_NO_SUSPEND (it also has to be passed the dev_id argument).
> 
> If we have that, the guys who need to set up device interrupts (ie. interrupts
> normally used for signaling input events etc) for system wakeup will need to
> use enable_device_irq_wake() and that should just work.

That could be used to address the PCIe PME interrupt wakeup and gpio-keys driver
wakeup in the same way at least.

Rafael

