Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbaB1Qm2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 11:42:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8336 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752444AbaB1Qlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 11:41:36 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] HID: multitouch: remove registered devices with default behavior
Date: Fri, 28 Feb 2014 11:41:23 -0500
Message-Id: <1393605685-17025-2-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1393605685-17025-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1393605685-17025-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default multitouch protocol class in use since the kernel v3.9 is
working quite well. Since its inclusion, the only devices we had to tweak
were those who really need quirks (GeneralTouch, FocalTech and Wistron,
the 3 of them are Win 7 certified ones).
The flow of new unhandled devices has stopped, which is great and I think
it's time to reduce the list of registered device.

This commit removes only the registration in the kernel of devices that
use the class MT_CLS_DEFAULT, or that can use it. By that, I mean that I
checked all the recordings I have, and the produced input device and
events are the same before and after applying the patch.

This gives two benefits:
- remove a bunch of lines of codes
- prevent bad handling of existing registered devices which are using a
different protocol while using the same VID/PID (I got the case of a
Quanta 3008 recently).

I also removed the associated classes (MT_CLS*). I kept their #define in
case people use the new_id sysfs node with a non standard class (their
should be really few people now, but we never now). This is why there
are /* reserved .... */.

Last, I add a comment on top of mt_devices[] definition to remember people
(and myself) not to include devices for the beauty of it.

To people still trying to add devices with the default class:
"""
Guys, try out your device under a kernel greater or equal to v3.9. If it
works, you are all set. Adding your VID/PID to the kernel only brings us
overload and you won't get anything from it _because_ even a backport of
this shiny patch will _not_ make the device work under 3.0, 3.2, 3.4 or
even 3.8.
So if it works, it works.
If it does not work, then yes, submit a patch or call for help.
In any cases, if you want me to do regression tests, I'd be happy to
get some traces of your device. But I won't patch the kernel if it works.
"""

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-multitouch.c | 129 ++++---------------------------------------
 1 file changed, 11 insertions(+), 118 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index f134d73..3e81f4e 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -128,16 +128,16 @@ static void mt_post_parse(struct mt_device *td);
 #define MT_CLS_CONFIDENCE_MINUS_ONE		0x0005
 #define MT_CLS_DUAL_INRANGE_CONTACTID		0x0006
 #define MT_CLS_DUAL_INRANGE_CONTACTNUMBER	0x0007
-#define MT_CLS_DUAL_NSMU_CONTACTID		0x0008
+/* reserved					0x0008 */
 #define MT_CLS_INRANGE_CONTACTNUMBER		0x0009
 #define MT_CLS_NSMU				0x000a
-#define MT_CLS_DUAL_CONTACT_NUMBER		0x0010
-#define MT_CLS_DUAL_CONTACT_ID			0x0011
+/* reserved					0x0010 */
+/* reserved					0x0011 */
 #define MT_CLS_WIN_8				0x0012
 
 /* vendor specific classes */
 #define MT_CLS_3M				0x0101
-#define MT_CLS_CYPRESS				0x0102
+/* reserved					0x0102 */
 #define MT_CLS_EGALAX				0x0103
 #define MT_CLS_EGALAX_SERIAL			0x0104
 #define MT_CLS_TOPSEED				0x0105
@@ -189,23 +189,9 @@ static struct mt_class mt_classes[] = {
 		.quirks = MT_QUIRK_VALID_IS_INRANGE |
 			MT_QUIRK_SLOT_IS_CONTACTNUMBER,
 		.maxcontacts = 2 },
-	{ .name = MT_CLS_DUAL_NSMU_CONTACTID,
-		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP |
-			MT_QUIRK_SLOT_IS_CONTACTID,
-		.maxcontacts = 2 },
 	{ .name = MT_CLS_INRANGE_CONTACTNUMBER,
 		.quirks = MT_QUIRK_VALID_IS_INRANGE |
 			MT_QUIRK_SLOT_IS_CONTACTNUMBER },
-	{ .name = MT_CLS_DUAL_CONTACT_NUMBER,
-		.quirks = MT_QUIRK_ALWAYS_VALID |
-			MT_QUIRK_CONTACT_CNT_ACCURATE |
-			MT_QUIRK_SLOT_IS_CONTACTNUMBER,
-		.maxcontacts = 2 },
-	{ .name = MT_CLS_DUAL_CONTACT_ID,
-		.quirks = MT_QUIRK_ALWAYS_VALID |
-			MT_QUIRK_CONTACT_CNT_ACCURATE |
-			MT_QUIRK_SLOT_IS_CONTACTID,
-		.maxcontacts = 2 },
 	{ .name = MT_CLS_WIN_8,
 		.quirks = MT_QUIRK_ALWAYS_VALID |
 			MT_QUIRK_IGNORE_DUPLICATES |
@@ -223,10 +209,6 @@ static struct mt_class mt_classes[] = {
 		.sn_height = 128,
 		.maxcontacts = 60,
 	},
-	{ .name = MT_CLS_CYPRESS,
-		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP |
-			MT_QUIRK_CYPRESS,
-		.maxcontacts = 10 },
 	{ .name = MT_CLS_EGALAX,
 		.quirks =  MT_QUIRK_SLOT_IS_CONTACTID |
 			MT_QUIRK_VALID_IS_INRANGE,
@@ -1034,6 +1016,12 @@ static void mt_remove(struct hid_device *hdev)
 	hid_hw_stop(hdev);
 }
 
+/*
+ * This list contains only:
+ * - VID/PID of products not working with the default multitouch handling
+ * - 2 generic rules.
+ * So there is no point in adding here any device with MT_CLS_DEFAULT.
+ */
 static const struct hid_device_id mt_devices[] = {
 
 	/* 3M panels */
@@ -1047,33 +1035,20 @@ static const struct hid_device_id mt_devices[] = {
 		MT_USB_DEVICE(USB_VENDOR_ID_3M,
 			USB_DEVICE_ID_3M3266) },
 
-	/* ActionStar panels */
-	{ .driver_data = MT_CLS_NSMU,
-		MT_USB_DEVICE(USB_VENDOR_ID_ACTIONSTAR,
-			USB_DEVICE_ID_ACTIONSTAR_1011) },
-
 	/* Atmel panels */
 	{ .driver_data = MT_CLS_SERIAL,
 		MT_USB_DEVICE(USB_VENDOR_ID_ATMEL,
-			USB_DEVICE_ID_ATMEL_MULTITOUCH) },
-	{ .driver_data = MT_CLS_SERIAL,
-		MT_USB_DEVICE(USB_VENDOR_ID_ATMEL,
 			USB_DEVICE_ID_ATMEL_MXT_DIGITIZER) },
 
 	/* Baanto multitouch devices */
 	{ .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_BAANTO,
 			USB_DEVICE_ID_BAANTO_MT_190W2) },
+
 	/* Cando panels */
 	{ .driver_data = MT_CLS_DUAL_INRANGE_CONTACTNUMBER,
 		MT_USB_DEVICE(USB_VENDOR_ID_CANDO,
 			USB_DEVICE_ID_CANDO_MULTI_TOUCH) },
-	{ .driver_data = MT_CLS_DUAL_CONTACT_NUMBER,
-		MT_USB_DEVICE(USB_VENDOR_ID_CANDO,
-			USB_DEVICE_ID_CANDO_MULTI_TOUCH_10_1) },
-	{ .driver_data = MT_CLS_DUAL_INRANGE_CONTACTNUMBER,
-		MT_USB_DEVICE(USB_VENDOR_ID_CANDO,
-			USB_DEVICE_ID_CANDO_MULTI_TOUCH_11_6) },
 	{ .driver_data = MT_CLS_DUAL_INRANGE_CONTACTNUMBER,
 		MT_USB_DEVICE(USB_VENDOR_ID_CANDO,
 			USB_DEVICE_ID_CANDO_MULTI_TOUCH_15_6) },
@@ -1088,16 +1063,6 @@ static const struct hid_device_id mt_devices[] = {
 		MT_USB_DEVICE(USB_VENDOR_ID_CVTOUCH,
 			USB_DEVICE_ID_CVTOUCH_SCREEN) },
 
-	/* Cypress panel */
-	{ .driver_data = MT_CLS_CYPRESS,
-		HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS,
-			USB_DEVICE_ID_CYPRESS_TRUETOUCH) },
-
-	/* Data Modul easyMaxTouch */
-	{ .driver_data = MT_CLS_DEFAULT,
-		MT_USB_DEVICE(USB_VENDOR_ID_DATA_MODUL,
-			USB_VENDOR_ID_DATA_MODUL_EASYMAXTOUCH) },
-
 	/* eGalax devices (resistive) */
 	{ .driver_data = MT_CLS_EGALAX,
 		MT_USB_DEVICE(USB_VENDOR_ID_DWAV,
@@ -1156,11 +1121,6 @@ static const struct hid_device_id mt_devices[] = {
 		MT_USB_DEVICE(USB_VENDOR_ID_DWAV,
 			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_A001) },
 
-	/* Elo TouchSystems IntelliTouch Plus panel */
-	{ .driver_data = MT_CLS_DUAL_CONTACT_ID,
-		MT_USB_DEVICE(USB_VENDOR_ID_ELO,
-			USB_DEVICE_ID_ELO_TS2515) },
-
 	/* Flatfrog Panels */
 	{ .driver_data = MT_CLS_FLATFROG,
 		MT_USB_DEVICE(USB_VENDOR_ID_FLATFROG,
@@ -1204,37 +1164,11 @@ static const struct hid_device_id mt_devices[] = {
 		MT_USB_DEVICE(USB_VENDOR_ID_HANVON_ALT,
 			USB_DEVICE_ID_HANVON_ALT_MULTITOUCH) },
 
-	/* Ideacom panel */
-	{ .driver_data = MT_CLS_SERIAL,
-		MT_USB_DEVICE(USB_VENDOR_ID_IDEACOM,
-			USB_DEVICE_ID_IDEACOM_IDC6650) },
-	{ .driver_data = MT_CLS_SERIAL,
-		MT_USB_DEVICE(USB_VENDOR_ID_IDEACOM,
-			USB_DEVICE_ID_IDEACOM_IDC6651) },
-
 	/* Ilitek dual touch panel */
 	{  .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_ILITEK,
 			USB_DEVICE_ID_ILITEK_MULTITOUCH) },
 
-	/* IRTOUCH panels */
-	{ .driver_data = MT_CLS_DUAL_INRANGE_CONTACTID,
-		MT_USB_DEVICE(USB_VENDOR_ID_IRTOUCHSYSTEMS,
-			USB_DEVICE_ID_IRTOUCH_INFRARED_USB) },
-
-	/* LG Display panels */
-	{ .driver_data = MT_CLS_DEFAULT,
-		MT_USB_DEVICE(USB_VENDOR_ID_LG,
-			USB_DEVICE_ID_LG_MULTITOUCH) },
-
-	/* Lumio panels */
-	{ .driver_data = MT_CLS_CONFIDENCE_MINUS_ONE,
-		MT_USB_DEVICE(USB_VENDOR_ID_LUMIO,
-			USB_DEVICE_ID_CRYSTALTOUCH) },
-	{ .driver_data = MT_CLS_CONFIDENCE_MINUS_ONE,
-		MT_USB_DEVICE(USB_VENDOR_ID_LUMIO,
-			USB_DEVICE_ID_CRYSTALTOUCH_DUAL) },
-
 	/* MosArt panels */
 	{ .driver_data = MT_CLS_CONFIDENCE_MINUS_ONE,
 		MT_USB_DEVICE(USB_VENDOR_ID_ASUS,
@@ -1246,11 +1180,6 @@ static const struct hid_device_id mt_devices[] = {
 		MT_USB_DEVICE(USB_VENDOR_ID_TURBOX,
 			USB_DEVICE_ID_TURBOX_TOUCHSCREEN_MOSART) },
 
-	/* Nexio panels */
-	{ .driver_data = MT_CLS_DEFAULT,
-		MT_USB_DEVICE(USB_VENDOR_ID_NEXIO,
-			USB_DEVICE_ID_NEXIO_MULTITOUCH_420)},
-
 	/* Panasonic panels */
 	{ .driver_data = MT_CLS_PANASONIC,
 		MT_USB_DEVICE(USB_VENDOR_ID_PANASONIC,
@@ -1264,11 +1193,6 @@ static const struct hid_device_id mt_devices[] = {
 		MT_USB_DEVICE(USB_VENDOR_ID_NOVATEK,
 			USB_DEVICE_ID_NOVATEK_PCT) },
 
-	/* PenMount panels */
-	{ .driver_data = MT_CLS_CONFIDENCE,
-		MT_USB_DEVICE(USB_VENDOR_ID_PENMOUNT,
-			USB_DEVICE_ID_PENMOUNT_PCI) },
-
 	/* PixArt optical touch screen */
 	{ .driver_data = MT_CLS_INRANGE_CONTACTNUMBER,
 		MT_USB_DEVICE(USB_VENDOR_ID_PIXART,
@@ -1282,44 +1206,18 @@ static const struct hid_device_id mt_devices[] = {
 
 	/* PixCir-based panels */
 	{ .driver_data = MT_CLS_DUAL_INRANGE_CONTACTID,
-		MT_USB_DEVICE(USB_VENDOR_ID_HANVON,
-			USB_DEVICE_ID_HANVON_MULTITOUCH) },
-	{ .driver_data = MT_CLS_DUAL_INRANGE_CONTACTID,
 		MT_USB_DEVICE(USB_VENDOR_ID_CANDO,
 			USB_DEVICE_ID_CANDO_PIXCIR_MULTI_TOUCH) },
 
 	/* Quanta-based panels */
 	{ .driver_data = MT_CLS_CONFIDENCE_CONTACT_ID,
 		MT_USB_DEVICE(USB_VENDOR_ID_QUANTA,
-			USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH) },
-	{ .driver_data = MT_CLS_CONFIDENCE_CONTACT_ID,
-		MT_USB_DEVICE(USB_VENDOR_ID_QUANTA,
 			USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH_3001) },
-	{ .driver_data = MT_CLS_CONFIDENCE_CONTACT_ID,
-		MT_USB_DEVICE(USB_VENDOR_ID_QUANTA,
-			USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH_3008) },
-
-	/* SiS panels */
-	{ .driver_data = MT_CLS_DEFAULT,
-		HID_USB_DEVICE(USB_VENDOR_ID_SIS_TOUCH,
-		USB_DEVICE_ID_SIS9200_TOUCH) },
-	{ .driver_data = MT_CLS_DEFAULT,
-		HID_USB_DEVICE(USB_VENDOR_ID_SIS_TOUCH,
-		USB_DEVICE_ID_SIS817_TOUCH) },
-	{ .driver_data = MT_CLS_DEFAULT,
-		HID_USB_DEVICE(USB_VENDOR_ID_SIS_TOUCH,
-		USB_DEVICE_ID_SIS1030_TOUCH) },
 
 	/* Stantum panels */
 	{ .driver_data = MT_CLS_CONFIDENCE,
-		MT_USB_DEVICE(USB_VENDOR_ID_STANTUM,
-			USB_DEVICE_ID_MTP)},
-	{ .driver_data = MT_CLS_CONFIDENCE,
 		MT_USB_DEVICE(USB_VENDOR_ID_STANTUM_STM,
 			USB_DEVICE_ID_MTP_STM)},
-	{ .driver_data = MT_CLS_DEFAULT,
-		MT_USB_DEVICE(USB_VENDOR_ID_STANTUM_SITRONIX,
-			USB_DEVICE_ID_MTP_SITRONIX)},
 
 	/* TopSeed panels */
 	{ .driver_data = MT_CLS_TOPSEED,
@@ -1378,11 +1276,6 @@ static const struct hid_device_id mt_devices[] = {
 		MT_USB_DEVICE(USB_VENDOR_ID_XIROKU,
 			USB_DEVICE_ID_XIROKU_CSR2) },
 
-	/* Zytronic panels */
-	{ .driver_data = MT_CLS_SERIAL,
-		MT_USB_DEVICE(USB_VENDOR_ID_ZYTRONIC,
-			USB_DEVICE_ID_ZYTRONIC_ZXY100) },
-
 	/* Generic MT device */
 	{ HID_DEVICE(HID_BUS_ANY, HID_GROUP_MULTITOUCH, HID_ANY_ID, HID_ANY_ID) },
 
-- 
1.8.5.3

