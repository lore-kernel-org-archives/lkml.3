Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965526Ab3DPVxj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 17:53:39 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965470Ab3DPVxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 17:53:38 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, user-mode-linux-devel@lists.sourceforge.net,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH] um: Use generic idle loop
Date: Tue, 16 Apr 2013 23:53:29 +0200
Message-Id: <1366149209-24787-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/Kconfig.common   |  1 +
 arch/um/kernel/process.c | 27 ++++-----------------------
 2 files changed, 5 insertions(+), 23 deletions(-)

diff --git a/arch/um/Kconfig.common b/arch/um/Kconfig.common
index bceee66..5783406 100644
--- a/arch/um/Kconfig.common
+++ b/arch/um/Kconfig.common
@@ -12,6 +12,7 @@ config UML
 	select GENERIC_CPU_DEVICES
 	select GENERIC_IO
 	select GENERIC_CLOCKEVENTS
+	select GENERIC_IDLE_LOOP
 	select TTY # Needed for line.c
 
 config MMU
diff --git a/arch/um/kernel/process.c b/arch/um/kernel/process.c
index b462b13..bbcef52 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -210,33 +210,14 @@ void initial_thread_cb(void (*proc)(void *), void *arg)
 	kmalloc_ok = save_kmalloc_ok;
 }
 
-void default_idle(void)
+void arch_cpu_idle(void)
 {
 	unsigned long long nsecs;
 
-	while (1) {
-		/* endless idle loop with no priority at all */
-
-		/*
-		 * although we are an idle CPU, we do not want to
-		 * get into the scheduler unnecessarily.
-		 */
-		if (need_resched())
-			schedule();
-
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
-		nsecs = disable_timer();
-		idle_sleep(nsecs);
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
-	}
-}
-
-void cpu_idle(void)
-{
 	cpu_tasks[current_thread_info()->cpu].pid = os_getpid();
-	default_idle();
+	nsecs = disable_timer();
+	idle_sleep(nsecs);
+	local_irq_enable();
 }
 
 int __cant_sleep(void) {
-- 
1.8.1.4

