Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbbAEPv5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:51:57 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:55683 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077AbbAEPsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:48:24 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-b5-54aab24645ca
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Pavel Machek <pavel@ucw.cz>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RFC PATCHv2 10/19] power: charger-manager: Use power_supply_*() API
 for accessing function attrs
Date: Mon, 05 Jan 2015 16:47:53 +0100
Message-id: <1420472882-10463-11-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420472882-10463-1-git-send-email-k.kozlowski@samsung.com>
References: <1420472882-10463-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKLMWRmVeSWpSXmKPExsVy+t/xa7pum1aFGBzezGUx6cl7ZouJKycz
	W7x+YWix8+FbNovl+/oZLTY9vsZqcXnXHDaLz71HGC3unjrKZnHm9CVWi9O7Sxy4PXbOusvu
	sXmFlsemVZ1sHpuX1HtsudrO4tG3ZRWjx4rV39k9Pm+SC+CI4rJJSc3JLEst0rdL4MqYduoS
	c8EJnYp5Ey+yNDBOUeli5OSQEDCR+DuxnxnCFpO4cG89WxcjF4eQwFJGiVOf90A5fUwSG28/
	YgOpYhMwlti8fAlYQkTgCZPE9NaTLCAJZgFDiZ/v/rCD2MICORJrT+4Hsjk4WARUJY41hIKE
	eQU8JObeesUKsU1O4uSxyWA2J1C86e8FsDFCAu4SH579Yp3AyLuAkWEVo2hqaXJBcVJ6rqFe
	cWJucWleul5yfu4mRkhQftnBuPiY1SFGAQ5GJR5ejxMrQ4RYE8uKK3MPMUpwMCuJ8L5KXxUi
	xJuSWFmVWpQfX1Sak1p8iJGJg1OqgbFlwrWS1ZMkvM5aTHsnt0tuemu/ptuz4viIhYV+P1ad
	Nd+4pysr/ZzNlM1VXr3NNx87T2aWYFgffubAGtYtLPzuWVOrGX34V+vWPWjYLNq4/PJ937Z9
	81O3zDh15bBM+MOPL+fP2rvmrF6efs+LxxXCgQnTK5c3TJJ/Hmmw8fypOfr8gRKqyRZKLMUZ
	iYZazEXFiQAgCMGQKAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace direct calls to power supply function attributes with wrappers.
Wrappers provide safe access in case of unregistering the power
supply (e.g. by removing the driver). Replace:
 - get_property -> power_supply_get_property

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Jonghwa Lee <jonghwa3.lee@samusng.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/power/charger-manager.c | 37 ++++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index 034c77bf0fc0..1d5065ebbd83 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -112,8 +112,8 @@ static bool is_batt_present(struct charger_manager *cm)
 		if (!psy)
 			break;
 
-		ret = psy->get_property(psy,
-				POWER_SUPPLY_PROP_PRESENT, &val);
+		ret = power_supply_get_property(psy, POWER_SUPPLY_PROP_PRESENT,
+				&val);
 		if (ret == 0 && val.intval)
 			present = true;
 		break;
@@ -127,8 +127,8 @@ static bool is_batt_present(struct charger_manager *cm)
 				continue;
 			}
 
-			ret = psy->get_property(psy, POWER_SUPPLY_PROP_PRESENT,
-					&val);
+			ret = power_supply_get_property(psy,
+				POWER_SUPPLY_PROP_PRESENT, &val);
 			if (ret == 0 && val.intval) {
 				present = true;
 				break;
@@ -164,7 +164,8 @@ static bool is_ext_pwr_online(struct charger_manager *cm)
 			continue;
 		}
 
-		ret = psy->get_property(psy, POWER_SUPPLY_PROP_ONLINE, &val);
+		ret = power_supply_get_property(psy, POWER_SUPPLY_PROP_ONLINE,
+				&val);
 		if (ret == 0 && val.intval) {
 			online = true;
 			break;
@@ -192,7 +193,7 @@ static int get_batt_uV(struct charger_manager *cm, int *uV)
 	if (!fuel_gauge)
 		return -ENODEV;
 
-	ret = fuel_gauge->get_property(fuel_gauge,
+	ret = power_supply_get_property(fuel_gauge,
 				POWER_SUPPLY_PROP_VOLTAGE_NOW, &val);
 	if (ret)
 		return ret;
@@ -232,7 +233,8 @@ static bool is_charging(struct charger_manager *cm)
 		}
 
 		/* 2. The charger should be online (ext-power) */
-		ret = psy->get_property(psy, POWER_SUPPLY_PROP_ONLINE, &val);
+		ret = power_supply_get_property(psy, POWER_SUPPLY_PROP_ONLINE,
+				&val);
 		if (ret) {
 			dev_warn(cm->dev, "Cannot read ONLINE value from %s\n",
 				 cm->desc->psy_charger_stat[i]);
@@ -245,7 +247,8 @@ static bool is_charging(struct charger_manager *cm)
 		 * 3. The charger should not be FULL, DISCHARGING,
 		 * or NOT_CHARGING.
 		 */
-		ret = psy->get_property(psy, POWER_SUPPLY_PROP_STATUS, &val);
+		ret = power_supply_get_property(psy, POWER_SUPPLY_PROP_STATUS,
+				&val);
 		if (ret) {
 			dev_warn(cm->dev, "Cannot read STATUS value from %s\n",
 				 cm->desc->psy_charger_stat[i]);
@@ -288,7 +291,7 @@ static bool is_full_charged(struct charger_manager *cm)
 		val.intval = 0;
 
 		/* Not full if capacity of fuel gauge isn't full */
-		ret = fuel_gauge->get_property(fuel_gauge,
+		ret = power_supply_get_property(fuel_gauge,
 				POWER_SUPPLY_PROP_CHARGE_FULL, &val);
 		if (!ret && val.intval > desc->fullbatt_full_capacity)
 			return true;
@@ -305,7 +308,7 @@ static bool is_full_charged(struct charger_manager *cm)
 	if (desc->fullbatt_soc > 0) {
 		val.intval = 0;
 
-		ret = fuel_gauge->get_property(fuel_gauge,
+		ret = power_supply_get_property(fuel_gauge,
 				POWER_SUPPLY_PROP_CAPACITY, &val);
 		if (!ret && val.intval >= desc->fullbatt_soc)
 			return true;
@@ -589,7 +592,7 @@ static int cm_get_battery_temperature_by_psy(struct charger_manager *cm,
 	if (!fuel_gauge)
 		return -ENODEV;
 
-	return fuel_gauge->get_property(fuel_gauge,
+	return power_supply_get_property(fuel_gauge,
 				POWER_SUPPLY_PROP_TEMP,
 				(union power_supply_propval *)temp);
 }
@@ -910,7 +913,7 @@ static int charger_get_property(struct power_supply *psy,
 			ret = -ENODEV;
 			break;
 		}
-		ret = fuel_gauge->get_property(fuel_gauge,
+		ret = power_supply_get_property(fuel_gauge,
 				POWER_SUPPLY_PROP_CURRENT_NOW, val);
 		break;
 	case POWER_SUPPLY_PROP_TEMP:
@@ -933,7 +936,7 @@ static int charger_get_property(struct power_supply *psy,
 		mdelay(2000);
 		pr_err("End wait...\n");
 
-		ret = fuel_gauge->get_property(fuel_gauge,
+		ret = power_supply_get_property(fuel_gauge,
 					POWER_SUPPLY_PROP_CAPACITY, val);
 		if (ret)
 			break;
@@ -989,7 +992,7 @@ static int charger_get_property(struct power_supply *psy,
 				break;
 			}
 
-			ret = fuel_gauge->get_property(fuel_gauge,
+			ret = power_supply_get_property(fuel_gauge,
 						POWER_SUPPLY_PROP_CHARGE_NOW,
 						val);
 			if (ret) {
@@ -1559,7 +1562,7 @@ static int cm_init_thermal_data(struct charger_manager *cm,
 	int ret;
 
 	/* Verify whether fuel gauge provides battery temperature */
-	ret = fuel_gauge->get_property(fuel_gauge,
+	ret = power_supply_get_property(fuel_gauge,
 					POWER_SUPPLY_PROP_TEMP, &val);
 
 	if (!ret) {
@@ -1851,13 +1854,13 @@ static int charger_manager_probe(struct platform_device *pdev)
 	cm->charger_psy.num_properties = psy_default.num_properties;
 
 	/* Find which optional psy-properties are available */
-	if (!fuel_gauge->get_property(fuel_gauge,
+	if (!power_supply_get_property(fuel_gauge,
 					  POWER_SUPPLY_PROP_CHARGE_NOW, &val)) {
 		cm->charger_psy.properties[cm->charger_psy.num_properties] =
 				POWER_SUPPLY_PROP_CHARGE_NOW;
 		cm->charger_psy.num_properties++;
 	}
-	if (!fuel_gauge->get_property(fuel_gauge,
+	if (!power_supply_get_property(fuel_gauge,
 					  POWER_SUPPLY_PROP_CURRENT_NOW,
 					  &val)) {
 		cm->charger_psy.properties[cm->charger_psy.num_properties] =
-- 
1.9.1

