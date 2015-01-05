Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252AbbAEPsb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:48:31 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:57063 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201AbbAEPs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:48:28 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-be-54aab2470542
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Pavel Machek <pavel@ucw.cz>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RFC PATCHv2 12/19] power_supply: Add power_supply_put for
 decrementing device reference counter
Date: Mon, 05 Jan 2015 16:47:55 +0100
Message-id: <1420472882-10463-13-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420472882-10463-1-git-send-email-k.kozlowski@samsung.com>
References: <1420472882-10463-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGLMWRmVeSWpSXmKPExsVy+t/xa7rum1aFGCz5xG8x6cl7ZouJKycz
	W7x+YWix8+FbNovl+/oZLTY9vsZqcXnXHDaLz71HGC3unjrKZnHm9CVWi9O7Sxy4PXbOusvu
	sXmFlsemVZ1sHpuX1HtsudrO4tG3ZRWjx4rV39k9Pm+SC+CI4rJJSc3JLEst0rdL4MrYv2YC
	c0G3XEXLxuuMDYyLJLsYOTkkBEwkJmw7zgxhi0lcuLeerYuRi0NIYCmjRNumfiYIp49JYsXC
	9ewgVWwCxhKbly8BqxIReMIkMb31JAtIglnAUOLnuz9gRcIC2RKTbi1iA7FZBFQlrvz7wApi
	8wp4SMydc4YVYp2cxMljk8FsTqB4098LYHOEBNwlPjz7xTqBkXcBI8MqRtHU0uSC4qT0XEO9
	4sTc4tK8dL3k/NxNjJCw/LKDcfExq0OMAhyMSjy8HidWhgixJpYVV+YeYpTgYFYS4X2VvipE
	iDclsbIqtSg/vqg0J7X4ECMTB6dUA6OOy2ylB1zlR49teTntreLd2x0HGr+q9tZKMDIuyuF1
	fsx79E/aT5Hu1An+EQH/fR653O2cIXg3eqYvh/85D/ZHL/iq1opctTVoOfrw6415ArapOtct
	PVl3HFjilN1mv+N3TvARh2MsvWuW713SlxrBV/JLfUHf/LVyk9S0TmetvHnTzHtXhoISS3FG
	oqEWc1FxIgDVaca6KQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The power_supply_get_by_phandle() and power_supply_get_by_name() use
function class_find_device() for obtaining the reference to power
supply. Each use of class_find_device() increases the power supply's
device reference counter.

However the reference counter was not decreased by users of this API.
Thus final device_unregister() call from power_supply_unregister() could
not release the device and clean up its resources. This lead to memory
leak if at least once power_supply_get_by_*() was called between
registering and unregistering the power supply.

Add and document new API power_supply_put() for decrementing the
reference counter.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/power/power_supply_core.c | 38 ++++++++++++++++++++++++++++++++++++++
 include/linux/power_supply.h      |  1 +
 2 files changed, 39 insertions(+)

diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index ec9ac01074c7..074aedf6b2f2 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -335,6 +335,17 @@ static int power_supply_match_device_by_name(struct device *dev, const void *dat
 	return strcmp(psy->desc->name, name) == 0;
 }
 
+/**
+ * power_supply_get_by_name() - Search for a power supply and returns its ref
+ * @name: Power supply name to fetch
+ *
+ * If power supply was found, it increases reference count for the
+ * internal power supply's device. The user should power_supply_put()
+ * after usage.
+ *
+ * Return: On success returns a reference to a power supply with
+ * matching name equals to @name, a NULL otherwise.
+ */
 struct power_supply *power_supply_get_by_name(const char *name)
 {
 	struct device *dev = class_find_device(power_supply_class, NULL, name,
@@ -344,12 +355,39 @@ struct power_supply *power_supply_get_by_name(const char *name)
 }
 EXPORT_SYMBOL_GPL(power_supply_get_by_name);
 
+/**
+ * power_supply_put() - Drop reference obtained with power_supply_get_by_name
+ * @psy: Reference to put
+ *
+ * The reference to power supply should be put before unregistering
+ * the power supply.
+ */
+void power_supply_put(struct power_supply *psy)
+{
+	might_sleep();
+
+	put_device(&psy->dev);
+}
+EXPORT_SYMBOL_GPL(power_supply_put);
+
 #ifdef CONFIG_OF
 static int power_supply_match_device_node(struct device *dev, const void *data)
 {
 	return dev->parent && dev->parent->of_node == data;
 }
 
+/**
+ * power_supply_get_by_phandle() - Search for a power supply and returns its ref
+ * @np: Pointer to device node holding phandle property
+ * @phandle_name: Name of property holding a power supply name
+ *
+ * If power supply was found, it increases reference count for the
+ * internal power supply's device. The user should power_supply_put()
+ * after usage.
+ *
+ * Return: On success returns a reference to a power supply with
+ * matching name equals to value under @property, NULL or ERR_PTR otherwise.
+ */
 struct power_supply *power_supply_get_by_phandle(struct device_node *np,
 							const char *property)
 {
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 4afbba073c4a..56e68c9156ce 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -282,6 +282,7 @@ extern struct atomic_notifier_head power_supply_notifier;
 extern int power_supply_reg_notifier(struct notifier_block *nb);
 extern void power_supply_unreg_notifier(struct notifier_block *nb);
 extern struct power_supply *power_supply_get_by_name(const char *name);
+extern void power_supply_put(struct power_supply *psy);
 #ifdef CONFIG_OF
 extern struct power_supply *power_supply_get_by_phandle(struct device_node *np,
 							const char *property);
-- 
1.9.1

