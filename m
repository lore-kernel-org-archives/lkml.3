Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbaG1Mdr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 08:33:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:40163 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbaG1Mdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 08:33:45 -0400
Date: Mon, 28 Jul 2014 14:33:41 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [RFC][PATCH] irq: Rework IRQF_NO_SUSPENDED
In-Reply-To: <20140728064913.GH6758@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1407281412060.23352@nanos>
References: <20140724212620.GO3935@laptop> <alpine.DEB.2.10.1407252217350.23352@nanos> <1663327.PISiM9sMHC@vostro.rjw.lan> <2368056.cLoWQWpTSo@vostro.rjw.lan> <20140728064913.GH6758@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2014, Peter Zijlstra wrote:
> On Sat, Jul 26, 2014 at 01:49:17PM +0200, Rafael J. Wysocki wrote:
> > One more idea, on top of the prototype patch that I posted
> > (https://patchwork.kernel.org/patch/4625921/).
> > 
> > The problem with enable_irq_wake() is that it only takes one argument, so
> > if that's a shared interrupt, we can't really say which irqaction is supposed
> > to handle wakeup interrupts should they occur.
> 
> Right.

Historically no hardware manufacturer was so stupid to have wakeup
sources on shared interrupts. Just because x86 is brain damaged is no
reason to claim that stuff that worked fine for years is crap.

We never needed this until now, so we simply go and do what we've done
always in such situations. We look for a solution which copes with the
new hardware brain farts and keeps the existing stuff working. It's
that simple.

> > To address this we can introduce enable_device_irq_wake() that will take
> > an additional dev_id argument (that must be the one passed to request_irq() or
> > the operation will fail) that can be used to identify the irqaction for
> > handling the wakeup interrupts.  It can work by setting IRQF_NO_SUSPEND
> > for the irqaction in question and doing the rest along the lines of
> > irq_set_irq_wake(irq, 1).  disable_device_irq_wake() will then clear
> > IRQF_NO_SUSPEND (it also has to be passed the dev_id argument).
> > 
> > If we have that, the guys who need to set up device interrupts (ie. interrupts
> > normally used for signaling input events etc) for system wakeup will need to
> > use enable_device_irq_wake() and that should just work.
> 
> So in the patch I posted I described why NO_SUSPEND is useful, I still
> have to hear a solid reason for why we also need enable_irq_wake()? What
> does it do that cannot be achieved with NO_SUSPEND?
> 
> I realize its dynamic, but that's crap, at device registration time it
> pretty much already knows if its a wakeup source or not, right?

It does, but that doesn't make it crap. There are situations where you
want certain wakeup sources enabled or disabled and you can't do that
with IRQF_NO_SUSPEND. And to support this, you need the wake_depth
counter as well. And that's what we always had.

I'd rather say, that the "I can wakeup the machine and will do so no
matter what flag" is more stupid than the wake mechanism.

It was added to support XEN wreckage and I wish we've never done that
in the first place.

So we are not going to make everything a single stupid flag and limit
the usability of existing code. We rather go and try to remove the
stupid flag before it becomes more wide spread.

And we cannot treat the wakeup thing the same way as the
IRQF_NO_SUSPEND flag, because there is hardware where the irq line
must be disabled at the normal (non suspend) interrupt controller, and
the wake mechanism tells the PM microcontroller to monitor the
interrupt line and kick the machine back to life.

So we need to very carefully look at all the existing cases instead of
yelling crap and inflicting x86 specific horror on everyone. I said on
friday, that I need to look at ALL use cases first and I meant it.

Thanks,

	tglx









