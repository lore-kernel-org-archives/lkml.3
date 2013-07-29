Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab3G2RTa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 13:19:30 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:43394 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813Ab3G2RT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 13:19:28 -0400
From: Abbas Raza <abbas_raza@mentor.com>
To: linux-kernel@vger.kernel.org
Cc: Abbas Raza <Abbas_Raza@mentor.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH] sched: don't wait in kthread_bind for presmp initcalls
Date: Mon, 29 Jul 2013 22:19:08 +0500
Message-Id: <1375118348-25253-1-git-send-email-abbas_raza@mentor.com>
X-Mailer: git-send-email 1.8.3.2
X-OriginalArrivalTime: 29 Jul 2013 17:19:23.0336 (UTC) FILETIME=[C4F3A480:01CE8C7F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abbas Raza <Abbas_Raza@mentor.com>

wait_task_inactive shouldn't be called in kthread_bind for presmp
initcalls the same way it is done in !SMP case.

more info here:
http://permalink.gmane.org/gmane.linux.kernel.embedded/4046

This patch improves boot time for pre-smp initcalls as given below

initcall spawn_ksoftirqd+0x0/0x54 returned 0 after 0 usecs
initcall init_workqueues+0x0/0x358 returned 0 after 0 usecs
initcall cpu_stop_init+0x0/0xcc returned 0 after 0 usecs

boot time without this patch:

initcall spawn_ksoftirqd+0x0/0x54 returned 0 after 9765 usecs
initcall init_workqueues+0x0/0x358 returned 0 after 9765 usecs
initcall cpu_stop_init+0x0/0xcc returned 0 after 19531 usecs

Signed-off-by: Abbas Raza <Abbas_Raza@mentor.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>

---
 kernel/kthread.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index b579af5..80f19b5 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -221,10 +221,15 @@ EXPORT_SYMBOL(kthread_create_on_node);
  */
 void kthread_bind(struct task_struct *p, unsigned int cpu)
 {
-	/* Must have done schedule() in kthread() before we set_task_cpu */
-	if (!wait_task_inactive(p, TASK_UNINTERRUPTIBLE)) {
-		WARN_ON(1);
-		return;
+	if (!((num_online_cpus() == 1) && !cpu)) {
+		/*
+		 * Must have done schedule() in kthread() before
+		 * we set_task_cpu
+		 */
+		if (!wait_task_inactive(p, TASK_UNINTERRUPTIBLE)) {
+			WARN_ON(1);
+			return;
+		}
 	}
 
 	/* It's safe because the task is inactive. */
-- 
1.8.3.2

