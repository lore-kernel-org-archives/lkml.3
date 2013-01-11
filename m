Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab3AKNNe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 08:13:34 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:37764 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088Ab3AKNNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 08:13:32 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, cbouatmailru@gmail.com,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 05/18] power: ab8500_charger: Handle gpadc errors
Date: Fri, 11 Jan 2013 13:12:53 +0000
Message-Id: <1357909986-9262-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357909986-9262-1-git-send-email-lee.jones@linaro.org>
References: <1357909986-9262-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

Gracefully handle gpadc conversion errors.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Reviewed-by: Johan BJORNSTEDT <johan.bjornstedt@stericsson.com>
---
 drivers/power/ab8500_charger.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index bbf7782e..919d156 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -160,6 +160,7 @@ struct ab8500_charger_info {
 	int charger_voltage;
 	int cv_active;
 	bool wd_expired;
+	int charger_current;
 };
 
 struct ab8500_charger_event_flags {
@@ -2358,6 +2359,7 @@ static int ab8500_charger_ac_get_property(struct power_supply *psy,
 	union power_supply_propval *val)
 {
 	struct ab8500_charger *di;
+	int ret;
 
 	di = to_ab8500_charger_ac_device_info(psy_to_ux500_charger(psy));
 
@@ -2379,7 +2381,10 @@ static int ab8500_charger_ac_get_property(struct power_supply *psy,
 		val->intval = di->ac.charger_connected;
 		break;
 	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
-		di->ac.charger_voltage = ab8500_charger_get_ac_voltage(di);
+		ret = ab8500_charger_get_ac_voltage(di);
+		if (ret >= 0)
+			di->ac.charger_voltage = ret;
+		/* On error, use previous value */
 		val->intval = di->ac.charger_voltage * 1000;
 		break;
 	case POWER_SUPPLY_PROP_VOLTAGE_AVG:
@@ -2391,7 +2396,10 @@ static int ab8500_charger_ac_get_property(struct power_supply *psy,
 		val->intval = di->ac.cv_active;
 		break;
 	case POWER_SUPPLY_PROP_CURRENT_NOW:
-		val->intval = ab8500_charger_get_ac_current(di) * 1000;
+		ret = ab8500_charger_get_ac_current(di);
+		if (ret >= 0)
+			di->ac.charger_current = ret;
+		val->intval = di->ac.charger_current * 1000;
 		break;
 	default:
 		return -EINVAL;
@@ -2418,6 +2426,7 @@ static int ab8500_charger_usb_get_property(struct power_supply *psy,
 	union power_supply_propval *val)
 {
 	struct ab8500_charger *di;
+	int ret;
 
 	di = to_ab8500_charger_usb_device_info(psy_to_ux500_charger(psy));
 
@@ -2441,7 +2450,9 @@ static int ab8500_charger_usb_get_property(struct power_supply *psy,
 		val->intval = di->usb.charger_connected;
 		break;
 	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
-		di->usb.charger_voltage = ab8500_charger_get_vbus_voltage(di);
+		ret = ab8500_charger_get_vbus_voltage(di);
+		if (ret >= 0)
+			di->usb.charger_voltage = ret;
 		val->intval = di->usb.charger_voltage * 1000;
 		break;
 	case POWER_SUPPLY_PROP_VOLTAGE_AVG:
@@ -2453,7 +2464,10 @@ static int ab8500_charger_usb_get_property(struct power_supply *psy,
 		val->intval = di->usb.cv_active;
 		break;
 	case POWER_SUPPLY_PROP_CURRENT_NOW:
-		val->intval = ab8500_charger_get_usb_current(di) * 1000;
+		ret = ab8500_charger_get_usb_current(di);
+		if (ret >= 0)
+			di->usb.charger_current = ret;
+		val->intval = di->usb.charger_current * 1000;
 		break;
 	case POWER_SUPPLY_PROP_CURRENT_AVG:
 		/*
-- 
1.7.9.5

