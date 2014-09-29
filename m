Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbaI2NPE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 09:15:04 -0400
Received: from homie.mail.dreamhost.com ([208.97.132.208]:34959 "EHLO
	homiemail-a99.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753932AbaI2NPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 09:15:01 -0400
From: Davidlohr Bueso <dave@stgolabs.net>
To: paulmck@linux.vnet.ibm.com
Cc: peterz@infradead.org, mingo@kernel.org, dave@stgolabs.net,
        linux-kernel@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH 1/4] locktorture: Support rwlocks
Date: Mon, 29 Sep 2014 06:14:23 -0700
Message-Id: <1411996466-11488-2-git-send-email-dave@stgolabs.net>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1411996466-11488-1-git-send-email-dave@stgolabs.net>
References: <1411996466-11488-1-git-send-email-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a "rw_lock" torture test to stress kernel rwlocks and their irq
variant. Reader critical regions are 5x longer than writers. As such
a similar ratio of lock acquisitions is seen in the statistics. In the
case of massive contention, both hold the lock for 1/10 of a second.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 Documentation/locking/locktorture.txt              |   5 +
 kernel/locking/locktorture.c                       | 115 ++++++++++++++++++++-
 .../selftests/rcutorture/configs/lock/CFLIST       |   1 +
 .../selftests/rcutorture/configs/lock/LOCK04       |   6 ++
 .../selftests/rcutorture/configs/lock/LOCK04.boot  |   1 +
 5 files changed, 125 insertions(+), 3 deletions(-)
 create mode 100644 tools/testing/selftests/rcutorture/configs/lock/LOCK04
 create mode 100644 tools/testing/selftests/rcutorture/configs/lock/LOCK04.boot

diff --git a/Documentation/locking/locktorture.txt b/Documentation/locking/locktorture.txt
index be71501..619f2bb 100644
--- a/Documentation/locking/locktorture.txt
+++ b/Documentation/locking/locktorture.txt
@@ -45,6 +45,11 @@ torture_type	  Type of lock to torture. By default, only spinlocks will
 		     o "spin_lock_irq": spin_lock_irq() and spin_unlock_irq()
 					pairs.
 
+		     o "rw_lock": read/write lock() and unlock() rwlock pairs.
+
+		     o "rw_lock_irq": read/write lock_irq() and unlock_irq()
+				      rwlock pairs.
+
 		     o "mutex_lock": mutex_lock() and mutex_unlock() pairs.
 
 		     o "rwsem_lock": read/write down() and up() semaphore pairs.
diff --git a/kernel/locking/locktorture.c b/kernel/locking/locktorture.c
index 540d5df..0762b25 100644
--- a/kernel/locking/locktorture.c
+++ b/kernel/locking/locktorture.c
@@ -27,6 +27,7 @@
 #include <linux/kthread.h>
 #include <linux/err.h>
 #include <linux/spinlock.h>
+#include <linux/rwlock.h>
 #include <linux/mutex.h>
 #include <linux/smp.h>
 #include <linux/interrupt.h>
@@ -229,6 +230,110 @@ static struct lock_torture_ops spin_lock_irq_ops = {
 	.name		= "spin_lock_irq"
 };
 
+static DEFINE_RWLOCK(torture_rwlock);
+
+static int torture_rwlock_write_lock(void) __acquires(torture_rwlock)
+{
+	write_lock(&torture_rwlock);
+	return 0;
+}
+
+static void torture_rwlock_write_delay(struct torture_random_state *trsp)
+{
+	const unsigned long shortdelay_us = 2;
+	const unsigned long longdelay_ms = 100;
+
+	/* We want a short delay mostly to emulate likely code, and
+	 * we want a long delay occasionally to force massive contention.
+	 */
+	if (!(torture_random(trsp) %
+	      (cxt.nrealwriters_stress * 2000 * longdelay_ms)))
+		mdelay(longdelay_ms);
+	else
+		udelay(shortdelay_us);
+}
+
+static void torture_rwlock_write_unlock(void) __releases(torture_rwlock)
+{
+	write_unlock(&torture_rwlock);
+}
+
+static int torture_rwlock_read_lock(void) __acquires(torture_rwlock)
+{
+	read_lock(&torture_rwlock);
+	return 0;
+}
+
+static void torture_rwlock_read_delay(struct torture_random_state *trsp)
+{
+	const unsigned long shortdelay_us = 10;
+	const unsigned long longdelay_ms = 100;
+
+	/* We want a short delay mostly to emulate likely code, and
+	 * we want a long delay occasionally to force massive contention.
+	 */
+	if (!(torture_random(trsp) %
+	      (cxt.nrealreaders_stress * 2000 * longdelay_ms)))
+		mdelay(longdelay_ms);
+	else
+		udelay(shortdelay_us);
+}
+
+static void torture_rwlock_read_unlock(void) __releases(torture_rwlock)
+{
+	read_unlock(&torture_rwlock);
+}
+
+static struct lock_torture_ops rw_lock_ops = {
+	.writelock	= torture_rwlock_write_lock,
+	.write_delay	= torture_rwlock_write_delay,
+	.writeunlock	= torture_rwlock_write_unlock,
+	.readlock       = torture_rwlock_read_lock,
+	.read_delay     = torture_rwlock_read_delay,
+	.readunlock     = torture_rwlock_read_unlock,
+	.name		= "rw_lock"
+};
+
+static int torture_rwlock_write_lock_irq(void) __acquires(torture_rwlock)
+{
+	unsigned long flags;
+
+	write_lock_irqsave(&torture_rwlock, flags);
+	cxt.cur_ops->flags = flags;
+	return 0;
+}
+
+static void torture_rwlock_write_unlock_irq(void)
+__releases(torture_rwlock)
+{
+	write_unlock_irqrestore(&torture_rwlock, cxt.cur_ops->flags);
+}
+
+static int torture_rwlock_read_lock_irq(void) __acquires(torture_rwlock)
+{
+	unsigned long flags;
+
+	read_lock_irqsave(&torture_rwlock, flags);
+	cxt.cur_ops->flags = flags;
+	return 0;
+}
+
+static void torture_rwlock_read_unlock_irq(void)
+__releases(torture_rwlock)
+{
+	write_unlock_irqrestore(&torture_rwlock, cxt.cur_ops->flags);
+}
+
+static struct lock_torture_ops rw_lock_irq_ops = {
+	.writelock	= torture_rwlock_write_lock_irq,
+	.write_delay	= torture_rwlock_write_delay,
+	.writeunlock	= torture_rwlock_write_unlock_irq,
+	.readlock       = torture_rwlock_read_lock_irq,
+	.read_delay     = torture_rwlock_read_delay,
+	.readunlock     = torture_rwlock_read_unlock_irq,
+	.name		= "rw_lock_irq"
+};
+
 static DEFINE_MUTEX(torture_mutex);
 
 static int torture_mutex_lock(void) __acquires(torture_mutex)
@@ -535,8 +640,11 @@ static int __init lock_torture_init(void)
 	int i, j;
 	int firsterr = 0;
 	static struct lock_torture_ops *torture_ops[] = {
-		&lock_busted_ops, &spin_lock_ops, &spin_lock_irq_ops,
-		&mutex_lock_ops, &rwsem_lock_ops,
+		&lock_busted_ops,
+		&spin_lock_ops, &spin_lock_irq_ops,
+		&rw_lock_ops, &rw_lock_irq_ops,
+		&mutex_lock_ops,
+		&rwsem_lock_ops,
 	};
 
 	if (!torture_init_begin(torture_type, verbose, &torture_runnable))
@@ -571,7 +679,8 @@ static int __init lock_torture_init(void)
 		cxt.debug_lock = true;
 #endif
 #ifdef CONFIG_DEBUG_SPINLOCK
-	if (strncmp(torture_type, "spin", 4) == 0)
+	if ((strncmp(torture_type, "spin", 4) == 0) ||
+	    (strncmp(torture_type, "rw_lock", 7) == 0))
 		cxt.debug_lock = true;
 #endif
 
diff --git a/tools/testing/selftests/rcutorture/configs/lock/CFLIST b/tools/testing/selftests/rcutorture/configs/lock/CFLIST
index 6108137..6910b73 100644
--- a/tools/testing/selftests/rcutorture/configs/lock/CFLIST
+++ b/tools/testing/selftests/rcutorture/configs/lock/CFLIST
@@ -1,3 +1,4 @@
 LOCK01
 LOCK02
 LOCK03
+LOCK04
\ No newline at end of file
diff --git a/tools/testing/selftests/rcutorture/configs/lock/LOCK04 b/tools/testing/selftests/rcutorture/configs/lock/LOCK04
new file mode 100644
index 0000000..1d1da14
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/lock/LOCK04
@@ -0,0 +1,6 @@
+CONFIG_SMP=y
+CONFIG_NR_CPUS=4
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
diff --git a/tools/testing/selftests/rcutorture/configs/lock/LOCK04.boot b/tools/testing/selftests/rcutorture/configs/lock/LOCK04.boot
new file mode 100644
index 0000000..48c04fe
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/lock/LOCK04.boot
@@ -0,0 +1 @@
+locktorture.torture_type=rw_lock
-- 
1.8.4.5

