Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbaG1NFy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 09:05:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:58930 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbaG1NFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 09:05:51 -0400
Date: Mon, 28 Jul 2014 15:04:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [RFC][PATCH] irq: Rework IRQF_NO_SUSPENDED
Message-ID: <20140728130435.GO20603@laptop.programming.kicks-ass.net>
References: <20140724212620.GO3935@laptop>
 <alpine.DEB.2.10.1407252217350.23352@nanos>
 <1663327.PISiM9sMHC@vostro.rjw.lan>
 <2368056.cLoWQWpTSo@vostro.rjw.lan>
 <20140728064913.GH6758@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1407281412060.23352@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1407281412060.23352@nanos>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 02:33:41PM +0200, Thomas Gleixner wrote:
> > I realize its dynamic, but that's crap, at device registration time it
> > pretty much already knows if its a wakeup source or not, right?
> 
> It does, but that doesn't make it crap. There are situations where you
> want certain wakeup sources enabled or disabled and you can't do that
> with IRQF_NO_SUSPEND. And to support this, you need the wake_depth
> counter as well. And that's what we always had.

But if the driver is PM aware it can change its behaviour in runtime. We
don't need to disable the line in the PIC if its well behaved. This
force disable is more a bandaid to quiesce ignorant drivers than
anything else.

> I'd rather say, that the "I can wakeup the machine and will do so no
> matter what flag" is more stupid than the wake mechanism.

I never said such. I think the NO_SUSPEND name bad one that confuses
thing more than anything as it describes the implementation not the
semantics.

But as above, if a driver sets this it basically says I'm PM aware and
will behave right, no need to go force the PIC on me.

With that the driver can or can not, depending on runtime circumstances
wake or not etc.

> So we are not going to make everything a single stupid flag and limit
> the usability of existing code. We rather go and try to remove the
> stupid flag before it becomes more wide spread.

Sure, having two different means of PM for the irq layer is one too
many.

> And we cannot treat the wakeup thing the same way as the
> IRQF_NO_SUSPEND flag, because there is hardware where the irq line
> must be disabled at the normal (non suspend) interrupt controller, and
> the wake mechanism tells the PM microcontroller to monitor the
> interrupt line and kick the machine back to life.

Ah, see that is useful information.. Yes such a thing would invalidate
the flag scheme.

> So we need to very carefully look at all the existing cases instead of
> yelling crap and inflicting x86 specific horror on everyone. I said on
> friday, that I need to look at ALL use cases first and I meant it.

Well, the reason I yelled crap is because its IRQ nr based and not
handler based. Yes, shared lines are a pain, but we have to deal with
them, so allowing 'new' interfaces in that do not deal with it is very
unfortunate at best.

What further didn't help is that it wasn't at all clear to me how it was
supposed to work.


