Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852Ab3K0Pff (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 10:35:35 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:64187 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756767Ab3K0Pf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 10:35:28 -0500
From: Ulf Hansson <ulf.hansson@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, linux-pm@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kevin Hilman <khilman@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 2/5] PM / Runtime: Implement the pm_generic_runtime functions for CONFIG_PM
Date: Wed, 27 Nov 2013 16:34:57 +0100
Message-Id: <1385566500-7666-3-git-send-email-ulf.hansson@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385566500-7666-1-git-send-email-ulf.hansson@linaro.org>
References: <1385566500-7666-1-git-send-email-ulf.hansson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pm_generic_runtime_suspend|resume functions were implemented within
CONFIG_PM_RUNTIME.

As we also may use runtime PM callbacks during system suspend, to put
devices into low power state, we need to move the implementation of
pm_generic_runtime_suspend|resume to CONFIG_PM.

This change prevents the platform bus from by-passing driver's runtime
PM callbacks while only CONFIG_PM_SLEEP and not CONFIG_PM_RUNTIME is
being used.

Cc: Kevin Hilman <khilman@linaro.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/base/power/generic_ops.c |    4 ++--
 include/linux/pm_runtime.h       |   12 ++++++++----
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/base/power/generic_ops.c b/drivers/base/power/generic_ops.c
index 8e78ad1..a4c6cb0 100644
--- a/drivers/base/power/generic_ops.c
+++ b/drivers/base/power/generic_ops.c
@@ -10,7 +10,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/export.h>
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 /**
  * pm_generic_runtime_suspend - Generic runtime suspend callback for subsystems.
  * @dev: Device to suspend.
@@ -48,7 +48,7 @@ int pm_generic_runtime_resume(struct device *dev)
 	return ret;
 }
 EXPORT_SYMBOL_GPL(pm_generic_runtime_resume);
-#endif /* CONFIG_PM_RUNTIME */
+#endif /* CONFIG_PM */
 
 #ifdef CONFIG_PM_SLEEP
 /**
diff --git a/include/linux/pm_runtime.h b/include/linux/pm_runtime.h
index 6fa7cea..16c9a62 100644
--- a/include/linux/pm_runtime.h
+++ b/include/linux/pm_runtime.h
@@ -23,6 +23,14 @@
 					    usage_count */
 #define RPM_AUTO		0x08	/* Use autosuspend_delay */
 
+#ifdef CONFIG_PM
+extern int pm_generic_runtime_suspend(struct device *dev);
+extern int pm_generic_runtime_resume(struct device *dev);
+#else
+static inline int pm_generic_runtime_suspend(struct device *dev) { return 0; }
+static inline int pm_generic_runtime_resume(struct device *dev) { return 0; }
+#endif
+
 #ifdef CONFIG_PM_RUNTIME
 
 extern struct workqueue_struct *pm_wq;
@@ -37,8 +45,6 @@ extern void pm_runtime_enable(struct device *dev);
 extern void __pm_runtime_disable(struct device *dev, bool check_resume);
 extern void pm_runtime_allow(struct device *dev);
 extern void pm_runtime_forbid(struct device *dev);
-extern int pm_generic_runtime_suspend(struct device *dev);
-extern int pm_generic_runtime_resume(struct device *dev);
 extern void pm_runtime_no_callbacks(struct device *dev);
 extern void pm_runtime_irq_safe(struct device *dev);
 extern void __pm_runtime_use_autosuspend(struct device *dev, bool use);
@@ -142,8 +148,6 @@ static inline bool pm_runtime_active(struct device *dev) { return true; }
 static inline bool pm_runtime_status_suspended(struct device *dev) { return false; }
 static inline bool pm_runtime_enabled(struct device *dev) { return false; }
 
-static inline int pm_generic_runtime_suspend(struct device *dev) { return 0; }
-static inline int pm_generic_runtime_resume(struct device *dev) { return 0; }
 static inline void pm_runtime_no_callbacks(struct device *dev) {}
 static inline void pm_runtime_irq_safe(struct device *dev) {}
 
-- 
1.7.9.5

