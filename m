Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829Ab3JTTbz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 15:31:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52615 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab3JTTbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 15:31:52 -0400
Date: Sun, 20 Oct 2013 12:31:31 -0700
From: tip-bot for Tetsuo Handa <tipbot@zytor.com>
Message-ID: <tip-b0267507dfd0187fb7840a0ec461a510a7f041c5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        penguin-kernel@I-love.SAKURA.ne.jp, akpm@linux-foundation.org,
        tglx@linutronix.de, maarten.lankhorst@canonical.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        penguin-kernel@I-love.SAKURA.ne.jp, akpm@linux-foundation.org,
        tglx@linutronix.de, maarten.lankhorst@canonical.com
In-Reply-To: <201310171945.AGB17114.FSQVtHOJFOOFML@I-love.SAKURA.ne.jp>
References: <201310171945.AGB17114.FSQVtHOJFOOFML@I-love.SAKURA.ne.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] mutex:
  Avoid gcc version dependent __builtin_constant_p() usage
Git-Commit-ID: b0267507dfd0187fb7840a0ec461a510a7f041c5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 20 Oct 2013 12:31:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b0267507dfd0187fb7840a0ec461a510a7f041c5
Gitweb:     http://git.kernel.org/tip/b0267507dfd0187fb7840a0ec461a510a7f041c5
Author:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
AuthorDate: Thu, 17 Oct 2013 19:45:29 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 Oct 2013 21:58:54 +0200

mutex: Avoid gcc version dependent __builtin_constant_p() usage

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
---
 kernel/mutex.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/kernel/mutex.c b/kernel/mutex.c
index 6d647ae..d24105b 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -410,7 +410,7 @@ ww_mutex_set_context_fastpath(struct ww_mutex *lock,
 static __always_inline int __sched
 __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		    struct lockdep_map *nest_lock, unsigned long ip,
-		    struct ww_acquire_ctx *ww_ctx)
+		    struct ww_acquire_ctx *ww_ctx, const bool use_ww_ctx)
 {
 	struct task_struct *task = current;
 	struct mutex_waiter waiter;
@@ -450,7 +450,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		struct task_struct *owner;
 		struct mspin_node  node;
 
-		if (!__builtin_constant_p(ww_ctx == NULL) && ww_ctx->acquired > 0) {
+		if (use_ww_ctx && ww_ctx->acquired > 0) {
 			struct ww_mutex *ww;
 
 			ww = container_of(lock, struct ww_mutex, base);
@@ -480,7 +480,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		if ((atomic_read(&lock->count) == 1) &&
 		    (atomic_cmpxchg(&lock->count, 1, 0) == 1)) {
 			lock_acquired(&lock->dep_map, ip);
-			if (!__builtin_constant_p(ww_ctx == NULL)) {
+			if (use_ww_ctx) {
 				struct ww_mutex *ww;
 				ww = container_of(lock, struct ww_mutex, base);
 
@@ -551,7 +551,7 @@ slowpath:
 			goto err;
 		}
 
-		if (!__builtin_constant_p(ww_ctx == NULL) && ww_ctx->acquired > 0) {
+		if (use_ww_ctx && ww_ctx->acquired > 0) {
 			ret = __mutex_lock_check_stamp(lock, ww_ctx);
 			if (ret)
 				goto err;
@@ -575,7 +575,7 @@ skip_wait:
 	lock_acquired(&lock->dep_map, ip);
 	mutex_set_owner(lock);
 
-	if (!__builtin_constant_p(ww_ctx == NULL)) {
+	if (use_ww_ctx) {
 		struct ww_mutex *ww = container_of(lock, struct ww_mutex, base);
 		struct mutex_waiter *cur;
 
@@ -615,7 +615,7 @@ mutex_lock_nested(struct mutex *lock, unsigned int subclass)
 {
 	might_sleep();
 	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE,
-			    subclass, NULL, _RET_IP_, NULL);
+			    subclass, NULL, _RET_IP_, NULL, 0);
 }
 
 EXPORT_SYMBOL_GPL(mutex_lock_nested);
@@ -625,7 +625,7 @@ _mutex_lock_nest_lock(struct mutex *lock, struct lockdep_map *nest)
 {
 	might_sleep();
 	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE,
-			    0, nest, _RET_IP_, NULL);
+			    0, nest, _RET_IP_, NULL, 0);
 }
 
 EXPORT_SYMBOL_GPL(_mutex_lock_nest_lock);
@@ -635,7 +635,7 @@ mutex_lock_killable_nested(struct mutex *lock, unsigned int subclass)
 {
 	might_sleep();
 	return __mutex_lock_common(lock, TASK_KILLABLE,
-				   subclass, NULL, _RET_IP_, NULL);
+				   subclass, NULL, _RET_IP_, NULL, 0);
 }
 EXPORT_SYMBOL_GPL(mutex_lock_killable_nested);
 
@@ -644,7 +644,7 @@ mutex_lock_interruptible_nested(struct mutex *lock, unsigned int subclass)
 {
 	might_sleep();
 	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE,
-				   subclass, NULL, _RET_IP_, NULL);
+				   subclass, NULL, _RET_IP_, NULL, 0);
 }
 
 EXPORT_SYMBOL_GPL(mutex_lock_interruptible_nested);
@@ -682,7 +682,7 @@ __ww_mutex_lock(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
 
 	might_sleep();
 	ret =  __mutex_lock_common(&lock->base, TASK_UNINTERRUPTIBLE,
-				   0, &ctx->dep_map, _RET_IP_, ctx);
+				   0, &ctx->dep_map, _RET_IP_, ctx, 1);
 	if (!ret && ctx->acquired > 1)
 		return ww_mutex_deadlock_injection(lock, ctx);
 
@@ -697,7 +697,7 @@ __ww_mutex_lock_interruptible(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
 
 	might_sleep();
 	ret = __mutex_lock_common(&lock->base, TASK_INTERRUPTIBLE,
-				  0, &ctx->dep_map, _RET_IP_, ctx);
+				  0, &ctx->dep_map, _RET_IP_, ctx, 1);
 
 	if (!ret && ctx->acquired > 1)
 		return ww_mutex_deadlock_injection(lock, ctx);
@@ -809,28 +809,28 @@ __mutex_lock_slowpath(atomic_t *lock_count)
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
@@ -838,7 +838,7 @@ __ww_mutex_lock_interruptible_slowpath(struct ww_mutex *lock,
 					    struct ww_acquire_ctx *ctx)
 {
 	return __mutex_lock_common(&lock->base, TASK_INTERRUPTIBLE, 0,
-				   NULL, _RET_IP_, ctx);
+				   NULL, _RET_IP_, ctx, 1);
 }
 
 #endif
