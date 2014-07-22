Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982AbaGVBHy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 21:07:54 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:54366 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750800AbaGVBHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 21:07:51 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 1/3] PM: Create PM workqueue if runtime PM is not configured too
Date: Tue, 22 Jul 2014 03:24:27 +0200
Message-ID: <1470749.z3A6zRcAYh@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <9631666.En3K0jlGsY@vostro.rjw.lan>
References: <1907495.agrCMfRsQN@vostro.rjw.lan> <9631666.En3K0jlGsY@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The PM workqueue is going to be used by ACPI PM notify handlers
regardless of whether or not runtime PM is configured, so move
it out of #ifdef CONFIG_PM_RUNTIME.

Do that in three places in the ACPI device PM code.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 include/linux/pm_runtime.h |   11 +++++++++--
 kernel/power/main.c        |    4 ----
 2 files changed, 9 insertions(+), 6 deletions(-)

Index: linux-pm/include/linux/pm_runtime.h
===================================================================
--- linux-pm.orig/include/linux/pm_runtime.h
+++ linux-pm/include/linux/pm_runtime.h
@@ -24,11 +24,20 @@
 #define RPM_AUTO		0x08	/* Use autosuspend_delay */
 
 #ifdef CONFIG_PM
+extern struct workqueue_struct *pm_wq;
+
+static inline bool queue_pm_work(struct work_struct *work)
+{
+	return queue_work(pm_wq, work);
+}
+
 extern int pm_generic_runtime_suspend(struct device *dev);
 extern int pm_generic_runtime_resume(struct device *dev);
 extern int pm_runtime_force_suspend(struct device *dev);
 extern int pm_runtime_force_resume(struct device *dev);
 #else
+static inline bool queue_pm_work(struct work_struct *work) { return false; }
+
 static inline int pm_generic_runtime_suspend(struct device *dev) { return 0; }
 static inline int pm_generic_runtime_resume(struct device *dev) { return 0; }
 static inline int pm_runtime_force_suspend(struct device *dev) { return 0; }
@@ -37,8 +46,6 @@ static inline int pm_runtime_force_resum
 
 #ifdef CONFIG_PM_RUNTIME
 
-extern struct workqueue_struct *pm_wq;
-
 extern int __pm_runtime_idle(struct device *dev, int rpmflags);
 extern int __pm_runtime_suspend(struct device *dev, int rpmflags);
 extern int __pm_runtime_resume(struct device *dev, int rpmflags);
Index: linux-pm/kernel/power/main.c
===================================================================
--- linux-pm.orig/kernel/power/main.c
+++ linux-pm/kernel/power/main.c
@@ -616,7 +616,6 @@ static struct attribute_group attr_group
 	.attrs = g,
 };
 
-#ifdef CONFIG_PM_RUNTIME
 struct workqueue_struct *pm_wq;
 EXPORT_SYMBOL_GPL(pm_wq);
 
@@ -626,9 +625,6 @@ static int __init pm_start_workqueue(voi
 
 	return pm_wq ? 0 : -ENOMEM;
 }
-#else
-static inline int pm_start_workqueue(void) { return 0; }
-#endif
 
 static int __init pm_init(void)
 {

