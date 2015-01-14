Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbbANTTu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 14:19:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39808 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529AbbANTTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 14:19:48 -0500
Date: Wed, 14 Jan 2015 11:19:11 -0800
From: tip-bot for Davidlohr Bueso <tipbot@zytor.com>
Message-ID: <tip-4bd19084faa61a8c68586e74f03f5776179f65c2@git.kernel.org>
Cc: hpa@zytor.com, torvalds@linux-foundation.org, tglx@linutronix.de,
        dave@stgolabs.net, linux-kernel@vger.kernel.org, mingo@kernel.org,
        dbueso@suse.de, paulmck@linux.vnet.ibm.com, peterz@infradead.org
Reply-To: paulmck@linux.vnet.ibm.com, peterz@infradead.org, hpa@zytor.com,
        dave@stgolabs.net, tglx@linutronix.de, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, mingo@kernel.org, dbueso@suse.de
In-Reply-To: <1420573509-24774-4-git-send-email-dave@stgolabs.net>
References: <1420573509-24774-4-git-send-email-dave@stgolabs.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] locking/mutex:
  Introduce ww_mutex_set_context_slowpath()
Git-Commit-ID: 4bd19084faa61a8c68586e74f03f5776179f65c2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4bd19084faa61a8c68586e74f03f5776179f65c2
Gitweb:     http://git.kernel.org/tip/4bd19084faa61a8c68586e74f03f5776179f65c2
Author:     Davidlohr Bueso <dave@stgolabs.net>
AuthorDate: Tue, 6 Jan 2015 11:45:06 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 14 Jan 2015 15:07:30 +0100

locking/mutex: Introduce ww_mutex_set_context_slowpath()

... which is equivalent to the fastpath counter part.
This mainly allows getting some WW specific code out
of generic mutex paths.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1420573509-24774-4-git-send-email-dave@stgolabs.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/locking/mutex.c | 44 ++++++++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 18 deletions(-)

diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index 6db3d0d..c67a60b 100644
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
+		debug_mutex_wake_waiter(&lock->base, cur);
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
