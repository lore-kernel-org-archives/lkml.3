Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934508AbaGXSQt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 14:16:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934165AbaGXSOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 14:14:41 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>,
        Przemo Firszt <przemo@firszt.eu>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH v2 03/10] Input - wacom: enhance Wireless Receiver battery reporting
Date: Thu, 24 Jul 2014 14:13:58 -0400
Message-Id: <1406225645-32141-4-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1406225645-32141-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1406225645-32141-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Reports the current status of the battery (discharging, charging, full).
- Also notify the upower daemon when there is a change in the battery
  value.
- keep the battery value as a percentage, not the raw value
- add WACOM_QUIRK_BATTERY to easily add a battery to a device (required
  for Bluetooth devices)

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---

changes in v2:
- add WACOM_QUIRK_BATTERY, which simplifies a bit the other patches

 drivers/hid/wacom.h     |  6 ++++++
 drivers/hid/wacom_sys.c | 19 +++++++++++++++----
 drivers/hid/wacom_wac.c | 22 ++++++++++++++++++----
 drivers/hid/wacom_wac.h |  3 +++
 4 files changed, 42 insertions(+), 8 deletions(-)

diff --git a/drivers/hid/wacom.h b/drivers/hid/wacom.h
index a678f82..99516ba 100644
--- a/drivers/hid/wacom.h
+++ b/drivers/hid/wacom.h
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
diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
index c857b3d..f0ee7ff 100644
--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -769,6 +769,7 @@ static void wacom_destroy_leds(struct wacom *wacom)
 }
 
 static enum power_supply_property wacom_battery_props[] = {
+	POWER_SUPPLY_PROP_STATUS,
 	POWER_SUPPLY_PROP_SCOPE,
 	POWER_SUPPLY_PROP_CAPACITY
 };
@@ -786,7 +787,16 @@ static int wacom_battery_get_property(struct power_supply *psy,
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
@@ -800,7 +810,7 @@ static int wacom_initialize_battery(struct wacom *wacom)
 {
 	int error = 0;
 
-	if (wacom->wacom_wac.features.quirks & WACOM_QUIRK_MONITOR) {
+	if (wacom->wacom_wac.features.quirks & WACOM_QUIRK_BATTERY) {
 		wacom->battery.properties = wacom_battery_props;
 		wacom->battery.num_properties = ARRAY_SIZE(wacom_battery_props);
 		wacom->battery.get_property = wacom_battery_get_property;
@@ -821,8 +831,8 @@ static int wacom_initialize_battery(struct wacom *wacom)
 
 static void wacom_destroy_battery(struct wacom *wacom)
 {
-	if (wacom->wacom_wac.features.quirks & WACOM_QUIRK_MONITOR &&
-	    wacom->battery.dev) {
+	if ((wacom->wacom_wac.features.quirks & WACOM_QUIRK_BATTERY) &&
+	     wacom->battery.dev) {
 		power_supply_unregister(&wacom->battery);
 		wacom->battery.dev = NULL;
 	}
@@ -947,6 +957,7 @@ static void wacom_wireless_work(struct work_struct *work)
 
 	if (wacom_wac->pid == 0) {
 		hid_info(wacom->hdev, "wireless tablet disconnected\n");
+		wacom_wac1->shared->type = 0;
 	} else {
 		const struct hid_device_id *id = wacom_ids;
 
diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index f30083f..2c69326 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
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
+		ps_connected = !!(data[5] & 0x80);
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
@@ -1558,8 +1570,10 @@ void wacom_setup_device_quirks(struct wacom_features *features)
 		features->quirks |= WACOM_QUIRK_NO_INPUT;
 
 		/* must be monitor interface if no device_type set */
-		if (!features->device_type)
+		if (!features->device_type) {
 			features->quirks |= WACOM_QUIRK_MONITOR;
+			features->quirks |= WACOM_QUIRK_BATTERY;
+		}
 	}
 }
 
diff --git a/drivers/hid/wacom_wac.h b/drivers/hid/wacom_wac.h
index 4c59247..8a042ac 100644
--- a/drivers/hid/wacom_wac.h
+++ b/drivers/hid/wacom_wac.h
@@ -68,6 +68,7 @@
 #define WACOM_QUIRK_BBTOUCH_LOWRES	0x0002
 #define WACOM_QUIRK_NO_INPUT		0x0004
 #define WACOM_QUIRK_MONITOR		0x0008
+#define WACOM_QUIRK_BATTERY		0x0010
 
 enum {
 	PENPARTNER = 0,
@@ -164,6 +165,8 @@ struct wacom_wac {
 	int pid;
 	int battery_capacity;
 	int num_contacts_left;
+	int bat_charging;
+	int ps_connected;
 };
 
 #endif
-- 
2.0.1

