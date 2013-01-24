Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161014Ab3AXVO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:14:58 -0500
Received: from mail.kernel.org ([198.145.19.201]:40003 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030204Ab3AXVNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:13:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 10/46] async: fix __lowest_in_progress()
Date: Thu, 24 Jan 2013 13:12:48 -0800
Message-Id: <20130124211139.518807401@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130124211135.862755794@linuxfoundation.org>
References: <20130124211135.862755794@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit f56c3196f251012de9b3ebaff55732a9074fdaae upstream.

Commit 083b804c4d3e ("async: use workqueue for worker pool") made it
possible that async jobs are moved from pending to running out-of-order.
While pending async jobs will be queued and dispatched for execution in
the same order, nothing guarantees they'll enter "1) move self to the
running queue" of async_run_entry_fn() in the same order.

Before the conversion, async implemented its own worker pool.  An async
worker, upon being woken up, fetches the first item from the pending
list, which kept the executing lists sorted.  The conversion to
workqueue was done by adding work_struct to each async_entry and async
just schedules the work item.  The queueing and dispatching of such work
items are still in order but now each worker thread is associated with a
specific async_entry and moves that specific async_entry to the
executing list.  So, depending on which worker reaches that point
earlier, which is non-deterministic, we may end up moving an async_entry
with larger cookie before one with smaller one.

This broke __lowest_in_progress().  running->domain may not be properly
sorted and is not guaranteed to contain lower cookies than pending list
when not empty.  Fix it by ensuring sort-inserting to the running list
and always looking at both pending and running when trying to determine
the lowest cookie.

Over time, the async synchronization implementation became quite messy.
We better restructure it such that each async_entry is linked to two
lists - one global and one per domain - and not move it when execution
starts.  There's no reason to distinguish pending and running.  They
behave the same for synchronization purposes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/async.c |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

--- a/kernel/async.c
+++ b/kernel/async.c
@@ -86,18 +86,27 @@ static atomic_t entry_count;
  */
 static async_cookie_t  __lowest_in_progress(struct async_domain *running)
 {
+	async_cookie_t first_running = next_cookie;	/* infinity value */
+	async_cookie_t first_pending = next_cookie;	/* ditto */
 	struct async_entry *entry;
 
+	/*
+	 * Both running and pending lists are sorted but not disjoint.
+	 * Take the first cookies from both and return the min.
+	 */
 	if (!list_empty(&running->domain)) {
 		entry = list_first_entry(&running->domain, typeof(*entry), list);
-		return entry->cookie;
+		first_running = entry->cookie;
 	}
 
-	list_for_each_entry(entry, &async_pending, list)
-		if (entry->running == running)
-			return entry->cookie;
+	list_for_each_entry(entry, &async_pending, list) {
+		if (entry->running == running) {
+			first_pending = entry->cookie;
+			break;
+		}
+	}
 
-	return next_cookie;	/* "infinity" value */
+	return min(first_running, first_pending);
 }
 
 static async_cookie_t  lowest_in_progress(struct async_domain *running)
@@ -118,13 +127,17 @@ static void async_run_entry_fn(struct wo
 {
 	struct async_entry *entry =
 		container_of(work, struct async_entry, work);
+	struct async_entry *pos;
 	unsigned long flags;
 	ktime_t uninitialized_var(calltime), delta, rettime;
 	struct async_domain *running = entry->running;
 
-	/* 1) move self to the running queue */
+	/* 1) move self to the running queue, make sure it stays sorted */
 	spin_lock_irqsave(&async_lock, flags);
-	list_move_tail(&entry->list, &running->domain);
+	list_for_each_entry_reverse(pos, &running->domain, list)
+		if (entry->cookie < pos->cookie)
+			break;
+	list_move_tail(&entry->list, &pos->list);
 	spin_unlock_irqrestore(&async_lock, flags);
 
 	/* 2) run (and print duration) */


