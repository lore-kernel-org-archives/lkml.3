Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830AbaGJSpw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 14:45:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbaGJSpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 14:45:49 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Przemo Firszt <przemo@firszt.eu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Ping Cheng <pinglinux@gmail.com>,
        Jason Gerecke <killertofu@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH 1/5] Input - wacom: enhance Wireless Receiver battery reporting
Date: Thu, 10 Jul 2014 14:44:56 -0400
Message-Id: <1405017900-16024-2-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1405017900-16024-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1405017900-16024-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Reports the current status of the battery (discharging, cherging, full).
- Also notify the upower daemon when there is a change in the battery
  value.
- keep the battery value as a percentage, not the raw value

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/input/tablet/wacom.h     |  6 ++++++
 drivers/input/tablet/wacom_sys.c | 13 ++++++++++++-
 drivers/input/tablet/wacom_wac.c | 18 +++++++++++++++---
 drivers/input/tablet/wacom_wac.h |  2 ++
 4 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/drivers/input/tablet/wacom.h b/drivers/input/tablet/wacom.h
index a678f82..99516ba 100644
--- a/drivers/input/tablet/wacom.h
+++ b/drivers/input/tablet/wacom.h
@@ -128,6 +128,12 @@ static inline void wacom_schedule_work(struct wacom_wac *wacom_wac)
 	schedule_work(&wacom->work);
 }
 
+static inline void wacom_notify_battery(struct wacom_wac *wacom_wac)
+{
+	struct wacom *wacom = container_of(wacom_wac, struct wacom, wacom_wac);
+	power_supply_changed(&wacom->battery);
+}
+
 extern const struct hid_device_id wacom_ids[];
 
 void wacom_wac_irq(struct wacom_wac *wacom_wac, size_t len);
diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index fb2958e..1888709 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -766,6 +766,7 @@ static void wacom_destroy_leds(struct wacom *wacom)
 }
 
 static enum power_supply_property wacom_battery_props[] = {
+	POWER_SUPPLY_PROP_STATUS,
 	POWER_SUPPLY_PROP_SCOPE,
 	POWER_SUPPLY_PROP_CAPACITY
 };
@@ -783,7 +784,16 @@ static int wacom_battery_get_property(struct power_supply *psy,
 			break;
 		case POWER_SUPPLY_PROP_CAPACITY:
 			val->intval =
-				wacom->wacom_wac.battery_capacity * 100 / 31;
+				wacom->wacom_wac.battery_capacity;
+			break;
+		case POWER_SUPPLY_PROP_STATUS:
+			if (wacom->wacom_wac.bat_charging)
+				val->intval = POWER_SUPPLY_STATUS_CHARGING;
+			else if (wacom->wacom_wac.battery_capacity == 100 &&
+				    wacom->wacom_wac.ps_connected)
+				val->intval = POWER_SUPPLY_STATUS_FULL;
+			else
+				val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
 			break;
 		default:
 			ret = -EINVAL;
@@ -944,6 +954,7 @@ static void wacom_wireless_work(struct work_struct *work)
 
 	if (wacom_wac->pid == 0) {
 		hid_info(wacom->hdev, "wireless tablet disconnected\n");
+		wacom_wac1->shared->type = 0;
 	} else {
 		const struct hid_device_id *id = wacom_ids;
 
diff --git a/drivers/input/tablet/wacom_wac.c b/drivers/input/tablet/wacom_wac.c
index cd91521..d935f75 100644
--- a/drivers/input/tablet/wacom_wac.c
+++ b/drivers/input/tablet/wacom_wac.c
@@ -1365,7 +1365,7 @@ static int wacom_wireless_irq(struct wacom_wac *wacom, size_t len)
 
 	connected = data[1] & 0x01;
 	if (connected) {
-		int pid, battery;
+		int pid, battery, ps_connected;
 
 		if ((wacom->shared->type == INTUOSHT) &&
 				wacom->shared->touch_max) {
@@ -1375,17 +1375,29 @@ static int wacom_wireless_irq(struct wacom_wac *wacom, size_t len)
 		}
 
 		pid = get_unaligned_be16(&data[6]);
-		battery = data[5] & 0x3f;
+		battery = (data[5] & 0x3f) * 100 / 31;
+		ps_connected = data[5] & 0x80;
 		if (wacom->pid != pid) {
 			wacom->pid = pid;
 			wacom_schedule_work(wacom);
 		}
-		wacom->battery_capacity = battery;
+
+		if (wacom->shared->type &&
+		    ((battery != wacom->battery_capacity) ||
+		     (ps_connected != wacom->ps_connected))) {
+			wacom->battery_capacity = battery;
+			wacom->ps_connected = ps_connected;
+			wacom->bat_charging = ps_connected &&
+						wacom->battery_capacity < 100;
+			wacom_notify_battery(wacom);
+		}
 	} else if (wacom->pid != 0) {
 		/* disconnected while previously connected */
 		wacom->pid = 0;
 		wacom_schedule_work(wacom);
 		wacom->battery_capacity = 0;
+		wacom->bat_charging = 0;
+		wacom->ps_connected = 0;
 	}
 
 	return 0;
diff --git a/drivers/input/tablet/wacom_wac.h b/drivers/input/tablet/wacom_wac.h
index 4c59247..68cf257 100644
--- a/drivers/input/tablet/wacom_wac.h
+++ b/drivers/input/tablet/wacom_wac.h
@@ -164,6 +164,8 @@ struct wacom_wac {
 	int pid;
 	int battery_capacity;
 	int num_contacts_left;
+	int bat_charging;
+	int ps_connected;
 };
 
 #endif
-- 
2.0.0

