Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab3AOMe7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 07:34:59 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:39632 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756665Ab3AOMek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 07:34:40 -0500
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Subject: [PATCH 7/7] reservation: Add lockdep annotation and selftests
Date: Tue, 15 Jan 2013 13:34:04 +0100
Message-Id: <1358253244-11453-8-git-send-email-maarten.lankhorst@canonical.com>
X-Mailer: git-send-email 1.8.0.3
In-Reply-To: <1358253244-11453-1-git-send-email-maarten.lankhorst@canonical.com>
References: <1358253244-11453-1-git-send-email-maarten.lankhorst@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>

---

The self-tests will fail if the commit "lockdep: Check if nested
lock is actually held" from linux tip core/locking is not applied.
---
 lib/Kconfig.debug      |   1 +
 lib/locking-selftest.c | 385 ++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 367 insertions(+), 19 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 67604e5..017bcea 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -716,6 +716,7 @@ config DEBUG_ATOMIC_SLEEP
 config DEBUG_LOCKING_API_SELFTESTS
 	bool "Locking API boot-time self-tests"
 	depends on DEBUG_KERNEL
+	select CONFIG_DMA_SHARED_BUFFER
 	help
 	  Say Y here if you want the kernel to run a short self-test during
 	  bootup. The self-test checks whether common types of locking bugs
diff --git a/lib/locking-selftest.c b/lib/locking-selftest.c
index 7aae0f2..7fe22c2 100644
--- a/lib/locking-selftest.c
+++ b/lib/locking-selftest.c
@@ -20,6 +20,7 @@
 #include <linux/interrupt.h>
 #include <linux/debug_locks.h>
 #include <linux/irqflags.h>
+#include <linux/reservation.h>
 
 /*
  * Change this to 1 if you want to see the failure printouts:
@@ -42,6 +43,7 @@ __setup("debug_locks_verbose=", setup_debug_locks_verbose);
 #define LOCKTYPE_RWLOCK	0x2
 #define LOCKTYPE_MUTEX	0x4
 #define LOCKTYPE_RWSEM	0x8
+#define LOCKTYPE_RESERVATION	0x10
 
 /*
  * Normal standalone locks, for the circular and irq-context
@@ -920,11 +922,17 @@ GENERATE_PERMUTATIONS_3_EVENTS(irq_read_recursion_soft)
 static void reset_locks(void)
 {
 	local_irq_disable();
+	lockdep_free_key_range(&reservation_object_class, 1);
+	lockdep_free_key_range(&reservation_ticket_class, 1);
+
 	I1(A); I1(B); I1(C); I1(D);
 	I1(X1); I1(X2); I1(Y1); I1(Y2); I1(Z1); I1(Z2);
 	lockdep_reset();
 	I2(A); I2(B); I2(C); I2(D);
 	init_shared_classes();
+
+	memset(&reservation_object_class, 0, sizeof reservation_object_class);
+	memset(&reservation_ticket_class, 0, sizeof reservation_ticket_class);
 	local_irq_enable();
 }
 
@@ -938,7 +946,6 @@ static int unexpected_testcase_failures;
 static void dotest(void (*testcase_fn)(void), int expected, int lockclass_mask)
 {
 	unsigned long saved_preempt_count = preempt_count();
-	int expected_failure = 0;
 
 	WARN_ON(irqs_disabled());
 
@@ -946,26 +953,16 @@ static void dotest(void (*testcase_fn)(void), int expected, int lockclass_mask)
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
@@ -1108,6 +1105,354 @@ static inline void print_testname(const char *testname)
 	DO_TESTCASE_6IRW(desc, name, 312);			\
 	DO_TESTCASE_6IRW(desc, name, 321);
 
+static void reservation_test_fail_reserve(void)
+{
+	struct reservation_ticket t;
+	struct reservation_object o;
+	int ret;
+
+	reservation_object_init(&o);
+	reservation_ticket_init(&t);
+	t.seqno++;
+
+	ret = mutex_reserve_lock(&o.lock, &t, t.seqno);
+
+	BUG_ON(!atomic_long_read(&o.lock.reservation_id));
+
+	/* No lockdep test, pure API */
+	ret = mutex_reserve_lock(&o.lock, &t, t.seqno);
+	WARN_ON(ret != -EDEADLK);
+
+	t.seqno++;
+	ret = mutex_trylock(&o.lock.base);
+	WARN_ON(ret);
+
+	ret = mutex_reserve_lock(&o.lock, &t, t.seqno);
+	WARN_ON(ret != -EAGAIN);
+	mutex_unlock(&o.lock.base);
+
+	if (mutex_trylock(&o.lock.base))
+		mutex_unlock(&o.lock.base);
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	else DEBUG_LOCKS_WARN_ON(1);
+#endif
+
+	reservation_ticket_fini(&t);
+}
+
+static void reservation_test_two_tickets(void)
+{
+	struct reservation_ticket t, t2;
+
+	reservation_ticket_init(&t);
+	reservation_ticket_init(&t2);
+
+	reservation_ticket_fini(&t2);
+	reservation_ticket_fini(&t);
+}
+
+static void reservation_test_ticket_unreserve_twice(void)
+{
+	struct reservation_ticket t;
+
+	reservation_ticket_init(&t);
+	reservation_ticket_fini(&t);
+	reservation_ticket_fini(&t);
+}
+
+static void reservation_test_object_unreserve_twice(void)
+{
+	struct reservation_object o;
+
+	reservation_object_init(&o);
+	mutex_lock(&o.lock.base);
+	mutex_unlock(&o.lock.base);
+	mutex_unlock(&o.lock.base);
+}
+
+static void reservation_test_fence_nest_unreserved(void)
+{
+	struct reservation_object o;
+
+	reservation_object_init(&o);
+
+	spin_lock_nest_lock(&lock_A, &o.lock.base);
+	spin_unlock(&lock_A);
+}
+
+static void reservation_test_ticket_block(void)
+{
+	struct reservation_ticket t;
+	struct reservation_object o, o2;
+	int ret;
+
+	reservation_object_init(&o);
+	reservation_object_init(&o2);
+	reservation_ticket_init(&t);
+
+	ret = mutex_reserve_lock(&o.lock, &t, t.seqno);
+	WARN_ON(ret);
+	mutex_lock(&o2.lock.base);
+	mutex_unlock(&o2.lock.base);
+	mutex_unreserve_unlock(&o.lock);
+
+	reservation_ticket_fini(&t);
+}
+
+static void reservation_test_ticket_try(void)
+{
+	struct reservation_ticket t;
+	struct reservation_object o, o2;
+	int ret;
+
+	reservation_object_init(&o);
+	reservation_object_init(&o2);
+	reservation_ticket_init(&t);
+
+	ret = mutex_reserve_lock(&o.lock, &t, t.seqno);
+	WARN_ON(ret);
+
+	mutex_trylock(&o2.lock.base);
+	mutex_unlock(&o2.lock.base);
+	mutex_unreserve_unlock(&o.lock);
+
+	reservation_ticket_fini(&t);
+}
+
+static void reservation_test_ticket_ticket(void)
+{
+	struct reservation_ticket t;
+	struct reservation_object o, o2;
+	int ret;
+
+	reservation_object_init(&o);
+	reservation_object_init(&o2);
+	reservation_ticket_init(&t);
+
+	ret = mutex_reserve_lock(&o.lock, &t, t.seqno);
+	WARN_ON(ret);
+
+	ret = mutex_reserve_lock(&o2.lock, &t, t.seqno);
+	WARN_ON(ret);
+
+	mutex_unreserve_unlock(&o2.lock);
+	mutex_unreserve_unlock(&o.lock);
+
+	reservation_ticket_fini(&t);
+}
+
+static void reservation_test_try_block(void)
+{
+	struct reservation_object o, o2;
+
+	reservation_object_init(&o);
+	reservation_object_init(&o2);
+
+	mutex_trylock(&o.lock.base);
+	mutex_lock(&o2.lock.base);
+	mutex_unlock(&o2.lock.base);
+	mutex_unlock(&o.lock.base);
+}
+
+static void reservation_test_try_try(void)
+{
+	struct reservation_object o, o2;
+
+	reservation_object_init(&o);
+	reservation_object_init(&o2);
+
+	mutex_trylock(&o.lock.base);
+	mutex_trylock(&o2.lock.base);
+	mutex_unlock(&o2.lock.base);
+	mutex_unlock(&o.lock.base);
+}
+
+static void reservation_test_try_ticket(void)
+{
+	struct reservation_ticket t;
+	struct reservation_object o, o2;
+	int ret;
+
+	reservation_object_init(&o);
+	reservation_object_init(&o2);
+
+	mutex_trylock(&o.lock.base);
+	reservation_ticket_init(&t);
+
+	ret = mutex_reserve_lock(&o2.lock, &t, t.seqno);
+	WARN_ON(ret);
+
+	mutex_unreserve_unlock(&o2.lock);
+	mutex_unlock(&o.lock.base);
+
+	reservation_ticket_fini(&t);
+}
+
+static void reservation_test_block_block(void)
+{
+	struct reservation_object o, o2;
+
+	reservation_object_init(&o);
+	reservation_object_init(&o2);
+
+	mutex_lock(&o.lock.base);
+	mutex_lock(&o2.lock.base);
+	mutex_unlock(&o2.lock.base);
+	mutex_unlock(&o.lock.base);
+}
+
+static void reservation_test_block_try(void)
+{
+	struct reservation_object o, o2;
+
+	reservation_object_init(&o);
+	reservation_object_init(&o2);
+
+	mutex_lock(&o.lock.base);
+	mutex_trylock(&o2.lock.base);
+	mutex_unlock(&o2.lock.base);
+	mutex_unlock(&o.lock.base);
+}
+
+static void reservation_test_block_ticket(void)
+{
+	struct reservation_ticket t;
+	struct reservation_object o, o2;
+	int ret;
+
+	reservation_object_init(&o);
+	reservation_object_init(&o2);
+
+	mutex_lock(&o.lock.base);
+	reservation_ticket_init(&t);
+
+	ret = mutex_reserve_lock(&o2.lock, &t, t.seqno);
+	WARN_ON(ret);
+	mutex_unreserve_unlock(&o2.lock);
+	mutex_unlock(&o.lock.base);
+
+	reservation_ticket_fini(&t);
+}
+
+static void reservation_test_fence_block(void)
+{
+	struct reservation_object o;
+
+	reservation_object_init(&o);
+	spin_lock(&lock_A);
+	spin_unlock(&lock_A);
+
+	mutex_lock(&o.lock.base);
+	spin_lock(&lock_A);
+	spin_unlock(&lock_A);
+	mutex_unlock(&o.lock.base);
+
+	spin_lock(&lock_A);
+	mutex_lock(&o.lock.base);
+	mutex_unlock(&o.lock.base);
+	spin_unlock(&lock_A);
+}
+
+static void reservation_test_fence_try(void)
+{
+	struct reservation_object o;
+
+	reservation_object_init(&o);
+	spin_lock(&lock_A);
+	spin_unlock(&lock_A);
+
+	mutex_trylock(&o.lock.base);
+	spin_lock(&lock_A);
+	spin_unlock(&lock_A);
+	mutex_unlock(&o.lock.base);
+
+	spin_lock(&lock_A);
+	mutex_trylock(&o.lock.base);
+	mutex_unlock(&o.lock.base);
+	spin_unlock(&lock_A);
+}
+
+static void reservation_test_fence_ticket(void)
+{
+	struct reservation_ticket t;
+	struct reservation_object o;
+	int ret;
+
+	reservation_object_init(&o);
+	spin_lock(&lock_A);
+	spin_unlock(&lock_A);
+
+	reservation_ticket_init(&t);
+
+	ret = mutex_reserve_lock(&o.lock, &t, t.seqno);
+	WARN_ON(ret);
+	spin_lock(&lock_A);
+	spin_unlock(&lock_A);
+	mutex_unreserve_unlock(&o.lock);
+
+	spin_lock(&lock_A);
+	ret = mutex_reserve_lock(&o.lock, &t, t.seqno);
+	WARN_ON(ret);
+	mutex_unreserve_unlock(&o.lock);
+	spin_unlock(&lock_A);
+
+	reservation_ticket_fini(&t);
+}
+
+static void reservation_tests(void)
+{
+	printk("  --------------------------------------------------------------------------\n");
+	printk("  | Reservation tests |\n");
+	printk("  ---------------------\n");
+
+	print_testname("reservation api failures");
+	dotest(reservation_test_fail_reserve, SUCCESS, LOCKTYPE_RESERVATION);
+	printk("\n");
+
+	print_testname("reserving two tickets");
+	dotest(reservation_test_two_tickets, FAILURE, LOCKTYPE_RESERVATION);
+	printk("\n");
+
+	print_testname("unreserve ticket twice");
+	dotest(reservation_test_ticket_unreserve_twice, FAILURE, LOCKTYPE_RESERVATION);
+	printk("\n");
+
+	print_testname("unreserve object twice");
+	dotest(reservation_test_object_unreserve_twice, FAILURE, LOCKTYPE_RESERVATION);
+	printk("\n");
+
+	print_testname("spinlock nest unreserved");
+	dotest(reservation_test_fence_nest_unreserved, FAILURE, LOCKTYPE_RESERVATION);
+	printk("\n");
+
+	printk("  -----------------------------------------------------\n");
+	printk("                                 |block | try  |ticket|\n");
+	printk("  -----------------------------------------------------\n");
+
+	print_testname("ticket");
+	dotest(reservation_test_ticket_block, FAILURE, LOCKTYPE_RESERVATION);
+	dotest(reservation_test_ticket_try, SUCCESS, LOCKTYPE_RESERVATION);
+	dotest(reservation_test_ticket_ticket, SUCCESS, LOCKTYPE_RESERVATION);
+	printk("\n");
+
+	print_testname("try");
+	dotest(reservation_test_try_block, FAILURE, LOCKTYPE_RESERVATION);
+	dotest(reservation_test_try_try, SUCCESS, LOCKTYPE_RESERVATION);
+	dotest(reservation_test_try_ticket, FAILURE, LOCKTYPE_RESERVATION);
+	printk("\n");
+
+	print_testname("block");
+	dotest(reservation_test_block_block, FAILURE, LOCKTYPE_RESERVATION);
+	dotest(reservation_test_block_try, SUCCESS, LOCKTYPE_RESERVATION);
+	dotest(reservation_test_block_ticket, FAILURE, LOCKTYPE_RESERVATION);
+	printk("\n");
+
+	print_testname("spinlock");
+	dotest(reservation_test_fence_block, FAILURE, LOCKTYPE_RESERVATION);
+	dotest(reservation_test_fence_try, SUCCESS, LOCKTYPE_RESERVATION);
+	dotest(reservation_test_fence_ticket, FAILURE, LOCKTYPE_RESERVATION);
+	printk("\n");
+}
 
 void locking_selftest(void)
 {
@@ -1188,6 +1533,8 @@ void locking_selftest(void)
 	DO_TESTCASE_6x2("irq read-recursion", irq_read_recursion);
 //	DO_TESTCASE_6x2B("irq read-recursion #2", irq_read_recursion2);
 
+	reservation_tests();
+
 	if (unexpected_testcase_failures) {
 		printk("-----------------------------------------------------------------\n");
 		debug_locks = 0;
-- 
1.8.0.3

