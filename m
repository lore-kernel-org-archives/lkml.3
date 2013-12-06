Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246Ab3LFNDC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:03:02 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44290 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161578Ab3LFNC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:02:58 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Forest Bond <forest.bond@rapidrollout.com>, Jiri Kosina <jkosina@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 155/272] HID: hid-multitouch: add support for SiS panels
Date: Fri,  6 Dec 2013 12:57:24 +0000
Message-Id: <1386334761-25517-156-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Forest Bond <forest.bond@rapidrollout.com>

commit a6802e008e19845fd9669511b895f7515ef9c48b upstream.

Add support for SiS multitouch panels.

Signed-off-by: Forest Bond <forest.bond@rapidrollout.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hid/Kconfig             | 1 +
 drivers/hid/hid-core.c          | 2 ++
 drivers/hid/hid-ids.h           | 4 ++++
 drivers/hid/hid-multitouch.c    | 8 ++++++++
 drivers/hid/usbhid/hid-quirks.c | 2 ++
 5 files changed, 17 insertions(+)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 6904bbd..5f5578b 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -455,6 +455,7 @@ config HID_MULTITOUCH
 	  - Pixcir dual touch panels
 	  - Quanta panels
 	  - eGalax dual-touch panels, including the Joojoo and Wetab tablets
+	  - SiS multitouch panels
 	  - Stantum multitouch panels
 	  - Touch International Panels
 	  - Unitec Panels
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 296f6dc..5793a3e 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1774,6 +1774,8 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_PS1000) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAMSUNG, USB_DEVICE_ID_SAMSUNG_IR_REMOTE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAMSUNG, USB_DEVICE_ID_SAMSUNG_WIRELESS_KBD_MOUSE) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_SIS2_TOUCH, USB_DEVICE_ID_SIS9200_TOUCH) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_SIS2_TOUCH, USB_DEVICE_ID_SIS817_TOUCH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SKYCABLE, USB_DEVICE_ID_SKYCABLE_WIRELESS_PRESENTER) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_BUZZ_CONTROLLER) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_WIRELESS_BUZZ_CONTROLLER) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 2226e59..3161ccf 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -751,6 +751,10 @@
 #define USB_VENDOR_ID_SIGMATEL		0x066F
 #define USB_DEVICE_ID_SIGMATEL_STMP3780	0x3780
 
+#define USB_VENDOR_ID_SIS2_TOUCH	0x0457
+#define USB_DEVICE_ID_SIS9200_TOUCH	0x9200
+#define USB_DEVICE_ID_SIS817_TOUCH	0x0817
+
 #define USB_VENDOR_ID_SKYCABLE			0x1223
 #define	USB_DEVICE_ID_SKYCABLE_WIRELESS_PRESENTER	0x3F07
 
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 94a903c..0e8fc79 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1319,6 +1319,14 @@ static const struct hid_device_id mt_devices[] = {
 		MT_USB_DEVICE(USB_VENDOR_ID_QUANTA,
 			USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH_3008) },
 
+	/* SiS panels */
+	{ .driver_data = MT_CLS_DEFAULT,
+		HID_USB_DEVICE(USB_VENDOR_ID_SIS2_TOUCH,
+		USB_DEVICE_ID_SIS9200_TOUCH) },
+	{ .driver_data = MT_CLS_DEFAULT,
+		HID_USB_DEVICE(USB_VENDOR_ID_SIS2_TOUCH,
+		USB_DEVICE_ID_SIS817_TOUCH) },
+
 	/* Stantum panels */
 	{ .driver_data = MT_CLS_CONFIDENCE,
 		MT_USB_DEVICE(USB_VENDOR_ID_STANTUM,
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index 0734552..ae5c634 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -84,6 +84,8 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_REALTEK, USB_DEVICE_ID_REALTEK_READER, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_SENNHEISER, USB_DEVICE_ID_SENNHEISER_BTD500USB, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_SIGMATEL, USB_DEVICE_ID_SIGMATEL_STMP3780, HID_QUIRK_NOGET },
+	{ USB_VENDOR_ID_SIS2_TOUCH, USB_DEVICE_ID_SIS9200_TOUCH, HID_QUIRK_NOGET },
+	{ USB_VENDOR_ID_SIS2_TOUCH, USB_DEVICE_ID_SIS817_TOUCH, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_SUN, USB_DEVICE_ID_RARITAN_KVM_DONGLE, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_SYMBOL, USB_DEVICE_ID_SYMBOL_SCANNER_1, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_SYMBOL, USB_DEVICE_ID_SYMBOL_SCANNER_2, HID_QUIRK_NOGET },
-- 
1.8.3.2

