Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674AbaEUFvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 01:51:39 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:33364 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbaEUFvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 01:51:38 -0400
From: Inderpal Singh <inderpal.s@samsung.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: nm@ti.com, rjw@rjwysocki.net, pavel@ucw.cz, viresh.kumar@linaro.org
Subject: [PATCH v2] PM / OPP: Implement opp_remove and free_opp_table functions
Date: Wed, 21 May 2014 11:21:42 +0530
Message-Id: <1400651502-23703-1-git-send-email-inderpal.s@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400231366-1221-1-git-send-email-inderpal.s@samsung.com>
References: <1400231366-1221-1-git-send-email-inderpal.s@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the driver unloading time the associated opps and its table may need
to be deleted. Otherwise it amounts to memory leak. The existing
OPP library does not have provision to do so.

Hence this patch implements the required functions to free the same.

Signed-off-by: Inderpal Singh <inderpal.s@samsung.com>
---
Changes in v2:
	- As suggested by Nishanth, added support to remove a single OPP
	  for non-DT users
	- Added an internal helper function to avoid the code duplication
	  between opp_remove and free_opp_table functions
 
 drivers/base/power/opp.c | 122 ++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/pm_opp.h   |  14 +++++-
 2 files changed, 134 insertions(+), 2 deletions(-)

diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
index faae9cf..22adef3 100644
--- a/drivers/base/power/opp.c
+++ b/drivers/base/power/opp.c
@@ -89,6 +89,7 @@ struct device_opp {
 	struct device *dev;
 	struct srcu_notifier_head head;
 	struct list_head opp_list;
+	struct rcu_head head_rcu;
 };
 
 /*
@@ -427,7 +428,6 @@ int dev_pm_opp_add(struct device *dev, unsigned long freq, unsigned long u_volt)
 				__func__);
 			return -ENOMEM;
 		}
-
 		dev_opp->dev = dev;
 		srcu_init_notifier_head(&dev_opp->head);
 		INIT_LIST_HEAD(&dev_opp->opp_list);
@@ -464,6 +464,82 @@ int dev_pm_opp_add(struct device *dev, unsigned long freq, unsigned long u_volt)
 EXPORT_SYMBOL_GPL(dev_pm_opp_add);
 
 /**
+ * opp_remove_and_free()  - Internal helper to remove and free an OPP
+ * @dev_opp:	device_opp for which we do this operation
+ * @opp:	OPP to be removed
+ *
+ * This function removes an opp from the opp list and frees it. And, if the
+ * list is empty, it also removes the device_opp from the root list and
+ * frees it.
+ *
+ * Locking: The internal device_opp and opp structures are RCU protected.
+ * The callers need to use RCU updater strategy with mutex locks to keep the
+ * integrity of the internal data structures.
+ */
+static void opp_remove_and_free(struct device_opp *dev_opp,
+						struct dev_pm_opp *opp)
+{
+	list_del_rcu(&opp->node);
+	/*
+	 * Notify the removal of the opp
+	 */
+	srcu_notifier_call_chain(&dev_opp->head, OPP_EVENT_REMOVE, opp);
+	kfree_rcu(opp, head);
+
+	if (list_empty(&dev_opp->opp_list)) {
+		list_del_rcu(&dev_opp->node);
+		kfree_rcu(dev_opp, head_rcu);
+	}
+}
+
+/**
+ * dev_pm_opp_remove() - remove a specific OPP
+ * @dev:	device for which we do this operation
+ * @freq:	OPP frequency to remove
+ *
+ * Removes a provided opp.
+ *
+ * Locking: The internal device_opp and opp structures are RCU protected.
+ * Hence this function internally uses RCU updater strategy with mutex locks to
+ * keep the integrity of the internal data structures. Callers should ensure
+ * that this function is *NOT* called under RCU protection or in contexts where
+ * mutex locking cannot be used.
+ */
+void dev_pm_opp_remove(struct device *dev, unsigned long freq)
+{
+	struct device_opp *dev_opp = ERR_PTR(-ENODEV);
+	struct dev_pm_opp *temp_opp, *opp = ERR_PTR(-ERANGE);
+
+	if (IS_ERR_OR_NULL(dev))
+		return;
+
+	/* Hold our list modification lock here */
+	mutex_lock(&dev_opp_list_lock);
+
+	/* Check for existing list for 'dev' */
+	dev_opp = find_device_opp(dev);
+	if (IS_ERR(dev_opp))
+		goto unlock;
+
+	/* Do we have the frequency? */
+	list_for_each_entry(temp_opp, &dev_opp->opp_list, node)
+		if (temp_opp->rate == freq) {
+			opp = temp_opp;
+			break;
+		}
+
+	if (IS_ERR(opp)) {
+		dev_warn(dev, "%s: OPP freq not found\n", __func__);
+		goto unlock;
+	}
+
+	opp_remove_and_free(dev_opp, opp);
+unlock:
+	mutex_unlock(&dev_opp_list_lock);
+}
+EXPORT_SYMBOL_GPL(dev_pm_opp_remove);
+
+/**
  * opp_set_availability() - helper to set the availability of an opp
  * @dev:		device for which we do this operation
  * @freq:		OPP frequency to modify availability
@@ -653,3 +729,47 @@ int of_init_opp_table(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(of_init_opp_table);
 #endif
+
+/**
+ * dev_pm_opp_free_opp_table() - free the opp table
+ * @dev:	device for which we do this operation
+ *
+ * Free up the allocated opp table
+ *
+ * Locking: The internal device_opp and opp structures are RCU protected.
+ * Hence this function internally uses RCU updater strategy with mutex locks to
+ * keep the integrity of the internal data structures. Callers should ensure
+ * that this function is *NOT* called under RCU protection or in contexts where
+ * mutex locking cannot be used.
+ */
+void dev_pm_opp_free_opp_table(struct device *dev)
+{
+	struct device_opp *dev_opp = ERR_PTR(-ENODEV);
+	struct dev_pm_opp *opp;
+	int count = 0;
+
+	if (IS_ERR_OR_NULL(dev))
+		return;
+
+	/* Hold our list modification lock here */
+	mutex_lock(&dev_opp_list_lock);
+
+	/* Check for existing list for 'dev' */
+	dev_opp = find_device_opp(dev);
+	if (IS_ERR(dev_opp)) {
+		dev_warn(dev, "%s: OPP list not found\n", __func__);
+		goto unlock;
+	}
+
+	list_for_each_entry_rcu(opp, &dev_opp->opp_list, node)
+		count++;
+
+	while (count--) {
+		opp = list_entry_rcu(dev_opp->opp_list.next,
+					struct dev_pm_opp, node);
+		opp_remove_and_free(dev_opp, opp);
+	}
+unlock:
+	mutex_unlock(&dev_opp_list_lock);
+}
+EXPORT_SYMBOL_GPL(dev_pm_opp_free_opp_table);
diff --git a/include/linux/pm_opp.h b/include/linux/pm_opp.h
index 0330217..13e6956 100644
--- a/include/linux/pm_opp.h
+++ b/include/linux/pm_opp.h
@@ -21,7 +21,7 @@ struct dev_pm_opp;
 struct device;
 
 enum dev_pm_opp_event {
-	OPP_EVENT_ADD, OPP_EVENT_ENABLE, OPP_EVENT_DISABLE,
+	OPP_EVENT_ADD, OPP_EVENT_REMOVE, OPP_EVENT_ENABLE, OPP_EVENT_DISABLE,
 };
 
 #if defined(CONFIG_PM_OPP)
@@ -49,7 +49,11 @@ int dev_pm_opp_enable(struct device *dev, unsigned long freq);
 
 int dev_pm_opp_disable(struct device *dev, unsigned long freq);
 
+void dev_pm_opp_remove(struct device *dev, unsigned long freq);
+
 struct srcu_notifier_head *dev_pm_opp_get_notifier(struct device *dev);
+
+void dev_pm_opp_free_opp_table(struct device *dev);
 #else
 static inline unsigned long dev_pm_opp_get_voltage(struct dev_pm_opp *opp)
 {
@@ -100,11 +104,19 @@ static inline int dev_pm_opp_disable(struct device *dev, unsigned long freq)
 	return 0;
 }
 
+static inline void dev_pm_opp_remove(struct device *dev, unsigned long freq)
+{
+}
+
 static inline struct srcu_notifier_head *dev_pm_opp_get_notifier(
 							struct device *dev)
 {
 	return ERR_PTR(-EINVAL);
 }
+
+static inline void dev_pm_opp_free_opp_table(struct device *dev)
+{
+}
 #endif		/* CONFIG_PM_OPP */
 
 #if defined(CONFIG_PM_OPP) && defined(CONFIG_OF)
-- 
1.8.3.2

