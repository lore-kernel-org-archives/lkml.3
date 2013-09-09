Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab3IIL5Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 07:57:16 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:56213 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab3IIL5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 07:57:15 -0400
X-Nat-Received: from [202.181.97.72]:63730 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1378727814.32016
To: maarten.lankhorst@canonical.com
Cc: imirkin@alum.mit.edu, linux-kernel@vger.kernel.org, daniel.vetter@ffwll.ch,
        robdclark@gmail.com, a.p.zijlstra@chello.nl, mingo@kernel.org
Subject: Re: [3.11-rc1] CONFIG_DEBUG_MUTEXES=y using gcc 3.x makes unbootablekernel.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <CAKb7UvjH1XZ3f-c=149s5=rqxkxVUhG_7-cfUYH3zrwJwr2_MQ@mail.gmail.com>
	<201309081624.EBJ90176.OJStQOFLHVFFOM@I-love.SAKURA.ne.jp>
	<522C312A.7050705@canonical.com>
	<201309082053.FDB24195.FVOOJMStFQFLHO@I-love.SAKURA.ne.jp>
	<522CDFC8.9020903@canonical.com>
In-Reply-To: <522CDFC8.9020903@canonical.com>
Message-Id: <201309092056.GDH56750.OOMJtOHQVFFLSF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 9 Sep 2013 20:56:53 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 09092013 #11001181, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maarten Lankhorst wrote:
> Almost correct. I meant passing it as parameter to __mutex_lock_common. Your version will still cause an extra pointless null check in the ww_mutex_lock case.

Ah, I see.
----------
>From 95f189eb37c25ddf8e48d5dfc2f9f1185c52b6a8 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Mon, 9 Sep 2013 20:48:13 +0900
Subject: [PATCH] mutex: Avoid gcc version dependent __builtin_constant_p() usage.

Commit 040a0a37 "mutex: Add support for wound/wait style locks" used
"!__builtin_constant_p(p == NULL)" but gcc 3.x cannot handle such expression
correctly, leading to boot failure when built with CONFIG_DEBUG_MUTEXES=y.

Fix it by explicitly passing a bool which tells whether p != NULL or not.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: <stable@kernel.org> [3.11+]
---
 kernel/mutex.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/kernel/mutex.c b/kernel/mutex.c
index a52ee7bb..a2b80f1 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -408,7 +408,7 @@ ww_mutex_set_context_fastpath(struct ww_mutex *lock,
 static __always_inline int __sched
 __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		    struct lockdep_map *nest_lock, unsigned long ip,
-		    struct ww_acquire_ctx *ww_ctx)
+		    struct ww_acquire_ctx *ww_ctx, const bool use_ww_ctx)
 {
 	struct task_struct *task = current;
 	struct mutex_waiter waiter;
@@ -448,7 +448,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		struct task_struct *owner;
 		struct mspin_node  node;
 
-		if (!__builtin_constant_p(ww_ctx == NULL) && ww_ctx->acquired > 0) {
+		if (use_ww_ctx && ww_ctx->acquired > 0) {
 			struct ww_mutex *ww;
 
 			ww = container_of(lock, struct ww_mutex, base);
@@ -478,7 +478,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
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
@@ -618,7 +618,7 @@ mutex_lock_nested(struct mutex *lock, unsigned int subclass)
 {
 	might_sleep();
 	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE,
-			    subclass, NULL, _RET_IP_, NULL);
+			    subclass, NULL, _RET_IP_, NULL, 0);
 }
 
 EXPORT_SYMBOL_GPL(mutex_lock_nested);
@@ -628,7 +628,7 @@ _mutex_lock_nest_lock(struct mutex *lock, struct lockdep_map *nest)
 {
 	might_sleep();
 	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE,
-			    0, nest, _RET_IP_, NULL);
+			    0, nest, _RET_IP_, NULL, 0);
 }
 
 EXPORT_SYMBOL_GPL(_mutex_lock_nest_lock);
@@ -638,7 +638,7 @@ mutex_lock_killable_nested(struct mutex *lock, unsigned int subclass)
 {
 	might_sleep();
 	return __mutex_lock_common(lock, TASK_KILLABLE,
-				   subclass, NULL, _RET_IP_, NULL);
+				   subclass, NULL, _RET_IP_, NULL, 0);
 }
 EXPORT_SYMBOL_GPL(mutex_lock_killable_nested);
 
@@ -647,7 +647,7 @@ mutex_lock_interruptible_nested(struct mutex *lock, unsigned int subclass)
 {
 	might_sleep();
 	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE,
-				   subclass, NULL, _RET_IP_, NULL);
+				   subclass, NULL, _RET_IP_, NULL, 0);
 }
 
 EXPORT_SYMBOL_GPL(mutex_lock_interruptible_nested);
@@ -685,7 +685,7 @@ __ww_mutex_lock(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
 
 	might_sleep();
 	ret =  __mutex_lock_common(&lock->base, TASK_UNINTERRUPTIBLE,
-				   0, &ctx->dep_map, _RET_IP_, ctx);
+				   0, &ctx->dep_map, _RET_IP_, ctx, 1);
 	if (!ret && ctx->acquired > 1)
 		return ww_mutex_deadlock_injection(lock, ctx);
 
@@ -700,7 +700,7 @@ __ww_mutex_lock_interruptible(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
 
 	might_sleep();
 	ret = __mutex_lock_common(&lock->base, TASK_INTERRUPTIBLE,
-				  0, &ctx->dep_map, _RET_IP_, ctx);
+				  0, &ctx->dep_map, _RET_IP_, ctx, 1);
 
 	if (!ret && ctx->acquired > 1)
 		return ww_mutex_deadlock_injection(lock, ctx);
@@ -812,28 +812,28 @@ __mutex_lock_slowpath(atomic_t *lock_count)
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
@@ -841,7 +841,7 @@ __ww_mutex_lock_interruptible_slowpath(struct ww_mutex *lock,
 					    struct ww_acquire_ctx *ctx)
 {
 	return __mutex_lock_common(&lock->base, TASK_INTERRUPTIBLE, 0,
-				   NULL, _RET_IP_, ctx);
+				   NULL, _RET_IP_, ctx, 1);
 }
 
 #endif
-- 
1.7.8
