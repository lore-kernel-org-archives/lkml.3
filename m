Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbaJTPWB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 11:22:01 -0400
Received: from mail.windriver.com ([147.11.1.11]:41640 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbaJTPV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 11:21:58 -0400
Date: Mon, 20 Oct 2014 11:21:44 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: Peter Zijlstra <peterz@infradead.org>, <linux-rt-users@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/7] wait.[ch]: Introduce the simple waitqueue (swait)
 implementation
Message-ID: <20141020152144.GF24595@windriver.com>
References: <1413591782-23453-1-git-send-email-paul.gortmaker@windriver.com>
 <1413591782-23453-4-git-send-email-paul.gortmaker@windriver.com>
 <20141018213417.GE23531@worktop.programming.kicks-ass.net>
 <1413673519.30326.11.camel@pippen.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1413673519.30326.11.camel@pippen.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: [PATCH 3/7] wait.[ch]: Introduce the simple waitqueue (swait) implementation] On 18/10/2014 (Sat 19:05) Steven Rostedt wrote:

> On Sat, 2014-10-18 at 23:34 +0200, Peter Zijlstra wrote:
> 
> > Same comment as before, that is an unbounded loop in a non preemptible
> > section and therefore violates RT design principles.
> > 
> > We actually did talk about ways of fixing that.
> 
> Right, and we should slap Paul for not showing up for it ;-)

And miss turkey day?  ;-)

> 
> The decision that we came up with was to splice the current list onto a
> local list variable. And then we could go into a loop releasing the lock
> and grabbing it again. Each time pop a waiter off the list and doing the
> work of only one task at a time. This prevents doing large amounts of
> wake ups under a spinlock. The splice is required to only wake up those
> that are on the list when the wake up is called. This prevents waking up
> a task twice because it woke up, removed itself, and then added itself
> again. We must keep the semantics that a wake up only wakes up a task
> once.

OK, amusing enough, when we were actively discussing this some time ago,
I'd played with something similar -- I'd created a shadow list, and then
abstracted out the lock/unlock, so that we could call a synchronize_wait
on the unlock operations.  What I didn't do, was try and use the same
lock for the shadow list and the main one, and lockdep never let me live
that down, so as tglx would say, I shoved it all in the horror closet.

I'd like to hear more details on what you had in mind here, so I don't
go chasing down the wrong road.  So the local list head gets all the
items (via list_cut or moves?) and then that local list is spliced onto
the (now temporarily empty) main list head? (presumably all under lock)

What would need to be done as an unwind at the end of processing the
local list head before it disappears from existence?  Anything?

> 
> > 
> > Also, I'm not entirely sure we want to do the cwait thing, it looks
> > painful.
> 
> Yeah, I have to think about that some more too. I'm currently sitting in
> the airport waiting for my final leg of my flight. After 18 hours of
> travel, it is probably not too wise to review this work in my current
> state ;-)

The alignment/parallel of existing mainline wait code seemed like the
consensus back ages ago when this was being discussed on IRC, but if
that has since changed, then I can adapt or abandon as required.  I long
ago learned that the time spent on something has no correlation to its
fitness or probability of being ready for addition to mainline.  :-)

Thanks,
Paul.
--

> 
> -- Steve
> 
> 
