Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbbAEPuk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:50:40 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:56286 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178AbbAEPs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:48:28 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-c4-54aab249b635
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Pavel Machek <pavel@ucw.cz>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RFC PATCHv2 13/19] power: charger-manager: Decrement the power
 supply's device reference counter
Date: Mon, 05 Jan 2015 16:47:56 +0100
Message-id: <1420472882-10463-14-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420472882-10463-1-git-send-email-k.kozlowski@samsung.com>
References: <1420472882-10463-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGLMWRmVeSWpSXmKPExsVy+t/xa7qem1aFGKzfzG4x6cl7ZouJKycz
	W7x+YWix8+FbNovl+/oZLTY9vsZqcXnXHDaLz71HGC3unjrKZnHm9CVWi9O7Sxy4PXbOusvu
	sXmFlsemVZ1sHpuX1HtsudrO4tG3ZRWjx4rV39k9Pm+SC+CI4rJJSc3JLEst0rdL4Mp48+sz
	Y8Fp04pn87oZGxh/a3UxcnJICJhIdG/sYIGwxSQu3FvP1sXIxSEksJRRYt3ynawQTh+TxIqF
	69lBqtgEjCU2L18CViUi8IRJYnrrSbB2ZgFDiZ/v/oAVCQvkSOx8u5MZxGYRUJW4934NWJxX
	wEPi2vyjjBDr5CROHpvMCmJzAsWb/l4AmyMk4C7x4dkv1gmMvAsYGVYxiqaWJhcUJ6XnGukV
	J+YWl+al6yXn525ihITl1x2MS49ZHWIU4GBU4uH1OLEyRIg1say4MvcQowQHs5II76v0VSFC
	vCmJlVWpRfnxRaU5qcWHGJk4OKUaGCs+Pd6gkPNqcdSKN9lXVD5xLDHg6D68MObSBC3DTxN3
	RrmuuZR0zXPSmX7ZJyL8+/kvMx3eZLLkiMWtBQ7y34+suFb2ak3Ht4Yyg8J9XaIBqvvefObY
	vse7d8eXqUu+H5pyIsx369sM/d9P7EQ4Em1Uc7037t7BWej+y/Xzvz2au6s7yi/GO4QrsRRn
	JBpqMRcVJwIAIYEY3ikCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use power_supply_put() to decrement the power supply's device reference
counter.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/power/charger-manager.c | 70 +++++++++++++++++++++++++++--------------
 1 file changed, 47 insertions(+), 23 deletions(-)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index a9870b9ff571..648b84289749 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -116,6 +116,7 @@ static bool is_batt_present(struct charger_manager *cm)
 				&val);
 		if (ret == 0 && val.intval)
 			present = true;
+		power_supply_put(psy);
 		break;
 	case CM_CHARGER_STAT:
 		for (i = 0; cm->desc->psy_charger_stat[i]; i++) {
@@ -129,6 +130,7 @@ static bool is_batt_present(struct charger_manager *cm)
 
 			ret = power_supply_get_property(psy,
 				POWER_SUPPLY_PROP_PRESENT, &val);
+			power_supply_put(psy);
 			if (ret == 0 && val.intval) {
 				present = true;
 				break;
@@ -166,6 +168,7 @@ static bool is_ext_pwr_online(struct charger_manager *cm)
 
 		ret = power_supply_get_property(psy, POWER_SUPPLY_PROP_ONLINE,
 				&val);
+		power_supply_put(psy);
 		if (ret == 0 && val.intval) {
 			online = true;
 			break;
@@ -195,6 +198,7 @@ static int get_batt_uV(struct charger_manager *cm, int *uV)
 
 	ret = power_supply_get_property(fuel_gauge,
 				POWER_SUPPLY_PROP_VOLTAGE_NOW, &val);
+	power_supply_put(fuel_gauge);
 	if (ret)
 		return ret;
 
@@ -238,10 +242,13 @@ static bool is_charging(struct charger_manager *cm)
 		if (ret) {
 			dev_warn(cm->dev, "Cannot read ONLINE value from %s\n",
 				 cm->desc->psy_charger_stat[i]);
+			power_supply_put(psy);
 			continue;
 		}
-		if (val.intval == 0)
+		if (val.intval == 0) {
+			power_supply_put(psy);
 			continue;
+		}
 
 		/*
 		 * 3. The charger should not be FULL, DISCHARGING,
@@ -249,6 +256,7 @@ static bool is_charging(struct charger_manager *cm)
 		 */
 		ret = power_supply_get_property(psy, POWER_SUPPLY_PROP_STATUS,
 				&val);
+		power_supply_put(psy);
 		if (ret) {
 			dev_warn(cm->dev, "Cannot read STATUS value from %s\n",
 				 cm->desc->psy_charger_stat[i]);
@@ -276,6 +284,7 @@ static bool is_full_charged(struct charger_manager *cm)
 	struct charger_desc *desc = cm->desc;
 	union power_supply_propval val;
 	struct power_supply *fuel_gauge;
+	bool is_full = false;
 	int ret = 0;
 	int uV;
 
@@ -293,15 +302,19 @@ static bool is_full_charged(struct charger_manager *cm)
 		/* Not full if capacity of fuel gauge isn't full */
 		ret = power_supply_get_property(fuel_gauge,
 				POWER_SUPPLY_PROP_CHARGE_FULL, &val);
-		if (!ret && val.intval > desc->fullbatt_full_capacity)
-			return true;
+		if (!ret && val.intval > desc->fullbatt_full_capacity) {
+			is_full = true;
+			goto out;
+		}
 	}
 
 	/* Full, if it's over the fullbatt voltage */
 	if (desc->fullbatt_uV > 0) {
 		ret = get_batt_uV(cm, &uV);
-		if (!ret && uV >= desc->fullbatt_uV)
-			return true;
+		if (!ret && uV >= desc->fullbatt_uV) {
+			is_full = true;
+			goto out;
+		}
 	}
 
 	/* Full, if the capacity is more than fullbatt_soc */
@@ -310,11 +323,15 @@ static bool is_full_charged(struct charger_manager *cm)
 
 		ret = power_supply_get_property(fuel_gauge,
 				POWER_SUPPLY_PROP_CAPACITY, &val);
-		if (!ret && val.intval >= desc->fullbatt_soc)
-			return true;
+		if (!ret && val.intval >= desc->fullbatt_soc) {
+			is_full = true;
+			goto out;
+		}
 	}
 
-	return false;
+out:
+	power_supply_put(fuel_gauge);
+	return is_full;
 }
 
 /**
@@ -587,14 +604,18 @@ static int cm_get_battery_temperature_by_psy(struct charger_manager *cm,
 					int *temp)
 {
 	struct power_supply *fuel_gauge;
+	int ret;
 
 	fuel_gauge = power_supply_get_by_name(cm->desc->psy_fuel_gauge);
 	if (!fuel_gauge)
 		return -ENODEV;
 
-	return power_supply_get_property(fuel_gauge,
+	ret = power_supply_get_property(fuel_gauge,
 				POWER_SUPPLY_PROP_TEMP,
 				(union power_supply_propval *)temp);
+	power_supply_put(fuel_gauge);
+
+	return ret;
 }
 
 static int cm_get_battery_temperature(struct charger_manager *cm,
@@ -876,7 +897,7 @@ static int charger_get_property(struct power_supply *psy,
 {
 	struct charger_manager *cm = power_supply_get_drvdata(psy);
 	struct charger_desc *desc = cm->desc;
-	struct power_supply *fuel_gauge;
+	struct power_supply *fuel_gauge = NULL;
 	int ret = 0;
 	int uV;
 
@@ -919,12 +940,6 @@ static int charger_get_property(struct power_supply *psy,
 	case POWER_SUPPLY_PROP_TEMP_AMBIENT:
 		return cm_get_battery_temperature(cm, &val->intval);
 	case POWER_SUPPLY_PROP_CAPACITY:
-		fuel_gauge = power_supply_get_by_name(cm->desc->psy_fuel_gauge);
-		if (!fuel_gauge) {
-			ret = -ENODEV;
-			break;
-		}
-
 		if (!is_batt_present(cm)) {
 			/* There is no battery. Assume 100% */
 			val->intval = 100;
@@ -935,6 +950,12 @@ static int charger_get_property(struct power_supply *psy,
 		mdelay(2000);
 		pr_err("End wait...\n");
 
+		fuel_gauge = power_supply_get_by_name(cm->desc->psy_fuel_gauge);
+		if (!fuel_gauge) {
+			ret = -ENODEV;
+			break;
+		}
+
 		ret = power_supply_get_property(fuel_gauge,
 					POWER_SUPPLY_PROP_CAPACITY, val);
 		if (ret)
@@ -1009,6 +1030,8 @@ static int charger_get_property(struct power_supply *psy,
 	default:
 		return -EINVAL;
 	}
+	if (fuel_gauge)
+		power_supply_put(fuel_gauge);
 	return ret;
 }
 
@@ -1809,13 +1832,7 @@ static int charger_manager_probe(struct platform_device *pdev)
 				desc->psy_charger_stat[i]);
 			return -ENODEV;
 		}
-	}
-
-	fuel_gauge = power_supply_get_by_name(desc->psy_fuel_gauge);
-	if (!fuel_gauge) {
-		dev_err(&pdev->dev, "Cannot find power supply \"%s\"\n",
-			desc->psy_fuel_gauge);
-		return -ENODEV;
+		power_supply_put(psy);
 	}
 
 	if (desc->polling_interval_ms == 0 ||
@@ -1855,6 +1872,12 @@ static int charger_manager_probe(struct platform_device *pdev)
 	cm->charger_psy_desc.num_properties = psy_default.num_properties;
 
 	/* Find which optional psy-properties are available */
+	fuel_gauge = power_supply_get_by_name(desc->psy_fuel_gauge);
+	if (!fuel_gauge) {
+		dev_err(&pdev->dev, "Cannot find power supply \"%s\"\n",
+			desc->psy_fuel_gauge);
+		return -ENODEV;
+	}
 	if (!power_supply_get_property(fuel_gauge,
 					  POWER_SUPPLY_PROP_CHARGE_NOW, &val)) {
 		cm->charger_psy_desc.properties[cm->charger_psy_desc.num_properties] =
@@ -1874,6 +1897,7 @@ static int charger_manager_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "Failed to initialize thermal data\n");
 		cm->desc->measure_battery_temp = false;
 	}
+	power_supply_put(fuel_gauge);
 
 	INIT_DELAYED_WORK(&cm->fullbatt_vchk_work, fullbatt_vchk);
 
-- 
1.9.1

