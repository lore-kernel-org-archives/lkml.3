Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbaL1JOY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 04:14:24 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:35765 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbaL1JMR (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Sun, 28 Dec 2014 04:12:17 -0500
From: Davidlohr Bueso <dave@stgolabs.net>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Davidlohr Bueso <dave@stgolabs.net>, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH 2/8] locking/mutex: Get rid of use_ww_cxt param in common paths
Date: Sun, 28 Dec 2014 01:11:17 -0800
Message-Id: <1419757883-4423-3-git-send-email-dave@stgolabs.net>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1419757883-4423-1-git-send-email-dave@stgolabs.net>
References: <1419757883-4423-1-git-send-email-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... and simplify a bit the parameters of __mutex_lock_common(). This
is straightforward as we can just check if the ww cxt for NULL if passed
from non wait/wound paths.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 kernel/locking/mutex.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index 4541951..2e687a8 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -300,7 +300,7 @@ static inline bool mutex_try_to_acquire(struct mutex *lock)
  * that we need to jump to the slowpath and sleep.
  */
 static bool mutex_optimistic_spin(struct mutex *lock,
-				  struct ww_acquire_ctx *ww_ctx, const bool use_ww_ctx)
+				  struct ww_acquire_ctx *ww_ctx)
 {
 	struct task_struct *task = current;
 
@@ -313,7 +313,7 @@ static bool mutex_optimistic_spin(struct mutex *lock,
 	while (true) {
 		struct task_struct *owner;
 
-		if (use_ww_ctx && ww_ctx->acquired > 0) {
+		if (ww_ctx && ww_ctx->acquired > 0) {
 			struct ww_mutex *ww;
 
 			ww = container_of(lock, struct ww_mutex, base);
@@ -341,7 +341,7 @@ static bool mutex_optimistic_spin(struct mutex *lock,
 		if (mutex_try_to_acquire(lock)) {
 			lock_acquired(&lock->dep_map, ip);
 
-			if (use_ww_ctx) {
+			if (ww_ctx) {
 				struct ww_mutex *ww;
 				ww = container_of(lock, struct ww_mutex, base);
 
@@ -391,7 +391,7 @@ done:
 }
 #else
 static bool mutex_optimistic_spin(struct mutex *lock,
-				  struct ww_acquire_ctx *ww_ctx, const bool use_ww_ctx)
+				  struct ww_acquire_ctx *ww_ctx)
 {
 	return false;
 }
@@ -498,7 +498,7 @@ __mutex_lock_check_stamp(struct mutex *lock, struct ww_acquire_ctx *ctx)
 static __always_inline int __sched
 __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		    struct lockdep_map *nest_lock, unsigned long ip,
-		    struct ww_acquire_ctx *ww_ctx, const bool use_ww_ctx)
+		    struct ww_acquire_ctx *ww_ctx)
 {
 	struct task_struct *task = current;
 	struct mutex_waiter waiter;
@@ -508,7 +508,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	preempt_disable();
 	mutex_acquire_nest(&lock->dep_map, subclass, 0, nest_lock, ip);
 
-	if (mutex_optimistic_spin(lock, ww_ctx, use_ww_ctx)) {
+	if (mutex_optimistic_spin(lock, ww_ctx)) {
 		/* got the lock, yay! */
 		preempt_enable();
 		return 0;
@@ -556,7 +556,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 			goto err;
 		}
 
-		if (use_ww_ctx && ww_ctx->acquired > 0) {
+		if (ww_ctx && ww_ctx->acquired > 0) {
 			ret = __mutex_lock_check_stamp(lock, ww_ctx);
 			if (ret)
 				goto err;
@@ -580,7 +580,7 @@ skip_wait:
 	lock_acquired(&lock->dep_map, ip);
 	mutex_set_owner(lock);
 
-	if (use_ww_ctx) {
+	if (ww_ctx) {
 		struct ww_mutex *ww = container_of(lock, struct ww_mutex, base);
 		struct mutex_waiter *cur;
 
@@ -620,7 +620,7 @@ mutex_lock_nested(struct mutex *lock, unsigned int subclass)
 {
 	might_sleep();
 	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE,
-			    subclass, NULL, _RET_IP_, NULL, 0);
+			    subclass, NULL, _RET_IP_, NULL);
 }
 
 EXPORT_SYMBOL_GPL(mutex_lock_nested);
@@ -630,7 +630,7 @@ _mutex_lock_nest_lock(struct mutex *lock, struct lockdep_map *nest)
 {
 	might_sleep();
 	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE,
-			    0, nest, _RET_IP_, NULL, 0);
+			    0, nest, _RET_IP_, NULL);
 }
 
 EXPORT_SYMBOL_GPL(_mutex_lock_nest_lock);
@@ -640,7 +640,7 @@ mutex_lock_killable_nested(struct mutex *lock, unsigned int subclass)
 {
 	might_sleep();
 	return __mutex_lock_common(lock, TASK_KILLABLE,
-				   subclass, NULL, _RET_IP_, NULL, 0);
+				   subclass, NULL, _RET_IP_, NULL);
 }
 EXPORT_SYMBOL_GPL(mutex_lock_killable_nested);
 
@@ -649,7 +649,7 @@ mutex_lock_interruptible_nested(struct mutex *lock, unsigned int subclass)
 {
 	might_sleep();
 	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE,
-				   subclass, NULL, _RET_IP_, NULL, 0);
+				   subclass, NULL, _RET_IP_, NULL);
 }
 
 EXPORT_SYMBOL_GPL(mutex_lock_interruptible_nested);
@@ -687,7 +687,7 @@ __ww_mutex_lock(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
 
 	might_sleep();
 	ret =  __mutex_lock_common(&lock->base, TASK_UNINTERRUPTIBLE,
-				   0, &ctx->dep_map, _RET_IP_, ctx, 1);
+				   0, &ctx->dep_map, _RET_IP_, ctx);
 	if (!ret && ctx->acquired > 1)
 		return ww_mutex_deadlock_injection(lock, ctx);
 
@@ -702,7 +702,7 @@ __ww_mutex_lock_interruptible(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
 
 	might_sleep();
 	ret = __mutex_lock_common(&lock->base, TASK_INTERRUPTIBLE,
-				  0, &ctx->dep_map, _RET_IP_, ctx, 1);
+				  0, &ctx->dep_map, _RET_IP_, ctx);
 
 	if (!ret && ctx->acquired > 1)
 		return ww_mutex_deadlock_injection(lock, ctx);
@@ -822,28 +822,28 @@ __mutex_lock_slowpath(atomic_t *lock_count)
 	struct mutex *lock = container_of(lock_count, struct mutex, count);
 
 	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, 0,
-			    NULL, _RET_IP_, NULL, 0);
+			    NULL, _RET_IP_, NULL);
 }
 
 static noinline int __sched
 __mutex_lock_killable_slowpath(struct mutex *lock)
 {
 	return __mutex_lock_common(lock, TASK_KILLABLE, 0,
-				   NULL, _RET_IP_, NULL, 0);
+				   NULL, _RET_IP_, NULL);
 }
 
 static noinline int __sched
 __mutex_lock_interruptible_slowpath(struct mutex *lock)
 {
 	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE, 0,
-				   NULL, _RET_IP_, NULL, 0);
+				   NULL, _RET_IP_, NULL);
 }
 
 static noinline int __sched
 __ww_mutex_lock_slowpath(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
 {
 	return __mutex_lock_common(&lock->base, TASK_UNINTERRUPTIBLE, 0,
-				   NULL, _RET_IP_, ctx, 1);
+				   NULL, _RET_IP_, ctx);
 }
 
 static noinline int __sched
@@ -851,7 +851,7 @@ __ww_mutex_lock_interruptible_slowpath(struct ww_mutex *lock,
 					    struct ww_acquire_ctx *ctx)
 {
 	return __mutex_lock_common(&lock->base, TASK_INTERRUPTIBLE, 0,
-				   NULL, _RET_IP_, ctx, 1);
+				   NULL, _RET_IP_, ctx);
 }
 
 #endif
-- 
2.1.2

