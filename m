Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922Ab3GNJmc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 05:42:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:62820 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680Ab3GNJma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 05:42:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,662,1367996400"; 
   d="scan'208";a="345365470"
From: Jenny TC <jenny.tc@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Jenny TC <jenny.tc@intel.com>
Subject: [PATCH 1/3] power_supply: Add charger control properties
Date: Sun, 14 Jul 2013 23:07:45 +0530
Message-Id: <1373823466-2581-1-git-send-email-jenny.tc@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The battery charger needs to have control path along
with the reporting charger properties. In existing solutions
this is implemented using regulator framework. A regulator
framework doesn't fit a charger driver requirement because of the
following reason
Charger needs support two paths - charger path (charger to platform)
and charging (charger to battery).Disabling the charging path alone
(eg over battery temperature) will allow the platform to work with
power from charger without discharging the battery. And the charger
may need to be disabled completely based on the charger temperature
or the platform temperature. Charger has more than one pair of
voltage/current to control (CC,CV,INLMT).These features will not
directly fit in the regulator framework. Since the charger driver
sits in the power supply subsystem it make sense to add the properties
to control the charger.

Signed-off-by: Jenny TC <jenny.tc@intel.com>
---
 drivers/power/power_supply_sysfs.c |    8 ++++++++
 include/linux/power_supply.h       |    8 ++++++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index 29178f7..643971c 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -167,6 +167,7 @@ static struct device_attribute power_supply_attrs[] = {
 	POWER_SUPPLY_ATTR(constant_charge_voltage_max),
 	POWER_SUPPLY_ATTR(charge_control_limit),
 	POWER_SUPPLY_ATTR(charge_control_limit_max),
+	POWER_SUPPLY_ATTR(input_cur_limit),
 	POWER_SUPPLY_ATTR(energy_full_design),
 	POWER_SUPPLY_ATTR(energy_empty_design),
 	POWER_SUPPLY_ATTR(energy_full),
@@ -178,6 +179,8 @@ static struct device_attribute power_supply_attrs[] = {
 	POWER_SUPPLY_ATTR(capacity_alert_max),
 	POWER_SUPPLY_ATTR(capacity_level),
 	POWER_SUPPLY_ATTR(temp),
+	POWER_SUPPLY_ATTR(max_temp),
+	POWER_SUPPLY_ATTR(min_temp),
 	POWER_SUPPLY_ATTR(temp_alert_min),
 	POWER_SUPPLY_ATTR(temp_alert_max),
 	POWER_SUPPLY_ATTR(temp_ambient),
@@ -189,6 +192,11 @@ static struct device_attribute power_supply_attrs[] = {
 	POWER_SUPPLY_ATTR(time_to_full_avg),
 	POWER_SUPPLY_ATTR(type),
 	POWER_SUPPLY_ATTR(scope),
+	POWER_SUPPLY_ATTR(charge_term_cur),
+	POWER_SUPPLY_ATTR(enable_charging),
+	POWER_SUPPLY_ATTR(enable_charger),
+	POWER_SUPPLY_ATTR(cable_type),
+	POWER_SUPPLY_ATTR(priority),
 	/* Properties of type `const char *' */
 	POWER_SUPPLY_ATTR(model_name),
 	POWER_SUPPLY_ATTR(manufacturer),
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 804b906..1265131 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -118,6 +118,7 @@ enum power_supply_property {
 	POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE_MAX,
 	POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT,
 	POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT_MAX,
+	POWER_SUPPLY_PROP_INLMT,
 	POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN,
 	POWER_SUPPLY_PROP_ENERGY_EMPTY_DESIGN,
 	POWER_SUPPLY_PROP_ENERGY_FULL,
@@ -129,6 +130,8 @@ enum power_supply_property {
 	POWER_SUPPLY_PROP_CAPACITY_ALERT_MAX, /* in percents! */
 	POWER_SUPPLY_PROP_CAPACITY_LEVEL,
 	POWER_SUPPLY_PROP_TEMP,
+	POWER_SUPPLY_PROP_MAX_TEMP,
+	POWER_SUPPLY_PROP_MIN_TEMP,
 	POWER_SUPPLY_PROP_TEMP_ALERT_MIN,
 	POWER_SUPPLY_PROP_TEMP_ALERT_MAX,
 	POWER_SUPPLY_PROP_TEMP_AMBIENT,
@@ -140,6 +143,11 @@ enum power_supply_property {
 	POWER_SUPPLY_PROP_TIME_TO_FULL_AVG,
 	POWER_SUPPLY_PROP_TYPE, /* use power_supply.type instead */
 	POWER_SUPPLY_PROP_SCOPE,
+	POWER_SUPPLY_PROP_CHARGE_TERM_CUR,
+	POWER_SUPPLY_PROP_ENABLE_CHARGING,
+	POWER_SUPPLY_PROP_ENABLE_CHARGER,
+	POWER_SUPPLY_PROP_CABLE_TYPE,
+	POWER_SUPPLY_PROP_PRIORITY,
 	/* Properties of type `const char *' */
 	POWER_SUPPLY_PROP_MODEL_NAME,
 	POWER_SUPPLY_PROP_MANUFACTURER,
-- 
1.7.9.5

