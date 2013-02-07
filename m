Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913Ab3BGQHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 11:07:50 -0500
Received: from adelie.canonical.com ([91.189.90.139]:50683 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755697Ab3BGQDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 11:03:10 -0500
Subject: [PATCH 3/3] reservation: Add tests to lib/locking-selftest.c.
To: linux-kernel@vger.kernel.org
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-arch@vger.kernel.org, a.p.zijlstra@chello.nl, daniel.vetter@ffwll.ch,
        x86@kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, robclark@gmail.com, tglx@linutronix.de,
        mingo@elte.hu, linux-media@vger.kernel.org
Date: Thu, 07 Feb 2013 16:18:44 +0100
Message-ID: <20130207151844.2868.87833.stgit@patser.local>
In-Reply-To: <20130207151831.2868.5146.stgit@patser.local>
References: <20130207151831.2868.5146.stgit@patser.local>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This stresses the lockdep code in some ways specifically useful to
reservations. It adds checks for most of the common locking errors.

Since the lockdep tests were originally written to stress the
reservation code, I duplicated some of the definitions into
lib/locking-selftest.c for now.

This will be cleaned up later when the api for reservations is
accepted. I don't expect the tests to change, since the discussion
is mostly about the fence aspect of reservations.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---
 lib/locking-selftest.c |  522 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 503 insertions(+), 19 deletions(-)

diff --git a/lib/locking-selftest.c b/lib/locking-selftest.c
index 7aae0f2..a3959af 100644
--- a/lib/locking-selftest.c
+++ b/lib/locking-selftest.c
@@ -26,6 +26,67 @@
  */
 static unsigned int debug_locks_verbose;
 
+/*
+ * These definitions are from the reservation objects patch series.
+ * For now we have to define it ourselves here. These definitions will
+ * be removed upon acceptance of that patch series.
+ */
+static const char reservation_object_name[] = "reservation_object";
+static struct lock_class_key reservation_object_class;
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+static const char reservation_ticket_name[] = "reservation_ticket";
+static struct lock_class_key reservation_ticket_class;
+#endif
+
+struct reservation_object {
+	struct ticket_mutex lock;
+};
+
+struct reservation_ticket {
+	unsigned long seqno;
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lockdep_map dep_map;
+#endif
+};
+
+static inline void
+reservation_object_init(struct reservation_object *obj)
+{
+	__ticket_mutex_init(&obj->lock, reservation_object_name,
+			    &reservation_object_class);
+}
+
+static inline void
+reservation_object_fini(struct reservation_object *obj)
+{
+	mutex_destroy(&obj->lock.base);
+}
+
+static inline void
+reservation_ticket_init(struct reservation_ticket *t)
+{
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	/*
+	 * Make sure we are not reinitializing a held ticket:
+	 */
+
+	debug_check_no_locks_freed((void *)t, sizeof(*t));
+	lockdep_init_map(&t->dep_map, reservation_ticket_name,
+			 &reservation_ticket_class, 0);
+#endif
+	mutex_acquire(&t->dep_map, 0, 0, _THIS_IP_);
+	t->seqno = 5;
+}
+
+static inline void
+reservation_ticket_fini(struct reservation_ticket *t)
+{
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	mutex_release(&t->dep_map, 0, _THIS_IP_);
+	t->seqno = 0;
+#endif
+}
+
 static int __init setup_debug_locks_verbose(char *str)
 {
 	get_option(&str, &debug_locks_verbose);
@@ -42,6 +103,7 @@ __setup("debug_locks_verbose=", setup_debug_locks_verbose);
 #define LOCKTYPE_RWLOCK	0x2
 #define LOCKTYPE_MUTEX	0x4
 #define LOCKTYPE_RWSEM	0x8
+#define LOCKTYPE_RESERVATION	0x10
 
 /*
  * Normal standalone locks, for the circular and irq-context
@@ -920,11 +982,17 @@ GENERATE_PERMUTATIONS_3_EVENTS(irq_read_recursion_soft)
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
+	memset(&reservation_object_class, 0, sizeof(reservation_object_class));
+	memset(&reservation_ticket_class, 0, sizeof(reservation_ticket_class));
 	local_irq_enable();
 }
 
@@ -938,7 +1006,6 @@ static int unexpected_testcase_failures;
 static void dotest(void (*testcase_fn)(void), int expected, int lockclass_mask)
 {
 	unsigned long saved_preempt_count = preempt_count();
-	int expected_failure = 0;
 
 	WARN_ON(irqs_disabled());
 
@@ -946,26 +1013,16 @@ static void dotest(void (*testcase_fn)(void), int expected, int lockclass_mask)
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
@@ -1108,6 +1165,431 @@ static inline void print_testname(const char *testname)
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
+	else
+		DEBUG_LOCKS_WARN_ON(1);
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
+static void reservation_test_mismatch_normal_reserve(void)
+{
+	struct reservation_object o;
+
+	reservation_object_init(&o);
+
+	mutex_lock(&o.lock.base);
+	mutex_unreserve_unlock(&o.lock);
+}
+
+static void reservation_test_mismatch_reserve_normal(void)
+{
+	struct reservation_ticket t;
+	struct reservation_object o;
+	int ret;
+
+	reservation_ticket_init(&t);
+	reservation_object_init(&o);
+
+	ret = mutex_reserve_lock(&o.lock, &t, t.seqno);
+	WARN_ON(ret);
+	mutex_unlock(&o.lock.base);
+
+	/*
+	 * the second mutex_reserve_lock will detect the
+	 * mismatch of the first one
+	 */
+	ret = mutex_reserve_lock(&o.lock, &t, t.seqno);
+	WARN_ON(ret);
+	mutex_unreserve_unlock(&o.lock);
+
+	reservation_ticket_fini(&t);
+}
+
+static void reservation_test_mismatch_reserve_normal_slow(void)
+{
+	struct reservation_ticket t;
+	struct reservation_object o;
+	int ret;
+
+	reservation_ticket_init(&t);
+	reservation_object_init(&o);
+
+	ret = mutex_reserve_lock(&o.lock, &t, t.seqno);
+	WARN_ON(ret);
+	mutex_unlock(&o.lock.base);
+
+	/*
+	 * the second mutex_reserve_lock will detect the
+	 * mismatch of the first one
+	 */
+	mutex_reserve_lock_slow(&o.lock, &t, t.seqno);
+	mutex_unreserve_unlock(&o.lock);
+
+	reservation_ticket_fini(&t);
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
+	ret = mutex_trylock(&o2.lock.base);
+	WARN_ON(!ret);
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
+	bool ret;
+
+	reservation_object_init(&o);
+	reservation_object_init(&o2);
+
+	ret = mutex_trylock(&o.lock.base);
+	WARN_ON(!ret);
+
+	mutex_lock(&o2.lock.base);
+	mutex_unlock(&o2.lock.base);
+	mutex_unlock(&o.lock.base);
+}
+
+static void reservation_test_try_try(void)
+{
+	struct reservation_object o, o2;
+	bool ret;
+
+	reservation_object_init(&o);
+	reservation_object_init(&o2);
+
+	ret = mutex_trylock(&o.lock.base);
+	WARN_ON(!ret);
+	ret = mutex_trylock(&o2.lock.base);
+	WARN_ON(!ret);
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
+	ret = mutex_trylock(&o.lock.base);
+	WARN_ON(!ret);
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
+	bool ret;
+
+	reservation_object_init(&o);
+	reservation_object_init(&o2);
+
+	mutex_lock(&o.lock.base);
+	ret = mutex_trylock(&o2.lock.base);
+	WARN_ON(!ret);
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
+	bool ret;
+
+	reservation_object_init(&o);
+	spin_lock(&lock_A);
+	spin_unlock(&lock_A);
+
+	ret = mutex_trylock(&o.lock.base);
+	WARN_ON(!ret);
+	spin_lock(&lock_A);
+	spin_unlock(&lock_A);
+	mutex_unlock(&o.lock.base);
+
+	spin_lock(&lock_A);
+	ret = mutex_trylock(&o.lock.base);
+	WARN_ON(!ret);
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
+	print_testname("mutex reserve (un)lock mismatch");
+	dotest(reservation_test_mismatch_normal_reserve, FAILURE, LOCKTYPE_RESERVATION);
+	dotest(reservation_test_mismatch_reserve_normal, FAILURE, LOCKTYPE_RESERVATION);
+	dotest(reservation_test_mismatch_reserve_normal_slow, FAILURE, LOCKTYPE_RESERVATION);
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
@@ -1188,6 +1670,8 @@ void locking_selftest(void)
 	DO_TESTCASE_6x2("irq read-recursion", irq_read_recursion);
 //	DO_TESTCASE_6x2B("irq read-recursion #2", irq_read_recursion2);
 
+	reservation_tests();
+
 	if (unexpected_testcase_failures) {
 		printk("-----------------------------------------------------------------\n");
 		debug_locks = 0;

