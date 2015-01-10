Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909AbbAJFj4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 00:39:56 -0500
Received: from mail-ig0-f170.google.com ([209.85.213.170]:43102 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473AbbAJFgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 00:36:50 -0500
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
Subject: [PATCH 14/25] staging: line6: Split out POD HD500 interfaces
Date: Fri,  9 Jan 2015 23:36:00 -0600
Message-Id: <1420868171-2031-15-git-send-email-chris@rorvick.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420868171-2031-1-git-send-email-chris@rorvick.com>
References: <1420868171-2031-1-git-send-email-chris@rorvick.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver uses a different altsetting depending on the interface.  Add
device type entries for each of these.

Signed-off-by: Chris Rorvick <chris@rorvick.com>
---
 drivers/staging/line6/driver.c | 41 ++++++++++++++++++++++++-----------------
 drivers/staging/line6/driver.h |  3 ++-
 drivers/staging/line6/pcm.c    |  3 ++-
 3 files changed, 28 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/line6/driver.c b/drivers/staging/line6/driver.c
index cb96029..e97e2cb 100644
--- a/drivers/staging/line6/driver.c
+++ b/drivers/staging/line6/driver.c
@@ -42,7 +42,8 @@ static const struct usb_device_id line6_id_table[] = {
 	{ LINE6_DEVICE(0x5051),    .driver_info = LINE6_POCKETPOD },
 	{ LINE6_DEVICE(0x5057),    .driver_info = LINE6_PODHD300 },
 	{ LINE6_DEVICE(0x5058),    .driver_info = LINE6_PODHD400 },
-	{ LINE6_DEVICE(0x414D),    .driver_info = LINE6_PODHD500 },
+	{ LINE6_IF_NUM(0x414D, 0), .driver_info = LINE6_PODHD500_0 },
+	{ LINE6_IF_NUM(0x414D, 1), .driver_info = LINE6_PODHD500_1 },
 	{ LINE6_DEVICE(0x4153),    .driver_info = LINE6_PODSTUDIO_GX },
 	{ LINE6_DEVICE(0x4150),    .driver_info = LINE6_PODSTUDIO_UX1 },
 	{ LINE6_DEVICE(0x4151),    .driver_info = LINE6_PODSTUDIO_UX2 },
@@ -105,7 +106,14 @@ static const struct line6_properties line6_properties_table[] = {
 				| LINE6_CAP_PCM
 				| LINE6_CAP_HWMON,
 	},
-	[LINE6_PODHD500] = {
+	[LINE6_PODHD500_0] = {
+		.id = "PODHD500",
+		.name = "POD HD500",
+		.capabilities	= LINE6_CAP_CONTROL
+				| LINE6_CAP_PCM
+				| LINE6_CAP_HWMON,
+	},
+	[LINE6_PODHD500_1] = {
 		.id = "PODHD500",
 		.name = "POD HD500",
 		.capabilities	= LINE6_CAP_CONTROL
@@ -451,7 +459,8 @@ static void line6_data_received(struct urb *urb)
 
 		case LINE6_PODHD300:
 		case LINE6_PODHD400:
-		case LINE6_PODHD500:
+		case LINE6_PODHD500_0:
+		case LINE6_PODHD500_1:
 			break; /* let userspace handle MIDI */
 
 		case LINE6_PODXTLIVE_POD:
@@ -740,17 +749,12 @@ static int line6_probe(struct usb_interface *interface,
 		}
 		break;
 
-	case LINE6_PODHD500:
-		switch (interface_number) {
-		case 0:
-			alternate = 1;
-			break;
-		case 1:
-			alternate = 0;
-			break;
-		default:
-			MISSING_CASE;
-		}
+	case LINE6_PODHD500_0:
+		alternate = 1;
+		break;
+
+	case LINE6_PODHD500_1:
+		alternate = 0;
 		break;
 
 	case LINE6_BASSPODXT:
@@ -819,7 +823,8 @@ static int line6_probe(struct usb_interface *interface,
 		ep_write = 0x03;
 		break;
 
-	case LINE6_PODHD500:
+	case LINE6_PODHD500_0:
+	case LINE6_PODHD500_1:
 		size = sizeof(struct usb_line6_podhd);
 		ep_read = 0x81;
 		ep_write = 0x01;
@@ -954,7 +959,8 @@ static int line6_probe(struct usb_interface *interface,
 
 	case LINE6_PODHD300:
 	case LINE6_PODHD400:
-	case LINE6_PODHD500:
+	case LINE6_PODHD500_0:
+	case LINE6_PODHD500_1:
 		ret = line6_podhd_init(interface,
 				       (struct usb_line6_podhd *)line6);
 		break;
@@ -1061,7 +1067,8 @@ static void line6_disconnect(struct usb_interface *interface)
 
 		case LINE6_PODHD300:
 		case LINE6_PODHD400:
-		case LINE6_PODHD500:
+		case LINE6_PODHD500_0:
+		case LINE6_PODHD500_1:
 			line6_podhd_disconnect(interface);
 			break;
 
diff --git a/drivers/staging/line6/driver.h b/drivers/staging/line6/driver.h
index 085aa44..9d6b351 100644
--- a/drivers/staging/line6/driver.h
+++ b/drivers/staging/line6/driver.h
@@ -28,7 +28,8 @@ enum line6_device_type {
 	LINE6_POCKETPOD,
 	LINE6_PODHD300,
 	LINE6_PODHD400,
-	LINE6_PODHD500,
+	LINE6_PODHD500_0,
+	LINE6_PODHD500_1,
 	LINE6_PODSTUDIO_GX,
 	LINE6_PODSTUDIO_UX1,
 	LINE6_PODSTUDIO_UX2,
diff --git a/drivers/staging/line6/pcm.c b/drivers/staging/line6/pcm.c
index d09d1ea..d8450af 100644
--- a/drivers/staging/line6/pcm.c
+++ b/drivers/staging/line6/pcm.c
@@ -442,7 +442,8 @@ int line6_init_pcm(struct usb_line6 *line6,
 		ep_write = 0x01;
 		break;
 
-	case LINE6_PODHD500:
+	case LINE6_PODHD500_0:
+	case LINE6_PODHD500_1:
 		ep_read = 0x86;
 		ep_write = 0x02;
 		break;
-- 
2.1.0

