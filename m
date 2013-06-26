Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab3FZMEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 08:04:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55772 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab3FZMEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 08:04:47 -0400
Date: Wed, 26 Jun 2013 05:04:30 -0700
From: tip-bot for Maarten Lankhorst <tipbot@zytor.com>
Message-ID: <tip-1de994452f44005e4b1f5c6c77eae4a26f86d484@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, tglx@linutronix.de,
        maarten.lankhorst@canonical.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, tglx@linutronix.de,
        maarten.lankhorst@canonical.com
In-Reply-To: <20130620113124.4001.23186.stgit@patser>
References: <20130620113124.4001.23186.stgit@patser>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/mutexes] mutex: Add w/w tests to lib/locking-selftest.c
Git-Commit-ID: 1de994452f44005e4b1f5c6c77eae4a26f86d484
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 26 Jun 2013 05:04:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1de994452f44005e4b1f5c6c77eae4a26f86d484
Gitweb:     http://git.kernel.org/tip/1de994452f44005e4b1f5c6c77eae4a26f86d484
Author:     Maarten Lankhorst <maarten.lankhorst@canonical.com>
AuthorDate: Thu, 20 Jun 2013 13:31:24 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 26 Jun 2013 12:10:57 +0200

mutex: Add w/w tests to lib/locking-selftest.c

This stresses the lockdep code in some ways specifically useful
to ww_mutexes. It adds checks for most of the common locking
errors.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: dri-devel@lists.freedesktop.org
Cc: linaro-mm-sig@lists.linaro.org
Cc: robclark@gmail.com
Cc: rostedt@goodmis.org
Cc: daniel@ffwll.ch
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/20130620113124.4001.23186.stgit@patser
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 lib/locking-selftest.c | 400 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 381 insertions(+), 19 deletions(-)

diff --git a/lib/locking-selftest.c b/lib/locking-selftest.c
index c3eb261..9962262 100644
--- a/lib/locking-selftest.c
+++ b/lib/locking-selftest.c
@@ -26,6 +26,8 @@
  */
 static unsigned int debug_locks_verbose;
 
+static DEFINE_WW_CLASS(ww_lockdep);
+
 static int __init setup_debug_locks_verbose(char *str)
 {
 	get_option(&str, &debug_locks_verbose);
@@ -42,6 +44,10 @@ __setup("debug_locks_verbose=", setup_debug_locks_verbose);
 #define LOCKTYPE_RWLOCK	0x2
 #define LOCKTYPE_MUTEX	0x4
 #define LOCKTYPE_RWSEM	0x8
+#define LOCKTYPE_WW	0x10
+
+static struct ww_acquire_ctx t, t2;
+static struct ww_mutex o, o2;
 
 /*
  * Normal standalone locks, for the circular and irq-context
@@ -193,6 +199,20 @@ static void init_shared_classes(void)
 #define RSU(x)			up_read(&rwsem_##x)
 #define RWSI(x)			init_rwsem(&rwsem_##x)
 
+#ifndef CONFIG_DEBUG_WW_MUTEX_SLOWPATH
+#define WWAI(x)			ww_acquire_init(x, &ww_lockdep)
+#else
+#define WWAI(x)			do { ww_acquire_init(x, &ww_lockdep); (x)->deadlock_inject_countdown = ~0U; } while (0)
+#endif
+#define WWAD(x)			ww_acquire_done(x)
+#define WWAF(x)			ww_acquire_fini(x)
+
+#define WWL(x, c)		ww_mutex_lock(x, c)
+#define WWT(x)			ww_mutex_trylock(x)
+#define WWL1(x)			ww_mutex_lock(x, NULL)
+#define WWU(x)			ww_mutex_unlock(x)
+
+
 #define LOCK_UNLOCK_2(x,y)	LOCK(x); LOCK(y); UNLOCK(y); UNLOCK(x)
 
 /*
@@ -894,11 +914,13 @@ GENERATE_PERMUTATIONS_3_EVENTS(irq_read_recursion_soft)
 # define I_RWLOCK(x)	lockdep_reset_lock(&rwlock_##x.dep_map)
 # define I_MUTEX(x)	lockdep_reset_lock(&mutex_##x.dep_map)
 # define I_RWSEM(x)	lockdep_reset_lock(&rwsem_##x.dep_map)
+# define I_WW(x)	lockdep_reset_lock(&x.dep_map)
 #else
 # define I_SPINLOCK(x)
 # define I_RWLOCK(x)
 # define I_MUTEX(x)
 # define I_RWSEM(x)
+# define I_WW(x)
 #endif
 
 #define I1(x)					\
@@ -920,11 +942,20 @@ GENERATE_PERMUTATIONS_3_EVENTS(irq_read_recursion_soft)
 static void reset_locks(void)
 {
 	local_irq_disable();
+	lockdep_free_key_range(&ww_lockdep.acquire_key, 1);
+	lockdep_free_key_range(&ww_lockdep.mutex_key, 1);
+
 	I1(A); I1(B); I1(C); I1(D);
 	I1(X1); I1(X2); I1(Y1); I1(Y2); I1(Z1); I1(Z2);
+	I_WW(t); I_WW(t2); I_WW(o.base); I_WW(o2.base);
 	lockdep_reset();
 	I2(A); I2(B); I2(C); I2(D);
 	init_shared_classes();
+
+	ww_mutex_init(&o, &ww_lockdep); ww_mutex_init(&o2, &ww_lockdep);
+	memset(&t, 0, sizeof(t)); memset(&t2, 0, sizeof(t2));
+	memset(&ww_lockdep.acquire_key, 0, sizeof(ww_lockdep.acquire_key));
+	memset(&ww_lockdep.mutex_key, 0, sizeof(ww_lockdep.mutex_key));
 	local_irq_enable();
 }
 
@@ -938,7 +969,6 @@ static int unexpected_testcase_failures;
 static void dotest(void (*testcase_fn)(void), int expected, int lockclass_mask)
 {
 	unsigned long saved_preempt_count = preempt_count();
-	int expected_failure = 0;
 
 	WARN_ON(irqs_disabled());
 
@@ -946,26 +976,16 @@ static void dotest(void (*testcase_fn)(void), int expected, int lockclass_mask)
 	/*
 	 * Filter out expected failures:
 	 */
+	if (debug_locks != expected) {
 #ifndef CONFIG_PROVE_LOCKING
-	if ((lockclass_mask & LOCKTYPE_SPIN) && debug_locks != expected)
-		expected_failure = 1;
-	if ((lockclass_mask & LOCKTYPE_RWLOCK) && debug_locks != expected)
-		expected_failure = 1;
-	if ((lockclass_mask & LOCKTYPE_MUTEX) && debug_locks != expected)
-		expected_failure = 1;
-	if ((lockclass_mask & LOCKTYPE_RWSEM) && debug_locks != expected)
-		expected_failure = 1;
+		expected_testcase_failures++;
+		printk("failed|");
+#else
+		unexpected_testcase_failures++;
+		printk("FAILED|");
+
+		dump_stack();
 #endif
-	if (debug_locks != expected) {
-		if (expected_failure) {
-			expected_testcase_failures++;
-			printk("failed|");
-		} else {
-			unexpected_testcase_failures++;
-
-			printk("FAILED|");
-			dump_stack();
-		}
 	} else {
 		testcase_successes++;
 		printk("  ok  |");
@@ -1108,6 +1128,346 @@ static inline void print_testname(const char *testname)
 	DO_TESTCASE_6IRW(desc, name, 312);			\
 	DO_TESTCASE_6IRW(desc, name, 321);
 
+static void ww_test_fail_acquire(void)
+{
+	int ret;
+
+	WWAI(&t);
+	t.stamp++;
+
+	ret = WWL(&o, &t);
+
+	if (WARN_ON(!o.ctx) ||
+	    WARN_ON(ret))
+		return;
+
+	/* No lockdep test, pure API */
+	ret = WWL(&o, &t);
+	WARN_ON(ret != -EALREADY);
+
+	ret = WWT(&o);
+	WARN_ON(ret);
+
+	t2 = t;
+	t2.stamp++;
+	ret = WWL(&o, &t2);
+	WARN_ON(ret != -EDEADLK);
+	WWU(&o);
+
+	if (WWT(&o))
+		WWU(&o);
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	else
+		DEBUG_LOCKS_WARN_ON(1);
+#endif
+}
+
+static void ww_test_two_contexts(void)
+{
+	WWAI(&t);
+	WWAI(&t2);
+}
+
+static void ww_test_diff_class(void)
+{
+	WWAI(&t);
+#ifdef CONFIG_DEBUG_MUTEXES
+	t.ww_class = NULL;
+#endif
+	WWL(&o, &t);
+}
+
+static void ww_test_context_done_twice(void)
+{
+	WWAI(&t);
+	WWAD(&t);
+	WWAD(&t);
+	WWAF(&t);
+}
+
+static void ww_test_context_unlock_twice(void)
+{
+	WWAI(&t);
+	WWAD(&t);
+	WWAF(&t);
+	WWAF(&t);
+}
+
+static void ww_test_context_fini_early(void)
+{
+	WWAI(&t);
+	WWL(&o, &t);
+	WWAD(&t);
+	WWAF(&t);
+}
+
+static void ww_test_context_lock_after_done(void)
+{
+	WWAI(&t);
+	WWAD(&t);
+	WWL(&o, &t);
+}
+
+static void ww_test_object_unlock_twice(void)
+{
+	WWL1(&o);
+	WWU(&o);
+	WWU(&o);
+}
+
+static void ww_test_object_lock_unbalanced(void)
+{
+	WWAI(&t);
+	WWL(&o, &t);
+	t.acquired = 0;
+	WWU(&o);
+	WWAF(&t);
+}
+
+static void ww_test_object_lock_stale_context(void)
+{
+	WWAI(&t);
+	o.ctx = &t2;
+	WWL(&o, &t);
+}
+
+static void ww_test_spin_nest_unlocked(void)
+{
+	raw_spin_lock_nest_lock(&lock_A, &o.base);
+	U(A);
+}
+
+static void ww_test_unneeded_slow(void)
+{
+	WWAI(&t);
+
+	ww_mutex_lock_slow(&o, &t);
+}
+
+static void ww_test_context_block(void)
+{
+	int ret;
+
+	WWAI(&t);
+
+	ret = WWL(&o, &t);
+	WARN_ON(ret);
+	WWL1(&o2);
+}
+
+static void ww_test_context_try(void)
+{
+	int ret;
+
+	WWAI(&t);
+
+	ret = WWL(&o, &t);
+	WARN_ON(ret);
+
+	ret = WWT(&o2);
+	WARN_ON(!ret);
+	WWU(&o2);
+	WWU(&o);
+}
+
+static void ww_test_context_context(void)
+{
+	int ret;
+
+	WWAI(&t);
+
+	ret = WWL(&o, &t);
+	WARN_ON(ret);
+
+	ret = WWL(&o2, &t);
+	WARN_ON(ret);
+
+	WWU(&o2);
+	WWU(&o);
+}
+
+static void ww_test_try_block(void)
+{
+	bool ret;
+
+	ret = WWT(&o);
+	WARN_ON(!ret);
+
+	WWL1(&o2);
+	WWU(&o2);
+	WWU(&o);
+}
+
+static void ww_test_try_try(void)
+{
+	bool ret;
+
+	ret = WWT(&o);
+	WARN_ON(!ret);
+	ret = WWT(&o2);
+	WARN_ON(!ret);
+	WWU(&o2);
+	WWU(&o);
+}
+
+static void ww_test_try_context(void)
+{
+	int ret;
+
+	ret = WWT(&o);
+	WARN_ON(!ret);
+
+	WWAI(&t);
+
+	ret = WWL(&o2, &t);
+	WARN_ON(ret);
+}
+
+static void ww_test_block_block(void)
+{
+	WWL1(&o);
+	WWL1(&o2);
+}
+
+static void ww_test_block_try(void)
+{
+	bool ret;
+
+	WWL1(&o);
+	ret = WWT(&o2);
+	WARN_ON(!ret);
+}
+
+static void ww_test_block_context(void)
+{
+	int ret;
+
+	WWL1(&o);
+	WWAI(&t);
+
+	ret = WWL(&o2, &t);
+	WARN_ON(ret);
+}
+
+static void ww_test_spin_block(void)
+{
+	L(A);
+	U(A);
+
+	WWL1(&o);
+	L(A);
+	U(A);
+	WWU(&o);
+
+	L(A);
+	WWL1(&o);
+	WWU(&o);
+	U(A);
+}
+
+static void ww_test_spin_try(void)
+{
+	bool ret;
+
+	L(A);
+	U(A);
+
+	ret = WWT(&o);
+	WARN_ON(!ret);
+	L(A);
+	U(A);
+	WWU(&o);
+
+	L(A);
+	ret = WWT(&o);
+	WARN_ON(!ret);
+	WWU(&o);
+	U(A);
+}
+
+static void ww_test_spin_context(void)
+{
+	int ret;
+
+	L(A);
+	U(A);
+
+	WWAI(&t);
+
+	ret = WWL(&o, &t);
+	WARN_ON(ret);
+	L(A);
+	U(A);
+	WWU(&o);
+
+	L(A);
+	ret = WWL(&o, &t);
+	WARN_ON(ret);
+	WWU(&o);
+	U(A);
+}
+
+static void ww_tests(void)
+{
+	printk("  --------------------------------------------------------------------------\n");
+	printk("  | Wound/wait tests |\n");
+	printk("  ---------------------\n");
+
+	print_testname("ww api failures");
+	dotest(ww_test_fail_acquire, SUCCESS, LOCKTYPE_WW);
+	dotest(ww_test_unneeded_slow, FAILURE, LOCKTYPE_WW);
+	printk("\n");
+
+	print_testname("ww contexts mixing");
+	dotest(ww_test_two_contexts, FAILURE, LOCKTYPE_WW);
+	dotest(ww_test_diff_class, FAILURE, LOCKTYPE_WW);
+	printk("\n");
+
+	print_testname("finishing ww context");
+	dotest(ww_test_context_done_twice, FAILURE, LOCKTYPE_WW);
+	dotest(ww_test_context_unlock_twice, FAILURE, LOCKTYPE_WW);
+	dotest(ww_test_context_fini_early, FAILURE, LOCKTYPE_WW);
+	dotest(ww_test_context_lock_after_done, FAILURE, LOCKTYPE_WW);
+	printk("\n");
+
+	print_testname("locking mismatches");
+	dotest(ww_test_object_unlock_twice, FAILURE, LOCKTYPE_WW);
+	dotest(ww_test_object_lock_unbalanced, FAILURE, LOCKTYPE_WW);
+	dotest(ww_test_object_lock_stale_context, FAILURE, LOCKTYPE_WW);
+	printk("\n");
+
+	print_testname("spinlock nest unlocked");
+	dotest(ww_test_spin_nest_unlocked, FAILURE, LOCKTYPE_WW);
+	printk("\n");
+
+	printk("  -----------------------------------------------------\n");
+	printk("                                 |block | try  |context|\n");
+	printk("  -----------------------------------------------------\n");
+
+	print_testname("context");
+	dotest(ww_test_context_block, FAILURE, LOCKTYPE_WW);
+	dotest(ww_test_context_try, SUCCESS, LOCKTYPE_WW);
+	dotest(ww_test_context_context, SUCCESS, LOCKTYPE_WW);
+	printk("\n");
+
+	print_testname("try");
+	dotest(ww_test_try_block, FAILURE, LOCKTYPE_WW);
+	dotest(ww_test_try_try, SUCCESS, LOCKTYPE_WW);
+	dotest(ww_test_try_context, FAILURE, LOCKTYPE_WW);
+	printk("\n");
+
+	print_testname("block");
+	dotest(ww_test_block_block, FAILURE, LOCKTYPE_WW);
+	dotest(ww_test_block_try, SUCCESS, LOCKTYPE_WW);
+	dotest(ww_test_block_context, FAILURE, LOCKTYPE_WW);
+	printk("\n");
+
+	print_testname("spinlock");
+	dotest(ww_test_spin_block, FAILURE, LOCKTYPE_WW);
+	dotest(ww_test_spin_try, SUCCESS, LOCKTYPE_WW);
+	dotest(ww_test_spin_context, FAILURE, LOCKTYPE_WW);
+	printk("\n");
+}
 
 void locking_selftest(void)
 {
@@ -1188,6 +1548,8 @@ void locking_selftest(void)
 	DO_TESTCASE_6x2("irq read-recursion", irq_read_recursion);
 //	DO_TESTCASE_6x2B("irq read-recursion #2", irq_read_recursion2);
 
+	ww_tests();
+
 	if (unexpected_testcase_failures) {
 		printk("-----------------------------------------------------------------\n");
 		debug_locks = 0;
