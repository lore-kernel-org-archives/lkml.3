Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbaI3RXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 13:23:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18198 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450AbaI3RSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:18:47 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Andrew de los Reyes <andrew-vger@gizmolabs.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH 04/13] HID: logitech-dj: merge header file into the source
Date: Tue, 30 Sep 2014 13:18:26 -0400
Message-Id: <1412097515-17241-5-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1412097515-17241-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1412097515-17241-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no point in keeping the header in a separate file, nobody
but hid-logitech-dj should have access to its content.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-logitech-dj.c |  88 +++++++++++++++++++++++++++++++-
 drivers/hid/hid-logitech-dj.h | 115 ------------------------------------------
 2 files changed, 87 insertions(+), 116 deletions(-)
 delete mode 100644 drivers/hid/hid-logitech-dj.h

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index 42d38d5..6aea16d 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -26,9 +26,95 @@
 #include <linux/hid.h>
 #include <linux/module.h>
 #include <linux/usb.h>
+#include <linux/kfifo.h>
 #include <asm/unaligned.h>
 #include "hid-ids.h"
-#include "hid-logitech-dj.h"
+
+#define DJ_MAX_PAIRED_DEVICES			6
+#define DJ_MAX_NUMBER_NOTIFICATIONS		8
+#define DJ_RECEIVER_INDEX			0
+#define DJ_DEVICE_INDEX_MIN			1
+#define DJ_DEVICE_INDEX_MAX			6
+
+#define DJREPORT_SHORT_LENGTH			15
+#define DJREPORT_LONG_LENGTH			32
+
+#define REPORT_ID_DJ_SHORT			0x20
+#define REPORT_ID_DJ_LONG			0x21
+
+#define REPORT_TYPE_RFREPORT_LAST		0x1F
+
+/* Command Switch to DJ mode */
+#define REPORT_TYPE_CMD_SWITCH			0x80
+#define CMD_SWITCH_PARAM_DEVBITFIELD		0x00
+#define CMD_SWITCH_PARAM_TIMEOUT_SECONDS	0x01
+#define TIMEOUT_NO_KEEPALIVE			0x00
+
+/* Command to Get the list of Paired devices */
+#define REPORT_TYPE_CMD_GET_PAIRED_DEVICES	0x81
+
+/* Device Paired Notification */
+#define REPORT_TYPE_NOTIF_DEVICE_PAIRED		0x41
+#define SPFUNCTION_MORE_NOTIF_EXPECTED		0x01
+#define SPFUNCTION_DEVICE_LIST_EMPTY		0x02
+#define DEVICE_PAIRED_PARAM_SPFUNCTION		0x00
+#define DEVICE_PAIRED_PARAM_EQUAD_ID_LSB	0x01
+#define DEVICE_PAIRED_PARAM_EQUAD_ID_MSB	0x02
+#define DEVICE_PAIRED_RF_REPORT_TYPE		0x03
+
+/* Device Un-Paired Notification */
+#define REPORT_TYPE_NOTIF_DEVICE_UNPAIRED	0x40
+
+
+/* Connection Status Notification */
+#define REPORT_TYPE_NOTIF_CONNECTION_STATUS	0x42
+#define CONNECTION_STATUS_PARAM_STATUS		0x00
+#define STATUS_LINKLOSS				0x01
+
+/* Error Notification */
+#define REPORT_TYPE_NOTIF_ERROR			0x7F
+#define NOTIF_ERROR_PARAM_ETYPE			0x00
+#define ETYPE_KEEPALIVE_TIMEOUT			0x01
+
+/* supported DJ HID && RF report types */
+#define REPORT_TYPE_KEYBOARD			0x01
+#define REPORT_TYPE_MOUSE			0x02
+#define REPORT_TYPE_CONSUMER_CONTROL		0x03
+#define REPORT_TYPE_SYSTEM_CONTROL		0x04
+#define REPORT_TYPE_MEDIA_CENTER		0x08
+#define REPORT_TYPE_LEDS			0x0E
+
+/* RF Report types bitfield */
+#define STD_KEYBOARD				0x00000002
+#define STD_MOUSE				0x00000004
+#define MULTIMEDIA				0x00000008
+#define POWER_KEYS				0x00000010
+#define MEDIA_CENTER				0x00000100
+#define KBD_LEDS				0x00004000
+
+struct dj_report {
+	u8 report_id;
+	u8 device_index;
+	u8 report_type;
+	u8 report_params[DJREPORT_SHORT_LENGTH - 3];
+};
+
+struct dj_receiver_dev {
+	struct hid_device *hdev;
+	struct dj_device *paired_dj_devices[DJ_MAX_PAIRED_DEVICES +
+					    DJ_DEVICE_INDEX_MIN];
+	struct work_struct work;
+	struct kfifo notif_fifo;
+	spinlock_t lock;
+	bool querying_devices;
+};
+
+struct dj_device {
+	struct hid_device *hdev;
+	struct dj_receiver_dev *dj_receiver_dev;
+	u32 reports_supported;
+	u8 device_index;
+};
 
 /* Keyboard descriptor (1) */
 static const char kbd_descriptor[] = {
diff --git a/drivers/hid/hid-logitech-dj.h b/drivers/hid/hid-logitech-dj.h
deleted file mode 100644
index b1208c9..0000000
--- a/drivers/hid/hid-logitech-dj.h
+++ /dev/null
@@ -1,115 +0,0 @@
-#ifndef __HID_LOGITECH_DJ_H
-#define __HID_LOGITECH_DJ_H
-
-/*
- *  HID driver for Logitech Unifying receivers
- *
- *  Copyright (c) 2011 Logitech
- */
-
-/*
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
- *
- */
-
-#include <linux/kfifo.h>
-
-#define DJ_MAX_PAIRED_DEVICES			6
-#define DJ_MAX_NUMBER_NOTIFICATIONS		8
-#define DJ_RECEIVER_INDEX			0
-#define DJ_DEVICE_INDEX_MIN 			1
-#define DJ_DEVICE_INDEX_MAX 			6
-
-#define DJREPORT_SHORT_LENGTH			15
-#define DJREPORT_LONG_LENGTH			32
-
-#define REPORT_ID_DJ_SHORT			0x20
-#define REPORT_ID_DJ_LONG			0x21
-
-#define REPORT_TYPE_RFREPORT_FIRST		0x01
-#define REPORT_TYPE_RFREPORT_LAST		0x1F
-
-/* Command Switch to DJ mode */
-#define REPORT_TYPE_CMD_SWITCH			0x80
-#define CMD_SWITCH_PARAM_DEVBITFIELD		0x00
-#define CMD_SWITCH_PARAM_TIMEOUT_SECONDS	0x01
-#define TIMEOUT_NO_KEEPALIVE			0x00
-
-/* Command to Get the list of Paired devices */
-#define REPORT_TYPE_CMD_GET_PAIRED_DEVICES	0x81
-
-/* Device Paired Notification */
-#define REPORT_TYPE_NOTIF_DEVICE_PAIRED		0x41
-#define SPFUNCTION_MORE_NOTIF_EXPECTED		0x01
-#define SPFUNCTION_DEVICE_LIST_EMPTY		0x02
-#define DEVICE_PAIRED_PARAM_SPFUNCTION		0x00
-#define DEVICE_PAIRED_PARAM_EQUAD_ID_LSB	0x01
-#define DEVICE_PAIRED_PARAM_EQUAD_ID_MSB	0x02
-#define DEVICE_PAIRED_RF_REPORT_TYPE		0x03
-
-/* Device Un-Paired Notification */
-#define REPORT_TYPE_NOTIF_DEVICE_UNPAIRED	0x40
-
-
-/* Connection Status Notification */
-#define REPORT_TYPE_NOTIF_CONNECTION_STATUS	0x42
-#define CONNECTION_STATUS_PARAM_STATUS		0x00
-#define STATUS_LINKLOSS				0x01
-
-/* Error Notification */
-#define REPORT_TYPE_NOTIF_ERROR			0x7F
-#define NOTIF_ERROR_PARAM_ETYPE			0x00
-#define ETYPE_KEEPALIVE_TIMEOUT			0x01
-
-/* supported DJ HID && RF report types */
-#define REPORT_TYPE_KEYBOARD			0x01
-#define REPORT_TYPE_MOUSE			0x02
-#define REPORT_TYPE_CONSUMER_CONTROL		0x03
-#define REPORT_TYPE_SYSTEM_CONTROL		0x04
-#define REPORT_TYPE_MEDIA_CENTER		0x08
-#define REPORT_TYPE_LEDS			0x0E
-
-/* RF Report types bitfield */
-#define STD_KEYBOARD				0x00000002
-#define STD_MOUSE				0x00000004
-#define MULTIMEDIA				0x00000008
-#define POWER_KEYS				0x00000010
-#define MEDIA_CENTER				0x00000100
-#define KBD_LEDS				0x00004000
-
-struct dj_report {
-	u8 report_id;
-	u8 device_index;
-	u8 report_type;
-	u8 report_params[DJREPORT_SHORT_LENGTH - 3];
-};
-
-struct dj_receiver_dev {
-	struct hid_device *hdev;
-	struct dj_device *paired_dj_devices[DJ_MAX_PAIRED_DEVICES +
-					    DJ_DEVICE_INDEX_MIN];
-	struct work_struct work;
-	struct kfifo notif_fifo;
-	spinlock_t lock;
-	bool querying_devices;
-};
-
-struct dj_device {
-	struct hid_device *hdev;
-	struct dj_receiver_dev *dj_receiver_dev;
-	u32 reports_supported;
-	u8 device_index;
-};
-
-#endif
-- 
2.1.0

