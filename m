Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab3BJF6z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 00:58:55 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:51069 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab3BJF6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 00:58:45 -0500
From: Len Brown <lenb@kernel.org>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        linux-m32r@ml.linux-m32r.org
Subject: [PATCH 10/16] m32r idle: delete pm_idle, and other dead idle code
Date: Sun, 10 Feb 2013 00:58:17 -0500
Message-Id: <50145c48954ee5626107dd1aa4c2ed95dd1bc2b6.1360475150.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1360475903-30007-1-git-send-email-lenb@kernel.org>
References: <1360475903-30007-1-git-send-email-lenb@kernel.org>
In-Reply-To: <2b219d07e0f287c2c713f5465fc8646158fa986e.1360475150.git.len.brown@intel.com>
References: <2b219d07e0f287c2c713f5465fc8646158fa986e.1360475150.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

All paths on m32r lead to cpu_relax().
So delete the dead code and simply call cpu_relax() directly.

Signed-off-by: Len Brown <len.brown@intel.com>
Cc: linux-m32r@ml.linux-m32r.org
---
 arch/m32r/kernel/process.c | 51 ++--------------------------------------------
 1 file changed, 2 insertions(+), 49 deletions(-)

diff --git a/arch/m32r/kernel/process.c b/arch/m32r/kernel/process.c
index 765d0f5..bde899e 100644
--- a/arch/m32r/kernel/process.c
+++ b/arch/m32r/kernel/process.c
@@ -44,36 +44,10 @@ unsigned long thread_saved_pc(struct task_struct *tsk)
 	return tsk->thread.lr;
 }
 
-/*
- * Powermanagement idle function, if any..
- */
-static void (*pm_idle)(void) = NULL;
-
 void (*pm_power_off)(void) = NULL;
 EXPORT_SYMBOL(pm_power_off);
 
 /*
- * We use this is we don't have any better
- * idle routine..
- */
-static void default_idle(void)
-{
-	/* M32R_FIXME: Please use "cpu_sleep" mode.  */
-	cpu_relax();
-}
-
-/*
- * On SMP it's slightly faster (but much more power-consuming!)
- * to poll the ->work.need_resched flag instead of waiting for the
- * cross-CPU IPI to arrive. Use this option with caution.
- */
-static void poll_idle (void)
-{
-	/* M32R_FIXME */
-	cpu_relax();
-}
-
-/*
  * The idle thread. There's no useful work to be
  * done, so just try to conserve power and have a
  * low exit latency (ie sit in a loop waiting for
@@ -84,14 +58,8 @@ void cpu_idle (void)
 	/* endless idle loop with no priority at all */
 	while (1) {
 		rcu_idle_enter();
-		while (!need_resched()) {
-			void (*idle)(void) = pm_idle;
-
-			if (!idle)
-				idle = default_idle;
-
-			idle();
-		}
+		while (!need_resched())
+			cpu_relax();
 		rcu_idle_exit();
 		schedule_preempt_disabled();
 	}
@@ -120,21 +88,6 @@ void machine_power_off(void)
 	/* M32R_FIXME */
 }
 
-static int __init idle_setup (char *str)
-{
-	if (!strncmp(str, "poll", 4)) {
-		printk("using poll in idle threads.\n");
-		pm_idle = poll_idle;
-	} else if (!strncmp(str, "sleep", 4)) {
-		printk("using sleep in idle threads.\n");
-		pm_idle = default_idle;
-	}
-
-	return 1;
-}
-
-__setup("idle=", idle_setup);
-
 void show_regs(struct pt_regs * regs)
 {
 	printk("\n");
-- 
1.8.1.3.535.ga923c31

