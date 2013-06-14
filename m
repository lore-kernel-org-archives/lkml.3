Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759999Ab3FNClb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 22:41:31 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:52357 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759888Ab3FNCl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 22:41:26 -0400
Date: Thu, 13 Jun 2013 19:41:22 -0700
From: Tejun Heo <tj@kernel.org>
To: Tejun Heo <theo@redhat.com>
Cc: Kent Overstreet <koverstreet@google.com>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>, Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: [PATCH v3 2/2] percpu-refcount: implement percpu_tryget() along with
 percpu_ref_kill_and_confirm()
Message-ID: <20130614024122.GA7846@htj.dyndns.org>
References: <20130612204532.GB15092@htj.dyndns.org>
 <20130612204627.GC15092@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130612204627.GC15092@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From dbece3a0f1ef0b19aff1cc6ed0942fec9ab98de1 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Thu, 13 Jun 2013 19:23:53 -0700

Implement percpu_tryget() which stops giving out references once the
percpu_ref is visible as killed.  Because the refcnt is per-cpu,
different CPUs will start to see a refcnt as killed at different
points in time and tryget() may continue to succeed on subset of cpus
for a while after percpu_ref_kill() returns.

For use cases where it's necessary to know when all CPUs start to see
the refcnt as dead, percpu_ref_kill_and_confirm() is added.  The new
function takes an extra argument @confirm_kill which is invoked when
the refcnt is guaranteed to be viewed as killed on all CPUs.

While this isn't the prettiest interface, it doesn't force synchronous
wait and is much safer than requiring the caller to do its own
call_rcu().

v2: Patch description rephrased to emphasize that tryget() may
    continue to succeed on some CPUs after kill() returns as suggested
    by Kent.

v3: Function comment in percpu_ref_kill_and_confirm() updated warning
    people to not depend on the implied RCU grace period from the
    confirm callback as it's an implementation detail.

Signed-off-by: Tejun Heo <tj@kernel.org>
Slightly-Grumpily-Acked-by: Kent Overstreet <koverstreet@google.com>
---
Applied to percpu/for-3.11.

Thanks!

 include/linux/percpu-refcount.h | 50 ++++++++++++++++++++++++++++++++++++++++-
 lib/percpu-refcount.c           | 23 ++++++++++++++-----
 2 files changed, 66 insertions(+), 7 deletions(-)

diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
index 6d843d6..dd2a086 100644
--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -63,13 +63,30 @@ struct percpu_ref {
 	 */
 	unsigned __percpu	*pcpu_count;
 	percpu_ref_func_t	*release;
+	percpu_ref_func_t	*confirm_kill;
 	struct rcu_head		rcu;
 };
 
 int __must_check percpu_ref_init(struct percpu_ref *ref,
 				 percpu_ref_func_t *release);
 void percpu_ref_cancel_init(struct percpu_ref *ref);
-void percpu_ref_kill(struct percpu_ref *ref);
+void percpu_ref_kill_and_confirm(struct percpu_ref *ref,
+				 percpu_ref_func_t *confirm_kill);
+
+/**
+ * percpu_ref_kill - drop the initial ref
+ * @ref: percpu_ref to kill
+ *
+ * Must be used to drop the initial ref on a percpu refcount; must be called
+ * precisely once before shutdown.
+ *
+ * Puts @ref in non percpu mode, then does a call_rcu() before gathering up the
+ * percpu counters and dropping the initial ref.
+ */
+static inline void percpu_ref_kill(struct percpu_ref *ref)
+{
+	return percpu_ref_kill_and_confirm(ref, NULL);
+}
 
 #define PCPU_STATUS_BITS	2
 #define PCPU_STATUS_MASK	((1 << PCPU_STATUS_BITS) - 1)
@@ -101,6 +118,37 @@ static inline void percpu_ref_get(struct percpu_ref *ref)
 }
 
 /**
+ * percpu_ref_tryget - try to increment a percpu refcount
+ * @ref: percpu_ref to try-get
+ *
+ * Increment a percpu refcount unless it has already been killed.  Returns
+ * %true on success; %false on failure.
+ *
+ * Completion of percpu_ref_kill() in itself doesn't guarantee that tryget
+ * will fail.  For such guarantee, percpu_ref_kill_and_confirm() should be
+ * used.  After the confirm_kill callback is invoked, it's guaranteed that
+ * no new reference will be given out by percpu_ref_tryget().
+ */
+static inline bool percpu_ref_tryget(struct percpu_ref *ref)
+{
+	unsigned __percpu *pcpu_count;
+	int ret = false;
+
+	rcu_read_lock();
+
+	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
+
+	if (likely(REF_STATUS(pcpu_count) == PCPU_REF_PTR)) {
+		__this_cpu_inc(*pcpu_count);
+		ret = true;
+	}
+
+	rcu_read_unlock();
+
+	return ret;
+}
+
+/**
  * percpu_ref_put - decrement a percpu refcount
  * @ref: percpu_ref to put
  *
diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
index ebeaac2..8bf9e71 100644
--- a/lib/percpu-refcount.c
+++ b/lib/percpu-refcount.c
@@ -118,6 +118,10 @@ static void percpu_ref_kill_rcu(struct rcu_head *rcu)
 
 	atomic_add((int) count - PCPU_COUNT_BIAS, &ref->count);
 
+	/* @ref is viewed as dead on all CPUs, send out kill confirmation */
+	if (ref->confirm_kill)
+		ref->confirm_kill(ref);
+
 	/*
 	 * Now we're in single atomic_t mode with a consistent refcount, so it's
 	 * safe to drop our initial ref:
@@ -126,22 +130,29 @@ static void percpu_ref_kill_rcu(struct rcu_head *rcu)
 }
 
 /**
- * percpu_ref_kill - safely drop initial ref
+ * percpu_ref_kill_and_confirm - drop the initial ref and schedule confirmation
  * @ref: percpu_ref to kill
+ * @confirm_kill: optional confirmation callback
  *
- * Must be used to drop the initial ref on a percpu refcount; must be called
- * precisely once before shutdown.
+ * Equivalent to percpu_ref_kill() but also schedules kill confirmation if
+ * @confirm_kill is not NULL.  @confirm_kill, which may not block, will be
+ * called after @ref is seen as dead from all CPUs - all further
+ * invocations of percpu_ref_tryget() will fail.  See percpu_ref_tryget()
+ * for more details.
  *
- * Puts @ref in non percpu mode, then does a call_rcu() before gathering up the
- * percpu counters and dropping the initial ref.
+ * Due to the way percpu_ref is implemented, @confirm_kill will be called
+ * after at least one full RCU grace period has passed but this is an
+ * implementation detail and callers must not depend on it.
  */
-void percpu_ref_kill(struct percpu_ref *ref)
+void percpu_ref_kill_and_confirm(struct percpu_ref *ref,
+				 percpu_ref_func_t *confirm_kill)
 {
 	WARN_ONCE(REF_STATUS(ref->pcpu_count) == PCPU_REF_DEAD,
 		  "percpu_ref_kill() called more than once!\n");
 
 	ref->pcpu_count = (unsigned __percpu *)
 		(((unsigned long) ref->pcpu_count)|PCPU_REF_DEAD);
+	ref->confirm_kill = confirm_kill;
 
 	call_rcu(&ref->rcu, percpu_ref_kill_rcu);
 }
-- 
1.8.2.1

