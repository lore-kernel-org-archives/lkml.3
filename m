Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474Ab3FZMGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 08:06:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55758 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab3FZMEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 08:04:37 -0400
Date: Wed, 26 Jun 2013 05:04:20 -0700
From: tip-bot for Daniel Vetter <tipbot@zytor.com>
Message-ID: <tip-230100276955529d5a7c69207421756b9a61a8e5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, tglx@linutronix.de, daniel.vetter@ffwll.ch,
        maarten.lankhorst@canonical.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, tglx@linutronix.de,
        maarten.lankhorst@canonical.com, daniel.vetter@ffwll.ch
In-Reply-To: <20130620113117.4001.21681.stgit@patser>
References: <20130620113117.4001.21681.stgit@patser>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/mutexes] mutex: Add w/w mutex slowpath debugging
Git-Commit-ID: 230100276955529d5a7c69207421756b9a61a8e5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 26 Jun 2013 05:04:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  230100276955529d5a7c69207421756b9a61a8e5
Gitweb:     http://git.kernel.org/tip/230100276955529d5a7c69207421756b9a61a8e5
Author:     Daniel Vetter <daniel.vetter@ffwll.ch>
AuthorDate: Thu, 20 Jun 2013 13:31:17 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 26 Jun 2013 12:10:56 +0200

mutex: Add w/w mutex slowpath debugging

Injects EDEADLK conditions at pseudo-random interval, with
exponential backoff up to UINT_MAX (to ensure that every lock
operation still completes in a reasonable time).

This way we can test the wound slowpath even for ww mutex users
where contention is never expected, and the ww deadlock
avoidance algorithm is only needed for correctness against
malicious userspace. An example would be protecting kernel
modesetting properties, which thanks to single-threaded X isn't
really expected to contend, ever.

I've looked into using the CONFIG_FAULT_INJECTION
infrastructure, but decided against it for two reasons:

- EDEADLK handling is mandatory for ww mutex users and should
  never affect the outcome of a syscall. This is in contrast to -ENOMEM
  injection. So fine configurability isn't required.

- The fault injection framework only allows to set a simple
  probability for failure. Now the probability that a ww mutex acquire
  stage with N locks will never complete (due to too many injected
  EDEADLK backoffs) is zero. But the expected number of ww_mutex_lock
  operations for the completely uncontended case would be O(exp(N)).
  The per-acuiqire ctx exponential backoff solution choosen here only
  results in O(log N) overhead due to injection and so O(log N * N)
  lock operations. This way we can fail with high probability (and so
  have good test coverage even for fancy backoff and lock acquisition
  paths) without running into patalogical cases.

Note that EDEADLK will only ever be injected when we managed to
acquire the lock. This prevents any behaviour changes for users
which rely on the EALREADY semantics.

Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: dri-devel@lists.freedesktop.org
Cc: linaro-mm-sig@lists.linaro.org
Cc: rostedt@goodmis.org
Cc: daniel@ffwll.ch
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/20130620113117.4001.21681.stgit@patser
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/mutex.h |  8 ++++++++
 kernel/mutex.c        | 44 +++++++++++++++++++++++++++++++++++++++++---
 lib/Kconfig.debug     | 13 +++++++++++++
 3 files changed, 62 insertions(+), 3 deletions(-)

diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index a56b0cc..3793ed7 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -98,6 +98,10 @@ struct ww_acquire_ctx {
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map dep_map;
 #endif
+#ifdef CONFIG_DEBUG_WW_MUTEX_SLOWPATH
+	unsigned deadlock_inject_interval;
+	unsigned deadlock_inject_countdown;
+#endif
 };
 
 struct ww_mutex {
@@ -283,6 +287,10 @@ static inline void ww_acquire_init(struct ww_acquire_ctx *ctx,
 			 &ww_class->acquire_key, 0);
 	mutex_acquire(&ctx->dep_map, 0, 0, _RET_IP_);
 #endif
+#ifdef CONFIG_DEBUG_WW_MUTEX_SLOWPATH
+	ctx->deadlock_inject_interval = 1;
+	ctx->deadlock_inject_countdown = ctx->stamp & 0xf;
+#endif
 }
 
 /**
diff --git a/kernel/mutex.c b/kernel/mutex.c
index fc801aa..e581ada 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -651,22 +651,60 @@ mutex_lock_interruptible_nested(struct mutex *lock, unsigned int subclass)
 
 EXPORT_SYMBOL_GPL(mutex_lock_interruptible_nested);
 
+static inline int
+ww_mutex_deadlock_injection(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
+{
+#ifdef CONFIG_DEBUG_WW_MUTEX_SLOWPATH
+	unsigned tmp;
+
+	if (ctx->deadlock_inject_countdown-- == 0) {
+		tmp = ctx->deadlock_inject_interval;
+		if (tmp > UINT_MAX/4)
+			tmp = UINT_MAX;
+		else
+			tmp = tmp*2 + tmp + tmp/2;
+
+		ctx->deadlock_inject_interval = tmp;
+		ctx->deadlock_inject_countdown = tmp;
+		ctx->contending_lock = lock;
+
+		ww_mutex_unlock(lock);
+
+		return -EDEADLK;
+	}
+#endif
+
+	return 0;
+}
 
 int __sched
 __ww_mutex_lock(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
 {
+	int ret;
+
 	might_sleep();
-	return __mutex_lock_common(&lock->base, TASK_UNINTERRUPTIBLE,
+	ret =  __mutex_lock_common(&lock->base, TASK_UNINTERRUPTIBLE,
 				   0, &ctx->dep_map, _RET_IP_, ctx);
+	if (!ret && ctx->acquired > 0)
+		return ww_mutex_deadlock_injection(lock, ctx);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(__ww_mutex_lock);
 
 int __sched
 __ww_mutex_lock_interruptible(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
 {
+	int ret;
+
 	might_sleep();
-	return __mutex_lock_common(&lock->base, TASK_INTERRUPTIBLE,
-				   0, &ctx->dep_map, _RET_IP_, ctx);
+	ret = __mutex_lock_common(&lock->base, TASK_INTERRUPTIBLE,
+				  0, &ctx->dep_map, _RET_IP_, ctx);
+
+	if (!ret && ctx->acquired > 0)
+		return ww_mutex_deadlock_injection(lock, ctx);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(__ww_mutex_lock_interruptible);
 
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 566cf2b..7154f79 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -547,6 +547,19 @@ config DEBUG_MUTEXES
 	 This feature allows mutex semantics violations to be detected and
 	 reported.
 
+config DEBUG_WW_MUTEX_SLOWPATH
+	bool "Wait/wound mutex debugging: Slowpath testing"
+	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
+	select DEBUG_LOCK_ALLOC
+	select DEBUG_SPINLOCK
+	select DEBUG_MUTEXES
+	help
+	 This feature enables slowpath testing for w/w mutex users by
+	 injecting additional -EDEADLK wound/backoff cases. Together with
+	 the full mutex checks enabled with (CONFIG_PROVE_LOCKING) this
+	 will test all possible w/w mutex interface abuse with the
+	 exception of simply not acquiring all the required locks.
+
 config DEBUG_LOCK_ALLOC
 	bool "Lock debugging: detect incorrect freeing of live locks"
 	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
