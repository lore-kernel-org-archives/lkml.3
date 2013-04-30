Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933657Ab3D3UgA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 16:36:00 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:48765 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933034Ab3D3Uf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 16:35:58 -0400
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, peterz@infradead.org, x86@kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        robclark@gmail.com, rostedt@goodmis.org, daniel@ffwll.ch,
        tglx@linutronix.de, mingo@elte.hu, linux-media@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH] [RFC] mutex: w/w mutex slowpath debugging
Date: Tue, 30 Apr 2013 22:38:56 +0200
Message-Id: <1367354336-13719-1-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367350179.30667.70.camel@gandalf.local.home>
References: <1367350179.30667.70.camel@gandalf.local.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Injects EDEADLK conditions at pseudo-random interval, with exponential
backoff up to UINT_MAX (to ensure that every lock operation still
completes in a reasonable time).

This way we can test the wound slowpath even for ww mutex users where
contention is never expected, and the ww deadlock avoidance algorithm
is only needed for correctness against malicious userspace. An example
would be protecting kernel modesetting properties, which thanks to
single-threaded X isn't really expected to contend, ever.

I've looked into using the CONFIG_FAULT_INJECTION infrastructure, but
decided against it for two reasons:

- EDEADLK handling is mandatory for ww mutex users and should never
  affect the outcome of a syscall. This is in contrast to -ENOMEM
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
acquire the lock. This prevents any behaviour changes for users which
rely on the EALREADY semantics.

v2: Drop the cargo-culted __sched (I should read docs next time
around) and annotate the non-debug case with inline to prevent gcc
from doing something horrible.

Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 include/linux/mutex.h |    8 ++++++++
 kernel/mutex.c        |   32 ++++++++++++++++++++++++++++++++
 lib/Kconfig.debug     |   10 ++++++++++
 3 files changed, 50 insertions(+)

diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 004f863..82d56ec 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -93,6 +93,10 @@ struct ww_acquire_ctx {
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map dep_map;
 #endif
+#ifdef CONFIG_DEBUG_WW_MUTEX_SLOWPATH
+	unsigned deadlock_inject_interval;
+	unsigned deadlock_inject_countdown;
+#endif
 };
 
 struct ww_mutex {
@@ -278,6 +282,10 @@ static inline void ww_acquire_init(struct ww_acquire_ctx *ctx,
 			 &ww_class->acquire_key, 0);
 	mutex_acquire(&ctx->dep_map, 0, 0, _RET_IP_);
 #endif
+#ifdef CONFIG_DEBUG_WW_MUTEX_SLOWPATH
+	ctx->deadlock_inject_interval = ctx->stamp & 0xf;
+	ctx->deadlock_inject_countdown = ctx->deadlock_inject_interval;
+#endif
 }
 
 /**
diff --git a/kernel/mutex.c b/kernel/mutex.c
index 66807c7..816fdfc 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -827,6 +827,36 @@ int __sched mutex_trylock(struct mutex *lock)
 EXPORT_SYMBOL(mutex_trylock);
 
 #ifndef CONFIG_DEBUG_LOCK_ALLOC
+
+#ifdef CONFIG_DEBUG_WW_MUTEX_SLOWPATH
+static int
+ww_mutex_deadlock_injection(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
+{
+	if (ctx->deadlock_inject_countdown-- == 0) {
+		tmp = ctx->deadlock_inject_interval;
+		if (tmp > UINT_MAX/4)
+			tmp = UINT_MAX;
+		else
+			tmp = tmp*2 + tmp + tmp/2;
+
+		ctx->deadlock_inject_interval = tmp;
+		ctx->deadlock_inject_countdown = tmp;
+
+		ww_mutex_unlock(lock);
+
+		return -EDEADLK;
+	}
+
+	return 0;
+}
+#else
+static inline int
+ww_mutex_deadlock_injection(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
+{
+	return 0;
+}
+#endif
+
 int __sched
 ww_mutex_lock(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
 {
@@ -839,6 +869,7 @@ ww_mutex_lock(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
 	if (likely(!ret)) {
 		ww_mutex_set_context_fastpath(lock, ctx);
 		mutex_set_owner(&lock->base);
+		return ww_mutex_deadlock_injection(lock, ctx);
 	} else
 		ret = __ww_mutex_lock_slowpath(lock, ctx);
 	return ret;
@@ -857,6 +888,7 @@ ww_mutex_lock_interruptible(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
 	if (likely(!ret)) {
 		ww_mutex_set_context_fastpath(lock, ctx);
 		mutex_set_owner(&lock->base);
+		return ww_mutex_deadlock_injection(lock, ctx);
 	} else
 		ret = __ww_mutex_lock_interruptible_slowpath(lock, ctx);
 	return ret;
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 28be08c..8c41f73 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -547,6 +547,16 @@ config DEBUG_MUTEXES
 	 This feature allows mutex semantics violations to be detected and
 	 reported.
 
+config DEBUG_WW_MUTEX_SLOWPATH
+	bool "Wait/wound mutex debugging: Slowpath testing"
+	depends on DEBUG_KERNEL
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
-- 
1.7.10.4

