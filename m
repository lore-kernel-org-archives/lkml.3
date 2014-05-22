Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbaEVPgY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 11:36:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43677 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146AbaEVPgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 11:36:23 -0400
Date: Thu, 22 May 2014 16:36:17 +0100
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
        Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave.hansen@intel.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] mm: filemap: Avoid unnecessary barriers and waitqueue
 lookups in unlock_page fastpath v7
Message-ID: <20140522153617.GI23991@suse.de>
References: <20140521121501.GT23991@suse.de>
 <20140521142622.049d0b3af5fc94912d5a1472@linux-foundation.org>
 <20140521213354.GL2485@laptop.programming.kicks-ass.net>
 <20140521145000.f130f8779f7641d0d8afcace@linux-foundation.org>
 <20140522000715.GA23991@suse.de>
 <20140522072001.GP30445@twins.programming.kicks-ass.net>
 <20140522104051.GE23991@suse.de>
 <20140522105638.GT30445@twins.programming.kicks-ass.net>
 <20140522144045.GH23991@suse.de>
 <20140522150451.GX30445@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140522150451.GX30445@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 05:04:51PM +0200, Peter Zijlstra wrote:
> On Thu, May 22, 2014 at 03:40:45PM +0100, Mel Gorman wrote:
> 
> > > +static bool __wake_up_common(wait_queue_head_t *q, unsigned int mode,
> > >  			int nr_exclusive, int wake_flags, void *key)
> > >  {
> > >  	wait_queue_t *curr, *next;
> > > +	bool woke = false;
> > >  
> > >  	list_for_each_entry_safe(curr, next, &q->task_list, task_list) {
> > >  		unsigned flags = curr->flags;
> > >  
> > > +		if (curr->func(curr, mode, wake_flags, key)) {
> > > +			woke = true;
> > > +			if ((flags & WQ_FLAG_EXCLUSIVE) && !--nr_exclusive)
> > > +				break;
> > > +		}
> > >  	}
> > > +
> > > +	return woke;
> > 
> > Ok, thinking about this more I'm less sure.
> > 
> > There are cases where the curr->func returns false even though there is a
> > task that needs to run -- task was already running or preparing to run. We
> > potentially end up clearing PG_waiters while there are still tasks on the
> > waitqueue. As __finish_wait checks if the waitqueue is empty and the last
> > waiter clears the bit I think there is nothing to gain by trying to do the
> > same job in __wake_up_page_bit.
> 
> Hmm, I think you're right, we need the test result from
> wake_bit_function(), unpolluted by the ttwu return value.

Which would be a bit too special cased and not a clear win. I at least
added a comment to explain what is going on here.

	/*
	 * Unlike __wake_up_bit it is necessary to check waitqueue_active
	 * under the wqh->lock to avoid races with parallel additions that
	 * could result in lost wakeups.
	 */
	spin_lock_irqsave(&wqh->lock, flags);
	if (waitqueue_active(wqh)) {
		/*
		 * Try waking a task on the queue. Responsibility for clearing
		 * the PG_waiters bit is left to the last waiter on the
		 * waitqueue as PageWaiters is called outside wqh->lock and
		 * we cannot miss wakeups. Due to hashqueue collisions, there
		 * may be colliding pages that still have PG_waiters set but
		 * the impact means there will be at least one unnecessary
		 * lookup of the page waitqueue on the next unlock_page or
		 * end of writeback.
		 */
		__wake_up_common(wqh, TASK_NORMAL, 1, 0, &key);
	} else {
		/* No potential waiters, safe to clear PG_waiters */
		ClearPageWaiters(page);
	}
	spin_unlock_irqrestore(&wqh->lock, flags);

-- 
Mel Gorman
SUSE Labs
