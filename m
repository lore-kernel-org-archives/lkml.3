Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbaI2VZc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 17:25:32 -0400
Received: from mail-oi0-f74.google.com ([209.85.218.74]:48466 "EHLO
	mail-oi0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbaI2VZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 17:25:30 -0400
From: Puthikorn Voravootivat <puthik@chromium.org>
To: linux-pm@vger.kernel.org
Cc: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        Gwendal Grignou <gwendal@chromium.org>,
        Rhyland Klein <rklein@nvidia.com>, Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>,
        Puthikorn Voravootivat <puthik@chromium.org>
Subject: [PATCH v2] bq27x00_battery: Add support to bq27742
Date: Mon, 29 Sep 2014 14:25:11 -0700
Message-Id: <1412025911-26809-1-git-send-email-puthik@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support to bq27742 in bq27x00 driver. bq27742 register
addresses are mostly mostly the same as bq27500 addresses
with minor differences.

Signed-off-by: Puthikorn Voravootivat <puthik@chromium.org>
Reviewed-by: Gwendal Grignou <gwendal@chromium.org>
Reviewed-by: Rhyland Klein <rklein@nvidia.com>
Reviewed-by: Benson Leung <bleung@chromium.org>
---
Change log
v2: Fix flags/full capacity register read

 drivers/power/bq27x00_battery.c | 58 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 48 insertions(+), 10 deletions(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index e10763e..8ea32c8 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -23,6 +23,7 @@
  * http://focus.ti.com/docs/prod/folders/print/bq27000.html
  * http://focus.ti.com/docs/prod/folders/print/bq27500.html
  * http://www.ti.com/product/bq27425-g1
+ * http://www.ti.com/product/BQ27742-G1
  */
 
 #include <linux/device.h>
@@ -71,6 +72,8 @@
 #define BQ27500_FLAG_FC			BIT(9)
 #define BQ27500_FLAG_OTC		BIT(15)
 
+#define BQ27742_POWER_AVG		0x76
+
 /* bq27425 register addresses are same as bq27x00 addresses minus 4 */
 #define BQ27425_REG_OFFSET		0x04
 #define BQ27425_REG_SOC			0x18 /* Register address plus offset */
@@ -83,7 +86,7 @@ struct bq27x00_access_methods {
 	int (*read)(struct bq27x00_device_info *di, u8 reg, bool single);
 };
 
-enum bq27x00_chip { BQ27000, BQ27500, BQ27425};
+enum bq27x00_chip { BQ27000, BQ27500, BQ27425, BQ27742};
 
 struct bq27x00_reg_cache {
 	int temperature;
@@ -152,6 +155,24 @@ static enum power_supply_property bq27425_battery_props[] = {
 	POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN,
 };
 
+static enum power_supply_property bq27742_battery_props[] = {
+	POWER_SUPPLY_PROP_STATUS,
+	POWER_SUPPLY_PROP_PRESENT,
+	POWER_SUPPLY_PROP_VOLTAGE_NOW,
+	POWER_SUPPLY_PROP_CURRENT_NOW,
+	POWER_SUPPLY_PROP_CAPACITY,
+	POWER_SUPPLY_PROP_CAPACITY_LEVEL,
+	POWER_SUPPLY_PROP_TEMP,
+	POWER_SUPPLY_PROP_TIME_TO_EMPTY_NOW,
+	POWER_SUPPLY_PROP_TECHNOLOGY,
+	POWER_SUPPLY_PROP_CHARGE_FULL,
+	POWER_SUPPLY_PROP_CHARGE_NOW,
+	POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN,
+	POWER_SUPPLY_PROP_CYCLE_COUNT,
+	POWER_SUPPLY_PROP_POWER_AVG,
+	POWER_SUPPLY_PROP_HEALTH,
+};
+
 static unsigned int poll_interval = 360;
 module_param(poll_interval, uint, 0644);
 MODULE_PARM_DESC(poll_interval, "battery poll interval in seconds - " \
@@ -176,7 +197,7 @@ static inline int bq27x00_read(struct bq27x00_device_info *di, u8 reg,
  */
 static bool bq27xxx_is_chip_version_higher(struct bq27x00_device_info *di)
 {
-	if (di->chip == BQ27425 || di->chip == BQ27500)
+	if (di->chip == BQ27425 || di->chip == BQ27500 || di->chip == BQ27742)
 		return true;
 	return false;
 }
@@ -189,7 +210,7 @@ static int bq27x00_battery_read_rsoc(struct bq27x00_device_info *di)
 {
 	int rsoc;
 
-	if (di->chip == BQ27500)
+	if (di->chip == BQ27500 || di->chip == BQ27742)
 		rsoc = bq27x00_read(di, BQ27500_REG_SOC, false);
 	else if (di->chip == BQ27425)
 		rsoc = bq27x00_read(di, BQ27425_REG_SOC, false);
@@ -233,9 +254,11 @@ static inline int bq27x00_battery_read_nac(struct bq27x00_device_info *di)
 {
 	int flags;
 	bool is_bq27500 = di->chip == BQ27500;
+	bool is_bq27742 = di->chip == BQ27742;
 	bool is_higher = bq27xxx_is_chip_version_higher(di);
+	bool flags_1b = !(is_bq27500 || is_bq27742);
 
-	flags = bq27x00_read(di, BQ27x00_REG_FLAGS, !is_bq27500);
+	flags = bq27x00_read(di, BQ27x00_REG_FLAGS, flags_1b);
 	if (flags >= 0 && !is_higher && (flags & BQ27000_FLAG_CI))
 		return -ENODATA;
 
@@ -414,13 +437,14 @@ static void bq27x00_update(struct bq27x00_device_info *di)
 	struct bq27x00_reg_cache cache = {0, };
 	bool is_bq27500 = di->chip == BQ27500;
 	bool is_bq27425 = di->chip == BQ27425;
-
-	cache.flags = bq27x00_read(di, BQ27x00_REG_FLAGS, !is_bq27500);
+	bool is_bq27742 = di->chip == BQ27742;
+	bool flags_1b = !(is_bq27500 || is_bq27742);
+	cache.flags = bq27x00_read(di, BQ27x00_REG_FLAGS, flags_1b);
 	if ((cache.flags & 0xff) == 0xff)
 		/* read error */
 		cache.flags = -1;
 	if (cache.flags >= 0) {
-		if (!is_bq27500 && !is_bq27425
+		if (!is_bq27500 && !is_bq27425 && !is_bq27742
 				&& (cache.flags & BQ27000_FLAG_CI)) {
 			dev_info(di->dev, "battery is not calibrated! ignoring capacity values\n");
 			cache.capacity = -ENODATA;
@@ -432,7 +456,11 @@ static void bq27x00_update(struct bq27x00_device_info *di)
 			cache.health = -ENODATA;
 		} else {
 			cache.capacity = bq27x00_battery_read_rsoc(di);
-			if (!is_bq27425) {
+			if (is_bq27742)
+				cache.time_to_empty =
+					bq27x00_battery_read_time(di,
+							BQ27x00_REG_TTE);
+			else if (!is_bq27425) {
 				cache.energy = bq27x00_battery_read_energy(di);
 				cache.time_to_empty =
 					bq27x00_battery_read_time(di,
@@ -450,8 +478,14 @@ static void bq27x00_update(struct bq27x00_device_info *di)
 		cache.temperature = bq27x00_battery_read_temperature(di);
 		if (!is_bq27425)
 			cache.cycle_count = bq27x00_battery_read_cyct(di);
-		cache.power_avg =
-			bq27x00_battery_read_pwr_avg(di, BQ27x00_POWER_AVG);
+		if (is_bq27742)
+			cache.power_avg =
+				bq27x00_battery_read_pwr_avg(di,
+						BQ27742_POWER_AVG);
+		else
+			cache.power_avg =
+				bq27x00_battery_read_pwr_avg(di,
+						BQ27x00_POWER_AVG);
 
 		/* We only have to read charge design full once */
 		if (di->charge_design_full <= 0)
@@ -702,6 +736,9 @@ static int bq27x00_powersupply_init(struct bq27x00_device_info *di)
 	if (di->chip == BQ27425) {
 		di->bat.properties = bq27425_battery_props;
 		di->bat.num_properties = ARRAY_SIZE(bq27425_battery_props);
+	} else if (di->chip == BQ27742) {
+		di->bat.properties = bq27742_battery_props;
+		di->bat.num_properties = ARRAY_SIZE(bq27742_battery_props);
 	} else {
 		di->bat.properties = bq27x00_battery_props;
 		di->bat.num_properties = ARRAY_SIZE(bq27x00_battery_props);
@@ -858,6 +895,7 @@ static const struct i2c_device_id bq27x00_id[] = {
 	{ "bq27200", BQ27000 },	/* bq27200 is same as bq27000, but with i2c */
 	{ "bq27500", BQ27500 },
 	{ "bq27425", BQ27425 },
+	{ "bq27742", BQ27742 },
 	{},
 };
 MODULE_DEVICE_TABLE(i2c, bq27x00_id);
-- 
2.1.0.rc2.206.gedb03e5

