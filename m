Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab3H1VH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 17:07:29 -0400
Received: from mail-qe0-f74.google.com ([209.85.128.74]:48447 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755478Ab3H1VH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 17:07:27 -0400
From: Jamie Liu <jamieliu@google.com>
To: Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Jamie Liu <jamieliu@google.com>
Subject: [PATCH] workqueue: defer to waiting stop_machine
Date: Wed, 28 Aug 2013 14:07:12 -0700
Message-Id: <1377724032-12199-1-git-send-email-jamieliu@google.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A kworker running while stop_machine is waiting for CPUs can cause a
lockup if a work on the workqueue continuously reschedules itself due to
inability to make progress while stop_machine is pending. Fix this by
having workers stop working if stop_machine is pending.

Details:

Some ATA commands require that they run exclusively of other commands on
the same ATA port. To support this, ATA ports allow constituent links to
temporarily request exclusive access to the port by setting
ata_port.excl_link. If a link requests exclusive access, but must
temporarily delay the command, exclusive access remains held (to avoid
starving the command), preventing commands from other links on the same
port from proceeding.

Consider the following sequence of events:

1. An ATA command sent by the SCSI subsystem is dispatched to a
controller that requires excl_link for that command (as decided by e.g.
sil24_qc_defer() in drivers/ata/sata_sil24.c). The controller driver
sets excl_link and returns ATA_DEFER_PORT, causing scsi_dispatch_cmd()
to schedule a scsi_requeue_run_queue() work to retry the command.

2. A different command from the same ATA link is issued successfully.

3. The scsi_requeue_run_queue() work executes. scsi_request_fn() does
not dispatch the delayed command because the SCSI host is still busy
serving the command issued in (2), and instead calls blk_delay_queue()
to reschedule the command to be retried after SCSI_QUEUE_DELAY.

4. A command from a different ATA link on the same port is delayed
because the command from (1) set excl_link, causing scsi_dispatch_cmd()
to schedule a scsi_requeue_run_queue() work to retry the command.

5. The CPU whose gcwq contains the work from (4) switches to
worker_thread.

6. stop_machine() is called. All CPUs, except for the CPU running the
kworker in (5), switch to cpu_stopper_thread and enter
stop_machine_cpu_stop(), waiting for the CPU in (5) to switch as well.

7. The delay from (3) expires, causing the scsi_requeue_run_queue()
(that will retry the original delayed command from (1)) to be placed on
the gcwq for a CPU currently in cpu_stopper_thread.

8. The kworker on the CPU in (5) executes the scsi_requeue_run_queue()
work from (4). As in (4), the retried command is delayed due to
excl_link and causes another scsi_requeue_run_queue() work to be
rescheduled on the same CPU.

The machine is now locked up; one CPU is stuck in worker_thread, and all
others are stuck in cpu_stopper_thread. This is difficult to fix from
the ATA side, since the need for excl_link is legitimate, and difficult
to fix from the SCSI side, since the need to retry the request is also
legitimate (and performance-sensitive).

Signed-off-by: Jamie Liu <jamieliu@google.com>
---
 include/linux/stop_machine.h | 13 +++++++++++++
 kernel/stop_machine.c        | 16 ++++++++++++++++
 kernel/workqueue.c           |  4 +++-
 3 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/include/linux/stop_machine.h b/include/linux/stop_machine.h
index 3b5e910..a315f92 100644
--- a/include/linux/stop_machine.h
+++ b/include/linux/stop_machine.h
@@ -127,6 +127,14 @@ int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus);
 int stop_machine_from_inactive_cpu(int (*fn)(void *), void *data,
 				   const struct cpumask *cpus);
 
+/**
+ * stop_machine_pending: check if a stop_machine is waiting on this CPU
+ *
+ * CONTEXT:
+ * Preemption must be disabled.
+ */
+bool stop_machine_pending(void);
+
 #else	 /* CONFIG_STOP_MACHINE && CONFIG_SMP */
 
 static inline int __stop_machine(int (*fn)(void *), void *data,
@@ -152,5 +160,10 @@ static inline int stop_machine_from_inactive_cpu(int (*fn)(void *), void *data,
 	return __stop_machine(fn, data, cpus);
 }
 
+static inline bool stop_machine_pending(void)
+{
+	return false;
+}
+
 #endif	/* CONFIG_STOP_MACHINE && CONFIG_SMP */
 #endif	/* _LINUX_STOP_MACHINE */
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index c09f295..4b99914 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -541,4 +541,20 @@ int stop_machine_from_inactive_cpu(int (*fn)(void *), void *data,
 	return ret ?: done.ret;
 }
 
+bool stop_machine_pending(void)
+{
+	struct cpu_stopper *stopper;
+	unsigned long flags;
+	bool has_pending;
+
+	if (unlikely(!stop_machine_initialized))
+		return false;
+
+	stopper = &per_cpu(cpu_stopper, smp_processor_id());
+	spin_lock_irqsave(&stopper->lock, flags);
+	has_pending = !list_empty(&stopper->works);
+	spin_unlock_irqrestore(&stopper->lock, flags);
+	return has_pending;
+}
+
 #endif	/* CONFIG_STOP_MACHINE */
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 7f5d4be..cd23fac 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -47,6 +47,7 @@
 #include <linux/nodemask.h>
 #include <linux/moduleparam.h>
 #include <linux/uaccess.h>
+#include <linux/stop_machine.h>
 
 #include "workqueue_internal.h"
 
@@ -734,7 +735,8 @@ static bool may_start_working(struct worker_pool *pool)
 static bool keep_working(struct worker_pool *pool)
 {
 	return !list_empty(&pool->worklist) &&
-		atomic_read(&pool->nr_running) <= 1;
+		atomic_read(&pool->nr_running) <= 1 &&
+		likely(!stop_machine_pending());
 }
 
 /* Do we need a new worker?  Called from manager. */
-- 
1.8.3.1

