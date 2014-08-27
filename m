Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539AbaH0KJE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 06:09:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:20680 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755288AbaH0KJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 06:09:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,409,1406617200"; 
   d="scan'208";a="590499187"
From: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
To: linux-kernel@vger.kernel.org, Sebastian Reichel <sre@kernel.org>
Cc: Pallala Ramakrishna <ramakrishna.pallala@intel.com>
Subject: [PATCH] power_supply: Add boot and calibration attributes
Date: Wed, 27 Aug 2014 23:44:08 +0530
Message-Id: <1409163248-26997-1-git-send-email-ramakrishna.pallala@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Usually PMIC's come with coulomb counting mechanism which can be
used to implement a Fuel Gauginig solution in Software itself.
One of key input to these SW Fuel Gauge solutioons is the boot up
parameters like boot voltage and boot current.

This patch adds the VOLTAGE_BOOT and CURRENT_BOOT power supply attributes
to report bootup voltage and current.

This patch also adds CALIBRATE power supply attribute which useful is
for calibrating the battery/coulomb counter.

Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
---
 Documentation/power/power_supply_class.txt |    6 ++++++
 drivers/power/power_supply_sysfs.c         |    3 +++
 include/linux/power_supply.h               |    5 +++++
 3 files changed, 14 insertions(+)

diff --git a/Documentation/power/power_supply_class.txt b/Documentation/power/power_supply_class.txt
index 48cff88..82dacc0 100644
--- a/Documentation/power/power_supply_class.txt
+++ b/Documentation/power/power_supply_class.txt
@@ -101,6 +101,10 @@ VOLTAGE_MAX, VOLTAGE_MIN - same as _DESIGN voltage values except that
 these ones should be used if hardware could only guess (measure and
 retain) the thresholds of a given power supply.
 
+VOLTAGE_BOOT - Reports the voltage measured during boot
+
+CURRENT_BOOT - Reports the current measured during boot
+
 CHARGE_FULL_DESIGN, CHARGE_EMPTY_DESIGN - design charge values, when
 battery considered full/empty.
 
@@ -123,6 +127,8 @@ the current drawn from a charging source.
 CHARGE_TERM_CURRENT - Charge termination current used to detect the end of charge
 condition.
 
+CALIBRATE - battery or coulomb counter calibration status
+
 CONSTANT_CHARGE_VOLTAGE - constant charge voltage programmed by charger.
 CONSTANT_CHARGE_VOLTAGE_MAX - maximum charge voltage supported by the
 power supply object.
diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index 750a202..7e4726d 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -149,9 +149,11 @@ static struct device_attribute power_supply_attrs[] = {
 	POWER_SUPPLY_ATTR(voltage_now),
 	POWER_SUPPLY_ATTR(voltage_avg),
 	POWER_SUPPLY_ATTR(voltage_ocv),
+	POWER_SUPPLY_ATTR(voltage_boot),
 	POWER_SUPPLY_ATTR(current_max),
 	POWER_SUPPLY_ATTR(current_now),
 	POWER_SUPPLY_ATTR(current_avg),
+	POWER_SUPPLY_ATTR(current_boot),
 	POWER_SUPPLY_ATTR(power_now),
 	POWER_SUPPLY_ATTR(power_avg),
 	POWER_SUPPLY_ATTR(charge_full_design),
@@ -193,6 +195,7 @@ static struct device_attribute power_supply_attrs[] = {
 	POWER_SUPPLY_ATTR(type),
 	POWER_SUPPLY_ATTR(scope),
 	POWER_SUPPLY_ATTR(charge_term_current),
+	POWER_SUPPLY_ATTR(calibrate),
 	/* Properties of type `const char *' */
 	POWER_SUPPLY_ATTR(model_name),
 	POWER_SUPPLY_ATTR(manufacturer),
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index f3dea41..de59a28 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -102,9 +102,11 @@ enum power_supply_property {
 	POWER_SUPPLY_PROP_VOLTAGE_NOW,
 	POWER_SUPPLY_PROP_VOLTAGE_AVG,
 	POWER_SUPPLY_PROP_VOLTAGE_OCV,
+	POWER_SUPPLY_PROP_VOLTAGE_BOOT,
 	POWER_SUPPLY_PROP_CURRENT_MAX,
 	POWER_SUPPLY_PROP_CURRENT_NOW,
 	POWER_SUPPLY_PROP_CURRENT_AVG,
+	POWER_SUPPLY_PROP_CURRENT_BOOT,
 	POWER_SUPPLY_PROP_POWER_NOW,
 	POWER_SUPPLY_PROP_POWER_AVG,
 	POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN,
@@ -146,6 +148,7 @@ enum power_supply_property {
 	POWER_SUPPLY_PROP_TYPE, /* use power_supply.type instead */
 	POWER_SUPPLY_PROP_SCOPE,
 	POWER_SUPPLY_PROP_CHARGE_TERM_CURRENT,
+	POWER_SUPPLY_PROP_CALIBRATE,
 	/* Properties of type `const char *' */
 	POWER_SUPPLY_PROP_MODEL_NAME,
 	POWER_SUPPLY_PROP_MANUFACTURER,
@@ -291,6 +294,7 @@ static inline bool power_supply_is_amp_property(enum power_supply_property psp)
 	case POWER_SUPPLY_PROP_CURRENT_MAX:
 	case POWER_SUPPLY_PROP_CURRENT_NOW:
 	case POWER_SUPPLY_PROP_CURRENT_AVG:
+	case POWER_SUPPLY_PROP_CURRENT_BOOT:
 		return 1;
 	default:
 		break;
@@ -315,6 +319,7 @@ static inline bool power_supply_is_watt_property(enum power_supply_property psp)
 	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
 	case POWER_SUPPLY_PROP_VOLTAGE_AVG:
 	case POWER_SUPPLY_PROP_VOLTAGE_OCV:
+	case POWER_SUPPLY_PROP_VOLTAGE_BOOT:
 	case POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE:
 	case POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE_MAX:
 	case POWER_SUPPLY_PROP_POWER_NOW:
-- 
1.7.9.5

