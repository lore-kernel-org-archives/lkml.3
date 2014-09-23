Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbaIWF6q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 01:58:46 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:33119 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451AbaIWFzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 01:55:24 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: kmo@daterainc.com, axboe@kernel.dk, hch@infradead.org, hannes@cmpxchg.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/9] percpu_ref: minor code and comment updates
Date: Tue, 23 Sep 2014 01:55:11 -0400
Message-Id: <1411451718-17807-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411451718-17807-1-git-send-email-tj@kernel.org>
References: <1411451718-17807-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Some comments became stale.  Updated.
* percpu_ref_tryget() unnecessarily initializes @ret.  Removed.
* A blank line removed from percpu_ref_kill_rcu().
* Explicit function name in a WARN format string replaced with __func__.
* WARN_ON() in percpu_ref_reinit() converted to WARN_ON_ONCE().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Kent Overstreet <kmo@daterainc.com>
---
 include/linux/percpu-refcount.h | 25 ++++++++++++++++---------
 lib/percpu-refcount.c           | 14 ++++++--------
 2 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
index f015f13..d44b027 100644
--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -115,8 +115,10 @@ static inline bool __pcpu_ref_alive(struct percpu_ref *ref,
  * percpu_ref_get - increment a percpu refcount
  * @ref: percpu_ref to get
  *
- * Analagous to atomic_inc().
-  */
+ * Analagous to atomic_long_inc().
+ *
+ * This function is safe to call as long as @ref is between init and exit.
+ */
 static inline void percpu_ref_get(struct percpu_ref *ref)
 {
 	unsigned long __percpu *pcpu_count;
@@ -138,12 +140,12 @@ static inline void percpu_ref_get(struct percpu_ref *ref)
  * Increment a percpu refcount unless its count already reached zero.
  * Returns %true on success; %false on failure.
  *
- * The caller is responsible for ensuring that @ref stays accessible.
+ * This function is safe to call as long as @ref is between init and exit.
  */
 static inline bool percpu_ref_tryget(struct percpu_ref *ref)
 {
 	unsigned long __percpu *pcpu_count;
-	int ret = false;
+	int ret;
 
 	rcu_read_lock_sched();
 
@@ -166,12 +168,13 @@ static inline bool percpu_ref_tryget(struct percpu_ref *ref)
  * Increment a percpu refcount unless it has already been killed.  Returns
  * %true on success; %false on failure.
  *
- * Completion of percpu_ref_kill() in itself doesn't guarantee that tryget
- * will fail.  For such guarantee, percpu_ref_kill_and_confirm() should be
- * used.  After the confirm_kill callback is invoked, it's guaranteed that
- * no new reference will be given out by percpu_ref_tryget().
+ * Completion of percpu_ref_kill() in itself doesn't guarantee that this
+ * function will fail.  For such guarantee, percpu_ref_kill_and_confirm()
+ * should be used.  After the confirm_kill callback is invoked, it's
+ * guaranteed that no new reference will be given out by
+ * percpu_ref_tryget_live().
  *
- * The caller is responsible for ensuring that @ref stays accessible.
+ * This function is safe to call as long as @ref is between init and exit.
  */
 static inline bool percpu_ref_tryget_live(struct percpu_ref *ref)
 {
@@ -196,6 +199,8 @@ static inline bool percpu_ref_tryget_live(struct percpu_ref *ref)
  *
  * Decrement the refcount, and if 0, call the release function (which was passed
  * to percpu_ref_init())
+ *
+ * This function is safe to call as long as @ref is between init and exit.
  */
 static inline void percpu_ref_put(struct percpu_ref *ref)
 {
@@ -216,6 +221,8 @@ static inline void percpu_ref_put(struct percpu_ref *ref)
  * @ref: percpu_ref to test
  *
  * Returns %true if @ref reached zero.
+ *
+ * This function is safe to call as long as @ref is between init and exit.
  */
 static inline bool percpu_ref_is_zero(struct percpu_ref *ref)
 {
diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
index 070dab5..8ef3f5c 100644
--- a/lib/percpu-refcount.c
+++ b/lib/percpu-refcount.c
@@ -108,7 +108,6 @@ static void percpu_ref_kill_rcu(struct rcu_head *rcu)
 	 * reaching 0 before we add the percpu counts. But doing it at the same
 	 * time is equivalent and saves us atomic operations:
 	 */
-
 	atomic_long_add((long)count - PCPU_COUNT_BIAS, &ref->count);
 
 	WARN_ONCE(atomic_long_read(&ref->count) <= 0,
@@ -120,8 +119,8 @@ static void percpu_ref_kill_rcu(struct rcu_head *rcu)
 		ref->confirm_kill(ref);
 
 	/*
-	 * Now we're in single atomic_t mode with a consistent refcount, so it's
-	 * safe to drop our initial ref:
+	 * Now we're in single atomic_long_t mode with a consistent
+	 * refcount, so it's safe to drop our initial ref:
 	 */
 	percpu_ref_put(ref);
 }
@@ -134,8 +133,8 @@ static void percpu_ref_kill_rcu(struct rcu_head *rcu)
  * Equivalent to percpu_ref_kill() but also schedules kill confirmation if
  * @confirm_kill is not NULL.  @confirm_kill, which may not block, will be
  * called after @ref is seen as dead from all CPUs - all further
- * invocations of percpu_ref_tryget() will fail.  See percpu_ref_tryget()
- * for more details.
+ * invocations of percpu_ref_tryget_live() will fail.  See
+ * percpu_ref_tryget_live() for more details.
  *
  * Due to the way percpu_ref is implemented, @confirm_kill will be called
  * after at least one full RCU grace period has passed but this is an
@@ -145,8 +144,7 @@ void percpu_ref_kill_and_confirm(struct percpu_ref *ref,
 				 percpu_ref_func_t *confirm_kill)
 {
 	WARN_ONCE(ref->pcpu_count_ptr & PCPU_REF_DEAD,
-		  "percpu_ref_kill() called more than once on %pf!",
-		  ref->release);
+		  "%s called more than once on %pf!", __func__, ref->release);
 
 	ref->pcpu_count_ptr |= PCPU_REF_DEAD;
 	ref->confirm_kill = confirm_kill;
@@ -172,7 +170,7 @@ void percpu_ref_reinit(struct percpu_ref *ref)
 	int cpu;
 
 	BUG_ON(!pcpu_count);
-	WARN_ON(!percpu_ref_is_zero(ref));
+	WARN_ON_ONCE(!percpu_ref_is_zero(ref));
 
 	atomic_long_set(&ref->count, 1 + PCPU_COUNT_BIAS);
 
-- 
1.9.3

