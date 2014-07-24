Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934367AbaGXSOz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 14:14:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934294AbaGXSOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 14:14:52 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>,
        Przemo Firszt <przemo@firszt.eu>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH v2 05/10] Input - wacom: register an ac power supply for wireless devices
Date: Thu, 24 Jul 2014 14:14:00 -0400
Message-Id: <1406225645-32141-6-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1406225645-32141-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1406225645-32141-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is used by HID Bluetooth devices but also add some more information
to the USB Wireless Receiver.
We are just porting the bits from hid-wacom.c to the common driver here.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---

new in v2

 drivers/hid/wacom.h     |  1 +
 drivers/hid/wacom_sys.c | 58 ++++++++++++++++++++++++++++++++++++++++++++-----
 drivers/hid/wacom_wac.h |  1 +
 3 files changed, 55 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/wacom.h b/drivers/hid/wacom.h
index 99516ba..2b5562b 100644
--- a/drivers/hid/wacom.h
+++ b/drivers/hid/wacom.h
@@ -120,6 +120,7 @@ struct wacom {
 	} led;
 	bool led_initialized;
 	struct power_supply battery;
+	struct power_supply ac;
 };
 
 static inline void wacom_schedule_work(struct wacom_wac *wacom_wac)
diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
index eb8705d..d0d06b8 100644
--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -774,6 +774,12 @@ static enum power_supply_property wacom_battery_props[] = {
 	POWER_SUPPLY_PROP_CAPACITY
 };
 
+static enum power_supply_property wacom_ac_props[] = {
+	POWER_SUPPLY_PROP_PRESENT,
+	POWER_SUPPLY_PROP_ONLINE,
+	POWER_SUPPLY_PROP_SCOPE,
+};
+
 static int wacom_battery_get_property(struct power_supply *psy,
 				      enum power_supply_property psp,
 				      union power_supply_propval *val)
@@ -806,14 +812,38 @@ static int wacom_battery_get_property(struct power_supply *psy,
 	return ret;
 }
 
+static int wacom_ac_get_property(struct power_supply *psy,
+				enum power_supply_property psp,
+				union power_supply_propval *val)
+{
+	struct wacom *wacom = container_of(psy, struct wacom, ac);
+	int ret = 0;
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_PRESENT:
+		/* fall through */
+	case POWER_SUPPLY_PROP_ONLINE:
+		val->intval = wacom->wacom_wac.ps_connected;
+		break;
+	case POWER_SUPPLY_PROP_SCOPE:
+		val->intval = POWER_SUPPLY_SCOPE_DEVICE;
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	return ret;
+}
+
 static int wacom_initialize_battery(struct wacom *wacom)
 {
-	int error = 0;
 	static atomic_t battery_no = ATOMIC_INIT(0);
+	int error;
 	unsigned long n;
 
 	if (wacom->wacom_wac.features.quirks & WACOM_QUIRK_BATTERY) {
 		n = atomic_inc_return(&battery_no) - 1;
+
 		wacom->battery.properties = wacom_battery_props;
 		wacom->battery.num_properties = ARRAY_SIZE(wacom_battery_props);
 		wacom->battery.get_property = wacom_battery_get_property;
@@ -822,15 +852,31 @@ static int wacom_initialize_battery(struct wacom *wacom)
 		wacom->battery.type = POWER_SUPPLY_TYPE_BATTERY;
 		wacom->battery.use_for_apm = 0;
 
+		wacom->ac.properties = wacom_ac_props;
+		wacom->ac.num_properties = ARRAY_SIZE(wacom_ac_props);
+		wacom->ac.get_property = wacom_ac_get_property;
+		sprintf(wacom->wacom_wac.ac_name, "wacom_ac_%ld", n);
+		wacom->ac.name = wacom->wacom_wac.ac_name;
+		wacom->ac.type = POWER_SUPPLY_TYPE_MAINS;
+		wacom->ac.use_for_apm = 0;
+
 		error = power_supply_register(&wacom->hdev->dev,
 					      &wacom->battery);
+		if (error)
+			return error;
+
+		power_supply_powers(&wacom->battery, &wacom->hdev->dev);
+
+		error = power_supply_register(&wacom->hdev->dev, &wacom->ac);
+		if (error) {
+			power_supply_unregister(&wacom->battery);
+			return error;
+		}
 
-		if (!error)
-			power_supply_powers(&wacom->battery,
-					    &wacom->hdev->dev);
+		power_supply_powers(&wacom->ac, &wacom->hdev->dev);
 	}
 
-	return error;
+	return 0;
 }
 
 static void wacom_destroy_battery(struct wacom *wacom)
@@ -839,6 +885,8 @@ static void wacom_destroy_battery(struct wacom *wacom)
 	     wacom->battery.dev) {
 		power_supply_unregister(&wacom->battery);
 		wacom->battery.dev = NULL;
+		power_supply_unregister(&wacom->ac);
+		wacom->ac.dev = NULL;
 	}
 }
 
diff --git a/drivers/hid/wacom_wac.h b/drivers/hid/wacom_wac.h
index 6cdf707..3433a0e 100644
--- a/drivers/hid/wacom_wac.h
+++ b/drivers/hid/wacom_wac.h
@@ -155,6 +155,7 @@ struct wacom_wac {
 	char name[WACOM_NAME_MAX];
 	char pad_name[WACOM_NAME_MAX];
 	char bat_name[WACOM_NAME_MAX];
+	char ac_name[WACOM_NAME_MAX];
 	unsigned char data[WACOM_PKGLEN_MAX];
 	int tool[2];
 	int id[2];
-- 
2.0.1

