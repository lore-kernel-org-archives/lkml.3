Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab3ASAkD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 19:40:03 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:35546 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab3ASAkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 19:40:01 -0500
Date: Fri, 18 Jan 2013 16:39:54 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>, Dan Williams <djbw@fb.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] async: bring sanity to the use of words domain and
 running
Message-ID: <20130119003954.GI24579@htj.dyndns.org>
References: <20130119003923.GH24579@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130119003923.GH24579@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From eefff28c548fc92cd85dc2b6f22282c9400bce52 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Fri, 18 Jan 2013 16:34:15 -0800

In the beginning, running lists were literal struct list_heads.  Later
on, struct async_domain was added.  For some reason, while the
conversion substituted list_heads with async_domains, the variable
names weren't fully converted.  In more places, "running" was used for
struct async_domain while other places adopted new "domain" name.

The situation is made much worse by having async_domain's running list
named "domain" and async_entry's field pointing to async_domain named
"running".

So, we end up with mix of "running" and "domain" for variable names
for async_domain, with the field names of async_domain and async_entry
swapped between "running" and "domain".

It feels almost intentionally made to be as confusing as possible.
Bring some sanity by

* Renaming all async_domain variables "domain".

* s/async_running/async_dfl_domain/

* s/async_domain->domain/async_domain->running/

* s/async_entry->running/async_entry->domain/

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 include/linux/async.h |  6 ++---
 kernel/async.c        | 68 +++++++++++++++++++++++++--------------------------
 2 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/include/linux/async.h b/include/linux/async.h
index 7a24fe9..6f23442 100644
--- a/include/linux/async.h
+++ b/include/linux/async.h
@@ -19,7 +19,7 @@ typedef u64 async_cookie_t;
 typedef void (async_func_ptr) (void *data, async_cookie_t cookie);
 struct async_domain {
 	struct list_head node;
-	struct list_head domain;
+	struct list_head running;
 	int count;
 	unsigned registered:1;
 };
@@ -29,7 +29,7 @@ struct async_domain {
  */
 #define ASYNC_DOMAIN(_name) \
 	struct async_domain _name = { .node = LIST_HEAD_INIT(_name.node), \
-				      .domain = LIST_HEAD_INIT(_name.domain), \
+				      .running = LIST_HEAD_INIT(_name.running), \
 				      .count = 0, \
 				      .registered = 1 }
 
@@ -39,7 +39,7 @@ struct async_domain {
  */
 #define ASYNC_DOMAIN_EXCLUSIVE(_name) \
 	struct async_domain _name = { .node = LIST_HEAD_INIT(_name.node), \
-				      .domain = LIST_HEAD_INIT(_name.domain), \
+				      .running = LIST_HEAD_INIT(_name.running), \
 				      .count = 0, \
 				      .registered = 0 }
 
diff --git a/kernel/async.c b/kernel/async.c
index 8f9f5cf..c082fed 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -62,7 +62,7 @@ static async_cookie_t next_cookie = 1;
 #define MAX_WORK	32768
 
 static LIST_HEAD(async_pending);
-static ASYNC_DOMAIN(async_running);
+static ASYNC_DOMAIN(async_dfl_domain);
 static LIST_HEAD(async_domains);
 static DEFINE_SPINLOCK(async_lock);
 static DEFINE_MUTEX(async_register_mutex);
@@ -73,7 +73,7 @@ struct async_entry {
 	async_cookie_t		cookie;
 	async_func_ptr		*func;
 	void			*data;
-	struct async_domain	*running;
+	struct async_domain	*domain;
 };
 
 static DECLARE_WAIT_QUEUE_HEAD(async_done);
@@ -84,7 +84,7 @@ static atomic_t entry_count;
 /*
  * MUST be called with the lock held!
  */
-static async_cookie_t  __lowest_in_progress(struct async_domain *running)
+static async_cookie_t __lowest_in_progress(struct async_domain *domain)
 {
 	async_cookie_t first_running = next_cookie;	/* infinity value */
 	async_cookie_t first_pending = next_cookie;	/* ditto */
@@ -94,13 +94,13 @@ static async_cookie_t  __lowest_in_progress(struct async_domain *running)
 	 * Both running and pending lists are sorted but not disjoint.
 	 * Take the first cookies from both and return the min.
 	 */
-	if (!list_empty(&running->domain)) {
-		entry = list_first_entry(&running->domain, typeof(*entry), list);
+	if (!list_empty(&domain->running)) {
+		entry = list_first_entry(&domain->running, typeof(*entry), list);
 		first_running = entry->cookie;
 	}
 
 	list_for_each_entry(entry, &async_pending, list) {
-		if (entry->running == running) {
+		if (entry->domain == domain) {
 			first_pending = entry->cookie;
 			break;
 		}
@@ -109,13 +109,13 @@ static async_cookie_t  __lowest_in_progress(struct async_domain *running)
 	return min(first_running, first_pending);
 }
 
-static async_cookie_t  lowest_in_progress(struct async_domain *running)
+static async_cookie_t lowest_in_progress(struct async_domain *domain)
 {
 	unsigned long flags;
 	async_cookie_t ret;
 
 	spin_lock_irqsave(&async_lock, flags);
-	ret = __lowest_in_progress(running);
+	ret = __lowest_in_progress(domain);
 	spin_unlock_irqrestore(&async_lock, flags);
 	return ret;
 }
@@ -130,11 +130,11 @@ static void async_run_entry_fn(struct work_struct *work)
 	struct async_entry *pos;
 	unsigned long flags;
 	ktime_t uninitialized_var(calltime), delta, rettime;
-	struct async_domain *running = entry->running;
+	struct async_domain *domain = entry->domain;
 
 	/* 1) move self to the running queue, make sure it stays sorted */
 	spin_lock_irqsave(&async_lock, flags);
-	list_for_each_entry_reverse(pos, &running->domain, list)
+	list_for_each_entry_reverse(pos, &domain->running, list)
 		if (entry->cookie < pos->cookie)
 			break;
 	list_move_tail(&entry->list, &pos->list);
@@ -160,8 +160,8 @@ static void async_run_entry_fn(struct work_struct *work)
 	/* 3) remove self from the running queue */
 	spin_lock_irqsave(&async_lock, flags);
 	list_del(&entry->list);
-	if (running->registered && --running->count == 0)
-		list_del_init(&running->node);
+	if (domain->registered && --domain->count == 0)
+		list_del_init(&domain->node);
 
 	/* 4) free the entry */
 	kfree(entry);
@@ -173,7 +173,7 @@ static void async_run_entry_fn(struct work_struct *work)
 	wake_up(&async_done);
 }
 
-static async_cookie_t __async_schedule(async_func_ptr *ptr, void *data, struct async_domain *running)
+static async_cookie_t __async_schedule(async_func_ptr *ptr, void *data, struct async_domain *domain)
 {
 	struct async_entry *entry;
 	unsigned long flags;
@@ -199,13 +199,13 @@ static async_cookie_t __async_schedule(async_func_ptr *ptr, void *data, struct a
 	INIT_WORK(&entry->work, async_run_entry_fn);
 	entry->func = ptr;
 	entry->data = data;
-	entry->running = running;
+	entry->domain = domain;
 
 	spin_lock_irqsave(&async_lock, flags);
 	newcookie = entry->cookie = next_cookie++;
 	list_add_tail(&entry->list, &async_pending);
-	if (running->registered && running->count++ == 0)
-		list_add_tail(&running->node, &async_domains);
+	if (domain->registered && domain->count++ == 0)
+		list_add_tail(&domain->node, &async_domains);
 	atomic_inc(&entry_count);
 	spin_unlock_irqrestore(&async_lock, flags);
 
@@ -225,7 +225,7 @@ static async_cookie_t __async_schedule(async_func_ptr *ptr, void *data, struct a
  */
 async_cookie_t async_schedule(async_func_ptr *ptr, void *data)
 {
-	return __async_schedule(ptr, data, &async_running);
+	return __async_schedule(ptr, data, &async_dfl_domain);
 }
 EXPORT_SYMBOL_GPL(async_schedule);
 
@@ -233,18 +233,18 @@ EXPORT_SYMBOL_GPL(async_schedule);
  * async_schedule_domain - schedule a function for asynchronous execution within a certain domain
  * @ptr: function to execute asynchronously
  * @data: data pointer to pass to the function
- * @running: running list for the domain
+ * @domain: the domain
  *
  * Returns an async_cookie_t that may be used for checkpointing later.
- * @running may be used in the async_synchronize_*_domain() functions
- * to wait within a certain synchronization domain rather than globally.
- * A synchronization domain is specified via the running queue @running to use.
- * Note: This function may be called from atomic or non-atomic contexts.
+ * @domain may be used in the async_synchronize_*_domain() functions to
+ * wait within a certain synchronization domain rather than globally.  A
+ * synchronization domain is specified via @domain.  Note: This function
+ * may be called from atomic or non-atomic contexts.
  */
 async_cookie_t async_schedule_domain(async_func_ptr *ptr, void *data,
-				     struct async_domain *running)
+				     struct async_domain *domain)
 {
-	return __async_schedule(ptr, data, running);
+	return __async_schedule(ptr, data, domain);
 }
 EXPORT_SYMBOL_GPL(async_schedule_domain);
 
@@ -284,7 +284,7 @@ void async_unregister_domain(struct async_domain *domain)
 	mutex_lock(&async_register_mutex);
 	spin_lock_irq(&async_lock);
 	WARN_ON(!domain->registered || !list_empty(&domain->node) ||
-		!list_empty(&domain->domain));
+		!list_empty(&domain->running));
 	domain->registered = 0;
 	spin_unlock_irq(&async_lock);
 	mutex_unlock(&async_register_mutex);
@@ -293,10 +293,10 @@ EXPORT_SYMBOL_GPL(async_unregister_domain);
 
 /**
  * async_synchronize_full_domain - synchronize all asynchronous function within a certain domain
- * @domain: running list to synchronize on
+ * @domain: the domain to synchronize
  *
  * This function waits until all asynchronous function calls for the
- * synchronization domain specified by the running list @domain have been done.
+ * synchronization domain specified by @domain have been done.
  */
 void async_synchronize_full_domain(struct async_domain *domain)
 {
@@ -307,17 +307,17 @@ EXPORT_SYMBOL_GPL(async_synchronize_full_domain);
 /**
  * async_synchronize_cookie_domain - synchronize asynchronous function calls within a certain domain with cookie checkpointing
  * @cookie: async_cookie_t to use as checkpoint
- * @running: running list to synchronize on
+ * @domain: the domain to synchronize
  *
  * This function waits until all asynchronous function calls for the
- * synchronization domain specified by running list @running submitted
- * prior to @cookie have been done.
+ * synchronization domain specified by @domain submitted prior to @cookie
+ * have been done.
  */
-void async_synchronize_cookie_domain(async_cookie_t cookie, struct async_domain *running)
+void async_synchronize_cookie_domain(async_cookie_t cookie, struct async_domain *domain)
 {
 	ktime_t uninitialized_var(starttime), delta, endtime;
 
-	if (!running)
+	if (!domain)
 		return;
 
 	if (initcall_debug && system_state == SYSTEM_BOOTING) {
@@ -325,7 +325,7 @@ void async_synchronize_cookie_domain(async_cookie_t cookie, struct async_domain
 		starttime = ktime_get();
 	}
 
-	wait_event(async_done, lowest_in_progress(running) >= cookie);
+	wait_event(async_done, lowest_in_progress(domain) >= cookie);
 
 	if (initcall_debug && system_state == SYSTEM_BOOTING) {
 		endtime = ktime_get();
@@ -347,6 +347,6 @@ EXPORT_SYMBOL_GPL(async_synchronize_cookie_domain);
  */
 void async_synchronize_cookie(async_cookie_t cookie)
 {
-	async_synchronize_cookie_domain(cookie, &async_running);
+	async_synchronize_cookie_domain(cookie, &async_dfl_domain);
 }
 EXPORT_SYMBOL_GPL(async_synchronize_cookie);
-- 
1.8.0.2

