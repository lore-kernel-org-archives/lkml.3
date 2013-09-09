Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab3IIPbp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:31:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19599 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067Ab3IIP0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:26:44 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=dvIvxJ4_SCsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=1GToGMD1ptoA:10 a=VwQbUJbxAAAA:8 a=VcUiGOdTKjBeXruxuyoA:9 a=Zh68SRI7RUMA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130909143535.275563613@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 09 Sep 2013 10:35:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>, <stable-rt@vger.kernel.org>
Subject: [PATCH RT 07/16] kernel/cpu: fix cpu down problem if kthreads cpu is going down
References: <20130909143517.641735717@goodmis.org>
Content-Disposition: inline; filename=0007-kernel-cpu-fix-cpu-down-problem-if-kthread-s-cpu-is-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

If kthread is pinned to CPUx and CPUx is going down then we get into
trouble:
- first the unplug thread is created
- it will set itself to hp->unplug. As a result, every task that is
  going to take a lock, has to leave the CPU.
- the CPU_DOWN_PREPARE notifier are started. The worker thread will
  start a new process for the "high priority worker".
  Now kthread would like to take a lock but since it can't leave the CPU
  it will never complete its task.

We could fire the unplug thread after the notifier but then the cpu is
no longer marked "online" and the unplug thread will run on CPU0 which
was fixed before :)

So instead the unplug thread is started and kept waiting until the
notfier complete their work.

Cc: stable-rt@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 kernel/cpu.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 3bcbf99..25853dc 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -78,6 +78,7 @@ struct hotplug_pcp {
 	int refcount;
 	int grab_lock;
 	struct completion synced;
+	struct completion unplug_wait;
 #ifdef CONFIG_PREEMPT_RT_FULL
 	spinlock_t lock;
 #else
@@ -175,6 +176,7 @@ static int sync_unplug_thread(void *data)
 {
 	struct hotplug_pcp *hp = data;
 
+	wait_for_completion(&hp->unplug_wait);
 	preempt_disable();
 	hp->unplug = current;
 	wait_for_pinned_cpus(hp);
@@ -240,6 +242,14 @@ static void __cpu_unplug_sync(struct hotplug_pcp *hp)
 	wait_for_completion(&hp->synced);
 }
 
+static void __cpu_unplug_wait(unsigned int cpu)
+{
+	struct hotplug_pcp *hp = &per_cpu(hotplug_pcp, cpu);
+
+	complete(&hp->unplug_wait);
+	wait_for_completion(&hp->synced);
+}
+
 /*
  * Start the sync_unplug_thread on the target cpu and wait for it to
  * complete.
@@ -263,6 +273,7 @@ static int cpu_unplug_begin(unsigned int cpu)
 	tell_sched_cpu_down_begin(cpu);
 
 	init_completion(&hp->synced);
+	init_completion(&hp->unplug_wait);
 
 	hp->sync_tsk = kthread_create(sync_unplug_thread, hp, "sync_unplug/%d", cpu);
 	if (IS_ERR(hp->sync_tsk)) {
@@ -278,8 +289,7 @@ static int cpu_unplug_begin(unsigned int cpu)
 	 * wait for tasks that are going to enter these sections and
 	 * we must not have them block.
 	 */
-	__cpu_unplug_sync(hp);
-
+	wake_up_process(hp->sync_tsk);
 	return 0;
 }
 
@@ -524,6 +534,8 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 		goto out_release;
 	}
 
+	__cpu_unplug_wait(cpu);
+
 	/* Notifiers are done. Don't let any more tasks pin this CPU. */
 	cpu_unplug_sync(cpu);
 
-- 
1.7.10.4


