Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbaLJNWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 08:22:51 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:55403 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044AbaLJNWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 08:22:48 -0500
From: David Hildenbrand <dahi@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, dahi@linux.vnet.ibm.com, borntraeger@de.ibm.com,
        rafael.j.wysocki@intel.com, paulmck@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, bp@suse.de, jkosina@suse.cz
Subject: [PATCH v4] CPU hotplug: active_writer not woken up in some cases - deadlock
Date: Wed, 10 Dec 2014 14:22:01 +0100
Message-Id: <1418217721-42919-1-git-send-email-dahi@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121013-0021-0000-0000-000002166688
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit b2c4623dcd07 ("rcu: More on deadlock between CPU hotplug and expedited
grace periods") introduced another problem that can easily be reproduced by
starting/stopping cpus in a loop.

E.g.:
  for i in `seq 5000`; do
      echo 1 > /sys/devices/system/cpu/cpu1/online
      echo 0 > /sys/devices/system/cpu/cpu1/online
  done

Will result in:
  INFO: task /cpu_start_stop:1 blocked for more than 120 seconds.
  Call Trace:
  ([<00000000006a028e>] __schedule+0x406/0x91c)
   [<0000000000130f60>] cpu_hotplug_begin+0xd0/0xd4
   [<0000000000130ff6>] _cpu_up+0x3e/0x1c4
   [<0000000000131232>] cpu_up+0xb6/0xd4
   [<00000000004a5720>] device_online+0x80/0xc0
   [<00000000004a57f0>] online_store+0x90/0xb0
  ...

And a deadlock.

Problem is that if the last ref in put_online_cpus() can't get the
cpu_hotplug.lock the puts_pending count is incremented, but a sleeping
active_writer might never be woken up, therefore never exiting the loop in
cpu_hotplug_begin().

This fix removes puts_pending and turns refcount into an atomic variable. We
also introduce a wait queue for the active_writer, to avoid possible races and
use-after-free. There is no need to take the lock in put_online_cpus() anymore.

Also rearrange the lockdep anotations so we won't get false positives.

Can't reproduce it with this fix.

Signed-off-by: David Hildenbrand <dahi@linux.vnet.ibm.com>
---
 kernel/cpu.c | 60 ++++++++++++++++++++++++++----------------------------------
 1 file changed, 26 insertions(+), 34 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 5d22023..3f1d5ba 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -58,22 +58,23 @@ static int cpu_hotplug_disabled;
 
 static struct {
 	struct task_struct *active_writer;
-	struct mutex lock; /* Synchronizes accesses to refcount, */
+	/* wait queue to wake up the active_writer */
+	wait_queue_head_t wq;
+	/* verifies that no writer will get active while readers are active */
+	struct mutex lock;
 	/*
 	 * Also blocks the new readers during
 	 * an ongoing cpu hotplug operation.
 	 */
-	int refcount;
-	/* And allows lockless put_online_cpus(). */
-	atomic_t puts_pending;
+	atomic_t refcount;
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map dep_map;
 #endif
 } cpu_hotplug = {
 	.active_writer = NULL,
+	.wq = __WAIT_QUEUE_HEAD_INITIALIZER(cpu_hotplug.wq),
 	.lock = __MUTEX_INITIALIZER(cpu_hotplug.lock),
-	.refcount = 0,
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	.dep_map = {.name = "cpu_hotplug.lock" },
 #endif
@@ -86,15 +87,6 @@ static struct {
 #define cpuhp_lock_acquire()      lock_map_acquire(&cpu_hotplug.dep_map)
 #define cpuhp_lock_release()      lock_map_release(&cpu_hotplug.dep_map)
 
-static void apply_puts_pending(int max)
-{
-	int delta;
-
-	if (atomic_read(&cpu_hotplug.puts_pending) >= max) {
-		delta = atomic_xchg(&cpu_hotplug.puts_pending, 0);
-		cpu_hotplug.refcount -= delta;
-	}
-}
 
 void get_online_cpus(void)
 {
@@ -103,9 +95,9 @@ void get_online_cpus(void)
 		return;
 	cpuhp_lock_acquire_read();
 	mutex_lock(&cpu_hotplug.lock);
-	apply_puts_pending(65536);
-	cpu_hotplug.refcount++;
+	atomic_inc(&cpu_hotplug.refcount);
 	mutex_unlock(&cpu_hotplug.lock);
+	cpuhp_lock_release();
 }
 EXPORT_SYMBOL_GPL(get_online_cpus);
 
@@ -116,9 +108,9 @@ bool try_get_online_cpus(void)
 	if (!mutex_trylock(&cpu_hotplug.lock))
 		return false;
 	cpuhp_lock_acquire_tryread();
-	apply_puts_pending(65536);
-	cpu_hotplug.refcount++;
+	atomic_inc(&cpu_hotplug.refcount);
 	mutex_unlock(&cpu_hotplug.lock);
+	cpuhp_lock_release();
 	return true;
 }
 EXPORT_SYMBOL_GPL(try_get_online_cpus);
@@ -127,20 +119,16 @@ void put_online_cpus(void)
 {
 	if (cpu_hotplug.active_writer == current)
 		return;
-	if (!mutex_trylock(&cpu_hotplug.lock)) {
-		atomic_inc(&cpu_hotplug.puts_pending);
-		cpuhp_lock_release();
-		return;
-	}
-
-	if (WARN_ON(!cpu_hotplug.refcount))
-		cpu_hotplug.refcount++; /* try to fix things up */
 
-	if (!--cpu_hotplug.refcount && unlikely(cpu_hotplug.active_writer))
-		wake_up_process(cpu_hotplug.active_writer);
-	mutex_unlock(&cpu_hotplug.lock);
-	cpuhp_lock_release();
+	if (atomic_dec_and_test(&cpu_hotplug.refcount) &&
+	    waitqueue_active(&cpu_hotplug.wq))
+		wake_up(&cpu_hotplug.wq);
 
+	/* missing get - try to fix things up */
+	if (WARN_ON(atomic_read(&cpu_hotplug.refcount) < 0))
+		atomic_set(&cpu_hotplug.refcount, 0);
+		if (waitqueue_active(&cpu_hotplug.wq))
+			wake_up(&cpu_hotplug.wq);
 }
 EXPORT_SYMBOL_GPL(put_online_cpus);
 
@@ -168,18 +156,22 @@ EXPORT_SYMBOL_GPL(put_online_cpus);
  */
 void cpu_hotplug_begin(void)
 {
+	DEFINE_WAIT(wait);
+
 	cpu_hotplug.active_writer = current;
 
-	cpuhp_lock_acquire();
 	for (;;) {
+		cpuhp_lock_acquire();
 		mutex_lock(&cpu_hotplug.lock);
-		apply_puts_pending(1);
-		if (likely(!cpu_hotplug.refcount))
+		prepare_to_wait(&cpu_hotplug.wq, &wait, TASK_UNINTERRUPTIBLE);
+		if (likely(!atomic_read(&cpu_hotplug.refcount)))
 			break;
-		__set_current_state(TASK_UNINTERRUPTIBLE);
 		mutex_unlock(&cpu_hotplug.lock);
+		cpuhp_lock_release();
 		schedule();
 	}
+
+	finish_wait(&cpu_hotplug.wq, &wait);
 }
 
 void cpu_hotplug_done(void)
-- 
1.8.5.5

