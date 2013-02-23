Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353Ab3BWSVK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 13:21:10 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:45564 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756159Ab3BWSVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 13:21:05 -0500
Date: Sat, 23 Feb 2013 19:21:01 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] irq: Cleanup context state transitions in irq_exit()
Message-ID: <20130223182059.GA23049@somewhere>
References: <1361496971-16939-1-git-send-email-fweisbec@gmail.com>
 <1361496971-16939-3-git-send-email-fweisbec@gmail.com>
 <alpine.LFD.2.02.1302221528470.22263@ionos>
 <20130222150444.GD18149@somewhere.redhat.com>
 <alpine.LFD.2.02.1302221605520.22263@ionos>
 <CA+55aFxOreKQ-uzfMtXEb6XH4D8By2i=qOxfDLJnchSYsa34PQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxOreKQ-uzfMtXEb6XH4D8By2i=qOxfDLJnchSYsa34PQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 01:08:17PM -0800, Linus Torvalds wrote:
> On Fri, Feb 22, 2013 at 7:06 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >>
> >> I prefer to let you guys have the final word on this patch. Whether you
> >> apply it or not, I fear I'll never be entirely happy either way :)
> >> That's the sad fate of dealing with circular dependencies...
> >
> > plus the butt ugly softirq semantics or the lack thereof ...
> 
> The softirq semantics are perfectly fine. Don't blame softirq for the
> fact that irq_exit() has had shit-for-brains for a long time.
> 
> Just move the whole "invoke_softirq()" thing down to *after* the
> tick_nohz_irq_exit() stuff. And that "wakeup_softirqd()" is garbage
> too, since the whole thing should only be used for the
> "force_irqthreads" case (which invoke_softirq()" got right.

The issue here is that softirqs may change some timers state (ie: enqueue
new timer list, dequeue, modify...), so tick_nohz_irq_exit() really need to be
called after irq tail time softirq processing in order to propagate the timer
changes to the hardware.

But tick_nohz_irq_exit() may trigger the timer softirq itself.

Another issue is rcu_irq_exit(). softirqs may make use of RCU read side critical
sections, so rcu_irq_exit() has to be called after softirq processing.
Meanwhile it seems that RCU may raise its softirq from rcu_irq_exit(). Perhaps
Paul could confirm that.

So we have a circular dependency problem here. I guess the sanest solution is to
rework tick_nohz_irq_exit() and rcu_irq_exit() to remove the use of softirqs there.
And even trigger a warning if that happens. Or we need some way to force raise
through ksoftirqd but that doesn't sound like a proper long term solution.
 
> And get rid of that final
> 
>  #ifndef __ARCH_IRQ_EXIT_IRQS_DISABLED
>         local_irq_restore(flags);
>  #endif
> 
> because even if the architecture enters irq_exit() with interrupts
> enabled, we should damn well exit with them disabled so that there are
> no races with new recursive interrupts (other than the ones that
> wakeup_softirqd already handled).

Agreed, we always return from irq_exit() with irqs disabled as long as
we processed pending softirqs anyway.
