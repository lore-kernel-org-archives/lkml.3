Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab3F2KRi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 06:17:38 -0400
Received: from wren.arvixe.com ([50.97.138.117]:34950 "EHLO wren.arvixe.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751940Ab3F2KRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 06:17:35 -0400
X-Greylist: delayed 1178 seconds by postgrey-1.27 at vger.kernel.org; Sat, 29 Jun 2013 06:17:35 EDT
From: Przemo Firszt <przemo@firszt.eu>
To: jkosina@suse.cz, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: pinglinux@gmail.com, Przemo Firszt <przemo@firszt.eu>
Subject: [PATCH] hid: wacom: Intuos4 battery charging changes
Date: Sat, 29 Jun 2013 10:57:13 +0100
Message-Id: <1372499833-7814-1-git-send-email-przemo@firszt.eu>
X-Mailer: git-send-email 1.8.1.4
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - wren.arvixe.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - firszt.eu
X-Get-Message-Sender-Via: wren.arvixe.com: authenticated_id: przemo@firszt.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intuos4 WL is separately reporting power supply and battery
charging status - now hid-wacom is using that information.
Previously hid-wacom was wrongly treating "battery charging" bit
as "power supply connected". Now it should report battery charging,
battery discharging, battery full and power supply status.

Intuos4 WL sends reports when is in use (obvious) and when unplugging
power supply. If means that if the device is being charged, but it's not
being used it will never report "battery full". The same problem happens
after the device has been connected, but it's not in use - the
battery/ac status will be incorrect. Currently there is no mechanism to
ask the device to send a report containing battery/ac status.

Signed-off-by: Przemo Firszt <przemo@firszt.eu>
---
 drivers/hid/hid-wacom.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-wacom.c b/drivers/hid/hid-wacom.c
index a4a8bb0..60c75dc 100644
--- a/drivers/hid/hid-wacom.c
+++ b/drivers/hid/hid-wacom.c
@@ -46,6 +46,7 @@ struct wacom_data {
 	__u8 battery_capacity;
 	__u8 power_raw;
 	__u8 ps_connected;
+	__u8 bat_charging;
 	struct power_supply battery;
 	struct power_supply ac;
 	__u8 led_selector;
@@ -62,6 +63,7 @@ static enum power_supply_property wacom_battery_props[] = {
 	POWER_SUPPLY_PROP_PRESENT,
 	POWER_SUPPLY_PROP_CAPACITY,
 	POWER_SUPPLY_PROP_SCOPE,
+	POWER_SUPPLY_PROP_STATUS,
 };
 
 static enum power_supply_property wacom_ac_props[] = {
@@ -287,6 +289,15 @@ static int wacom_battery_get_property(struct power_supply *psy,
 	case POWER_SUPPLY_PROP_CAPACITY:
 		val->intval = wdata->battery_capacity;
 		break;
+	case POWER_SUPPLY_PROP_STATUS:
+		if (wdata->bat_charging)
+			val->intval = POWER_SUPPLY_STATUS_CHARGING;
+		else
+			if (wdata->battery_capacity == 100 && wdata->ps_connected)
+				val->intval = POWER_SUPPLY_STATUS_FULL;
+			else
+				val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
+		break;
 	default:
 		ret = -EINVAL;
 		break;
@@ -727,7 +738,8 @@ static int wacom_raw_event(struct hid_device *hdev, struct hid_report *report,
 			if (power_raw != wdata->power_raw) {
 				wdata->power_raw = power_raw;
 				wdata->battery_capacity = batcap_i4[power_raw & 0x07];
-				wdata->ps_connected = power_raw & 0x08;
+				wdata->bat_charging = (power_raw & 0x08) ? 1 : 0;
+				wdata->ps_connected = (power_raw & 0x10) ? 1 : 0;
 			}
 
 			break;
-- 
1.8.1.4

