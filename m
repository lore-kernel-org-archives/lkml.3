Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820Ab3LLRSI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 12:18:08 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42098 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab3LLRSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 12:18:05 -0500
Date: Thu, 12 Dec 2013 18:17:53 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] wait-simple: Introduce the simple waitqueue
 implementation
Message-ID: <20131212171753.GA7959@laptop.programming.kicks-ass.net>
References: <1386810399-8973-1-git-send-email-paul.gortmaker@windriver.com>
 <1386810399-8973-2-git-send-email-paul.gortmaker@windriver.com>
 <20131212114447.GH21999@twins.programming.kicks-ass.net>
 <20131212094227.0a227f6f@gandalf.local.home>
 <20131212160323.GJ21999@twins.programming.kicks-ass.net>
 <20131212115137.4e5d156f@gandalf.local.home>
 <20131212121015.139ebe8c@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131212121015.139ebe8c@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 12:10:15PM -0500, Steven Rostedt wrote:
> So if we break up your code above, we have:
> 
> 	raw_spin_lock_irqsave(&head->lock, flags);
> 	w->task = current;
> 	if (list_empty(&w->node)) {
> 		list_add(&w->node, &head->list);
> 		smp_mb();
> 	}
> 	__set_current_state(state);
> 	raw_spin_unlock_irqrestore(&head->lock, flags);
> 
> 	if (!cond)
> 		schedule();
> 

the unlock is semi-permeable and would allow the cond test to cross over
and even be satisfied before the state write.

> 
> vs
> 
> 	cond = true;
> 
> 	raw_spin_lock_irqsave(&head->lock, flags);
> 	woken = __swait_wake_locked(head, state, num);
> 	raw_spin_unlock_irqrestore(&head->lock, flags);

Same here, the lock is semi-permeable and would allow the cond store to
leak down.

In the first case we really need the implied mb of set_current_state(),
the the second case the actual wakeup would still provide the required
barrier.
