Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391Ab3KGNNQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 08:13:16 -0500
Received: from www.linutronix.de ([62.245.132.108]:51415 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab3KGNNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 08:13:11 -0500
Date: Thu, 7 Nov 2013 14:13:02 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Mike Galbraith <bitbucket@online.de>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: CONFIG_NO_HZ_FULL + CONFIG_PREEMPT_RT_FULL = nogo
In-Reply-To: <20131107125923.GB24644@localhost.localdomain>
Message-ID: <alpine.DEB.2.02.1311071402380.23353@ionos.tec.linutronix.de>
References: <1383228427.5272.36.camel@marge.simpson.net> <alpine.DEB.2.02.1311061842160.23353@ionos.tec.linutronix.de> <1383794799.5441.16.camel@marge.simpson.net> <1383798668.5441.25.camel@marge.simpson.net> <alpine.DEB.2.02.1311071158350.23353@ionos.tec.linutronix.de>
 <20131107125923.GB24644@localhost.localdomain>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Nov 2013, Frederic Weisbecker wrote:
> On Thu, Nov 07, 2013 at 12:21:11PM +0100, Thomas Gleixner wrote:
> > Though it's not a full solution. It needs some thought versus the
> > softirq code of timers. Assume we have only one timer queued 1000
> > ticks into the future. So this change will cause the timer softirq not
> > to be called until that timer expires and then the timer softirq is
> > going to do 1000 loops until it catches up with jiffies. That's
> > anything but pretty ...
> 
> I see, so the problem is that we raise the timer softirq unconditionally
> from the tick?

Right.
 
> Ok we definetly don't want to keep that behaviour, even if softirqs are not
> threaded, that's an overhead. So I'm looking at that loop in __run_timers()
> and I guess you mean the "base->timer_jiffies" incrementation?
>
> That's indeed not pretty. How do we handle exit from long dynticks
> idle periods? Are we doing that loop until we catch up with the new
> jiffies?

Right. I realized that right after I hit send :)
 
> Then it relies on the timer cascade stuff which is very obscure code to me...

It's not that bad, really. I have an idea how to fix that. Needs some
rewriting though.

Thanks,

	tglx

