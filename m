Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab3KEMXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 07:23:43 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55916 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407Ab3KEMXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 07:23:41 -0500
Message-Id: <20131105110027.370210716@infradead.org>
User-Agent: quilt/0.60-1
Date: Tue, 05 Nov 2013 13:10:51 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: paulmck@linux.vnet.ibm.com, oleg@redhat.com, dhowells@redhat.com,
        willy@linux.intel.com, tglx@linutronix.de, rostedt@goodmis.org,
        airlied@gmail.com, maarten.lankhorst@canonical.com, walken@google.com,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [RFC 7/8] locking: Move lglocks into kernel/locking/
References: <20131105105244.666320103@infradead.org>
Content-Disposition: inline; filename=peterz-move-locking-lglock.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Suggested-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/Makefile         |    2 -
 kernel/lglock.c         |   89 ------------------------------------------------
 kernel/locking/Makefile |    2 -
 kernel/locking/lglock.c |   89 ++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 91 insertions(+), 91 deletions(-)

--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -10,7 +10,7 @@ obj-y     = fork.o exec_domain.o panic.o
 	    kthread.o sys_ni.o posix-cpu-timers.o \
 	    hrtimer.o nsproxy.o \
 	    notifier.o ksysfs.o cred.o reboot.o \
-	    async.o range.o groups.o lglock.o smpboot.o
+	    async.o range.o groups.o smpboot.o
 
 ifdef CONFIG_FUNCTION_TRACER
 # Do not trace debug files and internal ftrace files
--- a/kernel/lglock.c
+++ /dev/null
@@ -1,89 +0,0 @@
-/* See include/linux/lglock.h for description */
-#include <linux/module.h>
-#include <linux/lglock.h>
-#include <linux/cpu.h>
-#include <linux/string.h>
-
-/*
- * Note there is no uninit, so lglocks cannot be defined in
- * modules (but it's fine to use them from there)
- * Could be added though, just undo lg_lock_init
- */
-
-void lg_lock_init(struct lglock *lg, char *name)
-{
-	LOCKDEP_INIT_MAP(&lg->lock_dep_map, name, &lg->lock_key, 0);
-}
-EXPORT_SYMBOL(lg_lock_init);
-
-void lg_local_lock(struct lglock *lg)
-{
-	arch_spinlock_t *lock;
-
-	preempt_disable();
-	lock_acquire_shared(&lg->lock_dep_map, 0, 0, NULL, _RET_IP_);
-	lock = this_cpu_ptr(lg->lock);
-	arch_spin_lock(lock);
-}
-EXPORT_SYMBOL(lg_local_lock);
-
-void lg_local_unlock(struct lglock *lg)
-{
-	arch_spinlock_t *lock;
-
-	lock_release(&lg->lock_dep_map, 1, _RET_IP_);
-	lock = this_cpu_ptr(lg->lock);
-	arch_spin_unlock(lock);
-	preempt_enable();
-}
-EXPORT_SYMBOL(lg_local_unlock);
-
-void lg_local_lock_cpu(struct lglock *lg, int cpu)
-{
-	arch_spinlock_t *lock;
-
-	preempt_disable();
-	lock_acquire_shared(&lg->lock_dep_map, 0, 0, NULL, _RET_IP_);
-	lock = per_cpu_ptr(lg->lock, cpu);
-	arch_spin_lock(lock);
-}
-EXPORT_SYMBOL(lg_local_lock_cpu);
-
-void lg_local_unlock_cpu(struct lglock *lg, int cpu)
-{
-	arch_spinlock_t *lock;
-
-	lock_release(&lg->lock_dep_map, 1, _RET_IP_);
-	lock = per_cpu_ptr(lg->lock, cpu);
-	arch_spin_unlock(lock);
-	preempt_enable();
-}
-EXPORT_SYMBOL(lg_local_unlock_cpu);
-
-void lg_global_lock(struct lglock *lg)
-{
-	int i;
-
-	preempt_disable();
-	lock_acquire_exclusive(&lg->lock_dep_map, 0, 0, NULL, _RET_IP_);
-	for_each_possible_cpu(i) {
-		arch_spinlock_t *lock;
-		lock = per_cpu_ptr(lg->lock, i);
-		arch_spin_lock(lock);
-	}
-}
-EXPORT_SYMBOL(lg_global_lock);
-
-void lg_global_unlock(struct lglock *lg)
-{
-	int i;
-
-	lock_release(&lg->lock_dep_map, 1, _RET_IP_);
-	for_each_possible_cpu(i) {
-		arch_spinlock_t *lock;
-		lock = per_cpu_ptr(lg->lock, i);
-		arch_spin_unlock(lock);
-	}
-	preempt_enable();
-}
-EXPORT_SYMBOL(lg_global_unlock);
--- a/kernel/locking/Makefile
+++ b/kernel/locking/Makefile
@@ -1,5 +1,5 @@
 
-obj-y += mutex.o semaphore.o rwsem.o
+obj-y += mutex.o semaphore.o rwsem.o lglock.o
 
 ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_lockdep.o = -pg
--- /dev/null
+++ b/kernel/locking/lglock.c
@@ -0,0 +1,89 @@
+/* See include/linux/lglock.h for description */
+#include <linux/module.h>
+#include <linux/lglock.h>
+#include <linux/cpu.h>
+#include <linux/string.h>
+
+/*
+ * Note there is no uninit, so lglocks cannot be defined in
+ * modules (but it's fine to use them from there)
+ * Could be added though, just undo lg_lock_init
+ */
+
+void lg_lock_init(struct lglock *lg, char *name)
+{
+	LOCKDEP_INIT_MAP(&lg->lock_dep_map, name, &lg->lock_key, 0);
+}
+EXPORT_SYMBOL(lg_lock_init);
+
+void lg_local_lock(struct lglock *lg)
+{
+	arch_spinlock_t *lock;
+
+	preempt_disable();
+	lock_acquire_shared(&lg->lock_dep_map, 0, 0, NULL, _RET_IP_);
+	lock = this_cpu_ptr(lg->lock);
+	arch_spin_lock(lock);
+}
+EXPORT_SYMBOL(lg_local_lock);
+
+void lg_local_unlock(struct lglock *lg)
+{
+	arch_spinlock_t *lock;
+
+	lock_release(&lg->lock_dep_map, 1, _RET_IP_);
+	lock = this_cpu_ptr(lg->lock);
+	arch_spin_unlock(lock);
+	preempt_enable();
+}
+EXPORT_SYMBOL(lg_local_unlock);
+
+void lg_local_lock_cpu(struct lglock *lg, int cpu)
+{
+	arch_spinlock_t *lock;
+
+	preempt_disable();
+	lock_acquire_shared(&lg->lock_dep_map, 0, 0, NULL, _RET_IP_);
+	lock = per_cpu_ptr(lg->lock, cpu);
+	arch_spin_lock(lock);
+}
+EXPORT_SYMBOL(lg_local_lock_cpu);
+
+void lg_local_unlock_cpu(struct lglock *lg, int cpu)
+{
+	arch_spinlock_t *lock;
+
+	lock_release(&lg->lock_dep_map, 1, _RET_IP_);
+	lock = per_cpu_ptr(lg->lock, cpu);
+	arch_spin_unlock(lock);
+	preempt_enable();
+}
+EXPORT_SYMBOL(lg_local_unlock_cpu);
+
+void lg_global_lock(struct lglock *lg)
+{
+	int i;
+
+	preempt_disable();
+	lock_acquire_exclusive(&lg->lock_dep_map, 0, 0, NULL, _RET_IP_);
+	for_each_possible_cpu(i) {
+		arch_spinlock_t *lock;
+		lock = per_cpu_ptr(lg->lock, i);
+		arch_spin_lock(lock);
+	}
+}
+EXPORT_SYMBOL(lg_global_lock);
+
+void lg_global_unlock(struct lglock *lg)
+{
+	int i;
+
+	lock_release(&lg->lock_dep_map, 1, _RET_IP_);
+	for_each_possible_cpu(i) {
+		arch_spinlock_t *lock;
+		lock = per_cpu_ptr(lg->lock, i);
+		arch_spin_unlock(lock);
+	}
+	preempt_enable();
+}
+EXPORT_SYMBOL(lg_global_unlock);


