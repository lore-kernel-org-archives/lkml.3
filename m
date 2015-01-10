Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922AbbAJFig (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 00:38:36 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:39007 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811AbbAJFhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 00:37:02 -0500
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
Subject: [PATCH 21/25] staging: line6: Pass *_init() `usb_line6' pointers
Date: Fri,  9 Jan 2015 23:36:07 -0600
Message-Id: <1420868171-2031-22-git-send-email-chris@rorvick.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420868171-2031-1-git-send-email-chris@rorvick.com>
References: <1420868171-2031-1-git-send-email-chris@rorvick.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casting the `struct usb_line6' pointer at the call point makes the code
difficult to read.  This is substantially cleaned up by moving the cast
into the callees.

Signed-off-by: Chris Rorvick <chris@rorvick.com>
---
 drivers/staging/line6/driver.c   | 21 ++++++---------------
 drivers/staging/line6/pod.c      |  8 ++++----
 drivers/staging/line6/pod.h      |  2 +-
 drivers/staging/line6/podhd.c    |  4 ++--
 drivers/staging/line6/podhd.h    |  2 +-
 drivers/staging/line6/toneport.c |  8 ++++----
 drivers/staging/line6/toneport.h |  2 +-
 drivers/staging/line6/variax.c   |  8 ++++----
 drivers/staging/line6/variax.h   |  2 +-
 9 files changed, 24 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/line6/driver.c b/drivers/staging/line6/driver.c
index 4bfef21..08f8051 100644
--- a/drivers/staging/line6/driver.c
+++ b/drivers/staging/line6/driver.c
@@ -959,33 +959,26 @@ static int line6_probe(struct usb_interface *interface,
 	case LINE6_POCKETPOD:
 	case LINE6_PODXT:
 	case LINE6_PODXTPRO:
-		ret = line6_pod_init(interface, (struct usb_line6_pod *)line6);
+		ret = line6_pod_init(interface, line6);
 		break;
 
 	case LINE6_PODHD300:
 	case LINE6_PODHD400:
 	case LINE6_PODHD500_0:
 	case LINE6_PODHD500_1:
-		ret = line6_podhd_init(interface,
-				       (struct usb_line6_podhd *)line6);
+		ret = line6_podhd_init(interface, line6);
 		break;
 
 	case LINE6_PODXTLIVE_POD:
-		ret =
-		    line6_pod_init(interface,
-				   (struct usb_line6_pod *)line6);
+		ret = line6_pod_init(interface, line6);
 		break;
 
 	case LINE6_PODXTLIVE_VARIAX:
-		ret =
-		    line6_variax_init(interface,
-				      (struct usb_line6_variax *)line6);
+		ret = line6_variax_init(interface, line6);
 		break;
 
 	case LINE6_VARIAX:
-		ret =
-		    line6_variax_init(interface,
-				      (struct usb_line6_variax *)line6);
+		ret = line6_variax_init(interface, line6);
 		break;
 
 	case LINE6_PODSTUDIO_GX:
@@ -995,9 +988,7 @@ static int line6_probe(struct usb_interface *interface,
 	case LINE6_TONEPORT_UX1:
 	case LINE6_TONEPORT_UX2:
 	case LINE6_GUITARPORT:
-		ret =
-		    line6_toneport_init(interface,
-					(struct usb_line6_toneport *)line6);
+		ret = line6_toneport_init(interface, line6);
 		break;
 
 	default:
diff --git a/drivers/staging/line6/pod.c b/drivers/staging/line6/pod.c
index 0fb1788..9292b72 100644
--- a/drivers/staging/line6/pod.c
+++ b/drivers/staging/line6/pod.c
@@ -353,10 +353,10 @@ static int pod_create_files2(struct device *dev)
 	 Try to init POD device.
 */
 static int pod_try_init(struct usb_interface *interface,
-			struct usb_line6_pod *pod)
+			struct usb_line6 *line6)
 {
 	int err;
-	struct usb_line6 *line6 = &pod->line6;
+	struct usb_line6_pod *pod = (struct usb_line6_pod *) line6;
 
 	init_timer(&pod->startup_timer);
 	INIT_WORK(&pod->startup_work, pod_startup4);
@@ -409,9 +409,9 @@ static int pod_try_init(struct usb_interface *interface,
 /*
 	 Init POD device (and clean up in case of failure).
 */
-int line6_pod_init(struct usb_interface *interface, struct usb_line6_pod *pod)
+int line6_pod_init(struct usb_interface *interface, struct usb_line6 *line6)
 {
-	int err = pod_try_init(interface, pod);
+	int err = pod_try_init(interface, line6);
 
 	if (err < 0)
 		pod_destruct(interface);
diff --git a/drivers/staging/line6/pod.h b/drivers/staging/line6/pod.h
index 91fd4c5..cf6c75cd 100644
--- a/drivers/staging/line6/pod.h
+++ b/drivers/staging/line6/pod.h
@@ -88,7 +88,7 @@ struct usb_line6_pod {
 
 extern void line6_pod_disconnect(struct usb_interface *interface);
 extern int line6_pod_init(struct usb_interface *interface,
-			  struct usb_line6_pod *pod);
+			  struct usb_line6 *line6);
 extern void line6_pod_process_message(struct usb_line6_pod *pod);
 
 #endif
diff --git a/drivers/staging/line6/podhd.c b/drivers/staging/line6/podhd.c
index 7ef4543..3bb942e 100644
--- a/drivers/staging/line6/podhd.c
+++ b/drivers/staging/line6/podhd.c
@@ -121,9 +121,9 @@ static int podhd_try_init(struct usb_interface *interface,
 /*
 	Init POD HD device (and clean up in case of failure).
 */
-int line6_podhd_init(struct usb_interface *interface,
-		     struct usb_line6_podhd *podhd)
+int line6_podhd_init(struct usb_interface *interface, struct usb_line6 *line6)
 {
+	struct usb_line6_podhd *podhd = (struct usb_line6_podhd *) line6;
 	int err = podhd_try_init(interface, podhd);
 
 	if (err < 0)
diff --git a/drivers/staging/line6/podhd.h b/drivers/staging/line6/podhd.h
index 652f740..b7d9568 100644
--- a/drivers/staging/line6/podhd.h
+++ b/drivers/staging/line6/podhd.h
@@ -25,6 +25,6 @@ struct usb_line6_podhd {
 
 extern void line6_podhd_disconnect(struct usb_interface *interface);
 extern int line6_podhd_init(struct usb_interface *interface,
-			    struct usb_line6_podhd *podhd);
+			    struct usb_line6 *line6);
 
 #endif /* PODHD_H */
diff --git a/drivers/staging/line6/toneport.c b/drivers/staging/line6/toneport.c
index a2607e7..70fba02 100644
--- a/drivers/staging/line6/toneport.c
+++ b/drivers/staging/line6/toneport.c
@@ -339,10 +339,10 @@ static void toneport_setup(struct usb_line6_toneport *toneport)
 	 Try to init Toneport device.
 */
 static int toneport_try_init(struct usb_interface *interface,
-			     struct usb_line6_toneport *toneport)
+			     struct usb_line6 *line6)
 {
 	int err;
-	struct usb_line6 *line6 = &toneport->line6;
+	struct usb_line6_toneport *toneport =  (struct usb_line6_toneport *) line6;
 
 	if ((interface == NULL) || (toneport == NULL))
 		return -ENODEV;
@@ -411,9 +411,9 @@ static int toneport_try_init(struct usb_interface *interface,
 	 Init Toneport device (and clean up in case of failure).
 */
 int line6_toneport_init(struct usb_interface *interface,
-			struct usb_line6_toneport *toneport)
+			struct usb_line6 *line6)
 {
-	int err = toneport_try_init(interface, toneport);
+	int err = toneport_try_init(interface, line6);
 
 	if (err < 0)
 		toneport_destruct(interface);
diff --git a/drivers/staging/line6/toneport.h b/drivers/staging/line6/toneport.h
index 8576b72..af2b4e0 100644
--- a/drivers/staging/line6/toneport.h
+++ b/drivers/staging/line6/toneport.h
@@ -46,7 +46,7 @@ struct usb_line6_toneport {
 
 extern void line6_toneport_disconnect(struct usb_interface *interface);
 extern int line6_toneport_init(struct usb_interface *interface,
-			       struct usb_line6_toneport *toneport);
+			       struct usb_line6 *line6);
 extern void line6_toneport_reset_resume(struct usb_line6_toneport *toneport);
 
 #endif
diff --git a/drivers/staging/line6/variax.c b/drivers/staging/line6/variax.c
index ae2be99..f5b618b 100644
--- a/drivers/staging/line6/variax.c
+++ b/drivers/staging/line6/variax.c
@@ -174,8 +174,9 @@ static void variax_destruct(struct usb_interface *interface)
 	 Try to init workbench device.
 */
 static int variax_try_init(struct usb_interface *interface,
-			   struct usb_line6_variax *variax)
+			   struct usb_line6 *line6)
 {
+	struct usb_line6_variax *variax = (struct usb_line6_variax *) line6;
 	int err;
 
 	init_timer(&variax->startup_timer1);
@@ -212,10 +213,9 @@ static int variax_try_init(struct usb_interface *interface,
 /*
 	 Init workbench device (and clean up in case of failure).
 */
-int line6_variax_init(struct usb_interface *interface,
-		      struct usb_line6_variax *variax)
+int line6_variax_init(struct usb_interface *interface, struct usb_line6 *line6)
 {
-	int err = variax_try_init(interface, variax);
+	int err = variax_try_init(interface, line6);
 
 	if (err < 0)
 		variax_destruct(interface);
diff --git a/drivers/staging/line6/variax.h b/drivers/staging/line6/variax.h
index 24de796..9bf1464 100644
--- a/drivers/staging/line6/variax.h
+++ b/drivers/staging/line6/variax.h
@@ -66,7 +66,7 @@ struct usb_line6_variax {
 
 extern void line6_variax_disconnect(struct usb_interface *interface);
 extern int line6_variax_init(struct usb_interface *interface,
-			     struct usb_line6_variax *variax);
+			     struct usb_line6 *line6);
 extern void line6_variax_process_message(struct usb_line6_variax *variax);
 
 #endif
-- 
2.1.0

