Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbaGJSpc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 14:45:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324AbaGJSp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 14:45:29 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Przemo Firszt <przemo@firszt.eu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Ping Cheng <pinglinux@gmail.com>,
        Jason Gerecke <killertofu@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH 2/5] Input - wacom: use a specific name for the battery device
Date: Thu, 10 Jul 2014 14:44:57 -0400
Message-Id: <1405017900-16024-3-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1405017900-16024-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1405017900-16024-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current implementation uses "wacom_battery" as a generic name for
batteries. This prevents us to have two Wacom devices with a battery
attached as the power system will complain about the name which is already
registered.

Use a specific name for each type of battery attached.

A bug in upower prevents us to use spaces in the power name, so replace
each space by '_'.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/input/tablet/wacom_sys.c | 13 ++++++++++---
 drivers/input/tablet/wacom_wac.h |  1 +
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index 1888709..b5d75a4 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -803,15 +803,21 @@ static int wacom_battery_get_property(struct power_supply *psy,
 	return ret;
 }
 
-static int wacom_initialize_battery(struct wacom *wacom)
+static int wacom_initialize_battery(struct wacom *wacom, const char *name)
 {
 	int error = 0;
+	int i;
 
 	if (wacom->wacom_wac.features.quirks & WACOM_QUIRK_MONITOR) {
 		wacom->battery.properties = wacom_battery_props;
 		wacom->battery.num_properties = ARRAY_SIZE(wacom_battery_props);
 		wacom->battery.get_property = wacom_battery_get_property;
-		wacom->battery.name = "wacom_battery";
+		sprintf(wacom->wacom_wac.bat_name, "%s battery", name);
+		for (i=0; i < strlen(wacom->wacom_wac.bat_name); i++) {
+			if (wacom->wacom_wac.bat_name[i] == ' ')
+				wacom->wacom_wac.bat_name[i] = '_';
+		}
+		wacom->battery.name = wacom->wacom_wac.bat_name;
 		wacom->battery.type = POWER_SUPPLY_TYPE_BATTERY;
 		wacom->battery.use_for_apm = 0;
 
@@ -1012,7 +1018,8 @@ static void wacom_wireless_work(struct work_struct *work)
 				wacom_wac->shared->touch_input = wacom_wac2->input;
 		}
 
-		error = wacom_initialize_battery(wacom);
+		error = wacom_initialize_battery(wacom,
+				wacom_wac1->features.name);
 		if (error)
 			goto fail;
 	}
diff --git a/drivers/input/tablet/wacom_wac.h b/drivers/input/tablet/wacom_wac.h
index 68cf257..7565be5 100644
--- a/drivers/input/tablet/wacom_wac.h
+++ b/drivers/input/tablet/wacom_wac.h
@@ -153,6 +153,7 @@ struct wacom_shared {
 struct wacom_wac {
 	char name[WACOM_NAME_MAX];
 	char pad_name[WACOM_NAME_MAX];
+	char bat_name[WACOM_NAME_MAX];
 	unsigned char data[WACOM_PKGLEN_MAX];
 	int tool[2];
 	int id[2];
-- 
2.0.0

