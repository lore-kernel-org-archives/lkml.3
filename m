Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400AbbAJFiI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 00:38:08 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:48649 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123AbbAJFhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 00:37:06 -0500
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
Subject: [PATCH 24/25] staging: line6: Call *_disconnect() via pointer
Date: Fri,  9 Jan 2015 23:36:10 -0600
Message-Id: <1420868171-2031-25-git-send-email-chris@rorvick.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420868171-2031-1-git-send-email-chris@rorvick.com>
References: <1420868171-2031-1-git-send-email-chris@rorvick.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Which *_disconnect() to call on disconnect is known at initialization.
Add a function pointer to the `usb_line6' struct and use to call into
the appropriate logic instead of evaluating the conditional logic.

Signed-off-by: Chris Rorvick <chris@rorvick.com>
---
 drivers/staging/line6/driver.c   | 43 +---------------------------------------
 drivers/staging/line6/driver.h   |  1 +
 drivers/staging/line6/pod.c      |  1 +
 drivers/staging/line6/podhd.c    |  2 ++
 drivers/staging/line6/toneport.c |  2 ++
 drivers/staging/line6/variax.c   |  1 +
 6 files changed, 8 insertions(+), 42 deletions(-)

diff --git a/drivers/staging/line6/driver.c b/drivers/staging/line6/driver.c
index f7629cb..fc852f6 100644
--- a/drivers/staging/line6/driver.c
+++ b/drivers/staging/line6/driver.c
@@ -1017,48 +1017,7 @@ static void line6_disconnect(struct usb_interface *interface)
 			dev_err(line6->ifcdev,
 				"driver bug: inconsistent usb device\n");
 
-		switch (line6->type) {
-		case LINE6_BASSPODXT:
-		case LINE6_BASSPODXTLIVE:
-		case LINE6_BASSPODXTPRO:
-		case LINE6_POCKETPOD:
-		case LINE6_PODXT:
-		case LINE6_PODXTPRO:
-			line6_pod_disconnect(interface);
-			break;
-
-		case LINE6_PODHD300:
-		case LINE6_PODHD400:
-		case LINE6_PODHD500_0:
-		case LINE6_PODHD500_1:
-			line6_podhd_disconnect(interface);
-			break;
-
-		case LINE6_PODXTLIVE_POD:
-			line6_pod_disconnect(interface);
-			break;
-
-		case LINE6_PODXTLIVE_VARIAX:
-			line6_variax_disconnect(interface);
-			break;
-
-		case LINE6_VARIAX:
-			line6_variax_disconnect(interface);
-			break;
-
-		case LINE6_PODSTUDIO_GX:
-		case LINE6_PODSTUDIO_UX1:
-		case LINE6_PODSTUDIO_UX2:
-		case LINE6_TONEPORT_GX:
-		case LINE6_TONEPORT_UX1:
-		case LINE6_TONEPORT_UX2:
-		case LINE6_GUITARPORT:
-			line6_toneport_disconnect(interface);
-			break;
-
-		default:
-			MISSING_CASE;
-		}
+		line6->disconnect(interface);
 
 		dev_info(&interface->dev, "Line6 %s now disconnected\n",
 			 line6->properties->name);
diff --git a/drivers/staging/line6/driver.h b/drivers/staging/line6/driver.h
index 220813f..ad203f1 100644
--- a/drivers/staging/line6/driver.h
+++ b/drivers/staging/line6/driver.h
@@ -196,6 +196,7 @@ struct usb_line6 {
 	int message_length;
 
 	void (*process_message)(struct usb_line6 *);
+	void (*disconnect)(struct usb_interface *);
 };
 
 extern char *line6_alloc_sysex_buffer(struct usb_line6 *line6, int code1,
diff --git a/drivers/staging/line6/pod.c b/drivers/staging/line6/pod.c
index 79dcff4..b9af5cf 100644
--- a/drivers/staging/line6/pod.c
+++ b/drivers/staging/line6/pod.c
@@ -360,6 +360,7 @@ static int pod_try_init(struct usb_interface *interface,
 	struct usb_line6_pod *pod = (struct usb_line6_pod *) line6;
 
 	line6->process_message = line6_pod_process_message;
+	line6->disconnect = line6_pod_disconnect;
 
 	init_timer(&pod->startup_timer);
 	INIT_WORK(&pod->startup_work, pod_startup4);
diff --git a/drivers/staging/line6/podhd.c b/drivers/staging/line6/podhd.c
index 3bb942e..a57fbce 100644
--- a/drivers/staging/line6/podhd.c
+++ b/drivers/staging/line6/podhd.c
@@ -98,6 +98,8 @@ static int podhd_try_init(struct usb_interface *interface,
 	if ((interface == NULL) || (podhd == NULL))
 		return -ENODEV;
 
+	line6->disconnect = line6_podhd_disconnect;
+
 	/* initialize audio system: */
 	err = line6_init_audio(line6);
 	if (err < 0)
diff --git a/drivers/staging/line6/toneport.c b/drivers/staging/line6/toneport.c
index 70fba02..42c34eb 100644
--- a/drivers/staging/line6/toneport.c
+++ b/drivers/staging/line6/toneport.c
@@ -347,6 +347,8 @@ static int toneport_try_init(struct usb_interface *interface,
 	if ((interface == NULL) || (toneport == NULL))
 		return -ENODEV;
 
+	line6->disconnect = line6_toneport_disconnect;
+
 	/* initialize audio system: */
 	err = line6_init_audio(line6);
 	if (err < 0)
diff --git a/drivers/staging/line6/variax.c b/drivers/staging/line6/variax.c
index ccb1f68..ca25b41 100644
--- a/drivers/staging/line6/variax.c
+++ b/drivers/staging/line6/variax.c
@@ -181,6 +181,7 @@ static int variax_try_init(struct usb_interface *interface,
 	int err;
 
 	line6->process_message = line6_variax_process_message;
+	line6->disconnect = line6_variax_disconnect;
 
 	init_timer(&variax->startup_timer1);
 	init_timer(&variax->startup_timer2);
-- 
2.1.0

