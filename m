Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344Ab3IHLxk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 07:53:40 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:60790 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab3IHLxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 07:53:38 -0400
X-Nat-Received: from [202.181.97.72]:54935 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1378641201.18679
To: maarten.lankhorst@canonical.com
Cc: imirkin@alum.mit.edu, linux-kernel@vger.kernel.org, daniel.vetter@ffwll.ch,
        robdclark@gmail.com, a.p.zijlstra@chello.nl, mingo@kernel.org
Subject: Re: [3.11-rc1] CONFIG_DEBUG_MUTEXES=y using gcc 3.x makes unbootablekernel.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201309080100.FFE90102.FFOVOtJQOFHSLM@I-love.SAKURA.ne.jp>
	<201309081332.FEJ52163.FHJOMQVOFOLStF@I-love.SAKURA.ne.jp>
	<CAKb7UvjH1XZ3f-c=149s5=rqxkxVUhG_7-cfUYH3zrwJwr2_MQ@mail.gmail.com>
	<201309081624.EBJ90176.OJStQOFLHVFFOM@I-love.SAKURA.ne.jp>
	<522C312A.7050705@canonical.com>
In-Reply-To: <522C312A.7050705@canonical.com>
Message-Id: <201309082053.FDB24195.FVOOJMStFQFLHO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sun, 8 Sep 2013 20:53:18 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 08092013 #10996972, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Maarten Lankhorst wrote:
> if it's broken for your compiler, please add a bool use_ww_ctx or something to __mutex_lock_common that's set directly instead, the __builtin_constant_p trick
> might be too gcc version specific.

I see. I tested that both gcc 3.x and gcc 4.x can generate bootable kernel
using below fix.
----------
>From f71fb89bccaa7ed5b3a14e735a1b9cc1a0e7112d Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Sun, 8 Sep 2013 20:37:19 +0900
Subject: [PATCH] mutex: Avoid gcc version dependent __builtin_constant_p()
 usage.

Commit 040a0a37 "mutex: Add support for wound/wait style locks" used
"!__builtin_constant_p(p == NULL)" but gcc 3.x cannot handle such expression
correctly, leading to boot failure when built with CONFIG_DEBUG_MUTEXES=y.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: <stable@kernel.org> [3.11+]
---
 kernel/mutex.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/mutex.c b/kernel/mutex.c
index a52ee7bb..2e7984e 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -414,6 +414,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	struct mutex_waiter waiter;
 	unsigned long flags;
 	int ret;
+	const bool use_ww_ctx = !!ww_ctx;
 
 	preempt_disable();
 	mutex_acquire_nest(&lock->dep_map, subclass, 0, nest_lock, ip);
@@ -448,7 +449,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		struct task_struct *owner;
 		struct mspin_node  node;
 
-		if (!__builtin_constant_p(ww_ctx == NULL) && ww_ctx->acquired > 0) {
+		if (use_ww_ctx && ww_ctx->acquired > 0) {
 			struct ww_mutex *ww;
 
 			ww = container_of(lock, struct ww_mutex, base);
@@ -478,7 +479,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		if ((atomic_read(&lock->count) == 1) &&
 		    (atomic_cmpxchg(&lock->count, 1, 0) == 1)) {
 			lock_acquired(&lock->dep_map, ip);
-			if (!__builtin_constant_p(ww_ctx == NULL)) {
+			if (use_ww_ctx) {
 				struct ww_mutex *ww;
 				ww = container_of(lock, struct ww_mutex, base);
 
@@ -548,7 +549,7 @@ slowpath:
 			goto err;
 		}
 
-		if (!__builtin_constant_p(ww_ctx == NULL) && ww_ctx->acquired > 0) {
+		if (use_ww_ctx && ww_ctx->acquired > 0) {
 			ret = __mutex_lock_check_stamp(lock, ww_ctx);
 			if (ret)
 				goto err;
@@ -568,7 +569,7 @@ done:
 	mutex_remove_waiter(lock, &waiter, current_thread_info());
 	mutex_set_owner(lock);
 
-	if (!__builtin_constant_p(ww_ctx == NULL)) {
+	if (use_ww_ctx) {
 		struct ww_mutex *ww = container_of(lock,
 						      struct ww_mutex,
 						      base);
-- 
1.7.8

