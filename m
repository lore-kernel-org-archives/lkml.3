Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452AbaKDPK7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 10:10:59 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:37114 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbaKDPKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 10:10:49 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-8e-5458ec77b52c
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org
Cc: Anton Vorontsov <anton@enomsg.org>, Pavel Machek <pavel@ucw.cz>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH RESEND v2 2/7] power: charger-manager: Decrement the power
 supply's device reference counter
Date: Tue, 04 Nov 2014 16:10:31 +0100
Message-id: <1415113836-26098-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1415113836-26098-1-git-send-email-k.kozlowski@samsung.com>
References: <1415113836-26098-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsVy+t/xy7rlbyJCDLoPSVkc3KppsXHGelaL
	JU0ZFpOevGe2mLhyMrPFtI3iFq9fGFosW/yU0eJs0xt2i/tfjzJaTPmznMli0+NrrBaXd81h
	s/jce4TR4uPSDawWa4/cZbe4dGABk8XdU0fZLB6veMtucbqb1eL07hKLzZumMlv82PCY1UHc
	Y0L/J0aPnbPusnss2FTqsXmFlsfiPS+ZPDat6mTzuHNtD5vHu3Pn2D3mnQz02Lyk3uPj01ss
	Hu/3XWXz6NuyitFjxerv7B6fN8l5nGj5whogEMVlk5Kak1mWWqRvl8CVcfnmE8aCVyYV3Ten
	sTUwztfqYuTkkBAwkdgx5ykjhC0mceHeerYuRi4OIYGljBKPNm2BcvqYJCZf2MoOUsUmYCyx
	efkSsISIQCOrxLmtb5hAHGaBDiaJ2y07WUGqhAXyJFYdvc0GYrMIqEr8fdwE1s0r4C7x7sAr
	Noh9chInj00Gq+cU8JDY2fIfrEYIqObNxu2sExh5FzAyrGIUTS1NLihOSs811CtOzC0uzUvX
	S87P3cQIiaovOxgXH7M6xCjAwajEw5uhHhEixJpYVlyZe4hRgoNZSYRX/TFQiDclsbIqtSg/
	vqg0J7X4ECMTB6dUA+O8v6Vif1/+UJvK/+D2S4ZKlbdtEeu2bOV+tyO56+Ruxv1ldxKjKv4s
	5GmXEppRcmL96Y7fX5gf7mJ8avr3tf79uuBKu7QzZ1VSktnncvLueOlaJxXKctfV4wXzmxbj
	47a/GKJ6TW4HXJA7Ii80yb4zf5+uc3lLx57yYpW5Wztu75278M1cbk0lluKMREMt5qLiRADj
	aUT+iAIAAA==
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
index c4ca346dcd50..7455ac95ecbc 100644
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
 	struct charger_manager *cm = container_of(psy,
 			struct charger_manager, charger_psy);
 	struct charger_desc *desc = cm->desc;
-	struct power_supply *fuel_gauge;
+	struct power_supply *fuel_gauge = NULL;
 	int ret = 0;
 	int uV;
 
@@ -919,18 +940,18 @@ static int charger_get_property(struct power_supply *psy,
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
 			break;
 		}
 
+		fuel_gauge = power_supply_get_by_name(cm->desc->psy_fuel_gauge);
+		if (!fuel_gauge) {
+			ret = -ENODEV;
+			break;
+		}
+
 		ret = power_supply_get_property(fuel_gauge,
 					POWER_SUPPLY_PROP_CAPACITY, val);
 		if (ret)
@@ -1005,6 +1026,8 @@ static int charger_get_property(struct power_supply *psy,
 	default:
 		return -EINVAL;
 	}
+	if (fuel_gauge)
+		power_supply_put(fuel_gauge);
 	return ret;
 }
 
@@ -1803,13 +1826,7 @@ static int charger_manager_probe(struct platform_device *pdev)
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
@@ -1849,6 +1866,12 @@ static int charger_manager_probe(struct platform_device *pdev)
 	cm->charger_psy.num_properties = psy_default.num_properties;
 
 	/* Find which optional psy-properties are available */
+	fuel_gauge = power_supply_get_by_name(desc->psy_fuel_gauge);
+	if (!fuel_gauge) {
+		dev_err(&pdev->dev, "Cannot find power supply \"%s\"\n",
+			desc->psy_fuel_gauge);
+		return -ENODEV;
+	}
 	if (!power_supply_get_property(fuel_gauge,
 					  POWER_SUPPLY_PROP_CHARGE_NOW, &val)) {
 		cm->charger_psy.properties[cm->charger_psy.num_properties] =
@@ -1868,6 +1891,7 @@ static int charger_manager_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "Failed to initialize thermal data\n");
 		cm->desc->measure_battery_temp = false;
 	}
+	power_supply_put(fuel_gauge);
 
 	INIT_DELAYED_WORK(&cm->fullbatt_vchk_work, fullbatt_vchk);
 
-- 
1.9.1

