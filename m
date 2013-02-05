Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375Ab3BEWJ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:09:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47951 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974Ab3BEWJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:09:25 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tejun Heo <tj@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 28/93] async: fix __lowest_in_progress()
Date: Tue,  5 Feb 2013 20:06:17 -0200
Message-Id: <1360102042-10732-29-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

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
[ herton: there is no struct async_domain on 3.5, adjust for using
  list_head directly instead ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 kernel/async.c |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/kernel/async.c b/kernel/async.c
index 32d8dc9..f383244 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -84,6 +84,8 @@ static atomic_t entry_count;
  */
 static async_cookie_t  __lowest_in_progress(struct list_head *running)
 {
+	async_cookie_t first_running = next_cookie;	/* infinity value */
+	async_cookie_t first_pending = next_cookie;	/* ditto */
 	struct async_entry *entry;
 
 	if (!running) { /* just check the entry count */
@@ -93,17 +95,24 @@ static async_cookie_t  __lowest_in_progress(struct list_head *running)
 			return next_cookie;
 	}
 
+	/*
+	 * Both running and pending lists are sorted but not disjoint.
+	 * Take the first cookies from both and return the min.
+	 */
 	if (!list_empty(running)) {
 		entry = list_first_entry(running,
 			struct async_entry, list);
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
 
 static async_cookie_t  lowest_in_progress(struct list_head *running)
@@ -124,12 +133,16 @@ static void async_run_entry_fn(struct work_struct *work)
 {
 	struct async_entry *entry =
 		container_of(work, struct async_entry, work);
+	struct async_entry *pos;
 	unsigned long flags;
 	ktime_t uninitialized_var(calltime), delta, rettime;
 
-	/* 1) move self to the running queue */
+	/* 1) move self to the running queue, make sure it stays sorted */
 	spin_lock_irqsave(&async_lock, flags);
-	list_move_tail(&entry->list, entry->running);
+	list_for_each_entry_reverse(pos, entry->running, list)
+		if (entry->cookie < pos->cookie)
+			break;
+	list_move_tail(&entry->list, &pos->list);
 	spin_unlock_irqrestore(&async_lock, flags);
 
 	/* 2) run (and print duration) */
-- 
1.7.9.5

