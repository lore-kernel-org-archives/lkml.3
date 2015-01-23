Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137AbbAWKiP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 05:38:15 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:46394 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090AbbAWKiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 05:38:11 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-44-54c224009aa8
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] power: test_power: Use enum as index for array of supplies
Date: Fri, 23 Jan 2015 11:38:00 +0100
Message-id: <1422009480-5822-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIJMWRmVeSWpSXmKPExsVy+t/xy7oMKodCDN7d47XYOGM9q8WkJ++Z
	LSaunMxs8fqFocXZpjfsFpd3zWGz+Nx7hNHi9O4SBw6PnbPusntsXqHlsWlVJ5tH35ZVjB6f
	N8kFsEZx2aSk5mSWpRbp2yVwZXT9fcNesEylomHNEfYGxn1yXYycHBICJhKzj8xlhrDFJC7c
	W8/WxcjFISSwlFHiyrRGRpCEkEAfk0TfIRkQm03AWGLz8iVgRSICuxklJkxdzgLiMAtMY5S4
	cOo72ChhAW+JxyvfsYLYLAKqEk2zjoLFeQXcJHa/OscGsU5O4uSxyawTGLkXMDKsYhRNLU0u
	KE5KzzXUK07MLS7NS9dLzs/dxAgJli87GBcfszrEKMDBqMTDu+PpwRAh1sSy4srcQ4wSHMxK
	IrxxX4BCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGDeJ2B4qei9XXL93S88+vU6fSb5Vpxk8zx9b
	uOHAIy+Vl8s3LJQ5dIXljZXUmzBRmzCnle9iShYsLRM/P1ts/uLJPzdphb3cu1P7T3fwDad5
	0l79NplzjbnetOyv42FM2Ffzdb3WzoBJ1xgm5idJWi/cH8/8TqDENvn12WuXmg/zfOl8dLPq
	zxclluKMREMt5qLiRAAOBVHC9AEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace hard-coded numbers for indices of power supply array with enum.
This improves a little the readability as one does not have to guess
which power supply is associated with number.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/power/test_power.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/power/test_power.c b/drivers/power/test_power.c
index 0152f35dca5c..f26b1fa00fe1 100644
--- a/drivers/power/test_power.c
+++ b/drivers/power/test_power.c
@@ -21,6 +21,13 @@
 #include <linux/delay.h>
 #include <linux/vermagic.h>
 
+enum test_power_id {
+	TEST_AC,
+	TEST_BATTERY,
+	TEST_USB,
+	TEST_POWER_NUM,
+};
+
 static int ac_online			= 1;
 static int usb_online			= 1;
 static int battery_status		= POWER_SUPPLY_STATUS_DISCHARGING;
@@ -147,7 +154,7 @@ static char *test_power_ac_supplied_to[] = {
 };
 
 static struct power_supply test_power_supplies[] = {
-	{
+	[TEST_AC] = {
 		.name = "test_ac",
 		.type = POWER_SUPPLY_TYPE_MAINS,
 		.supplied_to = test_power_ac_supplied_to,
@@ -155,13 +162,15 @@ static struct power_supply test_power_supplies[] = {
 		.properties = test_power_ac_props,
 		.num_properties = ARRAY_SIZE(test_power_ac_props),
 		.get_property = test_power_get_ac_property,
-	}, {
+	},
+	[TEST_BATTERY] = {
 		.name = "test_battery",
 		.type = POWER_SUPPLY_TYPE_BATTERY,
 		.properties = test_power_battery_props,
 		.num_properties = ARRAY_SIZE(test_power_battery_props),
 		.get_property = test_power_get_battery_property,
-	}, {
+	},
+	[TEST_USB] = {
 		.name = "test_usb",
 		.type = POWER_SUPPLY_TYPE_USB,
 		.supplied_to = test_power_ac_supplied_to,
@@ -178,6 +187,8 @@ static int __init test_power_init(void)
 	int i;
 	int ret;
 
+	BUILD_BUG_ON(TEST_POWER_NUM != ARRAY_SIZE(test_power_supplies));
+
 	for (i = 0; i < ARRAY_SIZE(test_power_supplies); i++) {
 		ret = power_supply_register(NULL, &test_power_supplies[i]);
 		if (ret) {
@@ -309,7 +320,7 @@ static inline void signal_power_supply_changed(struct power_supply *psy)
 static int param_set_ac_online(const char *key, const struct kernel_param *kp)
 {
 	ac_online = map_get_value(map_ac_online, key, ac_online);
-	signal_power_supply_changed(&test_power_supplies[0]);
+	signal_power_supply_changed(&test_power_supplies[TEST_AC]);
 	return 0;
 }
 
@@ -322,7 +333,7 @@ static int param_get_ac_online(char *buffer, const struct kernel_param *kp)
 static int param_set_usb_online(const char *key, const struct kernel_param *kp)
 {
 	usb_online = map_get_value(map_ac_online, key, usb_online);
-	signal_power_supply_changed(&test_power_supplies[2]);
+	signal_power_supply_changed(&test_power_supplies[TEST_USB]);
 	return 0;
 }
 
@@ -336,7 +347,7 @@ static int param_set_battery_status(const char *key,
 					const struct kernel_param *kp)
 {
 	battery_status = map_get_value(map_status, key, battery_status);
-	signal_power_supply_changed(&test_power_supplies[1]);
+	signal_power_supply_changed(&test_power_supplies[TEST_BATTERY]);
 	return 0;
 }
 
@@ -350,7 +361,7 @@ static int param_set_battery_health(const char *key,
 					const struct kernel_param *kp)
 {
 	battery_health = map_get_value(map_health, key, battery_health);
-	signal_power_supply_changed(&test_power_supplies[1]);
+	signal_power_supply_changed(&test_power_supplies[TEST_BATTERY]);
 	return 0;
 }
 
@@ -364,7 +375,7 @@ static int param_set_battery_present(const char *key,
 					const struct kernel_param *kp)
 {
 	battery_present = map_get_value(map_present, key, battery_present);
-	signal_power_supply_changed(&test_power_supplies[0]);
+	signal_power_supply_changed(&test_power_supplies[TEST_AC]);
 	return 0;
 }
 
@@ -380,7 +391,7 @@ static int param_set_battery_technology(const char *key,
 {
 	battery_technology = map_get_value(map_technology, key,
 						battery_technology);
-	signal_power_supply_changed(&test_power_supplies[1]);
+	signal_power_supply_changed(&test_power_supplies[TEST_BATTERY]);
 	return 0;
 }
 
@@ -401,7 +412,7 @@ static int param_set_battery_capacity(const char *key,
 		return -EINVAL;
 
 	battery_capacity = tmp;
-	signal_power_supply_changed(&test_power_supplies[1]);
+	signal_power_supply_changed(&test_power_supplies[TEST_BATTERY]);
 	return 0;
 }
 
@@ -416,7 +427,7 @@ static int param_set_battery_voltage(const char *key,
 		return -EINVAL;
 
 	battery_voltage = tmp;
-	signal_power_supply_changed(&test_power_supplies[1]);
+	signal_power_supply_changed(&test_power_supplies[TEST_BATTERY]);
 	return 0;
 }
 
-- 
1.9.1

