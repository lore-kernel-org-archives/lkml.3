Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbbAEPv7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:51:59 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:56286 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421AbbAEPsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:48:24 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-ba-54aab24669ee
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Pavel Machek <pavel@ucw.cz>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RFC PATCHv2 11/19] power_supply: Change ownership from driver to core
Date: Mon, 05 Jan 2015 16:47:54 +0100
Message-id: <1420472882-10463-12-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420472882-10463-1-git-send-email-k.kozlowski@samsung.com>
References: <1420472882-10463-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t/xa7pum1aFGPR361lMevKe2WLiysnM
	Fq9fGFrsfPiWzWL5vn5Gi02Pr7FaXN41h83ic+8RRou7p46yWZw5fYnV4vTuEgduj52z7rJ7
	bF6h5bFpVSebx+Yl9R5brrazePRtWcXosWL1d3aPz5vkAjiiuGxSUnMyy1KL9O0SuDJeXP7M
	XPD/HXPF5dO32RsY78xh7mLk5JAQMJFoODidBcIWk7hwbz1bFyMXh5DAUkaJA8tAikCcPiaJ
	jbcfsYFUsQkYS2xevgSsSkTgCZPE9NaTYO3MAoYSP9/9YQexhQX8JW4ffgrWwCKgKvHq3jFW
	EJtXwEPiz5GvbBDr5CROHpsMFucEijf9vQA2R0jAXeLDs1+sExh5FzAyrGIUTS1NLihOSs81
	1CtOzC0uzUvXS87P3cQICc0vOxgXH7M6xCjAwajEw+txYmWIEGtiWXFl7iFGCQ5mJRHeV+mr
	QoR4UxIrq1KL8uOLSnNSiw8xMnFwSjUwak798/tHtptXJMucvjV3WVVOZTEpSfE1eHw/J9P5
	gbH6k+nJQ0W/mWZ9/qxW2Ju7R/Ln9xe1Ua4qzytXKK5K1bK2fRp0qrTmjcrUByUP1Bv+xDc/
	L5oZtcbr4m6+TfvEOOdWmNdv//pEyvnIolUPH0rppX9hONqylvn8j1fxyrUB9xJMtnEuVGIp
	zkg01GIuKk4EAIGiY5crAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the ownership of power_supply structure from each driver
implementing the class to the power supply core.

Each driver provides the implementation of power supply. However it
should not be the owner of 'power_supply' instance because it is exposed
by core to other subsystems with power_supply_get_by_name().  These
other subsystems have no knowledge when the driver will unregister the
power supply. This leads to several issues when driver is unbound -
mostly because user of power supply accesses freed memory.

Instead let the core own the instance of struct 'power_supply'.  Other
users of this power supply will still access valid memory because it
will be freed when device reference count reaches 0. Currently this
means "it will leak" but power_supply_put() call in next patches will
solve it.

This is a partial way of solving invalid memory references in following race
condition scenario:

Thread 1: charger manager
Thread 2: power supply driver, used by charger manager

THREAD 1 (charger manager)         THREAD 2 (power supply driver)
==========================         ==============================
psy = power_supply_get_by_name()
                                   Driver unbind, .remove
                                     power_supply_unregister()
                                     Device fully removed
psy->get_property()

The 'get_property' call is executed in invalid context because the driver was
unbound and struct 'power_supply' memory was freed.

This could be observed easily with charger manager driver (here compiled
with max17040 fuel gauge):
$ cat /sys/devices/virtual/power_supply/cm-battery/capacity &
$ echo "1-0036" > /sys/bus/i2c/drivers/max17040/unbind
[   55.725123] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[   55.732584] pgd = d98d4000
[   55.734060] [00000000] *pgd=5afa2831, *pte=00000000, *ppte=00000000
[   55.740318] Internal error: Oops: 80000007 [#1] PREEMPT SMP ARM
[   55.746210] Modules linked in:
[   55.749259] CPU: 1 PID: 2936 Comm: cat Tainted: G        W       3.19.0-rc1-next-20141226-00048-gf79f475f3c44-dirty #1496
[   55.760190] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
[   55.766270] task: d9b76f00 ti: daf54000 task.ti: daf54000
[   55.771647] PC is at 0x0
[   55.774182] LR is at charger_get_property+0x2f4/0x36c
[   55.779201] pc : [<00000000>]    lr : [<c034b0b4>]    psr: 60000013
[   55.779201] sp : daf55e90  ip : 00000003  fp : 00000000
[   55.790657] r10: 00000000  r9 : c06e2878  r8 : d9b26c68
[   55.795865] r7 : dad81610  r6 : daec7410  r5 : daf55ebc  r4 : 00000000
[   55.802367] r3 : 00000000  r2 : daf55ebc  r1 : 0000002a  r0 : d9b26c68
[   55.808879] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[   55.815994] Control: 10c5387d  Table: 598d406a  DAC: 00000015
[   55.821723] Process cat (pid: 2936, stack limit = 0xdaf54210)
[   55.827451] Stack: (0xdaf55e90 to 0xdaf56000)
[   55.831795] 5e80:                                     60000013 c01459c4 0000002a c06f8ef8
[   55.839956] 5ea0: db651000 c06f8ef8 daebac00 c04cb668 daebac08 c0346864 00000000 c01459c4
[   55.848115] 5ec0: d99eaa80 c06f8ef8 00000fff 00001000 db651000 c027f25c c027f240 d99eaa80
[   55.856274] 5ee0: d9a06c00 c0146218 daf55f18 00001000 d99eaa80 db4c18c0 00000001 00000001
[   55.864468] 5f00: daf55f80 c0144c78 c0144c54 c0107f90 00015000 d99eaab0 00000000 00000000
[   55.872603] 5f20: 000051c7 00000000 db4c18c0 c04a9370 00015000 00001000 daf55f80 00001000
[   55.880763] 5f40: daf54000 00015000 00000000 c00e53dc db4c18c0 c00e548c 0000000d 00008124
[   55.888937] 5f60: 00000001 00000000 00000000 db4c18c0 db4c18c0 00001000 00015000 c00e5550
[   55.897099] 5f80: 00000000 00000000 00001000 00001000 00015000 00000003 00000003 c000f364
[   55.905239] 5fa0: 00000000 c000f1a0 00001000 00015000 00000003 00015000 00001000 0001333c
[   55.913399] 5fc0: 00001000 00015000 00000003 00000003 00000002 00000000 00000000 00000000
[   55.921560] 5fe0: 7fffe000 be999850 0000a225 b6f3c19c 60000010 00000003 00000000 00000000
[   55.929744] [<c034b0b4>] (charger_get_property) from [<c0346864>] (power_supply_show_property+0x48/0x20c)
[   55.939286] [<c0346864>] (power_supply_show_property) from [<c027f25c>] (dev_attr_show+0x1c/0x48)
[   55.948130] [<c027f25c>] (dev_attr_show) from [<c0146218>] (sysfs_kf_seq_show+0x84/0x104)
[   55.956298] [<c0146218>] (sysfs_kf_seq_show) from [<c0144c78>] (kernfs_seq_show+0x24/0x28)
[   55.964536] [<c0144c78>] (kernfs_seq_show) from [<c0107f90>] (seq_read+0x1b0/0x484)
[   55.972172] [<c0107f90>] (seq_read) from [<c00e53dc>] (__vfs_read+0x18/0x4c)
[   55.979188] [<c00e53dc>] (__vfs_read) from [<c00e548c>] (vfs_read+0x7c/0x100)
[   55.986304] [<c00e548c>] (vfs_read) from [<c00e5550>] (SyS_read+0x40/0x8c)
[   55.993164] [<c00e5550>] (SyS_read) from [<c000f1a0>] (ret_fast_syscall+0x0/0x48)
[   56.000626] Code: bad PC value
[   56.011652] ---[ end trace 7b64343fbdae8ef1 ]---

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/power/bq24190_charger.c       | 103 ++++++++++++-------------
 drivers/power/charger-manager.c       |  53 ++++++-------
 drivers/power/max14577_charger.c      |  34 ++++----
 drivers/power/max17040_battery.c      |  31 ++++----
 drivers/power/max17042_battery.c      |  45 +++++++----
 drivers/power/power_supply_core.c     | 141 ++++++++++++++++++----------------
 drivers/power/power_supply_leds.c     |  25 +++---
 drivers/power/power_supply_sysfs.c    |  18 ++---
 drivers/power/sbs-battery.c           |  69 ++++++++---------
 drivers/power/tps65090-charger.c      |  43 ++++++-----
 include/linux/power/charger-manager.h |   3 +-
 include/linux/power_supply.h          |  39 ++++++----
 12 files changed, 323 insertions(+), 281 deletions(-)

diff --git a/drivers/power/bq24190_charger.c b/drivers/power/bq24190_charger.c
index f736c4c7c8fe..9215bc66fa88 100644
--- a/drivers/power/bq24190_charger.c
+++ b/drivers/power/bq24190_charger.c
@@ -152,8 +152,8 @@
 struct bq24190_dev_info {
 	struct i2c_client		*client;
 	struct device			*dev;
-	struct power_supply		charger;
-	struct power_supply		battery;
+	struct power_supply		*charger;
+	struct power_supply		*battery;
 	char				model_name[I2C_NAME_SIZE];
 	kernel_ulong_t			model;
 	unsigned int			gpio_int;
@@ -423,8 +423,7 @@ static ssize_t bq24190_sysfs_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct power_supply *psy = dev_get_drvdata(dev);
-	struct bq24190_dev_info *bdi =
-			container_of(psy, struct bq24190_dev_info, charger);
+	struct bq24190_dev_info *bdi = power_supply_get_drvdata(psy);
 	struct bq24190_sysfs_field_info *info;
 	int ret;
 	u8 v;
@@ -444,8 +443,7 @@ static ssize_t bq24190_sysfs_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct power_supply *psy = dev_get_drvdata(dev);
-	struct bq24190_dev_info *bdi =
-			container_of(psy, struct bq24190_dev_info, charger);
+	struct bq24190_dev_info *bdi = power_supply_get_drvdata(psy);
 	struct bq24190_sysfs_field_info *info;
 	int ret;
 	u8 v;
@@ -469,13 +467,13 @@ static int bq24190_sysfs_create_group(struct bq24190_dev_info *bdi)
 {
 	bq24190_sysfs_init_attrs();
 
-	return sysfs_create_group(&bdi->charger.dev->kobj,
+	return sysfs_create_group(&bdi->charger->dev.kobj,
 			&bq24190_sysfs_attr_group);
 }
 
 static void bq24190_sysfs_remove_group(struct bq24190_dev_info *bdi)
 {
-	sysfs_remove_group(&bdi->charger.dev->kobj, &bq24190_sysfs_attr_group);
+	sysfs_remove_group(&bdi->charger->dev.kobj, &bq24190_sysfs_attr_group);
 }
 #else
 static int bq24190_sysfs_create_group(struct bq24190_dev_info *bdi)
@@ -807,8 +805,7 @@ static int bq24190_charger_set_voltage(struct bq24190_dev_info *bdi,
 static int bq24190_charger_get_property(struct power_supply *psy,
 		enum power_supply_property psp, union power_supply_propval *val)
 {
-	struct bq24190_dev_info *bdi =
-			container_of(psy, struct bq24190_dev_info, charger);
+	struct bq24190_dev_info *bdi = power_supply_get_drvdata(psy);
 	int ret;
 
 	dev_dbg(bdi->dev, "prop: %d\n", psp);
@@ -861,8 +858,7 @@ static int bq24190_charger_set_property(struct power_supply *psy,
 		enum power_supply_property psp,
 		const union power_supply_propval *val)
 {
-	struct bq24190_dev_info *bdi =
-			container_of(psy, struct bq24190_dev_info, charger);
+	struct bq24190_dev_info *bdi = power_supply_get_drvdata(psy);
 	int ret;
 
 	dev_dbg(bdi->dev, "prop: %d\n", psp);
@@ -922,18 +918,15 @@ static char *bq24190_charger_supplied_to[] = {
 	"main-battery",
 };
 
-static void bq24190_charger_init(struct power_supply *charger)
-{
-	charger->name = "bq24190-charger";
-	charger->type = POWER_SUPPLY_TYPE_USB;
-	charger->properties = bq24190_charger_properties;
-	charger->num_properties = ARRAY_SIZE(bq24190_charger_properties);
-	charger->supplied_to = bq24190_charger_supplied_to;
-	charger->num_supplicants = ARRAY_SIZE(bq24190_charger_supplied_to);
-	charger->get_property = bq24190_charger_get_property;
-	charger->set_property = bq24190_charger_set_property;
-	charger->property_is_writeable = bq24190_charger_property_is_writeable;
-}
+static const struct power_supply_desc bq24190_charger_desc = {
+	.name = "bq24190-charger",
+	.type = POWER_SUPPLY_TYPE_USB,
+	.properties = bq24190_charger_properties,
+	.num_properties = ARRAY_SIZE(bq24190_charger_properties),
+	.get_property = bq24190_charger_get_property,
+	.set_property = bq24190_charger_set_property,
+	.property_is_writeable = bq24190_charger_property_is_writeable,
+};
 
 /* Battery power supply property routines */
 
@@ -1102,8 +1095,7 @@ static int bq24190_battery_set_temp_alert_max(struct bq24190_dev_info *bdi,
 static int bq24190_battery_get_property(struct power_supply *psy,
 		enum power_supply_property psp, union power_supply_propval *val)
 {
-	struct bq24190_dev_info *bdi =
-			container_of(psy, struct bq24190_dev_info, battery);
+	struct bq24190_dev_info *bdi = power_supply_get_drvdata(psy);
 	int ret;
 
 	dev_dbg(bdi->dev, "prop: %d\n", psp);
@@ -1144,8 +1136,7 @@ static int bq24190_battery_set_property(struct power_supply *psy,
 		enum power_supply_property psp,
 		const union power_supply_propval *val)
 {
-	struct bq24190_dev_info *bdi =
-			container_of(psy, struct bq24190_dev_info, battery);
+	struct bq24190_dev_info *bdi = power_supply_get_drvdata(psy);
 	int ret;
 
 	dev_dbg(bdi->dev, "prop: %d\n", psp);
@@ -1193,16 +1184,15 @@ static enum power_supply_property bq24190_battery_properties[] = {
 	POWER_SUPPLY_PROP_SCOPE,
 };
 
-static void bq24190_battery_init(struct power_supply *battery)
-{
-	battery->name = "bq24190-battery";
-	battery->type = POWER_SUPPLY_TYPE_BATTERY;
-	battery->properties = bq24190_battery_properties;
-	battery->num_properties = ARRAY_SIZE(bq24190_battery_properties);
-	battery->get_property = bq24190_battery_get_property;
-	battery->set_property = bq24190_battery_set_property;
-	battery->property_is_writeable = bq24190_battery_property_is_writeable;
-}
+static const struct power_supply_desc bq24190_battery_desc = {
+	.name = "bq24190-battery",
+	.type = POWER_SUPPLY_TYPE_BATTERY,
+	.properties = bq24190_battery_properties,
+	.num_properties = ARRAY_SIZE(bq24190_battery_properties),
+	.get_property = bq24190_battery_get_property,
+	.set_property = bq24190_battery_set_property,
+	.property_is_writeable = bq24190_battery_property_is_writeable,
+};
 
 static irqreturn_t bq24190_irq_handler_thread(int irq, void *data)
 {
@@ -1269,8 +1259,8 @@ static irqreturn_t bq24190_irq_handler_thread(int irq, void *data)
 	 * interrupt received).
 	 */
 	if (alert_userspace && !bdi->first_time) {
-		power_supply_changed(&bdi->charger);
-		power_supply_changed(&bdi->battery);
+		power_supply_changed(bdi->charger);
+		power_supply_changed(bdi->battery);
 		bdi->first_time = false;
 	}
 
@@ -1362,6 +1352,7 @@ static int bq24190_probe(struct i2c_client *client,
 	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
 	struct device *dev = &client->dev;
 	struct bq24190_platform_data *pdata = client->dev.platform_data;
+	struct power_supply_config charger_cfg = {}, battery_cfg = {};
 	struct bq24190_dev_info *bdi;
 	int ret;
 
@@ -1416,19 +1407,23 @@ static int bq24190_probe(struct i2c_client *client,
 		goto out2;
 	}
 
-	bq24190_charger_init(&bdi->charger);
-
-	ret = power_supply_register(dev, &bdi->charger, NULL);
-	if (ret) {
+	charger_cfg.drv_data = bdi;
+	charger_cfg.supplied_to = bq24190_charger_supplied_to;
+	charger_cfg.num_supplicants = ARRAY_SIZE(bq24190_charger_supplied_to),
+	bdi->charger = power_supply_register(dev, &bq24190_charger_desc,
+						&charger_cfg);
+	if (IS_ERR(bdi->charger)) {
 		dev_err(dev, "Can't register charger\n");
+		ret = PTR_ERR(bdi->charger);
 		goto out2;
 	}
 
-	bq24190_battery_init(&bdi->battery);
-
-	ret = power_supply_register(dev, &bdi->battery, NULL);
-	if (ret) {
+	battery_cfg.drv_data = bdi;
+	bdi->battery = power_supply_register(dev, &bq24190_battery_desc,
+						&battery_cfg);
+	if (IS_ERR(bdi->battery)) {
 		dev_err(dev, "Can't register battery\n");
+		ret = PTR_ERR(bdi->battery);
 		goto out3;
 	}
 
@@ -1441,9 +1436,9 @@ static int bq24190_probe(struct i2c_client *client,
 	return 0;
 
 out4:
-	power_supply_unregister(&bdi->battery);
+	power_supply_unregister(bdi->battery);
 out3:
-	power_supply_unregister(&bdi->charger);
+	power_supply_unregister(bdi->charger);
 out2:
 	pm_runtime_disable(dev);
 out1:
@@ -1462,8 +1457,8 @@ static int bq24190_remove(struct i2c_client *client)
 	pm_runtime_put_sync(bdi->dev);
 
 	bq24190_sysfs_remove_group(bdi);
-	power_supply_unregister(&bdi->battery);
-	power_supply_unregister(&bdi->charger);
+	power_supply_unregister(bdi->battery);
+	power_supply_unregister(bdi->charger);
 	pm_runtime_disable(bdi->dev);
 
 	if (bdi->gpio_int)
@@ -1499,8 +1494,8 @@ static int bq24190_pm_resume(struct device *dev)
 	pm_runtime_put_sync(bdi->dev);
 
 	/* Things may have changed while suspended so alert upper layer */
-	power_supply_changed(&bdi->charger);
-	power_supply_changed(&bdi->battery);
+	power_supply_changed(bdi->charger);
+	power_supply_changed(bdi->battery);
 
 	return 0;
 }
diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index 1d5065ebbd83..a9870b9ff571 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -874,8 +874,7 @@ static int charger_get_property(struct power_supply *psy,
 		enum power_supply_property psp,
 		union power_supply_propval *val)
 {
-	struct charger_manager *cm = container_of(psy,
-			struct charger_manager, charger_psy);
+	struct charger_manager *cm = power_supply_get_drvdata(psy);
 	struct charger_desc *desc = cm->desc;
 	struct power_supply *fuel_gauge;
 	int ret = 0;
@@ -1032,7 +1031,7 @@ static enum power_supply_property default_charger_props[] = {
 	 */
 };
 
-static struct power_supply psy_default = {
+static const struct power_supply_desc psy_default = {
 	.name = "battery",
 	.type = POWER_SUPPLY_TYPE_BATTERY,
 	.properties = default_charger_props,
@@ -1534,7 +1533,7 @@ static int charger_manager_register_sysfs(struct charger_manager *cm)
 		dev_info(cm->dev, "'%s' regulator's externally_control is %d\n",
 			 charger->regulator_name, charger->externally_control);
 
-		ret = sysfs_create_group(&cm->charger_psy.dev->kobj,
+		ret = sysfs_create_group(&cm->charger_psy->dev.kobj,
 					&charger->attr_g);
 		if (ret < 0) {
 			dev_err(cm->dev, "Cannot create sysfs entry of %s regulator\n",
@@ -1566,9 +1565,9 @@ static int cm_init_thermal_data(struct charger_manager *cm,
 					POWER_SUPPLY_PROP_TEMP, &val);
 
 	if (!ret) {
-		cm->charger_psy.properties[cm->charger_psy.num_properties] =
+		cm->charger_psy_desc.properties[cm->charger_psy_desc.num_properties] =
 				POWER_SUPPLY_PROP_TEMP;
-		cm->charger_psy.num_properties++;
+		cm->charger_psy_desc.num_properties++;
 		cm->desc->measure_battery_temp = true;
 	}
 #ifdef CONFIG_THERMAL
@@ -1579,9 +1578,9 @@ static int cm_init_thermal_data(struct charger_manager *cm,
 			return PTR_ERR(cm->tzd_batt);
 
 		/* Use external thermometer */
-		cm->charger_psy.properties[cm->charger_psy.num_properties] =
+		cm->charger_psy_desc.properties[cm->charger_psy_desc.num_properties] =
 				POWER_SUPPLY_PROP_TEMP_AMBIENT;
-		cm->charger_psy.num_properties++;
+		cm->charger_psy_desc.num_properties++;
 		cm->desc->measure_battery_temp = true;
 		ret = 0;
 	}
@@ -1735,6 +1734,7 @@ static int charger_manager_probe(struct platform_device *pdev)
 	int j = 0;
 	union power_supply_propval val;
 	struct power_supply *fuel_gauge;
+	struct power_supply_config psy_cfg = {};
 
 	if (g_desc && !rtc_dev && g_desc->rtc_name) {
 		rtc_dev = rtc_class_open(g_desc->rtc_name);
@@ -1759,6 +1759,7 @@ static int charger_manager_probe(struct platform_device *pdev)
 	/* Basic Values. Unspecified are Null or 0 */
 	cm->dev = &pdev->dev;
 	cm->desc = desc;
+	psy_cfg.drv_data = cm;
 
 	/*
 	 * The following two do not need to be errors.
@@ -1832,40 +1833,40 @@ static int charger_manager_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, cm);
 
-	memcpy(&cm->charger_psy, &psy_default, sizeof(psy_default));
+	memcpy(&cm->charger_psy_desc, &psy_default, sizeof(psy_default));
 
 	if (!desc->psy_name)
 		strncpy(cm->psy_name_buf, psy_default.name, PSY_NAME_MAX);
 	else
 		strncpy(cm->psy_name_buf, desc->psy_name, PSY_NAME_MAX);
-	cm->charger_psy.name = cm->psy_name_buf;
+	cm->charger_psy_desc.name = cm->psy_name_buf;
 
 	/* Allocate for psy properties because they may vary */
-	cm->charger_psy.properties = devm_kzalloc(&pdev->dev,
+	cm->charger_psy_desc.properties = devm_kzalloc(&pdev->dev,
 				sizeof(enum power_supply_property)
 				* (ARRAY_SIZE(default_charger_props) +
 				NUM_CHARGER_PSY_OPTIONAL), GFP_KERNEL);
-	if (!cm->charger_psy.properties)
+	if (!cm->charger_psy_desc.properties)
 		return -ENOMEM;
 
-	memcpy(cm->charger_psy.properties, default_charger_props,
+	memcpy(cm->charger_psy_desc.properties, default_charger_props,
 		sizeof(enum power_supply_property) *
 		ARRAY_SIZE(default_charger_props));
-	cm->charger_psy.num_properties = psy_default.num_properties;
+	cm->charger_psy_desc.num_properties = psy_default.num_properties;
 
 	/* Find which optional psy-properties are available */
 	if (!power_supply_get_property(fuel_gauge,
 					  POWER_SUPPLY_PROP_CHARGE_NOW, &val)) {
-		cm->charger_psy.properties[cm->charger_psy.num_properties] =
+		cm->charger_psy_desc.properties[cm->charger_psy_desc.num_properties] =
 				POWER_SUPPLY_PROP_CHARGE_NOW;
-		cm->charger_psy.num_properties++;
+		cm->charger_psy_desc.num_properties++;
 	}
 	if (!power_supply_get_property(fuel_gauge,
 					  POWER_SUPPLY_PROP_CURRENT_NOW,
 					  &val)) {
-		cm->charger_psy.properties[cm->charger_psy.num_properties] =
+		cm->charger_psy_desc.properties[cm->charger_psy_desc.num_properties] =
 				POWER_SUPPLY_PROP_CURRENT_NOW;
-		cm->charger_psy.num_properties++;
+		cm->charger_psy_desc.num_properties++;
 	}
 
 	ret = cm_init_thermal_data(cm, fuel_gauge);
@@ -1876,11 +1877,11 @@ static int charger_manager_probe(struct platform_device *pdev)
 
 	INIT_DELAYED_WORK(&cm->fullbatt_vchk_work, fullbatt_vchk);
 
-	ret = power_supply_register(NULL, &cm->charger_psy, NULL);
-	if (ret) {
+	cm->charger_psy = power_supply_register(NULL, &cm->charger_psy_desc, &psy_cfg);
+	if (IS_ERR(cm->charger_psy)) {
 		dev_err(&pdev->dev, "Cannot register charger-manager with name \"%s\"\n",
-			cm->charger_psy.name);
-		return ret;
+			cm->charger_psy->desc->name);
+		return PTR_ERR(cm->charger_psy);
 	}
 
 	/* Register extcon device for charger cable */
@@ -1926,7 +1927,7 @@ err_reg_sysfs:
 		struct charger_regulator *charger;
 
 		charger = &desc->charger_regulators[i];
-		sysfs_remove_group(&cm->charger_psy.dev->kobj,
+		sysfs_remove_group(&cm->charger_psy->dev.kobj,
 				&charger->attr_g);
 	}
 err_reg_extcon:
@@ -1944,7 +1945,7 @@ err_reg_extcon:
 		regulator_put(desc->charger_regulators[i].consumer);
 	}
 
-	power_supply_unregister(&cm->charger_psy);
+	power_supply_unregister(cm->charger_psy);
 
 	return ret;
 }
@@ -1976,7 +1977,7 @@ static int charger_manager_remove(struct platform_device *pdev)
 	for (i = 0 ; i < desc->num_charger_regulators ; i++)
 		regulator_put(desc->charger_regulators[i].consumer);
 
-	power_supply_unregister(&cm->charger_psy);
+	power_supply_unregister(cm->charger_psy);
 
 	try_charger_enable(cm, false);
 
@@ -2132,7 +2133,7 @@ static bool find_power_supply(struct charger_manager *cm,
 	bool found = false;
 
 	for (i = 0; cm->desc->psy_charger_stat[i]; i++) {
-		if (!strcmp(psy->name, cm->desc->psy_charger_stat[i])) {
+		if (!strcmp(psy->desc->name, cm->desc->psy_charger_stat[i])) {
 			found = true;
 			break;
 		}
diff --git a/drivers/power/max14577_charger.c b/drivers/power/max14577_charger.c
index 8f113ed73e6c..70d601f82098 100644
--- a/drivers/power/max14577_charger.c
+++ b/drivers/power/max14577_charger.c
@@ -22,9 +22,9 @@
 #include <linux/mfd/max14577.h>
 
 struct max14577_charger {
-	struct device *dev;
-	struct max14577	*max14577;
-	struct power_supply	charger;
+	struct device		*dev;
+	struct max14577		*max14577;
+	struct power_supply	*charger;
 
 	unsigned int		charging_state;
 	unsigned int		battery_state;
@@ -389,9 +389,7 @@ static int max14577_charger_get_property(struct power_supply *psy,
 			    enum power_supply_property psp,
 			    union power_supply_propval *val)
 {
-	struct max14577_charger *chg = container_of(psy,
-						  struct max14577_charger,
-						  charger);
+	struct max14577_charger *chg = power_supply_get_drvdata(psy);
 	int ret = 0;
 
 	switch (psp) {
@@ -424,6 +422,14 @@ static int max14577_charger_get_property(struct power_supply *psy,
 	return ret;
 }
 
+static const struct power_supply_desc max14577_charger_desc = {
+	.name = "max14577-charger",
+	.type = POWER_SUPPLY_TYPE_BATTERY,
+	.properties = max14577_charger_props,
+	.num_properties = ARRAY_SIZE(max14577_charger_props),
+	.get_property = max14577_charger_get_property,
+};
+
 #ifdef CONFIG_OF
 static struct max14577_charger_platform_data *max14577_charger_dt_init(
 		struct platform_device *pdev)
@@ -531,6 +537,7 @@ static DEVICE_ATTR(fast_charge_timer, S_IRUGO | S_IWUSR,
 static int max14577_charger_probe(struct platform_device *pdev)
 {
 	struct max14577_charger *chg;
+	struct power_supply_config psy_cfg = {};
 	struct max14577 *max14577 = dev_get_drvdata(pdev->dev.parent);
 	int ret;
 
@@ -550,21 +557,18 @@ static int max14577_charger_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	chg->charger.name = "max14577-charger",
-	chg->charger.type = POWER_SUPPLY_TYPE_BATTERY,
-	chg->charger.properties = max14577_charger_props,
-	chg->charger.num_properties = ARRAY_SIZE(max14577_charger_props),
-	chg->charger.get_property = max14577_charger_get_property,
-
 	ret = device_create_file(&pdev->dev, &dev_attr_fast_charge_timer);
 	if (ret) {
 		dev_err(&pdev->dev, "failed: create sysfs entry\n");
 		return ret;
 	}
 
-	ret = power_supply_register(&pdev->dev, &chg->charger, NULL);
-	if (ret) {
+	psy_cfg.drv_data = chg;
+	chg->charger = power_supply_register(&pdev->dev, &max14577_charger_desc,
+						&psy_cfg);
+	if (IS_ERR(chg->charger)) {
 		dev_err(&pdev->dev, "failed: power supply register\n");
+		ret = PTR_ERR(chg->charger);
 		goto err;
 	}
 
@@ -585,7 +589,7 @@ static int max14577_charger_remove(struct platform_device *pdev)
 	struct max14577_charger *chg = platform_get_drvdata(pdev);
 
 	device_remove_file(&pdev->dev, &dev_attr_fast_charge_timer);
-	power_supply_unregister(&chg->charger);
+	power_supply_unregister(chg->charger);
 
 	return 0;
 }
diff --git a/drivers/power/max17040_battery.c b/drivers/power/max17040_battery.c
index bf42c57a4247..2bfe4bbbc29a 100644
--- a/drivers/power/max17040_battery.c
+++ b/drivers/power/max17040_battery.c
@@ -40,7 +40,7 @@
 struct max17040_chip {
 	struct i2c_client		*client;
 	struct delayed_work		work;
-	struct power_supply		battery;
+	struct power_supply		*battery;
 	struct max17040_platform_data	*pdata;
 
 	/* State Of Connect */
@@ -57,8 +57,7 @@ static int max17040_get_property(struct power_supply *psy,
 			    enum power_supply_property psp,
 			    union power_supply_propval *val)
 {
-	struct max17040_chip *chip = container_of(psy,
-				struct max17040_chip, battery);
+	struct max17040_chip *chip = power_supply_get_drvdata(psy);
 
 	switch (psp) {
 	case POWER_SUPPLY_PROP_STATUS:
@@ -198,12 +197,20 @@ static enum power_supply_property max17040_battery_props[] = {
 	POWER_SUPPLY_PROP_CAPACITY,
 };
 
+static const struct power_supply_desc max17040_battery_desc = {
+	.name		= "battery",
+	.type		= POWER_SUPPLY_TYPE_BATTERY,
+	.get_property	= max17040_get_property,
+	.properties	= max17040_battery_props,
+	.num_properties	= ARRAY_SIZE(max17040_battery_props),
+};
+
 static int max17040_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
 	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
+	struct power_supply_config psy_cfg = {};
 	struct max17040_chip *chip;
-	int ret;
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE))
 		return -EIO;
@@ -216,17 +223,13 @@ static int max17040_probe(struct i2c_client *client,
 	chip->pdata = client->dev.platform_data;
 
 	i2c_set_clientdata(client, chip);
+	psy_cfg.drv_data = chip;
 
-	chip->battery.name		= "battery";
-	chip->battery.type		= POWER_SUPPLY_TYPE_BATTERY;
-	chip->battery.get_property	= max17040_get_property;
-	chip->battery.properties	= max17040_battery_props;
-	chip->battery.num_properties	= ARRAY_SIZE(max17040_battery_props);
-
-	ret = power_supply_register(&client->dev, &chip->battery, NULL);
-	if (ret) {
+	chip->battery = power_supply_register(&client->dev,
+				&max17040_battery_desc, &psy_cfg);
+	if (IS_ERR(chip->battery)) {
 		dev_err(&client->dev, "failed: power supply register\n");
-		return ret;
+		return PTR_ERR(chip->battery);
 	}
 
 	max17040_reset(client);
@@ -242,7 +245,7 @@ static int max17040_remove(struct i2c_client *client)
 {
 	struct max17040_chip *chip = i2c_get_clientdata(client);
 
-	power_supply_unregister(&chip->battery);
+	power_supply_unregister(chip->battery);
 	cancel_delayed_work(&chip->work);
 	return 0;
 }
diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
index c62d1428803e..40e7056d211e 100644
--- a/drivers/power/max17042_battery.c
+++ b/drivers/power/max17042_battery.c
@@ -69,7 +69,7 @@
 struct max17042_chip {
 	struct i2c_client *client;
 	struct regmap *regmap;
-	struct power_supply battery;
+	struct power_supply *battery;
 	enum max170xx_chip_type chip_type;
 	struct max17042_platform_data *pdata;
 	struct work_struct work;
@@ -96,8 +96,7 @@ static int max17042_get_property(struct power_supply *psy,
 			    enum power_supply_property psp,
 			    union power_supply_propval *val)
 {
-	struct max17042_chip *chip = container_of(psy,
-				struct max17042_chip, battery);
+	struct max17042_chip *chip = power_supply_get_drvdata(psy);
 	struct regmap *map = chip->regmap;
 	int ret;
 	u32 data;
@@ -604,7 +603,7 @@ static irqreturn_t max17042_thread_handler(int id, void *dev)
 		max17042_set_soc_threshold(chip, 1);
 	}
 
-	power_supply_changed(&chip->battery);
+	power_supply_changed(chip->battery);
 	return IRQ_HANDLED;
 }
 
@@ -664,10 +663,28 @@ static const struct regmap_config max17042_regmap_config = {
 	.val_format_endian = REGMAP_ENDIAN_NATIVE,
 };
 
+static const struct power_supply_desc max17042_psy_desc = {
+	.name		= "max170xx_battery",
+	.type		= POWER_SUPPLY_TYPE_BATTERY,
+	.get_property	= max17042_get_property,
+	.properties	= max17042_battery_props,
+	.num_properties	= ARRAY_SIZE(max17042_battery_props),
+};
+
+static const struct power_supply_desc max17042_no_current_sense_psy_desc = {
+	.name		= "max170xx_battery",
+	.type		= POWER_SUPPLY_TYPE_BATTERY,
+	.get_property	= max17042_get_property,
+	.properties	= max17042_battery_props,
+	.num_properties	= ARRAY_SIZE(max17042_battery_props) - 2,
+};
+
 static int max17042_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
 	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
+	const struct power_supply_desc *max17042_desc = &max17042_psy_desc;
+	struct power_supply_config psy_cfg = {};
 	struct max17042_chip *chip;
 	int ret;
 	int i;
@@ -694,6 +711,7 @@ static int max17042_probe(struct i2c_client *client,
 	}
 
 	i2c_set_clientdata(client, chip);
+	psy_cfg.drv_data = chip;
 
 	regmap_read(chip->regmap, MAX17042_DevName, &val);
 	if (val == MAX17042_IC_VERSION) {
@@ -707,16 +725,10 @@ static int max17042_probe(struct i2c_client *client,
 		return -EIO;
 	}
 
-	chip->battery.name		= "max170xx_battery";
-	chip->battery.type		= POWER_SUPPLY_TYPE_BATTERY;
-	chip->battery.get_property	= max17042_get_property;
-	chip->battery.properties	= max17042_battery_props;
-	chip->battery.num_properties	= ARRAY_SIZE(max17042_battery_props);
-
 	/* When current is not measured,
 	 * CURRENT_NOW and CURRENT_AVG properties should be invisible. */
 	if (!chip->pdata->enable_current_sense)
-		chip->battery.num_properties -= 2;
+		max17042_desc = &max17042_no_current_sense_psy_desc;
 
 	if (chip->pdata->r_sns == 0)
 		chip->pdata->r_sns = MAX17042_DEFAULT_SNS_RESISTOR;
@@ -733,17 +745,18 @@ static int max17042_probe(struct i2c_client *client,
 		regmap_write(chip->regmap, MAX17042_LearnCFG, 0x0007);
 	}
 
-	ret = power_supply_register(&client->dev, &chip->battery, NULL);
-	if (ret) {
+	chip->battery = power_supply_register(&client->dev, max17042_desc,
+						&psy_cfg);
+	if (IS_ERR(chip->battery)) {
 		dev_err(&client->dev, "failed: power supply register\n");
-		return ret;
+		return PTR_ERR(chip->battery);
 	}
 
 	if (client->irq) {
 		ret = request_threaded_irq(client->irq, NULL,
 					max17042_thread_handler,
 					IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
-					chip->battery.name, chip);
+					chip->battery->desc->name, chip);
 		if (!ret) {
 			regmap_read(chip->regmap, MAX17042_CONFIG, &val);
 			val |= CONFIG_ALRT_BIT_ENBL;
@@ -773,7 +786,7 @@ static int max17042_remove(struct i2c_client *client)
 
 	if (client->irq)
 		free_irq(client->irq, chip);
-	power_supply_unregister(&chip->battery);
+	power_supply_unregister(chip->battery);
 	return 0;
 }
 
diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index fdec3c29fc3c..ec9ac01074c7 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -40,16 +40,16 @@ static bool __power_supply_is_supplied_by(struct power_supply *supplier,
 
 	/* Support both supplied_to and supplied_from modes */
 	if (supply->supplied_from) {
-		if (!supplier->name)
+		if (!supplier->desc->name)
 			return false;
 		for (i = 0; i < supply->num_supplies; i++)
-			if (!strcmp(supplier->name, supply->supplied_from[i]))
+			if (!strcmp(supplier->desc->name, supply->supplied_from[i]))
 				return true;
 	} else {
-		if (!supply->name)
+		if (!supply->desc->name)
 			return false;
 		for (i = 0; i < supplier->num_supplicants; i++)
-			if (!strcmp(supplier->supplied_to[i], supply->name))
+			if (!strcmp(supplier->supplied_to[i], supply->desc->name))
 				return true;
 	}
 
@@ -62,8 +62,8 @@ static int __power_supply_changed_work(struct device *dev, void *data)
 	struct power_supply *pst = dev_get_drvdata(dev);
 
 	if (__power_supply_is_supplied_by(psy, pst)) {
-		if (pst->external_power_changed)
-			pst->external_power_changed(pst);
+		if (pst->desc->external_power_changed)
+			pst->desc->external_power_changed(pst);
 	}
 
 	return 0;
@@ -75,7 +75,7 @@ static void power_supply_changed_work(struct work_struct *work)
 	struct power_supply *psy = container_of(work, struct power_supply,
 						changed_work);
 
-	dev_dbg(psy->dev, "%s\n", __func__);
+	dev_dbg(&psy->dev, "%s\n", __func__);
 
 	spin_lock_irqsave(&psy->changed_lock, flags);
 	/*
@@ -93,7 +93,7 @@ static void power_supply_changed_work(struct work_struct *work)
 		power_supply_update_leds(psy);
 		atomic_notifier_call_chain(&power_supply_notifier,
 				PSY_EVENT_PROP_CHANGED, psy);
-		kobject_uevent(&psy->dev->kobj, KOBJ_CHANGE);
+		kobject_uevent(&psy->dev.kobj, KOBJ_CHANGE);
 		spin_lock_irqsave(&psy->changed_lock, flags);
 	}
 
@@ -103,7 +103,7 @@ static void power_supply_changed_work(struct work_struct *work)
 	 * to true.
 	 */
 	if (likely(!psy->changed))
-		pm_relax(psy->dev);
+		pm_relax(&psy->dev);
 	spin_unlock_irqrestore(&psy->changed_lock, flags);
 }
 
@@ -111,11 +111,11 @@ void power_supply_changed(struct power_supply *psy)
 {
 	unsigned long flags;
 
-	dev_dbg(psy->dev, "%s\n", __func__);
+	dev_dbg(&psy->dev, "%s\n", __func__);
 
 	spin_lock_irqsave(&psy->changed_lock, flags);
 	psy->changed = true;
-	pm_stay_awake(psy->dev);
+	pm_stay_awake(&psy->dev);
 	spin_unlock_irqrestore(&psy->changed_lock, flags);
 	schedule_work(&psy->changed_work);
 }
@@ -138,9 +138,9 @@ static int __power_supply_populate_supplied_from(struct device *dev,
 			break;
 
 		if (np == epsy->of_node) {
-			dev_info(psy->dev, "%s: Found supply : %s\n",
-				psy->name, epsy->name);
-			psy->supplied_from[i-1] = (char *)epsy->name;
+			dev_info(&psy->dev, "%s: Found supply : %s\n",
+				psy->desc->name, epsy->desc->name);
+			psy->supplied_from[i-1] = (char *)epsy->desc->name;
 			psy->num_supplies++;
 			of_node_put(np);
 			break;
@@ -158,7 +158,7 @@ static int power_supply_populate_supplied_from(struct power_supply *psy)
 	error = class_for_each_device(power_supply_class, NULL, psy,
 				      __power_supply_populate_supplied_from);
 
-	dev_dbg(psy->dev, "%s %d\n", __func__, error);
+	dev_dbg(&psy->dev, "%s %d\n", __func__, error);
 
 	return error;
 }
@@ -220,7 +220,7 @@ static int power_supply_check_supplies(struct power_supply *psy)
 		of_node_put(np);
 
 		if (ret) {
-			dev_dbg(psy->dev, "Failed to find supply!\n");
+			dev_dbg(&psy->dev, "Failed to find supply!\n");
 			return ret;
 		}
 	} while (np);
@@ -230,17 +230,18 @@ static int power_supply_check_supplies(struct power_supply *psy)
 		return 0;
 
 	/* All supplies found, allocate char ** array for filling */
-	psy->supplied_from = devm_kzalloc(psy->dev, sizeof(psy->supplied_from),
+	psy->supplied_from = devm_kzalloc(&psy->dev, sizeof(psy->supplied_from),
 					  GFP_KERNEL);
 	if (!psy->supplied_from) {
-		dev_err(psy->dev, "Couldn't allocate memory for supply list\n");
+		dev_err(&psy->dev, "Couldn't allocate memory for supply list\n");
 		return -ENOMEM;
 	}
 
-	*psy->supplied_from = devm_kzalloc(psy->dev, sizeof(char *) * (cnt - 1),
+	*psy->supplied_from = devm_kzalloc(&psy->dev,
+					   sizeof(char *) * (cnt - 1),
 					   GFP_KERNEL);
 	if (!*psy->supplied_from) {
-		dev_err(psy->dev, "Couldn't allocate memory for supply list\n");
+		dev_err(&psy->dev, "Couldn't allocate memory for supply list\n");
 		return -ENOMEM;
 	}
 
@@ -260,7 +261,8 @@ static int __power_supply_am_i_supplied(struct device *dev, void *data)
 	struct power_supply *epsy = dev_get_drvdata(dev);
 
 	if (__power_supply_is_supplied_by(epsy, psy))
-		if (!epsy->get_property(epsy, POWER_SUPPLY_PROP_ONLINE, &ret))
+		if (!epsy->desc->get_property(epsy, POWER_SUPPLY_PROP_ONLINE,
+					&ret))
 			return ret.intval;
 
 	return 0;
@@ -273,7 +275,7 @@ int power_supply_am_i_supplied(struct power_supply *psy)
 	error = class_for_each_device(power_supply_class, NULL, psy,
 				      __power_supply_am_i_supplied);
 
-	dev_dbg(psy->dev, "%s %d\n", __func__, error);
+	dev_dbg(&psy->dev, "%s %d\n", __func__, error);
 
 	return error;
 }
@@ -286,8 +288,9 @@ static int __power_supply_is_system_supplied(struct device *dev, void *data)
 	unsigned int *count = data;
 
 	(*count)++;
-	if (psy->type != POWER_SUPPLY_TYPE_BATTERY)
-		if (!psy->get_property(psy, POWER_SUPPLY_PROP_ONLINE, &ret))
+	if (psy->desc->type != POWER_SUPPLY_TYPE_BATTERY)
+		if (!psy->desc->get_property(psy, POWER_SUPPLY_PROP_ONLINE,
+					&ret))
 			return ret.intval;
 
 	return 0;
@@ -314,9 +317,9 @@ EXPORT_SYMBOL_GPL(power_supply_is_system_supplied);
 
 int power_supply_set_battery_charged(struct power_supply *psy)
 {
-	if (psy->use_cnt >= 0 && psy->type == POWER_SUPPLY_TYPE_BATTERY &&
-			psy->set_charged) {
-		psy->set_charged(psy);
+	if (psy->use_cnt >= 0 && psy->desc->type == POWER_SUPPLY_TYPE_BATTERY &&
+			psy->desc->set_charged) {
+		psy->desc->set_charged(psy);
 		return 0;
 	}
 
@@ -329,7 +332,7 @@ static int power_supply_match_device_by_name(struct device *dev, const void *dat
 	const char *name = data;
 	struct power_supply *psy = dev_get_drvdata(dev);
 
-	return strcmp(psy->name, name) == 0;
+	return strcmp(psy->desc->name, name) == 0;
 }
 
 struct power_supply *power_supply_get_by_name(const char *name)
@@ -374,7 +377,7 @@ int power_supply_get_property(struct power_supply *psy,
 	if (psy->use_cnt <= 0)
 		return -ENODEV;
 
-	return psy->get_property(psy, psp, val);
+	return psy->desc->get_property(psy, psp, val);
 }
 EXPORT_SYMBOL_GPL(power_supply_get_property);
 
@@ -382,42 +385,43 @@ int power_supply_set_property(struct power_supply *psy,
 			    enum power_supply_property psp,
 			    const union power_supply_propval *val)
 {
-	if (psy->use_cnt <= 0 || !psy->set_property)
+	if (psy->use_cnt <= 0 || !psy->desc->set_property)
 		return -ENODEV;
 
-	return psy->set_property(psy, psp, val);
+	return psy->desc->set_property(psy, psp, val);
 }
 EXPORT_SYMBOL_GPL(power_supply_set_property);
 
 int power_supply_property_is_writeable(struct power_supply *psy,
 					enum power_supply_property psp)
 {
-	if (psy->use_cnt <= 0 || !psy->property_is_writeable)
+	if (psy->use_cnt <= 0 || !psy->desc->property_is_writeable)
 		return -ENODEV;
 
-	return psy->property_is_writeable(psy, psp);
+	return psy->desc->property_is_writeable(psy, psp);
 }
 EXPORT_SYMBOL_GPL(power_supply_property_is_writeable);
 
 void power_supply_external_power_changed(struct power_supply *psy)
 {
-	if (psy->use_cnt <= 0 || !psy->external_power_changed)
+	if (psy->use_cnt <= 0 || !psy->desc->external_power_changed)
 		return;
 
-	psy->external_power_changed(psy);
+	psy->desc->external_power_changed(psy);
 }
 EXPORT_SYMBOL_GPL(power_supply_external_power_changed);
 
 int power_supply_powers(struct power_supply *psy, struct device *dev)
 {
-	return sysfs_create_link(&psy->dev->kobj, &dev->kobj, "powers");
+	return sysfs_create_link(&psy->dev.kobj, &dev->kobj, "powers");
 }
 EXPORT_SYMBOL_GPL(power_supply_powers);
 
 static void power_supply_dev_release(struct device *dev)
 {
+	struct power_supply *psy = container_of(dev, struct power_supply, dev);
 	pr_debug("device: '%s': %s\n", dev_name(dev), __func__);
-	kfree(dev);
+	kfree(psy);
 }
 
 int power_supply_reg_notifier(struct notifier_block *nb)
@@ -442,7 +446,7 @@ static int power_supply_read_temp(struct thermal_zone_device *tzd,
 
 	WARN_ON(tzd == NULL);
 	psy = tzd->devdata;
-	ret = psy->get_property(psy, POWER_SUPPLY_PROP_TEMP, &val);
+	ret = psy->desc->get_property(psy, POWER_SUPPLY_PROP_TEMP, &val);
 
 	/* Convert tenths of degree Celsius to milli degree Celsius. */
 	if (!ret)
@@ -459,14 +463,14 @@ static int psy_register_thermal(struct power_supply *psy)
 {
 	int i;
 
-	if (psy->no_thermal)
+	if (psy->desc->no_thermal)
 		return 0;
 
 	/* Register battery zone device psy reports temperature */
-	for (i = 0; i < psy->num_properties; i++) {
-		if (psy->properties[i] == POWER_SUPPLY_PROP_TEMP) {
-			psy->tzd = thermal_zone_device_register(psy->name, 0, 0,
-					psy, &psy_tzd_ops, NULL, 0, 0);
+	for (i = 0; i < psy->desc->num_properties; i++) {
+		if (psy->desc->properties[i] == POWER_SUPPLY_PROP_TEMP) {
+			psy->tzd = thermal_zone_device_register(psy->desc->name,
+					0, 0, psy, &psy_tzd_ops, NULL, 0, 0);
 			return PTR_ERR_OR_ZERO(psy->tzd);
 		}
 	}
@@ -489,7 +493,7 @@ static int ps_get_max_charge_cntl_limit(struct thermal_cooling_device *tcd,
 	int ret;
 
 	psy = tcd->devdata;
-	ret = psy->get_property(psy,
+	ret = psy->desc->get_property(psy,
 		POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT_MAX, &val);
 	if (!ret)
 		*state = val.intval;
@@ -505,7 +509,7 @@ static int ps_get_cur_chrage_cntl_limit(struct thermal_cooling_device *tcd,
 	int ret;
 
 	psy = tcd->devdata;
-	ret = psy->get_property(psy,
+	ret = psy->desc->get_property(psy,
 		POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT, &val);
 	if (!ret)
 		*state = val.intval;
@@ -522,7 +526,7 @@ static int ps_set_cur_charge_cntl_limit(struct thermal_cooling_device *tcd,
 
 	psy = tcd->devdata;
 	val.intval = state;
-	ret = psy->set_property(psy,
+	ret = psy->desc->set_property(psy,
 		POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT, &val);
 
 	return ret;
@@ -539,11 +543,11 @@ static int psy_register_cooler(struct power_supply *psy)
 	int i;
 
 	/* Register for cooling device if psy can control charging */
-	for (i = 0; i < psy->num_properties; i++) {
-		if (psy->properties[i] ==
+	for (i = 0; i < psy->desc->num_properties; i++) {
+		if (psy->desc->properties[i] ==
 				POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT) {
 			psy->tcd = thermal_cooling_device_register(
-							(char *)psy->name,
+							(char *)psy->desc->name,
 							psy, &psy_tcd_ops);
 			return PTR_ERR_OR_ZERO(psy->tcd);
 		}
@@ -577,17 +581,21 @@ static void psy_unregister_cooler(struct power_supply *psy)
 }
 #endif
 
-static int __power_supply_register(struct device *parent,
-				   struct power_supply *psy,
+static struct power_supply *__must_check
+__power_supply_register(struct device *parent,
+				   const struct power_supply_desc *desc,
 				   const struct power_supply_config *cfg,
 				   bool ws)
 {
 	struct device *dev;
+	struct power_supply *psy;
 	int rc;
 
-	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
-	if (!dev)
-		return -ENOMEM;
+	psy = kzalloc(sizeof(*psy), GFP_KERNEL);
+	if (!psy)
+		return ERR_PTR(-ENOMEM);
+
+	dev = &psy->dev;
 
 	device_initialize(dev);
 
@@ -596,7 +604,7 @@ static int __power_supply_register(struct device *parent,
 	dev->parent = parent;
 	dev->release = power_supply_dev_release;
 	dev_set_drvdata(dev, psy);
-	psy->dev = dev;
+	psy->desc = desc;
 	psy->use_cnt++;
 	if (cfg) {
 		psy->drv_data = cfg->drv_data;
@@ -605,7 +613,7 @@ static int __power_supply_register(struct device *parent,
 		psy->num_supplicants = cfg->num_supplicants;
 	}
 
-	rc = dev_set_name(dev, "%s", psy->name);
+	rc = dev_set_name(dev, "%s", desc->name);
 	if (rc)
 		goto dev_set_name_failed;
 
@@ -640,7 +648,7 @@ static int __power_supply_register(struct device *parent,
 
 	power_supply_changed(psy);
 
-	return 0;
+	return psy;
 
 create_triggers_failed:
 	psy_unregister_cooler(psy);
@@ -653,20 +661,23 @@ wakeup_init_failed:
 check_supplies_failed:
 dev_set_name_failed:
 	put_device(dev);
-	return rc;
+	return ERR_PTR(rc);
 }
 
-int power_supply_register(struct device *parent, struct power_supply *psy,
+struct power_supply *__must_check power_supply_register(struct device *parent,
+		const struct power_supply_desc *desc,
 		const struct power_supply_config *cfg)
 {
-	return __power_supply_register(parent, psy, cfg, true);
+	return __power_supply_register(parent, desc, cfg, true);
 }
 EXPORT_SYMBOL_GPL(power_supply_register);
 
-int power_supply_register_no_ws(struct device *parent, struct power_supply *psy,
+struct power_supply *__must_check
+power_supply_register_no_ws(struct device *parent,
+		const struct power_supply_desc *desc,
 		const struct power_supply_config *cfg)
 {
-	return __power_supply_register(parent, psy, cfg, false);
+	return __power_supply_register(parent, desc, cfg, false);
 }
 EXPORT_SYMBOL_GPL(power_supply_register_no_ws);
 
@@ -675,12 +686,12 @@ void power_supply_unregister(struct power_supply *psy)
 	psy->use_cnt--;
 	WARN_ON(psy->use_cnt);
 	cancel_work_sync(&psy->changed_work);
-	sysfs_remove_link(&psy->dev->kobj, "powers");
+	sysfs_remove_link(&psy->dev.kobj, "powers");
 	power_supply_remove_triggers(psy);
 	psy_unregister_cooler(psy);
 	psy_unregister_thermal(psy);
-	device_init_wakeup(psy->dev, false);
-	device_unregister(psy->dev);
+	device_init_wakeup(&psy->dev, false);
+	device_unregister(&psy->dev);
 }
 EXPORT_SYMBOL_GPL(power_supply_unregister);
 
diff --git a/drivers/power/power_supply_leds.c b/drivers/power/power_supply_leds.c
index effa093c37b0..2d41a43fc81a 100644
--- a/drivers/power/power_supply_leds.c
+++ b/drivers/power/power_supply_leds.c
@@ -25,10 +25,10 @@ static void power_supply_update_bat_leds(struct power_supply *psy)
 	unsigned long delay_on = 0;
 	unsigned long delay_off = 0;
 
-	if (psy->get_property(psy, POWER_SUPPLY_PROP_STATUS, &status))
+	if (psy->desc->get_property(psy, POWER_SUPPLY_PROP_STATUS, &status))
 		return;
 
-	dev_dbg(psy->dev, "%s %d\n", __func__, status.intval);
+	dev_dbg(&psy->dev, "%s %d\n", __func__, status.intval);
 
 	switch (status.intval) {
 	case POWER_SUPPLY_STATUS_FULL:
@@ -58,21 +58,21 @@ static void power_supply_update_bat_leds(struct power_supply *psy)
 static int power_supply_create_bat_triggers(struct power_supply *psy)
 {
 	psy->charging_full_trig_name = kasprintf(GFP_KERNEL,
-					"%s-charging-or-full", psy->name);
+					"%s-charging-or-full", psy->desc->name);
 	if (!psy->charging_full_trig_name)
 		goto charging_full_failed;
 
 	psy->charging_trig_name = kasprintf(GFP_KERNEL,
-					"%s-charging", psy->name);
+					"%s-charging", psy->desc->name);
 	if (!psy->charging_trig_name)
 		goto charging_failed;
 
-	psy->full_trig_name = kasprintf(GFP_KERNEL, "%s-full", psy->name);
+	psy->full_trig_name = kasprintf(GFP_KERNEL, "%s-full", psy->desc->name);
 	if (!psy->full_trig_name)
 		goto full_failed;
 
 	psy->charging_blink_full_solid_trig_name = kasprintf(GFP_KERNEL,
-		"%s-charging-blink-full-solid", psy->name);
+		"%s-charging-blink-full-solid", psy->desc->name);
 	if (!psy->charging_blink_full_solid_trig_name)
 		goto charging_blink_full_solid_failed;
 
@@ -115,10 +115,10 @@ static void power_supply_update_gen_leds(struct power_supply *psy)
 {
 	union power_supply_propval online;
 
-	if (psy->get_property(psy, POWER_SUPPLY_PROP_ONLINE, &online))
+	if (psy->desc->get_property(psy, POWER_SUPPLY_PROP_ONLINE, &online))
 		return;
 
-	dev_dbg(psy->dev, "%s %d\n", __func__, online.intval);
+	dev_dbg(&psy->dev, "%s %d\n", __func__, online.intval);
 
 	if (online.intval)
 		led_trigger_event(psy->online_trig, LED_FULL);
@@ -128,7 +128,8 @@ static void power_supply_update_gen_leds(struct power_supply *psy)
 
 static int power_supply_create_gen_triggers(struct power_supply *psy)
 {
-	psy->online_trig_name = kasprintf(GFP_KERNEL, "%s-online", psy->name);
+	psy->online_trig_name = kasprintf(GFP_KERNEL, "%s-online",
+					  psy->desc->name);
 	if (!psy->online_trig_name)
 		return -ENOMEM;
 
@@ -147,7 +148,7 @@ static void power_supply_remove_gen_triggers(struct power_supply *psy)
 
 void power_supply_update_leds(struct power_supply *psy)
 {
-	if (psy->type == POWER_SUPPLY_TYPE_BATTERY)
+	if (psy->desc->type == POWER_SUPPLY_TYPE_BATTERY)
 		power_supply_update_bat_leds(psy);
 	else
 		power_supply_update_gen_leds(psy);
@@ -155,14 +156,14 @@ void power_supply_update_leds(struct power_supply *psy)
 
 int power_supply_create_triggers(struct power_supply *psy)
 {
-	if (psy->type == POWER_SUPPLY_TYPE_BATTERY)
+	if (psy->desc->type == POWER_SUPPLY_TYPE_BATTERY)
 		return power_supply_create_bat_triggers(psy);
 	return power_supply_create_gen_triggers(psy);
 }
 
 void power_supply_remove_triggers(struct power_supply *psy)
 {
-	if (psy->type == POWER_SUPPLY_TYPE_BATTERY)
+	if (psy->desc->type == POWER_SUPPLY_TYPE_BATTERY)
 		power_supply_remove_bat_triggers(psy);
 	else
 		power_supply_remove_gen_triggers(psy);
diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index f817aab80813..af026806cba5 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -74,7 +74,7 @@ static ssize_t power_supply_show_property(struct device *dev,
 	union power_supply_propval value;
 
 	if (off == POWER_SUPPLY_PROP_TYPE) {
-		value.intval = psy->type;
+		value.intval = psy->desc->type;
 	} else {
 		ret = power_supply_get_property(psy, off, &value);
 
@@ -218,11 +218,11 @@ static umode_t power_supply_attr_is_visible(struct kobject *kobj,
 	if (attrno == POWER_SUPPLY_PROP_TYPE)
 		return mode;
 
-	for (i = 0; i < psy->num_properties; i++) {
-		int property = psy->properties[i];
+	for (i = 0; i < psy->desc->num_properties; i++) {
+		int property = psy->desc->properties[i];
 
 		if (property == attrno) {
-			if (psy->property_is_writeable &&
+			if (psy->desc->property_is_writeable &&
 			    power_supply_property_is_writeable(psy, property) > 0)
 				mode |= S_IWUSR;
 
@@ -279,14 +279,14 @@ int power_supply_uevent(struct device *dev, struct kobj_uevent_env *env)
 
 	dev_dbg(dev, "uevent\n");
 
-	if (!psy || !psy->dev) {
+	if (!psy || !psy->desc) {
 		dev_dbg(dev, "No power supply yet\n");
 		return ret;
 	}
 
-	dev_dbg(dev, "POWER_SUPPLY_NAME=%s\n", psy->name);
+	dev_dbg(dev, "POWER_SUPPLY_NAME=%s\n", psy->desc->name);
 
-	ret = add_uevent_var(env, "POWER_SUPPLY_NAME=%s", psy->name);
+	ret = add_uevent_var(env, "POWER_SUPPLY_NAME=%s", psy->desc->name);
 	if (ret)
 		return ret;
 
@@ -294,11 +294,11 @@ int power_supply_uevent(struct device *dev, struct kobj_uevent_env *env)
 	if (!prop_buf)
 		return -ENOMEM;
 
-	for (j = 0; j < psy->num_properties; j++) {
+	for (j = 0; j < psy->desc->num_properties; j++) {
 		struct device_attribute *attr;
 		char *line;
 
-		attr = &power_supply_attrs[psy->properties[j]];
+		attr = &power_supply_attrs[psy->desc->properties[j]];
 
 		ret = power_supply_show_property(dev, attr, prop_buf);
 		if (ret == -ENODEV || ret == -ENODATA) {
diff --git a/drivers/power/sbs-battery.c b/drivers/power/sbs-battery.c
index 879f1448fc4a..de1178659d4b 100644
--- a/drivers/power/sbs-battery.c
+++ b/drivers/power/sbs-battery.c
@@ -156,7 +156,7 @@ static enum power_supply_property sbs_properties[] = {
 
 struct sbs_info {
 	struct i2c_client		*client;
-	struct power_supply		power_supply;
+	struct power_supply		*power_supply;
 	struct sbs_platform_data	*pdata;
 	bool				is_present;
 	bool				gpio_detect;
@@ -391,7 +391,7 @@ static int sbs_get_battery_property(struct i2c_client *client,
 			chip->last_state = val->intval;
 		else if (chip->last_state != val->intval) {
 			cancel_delayed_work_sync(&chip->work);
-			power_supply_changed(&chip->power_supply);
+			power_supply_changed(chip->power_supply);
 			chip->poll_time = 0;
 		}
 	} else {
@@ -556,8 +556,7 @@ static int sbs_get_property(struct power_supply *psy,
 	union power_supply_propval *val)
 {
 	int ret = 0;
-	struct sbs_info *chip = container_of(psy,
-				struct sbs_info, power_supply);
+	struct sbs_info *chip = power_supply_get_drvdata(psy);
 	struct i2c_client *client = chip->client;
 
 	switch (psp) {
@@ -638,7 +637,7 @@ static int sbs_get_property(struct power_supply *psy,
 	if (!chip->gpio_detect &&
 		chip->is_present != (ret >= 0)) {
 		chip->is_present = (ret >= 0);
-		power_supply_changed(&chip->power_supply);
+		power_supply_changed(chip->power_supply);
 	}
 
 done:
@@ -671,9 +670,7 @@ static irqreturn_t sbs_irq(int irq, void *devid)
 
 static void sbs_external_power_changed(struct power_supply *psy)
 {
-	struct sbs_info *chip;
-
-	chip = container_of(psy, struct sbs_info, power_supply);
+	struct sbs_info *chip = power_supply_get_drvdata(psy);
 
 	if (chip->ignore_changes > 0) {
 		chip->ignore_changes--;
@@ -712,7 +709,7 @@ static void sbs_delayed_work(struct work_struct *work)
 
 	if (chip->last_state != ret) {
 		chip->poll_time = 0;
-		power_supply_changed(&chip->power_supply);
+		power_supply_changed(chip->power_supply);
 		return;
 	}
 	if (chip->poll_time > 0) {
@@ -796,43 +793,48 @@ static struct sbs_platform_data *sbs_of_populate_pdata(
 }
 #endif
 
+static const struct power_supply_desc sbs_default_desc = {
+	.type = POWER_SUPPLY_TYPE_BATTERY,
+	.properties = sbs_properties,
+	.num_properties = ARRAY_SIZE(sbs_properties),
+	.get_property = sbs_get_property,
+	.external_power_changed = sbs_external_power_changed,
+};
+
 static int sbs_probe(struct i2c_client *client,
 	const struct i2c_device_id *id)
 {
 	struct sbs_info *chip;
+	struct power_supply_desc *sbs_desc;
 	struct sbs_platform_data *pdata = client->dev.platform_data;
 	struct power_supply_config psy_cfg = {};
 	int rc;
 	int irq;
-	char *name;
 
-	name = kasprintf(GFP_KERNEL, "sbs-%s", dev_name(&client->dev));
-	if (!name) {
-		dev_err(&client->dev, "Failed to allocate device name\n");
+	sbs_desc = devm_kmemdup(&client->dev, &sbs_default_desc,
+			sizeof(*sbs_desc), GFP_KERNEL);
+	if (!sbs_desc)
+		return -ENOMEM;
+
+	sbs_desc->name = devm_kasprintf(&client->dev, GFP_KERNEL, "sbs-%s",
+			dev_name(&client->dev));
+	if (!sbs_desc->name)
 		return -ENOMEM;
-	}
 
 	chip = kzalloc(sizeof(struct sbs_info), GFP_KERNEL);
-	if (!chip) {
-		rc = -ENOMEM;
-		goto exit_free_name;
-	}
+	if (!chip)
+		return -ENOMEM;
 
 	chip->client = client;
 	chip->enable_detection = false;
 	chip->gpio_detect = false;
-	chip->power_supply.name = name;
-	chip->power_supply.type = POWER_SUPPLY_TYPE_BATTERY;
-	chip->power_supply.properties = sbs_properties;
-	chip->power_supply.num_properties = ARRAY_SIZE(sbs_properties);
-	chip->power_supply.get_property = sbs_get_property;
 	psy_cfg.of_node = client->dev.of_node;
+	psy_cfg.drv_data = chip;
 	/* ignore first notification of external change, it is generated
 	 * from the power_supply_register call back
 	 */
 	chip->ignore_changes = 1;
 	chip->last_state = POWER_SUPPLY_STATUS_UNKNOWN;
-	chip->power_supply.external_power_changed = sbs_external_power_changed;
 
 	pdata = sbs_of_populate_pdata(client);
 
@@ -871,7 +873,7 @@ static int sbs_probe(struct i2c_client *client,
 
 	rc = request_irq(irq, sbs_irq,
 		IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
-		dev_name(&client->dev), &chip->power_supply);
+		dev_name(&client->dev), chip->power_supply);
 	if (rc) {
 		dev_warn(&client->dev, "Failed to request irq: %d\n", rc);
 		gpio_free(pdata->battery_detect);
@@ -893,11 +895,12 @@ skip_gpio:
 		goto exit_psupply;
 	}
 
-	rc = power_supply_register(&client->dev, &chip->power_supply,
-			&psy_cfg);
-	if (rc) {
+	chip->power_supply = power_supply_register(&client->dev, sbs_desc,
+						   &psy_cfg);
+	if (IS_ERR(chip->power_supply)) {
 		dev_err(&client->dev,
 			"%s: Failed to register power supply\n", __func__);
+		rc = PTR_ERR(chip->power_supply);
 		goto exit_psupply;
 	}
 
@@ -912,15 +915,12 @@ skip_gpio:
 
 exit_psupply:
 	if (chip->irq)
-		free_irq(chip->irq, &chip->power_supply);
+		free_irq(chip->irq, chip->power_supply);
 	if (chip->gpio_detect)
 		gpio_free(pdata->battery_detect);
 
 	kfree(chip);
 
-exit_free_name:
-	kfree(name);
-
 	return rc;
 }
 
@@ -929,15 +929,14 @@ static int sbs_remove(struct i2c_client *client)
 	struct sbs_info *chip = i2c_get_clientdata(client);
 
 	if (chip->irq)
-		free_irq(chip->irq, &chip->power_supply);
+		free_irq(chip->irq, chip->power_supply);
 	if (chip->gpio_detect)
 		gpio_free(chip->pdata->battery_detect);
 
-	power_supply_unregister(&chip->power_supply);
+	power_supply_unregister(chip->power_supply);
 
 	cancel_delayed_work_sync(&chip->work);
 
-	kfree(chip->power_supply.name);
 	kfree(chip);
 	chip = NULL;
 
diff --git a/drivers/power/tps65090-charger.c b/drivers/power/tps65090-charger.c
index 37629affcd34..dcf9a3ca53d5 100644
--- a/drivers/power/tps65090-charger.c
+++ b/drivers/power/tps65090-charger.c
@@ -43,7 +43,7 @@ struct tps65090_charger {
 	int	irq;
 	struct task_struct	*poll_task;
 	bool			passive_mode;
-	struct power_supply	ac;
+	struct power_supply	*ac;
 	struct tps65090_platform_data *pdata;
 };
 
@@ -135,8 +135,7 @@ static int tps65090_ac_get_property(struct power_supply *psy,
 			enum power_supply_property psp,
 			union power_supply_propval *val)
 {
-	struct tps65090_charger *charger = container_of(psy,
-					struct tps65090_charger, ac);
+	struct tps65090_charger *charger = power_supply_get_drvdata(psy);
 
 	if (psp == POWER_SUPPLY_PROP_ONLINE) {
 		val->intval = charger->ac_online;
@@ -190,7 +189,7 @@ static irqreturn_t tps65090_charger_isr(int irq, void *dev_id)
 	}
 
 	if (charger->prev_ac_online != charger->ac_online)
-		power_supply_changed(&charger->ac);
+		power_supply_changed(charger->ac);
 
 	return IRQ_HANDLED;
 }
@@ -229,10 +228,19 @@ static int tps65090_charger_poll_task(void *data)
 	return 0;
 }
 
+static const struct power_supply_desc tps65090_charger_desc = {
+	.name			= "tps65090-ac",
+	.type			= POWER_SUPPLY_TYPE_MAINS,
+	.get_property		= tps65090_ac_get_property,
+	.properties		= tps65090_ac_props,
+	.num_properties		= ARRAY_SIZE(tps65090_ac_props),
+};
+
 static int tps65090_charger_probe(struct platform_device *pdev)
 {
 	struct tps65090_charger *cdata;
 	struct tps65090_platform_data *pdata;
+	struct power_supply_config psy_cfg = {};
 	uint8_t status1 = 0;
 	int ret;
 	int irq;
@@ -259,19 +267,16 @@ static int tps65090_charger_probe(struct platform_device *pdev)
 	cdata->dev			= &pdev->dev;
 	cdata->pdata			= pdata;
 
-	cdata->ac.name			= "tps65090-ac";
-	cdata->ac.type			= POWER_SUPPLY_TYPE_MAINS;
-	cdata->ac.get_property		= tps65090_ac_get_property;
-	cdata->ac.properties		= tps65090_ac_props;
-	cdata->ac.num_properties	= ARRAY_SIZE(tps65090_ac_props);
-	cdata->ac.supplied_to		= pdata->supplied_to;
-	cdata->ac.num_supplicants	= pdata->num_supplicants;
-	cdata->ac.of_node		= pdev->dev.of_node;
-
-	ret = power_supply_register(&pdev->dev, &cdata->ac, NULL);
-	if (ret) {
+	psy_cfg.supplied_to		= pdata->supplied_to;
+	psy_cfg.num_supplicants		= pdata->num_supplicants;
+	psy_cfg.of_node			= pdev->dev.of_node;
+	psy_cfg.drv_data		= cdata;
+
+	cdata->ac = power_supply_register(&pdev->dev, &tps65090_charger_desc,
+			&psy_cfg);
+	if (IS_ERR(cdata->ac)) {
 		dev_err(&pdev->dev, "failed: power supply register\n");
-		return ret;
+		return PTR_ERR(cdata->ac);
 	}
 
 	irq = platform_get_irq(pdev, 0);
@@ -301,7 +306,7 @@ static int tps65090_charger_probe(struct platform_device *pdev)
 			goto fail_unregister_supply;
 		}
 		cdata->ac_online = 1;
-		power_supply_changed(&cdata->ac);
+		power_supply_changed(cdata->ac);
 	}
 
 	if (irq != -ENXIO) {
@@ -328,7 +333,7 @@ static int tps65090_charger_probe(struct platform_device *pdev)
 	return 0;
 
 fail_unregister_supply:
-	power_supply_unregister(&cdata->ac);
+	power_supply_unregister(cdata->ac);
 
 	return ret;
 }
@@ -339,7 +344,7 @@ static int tps65090_charger_remove(struct platform_device *pdev)
 
 	if (cdata->irq == -ENXIO)
 		kthread_stop(cdata->poll_task);
-	power_supply_unregister(&cdata->ac);
+	power_supply_unregister(cdata->ac);
 
 	return 0;
 }
diff --git a/include/linux/power/charger-manager.h b/include/linux/power/charger-manager.h
index e97fc656a058..bde1a24b1f16 100644
--- a/include/linux/power/charger-manager.h
+++ b/include/linux/power/charger-manager.h
@@ -264,7 +264,8 @@ struct charger_manager {
 	int emergency_stop;
 
 	char psy_name_buf[PSY_NAME_MAX + 1];
-	struct power_supply charger_psy;
+	struct power_supply_desc charger_psy_desc;
+	struct power_supply *charger_psy;
 
 	bool status_save_ext_pwr_inserted;
 	bool status_save_batt;
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index c2c17ac3a608..4afbba073c4a 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -13,6 +13,7 @@
 #ifndef __LINUX_POWER_SUPPLY_H__
 #define __LINUX_POWER_SUPPLY_H__
 
+#include <linux/device.h>
 #include <linux/workqueue.h>
 #include <linux/leds.h>
 #include <linux/spinlock.h>
@@ -173,10 +174,10 @@ union power_supply_propval {
 	const char *strval;
 };
 
-struct device;
 struct device_node;
+struct power_supply;
 
-/* Power supply instance specific configuration */
+/* Run-time specific power supply configuration */
 struct power_supply_config {
 	struct device_node *of_node;
 	/* Driver private data */
@@ -186,19 +187,13 @@ struct power_supply_config {
 	size_t num_supplicants;
 };
 
-struct power_supply {
+/* Description of power supply */
+struct power_supply_desc {
 	const char *name;
 	enum power_supply_type type;
 	enum power_supply_property *properties;
 	size_t num_properties;
 
-	char **supplied_to;
-	size_t num_supplicants;
-
-	char **supplied_from;
-	size_t num_supplies;
-	struct device_node *of_node;
-
 	/*
 	 * Functions for drivers implementing power supply class.
 	 * These shouldn't be called directly by other drivers for accessing
@@ -224,12 +219,23 @@ struct power_supply {
 	bool no_thermal;
 	/* For APM emulation, think legacy userspace. */
 	int use_for_apm;
+};
+
+struct power_supply {
+	const struct power_supply_desc *desc;
+
+	char **supplied_to;
+	size_t num_supplicants;
+
+	char **supplied_from;
+	size_t num_supplies;
+	struct device_node *of_node;
 
 	/* Driver private data */
 	void *drv_data;
 
 	/* private */
-	struct device *dev;
+	struct device dev;
 	struct work_struct changed_work;
 	spinlock_t changed_lock;
 	bool changed;
@@ -303,11 +309,14 @@ extern int power_supply_set_property(struct power_supply *psy,
 extern int power_supply_property_is_writeable(struct power_supply *psy,
 					enum power_supply_property psp);
 extern void power_supply_external_power_changed(struct power_supply *psy);
-extern int power_supply_register(struct device *parent,
-				 struct power_supply *psy,
+
+extern struct power_supply *__must_check
+power_supply_register(struct device *parent,
+				 const struct power_supply_desc *desc,
 				 const struct power_supply_config *cfg);
-extern int power_supply_register_no_ws(struct device *parent,
-				 struct power_supply *psy,
+extern struct power_supply *__must_check
+power_supply_register_no_ws(struct device *parent,
+				 const struct power_supply_desc *desc,
 				 const struct power_supply_config *cfg);
 extern void power_supply_unregister(struct power_supply *psy);
 extern int power_supply_powers(struct power_supply *psy, struct device *dev);
-- 
1.9.1

