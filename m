Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448AbaKDPBz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 10:01:55 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:53934 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312AbaKDPBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 10:01:50 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-18-5458ea5bea62
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
Subject: [PATCH RESEND v2 1/8] power_supply: Add API for safe access of power
 supply function attrs
Date: Tue, 04 Nov 2014 16:01:34 +0100
Message-id: <1415113301-25661-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1415113301-25661-1-git-send-email-k.kozlowski@samsung.com>
References: <1415113301-25661-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t/xy7rRryJCDObd0rE4uFXTYuOM9awW
	k568Z7aYuHIys0Xn2SfMFq9fGFqcbXrDbnH/61FGiyl/ljNZbHp8jdXi8q45bBafe48wWjxZ
	eIbJYu2Ru+wWtxtXsFncPXWUzeJ0N6vF6d0lDkIeE/o/MXrsnHWX3WPzCi2PTas62TzuXNvD
	5jHvZKDH5iX1Hju/N7B79G1ZxeixYvV3do/Pm+QCuKO4bFJSczLLUov07RK4Mi7fsClY4l7x
	5sJDpgbGOzZdjJwcEgImEk+3XmSBsMUkLtxbzwZiCwksZZQ4PEexi5ELyO5jkjh5dj9YEZuA
	scTm5UvYQBIiAteZJDpXTGABcZgFGpkl3jU0M4FUCQukSvyZ1sUOYrMIqEqsnvEYrJtXwF1i
	zaduVoh1chInj00GszkFPCQarv5hhVjtLrGit51tAiPvAkaGVYyiqaXJBcVJ6bmGesWJucWl
	eel6yfm5mxghIf9lB+PiY1aHGAU4GJV4eDPUI0KEWBPLiitzDzFKcDArifCqPwYK8aYkVlal
	FuXHF5XmpBYfYmTi4JRqYOTMmso9a2H+shBmNg7xCe/eCtwu+Sj9wt5ye+w1pTkzRZuO/Ge8
	yLfJzTZD/9fxuQ22E9OnrfMIeKY6d/mDnnWqvGvXG39ZuGTW7aj4wyq3qsql7J6x71rXkxaj
	dSDnmXwh82+vkx0FXa+5NmR9UTVwXR6bMuup4H5pfpnd2z7eXPNE/+ikVC0lluKMREMt5qLi
	RACz1RxfVwIAAA==
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
Acked-by: Jonghwa Lee <jonghwa3.lee@samusng.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/power/power_supply_core.c | 57 +++++++++++++++++++++++++++++++++++++--
 include/linux/power_supply.h      | 16 +++++++++++
 2 files changed, 71 insertions(+), 2 deletions(-)

diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index 694e8cddd5c1..bd8f5be0d976 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -366,6 +366,56 @@ struct power_supply *power_supply_get_by_phandle(struct device_node *np,
 EXPORT_SYMBOL_GPL(power_supply_get_by_phandle);
 #endif /* CONFIG_OF */
 
+int power_supply_get_property(struct power_supply *psy,
+			    enum power_supply_property psp,
+			    union power_supply_propval *val)
+{
+	if (!psy->dev)
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
+	if (!psy->dev || !psy->set_property)
+		return -ENODEV;
+
+	return psy->set_property(psy, psp, val);
+}
+EXPORT_SYMBOL_GPL(power_supply_set_property);
+
+int power_supply_property_is_writeable(struct power_supply *psy,
+					enum power_supply_property psp)
+{
+	if (!psy->dev || !psy->property_is_writeable)
+		return -ENODEV;
+
+	return psy->property_is_writeable(psy, psp);
+}
+EXPORT_SYMBOL_GPL(power_supply_property_is_writeable);
+
+void power_supply_external_power_changed(struct power_supply *psy)
+{
+	if (!psy->dev || !psy->external_power_changed)
+		return;
+
+	psy->external_power_changed(psy);
+}
+EXPORT_SYMBOL_GPL(power_supply_external_power_changed);
+
+void power_supply_set_charged(struct power_supply *psy)
+{
+	if (!psy->dev || !psy->set_charged)
+		return;
+
+	psy->set_charged(psy);
+}
+EXPORT_SYMBOL_GPL(power_supply_set_charged);
+
 int power_supply_powers(struct power_supply *psy, struct device *dev)
 {
 	return sysfs_create_link(&psy->dev->kobj, &dev->kobj, "powers");
@@ -619,13 +669,16 @@ EXPORT_SYMBOL_GPL(power_supply_register_no_ws);
 
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
index 096dbced02ac..0ef515301aaf 100644
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
@@ -274,6 +280,16 @@ extern int power_supply_is_system_supplied(void);
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

