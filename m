Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbaHEKs6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 06:48:58 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:52852 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664AbaHEKsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 06:48:52 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-9a-53e0b691c5c1
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: iommu@lists.linux-foundation.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        linaro-mm-sig@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Shaik Ameer Basha <shaik.ameer@samsung.com>,
        Cho KyongHo <pullip.cho@samsung.com>, Joerg Roedel <joro@8bytes.org>,
        Thierry Reding <treding@nvidia.com>, Olof Johansson <olof@lixom.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Inki Dae <inki.dae@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 01/29] pm: Add PM domain notifications
Date: Tue, 05 Aug 2014 12:47:29 +0200
Message-id: <1407235677-26324-2-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
References: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsVy+t/xq7oTtz0INmibYmDxd9IxdovmxevZ
	LCbdn8BisWC/tUXn7A3sFr0LrrJZnG16w27ROXEJu8WXKw+ZLDY9vsZqcXnXHDaLGef3MVms
	PXKX3eLU9c9sFv96DzJanDl9idXi/54d7BaH37SzWhx5uJvdYtWuP4wWt3/zOYh6PDk4j8nj
	969JjB47Z91l95jdMZPVY9OqTjaP/XPXsHtsXlLvcfvfY2aPyTeWM3pcOdHE6tHb/I7NY8vV
	dhaPvi2rGD0+b5IL4IvisklJzcksSy3St0vgyjgytZGxYJlDxbOl99gbGHeYdjFyckgImEis
	aF7OBGGLSVy4t54NxBYSWMoo8eWNehcjF5DdxySxvHk3C0iCTcBQouttFxtIQkSgl1Giv+kH
	E4jDLLCOVWJ/73WwKmEBM4nT7zuBbA4OFgFViYNfOUDCvAIeEttvXmCB2CYn8f/lCrDNnAKe
	EodvHmCF2Owh8XPDGvYJjLwLGBlWMYqmliYXFCel5xrqFSfmFpfmpesl5+duYoTEzZcdjIuP
	WR1iFOBgVOLhNTh9N1iINbGsuDL3EKMEB7OSCK/EmgfBQrwpiZVVqUX58UWlOanFhxiZODil
	Ghizcxb7bElXu5py+MtNeYfJ/9+qfrUyv3xJ6HOiTue7izUiMhGz1c8o2Sxb86o7YJlCOcfP
	dzwLmXqcW7QWsZ+RNzjKH7bQVm1+oPvBi+7h67Uf3pa9+Zb3ScsEtVO1hzkOxN5rFn9i+XBT
	upBgwlRbhXnrVMJDpkuVXRC4OtNTRyf7ct/mM4xKLMUZiYZazEXFiQDW5cWIeQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sylwester Nawrocki <s.nawrocki@samsung.com>

This patch adds notifiers to the runtime PM/genpd subsystem. It is now
possible to register a notifier, which will be called before and after
the generic power domain subsystem calls the power domain's power_on
and power_off callbacks.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 Documentation/power/notifiers.txt | 14 ++++++++
 drivers/base/power/domain.c       | 70 ++++++++++++++++++++++++++++++++++++---
 include/linux/pm.h                |  2 ++
 include/linux/pm_domain.h         | 19 +++++++++++
 4 files changed, 101 insertions(+), 4 deletions(-)

diff --git a/Documentation/power/notifiers.txt b/Documentation/power/notifiers.txt
index a81fa25..62303f6 100644
--- a/Documentation/power/notifiers.txt
+++ b/Documentation/power/notifiers.txt
@@ -53,3 +53,17 @@ NULL).  To register and/or unregister a suspend notifier use the functions
 register_pm_notifier() and unregister_pm_notifier(), respectively, defined in
 include/linux/suspend.h .  If you don't need to unregister the notifier, you can
 also use the pm_notifier() macro defined in include/linux/suspend.h .
+
+Power Domain notifiers
+----------------------
+
+The power domain notifiers allow subsystems or drivers to register for power
+domain on/off notifications, should they need to perform any actions right
+before or right after the power domain on/off.  The device must be already
+added to a power domain before its subsystem or driver registers the notifier.
+Following events are supported:
+
+PM_GENPD_POWER_ON_PREPARE	The power domain is about to turn on.
+PM_GENPD_POST_POWER_ON		The power domain has just turned on.
+PM_GENPD_POWER_OFF_PREPARE	The power domain is about to turn off.
+PM_GENPD_POST_POWER_OFF		The power domain has just turned off.
diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
index eee55c1..5fe0966 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -70,6 +70,45 @@ static struct generic_pm_domain *pm_genpd_lookup_name(const char *domain_name)
 	return genpd;
 }
 
+int pm_genpd_register_notifier(struct device *dev, struct notifier_block *nb)
+{
+	struct pm_domain_data *pdd;
+	int ret = -EINVAL;
+
+	spin_lock_irq(&dev->power.lock);
+	if (dev->power.subsys_data) {
+		pdd = dev->power.subsys_data->domain_data;
+		ret = blocking_notifier_chain_register(&pdd->notify_chain_head,
+						       nb);
+	}
+	spin_unlock_irq(&dev->power.lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(pm_genpd_register_notifier);
+
+void pm_genpd_unregister_notifier(struct device *dev, struct notifier_block *nb)
+{
+	struct pm_domain_data *pdd;
+
+	spin_lock_irq(&dev->power.lock);
+	if (dev->power.subsys_data) {
+		pdd = dev->power.subsys_data->domain_data;
+		blocking_notifier_chain_unregister(&pdd->notify_chain_head, nb);
+	}
+	spin_unlock_irq(&dev->power.lock);
+}
+EXPORT_SYMBOL_GPL(pm_genpd_unregister_notifier);
+
+static void pm_genpd_notifier_call(unsigned long event,
+				   struct generic_pm_domain *genpd)
+{
+	struct pm_domain_data *pdd;
+
+	list_for_each_entry(pdd, &genpd->dev_list, list_node)
+		blocking_notifier_call_chain(&pdd->notify_chain_head,
+					     event, pdd->dev);
+}
+
 #ifdef CONFIG_PM
 
 struct generic_pm_domain *dev_to_genpd(struct device *dev)
@@ -231,10 +270,14 @@ static int __pm_genpd_poweron(struct generic_pm_domain *genpd)
 		ktime_t time_start = ktime_get();
 		s64 elapsed_ns;
 
+		pm_genpd_notifier_call(PM_GENPD_POWER_ON_PREPARE, genpd);
+
 		ret = genpd->power_on(genpd);
 		if (ret)
 			goto err;
 
+		pm_genpd_notifier_call(PM_GENPD_POST_POWER_ON, genpd);
+
 		elapsed_ns = ktime_to_ns(ktime_sub(ktime_get(), time_start));
 		if (elapsed_ns > genpd->power_on_latency_ns) {
 			genpd->power_on_latency_ns = elapsed_ns;
@@ -554,13 +597,17 @@ static int pm_genpd_poweroff(struct generic_pm_domain *genpd)
 		 * the pm_genpd_poweron() restore power for us (this shouldn't
 		 * happen very often).
 		 */
+		pm_genpd_notifier_call(PM_GENPD_POWER_OFF_PREPARE, genpd);
+
 		ret = genpd->power_off(genpd);
 		if (ret == -EBUSY) {
 			genpd_set_active(genpd);
 			goto out;
 		}
-
 		elapsed_ns = ktime_to_ns(ktime_sub(ktime_get(), time_start));
+
+		pm_genpd_notifier_call(PM_GENPD_POST_POWER_OFF, genpd);
+
 		if (elapsed_ns > genpd->power_off_latency_ns) {
 			genpd->power_off_latency_ns = elapsed_ns;
 			genpd->max_off_time_changed = true;
@@ -837,9 +884,13 @@ static void pm_genpd_sync_poweroff(struct generic_pm_domain *genpd)
 	    || atomic_read(&genpd->sd_count) > 0)
 		return;
 
-	if (genpd->power_off)
+	if (genpd->power_off) {
+		pm_genpd_notifier_call(PM_GENPD_POWER_OFF_PREPARE, genpd);
 		genpd->power_off(genpd);
 
+		pm_genpd_notifier_call(PM_GENPD_POST_POWER_OFF, genpd);
+	}
+
 	genpd->status = GPD_STATE_POWER_OFF;
 
 	list_for_each_entry(link, &genpd->slave_links, slave_node) {
@@ -869,8 +920,11 @@ static void pm_genpd_sync_poweron(struct generic_pm_domain *genpd)
 		genpd_sd_counter_inc(link->master);
 	}
 
-	if (genpd->power_on)
+	if (genpd->power_on) {
+		pm_genpd_notifier_call(PM_GENPD_POWER_ON_PREPARE, genpd);
 		genpd->power_on(genpd);
+		pm_genpd_notifier_call(PM_GENPD_POST_POWER_ON, genpd);
+	}
 
 	genpd->status = GPD_STATE_ACTIVE;
 }
@@ -1292,9 +1346,16 @@ static int pm_genpd_restore_noirq(struct device *dev)
 			 * If the domain was off before the hibernation, make
 			 * sure it will be off going forward.
 			 */
-			if (genpd->power_off)
+			if (genpd->power_off) {
+				pm_genpd_notifier_call(PM_GENPD_POWER_OFF_PREPARE,
+						       genpd);
+
 				genpd->power_off(genpd);
 
+				pm_genpd_notifier_call(PM_GENPD_POST_POWER_OFF,
+						       genpd);
+			}
+
 			return 0;
 		}
 	}
@@ -1467,6 +1528,7 @@ int __pm_genpd_add_device(struct generic_pm_domain *genpd, struct device *dev,
 	spin_unlock_irq(&dev->power.lock);
 
 	mutex_lock(&gpd_data->lock);
+	BLOCKING_INIT_NOTIFIER_HEAD(&gpd_data->base.notify_chain_head);
 	gpd_data->base.dev = dev;
 	list_add_tail(&gpd_data->base.list_node, &genpd->dev_list);
 	gpd_data->need_restore = genpd->status == GPD_STATE_POWER_OFF;
diff --git a/include/linux/pm.h b/include/linux/pm.h
index 72c0fe0..bfc55d4 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -22,6 +22,7 @@
 #define _LINUX_PM_H
 
 #include <linux/list.h>
+#include <linux/notifier.h>
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
 #include <linux/wait.h>
@@ -542,6 +543,7 @@ struct wakeup_source;
 struct pm_domain_data {
 	struct list_head list_node;
 	struct device *dev;
+	struct blocking_notifier_head notify_chain_head;
 };
 
 struct pm_subsys_data {
diff --git a/include/linux/pm_domain.h b/include/linux/pm_domain.h
index 7c1d252..569ab16 100644
--- a/include/linux/pm_domain.h
+++ b/include/linux/pm_domain.h
@@ -17,6 +17,12 @@
 #include <linux/notifier.h>
 #include <linux/cpuidle.h>
 
+/* PM domain state transition notifications */
+#define PM_GENPD_POWER_ON_PREPARE	0x01
+#define PM_GENPD_POST_POWER_ON		0x02
+#define PM_GENPD_POWER_OFF_PREPARE	0x03
+#define PM_GENPD_POST_POWER_OFF		0x04
+
 enum gpd_status {
 	GPD_STATE_ACTIVE = 0,	/* PM domain is active */
 	GPD_STATE_WAIT_MASTER,	/* PM domain's master is being waited for */
@@ -167,6 +173,11 @@ extern int pm_genpd_name_poweron(const char *domain_name);
 
 extern bool default_stop_ok(struct device *dev);
 
+extern int pm_genpd_register_notifier(struct device *dev,
+				      struct notifier_block *nb);
+extern void pm_genpd_unregister_notifier(struct device *dev,
+					struct notifier_block *nb);
+
 extern struct dev_power_governor pm_domain_always_on_gov;
 #else
 
@@ -259,6 +270,14 @@ static inline bool default_stop_ok(struct device *dev)
 {
 	return false;
 }
+static inline int pm_genpd_register_notifier(struct device *dev,
+					struct notifier_block *nb)
+{
+	return -ENOSYS;
+}
+static inline void pm_genpd_unregister_notifier(struct device *dev,
+					 struct notifier_block *nb) {}
+
 #define simple_qos_governor NULL
 #define pm_domain_always_on_gov NULL
 #endif
-- 
1.9.2

