Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbbAEVc0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 16:32:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55606 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003AbbAEVcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 16:32:25 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>, Jason Gerecke <killertofu@gmail.com>
Cc: josep.sanchez.ferreres@est.fib.upc.edu, Ping Cheng <pinglinux@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] HID: wacom: use WACOM_*_FIELD macros in wacom_usage_mapping()
Date: Mon,  5 Jan 2015 16:32:12 -0500
Message-Id: <1420493533-11639-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We introduced nice macros in wacom_wac.c to check whether a field is
a pen or a touch one.

wacom_usage_mapping() still uses it's own tests, which are not in sync with
the wacom_wac tests (.application is not checked).

That means that some legitimate fields might be filtered out from the
usage mapping, and thus will not be used properly while receiving the
events.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/wacom_sys.c | 6 ++----
 drivers/hid/wacom_wac.c | 8 --------
 drivers/hid/wacom_wac.h | 8 ++++++++
 3 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
index 6542029..f01ab3a 100644
--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -173,10 +173,8 @@ static void wacom_usage_mapping(struct hid_device *hdev,
 {
 	struct wacom *wacom = hid_get_drvdata(hdev);
 	struct wacom_features *features = &wacom->wacom_wac.features;
-	bool finger = (field->logical == HID_DG_FINGER) ||
-		      (field->physical == HID_DG_FINGER);
-	bool pen = (field->logical == HID_DG_STYLUS) ||
-		   (field->physical == HID_DG_STYLUS);
+	bool finger = WACOM_FINGER_FIELD(field);
+	bool pen = WACOM_PEN_FIELD(field);
 
 	/*
 	* Requiring Stylus Usage will ignore boot mouse
diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index ac7447c..596a6fb5 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -15,7 +15,6 @@
 #include "wacom_wac.h"
 #include "wacom.h"
 #include <linux/input/mt.h>
-#include <linux/hid.h>
 
 /* resolution for penabled devices */
 #define WACOM_PL_RES		20
@@ -1514,13 +1513,6 @@ static void wacom_wac_finger_report(struct hid_device *hdev,
 	wacom_wac->shared->touch_down = wacom_wac_finger_count_touches(hdev);
 }
 
-#define WACOM_PEN_FIELD(f)	(((f)->logical == HID_DG_STYLUS) || \
-				 ((f)->physical == HID_DG_STYLUS) || \
-				 ((f)->application == HID_DG_PEN))
-#define WACOM_FINGER_FIELD(f)	(((f)->logical == HID_DG_FINGER) || \
-				 ((f)->physical == HID_DG_FINGER) || \
-				 ((f)->application == HID_DG_TOUCHSCREEN))
-
 void wacom_wac_usage_mapping(struct hid_device *hdev,
 		struct hid_field *field, struct hid_usage *usage)
 {
diff --git a/drivers/hid/wacom_wac.h b/drivers/hid/wacom_wac.h
index bfad815..7436f2b 100644
--- a/drivers/hid/wacom_wac.h
+++ b/drivers/hid/wacom_wac.h
@@ -10,6 +10,7 @@
 #define WACOM_WAC_H
 
 #include <linux/types.h>
+#include <linux/hid.h>
 
 /* maximum packet length for USB devices */
 #define WACOM_PKGLEN_MAX	68
@@ -71,6 +72,13 @@
 #define WACOM_QUIRK_MONITOR		0x0008
 #define WACOM_QUIRK_BATTERY		0x0010
 
+#define WACOM_PEN_FIELD(f)	(((f)->logical == HID_DG_STYLUS) || \
+				 ((f)->physical == HID_DG_STYLUS) || \
+				 ((f)->application == HID_DG_PEN))
+#define WACOM_FINGER_FIELD(f)	(((f)->logical == HID_DG_FINGER) || \
+				 ((f)->physical == HID_DG_FINGER) || \
+				 ((f)->application == HID_DG_TOUCHSCREEN))
+
 enum {
 	PENPARTNER = 0,
 	GRAPHIRE,
-- 
2.1.0

