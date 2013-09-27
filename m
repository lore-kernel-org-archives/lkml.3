Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633Ab3I0Qrn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 12:47:43 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:49942 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab3I0Qrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 12:47:40 -0400
From: Abbas Raza <abbas_raza@mentor.com>
To: linux-kernel@vger.kernel.org
Cc: Abbas Raza <Abbas_Raza@mentor.com>
Subject: [PATCH] kthread_bind: don't wait in kthread_bind for presmp initcalls
Date: Fri, 27 Sep 2013 21:47:31 +0500
Message-Id: <1380300451-396-1-git-send-email-abbas_raza@mentor.com>
X-Mailer: git-send-email 1.8.3.2
X-OriginalArrivalTime: 27 Sep 2013 16:47:40.0560 (UTC) FILETIME=[47981100:01CEBBA1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abbas Raza <Abbas_Raza@mentor.com>

wait_task_inactive shouldn't be called in __kthread_bind for presmp
initcalls the same way it is done in !SMP case.

more info here:
http://permalink.gmane.org/gmane.linux.kernel.embedded/4046

This patch improves boot time for pre-smp initcalls as given below

boot time with this patch:

calling  spawn_ksoftirqd+0x0/0x30 @ 1
initcall spawn_ksoftirqd+0x0/0x30 returned 0 after 0 usecs

boot time without this patch:

calling  spawn_ksoftirqd+0x0/0x30 @ 1
initcall spawn_ksoftirqd+0x0/0x30 returned 0 after 19531 usecs

Signed-off-by: Abbas Raza <Abbas_Raza@mentor.com>
---
 kernel/kthread.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index 760e86d..28b5c4b 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -290,11 +290,17 @@ EXPORT_SYMBOL(kthread_create_on_node);
 
 static void __kthread_bind(struct task_struct *p, unsigned int cpu, long state)
 {
-	/* Must have done schedule() in kthread() before we set_task_cpu */
-	if (!wait_task_inactive(p, state)) {
-		WARN_ON(1);
-		return;
+	if (!((num_online_cpus() == 1) && !cpu)) {
+		/*
+		 * Must have done schedule() in kthread() before
+		 * we set_task_cpu
+		 */
+		if (!wait_task_inactive(p, state)) {
+			WARN_ON(1);
+			return;
+		}
 	}
+
 	/* It's safe because the task is inactive. */
 	do_set_cpus_allowed(p, cpumask_of(cpu));
 	p->flags |= PF_NO_SETAFFINITY;
-- 
1.8.3.2

