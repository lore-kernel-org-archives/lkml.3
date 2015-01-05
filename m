Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbbAEPyw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:54:52 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:55683 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442AbbAEPsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:48:22 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-94-54aab242c8bd
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Pavel Machek <pavel@ucw.cz>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RFC PATCHv2 03/19] power_supply: Add API for safe access of power
 supply function attrs
Date: Mon, 05 Jan 2015 16:47:46 +0100
Message-id: <1420472882-10463-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420472882-10463-1-git-send-email-k.kozlowski@samsung.com>
References: <1420472882-10463-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKLMWRmVeSWpSXmKPExsVy+t/xa7pOm1aFGHx5JG8x6cl7ZouJKycz
	W7x+YWix8+FbNovl+/oZLTY9vsZqcXnXHDaLz71HGC3unjrKZnHm9CVWi9O7Sxy4PXbOusvu
	sXmFlsemVZ1sHpuX1HtsudrO4tG3ZRWjx4rV39k9Pm+SC+CI4rJJSc3JLEst0rdL4Mp42vad
	sWCJRsW+uUvZGxgblboYOTkkBEwkHn2cwghhi0lcuLeerYuRi0NIYCmjxOkpZxghnD4miZvb
	r7OBVLEJGEtsXr4ErEpE4AmTxPTWkywgCWYBQ4mf7/6wg9jCAskSB7Y9BOrm4GARUJXYPTEQ
	JMwr4C5x88AZFohtchInj01mBbE5BTwkmv5eAIsLAdV8ePaLdQIj7wJGhlWMoqmlyQXFSem5
	hnrFibnFpXnpesn5uZsYIUH5ZQfj4mNWhxgFOBiVeHg9TqwMEWJNLCuuzD3EKMHBrCTC+yp9
	VYgQb0piZVVqUX58UWlOavEhRiYOTqkGxuk6Iv9uHVqx7t2dC23HhZrnrr5dxb2XqY3xUXnE
	BAY95aqp3BYMnGpbt5X7Ka/8M0FH75L5/iOup9LnXLtySfku56XUawsXR3hHMlxzX/Ki/ofi
	68u3vbcGn5zAoXhkhdklacYzzt1ykT953VbHHvDlZJgsufGYcrj9N43nzDVSwSvz2Tjn+yqx
	FGckGmoxFxUnAgAnC6HmKAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add simple wrappers for accessing power supply's function attributes:
 - get_property -> power_supply_get_property
 - set_property -> power_supply_set_property
 - property_is_writeable -> power_supply_property_is_writeable
 - external_power_changed -> power_supply_external_power_changed

This API along with usage counter adds a safe way of accessing a power
supply from another driver. If power supply is unregistered after
obtaining reference to it by some driver, then the API wrappers won't be
executed in invalid (freed) context.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/power/power_supply_core.c | 47 ++++++++++++++++++++++++++++++++++++++-
 include/linux/power_supply.h      | 16 +++++++++++++
 2 files changed, 62 insertions(+), 1 deletion(-)

diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index b748391c3e17..fdec3c29fc3c 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -314,7 +314,8 @@ EXPORT_SYMBOL_GPL(power_supply_is_system_supplied);
 
 int power_supply_set_battery_charged(struct power_supply *psy)
 {
-	if (psy->type == POWER_SUPPLY_TYPE_BATTERY && psy->set_charged) {
+	if (psy->use_cnt >= 0 && psy->type == POWER_SUPPLY_TYPE_BATTERY &&
+			psy->set_charged) {
 		psy->set_charged(psy);
 		return 0;
 	}
@@ -366,6 +367,47 @@ struct power_supply *power_supply_get_by_phandle(struct device_node *np,
 EXPORT_SYMBOL_GPL(power_supply_get_by_phandle);
 #endif /* CONFIG_OF */
 
+int power_supply_get_property(struct power_supply *psy,
+			    enum power_supply_property psp,
+			    union power_supply_propval *val)
+{
+	if (psy->use_cnt <= 0)
+		return -ENODEV;
+
+	return psy->get_property(psy, psp, val);
+}
+EXPORT_SYMBOL_GPL(power_supply_get_property);
+
+int power_supply_set_property(struct power_supply *psy,
+			    enum power_supply_property psp,
+			    const union power_supply_propval *val)
+{
+	if (psy->use_cnt <= 0 || !psy->set_property)
+		return -ENODEV;
+
+	return psy->set_property(psy, psp, val);
+}
+EXPORT_SYMBOL_GPL(power_supply_set_property);
+
+int power_supply_property_is_writeable(struct power_supply *psy,
+					enum power_supply_property psp)
+{
+	if (psy->use_cnt <= 0 || !psy->property_is_writeable)
+		return -ENODEV;
+
+	return psy->property_is_writeable(psy, psp);
+}
+EXPORT_SYMBOL_GPL(power_supply_property_is_writeable);
+
+void power_supply_external_power_changed(struct power_supply *psy)
+{
+	if (psy->use_cnt <= 0 || !psy->external_power_changed)
+		return;
+
+	psy->external_power_changed(psy);
+}
+EXPORT_SYMBOL_GPL(power_supply_external_power_changed);
+
 int power_supply_powers(struct power_supply *psy, struct device *dev)
 {
 	return sysfs_create_link(&psy->dev->kobj, &dev->kobj, "powers");
@@ -555,6 +597,7 @@ static int __power_supply_register(struct device *parent,
 	dev->release = power_supply_dev_release;
 	dev_set_drvdata(dev, psy);
 	psy->dev = dev;
+	psy->use_cnt++;
 	if (cfg) {
 		psy->drv_data = cfg->drv_data;
 		psy->of_node = cfg->of_node;
@@ -629,6 +672,8 @@ EXPORT_SYMBOL_GPL(power_supply_register_no_ws);
 
 void power_supply_unregister(struct power_supply *psy)
 {
+	psy->use_cnt--;
+	WARN_ON(psy->use_cnt);
 	cancel_work_sync(&psy->changed_work);
 	sysfs_remove_link(&psy->dev->kobj, "powers");
 	power_supply_remove_triggers(psy);
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index b203a26d5c54..c2c17ac3a608 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -199,6 +199,12 @@ struct power_supply {
 	size_t num_supplies;
 	struct device_node *of_node;
 
+	/*
+	 * Functions for drivers implementing power supply class.
+	 * These shouldn't be called directly by other drivers for accessing
+	 * this power supply. Instead use power_supply_*() functions (for
+	 * example power_supply_get_property()).
+	 */
 	int (*get_property)(struct power_supply *psy,
 			    enum power_supply_property psp,
 			    union power_supply_propval *val);
@@ -227,6 +233,7 @@ struct power_supply {
 	struct work_struct changed_work;
 	spinlock_t changed_lock;
 	bool changed;
+	int use_cnt;
 #ifdef CONFIG_THERMAL
 	struct thermal_zone_device *tzd;
 	struct thermal_cooling_device *tcd;
@@ -287,6 +294,15 @@ extern int power_supply_is_system_supplied(void);
 static inline int power_supply_is_system_supplied(void) { return -ENOSYS; }
 #endif
 
+extern int power_supply_get_property(struct power_supply *psy,
+			    enum power_supply_property psp,
+			    union power_supply_propval *val);
+extern int power_supply_set_property(struct power_supply *psy,
+			    enum power_supply_property psp,
+			    const union power_supply_propval *val);
+extern int power_supply_property_is_writeable(struct power_supply *psy,
+					enum power_supply_property psp);
+extern void power_supply_external_power_changed(struct power_supply *psy);
 extern int power_supply_register(struct device *parent,
 				 struct power_supply *psy,
 				 const struct power_supply_config *cfg);
-- 
1.9.1

