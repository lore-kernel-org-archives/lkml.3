Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946565Ab3BHOin (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 09:38:43 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:65293 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946442Ab3BHOii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 09:38:38 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] hid: use hid_hw_request() instead of direct call to usbhid
Date: Fri,  8 Feb 2013 15:37:33 +0100
Message-Id: <1360334256-22127-5-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360334256-22127-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1360334256-22127-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows the hid drivers to be independent from the transport layer.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/Kconfig                 | 30 ++++++++---------
 drivers/hid/hid-axff.c              |  6 ++--
 drivers/hid/hid-dr.c                |  8 ++---
 drivers/hid/hid-emsff.c             |  6 ++--
 drivers/hid/hid-gaff.c              | 10 +++---
 drivers/hid/hid-holtekff.c          |  4 +--
 drivers/hid/hid-kye.c               |  4 +--
 drivers/hid/hid-lenovo-tpkbd.c      |  4 +--
 drivers/hid/hid-lg2ff.c             |  6 ++--
 drivers/hid/hid-lg3ff.c             |  6 ++--
 drivers/hid/hid-lg4ff.c             | 18 +++++------
 drivers/hid/hid-lgff.c              |  8 ++---
 drivers/hid/hid-logitech-dj.c       |  3 +-
 drivers/hid/hid-multitouch.c        |  4 +--
 drivers/hid/hid-ntrig.c             |  6 ++--
 drivers/hid/hid-picolcd.h           |  4 +--
 drivers/hid/hid-picolcd_backlight.c |  4 +--
 drivers/hid/hid-picolcd_cir.c       |  2 --
 drivers/hid/hid-picolcd_core.c      |  8 ++---
 drivers/hid/hid-picolcd_debugfs.c   |  2 --
 drivers/hid/hid-picolcd_fb.c        |  7 ++--
 drivers/hid/hid-picolcd_lcd.c       |  4 +--
 drivers/hid/hid-picolcd_leds.c      |  4 +--
 drivers/hid/hid-pl.c                |  6 ++--
 drivers/hid/hid-prodikeys.c         |  3 +-
 drivers/hid/hid-sensor-hub.c        |  7 ++--
 drivers/hid/hid-sjoy.c              |  6 ++--
 drivers/hid/hid-steelseries.c       |  3 +-
 drivers/hid/hid-tmff.c              |  6 ++--
 drivers/hid/hid-zpff.c              |  6 ++--
 drivers/hid/usbhid/hid-core.c       |  3 +-
 drivers/hid/usbhid/hid-pidff.c      | 64 ++++++++++++++++++-------------------
 drivers/hid/usbhid/hiddev.c         |  4 +--
 drivers/hid/usbhid/usbhid.h         |  2 --
 34 files changed, 111 insertions(+), 157 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 581ca9f..d60a427 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -99,7 +99,7 @@ config HID_A4TECH
 
 config HID_ACRUX
 	tristate "ACRUX game controller support"
-	depends on USB_HID
+	depends on HID
 	---help---
 	Say Y here if you want to enable support for ACRUX game controllers.
 
@@ -151,7 +151,7 @@ config HID_CHICONY
 
 config HID_PRODIKEYS
 	tristate "Prodikeys PC-MIDI Keyboard support"
-	depends on USB_HID && SND
+	depends on HID && SND
 	select SND_RAWMIDI
 	---help---
 	Support for Prodikeys PC-MIDI Keyboard device support.
@@ -173,7 +173,7 @@ config HID_CYPRESS
 
 config HID_DRAGONRISE
 	tristate "DragonRise Inc. game controller"
-	depends on USB_HID
+	depends on HID
 	---help---
 	Say Y here if you have DragonRise Inc. game controllers.
 	These might be branded as:
@@ -192,7 +192,7 @@ config DRAGONRISE_FF
 
 config HID_EMS_FF
 	tristate "EMS Production Inc. force feedback support"
-	depends on USB_HID
+	depends on HID
 	select INPUT_FF_MEMLESS
 	---help---
 	Say Y here if you want to enable force feedback support for devices by
@@ -215,7 +215,7 @@ config HID_EZKEY
 
 config HID_HOLTEK
 	tristate "Holtek HID devices"
-	depends on USB_HID
+	depends on HID
 	---help---
 	Support for Holtek based devices:
 	  - Holtek On Line Grip based game controller
@@ -239,7 +239,7 @@ config HID_KEYTOUCH
 
 config HID_KYE
 	tristate "KYE/Genius devices"
-	depends on USB_HID
+	depends on HID
 	---help---
 	Support for KYE/Genius devices not fully compliant with HID standard:
 	- Ergo Mouse
@@ -397,7 +397,7 @@ config HID_MONTEREY
 
 config HID_MULTITOUCH
 	tristate "HID Multitouch panels"
-	depends on USB_HID
+	depends on HID
 	---help---
 	  Generic support for HID multitouch panels.
 
@@ -458,7 +458,7 @@ config HID_ORTEK
 
 config HID_PANTHERLORD
 	tristate "Pantherlord/GreenAsia game controller"
-	depends on USB_HID
+	depends on HID
 	---help---
 	  Say Y here if you have a PantherLord/GreenAsia based game controller
 	  or adapter.
@@ -592,13 +592,13 @@ config HID_SONY
 
 config HID_SPEEDLINK
 	tristate "Speedlink VAD Cezanne mouse support"
-	depends on USB_HID
+	depends on HID
 	---help---
 	Support for Speedlink Vicious and Divine Cezanne mouse.
 
 config HID_STEELSERIES
 	tristate "Steelseries SRW-S1 steering wheel support"
-	depends on USB_HID
+	depends on HID
 	---help---
 	Support for Steelseries SRW-S1 steering wheel
 
@@ -610,7 +610,7 @@ config HID_SUNPLUS
 
 config HID_GREENASIA
 	tristate "GreenAsia (Product ID 0x12) game controller support"
-	depends on USB_HID
+	depends on HID
 	---help---
 	  Say Y here if you have a GreenAsia (Product ID 0x12) based game
 	  controller or adapter.
@@ -632,7 +632,7 @@ config HID_HYPERV_MOUSE
 
 config HID_SMARTJOYPLUS
 	tristate "SmartJoy PLUS PS2/USB adapter support"
-	depends on USB_HID
+	depends on HID
 	---help---
 	Support for SmartJoy PLUS PS2/USB adapter, Super Dual Box,
 	Super Joy Box 3 Pro, Super Dual Box Pro, and Super Joy Box 5 Pro.
@@ -663,7 +663,7 @@ config HID_TOPSEED
 
 config HID_THRUSTMASTER
 	tristate "ThrustMaster devices support"
-	depends on USB_HID
+	depends on HID
 	---help---
 	  Say Y here if you have a THRUSTMASTER FireStore Dual Power 2 or
 	  a THRUSTMASTER Ferrari GT Rumble Wheel.
@@ -705,7 +705,7 @@ config HID_WIIMOTE_EXT
 
 config HID_ZEROPLUS
 	tristate "Zeroplus based game controller support"
-	depends on USB_HID
+	depends on HID
 	---help---
 	  Say Y here if you have a Zeroplus based game controller.
 
@@ -725,7 +725,7 @@ config HID_ZYDACRON
 
 config HID_SENSOR_HUB
 	tristate "HID Sensors framework support"
-	depends on USB_HID && GENERIC_HARDIRQS
+	depends on HID && GENERIC_HARDIRQS
 	select MFD_CORE
 	default n
 	-- help---
diff --git a/drivers/hid/hid-axff.c b/drivers/hid/hid-axff.c
index 62f0cee..64ab94a 100644
--- a/drivers/hid/hid-axff.c
+++ b/drivers/hid/hid-axff.c
@@ -29,14 +29,12 @@
 
 #include <linux/input.h>
 #include <linux/slab.h>
-#include <linux/usb.h>
 #include <linux/hid.h>
 #include <linux/module.h>
 
 #include "hid-ids.h"
 
 #ifdef CONFIG_HID_ACRUX_FF
-#include "usbhid/usbhid.h"
 
 struct axff_device {
 	struct hid_report *report;
@@ -68,7 +66,7 @@ static int axff_play(struct input_dev *dev, void *data, struct ff_effect *effect
 	}
 
 	dbg_hid("running with 0x%02x 0x%02x", left, right);
-	usbhid_submit_report(hid, axff->report, USB_DIR_OUT);
+	hid_hw_request(hid, axff->report, HID_REQ_SET_REPORT);
 
 	return 0;
 }
@@ -114,7 +112,7 @@ static int axff_init(struct hid_device *hid)
 		goto err_free_mem;
 
 	axff->report = report;
-	usbhid_submit_report(hid, axff->report, USB_DIR_OUT);
+	hid_hw_request(hid, axff->report, HID_REQ_SET_REPORT);
 
 	hid_info(hid, "Force Feedback for ACRUX game controllers by Sergei Kolzun <x0r@dv-life.ru>\n");
 
diff --git a/drivers/hid/hid-dr.c b/drivers/hid/hid-dr.c
index 0fe8f65..ce06444 100644
--- a/drivers/hid/hid-dr.c
+++ b/drivers/hid/hid-dr.c
@@ -29,14 +29,12 @@
 
 #include <linux/input.h>
 #include <linux/slab.h>
-#include <linux/usb.h>
 #include <linux/hid.h>
 #include <linux/module.h>
 
 #include "hid-ids.h"
 
 #ifdef CONFIG_DRAGONRISE_FF
-#include "usbhid/usbhid.h"
 
 struct drff_device {
 	struct hid_report *report;
@@ -68,7 +66,7 @@ static int drff_play(struct input_dev *dev, void *data,
 		drff->report->field[0]->value[1] = 0x00;
 		drff->report->field[0]->value[2] = weak;
 		drff->report->field[0]->value[4] = strong;
-		usbhid_submit_report(hid, drff->report, USB_DIR_OUT);
+		hid_hw_request(hid, drff->report, HID_REQ_SET_REPORT);
 
 		drff->report->field[0]->value[0] = 0xfa;
 		drff->report->field[0]->value[1] = 0xfe;
@@ -80,7 +78,7 @@ static int drff_play(struct input_dev *dev, void *data,
 	drff->report->field[0]->value[2] = 0x00;
 	drff->report->field[0]->value[4] = 0x00;
 	dbg_hid("running with 0x%02x 0x%02x", strong, weak);
-	usbhid_submit_report(hid, drff->report, USB_DIR_OUT);
+	hid_hw_request(hid, drff->report, HID_REQ_SET_REPORT);
 
 	return 0;
 }
@@ -132,7 +130,7 @@ static int drff_init(struct hid_device *hid)
 	drff->report->field[0]->value[4] = 0x00;
 	drff->report->field[0]->value[5] = 0x00;
 	drff->report->field[0]->value[6] = 0x00;
-	usbhid_submit_report(hid, drff->report, USB_DIR_OUT);
+	hid_hw_request(hid, drff->report, HID_REQ_SET_REPORT);
 
 	hid_info(hid, "Force Feedback for DragonRise Inc. "
 		 "game controllers by Richard Walmsley <richwalm@gmail.com>\n");
diff --git a/drivers/hid/hid-emsff.c b/drivers/hid/hid-emsff.c
index 2e093ab..d82d75b 100644
--- a/drivers/hid/hid-emsff.c
+++ b/drivers/hid/hid-emsff.c
@@ -23,11 +23,9 @@
 
 #include <linux/hid.h>
 #include <linux/input.h>
-#include <linux/usb.h>
 #include <linux/module.h>
 
 #include "hid-ids.h"
-#include "usbhid/usbhid.h"
 
 struct emsff_device {
 	struct hid_report *report;
@@ -52,7 +50,7 @@ static int emsff_play(struct input_dev *dev, void *data,
 	emsff->report->field[0]->value[2] = strong;
 
 	dbg_hid("running with 0x%02x 0x%02x\n", strong, weak);
-	usbhid_submit_report(hid, emsff->report, USB_DIR_OUT);
+	hid_hw_request(hid, emsff->report, HID_REQ_SET_REPORT);
 
 	return 0;
 }
@@ -104,7 +102,7 @@ static int emsff_init(struct hid_device *hid)
 	emsff->report->field[0]->value[4] = 0x00;
 	emsff->report->field[0]->value[5] = 0x00;
 	emsff->report->field[0]->value[6] = 0x00;
-	usbhid_submit_report(hid, emsff->report, USB_DIR_OUT);
+	hid_hw_request(hid, emsff->report, HID_REQ_SET_REPORT);
 
 	hid_info(hid, "force feedback for EMS based devices by Ignaz Forster <ignaz.forster@gmx.de>\n");
 
diff --git a/drivers/hid/hid-gaff.c b/drivers/hid/hid-gaff.c
index 04d2e6a..2d8cead 100644
--- a/drivers/hid/hid-gaff.c
+++ b/drivers/hid/hid-gaff.c
@@ -29,13 +29,11 @@
 
 #include <linux/input.h>
 #include <linux/slab.h>
-#include <linux/usb.h>
 #include <linux/hid.h>
 #include <linux/module.h>
 #include "hid-ids.h"
 
 #ifdef CONFIG_GREENASIA_FF
-#include "usbhid/usbhid.h"
 
 struct gaff_device {
 	struct hid_report *report;
@@ -63,14 +61,14 @@ static int hid_gaff_play(struct input_dev *dev, void *data,
 	gaff->report->field[0]->value[4] = left;
 	gaff->report->field[0]->value[5] = 0;
 	dbg_hid("running with 0x%02x 0x%02x", left, right);
-	usbhid_submit_report(hid, gaff->report, USB_DIR_OUT);
+	hid_hw_request(hid, gaff->report, HID_REQ_SET_REPORT);
 
 	gaff->report->field[0]->value[0] = 0xfa;
 	gaff->report->field[0]->value[1] = 0xfe;
 	gaff->report->field[0]->value[2] = 0x0;
 	gaff->report->field[0]->value[4] = 0x0;
 
-	usbhid_submit_report(hid, gaff->report, USB_DIR_OUT);
+	hid_hw_request(hid, gaff->report, HID_REQ_SET_REPORT);
 
 	return 0;
 }
@@ -122,12 +120,12 @@ static int gaff_init(struct hid_device *hid)
 	gaff->report->field[0]->value[1] = 0x00;
 	gaff->report->field[0]->value[2] = 0x00;
 	gaff->report->field[0]->value[3] = 0x00;
-	usbhid_submit_report(hid, gaff->report, USB_DIR_OUT);
+	hid_hw_request(hid, gaff->report, HID_REQ_SET_REPORT);
 
 	gaff->report->field[0]->value[0] = 0xfa;
 	gaff->report->field[0]->value[1] = 0xfe;
 
-	usbhid_submit_report(hid, gaff->report, USB_DIR_OUT);
+	hid_hw_request(hid, gaff->report, HID_REQ_SET_REPORT);
 
 	hid_info(hid, "Force Feedback for GreenAsia 0x12 devices by Lukasz Lubojanski <lukasz@lubojanski.info>\n");
 
diff --git a/drivers/hid/hid-holtekff.c b/drivers/hid/hid-holtekff.c
index f34d118..9a8f051 100644
--- a/drivers/hid/hid-holtekff.c
+++ b/drivers/hid/hid-holtekff.c
@@ -27,12 +27,10 @@
 #include <linux/input.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/usb.h>
 
 #include "hid-ids.h"
 
 #ifdef CONFIG_HOLTEK_FF
-#include "usbhid/usbhid.h"
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Anssi Hannula <anssi.hannula@iki.fi>");
@@ -102,7 +100,7 @@ static void holtekff_send(struct holtekff_device *holtekff,
 
 	dbg_hid("sending %*ph\n", 7, data);
 
-	usbhid_submit_report(hid, holtekff->field->report, USB_DIR_OUT);
+	hid_hw_request(hid, holtekff->field->report, HID_REQ_SET_REPORT);
 }
 
 static int holtekff_play(struct input_dev *dev, void *data,
diff --git a/drivers/hid/hid-kye.c b/drivers/hid/hid-kye.c
index ef72dae..6af90db 100644
--- a/drivers/hid/hid-kye.c
+++ b/drivers/hid/hid-kye.c
@@ -16,8 +16,6 @@
 #include <linux/device.h>
 #include <linux/hid.h>
 #include <linux/module.h>
-#include <linux/usb.h>
-#include "usbhid/usbhid.h"
 
 #include "hid-ids.h"
 
@@ -361,7 +359,7 @@ static int kye_tablet_enable(struct hid_device *hdev)
 	value[4] = 0x00;
 	value[5] = 0x00;
 	value[6] = 0x00;
-	usbhid_submit_report(hdev, report, USB_DIR_OUT);
+	hid_hw_request(hdev, report, HID_REQ_SET_REPORT);
 
 	return 0;
 }
diff --git a/drivers/hid/hid-lenovo-tpkbd.c b/drivers/hid/hid-lenovo-tpkbd.c
index 956c3b1..a0535fd 100644
--- a/drivers/hid/hid-lenovo-tpkbd.c
+++ b/drivers/hid/hid-lenovo-tpkbd.c
@@ -68,7 +68,7 @@ static int tpkbd_features_set(struct hid_device *hdev)
 	report->field[2]->value[0] = data_pointer->sensitivity;
 	report->field[3]->value[0] = data_pointer->press_speed;
 
-	usbhid_submit_report(hdev, report, USB_DIR_OUT);
+	hid_hw_request(hdev, report, HID_REQ_SET_REPORT);
 	return 0;
 }
 
@@ -332,7 +332,7 @@ static void tpkbd_led_brightness_set(struct led_classdev *led_cdev,
 	report = hdev->report_enum[HID_OUTPUT_REPORT].report_id_hash[3];
 	report->field[0]->value[0] = (data_pointer->led_state >> 0) & 1;
 	report->field[0]->value[1] = (data_pointer->led_state >> 1) & 1;
-	usbhid_submit_report(hdev, report, USB_DIR_OUT);
+	hid_hw_request(hdev, report, HID_REQ_SET_REPORT);
 }
 
 static int tpkbd_probe_tp(struct hid_device *hdev)
diff --git a/drivers/hid/hid-lg2ff.c b/drivers/hid/hid-lg2ff.c
index 3c31bc6..b3cd150 100644
--- a/drivers/hid/hid-lg2ff.c
+++ b/drivers/hid/hid-lg2ff.c
@@ -23,10 +23,8 @@
 
 #include <linux/input.h>
 #include <linux/slab.h>
-#include <linux/usb.h>
 #include <linux/hid.h>
 
-#include "usbhid/usbhid.h"
 #include "hid-lg.h"
 
 struct lg2ff_device {
@@ -56,7 +54,7 @@ static int play_effect(struct input_dev *dev, void *data,
 		lg2ff->report->field[0]->value[4] = 0x00;
 	}
 
-	usbhid_submit_report(hid, lg2ff->report, USB_DIR_OUT);
+	hid_hw_request(hid, lg2ff->report, HID_REQ_SET_REPORT);
 	return 0;
 }
 
@@ -108,7 +106,7 @@ int lg2ff_init(struct hid_device *hid)
 	report->field[0]->value[5] = 0x00;
 	report->field[0]->value[6] = 0x00;
 
-	usbhid_submit_report(hid, report, USB_DIR_OUT);
+	hid_hw_request(hid, report, HID_REQ_SET_REPORT);
 
 	hid_info(hid, "Force feedback for Logitech RumblePad/Rumblepad 2 by Anssi Hannula <anssi.hannula@gmail.com>\n");
 
diff --git a/drivers/hid/hid-lg3ff.c b/drivers/hid/hid-lg3ff.c
index f98644c..e52f181 100644
--- a/drivers/hid/hid-lg3ff.c
+++ b/drivers/hid/hid-lg3ff.c
@@ -22,10 +22,8 @@
 
 
 #include <linux/input.h>
-#include <linux/usb.h>
 #include <linux/hid.h>
 
-#include "usbhid/usbhid.h"
 #include "hid-lg.h"
 
 /*
@@ -92,7 +90,7 @@ static int hid_lg3ff_play(struct input_dev *dev, void *data,
 		report->field[0]->value[1] = (unsigned char)(-x);
 		report->field[0]->value[31] = (unsigned char)(-y);
 
-		usbhid_submit_report(hid, report, USB_DIR_OUT);
+		hid_hw_request(hid, report, HID_REQ_SET_REPORT);
 		break;
 	}
 	return 0;
@@ -118,7 +116,7 @@ static void hid_lg3ff_set_autocenter(struct input_dev *dev, u16 magnitude)
 	report->field[0]->value[33] = 0x7F;
 	report->field[0]->value[34] = 0x7F;
 
-	usbhid_submit_report(hid, report, USB_DIR_OUT);
+	hid_hw_request(hid, report, HID_REQ_SET_REPORT);
 }
 
 
diff --git a/drivers/hid/hid-lg4ff.c b/drivers/hid/hid-lg4ff.c
index d7947c7..727d920 100644
--- a/drivers/hid/hid-lg4ff.c
+++ b/drivers/hid/hid-lg4ff.c
@@ -207,7 +207,7 @@ static int hid_lg4ff_play(struct input_dev *dev, void *data, struct ff_effect *e
 		value[5] = 0x00;
 		value[6] = 0x00;
 
-		usbhid_submit_report(hid, report, USB_DIR_OUT);
+		hid_hw_request(hid, report, HID_REQ_SET_REPORT);
 		break;
 	}
 	return 0;
@@ -230,7 +230,7 @@ static void hid_lg4ff_set_autocenter_default(struct input_dev *dev, u16 magnitud
 	value[5] = 0x00;
 	value[6] = 0x00;
 
-	usbhid_submit_report(hid, report, USB_DIR_OUT);
+	hid_hw_request(hid, report, HID_REQ_SET_REPORT);
 }
 
 /* Sends autocentering command compatible with Formula Force EX */
@@ -250,7 +250,7 @@ static void hid_lg4ff_set_autocenter_ffex(struct input_dev *dev, u16 magnitude)
 	value[5] = 0x00;
 	value[6] = 0x00;
 
-	usbhid_submit_report(hid, report, USB_DIR_OUT);
+	hid_hw_request(hid, report, HID_REQ_SET_REPORT);
 }
 
 /* Sends command to set range compatible with G25/G27/Driving Force GT */
@@ -270,7 +270,7 @@ static void hid_lg4ff_set_range_g25(struct hid_device *hid, u16 range)
 	value[5] = 0x00;
 	value[6] = 0x00;
 
-	usbhid_submit_report(hid, report, USB_DIR_OUT);
+	hid_hw_request(hid, report, HID_REQ_SET_REPORT);
 }
 
 /* Sends commands to set range compatible with Driving Force Pro wheel */
@@ -299,7 +299,7 @@ static void hid_lg4ff_set_range_dfp(struct hid_device *hid, __u16 range)
 		report->field[0]->value[1] = 0x02;
 		full_range = 200;
 	}
-	usbhid_submit_report(hid, report, USB_DIR_OUT);
+	hid_hw_request(hid, report, HID_REQ_SET_REPORT);
 
 	/* Prepare "fine" limit command */
 	value[0] = 0x81;
@@ -311,7 +311,7 @@ static void hid_lg4ff_set_range_dfp(struct hid_device *hid, __u16 range)
 	value[6] = 0x00;
 
 	if (range == 200 || range == 900) {	/* Do not apply any fine limit */
-		usbhid_submit_report(hid, report, USB_DIR_OUT);
+		hid_hw_request(hid, report, HID_REQ_SET_REPORT);
 		return;
 	}
 
@@ -325,7 +325,7 @@ static void hid_lg4ff_set_range_dfp(struct hid_device *hid, __u16 range)
 	value[5] = (start_right & 0xe) << 4 | (start_left & 0xe);
 	value[6] = 0xff;
 
-	usbhid_submit_report(hid, report, USB_DIR_OUT);
+	hid_hw_request(hid, report, HID_REQ_SET_REPORT);
 }
 
 static void hid_lg4ff_switch_native(struct hid_device *hid, const struct lg4ff_native_cmd *cmd)
@@ -339,7 +339,7 @@ static void hid_lg4ff_switch_native(struct hid_device *hid, const struct lg4ff_n
 		for (i = 0; i < 7; i++)
 			report->field[0]->value[i] = cmd->cmd[j++];
 
-		usbhid_submit_report(hid, report, USB_DIR_OUT);
+		hid_hw_request(hid, report, HID_REQ_SET_REPORT);
 	}
 }
 
@@ -415,7 +415,7 @@ static void lg4ff_set_leds(struct hid_device *hid, __u8 leds)
 	value[4] = 0x00;
 	value[5] = 0x00;
 	value[6] = 0x00;
-	usbhid_submit_report(hid, report, USB_DIR_OUT);
+	hid_hw_request(hid, report, HID_REQ_SET_REPORT);
 }
 
 static void lg4ff_led_set_brightness(struct led_classdev *led_cdev,
diff --git a/drivers/hid/hid-lgff.c b/drivers/hid/hid-lgff.c
index 27bc54f..d7ea8c8 100644
--- a/drivers/hid/hid-lgff.c
+++ b/drivers/hid/hid-lgff.c
@@ -30,10 +30,8 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/input.h>
-#include <linux/usb.h>
 #include <linux/hid.h>
 
-#include "usbhid/usbhid.h"
 #include "hid-lg.h"
 
 struct dev_type {
@@ -89,7 +87,7 @@ static int hid_lgff_play(struct input_dev *dev, void *data, struct ff_effect *ef
 		report->field[0]->value[2] = x;
 		report->field[0]->value[3] = y;
 		dbg_hid("(x, y)=(%04x, %04x)\n", x, y);
-		usbhid_submit_report(hid, report, USB_DIR_OUT);
+		hid_hw_request(hid, report, HID_REQ_SET_REPORT);
 		break;
 
 	case FF_RUMBLE:
@@ -104,7 +102,7 @@ static int hid_lgff_play(struct input_dev *dev, void *data, struct ff_effect *ef
 		report->field[0]->value[2] = left;
 		report->field[0]->value[3] = right;
 		dbg_hid("(left, right)=(%04x, %04x)\n", left, right);
-		usbhid_submit_report(hid, report, USB_DIR_OUT);
+		hid_hw_request(hid, report, HID_REQ_SET_REPORT);
 		break;
 	}
 	return 0;
@@ -124,7 +122,7 @@ static void hid_lgff_set_autocenter(struct input_dev *dev, u16 magnitude)
 	*value++ = 0x80;
 	*value++ = 0x00;
 	*value = 0x00;
-	usbhid_submit_report(hid, report, USB_DIR_OUT);
+	hid_hw_request(hid, report, HID_REQ_SET_REPORT);
 }
 
 int lgff_init(struct hid_device* hid)
diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index 9500f2f..3cf62be 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -27,7 +27,6 @@
 #include <linux/module.h>
 #include <linux/usb.h>
 #include <asm/unaligned.h>
-#include "usbhid/usbhid.h"
 #include "hid-ids.h"
 #include "hid-logitech-dj.h"
 
@@ -638,7 +637,7 @@ static int logi_dj_ll_input_event(struct input_dev *dev, unsigned int type,
 	hid_set_field(report->field[0], 1, REPORT_TYPE_LEDS);
 	hid_set_field(report->field[0], 2, data[1]);
 
-	usbhid_submit_report(dj_rcv_hiddev, report, USB_DIR_OUT);
+	hid_hw_request(dj_rcv_hiddev, report, HID_REQ_SET_REPORT);
 
 	return 0;
 
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 7a1ebb8..32258ba 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -736,7 +736,7 @@ static void mt_set_input_mode(struct hid_device *hdev)
 	r = re->report_id_hash[td->inputmode];
 	if (r) {
 		r->field[0]->value[td->inputmode_index] = 0x02;
-		usbhid_submit_report(hdev, r, USB_DIR_OUT);
+		hid_hw_request(hdev, r, HID_REQ_SET_REPORT);
 	}
 }
 
@@ -761,7 +761,7 @@ static void mt_set_maxcontacts(struct hid_device *hdev)
 		max = min(fieldmax, max);
 		if (r->field[0]->value[0] != max) {
 			r->field[0]->value[0] = max;
-			usbhid_submit_report(hdev, r, USB_DIR_OUT);
+			hid_hw_request(hdev, r, HID_REQ_SET_REPORT);
 		}
 	}
 }
diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
index 2ffc0e3..a722599 100644
--- a/drivers/hid/hid-ntrig.c
+++ b/drivers/hid/hid-ntrig.c
@@ -118,7 +118,7 @@ static inline int ntrig_get_mode(struct hid_device *hdev)
 	if (!report)
 		return -EINVAL;
 
-	usbhid_submit_report(hdev, report, USB_DIR_IN);
+	hid_hw_request(hdev, report, HID_REQ_GET_REPORT);
 	usbhid_wait_io(hdev);
 	return (int)report->field[0]->value[0];
 }
@@ -137,7 +137,7 @@ static inline void ntrig_set_mode(struct hid_device *hdev, const int mode)
 	if (!report)
 		return;
 
-	usbhid_submit_report(hdev, report, USB_DIR_IN);
+	hid_hw_request(hdev, report, HID_REQ_GET_REPORT);
 }
 
 static void ntrig_report_version(struct hid_device *hdev)
@@ -939,7 +939,7 @@ static int ntrig_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		/* Let the device settle to ensure the wakeup message gets
 		 * through */
 		usbhid_wait_io(hdev);
-		usbhid_submit_report(hdev, report, USB_DIR_IN);
+		hid_hw_request(hdev, report, HID_REQ_GET_REPORT);
 
 		/*
 		 * Sanity check: if the current mode is invalid reset it to
diff --git a/drivers/hid/hid-picolcd.h b/drivers/hid/hid-picolcd.h
index 020cef6..2941891 100644
--- a/drivers/hid/hid-picolcd.h
+++ b/drivers/hid/hid-picolcd.h
@@ -142,10 +142,10 @@ struct hid_report *picolcd_report(int id, struct hid_device *hdev, int dir);
 #ifdef CONFIG_DEBUG_FS
 void picolcd_debug_out_report(struct picolcd_data *data,
 		struct hid_device *hdev, struct hid_report *report);
-#define usbhid_submit_report(a, b, c) \
+#define hid_hw_request(a, b, c) \
 	do { \
 		picolcd_debug_out_report(hid_get_drvdata(a), a, b); \
-		usbhid_submit_report(a, b, c); \
+		hid_hw_request(a, b, c); \
 	} while (0)
 
 void picolcd_debug_raw_event(struct picolcd_data *data,
diff --git a/drivers/hid/hid-picolcd_backlight.c b/drivers/hid/hid-picolcd_backlight.c
index b91f309..a32c5f8 100644
--- a/drivers/hid/hid-picolcd_backlight.c
+++ b/drivers/hid/hid-picolcd_backlight.c
@@ -18,8 +18,6 @@
  ***************************************************************************/
 
 #include <linux/hid.h>
-#include "usbhid/usbhid.h"
-#include <linux/usb.h>
 
 #include <linux/fb.h>
 #include <linux/backlight.h>
@@ -46,7 +44,7 @@ static int picolcd_set_brightness(struct backlight_device *bdev)
 	spin_lock_irqsave(&data->lock, flags);
 	hid_set_field(report->field[0], 0, data->lcd_power == FB_BLANK_UNBLANK ? data->lcd_brightness : 0);
 	if (!(data->status & PICOLCD_FAILED))
-		usbhid_submit_report(data->hdev, report, USB_DIR_OUT);
+		hid_hw_request(data->hdev, report, HID_REQ_SET_REPORT);
 	spin_unlock_irqrestore(&data->lock, flags);
 	return 0;
 }
diff --git a/drivers/hid/hid-picolcd_cir.c b/drivers/hid/hid-picolcd_cir.c
index a79e95b..e346038 100644
--- a/drivers/hid/hid-picolcd_cir.c
+++ b/drivers/hid/hid-picolcd_cir.c
@@ -21,8 +21,6 @@
 #include <linux/hid-debug.h>
 #include <linux/input.h>
 #include "hid-ids.h"
-#include "usbhid/usbhid.h"
-#include <linux/usb.h>
 
 #include <linux/fb.h>
 #include <linux/vmalloc.h>
diff --git a/drivers/hid/hid-picolcd_core.c b/drivers/hid/hid-picolcd_core.c
index 31cd93f..b48092d 100644
--- a/drivers/hid/hid-picolcd_core.c
+++ b/drivers/hid/hid-picolcd_core.c
@@ -21,8 +21,6 @@
 #include <linux/hid-debug.h>
 #include <linux/input.h>
 #include "hid-ids.h"
-#include "usbhid/usbhid.h"
-#include <linux/usb.h>
 
 #include <linux/fb.h>
 #include <linux/vmalloc.h>
@@ -110,7 +108,7 @@ struct picolcd_pending *picolcd_send_and_wait(struct hid_device *hdev,
 		work = NULL;
 	} else {
 		data->pending = work;
-		usbhid_submit_report(data->hdev, report, USB_DIR_OUT);
+		hid_hw_request(data->hdev, report, HID_REQ_SET_REPORT);
 		spin_unlock_irqrestore(&data->lock, flags);
 		wait_for_completion_interruptible_timeout(&work->ready, HZ*2);
 		spin_lock_irqsave(&data->lock, flags);
@@ -244,7 +242,7 @@ int picolcd_reset(struct hid_device *hdev)
 		spin_unlock_irqrestore(&data->lock, flags);
 		return -ENODEV;
 	}
-	usbhid_submit_report(hdev, report, USB_DIR_OUT);
+	hid_hw_request(hdev, report, HID_REQ_SET_REPORT);
 	spin_unlock_irqrestore(&data->lock, flags);
 
 	error = picolcd_check_version(hdev);
@@ -303,7 +301,7 @@ static ssize_t picolcd_operation_mode_store(struct device *dev,
 	spin_lock_irqsave(&data->lock, flags);
 	hid_set_field(report->field[0], 0, timeout & 0xff);
 	hid_set_field(report->field[0], 1, (timeout >> 8) & 0xff);
-	usbhid_submit_report(data->hdev, report, USB_DIR_OUT);
+	hid_hw_request(data->hdev, report, HID_REQ_SET_REPORT);
 	spin_unlock_irqrestore(&data->lock, flags);
 	return count;
 }
diff --git a/drivers/hid/hid-picolcd_debugfs.c b/drivers/hid/hid-picolcd_debugfs.c
index 4809aa1..59ab8e1 100644
--- a/drivers/hid/hid-picolcd_debugfs.c
+++ b/drivers/hid/hid-picolcd_debugfs.c
@@ -19,8 +19,6 @@
 
 #include <linux/hid.h>
 #include <linux/hid-debug.h>
-#include "usbhid/usbhid.h"
-#include <linux/usb.h>
 
 #include <linux/fb.h>
 #include <linux/seq_file.h>
diff --git a/drivers/hid/hid-picolcd_fb.c b/drivers/hid/hid-picolcd_fb.c
index eb00357..98f61de 100644
--- a/drivers/hid/hid-picolcd_fb.c
+++ b/drivers/hid/hid-picolcd_fb.c
@@ -20,7 +20,6 @@
 #include <linux/hid.h>
 #include <linux/vmalloc.h>
 #include "usbhid/usbhid.h"
-#include <linux/usb.h>
 
 #include <linux/fb.h>
 #include <linux/module.h>
@@ -143,8 +142,8 @@ static int picolcd_fb_send_tile(struct picolcd_data *data, u8 *vbitmap,
 		else
 			hid_set_field(report2->field[0], 4 + i - 32, tdata[i]);
 
-	usbhid_submit_report(data->hdev, report1, USB_DIR_OUT);
-	usbhid_submit_report(data->hdev, report2, USB_DIR_OUT);
+	hid_hw_request(data->hdev, report1, HID_REQ_SET_REPORT);
+	hid_hw_request(data->hdev, report2, HID_REQ_SET_REPORT);
 	spin_unlock_irqrestore(&data->lock, flags);
 	return 0;
 }
@@ -214,7 +213,7 @@ int picolcd_fb_reset(struct picolcd_data *data, int clear)
 				hid_set_field(report->field[0], j, mapcmd[j]);
 			else
 				hid_set_field(report->field[0], j, 0);
-		usbhid_submit_report(data->hdev, report, USB_DIR_OUT);
+		hid_hw_request(data->hdev, report, HID_REQ_SET_REPORT);
 	}
 	spin_unlock_irqrestore(&data->lock, flags);
 
diff --git a/drivers/hid/hid-picolcd_lcd.c b/drivers/hid/hid-picolcd_lcd.c
index 2d0ddc5..89821c2 100644
--- a/drivers/hid/hid-picolcd_lcd.c
+++ b/drivers/hid/hid-picolcd_lcd.c
@@ -18,8 +18,6 @@
  ***************************************************************************/
 
 #include <linux/hid.h>
-#include "usbhid/usbhid.h"
-#include <linux/usb.h>
 
 #include <linux/fb.h>
 #include <linux/lcd.h>
@@ -48,7 +46,7 @@ static int picolcd_set_contrast(struct lcd_device *ldev, int contrast)
 	spin_lock_irqsave(&data->lock, flags);
 	hid_set_field(report->field[0], 0, data->lcd_contrast);
 	if (!(data->status & PICOLCD_FAILED))
-		usbhid_submit_report(data->hdev, report, USB_DIR_OUT);
+		hid_hw_request(data->hdev, report, HID_REQ_SET_REPORT);
 	spin_unlock_irqrestore(&data->lock, flags);
 	return 0;
 }
diff --git a/drivers/hid/hid-picolcd_leds.c b/drivers/hid/hid-picolcd_leds.c
index 28cb6a4..e994f9c 100644
--- a/drivers/hid/hid-picolcd_leds.c
+++ b/drivers/hid/hid-picolcd_leds.c
@@ -21,8 +21,6 @@
 #include <linux/hid-debug.h>
 #include <linux/input.h>
 #include "hid-ids.h"
-#include "usbhid/usbhid.h"
-#include <linux/usb.h>
 
 #include <linux/fb.h>
 #include <linux/vmalloc.h>
@@ -55,7 +53,7 @@ void picolcd_leds_set(struct picolcd_data *data)
 	spin_lock_irqsave(&data->lock, flags);
 	hid_set_field(report->field[0], 0, data->led_state);
 	if (!(data->status & PICOLCD_FAILED))
-		usbhid_submit_report(data->hdev, report, USB_DIR_OUT);
+		hid_hw_request(data->hdev, report, HID_REQ_SET_REPORT);
 	spin_unlock_irqrestore(&data->lock, flags);
 }
 
diff --git a/drivers/hid/hid-pl.c b/drivers/hid/hid-pl.c
index b0199d2..d29112f 100644
--- a/drivers/hid/hid-pl.c
+++ b/drivers/hid/hid-pl.c
@@ -43,13 +43,11 @@
 #include <linux/input.h>
 #include <linux/slab.h>
 #include <linux/module.h>
-#include <linux/usb.h>
 #include <linux/hid.h>
 
 #include "hid-ids.h"
 
 #ifdef CONFIG_PANTHERLORD_FF
-#include "usbhid/usbhid.h"
 
 struct plff_device {
 	struct hid_report *report;
@@ -75,7 +73,7 @@ static int hid_plff_play(struct input_dev *dev, void *data,
 	*plff->strong = left;
 	*plff->weak = right;
 	debug("running with 0x%02x 0x%02x", left, right);
-	usbhid_submit_report(hid, plff->report, USB_DIR_OUT);
+	hid_hw_request(hid, plff->report, HID_REQ_SET_REPORT);
 
 	return 0;
 }
@@ -169,7 +167,7 @@ static int plff_init(struct hid_device *hid)
 
 		*strong = 0x00;
 		*weak = 0x00;
-		usbhid_submit_report(hid, plff->report, USB_DIR_OUT);
+		hid_hw_request(hid, plff->report, HID_REQ_SET_REPORT);
 	}
 
 	hid_info(hid, "Force feedback for PantherLord/GreenAsia devices by Anssi Hannula <anssi.hannula@gmail.com>\n");
diff --git a/drivers/hid/hid-prodikeys.c b/drivers/hid/hid-prodikeys.c
index 4e1c4bc..7ed8280 100644
--- a/drivers/hid/hid-prodikeys.c
+++ b/drivers/hid/hid-prodikeys.c
@@ -26,7 +26,6 @@
 #include <sound/core.h>
 #include <sound/initval.h>
 #include <sound/rawmidi.h>
-#include "usbhid/usbhid.h"
 #include "hid-ids.h"
 
 
@@ -306,7 +305,7 @@ static void pcmidi_submit_output_report(struct pcmidi_snd *pm, int state)
 	report->field[0]->value[0] = 0x01;
 	report->field[0]->value[1] = state;
 
-	usbhid_submit_report(hdev, report, USB_DIR_OUT);
+	hid_hw_request(hdev, report, HID_REQ_SET_REPORT);
 }
 
 static int pcmidi_handle_report1(struct pcmidi_snd *pm, u8 *data)
diff --git a/drivers/hid/hid-sensor-hub.c b/drivers/hid/hid-sensor-hub.c
index 4179f5e..569cc07 100644
--- a/drivers/hid/hid-sensor-hub.c
+++ b/drivers/hid/hid-sensor-hub.c
@@ -18,7 +18,6 @@
  */
 #include <linux/device.h>
 #include <linux/hid.h>
-#include <linux/usb.h>
 #include "usbhid/usbhid.h"
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -204,7 +203,7 @@ int sensor_hub_set_feature(struct hid_sensor_hub_device *hsdev, u32 report_id,
 		goto done_proc;
 	}
 	hid_set_field(report->field[field_index], 0, value);
-	usbhid_submit_report(hsdev->hdev, report, USB_DIR_OUT);
+	hid_hw_request(hsdev->hdev, report, HID_REQ_SET_REPORT);
 	usbhid_wait_io(hsdev->hdev);
 
 done_proc:
@@ -227,7 +226,7 @@ int sensor_hub_get_feature(struct hid_sensor_hub_device *hsdev, u32 report_id,
 		ret = -EINVAL;
 		goto done_proc;
 	}
-	usbhid_submit_report(hsdev->hdev, report, USB_DIR_IN);
+	hid_hw_request(hsdev->hdev, report, HID_REQ_GET_REPORT);
 	usbhid_wait_io(hsdev->hdev);
 	*value = report->field[field_index]->value[0];
 
@@ -262,7 +261,7 @@ int sensor_hub_input_attr_get_raw_value(struct hid_sensor_hub_device *hsdev,
 		spin_unlock_irqrestore(&data->lock, flags);
 		goto err_free;
 	}
-	usbhid_submit_report(hsdev->hdev, report, USB_DIR_IN);
+	hid_hw_request(hsdev->hdev, report, HID_REQ_GET_REPORT);
 	spin_unlock_irqrestore(&data->lock, flags);
 	wait_for_completion_interruptible_timeout(&data->pending.ready, HZ*5);
 	switch (data->pending.raw_size) {
diff --git a/drivers/hid/hid-sjoy.c b/drivers/hid/hid-sjoy.c
index 28f7740..37845ec 100644
--- a/drivers/hid/hid-sjoy.c
+++ b/drivers/hid/hid-sjoy.c
@@ -28,13 +28,11 @@
 
 #include <linux/input.h>
 #include <linux/slab.h>
-#include <linux/usb.h>
 #include <linux/hid.h>
 #include <linux/module.h>
 #include "hid-ids.h"
 
 #ifdef CONFIG_SMARTJOYPLUS_FF
-#include "usbhid/usbhid.h"
 
 struct sjoyff_device {
 	struct hid_report *report;
@@ -57,7 +55,7 @@ static int hid_sjoyff_play(struct input_dev *dev, void *data,
 	sjoyff->report->field[0]->value[1] = right;
 	sjoyff->report->field[0]->value[2] = left;
 	dev_dbg(&dev->dev, "running with 0x%02x 0x%02x\n", left, right);
-	usbhid_submit_report(hid, sjoyff->report, USB_DIR_OUT);
+	hid_hw_request(hid, sjoyff->report, HID_REQ_SET_REPORT);
 
 	return 0;
 }
@@ -115,7 +113,7 @@ static int sjoyff_init(struct hid_device *hid)
 		sjoyff->report->field[0]->value[0] = 0x01;
 		sjoyff->report->field[0]->value[1] = 0x00;
 		sjoyff->report->field[0]->value[2] = 0x00;
-		usbhid_submit_report(hid, sjoyff->report, USB_DIR_OUT);
+		hid_hw_request(hid, sjoyff->report, HID_REQ_SET_REPORT);
 	}
 
 	hid_info(hid, "Force feedback for SmartJoy PLUS PS2/USB adapter\n");
diff --git a/drivers/hid/hid-steelseries.c b/drivers/hid/hid-steelseries.c
index 2ed995c..98e66ac 100644
--- a/drivers/hid/hid-steelseries.c
+++ b/drivers/hid/hid-steelseries.c
@@ -16,7 +16,6 @@
 #include <linux/hid.h>
 #include <linux/module.h>
 
-#include "usbhid/usbhid.h"
 #include "hid-ids.h"
 
 #if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
@@ -132,7 +131,7 @@ static void steelseries_srws1_set_leds(struct hid_device *hdev, __u16 leds)
 	value[14] = 0x00;
 	value[15] = 0x00;
 
-	usbhid_submit_report(hdev, report, USB_DIR_OUT);
+	hid_hw_request(hdev, report, HID_REQ_SET_REPORT);
 
 	/* Note: LED change does not show on device until the device is read/polled */
 }
diff --git a/drivers/hid/hid-tmff.c b/drivers/hid/hid-tmff.c
index e4fcf3f..b833760 100644
--- a/drivers/hid/hid-tmff.c
+++ b/drivers/hid/hid-tmff.c
@@ -30,7 +30,6 @@
 #include <linux/hid.h>
 #include <linux/input.h>
 #include <linux/slab.h>
-#include <linux/usb.h>
 #include <linux/module.h>
 
 #include "hid-ids.h"
@@ -46,7 +45,6 @@ static const signed short ff_joystick[] = {
 };
 
 #ifdef CONFIG_THRUSTMASTER_FF
-#include "usbhid/usbhid.h"
 
 /* Usages for thrustmaster devices I know about */
 #define THRUSTMASTER_USAGE_FF	(HID_UP_GENDESK | 0xbb)
@@ -103,7 +101,7 @@ static int tmff_play(struct input_dev *dev, void *data,
 		dbg_hid("(x, y)=(%04x, %04x)\n", x, y);
 		ff_field->value[0] = x;
 		ff_field->value[1] = y;
-		usbhid_submit_report(hid, tmff->report, USB_DIR_OUT);
+		hid_hw_request(hid, tmff->report, HID_REQ_SET_REPORT);
 		break;
 
 	case FF_RUMBLE:
@@ -117,7 +115,7 @@ static int tmff_play(struct input_dev *dev, void *data,
 		dbg_hid("(left,right)=(%08x, %08x)\n", left, right);
 		ff_field->value[0] = left;
 		ff_field->value[1] = right;
-		usbhid_submit_report(hid, tmff->report, USB_DIR_OUT);
+		hid_hw_request(hid, tmff->report, HID_REQ_SET_REPORT);
 		break;
 	}
 	return 0;
diff --git a/drivers/hid/hid-zpff.c b/drivers/hid/hid-zpff.c
index af66452..6ec28a3 100644
--- a/drivers/hid/hid-zpff.c
+++ b/drivers/hid/hid-zpff.c
@@ -24,13 +24,11 @@
 #include <linux/hid.h>
 #include <linux/input.h>
 #include <linux/slab.h>
-#include <linux/usb.h>
 #include <linux/module.h>
 
 #include "hid-ids.h"
 
 #ifdef CONFIG_ZEROPLUS_FF
-#include "usbhid/usbhid.h"
 
 struct zpff_device {
 	struct hid_report *report;
@@ -59,7 +57,7 @@ static int zpff_play(struct input_dev *dev, void *data,
 	zpff->report->field[2]->value[0] = left;
 	zpff->report->field[3]->value[0] = right;
 	dbg_hid("running with 0x%02x 0x%02x\n", left, right);
-	usbhid_submit_report(hid, zpff->report, USB_DIR_OUT);
+	hid_hw_request(hid, zpff->report, HID_REQ_SET_REPORT);
 
 	return 0;
 }
@@ -104,7 +102,7 @@ static int zpff_init(struct hid_device *hid)
 	zpff->report->field[1]->value[0] = 0x02;
 	zpff->report->field[2]->value[0] = 0x00;
 	zpff->report->field[3]->value[0] = 0x00;
-	usbhid_submit_report(hid, zpff->report, USB_DIR_OUT);
+	hid_hw_request(hid, zpff->report, HID_REQ_SET_REPORT);
 
 	hid_info(hid, "force feedback for Zeroplus based devices by Anssi Hannula <anssi.hannula@gmail.com>\n");
 
diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 99d95d3..da68687 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -639,7 +639,7 @@ static void __usbhid_submit_report(struct hid_device *hid, struct hid_report *re
 	}
 }
 
-void usbhid_submit_report(struct hid_device *hid, struct hid_report *report, unsigned char dir)
+static void usbhid_submit_report(struct hid_device *hid, struct hid_report *report, unsigned char dir)
 {
 	struct usbhid_device *usbhid = hid->driver_data;
 	unsigned long flags;
@@ -648,7 +648,6 @@ void usbhid_submit_report(struct hid_device *hid, struct hid_report *report, uns
 	__usbhid_submit_report(hid, report, dir);
 	spin_unlock_irqrestore(&usbhid->lock, flags);
 }
-EXPORT_SYMBOL_GPL(usbhid_submit_report);
 
 /* Workqueue routine to send requests to change LEDs */
 static void hid_led(struct work_struct *work)
diff --git a/drivers/hid/usbhid/hid-pidff.c b/drivers/hid/usbhid/hid-pidff.c
index f91c136..0f1efa3 100644
--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -263,8 +263,8 @@ static void pidff_set_envelope_report(struct pidff_device *pidff,
 		envelope->attack_level,
 		pidff->set_envelope[PID_ATTACK_LEVEL].value[0]);
 
-	usbhid_submit_report(pidff->hid, pidff->reports[PID_SET_ENVELOPE],
-			  USB_DIR_OUT);
+	hid_hw_request(pidff->hid, pidff->reports[PID_SET_ENVELOPE],
+			HID_REQ_SET_REPORT);
 }
 
 /*
@@ -290,8 +290,8 @@ static void pidff_set_constant_force_report(struct pidff_device *pidff,
 	pidff_set_signed(&pidff->set_constant[PID_MAGNITUDE],
 			 effect->u.constant.level);
 
-	usbhid_submit_report(pidff->hid, pidff->reports[PID_SET_CONSTANT],
-			  USB_DIR_OUT);
+	hid_hw_request(pidff->hid, pidff->reports[PID_SET_CONSTANT],
+			HID_REQ_SET_REPORT);
 }
 
 /*
@@ -325,8 +325,8 @@ static void pidff_set_effect_report(struct pidff_device *pidff,
 				pidff->effect_direction);
 	pidff->set_effect[PID_START_DELAY].value[0] = effect->replay.delay;
 
-	usbhid_submit_report(pidff->hid, pidff->reports[PID_SET_EFFECT],
-			  USB_DIR_OUT);
+	hid_hw_request(pidff->hid, pidff->reports[PID_SET_EFFECT],
+			HID_REQ_SET_REPORT);
 }
 
 /*
@@ -357,8 +357,8 @@ static void pidff_set_periodic_report(struct pidff_device *pidff,
 	pidff_set(&pidff->set_periodic[PID_PHASE], effect->u.periodic.phase);
 	pidff->set_periodic[PID_PERIOD].value[0] = effect->u.periodic.period;
 
-	usbhid_submit_report(pidff->hid, pidff->reports[PID_SET_PERIODIC],
-			  USB_DIR_OUT);
+	hid_hw_request(pidff->hid, pidff->reports[PID_SET_PERIODIC],
+			HID_REQ_SET_REPORT);
 
 }
 
@@ -399,8 +399,8 @@ static void pidff_set_condition_report(struct pidff_device *pidff,
 			  effect->u.condition[i].left_saturation);
 		pidff_set(&pidff->set_condition[PID_DEAD_BAND],
 			  effect->u.condition[i].deadband);
-		usbhid_submit_report(pidff->hid, pidff->reports[PID_SET_CONDITION],
-				  USB_DIR_OUT);
+		hid_hw_request(pidff->hid, pidff->reports[PID_SET_CONDITION],
+				HID_REQ_SET_REPORT);
 	}
 }
 
@@ -440,8 +440,8 @@ static void pidff_set_ramp_force_report(struct pidff_device *pidff,
 			 effect->u.ramp.start_level);
 	pidff_set_signed(&pidff->set_ramp[PID_RAMP_END],
 			 effect->u.ramp.end_level);
-	usbhid_submit_report(pidff->hid, pidff->reports[PID_SET_RAMP],
-			  USB_DIR_OUT);
+	hid_hw_request(pidff->hid, pidff->reports[PID_SET_RAMP],
+			HID_REQ_SET_REPORT);
 }
 
 /*
@@ -465,8 +465,8 @@ static int pidff_request_effect_upload(struct pidff_device *pidff, int efnum)
 	int j;
 
 	pidff->create_new_effect_type->value[0] = efnum;
-	usbhid_submit_report(pidff->hid, pidff->reports[PID_CREATE_NEW_EFFECT],
-			  USB_DIR_OUT);
+	hid_hw_request(pidff->hid, pidff->reports[PID_CREATE_NEW_EFFECT],
+			HID_REQ_SET_REPORT);
 	hid_dbg(pidff->hid, "create_new_effect sent, type: %d\n", efnum);
 
 	pidff->block_load[PID_EFFECT_BLOCK_INDEX].value[0] = 0;
@@ -475,8 +475,8 @@ static int pidff_request_effect_upload(struct pidff_device *pidff, int efnum)
 
 	for (j = 0; j < 60; j++) {
 		hid_dbg(pidff->hid, "pid_block_load requested\n");
-		usbhid_submit_report(pidff->hid, pidff->reports[PID_BLOCK_LOAD],
-				  USB_DIR_IN);
+		hid_hw_request(pidff->hid, pidff->reports[PID_BLOCK_LOAD],
+				HID_REQ_GET_REPORT);
 		usbhid_wait_io(pidff->hid);
 		if (pidff->block_load_status->value[0] ==
 		    pidff->status_id[PID_BLOCK_LOAD_SUCCESS]) {
@@ -513,8 +513,8 @@ static void pidff_playback_pid(struct pidff_device *pidff, int pid_id, int n)
 		pidff->effect_operation[PID_LOOP_COUNT].value[0] = n;
 	}
 
-	usbhid_submit_report(pidff->hid, pidff->reports[PID_EFFECT_OPERATION],
-			  USB_DIR_OUT);
+	hid_hw_request(pidff->hid, pidff->reports[PID_EFFECT_OPERATION],
+			HID_REQ_SET_REPORT);
 }
 
 /**
@@ -535,8 +535,8 @@ static int pidff_playback(struct input_dev *dev, int effect_id, int value)
 static void pidff_erase_pid(struct pidff_device *pidff, int pid_id)
 {
 	pidff->block_free[PID_EFFECT_BLOCK_INDEX].value[0] = pid_id;
-	usbhid_submit_report(pidff->hid, pidff->reports[PID_BLOCK_FREE],
-			  USB_DIR_OUT);
+	hid_hw_request(pidff->hid, pidff->reports[PID_BLOCK_FREE],
+			HID_REQ_SET_REPORT);
 }
 
 /*
@@ -718,8 +718,8 @@ static void pidff_set_gain(struct input_dev *dev, u16 gain)
 	struct pidff_device *pidff = dev->ff->private;
 
 	pidff_set(&pidff->device_gain[PID_DEVICE_GAIN_FIELD], gain);
-	usbhid_submit_report(pidff->hid, pidff->reports[PID_DEVICE_GAIN],
-			  USB_DIR_OUT);
+	hid_hw_request(pidff->hid, pidff->reports[PID_DEVICE_GAIN],
+			HID_REQ_SET_REPORT);
 }
 
 static void pidff_autocenter(struct pidff_device *pidff, u16 magnitude)
@@ -744,8 +744,8 @@ static void pidff_autocenter(struct pidff_device *pidff, u16 magnitude)
 	pidff->set_effect[PID_DIRECTION_ENABLE].value[0] = 1;
 	pidff->set_effect[PID_START_DELAY].value[0] = 0;
 
-	usbhid_submit_report(pidff->hid, pidff->reports[PID_SET_EFFECT],
-			  USB_DIR_OUT);
+	hid_hw_request(pidff->hid, pidff->reports[PID_SET_EFFECT],
+			HID_REQ_SET_REPORT);
 }
 
 /*
@@ -1158,18 +1158,18 @@ static void pidff_reset(struct pidff_device *pidff)
 
 	pidff->device_control->value[0] = pidff->control_id[PID_RESET];
 	/* We reset twice as sometimes hid_wait_io isn't waiting long enough */
-	usbhid_submit_report(hid, pidff->reports[PID_DEVICE_CONTROL], USB_DIR_OUT);
+	hid_hw_request(hid, pidff->reports[PID_DEVICE_CONTROL], HID_REQ_SET_REPORT);
 	usbhid_wait_io(hid);
-	usbhid_submit_report(hid, pidff->reports[PID_DEVICE_CONTROL], USB_DIR_OUT);
+	hid_hw_request(hid, pidff->reports[PID_DEVICE_CONTROL], HID_REQ_SET_REPORT);
 	usbhid_wait_io(hid);
 
 	pidff->device_control->value[0] =
 		pidff->control_id[PID_ENABLE_ACTUATORS];
-	usbhid_submit_report(hid, pidff->reports[PID_DEVICE_CONTROL], USB_DIR_OUT);
+	hid_hw_request(hid, pidff->reports[PID_DEVICE_CONTROL], HID_REQ_SET_REPORT);
 	usbhid_wait_io(hid);
 
 	/* pool report is sometimes messed up, refetch it */
-	usbhid_submit_report(hid, pidff->reports[PID_POOL], USB_DIR_IN);
+	hid_hw_request(hid, pidff->reports[PID_POOL], HID_REQ_GET_REPORT);
 	usbhid_wait_io(hid);
 
 	if (pidff->pool[PID_SIMULTANEOUS_MAX].value) {
@@ -1181,8 +1181,8 @@ static void pidff_reset(struct pidff_device *pidff)
 				break;
 			}
 			hid_dbg(pidff->hid, "pid_pool requested again\n");
-			usbhid_submit_report(hid, pidff->reports[PID_POOL],
-					  USB_DIR_IN);
+			hid_hw_request(hid, pidff->reports[PID_POOL],
+					  HID_REQ_GET_REPORT);
 			usbhid_wait_io(hid);
 		}
 	}
@@ -1269,8 +1269,8 @@ int hid_pidff_init(struct hid_device *hid)
 
 	if (test_bit(FF_GAIN, dev->ffbit)) {
 		pidff_set(&pidff->device_gain[PID_DEVICE_GAIN_FIELD], 0xffff);
-		usbhid_submit_report(hid, pidff->reports[PID_DEVICE_GAIN],
-				     USB_DIR_OUT);
+		hid_hw_request(hid, pidff->reports[PID_DEVICE_GAIN],
+				     HID_REQ_SET_REPORT);
 	}
 
 	error = pidff_check_autocenter(pidff, dev);
diff --git a/drivers/hid/usbhid/hiddev.c b/drivers/hid/usbhid/hiddev.c
index 87bd649..430d2a9 100644
--- a/drivers/hid/usbhid/hiddev.c
+++ b/drivers/hid/usbhid/hiddev.c
@@ -705,7 +705,7 @@ static long hiddev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		if (report == NULL)
 			break;
 
-		usbhid_submit_report(hid, report, USB_DIR_IN);
+		hid_hw_request(hid, report, HID_REQ_GET_REPORT);
 		usbhid_wait_io(hid);
 
 		r = 0;
@@ -724,7 +724,7 @@ static long hiddev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		if (report == NULL)
 			break;
 
-		usbhid_submit_report(hid, report, USB_DIR_OUT);
+		hid_hw_request(hid, report, HID_REQ_SET_REPORT);
 		usbhid_wait_io(hid);
 
 		r = 0;
diff --git a/drivers/hid/usbhid/usbhid.h b/drivers/hid/usbhid/usbhid.h
index bd87a61..aa1d5ff 100644
--- a/drivers/hid/usbhid/usbhid.h
+++ b/drivers/hid/usbhid/usbhid.h
@@ -38,8 +38,6 @@ int usbhid_wait_io(struct hid_device* hid);
 void usbhid_close(struct hid_device *hid);
 int usbhid_open(struct hid_device *hid);
 void usbhid_init_reports(struct hid_device *hid);
-void usbhid_submit_report
-(struct hid_device *hid, struct hid_report *report, unsigned char dir);
 int usbhid_get_power(struct hid_device *hid);
 void usbhid_put_power(struct hid_device *hid);
 struct usb_interface *usbhid_find_interface(int minor);
-- 
1.8.1

