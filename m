Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900AbbAJFhj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 00:37:39 -0500
Received: from mail-ig0-f171.google.com ([209.85.213.171]:48058 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220AbbAJFhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 00:37:08 -0500
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
Subject: [PATCH 25/25] staging: line6: Make *_disconnect() functions static
Date: Fri,  9 Jan 2015 23:36:11 -0600
Message-Id: <1420868171-2031-26-git-send-email-chris@rorvick.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420868171-2031-1-git-send-email-chris@rorvick.com>
References: <1420868171-2031-1-git-send-email-chris@rorvick.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove declarations from the header and move the definitions up in the
source so they need not be forward declared.

Signed-off-by: Chris Rorvick <chris@rorvick.com>
---
 drivers/staging/line6/pod.c      | 58 ++++++++++++++++++------------------
 drivers/staging/line6/pod.h      |  1 -
 drivers/staging/line6/podhd.c    | 42 +++++++++++++--------------
 drivers/staging/line6/podhd.h    |  1 -
 drivers/staging/line6/toneport.c | 63 +++++++++++++++++++++-------------------
 drivers/staging/line6/toneport.h |  1 -
 drivers/staging/line6/variax.c   | 22 +++++++-------
 drivers/staging/line6/variax.h   |  1 -
 8 files changed, 94 insertions(+), 95 deletions(-)

diff --git a/drivers/staging/line6/pod.c b/drivers/staging/line6/pod.c
index b9af5cf..85a4363 100644
--- a/drivers/staging/line6/pod.c
+++ b/drivers/staging/line6/pod.c
@@ -338,6 +338,35 @@ static void pod_destruct(struct usb_interface *interface)
 }
 
 /*
+	POD device disconnected.
+*/
+static void line6_pod_disconnect(struct usb_interface *interface)
+{
+	struct usb_line6_pod *pod;
+
+	if (interface == NULL)
+		return;
+	pod = usb_get_intfdata(interface);
+
+	if (pod != NULL) {
+		struct snd_line6_pcm *line6pcm = pod->line6.line6pcm;
+		struct device *dev = &interface->dev;
+
+		if (line6pcm != NULL)
+			line6_pcm_disconnect(line6pcm);
+
+		if (dev != NULL) {
+			/* remove sysfs entries: */
+			device_remove_file(dev, &dev_attr_device_id);
+			device_remove_file(dev, &dev_attr_firmware_version);
+			device_remove_file(dev, &dev_attr_serial_number);
+		}
+	}
+
+	pod_destruct(interface);
+}
+
+/*
 	Create sysfs entries.
 */
 static int pod_create_files2(struct device *dev)
@@ -422,32 +451,3 @@ int line6_pod_init(struct usb_interface *interface, struct usb_line6 *line6)
 
 	return err;
 }
-
-/*
-	POD device disconnected.
-*/
-void line6_pod_disconnect(struct usb_interface *interface)
-{
-	struct usb_line6_pod *pod;
-
-	if (interface == NULL)
-		return;
-	pod = usb_get_intfdata(interface);
-
-	if (pod != NULL) {
-		struct snd_line6_pcm *line6pcm = pod->line6.line6pcm;
-		struct device *dev = &interface->dev;
-
-		if (line6pcm != NULL)
-			line6_pcm_disconnect(line6pcm);
-
-		if (dev != NULL) {
-			/* remove sysfs entries: */
-			device_remove_file(dev, &dev_attr_device_id);
-			device_remove_file(dev, &dev_attr_firmware_version);
-			device_remove_file(dev, &dev_attr_serial_number);
-		}
-	}
-
-	pod_destruct(interface);
-}
diff --git a/drivers/staging/line6/pod.h b/drivers/staging/line6/pod.h
index 0d78ca7..87a8f0f 100644
--- a/drivers/staging/line6/pod.h
+++ b/drivers/staging/line6/pod.h
@@ -86,7 +86,6 @@ struct usb_line6_pod {
 	int device_id;
 };
 
-extern void line6_pod_disconnect(struct usb_interface *interface);
 extern int line6_pod_init(struct usb_interface *interface,
 			  struct usb_line6 *line6);
 
diff --git a/drivers/staging/line6/podhd.c b/drivers/staging/line6/podhd.c
index a57fbce..27c5402 100644
--- a/drivers/staging/line6/podhd.c
+++ b/drivers/staging/line6/podhd.c
@@ -87,6 +87,27 @@ static void podhd_destruct(struct usb_interface *interface)
 }
 
 /*
+	POD HD device disconnected.
+*/
+static void line6_podhd_disconnect(struct usb_interface *interface)
+{
+	struct usb_line6_podhd *podhd;
+
+	if (interface == NULL)
+		return;
+	podhd = usb_get_intfdata(interface);
+
+	if (podhd != NULL) {
+		struct snd_line6_pcm *line6pcm = podhd->line6.line6pcm;
+
+		if (line6pcm != NULL)
+			line6_pcm_disconnect(line6pcm);
+	}
+
+	podhd_destruct(interface);
+}
+
+/*
 	Try to init POD HD device.
 */
 static int podhd_try_init(struct usb_interface *interface,
@@ -133,24 +154,3 @@ int line6_podhd_init(struct usb_interface *interface, struct usb_line6 *line6)
 
 	return err;
 }
-
-/*
-	POD HD device disconnected.
-*/
-void line6_podhd_disconnect(struct usb_interface *interface)
-{
-	struct usb_line6_podhd *podhd;
-
-	if (interface == NULL)
-		return;
-	podhd = usb_get_intfdata(interface);
-
-	if (podhd != NULL) {
-		struct snd_line6_pcm *line6pcm = podhd->line6.line6pcm;
-
-		if (line6pcm != NULL)
-			line6_pcm_disconnect(line6pcm);
-	}
-
-	podhd_destruct(interface);
-}
diff --git a/drivers/staging/line6/podhd.h b/drivers/staging/line6/podhd.h
index b7d9568..a14f711 100644
--- a/drivers/staging/line6/podhd.h
+++ b/drivers/staging/line6/podhd.h
@@ -23,7 +23,6 @@ struct usb_line6_podhd {
 	struct usb_line6 line6;
 };
 
-extern void line6_podhd_disconnect(struct usb_interface *interface);
 extern int line6_podhd_init(struct usb_interface *interface,
 			    struct usb_line6 *line6);
 
diff --git a/drivers/staging/line6/toneport.c b/drivers/staging/line6/toneport.c
index 42c34eb..aae78d8 100644
--- a/drivers/staging/line6/toneport.c
+++ b/drivers/staging/line6/toneport.c
@@ -336,6 +336,39 @@ static void toneport_setup(struct usb_line6_toneport *toneport)
 }
 
 /*
+	Toneport device disconnected.
+*/
+static void line6_toneport_disconnect(struct usb_interface *interface)
+{
+	struct usb_line6_toneport *toneport;
+	u16 idProduct;
+
+	if (interface == NULL)
+		return;
+
+	toneport = usb_get_intfdata(interface);
+	del_timer_sync(&toneport->timer);
+	idProduct = le16_to_cpu(toneport->line6.usbdev->descriptor.idProduct);
+
+	if (toneport_has_led(idProduct)) {
+		device_remove_file(&interface->dev, &dev_attr_led_red);
+		device_remove_file(&interface->dev, &dev_attr_led_green);
+	}
+
+	if (toneport != NULL) {
+		struct snd_line6_pcm *line6pcm = toneport->line6.line6pcm;
+
+		if (line6pcm != NULL) {
+			line6_pcm_release(line6pcm, LINE6_BITS_PCM_MONITOR);
+			line6_pcm_disconnect(line6pcm);
+		}
+	}
+
+	toneport_destruct(interface);
+}
+
+
+/*
 	 Try to init Toneport device.
 */
 static int toneport_try_init(struct usb_interface *interface,
@@ -430,33 +463,3 @@ void line6_toneport_reset_resume(struct usb_line6_toneport *toneport)
 {
 	toneport_setup(toneport);
 }
-
-/*
-	Toneport device disconnected.
-*/
-void line6_toneport_disconnect(struct usb_interface *interface)
-{
-	struct usb_line6_toneport *toneport;
-
-	if (interface == NULL)
-		return;
-
-	toneport = usb_get_intfdata(interface);
-	del_timer_sync(&toneport->timer);
-
-	if (toneport_has_led(toneport->line6.type)) {
-		device_remove_file(&interface->dev, &dev_attr_led_red);
-		device_remove_file(&interface->dev, &dev_attr_led_green);
-	}
-
-	if (toneport != NULL) {
-		struct snd_line6_pcm *line6pcm = toneport->line6.line6pcm;
-
-		if (line6pcm != NULL) {
-			line6_pcm_release(line6pcm, LINE6_BITS_PCM_MONITOR);
-			line6_pcm_disconnect(line6pcm);
-		}
-	}
-
-	toneport_destruct(interface);
-}
diff --git a/drivers/staging/line6/toneport.h b/drivers/staging/line6/toneport.h
index af2b4e0..8cb1442 100644
--- a/drivers/staging/line6/toneport.h
+++ b/drivers/staging/line6/toneport.h
@@ -44,7 +44,6 @@ struct usb_line6_toneport {
 	struct timer_list timer;
 };
 
-extern void line6_toneport_disconnect(struct usb_interface *interface);
 extern int line6_toneport_init(struct usb_interface *interface,
 			       struct usb_line6 *line6);
 extern void line6_toneport_reset_resume(struct usb_line6_toneport *toneport);
diff --git a/drivers/staging/line6/variax.c b/drivers/staging/line6/variax.c
index ca25b41..b4a41b0 100644
--- a/drivers/staging/line6/variax.c
+++ b/drivers/staging/line6/variax.c
@@ -172,6 +172,17 @@ static void variax_destruct(struct usb_interface *interface)
 }
 
 /*
+	Workbench device disconnected.
+*/
+static void line6_variax_disconnect(struct usb_interface *interface)
+{
+	if (interface == NULL)
+		return;
+
+	variax_destruct(interface);
+}
+
+/*
 	 Try to init workbench device.
 */
 static int variax_try_init(struct usb_interface *interface,
@@ -226,14 +237,3 @@ int line6_variax_init(struct usb_interface *interface, struct usb_line6 *line6)
 
 	return err;
 }
-
-/*
-	Workbench device disconnected.
-*/
-void line6_variax_disconnect(struct usb_interface *interface)
-{
-	if (interface == NULL)
-		return;
-
-	variax_destruct(interface);
-}
diff --git a/drivers/staging/line6/variax.h b/drivers/staging/line6/variax.h
index f21ff20..dfb94e5 100644
--- a/drivers/staging/line6/variax.h
+++ b/drivers/staging/line6/variax.h
@@ -64,7 +64,6 @@ struct usb_line6_variax {
 	int startup_progress;
 };
 
-extern void line6_variax_disconnect(struct usb_interface *interface);
 extern int line6_variax_init(struct usb_interface *interface,
 			     struct usb_line6 *line6);
 
-- 
2.1.0

