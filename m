Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab3C2O1h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 10:27:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:58715 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755348Ab3C2O1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 10:27:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,373,1363158000"; 
   d="scan'208";a="309147570"
From: Zhang Rui <rui.zhang@intel.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: amit.daniel@samsung.com, durgadoss.r@intel.com, andi@lisas.de,
        eduardo.valentin@ti.com, Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH V2 2/3] Thermal: build thermal governors into thermal_sys module
Date: Fri, 29 Mar 2013 22:26:35 +0800
Message-Id: <1364567196-3560-3-git-send-email-rui.zhang@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364567196-3560-1-git-send-email-rui.zhang@intel.com>
References: <1364567196-3560-1-git-send-email-rui.zhang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The thermal governors are part of the thermal framework,
rather than a seperate feature/module.
Because the generic thermal layer can not work without
thermal governors, and it must load the thermal governors
during its initialization.

Build them into one module in this patch.

This also fix a problem that the generic thermal layer does not
work when CONFIG_THERMAL=m and CONFIG_THERMAL_GOV_XXX=y.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 Documentation/thermal/sysfs-api.txt |    8 -----
 drivers/thermal/Makefile            |    6 ++--
 drivers/thermal/fair_share.c        |   15 ++-------
 drivers/thermal/step_wise.c         |   16 ++--------
 drivers/thermal/thermal_core.c      |   59 ++++++++++++++++++++++++++++-------
 drivers/thermal/thermal_core.h      |   27 ++++++++++++++++
 drivers/thermal/user_space.c        |   15 ++-------
 include/linux/thermal.h             |    4 ---
 8 files changed, 84 insertions(+), 66 deletions(-)

diff --git a/Documentation/thermal/sysfs-api.txt b/Documentation/thermal/sysfs-api.txt
index 6859661..6eac27a 100644
--- a/Documentation/thermal/sysfs-api.txt
+++ b/Documentation/thermal/sysfs-api.txt
@@ -375,11 +375,3 @@ platform data is provided, this uses the step_wise throttling policy.
 This function serves as an arbitrator to set the state of a cooling
 device. It sets the cooling device to the deepest cooling state if
 possible.
-
-5.5:thermal_register_governor:
-This function lets the various thermal governors to register themselves
-with the Thermal framework. At run time, depending on a zone's platform
-data, a particular governor is used for throttling.
-
-5.6:thermal_unregister_governor:
-This function unregisters a governor from the thermal framework.
diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
index b2009bd..b7fffc7 100644
--- a/drivers/thermal/Makefile
+++ b/drivers/thermal/Makefile
@@ -6,9 +6,9 @@ obj-$(CONFIG_THERMAL)		+= thermal_sys.o
 thermal_sys-y			+= thermal_core.o
 
 # governors
-obj-$(CONFIG_THERMAL_GOV_FAIR_SHARE)	+= fair_share.o
-obj-$(CONFIG_THERMAL_GOV_STEP_WISE)	+= step_wise.o
-obj-$(CONFIG_THERMAL_GOV_USER_SPACE)	+= user_space.o
+thermal_sys-$(CONFIG_THERMAL_GOV_FAIR_SHARE)	+= fair_share.o
+thermal_sys-$(CONFIG_THERMAL_GOV_STEP_WISE)	+= step_wise.o
+thermal_sys-$(CONFIG_THERMAL_GOV_USER_SPACE)	+= user_space.o
 
 # cpufreq cooling
 obj-$(CONFIG_CPU_THERMAL)	+= cpu_cooling.o
diff --git a/drivers/thermal/fair_share.c b/drivers/thermal/fair_share.c
index 792479f..944ba2f 100644
--- a/drivers/thermal/fair_share.c
+++ b/drivers/thermal/fair_share.c
@@ -22,9 +22,6 @@
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#include <linux/module.h>
 #include <linux/thermal.h>
 
 #include "thermal_core.h"
@@ -111,23 +108,15 @@ static int fair_share_throttle(struct thermal_zone_device *tz, int trip)
 static struct thermal_governor thermal_gov_fair_share = {
 	.name		= "fair_share",
 	.throttle	= fair_share_throttle,
-	.owner		= THIS_MODULE,
 };
 
-static int __init thermal_gov_fair_share_init(void)
+int thermal_gov_fair_share_register(void)
 {
 	return thermal_register_governor(&thermal_gov_fair_share);
 }
 
-static void __exit thermal_gov_fair_share_exit(void)
+void thermal_gov_fair_share_unregister(void)
 {
 	thermal_unregister_governor(&thermal_gov_fair_share);
 }
 
-/* This should load after thermal framework */
-fs_initcall(thermal_gov_fair_share_init);
-module_exit(thermal_gov_fair_share_exit);
-
-MODULE_AUTHOR("Durgadoss R");
-MODULE_DESCRIPTION("A simple weight based thermal throttling governor");
-MODULE_LICENSE("GPL");
diff --git a/drivers/thermal/step_wise.c b/drivers/thermal/step_wise.c
index 407cde3..a6c9666 100644
--- a/drivers/thermal/step_wise.c
+++ b/drivers/thermal/step_wise.c
@@ -22,9 +22,6 @@
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#include <linux/module.h>
 #include <linux/thermal.h>
 
 #include "thermal_core.h"
@@ -180,23 +177,14 @@ static int step_wise_throttle(struct thermal_zone_device *tz, int trip)
 static struct thermal_governor thermal_gov_step_wise = {
 	.name		= "step_wise",
 	.throttle	= step_wise_throttle,
-	.owner		= THIS_MODULE,
 };
 
-static int __init thermal_gov_step_wise_init(void)
+int thermal_gov_step_wise_register(void)
 {
 	return thermal_register_governor(&thermal_gov_step_wise);
 }
 
-static void __exit thermal_gov_step_wise_exit(void)
+void thermal_gov_step_wise_unregister(void)
 {
 	thermal_unregister_governor(&thermal_gov_step_wise);
 }
-
-/* This should load after thermal framework */
-fs_initcall(thermal_gov_step_wise_init);
-module_exit(thermal_gov_step_wise_exit);
-
-MODULE_AUTHOR("Durgadoss R");
-MODULE_DESCRIPTION("A step-by-step thermal throttling governor");
-MODULE_LICENSE("GPL");
diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 5b7863a..0107a82 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -99,7 +99,6 @@ int thermal_register_governor(struct thermal_governor *governor)
 
 	return err;
 }
-EXPORT_SYMBOL_GPL(thermal_register_governor);
 
 void thermal_unregister_governor(struct thermal_governor *governor)
 {
@@ -127,7 +126,6 @@ void thermal_unregister_governor(struct thermal_governor *governor)
 	mutex_unlock(&thermal_governor_lock);
 	return;
 }
-EXPORT_SYMBOL_GPL(thermal_unregister_governor);
 
 static int get_idr(struct idr *idr, struct mutex *lock, int *id)
 {
@@ -1858,30 +1856,69 @@ static inline int genetlink_init(void) { return 0; }
 static inline void genetlink_exit(void) {}
 #endif /* !CONFIG_NET */
 
+static int __init thermal_register_governors(void)
+{
+	int result;
+
+	result = thermal_gov_step_wise_register();
+	if (result)
+		return result;
+
+	result = thermal_gov_fair_share_register();
+	if (result)
+		return result;
+
+	return thermal_gov_user_space_register();
+}
+
+static void __exit thermal_unregister_governors(void)
+{
+	thermal_gov_step_wise_unregister();
+	thermal_gov_fair_share_unregister();
+	thermal_gov_user_space_unregister();
+}
+
 static int __init thermal_init(void)
 {
-	int result = 0;
+	int result;
+
+	result = thermal_register_governors();
+	if (result)
+		goto error;
 
 	result = class_register(&thermal_class);
-	if (result) {
-		idr_destroy(&thermal_tz_idr);
-		idr_destroy(&thermal_cdev_idr);
-		mutex_destroy(&thermal_idr_lock);
-		mutex_destroy(&thermal_list_lock);
-		return result;
-	}
+	if (result)
+		goto unregister_governors;
+
 	result = genetlink_init();
+	if (result)
+		goto unregister_class;
+
+	return 0;
+
+unregister_governors:
+	thermal_unregister_governors();
+unregister_class:
+	class_unregister(&thermal_class);
+error:
+	idr_destroy(&thermal_tz_idr);
+	idr_destroy(&thermal_cdev_idr);
+	mutex_destroy(&thermal_idr_lock);
+	mutex_destroy(&thermal_list_lock);
+	mutex_destroy(&thermal_governor_lock);
 	return result;
 }
 
 static void __exit thermal_exit(void)
 {
+	genetlink_exit();
 	class_unregister(&thermal_class);
+	thermal_unregister_governors();
 	idr_destroy(&thermal_tz_idr);
 	idr_destroy(&thermal_cdev_idr);
 	mutex_destroy(&thermal_idr_lock);
 	mutex_destroy(&thermal_list_lock);
-	genetlink_exit();
+	mutex_destroy(&thermal_governor_lock);
 }
 
 fs_initcall(thermal_init);
diff --git a/drivers/thermal/thermal_core.h b/drivers/thermal/thermal_core.h
index 0d3205a..7cf2f66 100644
--- a/drivers/thermal/thermal_core.h
+++ b/drivers/thermal/thermal_core.h
@@ -50,4 +50,31 @@ struct thermal_instance {
 	struct list_head cdev_node; /* node in cdev->thermal_instances */
 };
 
+int thermal_register_governor(struct thermal_governor *);
+void thermal_unregister_governor(struct thermal_governor *);
+
+#ifdef CONFIG_THERMAL_GOV_STEP_WISE
+int thermal_gov_step_wise_register(void);
+void thermal_gov_step_wise_unregister(void);
+#else
+static inline int thermal_gov_step_wise_register(void) { return 0; }
+static inline void thermal_gov_step_wise_unregister(void) {}
+#endif /* CONFIG_THERMAL_GOV_STEP_WISE */
+
+#ifdef CONFIG_THERMAL_GOV_FAIR_SHARE
+int thermal_gov_fair_share_register(void);
+void thermal_gov_fair_share_unregister(void);
+#else
+static inline int thermal_gov_fair_share_register(void) { return 0; }
+static inline void thermal_gov_fair_share_unregister(void) {}
+#endif /* CONFIG_THERMAL_GOV_FAIR_SHARE */
+
+#ifdef CONFIG_THERMAL_GOV_USER_SPACE
+int thermal_gov_user_space_register(void);
+void thermal_gov_user_space_unregister(void);
+#else
+static inline int thermal_gov_user_space_register(void) { return 0; }
+static inline void thermal_gov_user_space_unregister(void) {}
+#endif /* CONFIG_THERMAL_GOV_USER_SPACE */
+
 #endif /* __THERMAL_CORE_H__ */
diff --git a/drivers/thermal/user_space.c b/drivers/thermal/user_space.c
index 6bbb380..10adcdd 100644
--- a/drivers/thermal/user_space.c
+++ b/drivers/thermal/user_space.c
@@ -22,9 +22,6 @@
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#include <linux/module.h>
 #include <linux/thermal.h>
 
 #include "thermal_core.h"
@@ -46,23 +43,15 @@ static int notify_user_space(struct thermal_zone_device *tz, int trip)
 static struct thermal_governor thermal_gov_user_space = {
 	.name		= "user_space",
 	.throttle	= notify_user_space,
-	.owner		= THIS_MODULE,
 };
 
-static int __init thermal_gov_user_space_init(void)
+int thermal_gov_user_space_register(void)
 {
 	return thermal_register_governor(&thermal_gov_user_space);
 }
 
-static void __exit thermal_gov_user_space_exit(void)
+void thermal_gov_user_space_unregister(void)
 {
 	thermal_unregister_governor(&thermal_gov_user_space);
 }
 
-/* This should load after thermal framework */
-fs_initcall(thermal_gov_user_space_init);
-module_exit(thermal_gov_user_space_exit);
-
-MODULE_AUTHOR("Durgadoss R");
-MODULE_DESCRIPTION("A user space Thermal notifier");
-MODULE_LICENSE("GPL");
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index f0bd7f9..af03ea6 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -184,7 +184,6 @@ struct thermal_governor {
 	char name[THERMAL_NAME_LENGTH];
 	int (*throttle)(struct thermal_zone_device *tz, int trip);
 	struct list_head	governor_list;
-	struct module		*owner;
 };
 
 /* Structure that holds binding parameters for a zone */
@@ -244,9 +243,6 @@ struct thermal_instance *get_thermal_instance(struct thermal_zone_device *,
 void thermal_cdev_update(struct thermal_cooling_device *);
 void notify_thermal_framework(struct thermal_zone_device *, int);
 
-int thermal_register_governor(struct thermal_governor *);
-void thermal_unregister_governor(struct thermal_governor *);
-
 #ifdef CONFIG_NET
 extern int thermal_generate_netlink_event(struct thermal_zone_device *tz,
 						enum events event);
-- 
1.7.9.5

