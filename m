Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412AbaDWItr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 04:49:47 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43485 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbaDWItn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 04:49:43 -0400
Date: Wed, 23 Apr 2014 10:49:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, Stanislav Meduna <stano@meduna.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: BUG: spinlock trylock failure on UP, i.MX28 3.12.15-rt25
Message-ID: <20140423084937.GH11096@twins.programming.kicks-ass.net>
References: <534C3606.7010206@meduna.org>
 <534C731F.1050406@meduna.org>
 <534DADF1.6060608@meduna.org>
 <20140422115439.GA20669@linutronix.de>
 <20140422094657.5b6ca1e2@gandalf.local.home>
 <53569E05.8010600@linutronix.de>
 <20140422134802.73fc1fa4@gandalf.local.home>
 <20140422141650.7f43d5ba@gandalf.local.home>
 <53576859.8060706@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53576859.8060706@linutronix.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 09:14:33AM +0200, Sebastian Andrzej Siewior wrote:
> On 04/22/2014 08:16 PM, Steven Rostedt wrote:
> > --- a/kernel/timer.c
> > +++ b/kernel/timer.c
> > @@ -1447,6 +1447,12 @@ static void run_timer_softirq(struct softirq_action *h)
> >  		__run_timers(base);
> >  }
> >  
> > +#ifdef CONFIG_SMP
> > +#define timer_should_raise_softirq(lock)	!spin_do_trylock(lock)
> > +#else
> > +#define timer_should_raise_softirq(lock)	1
> > +#endif
> > +
> 
> No. The lock may be taken but it also may be available no matter if UP
> or not. With this patch applied the lockdep splat will go away but the
> FULL_NO_HZ people will come back because the timer softirq is scheduled
> even if no timer has expired.

You can do FULL_NO_HZ on UP ? That seems rather pointless, as there
isn't a 'spare' CPU to do all the timekeeping on.
