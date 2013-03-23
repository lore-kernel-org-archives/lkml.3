Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423269Ab3CWBcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 21:32:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:10220 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422816Ab3CWBZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 21:25:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,896,1355126400"; 
   d="scan'208";a="307217453"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 23/29] x86, tsx: Add generic per-lock adaptive lock elision support
Date: Fri, 22 Mar 2013 18:25:17 -0700
Message-Id: <1364001923-10796-24-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
References: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Extend the elide() macro to support adaptation state per lock.
The adaptation keeps track whether the elision is successfull.
When the lock aborts due to internal reasons (e.g. it always
writes a MSR or always does MMIO) disable elision for some time.

The state is kept as a "short" count in the lock. This can
be then in the elision wrapper.

This just adds the infrastructure, will be actually used
in followon patches.

We use a per cpu variant of module params as statistic counters for now.
This could be moved elsewhere in sysfs too, but it would be far
more code.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/elide.h |   83 +++++++++++++++++++++++++++++++++++
 arch/x86/kernel/rtm-locks.c  |   99 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 182 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/elide.h b/arch/x86/include/asm/elide.h
index c492aed..d102bb6 100644
--- a/arch/x86/include/asm/elide.h
+++ b/arch/x86/include/asm/elide.h
@@ -4,12 +4,52 @@
 #ifdef CONFIG_RTM_LOCKS
 #include <asm/rtm.h>
 
+struct elision_config {
+	short internal_abort_skip;
+	short lock_busy_skip;
+	short other_abort_skip;
+	short conflict_abort_skip;
+	int conflict_retry;
+	int retry_timeout;
+	int lock_busy_retry;
+};
+
+/* Tuning preliminary */
+#define DEFAULT_ELISION_CONFIG {	\
+	.internal_abort_skip = 5,	\
+	.lock_busy_skip = 3,		\
+	.other_abort_skip = 3,		\
+	.conflict_abort_skip = 3,	\
+	.conflict_retry = 3,		\
+	.retry_timeout = 500,		\
+	.lock_busy_retry = 3,		\
+}
+
+#define TUNE_ELISION_CONFIG(prefix, name)				\
+	module_param_named(prefix ## _internal_abort_skip,		\
+			   name.internal_abort_skip, short, 0644);	\
+	module_param_named(prefix ## _lock_busy_skip,			\
+			   name.lock_busy_skip, short, 0644);		\
+	module_param_named(prefix ## _other_abort_skip,			\
+			   name.other_abort_skip, short, 0644);		\
+	module_param_named(prefix ## _conflict_abort_skip,		\
+			   name.conflict_abort_skip, short, 0644);	\
+	module_param_named(prefix ## _conflict_retry,			\
+			   name.conflict_retry, int, 0644);		\
+	module_param_named(prefix ## _retry_timeout,			\
+			   name.retry_timeout, int, 0644);		\
+	module_param_named(prefix ## _lock_busy_retry,			\
+			   name.lock_busy_retry, int, 0644)
+
+
 /*
  * These are out of line unfortunately, just to avoid
  * a nasty include loop with per cpu data.
  * (FIXME)
  */
 extern int __elide_lock(void);
+extern int __elide_lock_adapt(short *adapt, struct elision_config *config,
+			      int *retry);
 extern void __elide_unlock(void);
 
 /*
@@ -33,6 +73,49 @@ extern void __elide_unlock(void);
 	flag;				\
 })
 
+enum { ELIDE_TXN, ELIDE_STOP, ELIDE_RETRY };
+
+/*
+ * Adaptive elision lock wrapper
+ *
+ * Like above. a is a pointer to a
+ * short adaption count stored in the lock.
+ * config is a pointer to a elision_config for the lock type
+ *
+ * This is a bit convulted because we need a retry loop with a lock test
+ * to wait for the lock freeing again. Right now we just spin up to
+ * a defined number of iterations.
+ *
+ * Ideally every lock that can afford to have a 16 bit count stored
+ * in it should use this variant.
+ */
+#define elide_lock_adapt(f, l, a, config) ({			\
+	int flag = 0;						\
+	if (static_key_true(&(f))) {				\
+		int retry = (config)->conflict_retry;		\
+		int timeout = (config)->retry_timeout;		\
+		int status;					\
+		again:						\
+		status = __elide_lock_adapt(a, config, &retry); \
+		/* Retries wait until the lock is free. */	\
+		if (unlikely(status == ELIDE_RETRY)) {		\
+			while (!(l) && --timeout > 0)		\
+				cpu_relax();			\
+			if (timeout > 0)			\
+				goto again;			\
+		}						\
+		if (likely(status != ELIDE_STOP)) {		\
+			/* in transaction. check now if the lock is free. */ \
+			if (likely(l))				\
+				flag = 1;			\
+			else					\
+				_xabort(0xff);			\
+		}						\
+	}							\
+	flag;							\
+})
+
+
 /*
  * Note that if you see a general protection fault
  * in the _xend you have a unmatched unlock. Please fix
diff --git a/arch/x86/kernel/rtm-locks.c b/arch/x86/kernel/rtm-locks.c
index 1811028..8d4763d 100644
--- a/arch/x86/kernel/rtm-locks.c
+++ b/arch/x86/kernel/rtm-locks.c
@@ -36,6 +36,9 @@
 #include <asm/rtm.h>
 #include <asm/paravirt.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/elision.h>
+
 /*
  * We need a software in_tx marker, to answer the question
  * "Is this an inner nested transaction commit?" inside the transaction.
@@ -265,6 +268,97 @@ inline int __elide_lock(void)
 }
 EXPORT_SYMBOL(__elide_lock);
 
+/* XXX make per lock type */
+static DEFINE_PER_CPU(unsigned, lock_el_skip);
+static DEFINE_PER_CPU(unsigned, lock_el_start_skip);
+
+/*
+ * Implement a simple adaptive algorithm. When the lock aborts
+ * for an internal (not external) cause we stop eliding for some time.
+ * For a conflict we retry a defined number of times, then also skip.
+ * For other aborts we also skip. All the skip counts are individually
+ * configurable.
+ *
+ * The retry loop is in the caller, as it needs to wait for the lock
+ * to free itself first. Otherwise we would cycle too fast through
+ * the retries.
+ *
+ * The complex logic is generally in the slow path, when we would
+ * have blocked anyways.
+ */
+
+static inline void skip_update(short *count, short skip, unsigned status)
+{
+	__this_cpu_inc(lock_el_start_skip);
+	/* Can lose updates, but that is ok as this is just a hint. */
+	if (*count != skip) {
+		trace_elision_skip_start(count, status);
+		*count = skip;
+	}
+}
+
+static int
+__elide_lock_adapt_slow(short *count, struct elision_config *config,
+			int *retry, unsigned status)
+{
+	/* Internal abort? Adapt the mutex */
+	if (!(status & _XABORT_RETRY)) {
+		/* Lock busy is a special case */
+		if ((status & _XABORT_EXPLICIT) &&
+		    _XABORT_CODE(status) == 0xff) {
+			/* Do some retries on lock busy. */
+			if (*retry > 0) {
+				if (*retry == config->conflict_retry &&
+				    config->lock_busy_retry <
+				    config->conflict_retry)
+					*retry = config->lock_busy_retry;
+				(*retry)--;
+				return ELIDE_RETRY;
+			}
+			skip_update(count, config->lock_busy_skip, status);
+		} else
+			skip_update(count, config->internal_abort_skip, status);
+		return ELIDE_STOP;
+	}
+	if (!(status & _XABORT_CONFLICT)) {
+		/* No retries for capacity. Maybe later. */
+		skip_update(count, config->other_abort_skip, status);
+		return ELIDE_STOP;
+	}
+	/* Was a conflict. Do some retries. */
+	if (*retry > 0) {
+		/* In caller wait for lock becoming free and then retry. */
+		(*retry)--;
+		return ELIDE_RETRY;
+	}
+
+	skip_update(count, config->conflict_abort_skip, status);
+	return ELIDE_STOP;
+}
+
+inline int __elide_lock_adapt(short *count, struct elision_config *config,
+			      int *retry)
+{
+	unsigned status;
+
+	if (unlikely(txn_disabled()))
+		return ELIDE_STOP;
+	/* Adapted lock? */
+	if (unlikely(*count > 0)) {
+		/* Can lose updates, but that is ok as this is just a hint. */
+		(*count)--;
+		/* TBD should count this per lock type and per lock */
+		__this_cpu_inc(lock_el_skip);
+		return ELIDE_STOP;
+	}
+	if (likely((status = _xbegin()) == _XBEGIN_STARTED)) {
+		start_in_tx();
+		return ELIDE_TXN;
+	}
+	return __elide_lock_adapt_slow(count, config, retry, status);
+}
+EXPORT_SYMBOL(__elide_lock_adapt);
+
 inline void __elide_unlock(void)
 {
 	/*
@@ -354,3 +448,8 @@ module_param(mutex_elision, bool, 0644);
 
 __read_mostly bool rwsem_elision = true;
 module_param(rwsem_elision, bool, 0644);
+
+module_param_cb(lock_el_skip, &param_ops_percpu_uint, &lock_el_skip,
+		0644);
+module_param_cb(lock_el_start_skip, &param_ops_percpu_uint,
+		&lock_el_start_skip, 0644);
-- 
1.7.7.6

