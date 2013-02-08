Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946525Ab3BHOif (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 09:38:35 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:54779 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946442Ab3BHOia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 09:38:30 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] HID: use hid_hw_wait() instead of direct call to usbhid
Date: Fri,  8 Feb 2013 15:37:34 +0100
Message-Id: <1360334256-22127-6-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360334256-22127-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1360334256-22127-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes most of the dependencies between hid drivers and usbhid.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/Kconfig            |  2 +-
 drivers/hid/hid-ntrig.c        |  4 ++--
 drivers/hid/hid-picolcd_fb.c   |  5 ++---
 drivers/hid/hid-sensor-hub.c   |  5 ++---
 drivers/hid/usbhid/hid-core.c  |  3 +--
 drivers/hid/usbhid/hid-pidff.c | 16 ++++++++--------
 drivers/hid/usbhid/hiddev.c    |  4 ++--
 drivers/hid/usbhid/usbhid.h    |  1 -
 8 files changed, 18 insertions(+), 22 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index d60a427..f517d4a 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -479,7 +479,7 @@ config HID_PETALYNX
 
 config HID_PICOLCD
 	tristate "PicoLCD (graphic version)"
-	depends on USB_HID
+	depends on HID
 	---help---
 	  This provides support for Minibox PicoLCD devices, currently
 	  only the graphical ones are supported.
diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
index a722599..e3c2e52 100644
--- a/drivers/hid/hid-ntrig.c
+++ b/drivers/hid/hid-ntrig.c
@@ -119,7 +119,7 @@ static inline int ntrig_get_mode(struct hid_device *hdev)
 		return -EINVAL;
 
 	hid_hw_request(hdev, report, HID_REQ_GET_REPORT);
-	usbhid_wait_io(hdev);
+	hid_hw_wait(hdev);
 	return (int)report->field[0]->value[0];
 }
 
@@ -938,7 +938,7 @@ static int ntrig_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	if (report) {
 		/* Let the device settle to ensure the wakeup message gets
 		 * through */
-		usbhid_wait_io(hdev);
+		hid_hw_wait(hdev);
 		hid_hw_request(hdev, report, HID_REQ_GET_REPORT);
 
 		/*
diff --git a/drivers/hid/hid-picolcd_fb.c b/drivers/hid/hid-picolcd_fb.c
index 98f61de..591f6b2 100644
--- a/drivers/hid/hid-picolcd_fb.c
+++ b/drivers/hid/hid-picolcd_fb.c
@@ -19,7 +19,6 @@
 
 #include <linux/hid.h>
 #include <linux/vmalloc.h>
-#include "usbhid/usbhid.h"
 
 #include <linux/fb.h>
 #include <linux/module.h>
@@ -269,7 +268,7 @@ static void picolcd_fb_update(struct fb_info *info)
 				mutex_unlock(&info->lock);
 				if (!data)
 					return;
-				usbhid_wait_io(data->hdev);
+				hid_hw_wait(data->hdev);
 				mutex_lock(&info->lock);
 				n = 0;
 			}
@@ -287,7 +286,7 @@ static void picolcd_fb_update(struct fb_info *info)
 		spin_unlock_irqrestore(&fbdata->lock, flags);
 		mutex_unlock(&info->lock);
 		if (data)
-			usbhid_wait_io(data->hdev);
+			hid_hw_wait(data->hdev);
 		return;
 	}
 out:
diff --git a/drivers/hid/hid-sensor-hub.c b/drivers/hid/hid-sensor-hub.c
index 569cc07..3731139 100644
--- a/drivers/hid/hid-sensor-hub.c
+++ b/drivers/hid/hid-sensor-hub.c
@@ -18,7 +18,6 @@
  */
 #include <linux/device.h>
 #include <linux/hid.h>
-#include "usbhid/usbhid.h"
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/mfd/core.h>
@@ -204,7 +203,7 @@ int sensor_hub_set_feature(struct hid_sensor_hub_device *hsdev, u32 report_id,
 	}
 	hid_set_field(report->field[field_index], 0, value);
 	hid_hw_request(hsdev->hdev, report, HID_REQ_SET_REPORT);
-	usbhid_wait_io(hsdev->hdev);
+	hid_hw_wait(hsdev->hdev);
 
 done_proc:
 	mutex_unlock(&data->mutex);
@@ -227,7 +226,7 @@ int sensor_hub_get_feature(struct hid_sensor_hub_device *hsdev, u32 report_id,
 		goto done_proc;
 	}
 	hid_hw_request(hsdev->hdev, report, HID_REQ_GET_REPORT);
-	usbhid_wait_io(hsdev->hdev);
+	hid_hw_wait(hsdev->hdev);
 	*value = report->field[field_index]->value[0];
 
 done_proc:
diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index da68687..420466b 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -705,7 +705,7 @@ static int usb_hidinput_input_event(struct input_dev *dev, unsigned int type, un
 	return 0;
 }
 
-int usbhid_wait_io(struct hid_device *hid)
+static int usbhid_wait_io(struct hid_device *hid)
 {
 	struct usbhid_device *usbhid = hid->driver_data;
 
@@ -719,7 +719,6 @@ int usbhid_wait_io(struct hid_device *hid)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(usbhid_wait_io);
 
 static int hid_set_idle(struct usb_device *dev, int ifnum, int report, int idle)
 {
diff --git a/drivers/hid/usbhid/hid-pidff.c b/drivers/hid/usbhid/hid-pidff.c
index 0f1efa3..10b6167 100644
--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -471,13 +471,13 @@ static int pidff_request_effect_upload(struct pidff_device *pidff, int efnum)
 
 	pidff->block_load[PID_EFFECT_BLOCK_INDEX].value[0] = 0;
 	pidff->block_load_status->value[0] = 0;
-	usbhid_wait_io(pidff->hid);
+	hid_hw_wait(pidff->hid);
 
 	for (j = 0; j < 60; j++) {
 		hid_dbg(pidff->hid, "pid_block_load requested\n");
 		hid_hw_request(pidff->hid, pidff->reports[PID_BLOCK_LOAD],
 				HID_REQ_GET_REPORT);
-		usbhid_wait_io(pidff->hid);
+		hid_hw_wait(pidff->hid);
 		if (pidff->block_load_status->value[0] ==
 		    pidff->status_id[PID_BLOCK_LOAD_SUCCESS]) {
 			hid_dbg(pidff->hid, "device reported free memory: %d bytes\n",
@@ -551,7 +551,7 @@ static int pidff_erase_effect(struct input_dev *dev, int effect_id)
 		effect_id, pidff->pid_id[effect_id]);
 	/* Wait for the queue to clear. We do not want a full fifo to
 	   prevent the effect removal. */
-	usbhid_wait_io(pidff->hid);
+	hid_hw_wait(pidff->hid);
 	pidff_playback_pid(pidff, pid_id, 0);
 	pidff_erase_pid(pidff, pid_id);
 
@@ -1159,18 +1159,18 @@ static void pidff_reset(struct pidff_device *pidff)
 	pidff->device_control->value[0] = pidff->control_id[PID_RESET];
 	/* We reset twice as sometimes hid_wait_io isn't waiting long enough */
 	hid_hw_request(hid, pidff->reports[PID_DEVICE_CONTROL], HID_REQ_SET_REPORT);
-	usbhid_wait_io(hid);
+	hid_hw_wait(hid);
 	hid_hw_request(hid, pidff->reports[PID_DEVICE_CONTROL], HID_REQ_SET_REPORT);
-	usbhid_wait_io(hid);
+	hid_hw_wait(hid);
 
 	pidff->device_control->value[0] =
 		pidff->control_id[PID_ENABLE_ACTUATORS];
 	hid_hw_request(hid, pidff->reports[PID_DEVICE_CONTROL], HID_REQ_SET_REPORT);
-	usbhid_wait_io(hid);
+	hid_hw_wait(hid);
 
 	/* pool report is sometimes messed up, refetch it */
 	hid_hw_request(hid, pidff->reports[PID_POOL], HID_REQ_GET_REPORT);
-	usbhid_wait_io(hid);
+	hid_hw_wait(hid);
 
 	if (pidff->pool[PID_SIMULTANEOUS_MAX].value) {
 		while (pidff->pool[PID_SIMULTANEOUS_MAX].value[0] < 2) {
@@ -1183,7 +1183,7 @@ static void pidff_reset(struct pidff_device *pidff)
 			hid_dbg(pidff->hid, "pid_pool requested again\n");
 			hid_hw_request(hid, pidff->reports[PID_POOL],
 					  HID_REQ_GET_REPORT);
-			usbhid_wait_io(hid);
+			hid_hw_wait(hid);
 		}
 	}
 }
diff --git a/drivers/hid/usbhid/hiddev.c b/drivers/hid/usbhid/hiddev.c
index 430d2a9..2f1ddca 100644
--- a/drivers/hid/usbhid/hiddev.c
+++ b/drivers/hid/usbhid/hiddev.c
@@ -706,7 +706,7 @@ static long hiddev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			break;
 
 		hid_hw_request(hid, report, HID_REQ_GET_REPORT);
-		usbhid_wait_io(hid);
+		hid_hw_wait(hid);
 
 		r = 0;
 		break;
@@ -725,7 +725,7 @@ static long hiddev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			break;
 
 		hid_hw_request(hid, report, HID_REQ_SET_REPORT);
-		usbhid_wait_io(hid);
+		hid_hw_wait(hid);
 
 		r = 0;
 		break;
diff --git a/drivers/hid/usbhid/usbhid.h b/drivers/hid/usbhid/usbhid.h
index aa1d5ff..dbb6af6 100644
--- a/drivers/hid/usbhid/usbhid.h
+++ b/drivers/hid/usbhid/usbhid.h
@@ -34,7 +34,6 @@
 #include <linux/input.h>
 
 /*  API provided by hid-core.c for USB HID drivers */
-int usbhid_wait_io(struct hid_device* hid);
 void usbhid_close(struct hid_device *hid);
 int usbhid_open(struct hid_device *hid);
 void usbhid_init_reports(struct hid_device *hid);
-- 
1.8.1

