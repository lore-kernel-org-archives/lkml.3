Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233AbaF1AEo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 20:04:44 -0400
Received: from mail-pa0-f73.google.com ([209.85.220.73]:65394 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbaF1AEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 20:04:42 -0400
From: Derek Basehore <dbasehore@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>,
        Ian Campbell <ian.campbell@citrix.com>, xen-devel@lists.xenproject.org,
        Derek Basehore <dbasehore@chromium.org>
Subject: [PATCH v1 1/2] genirq: Fix error path for resuming irqs
Date: Fri, 27 Jun 2014 17:04:24 -0700
Message-Id: <1403913865-31614-1-git-send-email-dbasehore@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case of a late abort to suspend/hibernate, irqs marked with
IRQF_EARLY_RESUME will not be enabled. This is due to syscore_resume not getting
called on these paths.

This can happen with a pm test for platform, a late wakeup irq, and other
instances. This change removes the function from syscore and calls it explicitly
in suspend, hibernate, etc.

This regression was introduced in 9bab0b7f "genirq: Add IRQF_RESUME_EARLY"

Signed-off-by: Derek Basehore <dbasehore@chromium.org>
---
 drivers/base/power/main.c |  5 ++++-
 drivers/xen/manage.c      |  5 ++++-
 include/linux/interrupt.h |  1 +
 include/linux/pm.h        |  2 +-
 kernel/irq/pm.c           | 17 +++--------------
 kernel/kexec.c            |  2 +-
 kernel/power/hibernate.c  |  6 +++---
 kernel/power/suspend.c    |  2 +-
 8 files changed, 18 insertions(+), 22 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index bf41296..a087473 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -712,8 +712,10 @@ static void dpm_resume_early(pm_message_t state)
  * dpm_resume_start - Execute "noirq" and "early" device callbacks.
  * @state: PM transition of the system being carried out.
  */
-void dpm_resume_start(pm_message_t state)
+void dpm_resume_start(pm_message_t state, bool enable_early_irqs)
 {
+	if (enable_early_irqs)
+		early_resume_device_irqs();
 	dpm_resume_noirq(state);
 	dpm_resume_early(state);
 }
@@ -1132,6 +1134,7 @@ static int dpm_suspend_noirq(pm_message_t state)
 	if (error) {
 		suspend_stats.failed_suspend_noirq++;
 		dpm_save_failed_step(SUSPEND_SUSPEND_NOIRQ);
+		early_resume_device_irqs();
 		dpm_resume_noirq(resume_event(state));
 	} else {
 		dpm_show_time(starttime, state, "noirq");
diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
index c3667b2..d387cdf 100644
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -68,6 +68,7 @@ static int xen_suspend(void *data)
 	err = syscore_suspend();
 	if (err) {
 		pr_err("%s: system core suspend failed: %d\n", __func__, err);
+		early_resume_device_irqs();
 		return err;
 	}
 
@@ -92,6 +93,8 @@ static int xen_suspend(void *data)
 		xen_timer_resume();
 	}
 
+	early_resume_device_irqs();
+
 	syscore_resume();
 
 	return 0;
@@ -137,7 +140,7 @@ static void do_suspend(void)
 
 	raw_notifier_call_chain(&xen_resume_notifier, 0, NULL);
 
-	dpm_resume_start(si.cancelled ? PMSG_THAW : PMSG_RESTORE);
+	dpm_resume_start(si.cancelled ? PMSG_THAW : PMSG_RESTORE, false);
 
 	if (err) {
 		pr_err("failed to start xen_suspend: %d\n", err);
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 698ad05..7f390e3 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -193,6 +193,7 @@ extern void irq_wake_thread(unsigned int irq, void *dev_id);
 /* The following three functions are for the core kernel use only. */
 extern void suspend_device_irqs(void);
 extern void resume_device_irqs(void);
+extern void early_resume_device_irqs(void);
 #ifdef CONFIG_PM_SLEEP
 extern int check_wakeup_irqs(void);
 #else
diff --git a/include/linux/pm.h b/include/linux/pm.h
index 72c0fe0..ae5b26a 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -677,7 +677,7 @@ struct dev_pm_domain {
 
 #ifdef CONFIG_PM_SLEEP
 extern void device_pm_lock(void);
-extern void dpm_resume_start(pm_message_t state);
+extern void dpm_resume_start(pm_message_t state, bool enable_early_irqs);
 extern void dpm_resume_end(pm_message_t state);
 extern void dpm_resume(pm_message_t state);
 extern void dpm_complete(pm_message_t state);
diff --git a/kernel/irq/pm.c b/kernel/irq/pm.c
index abcd6ca..b07dc9c 100644
--- a/kernel/irq/pm.c
+++ b/kernel/irq/pm.c
@@ -60,26 +60,15 @@ static void resume_irqs(bool want_early)
 }
 
 /**
- * irq_pm_syscore_ops - enable interrupt lines early
+ * early_resume_device_irqs - enable interrupt lines early
  *
  * Enable all interrupt lines with %IRQF_EARLY_RESUME set.
  */
-static void irq_pm_syscore_resume(void)
+void early_resume_device_irqs(void)
 {
 	resume_irqs(true);
 }
-
-static struct syscore_ops irq_pm_syscore_ops = {
-	.resume		= irq_pm_syscore_resume,
-};
-
-static int __init irq_pm_init_ops(void)
-{
-	register_syscore_ops(&irq_pm_syscore_ops);
-	return 0;
-}
-
-device_initcall(irq_pm_init_ops);
+EXPORT_SYMBOL_GPL(early_resume_device_irqs);
 
 /**
  * resume_device_irqs - enable interrupt lines disabled by suspend_device_irqs()
diff --git a/kernel/kexec.c b/kernel/kexec.c
index 369f41a..272853b 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1700,7 +1700,7 @@ int kernel_kexec(void)
 		local_irq_enable();
  Enable_cpus:
 		enable_nonboot_cpus();
-		dpm_resume_start(PMSG_RESTORE);
+		dpm_resume_start(PMSG_RESTORE, true);
  Resume_devices:
 		dpm_resume_end(PMSG_RESTORE);
  Resume_console:
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index fcc2611..1d6dd56 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -325,7 +325,7 @@ static int create_image(int platform_mode)
 	platform_finish(platform_mode);
 
 	dpm_resume_start(in_suspend ?
-		(error ? PMSG_RECOVER : PMSG_THAW) : PMSG_RESTORE);
+		(error ? PMSG_RECOVER : PMSG_THAW) : PMSG_RESTORE, true);
 
 	return error;
 }
@@ -482,7 +482,7 @@ static int resume_target_kernel(bool platform_mode)
  Cleanup:
 	platform_restore_cleanup(platform_mode);
 
-	dpm_resume_start(PMSG_RECOVER);
+	dpm_resume_start(PMSG_RECOVER, true);
 
 	return error;
 }
@@ -574,7 +574,7 @@ int hibernation_platform_enter(void)
  Platform_finish:
 	hibernation_ops->finish();
 
-	dpm_resume_start(PMSG_RESTORE);
+	dpm_resume_start(PMSG_RESTORE, true);
 
  Resume_devices:
 	entering_platform_hibernation = false;
diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index 4dd8822..3597c72 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -281,7 +281,7 @@ static int suspend_enter(suspend_state_t state, bool *wakeup)
 	if (need_suspend_ops(state) && suspend_ops->wake)
 		suspend_ops->wake();
 
-	dpm_resume_start(PMSG_RESUME);
+	dpm_resume_start(PMSG_RESUME, true);
 
  Platform_finish:
 	if (need_suspend_ops(state) && suspend_ops->finish)
-- 
2.0.0.526.g5318336

