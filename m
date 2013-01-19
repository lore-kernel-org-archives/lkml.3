Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822Ab3ASAlH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 19:41:07 -0500
Received: from mail-da0-f43.google.com ([209.85.210.43]:51369 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018Ab3ASAlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 19:41:04 -0500
Date: Fri, 18 Jan 2013 16:41:00 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>, Dan Williams <djbw@fb.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] async: replace list of active domains with global list
 of pending items
Message-ID: <20130119004100.GL24579@htj.dyndns.org>
References: <20130119003923.GH24579@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130119003923.GH24579@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 0e18802ed054fc97026973e94a58f0b9beb1b294 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Fri, 18 Jan 2013 16:34:16 -0800

Global synchronization - async_synchronize_full() - is currently
implemented by keeping a list of all active registered domains and
syncing them one by one until no domain is active.

While this isn't necessarily a complex scheme, it can easily be
simplified by keeping global list of the pending items of all
registered active domains instead of list of domains and simply using
the globl pending list the same way as domain syncing.

This patch replaces async_domains with async_global_pending and update
lowest_in_progress() to use the global pending list if @domain is
%NULL.  async_synchronize_full_domain(NULL) is now allowed and
equivalent to async_synchronize_full().  As no one is calling with
NULL domain, this doesn't affect any existing users.

async_register_mutex is no longer necessary and dropped.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 kernel/async.c | 63 +++++++++++++++++++++++++++-------------------------------
 1 file changed, 29 insertions(+), 34 deletions(-)

diff --git a/kernel/async.c b/kernel/async.c
index 711fc34..ddc59fd 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -62,13 +62,13 @@ static async_cookie_t next_cookie = 1;
 #define MAX_WORK		32768
 #define ASYNC_COOKIE_MAX	ULLONG_MAX	/* infinity cookie */
 
+static LIST_HEAD(async_global_pending);	/* pending from all registered doms */
 static ASYNC_DOMAIN(async_dfl_domain);
-static LIST_HEAD(async_domains);
 static DEFINE_SPINLOCK(async_lock);
-static DEFINE_MUTEX(async_register_mutex);
 
 struct async_entry {
-	struct list_head	list;
+	struct list_head	domain_list;
+	struct list_head	global_list;
 	struct work_struct	work;
 	async_cookie_t		cookie;
 	async_func_ptr		*func;
@@ -82,15 +82,25 @@ static atomic_t entry_count;
 
 static async_cookie_t lowest_in_progress(struct async_domain *domain)
 {
+	struct async_entry *first = NULL;
 	async_cookie_t ret = ASYNC_COOKIE_MAX;
 	unsigned long flags;
 
 	spin_lock_irqsave(&async_lock, flags);
-	if (!list_empty(&domain->pending)) {
-		struct async_entry *first = list_first_entry(&domain->pending,
-						struct async_entry, list);
-		ret = first->cookie;
+
+	if (domain) {
+		if (!list_empty(&domain->pending))
+			first = list_first_entry(&domain->pending,
+					struct async_entry, domain_list);
+	} else {
+		if (!list_empty(&async_global_pending))
+			first = list_first_entry(&async_global_pending,
+					struct async_entry, global_list);
 	}
+
+	if (first)
+		ret = first->cookie;
+
 	spin_unlock_irqrestore(&async_lock, flags);
 	return ret;
 }
@@ -104,7 +114,6 @@ static void async_run_entry_fn(struct work_struct *work)
 		container_of(work, struct async_entry, work);
 	unsigned long flags;
 	ktime_t uninitialized_var(calltime), delta, rettime;
-	struct async_domain *domain = entry->domain;
 
 	/* 1) run (and print duration) */
 	if (initcall_debug && system_state == SYSTEM_BOOTING) {
@@ -125,9 +134,8 @@ static void async_run_entry_fn(struct work_struct *work)
 
 	/* 2) remove self from the pending queues */
 	spin_lock_irqsave(&async_lock, flags);
-	list_del(&entry->list);
-	if (domain->registered && list_empty(&domain->pending))
-		list_del_init(&domain->node);
+	list_del_init(&entry->domain_list);
+	list_del_init(&entry->global_list);
 
 	/* 3) free the entry */
 	kfree(entry);
@@ -168,10 +176,14 @@ static async_cookie_t __async_schedule(async_func_ptr *ptr, void *data, struct a
 	entry->domain = domain;
 
 	spin_lock_irqsave(&async_lock, flags);
+
+	/* allocate cookie and queue */
 	newcookie = entry->cookie = next_cookie++;
-	if (domain->registered && list_empty(&domain->pending))
-		list_add_tail(&domain->node, &async_domains);
-	list_add_tail(&entry->list, &domain->pending);
+
+	list_add_tail(&entry->domain_list, &domain->pending);
+	if (domain->registered)
+		list_add_tail(&entry->global_list, &async_global_pending);
+
 	atomic_inc(&entry_count);
 	spin_unlock_irqrestore(&async_lock, flags);
 
@@ -221,18 +233,7 @@ EXPORT_SYMBOL_GPL(async_schedule_domain);
  */
 void async_synchronize_full(void)
 {
-	mutex_lock(&async_register_mutex);
-	do {
-		struct async_domain *domain = NULL;
-
-		spin_lock_irq(&async_lock);
-		if (!list_empty(&async_domains))
-			domain = list_first_entry(&async_domains, typeof(*domain), node);
-		spin_unlock_irq(&async_lock);
-
-		async_synchronize_cookie_domain(ASYNC_COOKIE_MAX, domain);
-	} while (!list_empty(&async_domains));
-	mutex_unlock(&async_register_mutex);
+	async_synchronize_full_domain(NULL);
 }
 EXPORT_SYMBOL_GPL(async_synchronize_full);
 
@@ -247,13 +248,10 @@ EXPORT_SYMBOL_GPL(async_synchronize_full);
  */
 void async_unregister_domain(struct async_domain *domain)
 {
-	mutex_lock(&async_register_mutex);
 	spin_lock_irq(&async_lock);
-	WARN_ON(!domain->registered || !list_empty(&domain->node) ||
-		!list_empty(&domain->pending));
+	WARN_ON(!domain->registered || !list_empty(&domain->pending));
 	domain->registered = 0;
 	spin_unlock_irq(&async_lock);
-	mutex_unlock(&async_register_mutex);
 }
 EXPORT_SYMBOL_GPL(async_unregister_domain);
 
@@ -273,7 +271,7 @@ EXPORT_SYMBOL_GPL(async_synchronize_full_domain);
 /**
  * async_synchronize_cookie_domain - synchronize asynchronous function calls within a certain domain with cookie checkpointing
  * @cookie: async_cookie_t to use as checkpoint
- * @domain: the domain to synchronize
+ * @domain: the domain to synchronize (%NULL for all registered domains)
  *
  * This function waits until all asynchronous function calls for the
  * synchronization domain specified by @domain submitted prior to @cookie
@@ -283,9 +281,6 @@ void async_synchronize_cookie_domain(async_cookie_t cookie, struct async_domain
 {
 	ktime_t uninitialized_var(starttime), delta, endtime;
 
-	if (!domain)
-		return;
-
 	if (initcall_debug && system_state == SYSTEM_BOOTING) {
 		printk(KERN_DEBUG "async_waiting @ %i\n", task_pid_nr(current));
 		starttime = ktime_get();
-- 
1.8.0.2

