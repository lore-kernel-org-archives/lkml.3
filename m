Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932881AbbAFTqI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:46:08 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:36145 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932594AbbAFTpz (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Tue, 6 Jan 2015 14:45:55 -0500
From: Davidlohr Bueso <dave@stgolabs.net>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Davidlohr Bueso <dave@stgolabs.net>, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH 3/6] locking/mutex: Introduce ww_mutex_set_context_slowpath
Date: Tue,  6 Jan 2015 11:45:06 -0800
Message-Id: <1420573509-24774-4-git-send-email-dave@stgolabs.net>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1420573509-24774-1-git-send-email-dave@stgolabs.net>
References: <1420573509-24774-1-git-send-email-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... which is equivalent to the fastpath counter part.
This mainly allows getting some ww specific code out
of generic mutex paths.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 kernel/locking/mutex.c | 44 ++++++++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 18 deletions(-)

diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index 6db3d0d..2ac48e0 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -147,7 +147,7 @@ static __always_inline void ww_mutex_lock_acquired(struct ww_mutex *ww,
 }
 
 /*
- * after acquiring lock with fastpath or when we lost out in contested
+ * After acquiring lock with fastpath or when we lost out in contested
  * slowpath, set ctx and wake up any waiters so they can recheck.
  *
  * This function is never called when CONFIG_DEBUG_LOCK_ALLOC is set,
@@ -191,6 +191,30 @@ ww_mutex_set_context_fastpath(struct ww_mutex *lock,
 	spin_unlock_mutex(&lock->base.wait_lock, flags);
 }
 
+/*
+ * After acquiring lock in the slowpath set ctx and wake up any
+ * waiters so they can recheck.
+ *
+ * Callers must hold the mutex wait_lock.
+ */
+static __always_inline void
+ww_mutex_set_context_slowpath(struct ww_mutex *lock,
+			      struct ww_acquire_ctx *ctx)
+{
+	struct mutex_waiter *cur;
+
+	ww_mutex_lock_acquired(lock, ctx);
+	lock->ctx = ctx;
+
+	/*
+	 * Give any possible sleeping processes the chance to wake up,
+	 * so they can recheck if they have to back off.
+	 */
+	list_for_each_entry(cur, &lock->base.wait_list, list) {
+		debug_mutex_wake_waiter(lock->base, cur);
+		wake_up_process(cur->task);
+	}
+}
 
 #ifdef CONFIG_MUTEX_SPIN_ON_OWNER
 static inline bool owner_running(struct mutex *lock, struct task_struct *owner)
@@ -576,23 +600,7 @@ skip_wait:
 
 	if (use_ww_ctx) {
 		struct ww_mutex *ww = container_of(lock, struct ww_mutex, base);
-		struct mutex_waiter *cur;
-
-		/*
-		 * This branch gets optimized out for the common case,
-		 * and is only important for ww_mutex_lock.
-		 */
-		ww_mutex_lock_acquired(ww, ww_ctx);
-		ww->ctx = ww_ctx;
-
-		/*
-		 * Give any possible sleeping processes the chance to wake up,
-		 * so they can recheck if they have to back off.
-		 */
-		list_for_each_entry(cur, &lock->wait_list, list) {
-			debug_mutex_wake_waiter(lock, cur);
-			wake_up_process(cur->task);
-		}
+		ww_mutex_set_context_slowpath(ww, ww_ctx);
 	}
 
 	spin_unlock_mutex(&lock->wait_lock, flags);
-- 
2.1.2

