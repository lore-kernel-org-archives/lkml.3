Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758815Ab3KIG5d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 01:57:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33593 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758620Ab3KIGw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:52:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, peterz@infradead.org,
        imirkin@alum.mit.edu, daniel.vetter@ffwll.ch, robdclark@gmail.com
Subject: [PATCH 3.11 89/94] mutex: Avoid gcc version dependent __builtin_constant_p() usage
Date: Fri,  8 Nov 2013 22:52:35 -0800
Message-Id: <20131109065210.539422941@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065204.252462489@linuxfoundation.org>
References: <20131109065204.252462489@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit b0267507dfd0187fb7840a0ec461a510a7f041c5 upstream.

Commit 040a0a37 ("mutex: Add support for wound/wait style locks")
used "!__builtin_constant_p(p == NULL)" but gcc 3.x cannot
handle such expression correctly, leading to boot failure when
built with CONFIG_DEBUG_MUTEXES=y.

Fix it by explicitly passing a bool which tells whether p != NULL
or not.

[ PeterZ: This is a sad patch, but provided it actually generates
          similar code I suppose its the best we can do bar whole
	  sale deprecating gcc-3. ]

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: peterz@infradead.org
Cc: imirkin@alum.mit.edu
Cc: daniel.vetter@ffwll.ch
Cc: robdclark@gmail.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/201310171945.AGB17114.FSQVtHOJFOOFML@I-love.SAKURA.ne.jp
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/mutex.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -408,7 +408,7 @@ ww_mutex_set_context_fastpath(struct ww_
 static __always_inline int __sched
 __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		    struct lockdep_map *nest_lock, unsigned long ip,
-		    struct ww_acquire_ctx *ww_ctx)
+		    struct ww_acquire_ctx *ww_ctx, const bool use_ww_ctx)
 {
 	struct task_struct *task = current;
 	struct mutex_waiter waiter;
@@ -448,7 +448,7 @@ __mutex_lock_common(struct mutex *lock,
 		struct task_struct *owner;
 		struct mspin_node  node;
 
-		if (!__builtin_constant_p(ww_ctx == NULL) && ww_ctx->acquired > 0) {
+		if (use_ww_ctx && ww_ctx->acquired > 0) {
 			struct ww_mutex *ww;
 
 			ww = container_of(lock, struct ww_mutex, base);
@@ -478,7 +478,7 @@ __mutex_lock_common(struct mutex *lock,
 		if ((atomic_read(&lock->count) == 1) &&
 		    (atomic_cmpxchg(&lock->count, 1, 0) == 1)) {
 			lock_acquired(&lock->dep_map, ip);
-			if (!__builtin_constant_p(ww_ctx == NULL)) {
+			if (use_ww_ctx) {
 				struct ww_mutex *ww;
 				ww = container_of(lock, struct ww_mutex, base);
 
@@ -548,7 +548,7 @@ slowpath:
 			goto err;
 		}
 
-		if (!__builtin_constant_p(ww_ctx == NULL) && ww_ctx->acquired > 0) {
+		if (use_ww_ctx && ww_ctx->acquired > 0) {
 			ret = __mutex_lock_check_stamp(lock, ww_ctx);
 			if (ret)
 				goto err;
@@ -568,7 +568,7 @@ done:
 	mutex_remove_waiter(lock, &waiter, current_thread_info());
 	mutex_set_owner(lock);
 
-	if (!__builtin_constant_p(ww_ctx == NULL)) {
+	if (use_ww_ctx) {
 		struct ww_mutex *ww = container_of(lock,
 						      struct ww_mutex,
 						      base);
@@ -618,7 +618,7 @@ mutex_lock_nested(struct mutex *lock, un
 {
 	might_sleep();
 	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE,
-			    subclass, NULL, _RET_IP_, NULL);
+			    subclass, NULL, _RET_IP_, NULL, 0);
 }
 
 EXPORT_SYMBOL_GPL(mutex_lock_nested);
@@ -628,7 +628,7 @@ _mutex_lock_nest_lock(struct mutex *lock
 {
 	might_sleep();
 	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE,
-			    0, nest, _RET_IP_, NULL);
+			    0, nest, _RET_IP_, NULL, 0);
 }
 
 EXPORT_SYMBOL_GPL(_mutex_lock_nest_lock);
@@ -638,7 +638,7 @@ mutex_lock_killable_nested(struct mutex
 {
 	might_sleep();
 	return __mutex_lock_common(lock, TASK_KILLABLE,
-				   subclass, NULL, _RET_IP_, NULL);
+				   subclass, NULL, _RET_IP_, NULL, 0);
 }
 EXPORT_SYMBOL_GPL(mutex_lock_killable_nested);
 
@@ -647,7 +647,7 @@ mutex_lock_interruptible_nested(struct m
 {
 	might_sleep();
 	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE,
-				   subclass, NULL, _RET_IP_, NULL);
+				   subclass, NULL, _RET_IP_, NULL, 0);
 }
 
 EXPORT_SYMBOL_GPL(mutex_lock_interruptible_nested);
@@ -685,7 +685,7 @@ __ww_mutex_lock(struct ww_mutex *lock, s
 
 	might_sleep();
 	ret =  __mutex_lock_common(&lock->base, TASK_UNINTERRUPTIBLE,
-				   0, &ctx->dep_map, _RET_IP_, ctx);
+				   0, &ctx->dep_map, _RET_IP_, ctx, 1);
 	if (!ret && ctx->acquired > 1)
 		return ww_mutex_deadlock_injection(lock, ctx);
 
@@ -700,7 +700,7 @@ __ww_mutex_lock_interruptible(struct ww_
 
 	might_sleep();
 	ret = __mutex_lock_common(&lock->base, TASK_INTERRUPTIBLE,
-				  0, &ctx->dep_map, _RET_IP_, ctx);
+				  0, &ctx->dep_map, _RET_IP_, ctx, 1);
 
 	if (!ret && ctx->acquired > 1)
 		return ww_mutex_deadlock_injection(lock, ctx);
@@ -812,28 +812,28 @@ __mutex_lock_slowpath(atomic_t *lock_cou
 	struct mutex *lock = container_of(lock_count, struct mutex, count);
 
 	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, 0,
-			    NULL, _RET_IP_, NULL);
+			    NULL, _RET_IP_, NULL, 0);
 }
 
 static noinline int __sched
 __mutex_lock_killable_slowpath(struct mutex *lock)
 {
 	return __mutex_lock_common(lock, TASK_KILLABLE, 0,
-				   NULL, _RET_IP_, NULL);
+				   NULL, _RET_IP_, NULL, 0);
 }
 
 static noinline int __sched
 __mutex_lock_interruptible_slowpath(struct mutex *lock)
 {
 	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE, 0,
-				   NULL, _RET_IP_, NULL);
+				   NULL, _RET_IP_, NULL, 0);
 }
 
 static noinline int __sched
 __ww_mutex_lock_slowpath(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
 {
 	return __mutex_lock_common(&lock->base, TASK_UNINTERRUPTIBLE, 0,
-				   NULL, _RET_IP_, ctx);
+				   NULL, _RET_IP_, ctx, 1);
 }
 
 static noinline int __sched
@@ -841,7 +841,7 @@ __ww_mutex_lock_interruptible_slowpath(s
 					    struct ww_acquire_ctx *ctx)
 {
 	return __mutex_lock_common(&lock->base, TASK_INTERRUPTIBLE, 0,
-				   NULL, _RET_IP_, ctx);
+				   NULL, _RET_IP_, ctx, 1);
 }
 
 #endif


