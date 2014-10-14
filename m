Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255AbaJNMVI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 08:21:08 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:54150 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755113AbaJNMVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 08:21:04 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-a1-543d152d9e1c
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Anton Vorontsov <anton@enomsg.org>, Guenter Roeck <linux@roeck-us.net>,
        Pavel Machek <pavel@ucw.cz>, Myungjoo Ham <myungjoo.ham@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 1/8] power_supply: Add API for safe access of power supply
 function attrs
Date: Tue, 14 Oct 2014 14:20:39 +0200
Message-id: <1413289246-31650-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1413289246-31650-1-git-send-email-k.kozlowski@samsung.com>
References: <1413289246-31650-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t/xq7q6orYhBmu+MVoc3KppsXHGelaL
	SU/eM1tMXDmZ2aLz7BNmi9cvDC3ONr1ht7j/9SijxZQ/y5ksNj2+xmpxedccNovPvUcYLZ4s
	PMNksfbIXXaL240r2CzunjrKZnG6m9Xi9O4SByGPCf2fGD12zrrL7rF5hZbHplWdbB53ru1h
	85h3MtBj85J6j53fG9g9+rasYvRYsfo7u8fnTXIB3FFcNimpOZllqUX6dglcGbO3fWEp+OxW
	8XDNPOYGxtU2XYycHBICJhJvJt1hg7DFJC7cWw9kc3EICSxllFj7qIUZwuljknjw7Rk7SBWb
	gLHE5uVLwKpEBK4zSXSumMAC4jALNDJLvGtoZupi5OAQFoiW+H8gBqSBRUBV4nTTI7BmXgF3
	ibUfV7JCrJOTOHlsMpjNKeAhsXLRERYQWwiopv3kbbYJjLwLGBlWMYqmliYXFCel5xrpFSfm
	Fpfmpesl5+duYoQE/dcdjEuPWR1iFOBgVOLhLYi0CRFiTSwrrsw9xCjBwawkwqvAYRsixJuS
	WFmVWpQfX1Sak1p8iJGJg1OqgXF9ZXT0awcXiU3JarXhN3x4j5/gPy3dNDPBSIh1bpJH2r0r
	nkvX87GZXVVROJyRulxw9YwH++4tW8xzJ/3XtnKfTtusuW4WvYceTr6x6Z2Ur736FUchycS1
	7BcDV/4KsWlp+mj3fcnto2kBiz6FJycUiXzaV7JvbXjNhLcmN5ycLy05dSHylooSS3FGoqEW
	c1FxIgAOkdPSWAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add simple wrappers for accessing power supply's function attributes:
 - get_property -> power_supply_get_property
 - set_property -> power_supply_set_property
 - property_is_writeable -> power_supply_property_is_writeable
 - external_power_changed -> power_supply_external_power_changed
 - set_charged -> power_supply_set_charged

This API adds a safe way of accessing a power supply from another
driver. Particularly it solves invalid memory references (and lockup) in
following race condition scenario:

Thread 1: charger manager
Thread 2: power supply driver, used by charger manager

THREAD 1 (charger manager)         THREAD 2 (power supply driver)
==========================         ==============================
psy = power_supply_get_by_name()
                                   Driver unbind, .remove
                                     power_supply_unregister
                                     Device fully removed
psy->get_property()

The 'get_property' callback is still valid and leads to actual calling of
Thread2->get_property() but now in invalid context because the driver was
unbound.

This could be observed easily with charger manager driver (here compiled
with max17042 fuel gauge):
$ echo "12-0036" > /sys/bus/i2c/drivers/max17042/unbind
$ cat /sys/devices/virtual/power_supply/battery/temp
[  240.505998] INFO: task cat:1394 blocked for more than 120 seconds.
[  240.510762]       Not tainted 3.17.0-next-20141007-00028-ge60b6dd79570-dirty #183
[  240.518208] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  240.526025] cat             D c0469548     0  1394      1 0x00000000
[  240.532384] [<c0469548>] (__schedule) from [<c0469d54>] (schedule_preempt_disabled+0x14/0x20)
[  240.540885] [<c0469d54>] (schedule_preempt_disabled) from [<c046af20>] (mutex_lock_nested+0x1bc/0x458)
[  240.550171] [<c046af20>] (mutex_lock_nested) from [<c0287a98>] (regmap_read+0x30/0x60)
[  240.558079] [<c0287a98>] (regmap_read) from [<c032238c>] (max17042_get_property+0x2e8/0x350)
[  240.566490] [<c032238c>] (max17042_get_property) from [<c0324b60>] (charger_get_property+0x238/0x31c)
[  240.575688] [<c0324b60>] (charger_get_property) from [<c0320764>] (power_supply_show_property+0x48/0x1e0)
[  240.585241] [<c0320764>] (power_supply_show_property) from [<c027308c>] (dev_attr_show+0x1c/0x48)
[  240.594100] [<c027308c>] (dev_attr_show) from [<c0141fb0>] (sysfs_kf_seq_show+0x84/0x104)
[  240.602251] [<c0141fb0>] (sysfs_kf_seq_show) from [<c0140b18>] (kernfs_seq_show+0x24/0x28)
[  240.610497] [<c0140b18>] (kernfs_seq_show) from [<c0104574>] (seq_read+0x1b0/0x484)
[  240.618138] [<c0104574>] (seq_read) from [<c00e1e24>] (vfs_read+0x88/0x144)
[  240.625127] [<c00e1e24>] (vfs_read) from [<c00e1f20>] (SyS_read+0x40/0x8c)
[  240.631941] [<c00e1f20>] (SyS_read) from [<c000e760>] (ret_fast_syscall+0x0/0x48)

Or:
[   17.277605] Division by zero in kernel.
[   17.280043] CPU: 2 PID: 1384 Comm: cat Not tainted 3.17.0-next-20141007-00028-ge60b6dd79570-dirty #181
[   17.289348] [<c00140f0>] (unwind_backtrace) from [<c0011228>] (show_stack+0x10/0x14)
[   17.297055] [<c0011228>] (show_stack) from [<c04680d0>] (dump_stack+0x70/0xbc)
[   17.304264] [<c04680d0>] (dump_stack) from [<c01f7a28>] (Ldiv0+0x8/0x10)
[   17.310933] [<c01f7a28>] (Ldiv0) from [<c01f79f8>] (__aeabi_uidivmod+0x8/0x18)
[   17.318132] [<c01f79f8>] (__aeabi_uidivmod) from [<c0287a84>] (regmap_read+0x1c/0x60)
[   17.325956] [<c0287a84>] (regmap_read) from [<c0322260>] (max17042_get_property+0x1bc/0x350)
[   17.334361] [<c0322260>] (max17042_get_property) from [<c0324734>] (charger_get_property+0x198/0x328)
[   17.343560] [<c0324734>] (charger_get_property) from [<c0320764>] (power_supply_show_property+0x48/0x1e0)
[   17.353108] [<c0320764>] (power_supply_show_property) from [<c03209d4>] (power_supply_uevent+0x9c/0x1c4)
[   17.362575] [<c03209d4>] (power_supply_uevent) from [<c02745d0>] (dev_uevent+0xb8/0x1c8)
[   17.370639] [<c02745d0>] (dev_uevent) from [<c0272c4c>] (uevent_show+0xa8/0x104)
[   17.378015] [<c0272c4c>] (uevent_show) from [<c027308c>] (dev_attr_show+0x1c/0x48)
[   17.385579] [<c027308c>] (dev_attr_show) from [<c0141fb0>] (sysfs_kf_seq_show+0x84/0x104)
[   17.393731] [<c0141fb0>] (sysfs_kf_seq_show) from [<c0140b18>] (kernfs_seq_show+0x24/0x28)
[   17.401979] [<c0140b18>] (kernfs_seq_show) from [<c0104574>] (seq_read+0x1b0/0x484)
[   17.409619] [<c0104574>] (seq_read) from [<c00e1e24>] (vfs_read+0x88/0x144)
[   17.416557] [<c00e1e24>] (vfs_read) from [<c00e1f20>] (SyS_read+0x40/0x8c)
[   17.423416] [<c00e1f20>] (SyS_read) from [<c000e760>] (ret_fast_syscall+0x0/0x48)
[   17.430880] power_supply battery: driver failed to report `voltage_now' property: -22

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/power/power_supply_core.c | 57 +++++++++++++++++++++++++++++++++++++--
 include/linux/power_supply.h      | 16 +++++++++++
 2 files changed, 71 insertions(+), 2 deletions(-)

diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index 6cb7fe5c022d..8e36986a73e1 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -366,6 +366,56 @@ struct power_supply *power_supply_get_by_phandle(struct device_node *np,
 EXPORT_SYMBOL_GPL(power_supply_get_by_phandle);
 #endif /* CONFIG_OF */
 
+int power_supply_get_property(struct power_supply *psy,
+			    enum power_supply_property psp,
+			    union power_supply_propval *val)
+{
+	if (!psy || !psy->dev)
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
+	if (!psy || !psy->dev || !psy->set_property)
+		return -ENODEV;
+
+	return psy->set_property(psy, psp, val);
+}
+EXPORT_SYMBOL_GPL(power_supply_set_property);
+
+int power_supply_property_is_writeable(struct power_supply *psy,
+					enum power_supply_property psp)
+{
+	if (!psy || !psy->dev || !psy->property_is_writeable)
+		return -ENODEV;
+
+	return psy->property_is_writeable(psy, psp);
+}
+EXPORT_SYMBOL_GPL(power_supply_property_is_writeable);
+
+void power_supply_external_power_changed(struct power_supply *psy)
+{
+	if (!psy || !psy->dev || !psy->external_power_changed)
+		return;
+
+	psy->external_power_changed(psy);
+}
+EXPORT_SYMBOL_GPL(power_supply_external_power_changed);
+
+void power_supply_set_charged(struct power_supply *psy)
+{
+	if (!psy || !psy->dev || !psy->set_charged)
+		return;
+
+	psy->set_charged(psy);
+}
+EXPORT_SYMBOL_GPL(power_supply_set_charged);
+
 int power_supply_powers(struct power_supply *psy, struct device *dev)
 {
 	return sysfs_create_link(&psy->dev->kobj, &dev->kobj, "powers");
@@ -616,13 +666,16 @@ EXPORT_SYMBOL_GPL(power_supply_register_no_ws);
 
 void power_supply_unregister(struct power_supply *psy)
 {
+	struct device *dev = psy->dev;
+
 	cancel_work_sync(&psy->changed_work);
 	sysfs_remove_link(&psy->dev->kobj, "powers");
+	psy->dev = NULL;
 	power_supply_remove_triggers(psy);
 	psy_unregister_cooler(psy);
 	psy_unregister_thermal(psy);
-	device_init_wakeup(psy->dev, false);
-	device_unregister(psy->dev);
+	device_init_wakeup(dev, false);
+	device_unregister(dev);
 }
 EXPORT_SYMBOL_GPL(power_supply_unregister);
 
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 3ed049673022..44e749c65505 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -189,6 +189,12 @@ struct power_supply {
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
@@ -268,6 +274,16 @@ extern int power_supply_is_system_supplied(void);
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
+extern void power_supply_set_charged(struct power_supply *psy);
 extern int power_supply_register(struct device *parent,
 				 struct power_supply *psy);
 extern int power_supply_register_no_ws(struct device *parent,
-- 
1.9.1

