Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934822Ab3BTJ5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 04:57:36 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:61939 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933984Ab3BTJ5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 04:57:33 -0500
MIME-Version: 1.0
Date: Wed, 20 Feb 2013 09:57:31 +0000
Message-ID: <CAMuW1wcYcoNaOh2HD=NyizprakcLkFM7TLx4WitxX2iX9hm9Zg@mail.gmail.com>
Subject: mutex: add tests for normal mutex paths, and use __always_inline on __mutex_lock_common
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Ben Skeggs <bskeggs@redhat.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I hope gmail web client can send patches correctly, I'm not at home
and my router at home stopped responding to pings, so hopefully this
works..

Can you test the following patch without the always_inline change too,
to ensure the fix part works?

For the tests to run, you need CONFIG_DEBUG_LOCKING_API_SELFTESTS=y

------->8
The non-reservation calls to __mutex_lock_common always need to be
inlined, else __builtin_constant_p() may evaluate to false, even
though it should be evaluated as true.

Add tests to verify that the normal locking calls do not corrupt
the reservation_id member, since it's not guaranteed to exist for
normal locks, resulting in memory corruption.

This should fix the following warning:

[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at /c/kernel-tests/src/tip/kernel/mutex.c:386
__mutex_lock_common+0x5a9/0x870()
[    0.000000] Hardware name: Bochs
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper/0 Not tainted 3.8.0-rc7-00071-g11eb5a2 #180
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81047102>] warn_slowpath_common+0xb2/0x120
[    0.000000]  [<ffffffff81047195>] warn_slowpath_null+0x25/0x30
[    0.000000]  [<ffffffff814ebdd9>] __mutex_lock_common+0x5a9/0x870
[    0.000000]  [<ffffffff81a66ef8>] ? rcu_cpu_notify+0xa8/0x451
[    0.000000]  [<ffffffff810bcb8f>] ? trace_hardirqs_off_caller+0xaf/0x120
[    0.000000]  [<ffffffff81a66ef8>] ? rcu_cpu_notify+0xa8/0x451
[    0.000000]  [<ffffffff810be38c>] ? lockdep_init_map+0xfc/0x230
[    0.000000]  [<ffffffff814ec621>] mutex_lock_nested+0x61/0x80
[    0.000000]  [<ffffffff810bcc1d>] ? trace_hardirqs_off+0x1d/0x30
[    0.000000]  [<ffffffff81a66ef8>] rcu_cpu_notify+0xa8/0x451
[    0.000000]  [<ffffffff814ecc31>] ? mutex_unlock+0x11/0x20
[    0.000000]  [<ffffffff81a3f952>] rcu_init+0x3b3/0x408
[    0.000000]  [<ffffffff81a21e0c>] start_kernel+0x34a/0x744
[    0.000000]  [<ffffffff81a216e6>] ? repair_env_string+0x81/0x81
[    0.000000]  [<ffffffff81a21120>] ? early_idt_handlers+0x120/0x120
[    0.000000]  [<ffffffff81a212fd>] x86_64_start_reservations+0x185/0x190
[    0.000000]  [<ffffffff81a214a8>] x86_64_start_kernel+0x1a0/0x1b6
[    0.000000] ---[ end trace 8e966724b1809892 ]---

Link: http://lkml.kernel.org/r/20130218013720.GC10963@localhost
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@ubuntu.com>
---
 kernel/mutex.c         |    2 +
 lib/locking-selftest.c |   66 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+), 1 deletion(-)

diff --git a/kernel/mutex.c b/kernel/mutex.c
index 432948c..014b117 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -227,7 +227,7 @@ mutex_set_reservation_fastpath(struct ticket_mutex *lock,
 /*
  * Lock a mutex (possibly interruptible), slowpath:
  */
-static inline int __sched
+static __always_inline int __sched
 __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		    struct lockdep_map *nest_lock, unsigned long ip,
 		    unsigned long reservation_id, bool res_slow)
diff --git a/lib/locking-selftest.c b/lib/locking-selftest.c
index 69751a8..117123e 100644
--- a/lib/locking-selftest.c
+++ b/lib/locking-selftest.c
@@ -1141,6 +1141,71 @@ static void reservation_test_fail_reserve(void)
 	reservation_ticket_fini(&t);
 }

+static void reservation_test_normal(void)
+{
+	struct reservation_object o;
+	struct reservation_ticket t;
+	int ret;
+
+	reservation_object_init(&o);
+	reservation_ticket_init(&t);
+
+	/*
+	 * test if reservation_id is kept identical if not
+	 * called with any of the reserve_* locking calls
+	 */
+
+	/* mutex_lock (and indirectly, mutex_lock_nested) */
+	atomic_long_set(&o.lock.reservation_id, ~0UL);
+	mutex_lock(&o.lock.base);
+	mutex_unlock(&o.lock.base);
+	WARN_ON(atomic_long_read(&o.lock.reservation_id) != ~0UL);
+
+	/* mutex_lock_interruptible (and *_nested) */
+	atomic_long_set(&o.lock.reservation_id, ~0UL);
+	ret = mutex_lock_interruptible(&o.lock.base);
+	if (!ret)
+		mutex_unlock(&o.lock.base);
+	else
+		WARN_ON(1);
+	WARN_ON(atomic_long_read(&o.lock.reservation_id) != ~0UL);
+
+	/* mutex_lock_killable (and *_nested) */
+	atomic_long_set(&o.lock.reservation_id, ~0UL);
+	ret = mutex_lock_killable(&o.lock.base);
+	if (!ret)
+		mutex_unlock(&o.lock.base);
+	else
+		WARN_ON(1);
+	WARN_ON(atomic_long_read(&o.lock.reservation_id) != ~0UL);
+
+	/* trylock, succeeding */
+	atomic_long_set(&o.lock.reservation_id, ~0UL);
+	ret = mutex_trylock(&o.lock.base);
+	WARN_ON(!ret);
+	if (ret)
+		mutex_unlock(&o.lock.base);
+	else
+		WARN_ON(1);
+	WARN_ON(atomic_long_read(&o.lock.reservation_id) != ~0UL);
+
+	/* trylock, failing */
+	atomic_long_set(&o.lock.reservation_id, ~0UL);
+	mutex_lock(&o.lock.base);
+	ret = mutex_trylock(&o.lock.base);
+	WARN_ON(ret);
+	mutex_unlock(&o.lock.base);
+	WARN_ON(atomic_long_read(&o.lock.reservation_id) != ~0UL);
+
+	/* nest_lock */
+	atomic_long_set(&o.lock.reservation_id, ~0UL);
+	mutex_lock_nest_lock(&o.lock.base, &t);
+	mutex_unlock(&o.lock.base);
+	WARN_ON(atomic_long_read(&o.lock.reservation_id) != ~0UL);
+
+	reservation_ticket_fini(&t);
+}
+
 static void reservation_test_two_tickets(void)
 {
 	struct reservation_ticket t, t2;
@@ -1478,6 +1543,7 @@ static void reservation_tests(void)

 	print_testname("reservation api failures");
 	dotest(reservation_test_fail_reserve, SUCCESS, LOCKTYPE_RESERVATION);
+	dotest(reservation_test_normal, SUCCESS, LOCKTYPE_RESERVATION);
 	printk("\n");

 	print_testname("reserving two tickets");
