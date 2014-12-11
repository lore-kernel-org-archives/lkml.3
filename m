Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934069AbaLKI0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 03:26:51 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:42591 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934053AbaLKI0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 03:26:45 -0500
From: Tomasz Figa <tfiga@chromium.org>
To: linux-rockchip@lists.infradead.org
Cc: linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Heiko Stuebner <heiko@sntech.de>, Joerg Roedel <joro@8bytes.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kevin Hilman <khilman@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Daniel Kurtz <djkurtz@chromium.org>, Tomasz Figa <tfiga@chromium.org>
Subject: [RFC PATCH 1/2] pm: Add PM domain notifications
Date: Thu, 11 Dec 2014 17:26:26 +0900
Message-Id: <1418286387-9663-2-git-send-email-tfiga@chromium.org>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
In-Reply-To: <1418286387-9663-1-git-send-email-tfiga@chromium.org>
References: <1418286387-9663-1-git-send-email-tfiga@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sylwester Nawrocki <s.nawrocki@samsung.com>

This patch adds notifiers to the runtime PM/genpd subsystem. It is now
possible to register a notifier, which will be called before and after
the generic power domain subsystem calls the power domain's power_on
and power_off callbacks.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
[tfiga@chromium.org: rebased]
Signed-off-by: Tomasz Figa <tfiga@chromium.org>
---
 Documentation/power/notifiers.txt | 14 +++++++++++
 drivers/base/power/domain.c       | 50 +++++++++++++++++++++++++++++++++++++++
 include/linux/pm_domain.h         | 20 ++++++++++++++++
 3 files changed, 84 insertions(+)

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
index 6a103a3..0d6f84e 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -68,6 +68,45 @@ static struct generic_pm_domain *pm_genpd_lookup_name(const char *domain_name)
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
 struct generic_pm_domain *dev_to_genpd(struct device *dev)
 {
 	if (IS_ERR_OR_NULL(dev->pm_domain))
@@ -161,12 +200,17 @@ static int genpd_power_on(struct generic_pm_domain *genpd)
 	if (!genpd->power_on)
 		return 0;
 
+	pm_genpd_notifier_call(PM_GENPD_POWER_ON_PREPARE, genpd);
+
 	time_start = ktime_get();
 	ret = genpd->power_on(genpd);
 	if (ret)
 		return ret;
 
 	elapsed_ns = ktime_to_ns(ktime_sub(ktime_get(), time_start));
+
+	pm_genpd_notifier_call(PM_GENPD_POST_POWER_ON, genpd);
+
 	if (elapsed_ns <= genpd->power_on_latency_ns)
 		return ret;
 
@@ -188,12 +232,17 @@ static int genpd_power_off(struct generic_pm_domain *genpd)
 	if (!genpd->power_off)
 		return 0;
 
+	pm_genpd_notifier_call(PM_GENPD_POWER_OFF_PREPARE, genpd);
+
 	time_start = ktime_get();
 	ret = genpd->power_off(genpd);
 	if (ret == -EBUSY)
 		return ret;
 
 	elapsed_ns = ktime_to_ns(ktime_sub(ktime_get(), time_start));
+
+	pm_genpd_notifier_call(PM_GENPD_POST_POWER_OFF, genpd);
+
 	if (elapsed_ns <= genpd->power_off_latency_ns)
 		return ret;
 
@@ -1466,6 +1515,7 @@ int __pm_genpd_add_device(struct generic_pm_domain *genpd, struct device *dev,
 		genpd->attach_dev(genpd, dev);
 
 	mutex_lock(&gpd_data->lock);
+	BLOCKING_INIT_NOTIFIER_HEAD(&gpd_data->base.notify_chain_head);
 	gpd_data->base.dev = dev;
 	list_add_tail(&gpd_data->base.list_node, &genpd->dev_list);
 	gpd_data->need_restore = -1;
diff --git a/include/linux/pm_domain.h b/include/linux/pm_domain.h
index 6cd20d5..356a145 100644
--- a/include/linux/pm_domain.h
+++ b/include/linux/pm_domain.h
@@ -20,6 +20,12 @@
 /* Defines used for the flags field in the struct generic_pm_domain */
 #define GENPD_FLAG_PM_CLK	(1U << 0) /* PM domain uses PM clk */
 
+/* PM domain state transition notifications */
+#define PM_GENPD_POWER_ON_PREPARE	0x01
+#define PM_GENPD_POST_POWER_ON		0x02
+#define PM_GENPD_POWER_OFF_PREPARE	0x03
+#define PM_GENPD_POST_POWER_OFF		0x04
+
 enum gpd_status {
 	GPD_STATE_ACTIVE = 0,	/* PM domain is active */
 	GPD_STATE_WAIT_MASTER,	/* PM domain's master is being waited for */
@@ -107,6 +113,7 @@ struct gpd_timing_data {
 struct pm_domain_data {
 	struct list_head list_node;
 	struct device *dev;
+	struct blocking_notifier_head notify_chain_head;
 };
 
 struct generic_pm_domain_data {
@@ -159,6 +166,11 @@ extern int pm_genpd_name_poweron(const char *domain_name);
 extern void pm_genpd_poweroff_unused(void);
 
 extern struct dev_power_governor simple_qos_governor;
+extern int pm_genpd_register_notifier(struct device *dev,
+				      struct notifier_block *nb);
+extern void pm_genpd_unregister_notifier(struct device *dev,
+					struct notifier_block *nb);
+
 extern struct dev_power_governor pm_domain_always_on_gov;
 #else
 
@@ -232,6 +244,14 @@ static inline int pm_genpd_name_poweron(const char *domain_name)
 	return -ENOSYS;
 }
 static inline void pm_genpd_poweroff_unused(void) {}
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
2.2.0.rc0.207.ga3a616c

