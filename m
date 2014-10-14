Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277AbaJNMVL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 08:21:11 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:36907 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755113AbaJNMVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 08:21:09 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-0c-543d15329565
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
Subject: [PATCH 8/8] power: charger-manager: Use power_supply_*() API for
 accessing function attrs
Date: Tue, 14 Oct 2014 14:20:46 +0200
Message-id: <1413289246-31650-9-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1413289246-31650-1-git-send-email-k.kozlowski@samsung.com>
References: <1413289246-31650-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsVy+t/xq7pGorYhBofuylkc3KppsXHGelaL
	SU/eM1tMXDmZ2aLz7BNmi9cvDC3ONr1ht7j/9SijxZQ/y5ksNj2+xmpxedccNovPvUcYLZ4s
	PMNksfbIXXaL240r2CzunjrKZnG6m9Xi9O4SByGPCf2fGD12zrrL7rF5hZbHplWdbB53ru1h
	85h3MtBj85J6j53fG9g9+rasYvRYsfo7u8fnTXIB3FFcNimpOZllqUX6dglcGfe3bmMtuKld
	8fZiH3sD4zrlLkZODgkBE4kP5y8yQdhiEhfurWfrYuTiEBJYyijR9+oFC4TTxyTxqaMNrIpN
	wFhi8/IlYFUiAteZJDpXTACrYhZoZJZ419AMViUskCIx+9BrVhCbRUBVonvFNEYQm1fAXaJ7
	7npmiH1yEiePTQar4RTwkFi56AgLiC0EVNN+8jbbBEbeBYwMqxhFU0uTC4qT0nMN9YoTc4tL
	89L1kvNzNzFCwv7LDsbFx6wOMQpwMCrx8BZE2oQIsSaWFVfmHmKU4GBWEuFV4LANEeJNSays
	Si3Kjy8qzUktPsTIxMEp1cA4/6+zm+KkwLQTHQuzORZb2MzPvWQWnJhytfL00YrLfD0xEjMO
	+L48/mtL0inrllmXWXO32IiqX09fNF1pS3WV+O3dC3Za7aqctMY45HlggDrXlZWF/hta5a3T
	tRjerrSxUbzz+AHfjHMrjv+59cfj7AVR817N23o7bsloh4iFn03dVOl58eUnJZbijERDLeai
	4kQAfKfm7FkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace direct calls to power supply function attributes with wrappers.
Wrappers provide safe access access in case of unregistering the power
supply (.e.g by removing the driver). Replace:
 - get_property -> power_supply_get_property

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/power/charger-manager.c | 37 ++++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index b5d272cb7c4a..9e01074d3169 100644
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
@@ -909,7 +912,7 @@ static int charger_get_property(struct power_supply *psy,
 			ret = -ENODEV;
 			break;
 		}
-		ret = fuel_gauge->get_property(fuel_gauge,
+		ret = power_supply_get_property(fuel_gauge,
 				POWER_SUPPLY_PROP_CURRENT_NOW, val);
 		break;
 	case POWER_SUPPLY_PROP_TEMP:
@@ -928,7 +931,7 @@ static int charger_get_property(struct power_supply *psy,
 			break;
 		}
 
-		ret = fuel_gauge->get_property(fuel_gauge,
+		ret = power_supply_get_property(fuel_gauge,
 					POWER_SUPPLY_PROP_CAPACITY, val);
 		if (ret)
 			break;
@@ -984,7 +987,7 @@ static int charger_get_property(struct power_supply *psy,
 				break;
 			}
 
-			ret = fuel_gauge->get_property(fuel_gauge,
+			ret = power_supply_get_property(fuel_gauge,
 						POWER_SUPPLY_PROP_CHARGE_NOW,
 						val);
 			if (ret) {
@@ -1553,7 +1556,7 @@ static int cm_init_thermal_data(struct charger_manager *cm,
 	int ret;
 
 	/* Verify whether fuel gauge provides battery temperature */
-	ret = fuel_gauge->get_property(fuel_gauge,
+	ret = power_supply_get_property(fuel_gauge,
 					POWER_SUPPLY_PROP_TEMP, &val);
 
 	if (!ret) {
@@ -1845,13 +1848,13 @@ static int charger_manager_probe(struct platform_device *pdev)
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

