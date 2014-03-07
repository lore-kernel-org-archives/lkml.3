Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792AbaCGF35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 00:29:57 -0500
Received: from mga09.intel.com ([134.134.136.24]:30136 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647AbaCGF3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 00:29:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,605,1389772800"; 
   d="scan'208";a="468199228"
From: Jenny TC <jenny.tc@intel.com>
To: linux-kernel@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Jenny TC <jenny.tc@intel.com>, Kim Milo <Milo.Kim@ti.com>,
        Lee Jones <lee.jones@linaro.org>, Jingoo Han <jg1.han@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Rhyland Klein <rklein@nvidia.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sebastian Reichel <sre@ring0.de>, aaro.koskinen@iki.fi,
        Pallala Ramakrishna <ramakrishna.pallala@intel.com>,
        freemangordon@abv.bg, linux-omap@vger.kernel.org
Subject: [PATCHv8 1/4] power_supply: Add inlmt,iterm, min/max temp props
Date: Fri,  7 Mar 2014 10:59:31 +0530
Message-Id: <1394170174-21959-2-git-send-email-jenny.tc@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394170174-21959-1-git-send-email-jenny.tc@intel.com>
References: <1394170174-21959-1-git-send-email-jenny.tc@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new power supply properties for input current, charge termination
current, min and max temperature

POWER_SUPPLY_PROP_TEMP_MIN - minimum operatable temperature
POWER_SUPPLY_PROP_TEMP_MAX - maximum operatable temperature

POWER_SUPPLY_PROP_INLMT - input current limit programmed by charger. Indicates
the input current for a charging source.

POWER_SUPPLY_PROP_CHARGE_TERM_CUR - Charge termination current used to detect
the end of charge condition

Signed-off-by: Jenny TC <jenny.tc@intel.com>
---
 Documentation/power/power_supply_class.txt |    6 ++++++
 drivers/power/power_supply_sysfs.c         |    4 ++++
 include/linux/power_supply.h               |    4 ++++
 3 files changed, 14 insertions(+)

diff --git a/Documentation/power/power_supply_class.txt b/Documentation/power/power_supply_class.txt
index 89a8816..48cff88 100644
--- a/Documentation/power/power_supply_class.txt
+++ b/Documentation/power/power_supply_class.txt
@@ -118,6 +118,10 @@ relative, time-based measurements.
 CONSTANT_CHARGE_CURRENT - constant charge current programmed by charger.
 CONSTANT_CHARGE_CURRENT_MAX - maximum charge current supported by the
 power supply object.
+INPUT_CURRENT_LIMIT - input current limit programmed by charger. Indicates
+the current drawn from a charging source.
+CHARGE_TERM_CURRENT - Charge termination current used to detect the end of charge
+condition.
 
 CONSTANT_CHARGE_VOLTAGE - constant charge voltage programmed by charger.
 CONSTANT_CHARGE_VOLTAGE_MAX - maximum charge voltage supported by the
@@ -140,6 +144,8 @@ TEMP_ALERT_MAX - maximum battery temperature alert.
 TEMP_AMBIENT - ambient temperature.
 TEMP_AMBIENT_ALERT_MIN - minimum ambient temperature alert.
 TEMP_AMBIENT_ALERT_MAX - maximum ambient temperature alert.
+TEMP_MIN - minimum operatable temperature
+TEMP_MAX - maximum operatable temperature
 
 TIME_TO_EMPTY - seconds left for battery to be considered empty (i.e.
 while battery powers a load)
diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index 44420d1..750a202 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -167,6 +167,7 @@ static struct device_attribute power_supply_attrs[] = {
 	POWER_SUPPLY_ATTR(constant_charge_voltage_max),
 	POWER_SUPPLY_ATTR(charge_control_limit),
 	POWER_SUPPLY_ATTR(charge_control_limit_max),
+	POWER_SUPPLY_ATTR(input_current_limit),
 	POWER_SUPPLY_ATTR(energy_full_design),
 	POWER_SUPPLY_ATTR(energy_empty_design),
 	POWER_SUPPLY_ATTR(energy_full),
@@ -178,6 +179,8 @@ static struct device_attribute power_supply_attrs[] = {
 	POWER_SUPPLY_ATTR(capacity_alert_max),
 	POWER_SUPPLY_ATTR(capacity_level),
 	POWER_SUPPLY_ATTR(temp),
+	POWER_SUPPLY_ATTR(temp_max),
+	POWER_SUPPLY_ATTR(temp_min),
 	POWER_SUPPLY_ATTR(temp_alert_min),
 	POWER_SUPPLY_ATTR(temp_alert_max),
 	POWER_SUPPLY_ATTR(temp_ambient),
@@ -189,6 +192,7 @@ static struct device_attribute power_supply_attrs[] = {
 	POWER_SUPPLY_ATTR(time_to_full_avg),
 	POWER_SUPPLY_ATTR(type),
 	POWER_SUPPLY_ATTR(scope),
+	POWER_SUPPLY_ATTR(charge_term_current),
 	/* Properties of type `const char *' */
 	POWER_SUPPLY_ATTR(model_name),
 	POWER_SUPPLY_ATTR(manufacturer),
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index c9dc4e0..0278600 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -120,6 +120,7 @@ enum power_supply_property {
 	POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE_MAX,
 	POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT,
 	POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT_MAX,
+	POWER_SUPPLY_PROP_INPUT_CURRENT_LIMIT,
 	POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN,
 	POWER_SUPPLY_PROP_ENERGY_EMPTY_DESIGN,
 	POWER_SUPPLY_PROP_ENERGY_FULL,
@@ -131,6 +132,8 @@ enum power_supply_property {
 	POWER_SUPPLY_PROP_CAPACITY_ALERT_MAX, /* in percents! */
 	POWER_SUPPLY_PROP_CAPACITY_LEVEL,
 	POWER_SUPPLY_PROP_TEMP,
+	POWER_SUPPLY_PROP_TEMP_MAX,
+	POWER_SUPPLY_PROP_TEMP_MIN,
 	POWER_SUPPLY_PROP_TEMP_ALERT_MIN,
 	POWER_SUPPLY_PROP_TEMP_ALERT_MAX,
 	POWER_SUPPLY_PROP_TEMP_AMBIENT,
@@ -142,6 +145,7 @@ enum power_supply_property {
 	POWER_SUPPLY_PROP_TIME_TO_FULL_AVG,
 	POWER_SUPPLY_PROP_TYPE, /* use power_supply.type instead */
 	POWER_SUPPLY_PROP_SCOPE,
+	POWER_SUPPLY_PROP_CHARGE_TERM_CURRENT,
 	/* Properties of type `const char *' */
 	POWER_SUPPLY_PROP_MODEL_NAME,
 	POWER_SUPPLY_PROP_MANUFACTURER,
-- 
1.7.9.5

