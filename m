Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720Ab3ASAkp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 19:40:45 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:49407 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972Ab3ASAkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 19:40:43 -0500
Date: Fri, 18 Jan 2013 16:40:38 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>, Dan Williams <djbw@fb.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] async: keep pending tasks on async_domain and remove
 async_pending
Message-ID: <20130119004038.GK24579@htj.dyndns.org>
References: <20130119003923.GH24579@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130119003923.GH24579@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From e5877615929e13719fde210bc4b776bfd25c16c8 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Fri, 18 Jan 2013 16:34:16 -0800

Async kept single global pending list and per-domain running lists.
When an async item is queued, it's put on the global pending list.
The item is moved to the per-domain running list when its execution
starts.

At this point, this design complicates execution and synchronization
without bringing any benefit.  The list only matters for
synchronization which doesn't care whether a given async item is
pending or executing.  Also, global synchronization is done by
iterating through all active registered async_domains, so the global
async_pending list doesn't help anything either.

Rename async_domain->running to async_domain->pending and put async
items directly there and remove when execution completes.  This
simplifies lowest_in_progress() a lot - the first item on the pending
list is the one with the lowest cookie, and async_run_entry_fn()
doesn't have to mess with moving the item from pending to running.

After the change, whether a domain is empty or not can be trivially
determined by looking at async_domain->pending.  Remove
async_domain->count and use list_empty() on pending instead.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 include/linux/async.h |  9 +++-----
 kernel/async.c        | 63 ++++++++++++---------------------------------------
 2 files changed, 17 insertions(+), 55 deletions(-)

diff --git a/include/linux/async.h b/include/linux/async.h
index 6f23442..849fb8c 100644
--- a/include/linux/async.h
+++ b/include/linux/async.h
@@ -19,8 +19,7 @@ typedef u64 async_cookie_t;
 typedef void (async_func_ptr) (void *data, async_cookie_t cookie);
 struct async_domain {
 	struct list_head node;
-	struct list_head running;
-	int count;
+	struct list_head pending;
 	unsigned registered:1;
 };
 
@@ -29,8 +28,7 @@ struct async_domain {
  */
 #define ASYNC_DOMAIN(_name) \
 	struct async_domain _name = { .node = LIST_HEAD_INIT(_name.node), \
-				      .running = LIST_HEAD_INIT(_name.running), \
-				      .count = 0, \
+				      .pending = LIST_HEAD_INIT(_name.pending), \
 				      .registered = 1 }
 
 /*
@@ -39,8 +37,7 @@ struct async_domain {
  */
 #define ASYNC_DOMAIN_EXCLUSIVE(_name) \
 	struct async_domain _name = { .node = LIST_HEAD_INIT(_name.node), \
-				      .running = LIST_HEAD_INIT(_name.running), \
-				      .count = 0, \
+				      .pending = LIST_HEAD_INIT(_name.pending), \
 				      .registered = 0 }
 
 extern async_cookie_t async_schedule(async_func_ptr *ptr, void *data);
diff --git a/kernel/async.c b/kernel/async.c
index 4cb4823..711fc34 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -62,7 +62,6 @@ static async_cookie_t next_cookie = 1;
 #define MAX_WORK		32768
 #define ASYNC_COOKIE_MAX	ULLONG_MAX	/* infinity cookie */
 
-static LIST_HEAD(async_pending);
 static ASYNC_DOMAIN(async_dfl_domain);
 static LIST_HEAD(async_domains);
 static DEFINE_SPINLOCK(async_lock);
@@ -81,42 +80,17 @@ static DECLARE_WAIT_QUEUE_HEAD(async_done);
 
 static atomic_t entry_count;
 
-
-/*
- * MUST be called with the lock held!
- */
-static async_cookie_t __lowest_in_progress(struct async_domain *domain)
-{
-	async_cookie_t first_running = ASYNC_COOKIE_MAX;
-	async_cookie_t first_pending = ASYNC_COOKIE_MAX;
-	struct async_entry *entry;
-
-	/*
-	 * Both running and pending lists are sorted but not disjoint.
-	 * Take the first cookies from both and return the min.
-	 */
-	if (!list_empty(&domain->running)) {
-		entry = list_first_entry(&domain->running, typeof(*entry), list);
-		first_running = entry->cookie;
-	}
-
-	list_for_each_entry(entry, &async_pending, list) {
-		if (entry->domain == domain) {
-			first_pending = entry->cookie;
-			break;
-		}
-	}
-
-	return min(first_running, first_pending);
-}
-
 static async_cookie_t lowest_in_progress(struct async_domain *domain)
 {
+	async_cookie_t ret = ASYNC_COOKIE_MAX;
 	unsigned long flags;
-	async_cookie_t ret;
 
 	spin_lock_irqsave(&async_lock, flags);
-	ret = __lowest_in_progress(domain);
+	if (!list_empty(&domain->pending)) {
+		struct async_entry *first = list_first_entry(&domain->pending,
+						struct async_entry, list);
+		ret = first->cookie;
+	}
 	spin_unlock_irqrestore(&async_lock, flags);
 	return ret;
 }
@@ -128,20 +102,11 @@ static void async_run_entry_fn(struct work_struct *work)
 {
 	struct async_entry *entry =
 		container_of(work, struct async_entry, work);
-	struct async_entry *pos;
 	unsigned long flags;
 	ktime_t uninitialized_var(calltime), delta, rettime;
 	struct async_domain *domain = entry->domain;
 
-	/* 1) move self to the running queue, make sure it stays sorted */
-	spin_lock_irqsave(&async_lock, flags);
-	list_for_each_entry_reverse(pos, &domain->running, list)
-		if (entry->cookie < pos->cookie)
-			break;
-	list_move_tail(&entry->list, &pos->list);
-	spin_unlock_irqrestore(&async_lock, flags);
-
-	/* 2) run (and print duration) */
+	/* 1) run (and print duration) */
 	if (initcall_debug && system_state == SYSTEM_BOOTING) {
 		printk(KERN_DEBUG "calling  %lli_%pF @ %i\n",
 			(long long)entry->cookie,
@@ -158,19 +123,19 @@ static void async_run_entry_fn(struct work_struct *work)
 			(long long)ktime_to_ns(delta) >> 10);
 	}
 
-	/* 3) remove self from the running queue */
+	/* 2) remove self from the pending queues */
 	spin_lock_irqsave(&async_lock, flags);
 	list_del(&entry->list);
-	if (domain->registered && --domain->count == 0)
+	if (domain->registered && list_empty(&domain->pending))
 		list_del_init(&domain->node);
 
-	/* 4) free the entry */
+	/* 3) free the entry */
 	kfree(entry);
 	atomic_dec(&entry_count);
 
 	spin_unlock_irqrestore(&async_lock, flags);
 
-	/* 5) wake up any waiters */
+	/* 4) wake up any waiters */
 	wake_up(&async_done);
 }
 
@@ -204,9 +169,9 @@ static async_cookie_t __async_schedule(async_func_ptr *ptr, void *data, struct a
 
 	spin_lock_irqsave(&async_lock, flags);
 	newcookie = entry->cookie = next_cookie++;
-	list_add_tail(&entry->list, &async_pending);
-	if (domain->registered && domain->count++ == 0)
+	if (domain->registered && list_empty(&domain->pending))
 		list_add_tail(&domain->node, &async_domains);
+	list_add_tail(&entry->list, &domain->pending);
 	atomic_inc(&entry_count);
 	spin_unlock_irqrestore(&async_lock, flags);
 
@@ -285,7 +250,7 @@ void async_unregister_domain(struct async_domain *domain)
 	mutex_lock(&async_register_mutex);
 	spin_lock_irq(&async_lock);
 	WARN_ON(!domain->registered || !list_empty(&domain->node) ||
-		!list_empty(&domain->running));
+		!list_empty(&domain->pending));
 	domain->registered = 0;
 	spin_unlock_irq(&async_lock);
 	mutex_unlock(&async_register_mutex);
-- 
1.8.0.2

