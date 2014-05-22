Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931AbaEVNAW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 09:00:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40136 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362AbaEVNAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 09:00:21 -0400
Date: Thu, 22 May 2014 14:00:14 +0100
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
Message-ID: <20140522130014.GF23991@suse.de>
References: <20140515104808.GF23991@suse.de>
 <20140515142414.16c47315a03160c58ceb9066@linux-foundation.org>
 <20140521121501.GT23991@suse.de>
 <20140521142622.049d0b3af5fc94912d5a1472@linux-foundation.org>
 <20140521213354.GL2485@laptop.programming.kicks-ass.net>
 <20140521145000.f130f8779f7641d0d8afcace@linux-foundation.org>
 <20140522000715.GA23991@suse.de>
 <20140522072001.GP30445@twins.programming.kicks-ass.net>
 <20140522104051.GE23991@suse.de>
 <20140522105638.GT30445@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140522105638.GT30445@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 12:56:38PM +0200, Peter Zijlstra wrote:
> On Thu, May 22, 2014 at 11:40:51AM +0100, Mel Gorman wrote:
> > +void __wake_up_page_bit(wait_queue_head_t *wqh, struct page *page, void *word, int bit)
> > +{
> > +	struct wait_bit_key key = __WAIT_BIT_KEY_INITIALIZER(word, bit);
> > +	unsigned long flags;
> > +
> > +	/* If there is no PG_waiters bit, always take the slow path */
> 
> That comment is misleading, this is actually a fast path for
> !PG_waiters.
> 

And could have been far better anyway now that you called me on it.

> > +	if (!__PG_WAITERS && waitqueue_active(wq)) {
> > +		__wake_up(wq, TASK_NORMAL, 1, &key);
> > +		return;
> > +	}
> > +
> > +	/*
> > +	 * Unlike __wake_up_bit it is necessary to check waitqueue_active to be
> > +	 * checked under the wqh->lock to avoid races with parallel additions
> > +	 * to the waitqueue. Otherwise races could result in lost wakeups
> > +	 */
> > +	spin_lock_irqsave(&wqh->lock, flags);
> > +	if (waitqueue_active(wqh))
> > +		__wake_up_common(wqh, TASK_NORMAL, 1, 0, &key);
> > +	else
> > +		ClearPageWaiters(page);
> > +	spin_unlock_irqrestore(&wqh->lock, flags);
> > +}
> 
> So I think you missed one Clear opportunity here that was in my original
> proposal, possibly because you also frobbed PG_writeback in.
> 

It got lost in the midst of all the other modifications to make this as
"obvious" as possible.

> <SNIP>
>
> I suppose the one thing to say for the big open coded loop is that its
> much easier to read than this scattered stuff.
> 

Sure, but the end result of open coding this is duplicated code that will
be harder to maintain overall. I could split __wake_up_bit and use that
in both but I do not think it would make the code any clearer for the sake
of two lines.  Untested but this on top?

diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
index 73cb8c6..d3a8c34 100644
--- a/kernel/sched/wait.c
+++ b/kernel/sched/wait.c
@@ -60,19 +60,26 @@ EXPORT_SYMBOL(remove_wait_queue);
  * There are circumstances in which we can try to wake a task which has already
  * started to run but is not in state TASK_RUNNING. try_to_wake_up() returns
  * zero in this (rare) case, and we handle it by continuing to scan the queue.
+ *
+ * Returns true if a process was woken up
  */
-static void __wake_up_common(wait_queue_head_t *q, unsigned int mode,
+static bool __wake_up_common(wait_queue_head_t *q, unsigned int mode,
 			int nr_exclusive, int wake_flags, void *key)
 {
 	wait_queue_t *curr, *next;
+	bool woke = false;
 
 	list_for_each_entry_safe(curr, next, &q->task_list, task_list) {
 		unsigned flags = curr->flags;
 
-		if (curr->func(curr, mode, wake_flags, key) &&
-				(flags & WQ_FLAG_EXCLUSIVE) && !--nr_exclusive)
-			break;
+		if (curr->func(curr, mode, wake_flags, key)) {
+			woke = true;
+			if ((flags & WQ_FLAG_EXCLUSIVE) && !--nr_exclusive)
+				break;
+		}
 	}
+
+	return woke;
 }
 
 /**
@@ -441,9 +448,13 @@ void __wake_up_page_bit(wait_queue_head_t *wqh, struct page *page, void *word, i
 	struct wait_bit_key key = __WAIT_BIT_KEY_INITIALIZER(word, bit);
 	unsigned long flags;
 
-	/* If there is no PG_waiters bit, always take the slow path */
-	if (!__PG_WAITERS && waitqueue_active(wq)) {
-		__wake_up(wq, TASK_NORMAL, 1, &key);
+	/*
+	 * If there is no PG_waiters bit (32-bit), then waitqueue_active can be
+	 * checked without wqh->lock as there is no PG_waiters race to protect.
+	 */
+	if (!__PG_WAITERS) {
+		if (waitqueue_active(wqh))
+			__wake_up(wqh, TASK_NORMAL, 1, &key);
 		return;
 	}
 
@@ -453,9 +464,8 @@ void __wake_up_page_bit(wait_queue_head_t *wqh, struct page *page, void *word, i
 	 * to the waitqueue. Otherwise races could result in lost wakeups
 	 */
 	spin_lock_irqsave(&wqh->lock, flags);
-	if (waitqueue_active(wqh))
-		__wake_up_common(wqh, TASK_NORMAL, 1, 0, &key);
-	else
+	if (!waitqueue_active(wqh) ||
+	    !__wake_up_common(wqh, TASK_NORMAL, 1, 0, &key))
 		ClearPageWaiters(page);
 	spin_unlock_irqrestore(&wqh->lock, flags);
 }

