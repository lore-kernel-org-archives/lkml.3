Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab3GYL0I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 07:26:08 -0400
Received: from mga03.intel.com ([143.182.124.21]:52216 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755491Ab3GYL0C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 07:26:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,742,1367996400"; 
   d="scan'208";a="273078846"
From: Jenny TC <jenny.tc@intel.com>
To: linux-kernel@vger.kernel.org, Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Jenny TC <jenny.tc@intel.com>
Subject: [PATCH] power_supply: Add power_supply notifier
Date: Fri, 26 Jul 2013 00:51:09 +0530
Message-Id: <1374780069-23670-1-git-send-email-jenny.tc@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a notifier chain to the power_supply.
This notifier helps drivers in other subsystem to listen to
changes in power supply subsystem. This would help to take some
actions in those drivers on changing the power supply properties.
One such scenario is to increase/decrease system performance based
on the battery capacity/voltage. Another scenario is to adjust the
h/w peak current detection voltage/current thresholds based on battery
voltage/capacity. The notifier helps drivers to listen to changes
in power_suppy susbystem without polling the power_supply properties

Signed-off-by: Jenny TC <jenny.tc@intel.com>
---
 drivers/power/power_supply_core.c |   18 ++++++++++++++++++
 include/linux/power_supply.h      |    7 +++++++
 2 files changed, 25 insertions(+)

diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index 3b2d5df..a5779b3 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -24,6 +24,9 @@
 struct class *power_supply_class;
 EXPORT_SYMBOL_GPL(power_supply_class);
 
+ATOMIC_NOTIFIER_HEAD(power_supply_notifier);
+EXPORT_SYMBOL(power_supply_notifier);
+
 static struct device_type power_supply_dev_type;
 
 static bool __power_supply_is_supplied_by(struct power_supply *supplier,
@@ -76,6 +79,9 @@ static void power_supply_changed_work(struct work_struct *work)
 			      __power_supply_changed_work);
 
 	power_supply_update_leds(psy);
+	
+	atomic_notifier_call_chain(&power_supply_notifier,
+				POWER_SUPPLY_PROP_CHANGED, psy);
 
 	kobject_uevent(&psy->dev->kobj, KOBJ_CHANGE);
 }
@@ -328,6 +334,18 @@ static void power_supply_dev_release(struct device *dev)
 	kfree(dev);
 }
 
+int power_supply_reg_notifier(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_register(&power_supply_notifier, nb);
+}
+EXPORT_SYMBOL_GPL(power_supply_reg_notifier);
+
+void power_supply_unreg_notifier(struct notifier_block *nb)
+{
+	atomic_notifier_chain_unregister(&power_supply_notifier, nb);
+}
+EXPORT_SYMBOL_GPL(power_supply_unreg_notifier);
+
 #ifdef CONFIG_THERMAL
 static int power_supply_read_temp(struct thermal_zone_device *tzd,
 		unsigned long *temp)
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 516e4c4..32fae9c 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -217,6 +217,10 @@ enum psy_throttle_action {
 	PSY_THROTTLE_INPUT_LIMIT,
 };
 
+enum power_supply_notifier_events {
+	POWER_SUPPLY_PROP_CHANGED,
+};
+
 struct psy_throttle_state {
 	enum psy_throttle_action throttle_action;
 	unsigned throttle_val;
@@ -293,6 +297,9 @@ struct power_supply_info {
 	int use_for_apm;
 };
 
+extern struct atomic_notifier_head    power_supply_notifier;
+extern int power_supply_reg_notifier(struct notifier_block *nb);
+extern void power_supply_unreg_notifier(struct notifier_block *nb);
 extern struct power_supply *power_supply_get_by_name(const char *name);
 extern void power_supply_changed(struct power_supply *psy);
 extern int power_supply_am_i_supplied(struct power_supply *psy);
-- 
1.7.9.5

