Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934481Ab3E1OtZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 10:49:25 -0400
Received: from adelie.canonical.com ([91.189.90.139]:46503 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934408Ab3E1OtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 10:49:22 -0400
Subject: [PATCH v4 4/4] mutex: w/w mutex slowpath debugging
To: linux-kernel@vger.kernel.org
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-arch@vger.kernel.org, peterz@infradead.org, x86@kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        robclark@gmail.com, rostedt@goodmis.org, daniel@ffwll.ch,
        tglx@linutronix.de, mingo@elte.hu, linux-media@vger.kernel.org
Date: Tue, 28 May 2013 16:48:51 +0200
Message-ID: <20130528144851.4538.75070.stgit@patser>
In-Reply-To: <20130528144420.4538.70725.stgit@patser>
References: <20130528144420.4538.70725.stgit@patser>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Vetter <daniel.vetter@ffwll.ch>

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

v3: Rebase on top of Maarten's latest patches.

v4: Actually make this stuff compile, I've misplace the hunk in the
wrong #ifdef block.

v5: Simplify ww_mutex_deadlock_injection definition, and fix
lib/locking-selftest.c warnings. Fix lib/Kconfig.debug definition
to work correctly. (mlankhorst)

v6:
Do not inject -EDEADLK when ctx->acquired == 0, because
the _slow paths are merged now. (mlankhorst)

Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---
 include/linux/mutex.h  |    8 ++++++++
 kernel/mutex.c         |   44 +++++++++++++++++++++++++++++++++++++++++---
 lib/Kconfig.debug      |   13 +++++++++++++
 lib/locking-selftest.c |    5 +++++
 4 files changed, 67 insertions(+), 3 deletions(-)

diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index f3ad181..2ff9178 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -95,6 +95,10 @@ struct ww_acquire_ctx {
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map dep_map;
 #endif
+#ifdef CONFIG_DEBUG_WW_MUTEX_SLOWPATH
+	unsigned deadlock_inject_interval;
+	unsigned deadlock_inject_countdown;
+#endif
 };
 
 struct ww_mutex {
@@ -280,6 +284,10 @@ static inline void ww_acquire_init(struct ww_acquire_ctx *ctx,
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
index 75fc7c4..e40004b 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -508,22 +508,60 @@ mutex_lock_interruptible_nested(struct mutex *lock, unsigned int subclass)
 
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
index 28be08c..06538ee 100644
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
diff --git a/lib/locking-selftest.c b/lib/locking-selftest.c
index b18f1d3..7f0bacc 100644
--- a/lib/locking-selftest.c
+++ b/lib/locking-selftest.c
@@ -199,7 +199,12 @@ static void init_shared_classes(void)
 #define RSU(x)			up_read(&rwsem_##x)
 #define RWSI(x)			init_rwsem(&rwsem_##x)
 
+#ifndef CONFIG_DEBUG_WW_MUTEX_SLOWPATH
 #define WWAI(x)			ww_acquire_init(x, &ww_lockdep)
+#else
+#define WWAI(x)			do { ww_acquire_init(x, &ww_lockdep); (x)->deadlock_inject_countdown = ~0U; } while (0)
+
+#endif
 #define WWAD(x)			ww_acquire_done(x)
 #define WWAF(x)			ww_acquire_fini(x)
 

