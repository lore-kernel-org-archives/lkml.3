Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab3HASWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 14:22:17 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:25226 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab3HASWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 14:22:15 -0400
Message-ID: <201308011822.r71IMEhW020347@farm-0021.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 30 Jul 2013 17:18:05 -0400
Subject: [PATCH] tile: various minor cleanups to hardwall subsystem
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First, clean up active hardwalls in exit_thread().  This is a better
place than in arch_release_thread_info().

Second, mask out any non-online cpus from the cpumask after
validating any required semantics of the cpu set.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/hardwall.c | 10 +++++++++-
 arch/tile/kernel/process.c  | 23 +++++++++--------------
 2 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/arch/tile/kernel/hardwall.c b/arch/tile/kernel/hardwall.c
index 38ac189..7db8893 100644
--- a/arch/tile/kernel/hardwall.c
+++ b/arch/tile/kernel/hardwall.c
@@ -540,6 +540,14 @@ static struct hardwall_info *hardwall_create(struct hardwall_type *hwt,
 		}
 	}
 
+	/*
+	 * Eliminate cpus that are not part of this Linux client.
+	 * Note that this allows for configurations that we might not want to
+	 * support, such as one client on every even cpu, another client on
+	 * every odd cpu.
+	 */
+	cpumask_and(&info->cpumask, &info->cpumask, cpu_online_mask);
+
 	/* Confirm it doesn't overlap and add it to the list. */
 	spin_lock_irqsave(&hwt->lock, flags);
 	list_for_each_entry(iter, &hwt->list, list) {
@@ -612,7 +620,7 @@ static int hardwall_activate(struct hardwall_info *info)
 
 /*
  * Deactivate a task's hardwall.  Must hold lock for hardwall_type.
- * This method may be called from free_task(), so we don't want to
+ * This method may be called from exit_thread(), so we don't want to
  * rely on too many fields of struct task_struct still being valid.
  * We assume the cpus_allowed, pid, and comm fields are still valid.
  */
diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index 8ac3044..8d6c51d 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -74,19 +74,6 @@ void arch_release_thread_info(struct thread_info *info)
 {
 	struct single_step_state *step_state = info->step_state;
 
-#ifdef CONFIG_HARDWALL
-	/*
-	 * We free a thread_info from the context of the task that has
-	 * been scheduled next, so the original task is already dead.
-	 * Calling deactivate here just frees up the data structures.
-	 * If the task we're freeing held the last reference to a
-	 * hardwall fd, it would have been released prior to this point
-	 * anyway via exit_files(), and the hardwall_task.info pointers
-	 * would be NULL by now.
-	 */
-	hardwall_deactivate_all(info->task);
-#endif
-
 	if (step_state) {
 
 		/*
@@ -564,7 +551,15 @@ void flush_thread(void)
  */
 void exit_thread(void)
 {
-	/* Nothing */
+#ifdef CONFIG_HARDWALL
+	/*
+	 * Remove the task from the list of tasks that are associated
+	 * with any live hardwalls.  (If the task that is exiting held
+	 * the last reference to a hardwall fd, it would already have
+	 * been released and deactivated at this point.)
+	 */
+	hardwall_deactivate_all(current);
+#endif
 }
 
 void show_regs(struct pt_regs *regs)
-- 
1.8.3.1

