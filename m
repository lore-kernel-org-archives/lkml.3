Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbbAJFgv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 00:36:51 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:60709 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470AbbAJFgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 00:36:49 -0500
From: Chris Rorvick <chris@rorvick.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Chris Rorvick <chris@rorvick.com>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Davide Berardi <berardi.dav@gmail.com>, devel@driverdev.osuosl.org,
        Fabian Mewes <architekt@coding4coffee.org>,
        Gulsah Kose <gulsah.1004@gmail.com>,
        Himangi Saraogi <himangi774@gmail.com>,
        Jerry Snitselaar <dev@snitselaar.org>,
        =?UTF-8?q?L=2E=20Alberto=20Gim=C3=A9nez?= <agimenez@sysvalve.es>,
        linux-kernel@vger.kernel.org, Mikhail Boiko <mm.boiko@yandex.ru>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Stefan Hajnoczi <stefanha@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 13/25] staging: line6: Split out PODxt Live interfaces
Date: Fri,  9 Jan 2015 23:35:59 -0600
Message-Id: <1420868171-2031-14-git-send-email-chris@rorvick.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420868171-2031-1-git-send-email-chris@rorvick.com>
References: <1420868171-2031-1-git-send-email-chris@rorvick.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PODxt Live device has both a POD and a Variax interface.  Add device
type entries for each of these.

Signed-off-by: Chris Rorvick <chris@rorvick.com>
---
 drivers/staging/line6/driver.c | 112 ++++++++++++++++-------------------------
 drivers/staging/line6/driver.h |   8 +--
 drivers/staging/line6/pcm.c    |   3 +-
 drivers/staging/line6/pod.h    |   6 ---
 4 files changed, 48 insertions(+), 81 deletions(-)

diff --git a/drivers/staging/line6/driver.c b/drivers/staging/line6/driver.c
index 6fecc1b..cb96029 100644
--- a/drivers/staging/line6/driver.c
+++ b/drivers/staging/line6/driver.c
@@ -31,6 +31,7 @@
 #define DRIVER_VERSION "0.9.1beta" DRIVER_REVISION
 
 #define LINE6_DEVICE(prod) USB_DEVICE(0x0e41, prod)
+#define LINE6_IF_NUM(prod, n) USB_DEVICE_INTERFACE_NUMBER(0x0e41, prod, n)
 
 /* table of devices that work with this driver */
 static const struct usb_device_id line6_id_table[] = {
@@ -46,7 +47,8 @@ static const struct usb_device_id line6_id_table[] = {
 	{ LINE6_DEVICE(0x4150),    .driver_info = LINE6_PODSTUDIO_UX1 },
 	{ LINE6_DEVICE(0x4151),    .driver_info = LINE6_PODSTUDIO_UX2 },
 	{ LINE6_DEVICE(0x5044),    .driver_info = LINE6_PODXT },
-	{ LINE6_DEVICE(0x4650),    .driver_info = LINE6_PODXTLIVE },
+	{ LINE6_IF_NUM(0x4650, 0), .driver_info = LINE6_PODXTLIVE_POD },
+	{ LINE6_IF_NUM(0x4650, 1), .driver_info = LINE6_PODXTLIVE_VARIAX },
 	{ LINE6_DEVICE(0x5050),    .driver_info = LINE6_PODXTPRO },
 	{ LINE6_DEVICE(0x4147),    .driver_info = LINE6_TONEPORT_GX },
 	{ LINE6_DEVICE(0x4141),    .driver_info = LINE6_TONEPORT_UX1 },
@@ -132,7 +134,14 @@ static const struct line6_properties line6_properties_table[] = {
 				| LINE6_CAP_PCM
 				| LINE6_CAP_HWMON,
 	},
-	[LINE6_PODXTLIVE] = {
+	[LINE6_PODXTLIVE_POD] = {
+		.id = "PODxtLive",
+		.name = "PODxt Live",
+		.capabilities	= LINE6_CAP_CONTROL
+				| LINE6_CAP_PCM
+				| LINE6_CAP_HWMON,
+	},
+	[LINE6_PODXTLIVE_VARIAX] = {
 		.id = "PODxtLive",
 		.name = "PODxt Live",
 		.capabilities	= LINE6_CAP_CONTROL
@@ -445,24 +454,15 @@ static void line6_data_received(struct urb *urb)
 		case LINE6_PODHD500:
 			break; /* let userspace handle MIDI */
 
-		case LINE6_PODXTLIVE:
-			switch (line6->interface_number) {
-			case PODXTLIVE_INTERFACE_POD:
-				line6_pod_process_message((struct usb_line6_pod
+		case LINE6_PODXTLIVE_POD:
+			line6_pod_process_message((struct usb_line6_pod
 							   *)line6);
-				break;
-
-			case PODXTLIVE_INTERFACE_VARIAX:
-				line6_variax_process_message((struct
-							      usb_line6_variax
-							      *)line6);
-				break;
-
-			default:
-				dev_err(line6->ifcdev,
-					"PODxt Live interface %d not supported\n",
-					line6->interface_number);
-			}
+			break;
+
+		case LINE6_PODXTLIVE_VARIAX:
+			line6_variax_process_message((struct
+						      usb_line6_variax
+						      *)line6);
 			break;
 
 		case LINE6_VARIAX:
@@ -722,7 +722,8 @@ static int line6_probe(struct usb_interface *interface,
 
 	switch (devtype) {
 	case LINE6_BASSPODXTLIVE:
-	case LINE6_PODXTLIVE:
+	case LINE6_PODXTLIVE_POD:
+	case LINE6_PODXTLIVE_VARIAX:
 	case LINE6_VARIAX:
 		alternate = 1;
 		break;
@@ -841,24 +842,16 @@ static int line6_probe(struct usb_interface *interface,
 		/* these don't have a control channel */
 		break;
 
-	case LINE6_PODXTLIVE:
-		switch (interface_number) {
-		case PODXTLIVE_INTERFACE_POD:
-			size = sizeof(struct usb_line6_pod);
-			ep_read = 0x84;
-			ep_write = 0x03;
-			break;
-
-		case PODXTLIVE_INTERFACE_VARIAX:
-			size = sizeof(struct usb_line6_variax);
-			ep_read = 0x86;
-			ep_write = 0x05;
-			break;
+	case LINE6_PODXTLIVE_POD:
+		size = sizeof(struct usb_line6_pod);
+		ep_read = 0x84;
+		ep_write = 0x03;
+		break;
 
-		default:
-			ret = -ENODEV;
-			goto err_put;
-		}
+	case LINE6_PODXTLIVE_VARIAX:
+		size = sizeof(struct usb_line6_variax);
+		ep_read = 0x86;
+		ep_write = 0x05;
 		break;
 
 	case LINE6_VARIAX:
@@ -887,7 +880,6 @@ static int line6_probe(struct usb_interface *interface,
 	}
 
 	/* store basic data: */
-	line6->interface_number = interface_number;
 	line6->properties = properties;
 	line6->usbdev = usbdev;
 	line6->ifcdev = &interface->dev;
@@ -967,27 +959,16 @@ static int line6_probe(struct usb_interface *interface,
 				       (struct usb_line6_podhd *)line6);
 		break;
 
-	case LINE6_PODXTLIVE:
-		switch (interface_number) {
-		case PODXTLIVE_INTERFACE_POD:
-			ret =
-			    line6_pod_init(interface,
-					   (struct usb_line6_pod *)line6);
-			break;
-
-		case PODXTLIVE_INTERFACE_VARIAX:
-			ret =
-			    line6_variax_init(interface,
-					      (struct usb_line6_variax *)line6);
-			break;
-
-		default:
-			dev_err(&interface->dev,
-				"PODxt Live interface %d not supported\n",
-				interface_number);
-			ret = -ENODEV;
-		}
+	case LINE6_PODXTLIVE_POD:
+		ret =
+		    line6_pod_init(interface,
+				   (struct usb_line6_pod *)line6);
+		break;
 
+	case LINE6_PODXTLIVE_VARIAX:
+		ret =
+		    line6_variax_init(interface,
+				      (struct usb_line6_variax *)line6);
 		break;
 
 	case LINE6_VARIAX:
@@ -1084,17 +1065,12 @@ static void line6_disconnect(struct usb_interface *interface)
 			line6_podhd_disconnect(interface);
 			break;
 
-		case LINE6_PODXTLIVE:
-			switch (interface_number) {
-			case PODXTLIVE_INTERFACE_POD:
-				line6_pod_disconnect(interface);
-				break;
-
-			case PODXTLIVE_INTERFACE_VARIAX:
-				line6_variax_disconnect(interface);
-				break;
-			}
+		case LINE6_PODXTLIVE_POD:
+			line6_pod_disconnect(interface);
+			break;
 
+		case LINE6_PODXTLIVE_VARIAX:
+			line6_variax_disconnect(interface);
 			break;
 
 		case LINE6_VARIAX:
diff --git a/drivers/staging/line6/driver.h b/drivers/staging/line6/driver.h
index c536795..085aa44 100644
--- a/drivers/staging/line6/driver.h
+++ b/drivers/staging/line6/driver.h
@@ -33,7 +33,8 @@ enum line6_device_type {
 	LINE6_PODSTUDIO_UX1,
 	LINE6_PODSTUDIO_UX2,
 	LINE6_PODXT,
-	LINE6_PODXTLIVE,
+	LINE6_PODXTLIVE_POD,
+	LINE6_PODXTLIVE_VARIAX,
 	LINE6_PODXTPRO,
 	LINE6_TONEPORT_GX,
 	LINE6_TONEPORT_UX1,
@@ -136,11 +137,6 @@ struct usb_line6 {
 	const struct line6_properties *properties;
 
 	/**
-		 Interface number.
-	*/
-	int interface_number;
-
-	/**
 		 Interval (ms).
 	*/
 	int interval;
diff --git a/drivers/staging/line6/pcm.c b/drivers/staging/line6/pcm.c
index e09772f..d09d1ea 100644
--- a/drivers/staging/line6/pcm.c
+++ b/drivers/staging/line6/pcm.c
@@ -433,7 +433,8 @@ int line6_init_pcm(struct usb_line6 *line6,
 	case LINE6_BASSPODXTLIVE:
 	case LINE6_BASSPODXTPRO:
 	case LINE6_PODXT:
-	case LINE6_PODXTLIVE:
+	case LINE6_PODXTLIVE_POD:
+	case LINE6_PODXTLIVE_VARIAX:
 	case LINE6_PODXTPRO:
 	case LINE6_PODHD300:
 	case LINE6_PODHD400:
diff --git a/drivers/staging/line6/pod.h b/drivers/staging/line6/pod.h
index 397d94c..91fd4c5 100644
--- a/drivers/staging/line6/pod.h
+++ b/drivers/staging/line6/pod.h
@@ -21,12 +21,6 @@
 #include "driver.h"
 
 /*
-	PODxt Live interfaces
-*/
-#define PODXTLIVE_INTERFACE_POD    0
-#define PODXTLIVE_INTERFACE_VARIAX 1
-
-/*
 	Locate name in binary program dump
 */
 #define	POD_NAME_OFFSET 0
-- 
2.1.0

