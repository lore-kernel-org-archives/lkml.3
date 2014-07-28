Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbaG1Ves (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 17:34:48 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:52969 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750708AbaG1Vep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 17:34:45 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [RFC][PATCH] irq: Rework IRQF_NO_SUSPENDED
Date: Mon, 28 Jul 2014 23:53:15 +0200
Message-ID: <2706544.qjOZ3fREQ9@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.DEB.2.10.1407281412060.23352@nanos>
References: <20140724212620.GO3935@laptop> <20140728064913.GH6758@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1407281412060.23352@nanos>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 28, 2014 02:33:41 PM Thomas Gleixner wrote:
> On Mon, 28 Jul 2014, Peter Zijlstra wrote:
> > On Sat, Jul 26, 2014 at 01:49:17PM +0200, Rafael J. Wysocki wrote:
> > > One more idea, on top of the prototype patch that I posted
> > > (https://patchwork.kernel.org/patch/4625921/).
> > > 
> > > The problem with enable_irq_wake() is that it only takes one argument, so
> > > if that's a shared interrupt, we can't really say which irqaction is supposed
> > > to handle wakeup interrupts should they occur.
> > 
> > Right.
> 
> Historically no hardware manufacturer was so stupid to have wakeup
> sources on shared interrupts. Just because x86 is brain damaged is no
> reason to claim that stuff that worked fine for years is crap.

I don't honestly think that's x86 only.  The PCIe PME interrupt has always been
designed as shareable and that's not limited to x86.

Also enable_irq_wake() has the problem that on some platforms it makes
the interrupt wakeup-only, so it stops signaling input events after that.
AT91 seems to be one of these platforms (you may argue that this is a platform
bug, but still).  So if it is called in a driver's .suspend() callback,
it will create a "blind" period for potential wakeup events between
that point and when the platform is eventually turned off.

> We never needed this until now, so we simply go and do what we've done
> always in such situations. We look for a solution which copes with the
> new hardware brain farts and keeps the existing stuff working. It's
> that simple.
> 
> > > To address this we can introduce enable_device_irq_wake() that will take
> > > an additional dev_id argument (that must be the one passed to request_irq() or
> > > the operation will fail) that can be used to identify the irqaction for
> > > handling the wakeup interrupts.  It can work by setting IRQF_NO_SUSPEND
> > > for the irqaction in question and doing the rest along the lines of
> > > irq_set_irq_wake(irq, 1).  disable_device_irq_wake() will then clear
> > > IRQF_NO_SUSPEND (it also has to be passed the dev_id argument).
> > > 
> > > If we have that, the guys who need to set up device interrupts (ie. interrupts
> > > normally used for signaling input events etc) for system wakeup will need to
> > > use enable_device_irq_wake() and that should just work.
> > 
> > So in the patch I posted I described why NO_SUSPEND is useful, I still
> > have to hear a solid reason for why we also need enable_irq_wake()? What
> > does it do that cannot be achieved with NO_SUSPEND?
> > 
> > I realize its dynamic, but that's crap, at device registration time it
> > pretty much already knows if its a wakeup source or not, right?
> 
> It does, but that doesn't make it crap. There are situations where you
> want certain wakeup sources enabled or disabled and you can't do that
> with IRQF_NO_SUSPEND. And to support this, you need the wake_depth
> counter as well. And that's what we always had.
> 
> I'd rather say, that the "I can wakeup the machine and will do so no
> matter what flag" is more stupid than the wake mechanism.
> 
> It was added to support XEN wreckage and I wish we've never done that
> in the first place.

We needed to do that for timers to start with.  We also need it for ACPI
and pretty much everything that needs to react to events during system
suspend/resume too.  I would argue for limiting its use to things that
need their interrupts to be always enabled, though.

> So we are not going to make everything a single stupid flag and limit
> the usability of existing code. We rather go and try to remove the
> stupid flag before it becomes more wide spread.
> 
> And we cannot treat the wakeup thing the same way as the
> IRQF_NO_SUSPEND flag, because there is hardware where the irq line
> must be disabled at the normal (non suspend) interrupt controller, and
> the wake mechanism tells the PM microcontroller to monitor the
> interrupt line and kick the machine back to life.
> 
> So we need to very carefully look at all the existing cases instead of
> yelling crap and inflicting x86 specific horror on everyone. I said on
> friday, that I need to look at ALL use cases first and I meant it.

Regardless of the use case, I don't think it is necessary to manipulate
the interrupt controller settings before the syscore_suspend stage, because
if an interrupt happens earlier, we need to handle it pretty much in a normal
way, unless it has been suspended.

So I'd argue for not using anything like enable_irq_wake() that goes all
the way to the hardware in drivers.  Instead, we could allow drivers to
mark interrupts as "set this up for system wakeup" and really do the setup
right before putting the platform into the final "suspended" state.  And that
is totally independend of the IRQF_NO_SUSPEND thing.

Rafael

