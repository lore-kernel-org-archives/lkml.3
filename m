Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbbAJFhM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 00:37:12 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:61312 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755036AbbAJFhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 00:37:04 -0500
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
Subject: [PATCH 22/25] staging: line6: Pass *_process_message() `usb_line6' pointers
Date: Fri,  9 Jan 2015 23:36:08 -0600
Message-Id: <1420868171-2031-23-git-send-email-chris@rorvick.com>
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
 drivers/staging/line6/driver.c | 13 ++++---------
 drivers/staging/line6/pod.c    |  3 ++-
 drivers/staging/line6/pod.h    |  2 +-
 drivers/staging/line6/variax.c |  3 ++-
 drivers/staging/line6/variax.h |  2 +-
 5 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/line6/driver.c b/drivers/staging/line6/driver.c
index 08f8051..369e60e 100644
--- a/drivers/staging/line6/driver.c
+++ b/drivers/staging/line6/driver.c
@@ -544,8 +544,7 @@ static void line6_data_received(struct urb *urb)
 		case LINE6_PODXT:
 		case LINE6_PODXTPRO:
 		case LINE6_POCKETPOD:
-			line6_pod_process_message((struct usb_line6_pod *)
-						  line6);
+			line6_pod_process_message(line6);
 			break;
 
 		case LINE6_PODHD300:
@@ -555,19 +554,15 @@ static void line6_data_received(struct urb *urb)
 			break; /* let userspace handle MIDI */
 
 		case LINE6_PODXTLIVE_POD:
-			line6_pod_process_message((struct usb_line6_pod
-							   *)line6);
+			line6_pod_process_message(line6);
 			break;
 
 		case LINE6_PODXTLIVE_VARIAX:
-			line6_variax_process_message((struct
-						      usb_line6_variax
-						      *)line6);
+			line6_variax_process_message(line6);
 			break;
 
 		case LINE6_VARIAX:
-			line6_variax_process_message((struct usb_line6_variax *)
-						     line6);
+			line6_variax_process_message(line6);
 			break;
 
 		default:
diff --git a/drivers/staging/line6/pod.c b/drivers/staging/line6/pod.c
index 9292b72..aa8977d 100644
--- a/drivers/staging/line6/pod.c
+++ b/drivers/staging/line6/pod.c
@@ -131,8 +131,9 @@ static char *pod_alloc_sysex_buffer(struct usb_line6_pod *pod, int code,
 /*
 	Process a completely received message.
 */
-void line6_pod_process_message(struct usb_line6_pod *pod)
+void line6_pod_process_message(struct usb_line6 *line6)
 {
+	struct usb_line6_pod *pod = (struct usb_line6_pod *) line6;
 	const unsigned char *buf = pod->line6.buffer_message;
 
 	if (memcmp(buf, pod_version_header, sizeof(pod_version_header)) == 0) {
diff --git a/drivers/staging/line6/pod.h b/drivers/staging/line6/pod.h
index cf6c75cd..984a00b 100644
--- a/drivers/staging/line6/pod.h
+++ b/drivers/staging/line6/pod.h
@@ -89,6 +89,6 @@ struct usb_line6_pod {
 extern void line6_pod_disconnect(struct usb_interface *interface);
 extern int line6_pod_init(struct usb_interface *interface,
 			  struct usb_line6 *line6);
-extern void line6_pod_process_message(struct usb_line6_pod *pod);
+extern void line6_pod_process_message(struct usb_line6 *line6);
 
 #endif
diff --git a/drivers/staging/line6/variax.c b/drivers/staging/line6/variax.c
index f5b618b..4d41994 100644
--- a/drivers/staging/line6/variax.c
+++ b/drivers/staging/line6/variax.c
@@ -130,8 +130,9 @@ static void variax_startup6(struct work_struct *work)
 /*
 	Process a completely received message.
 */
-void line6_variax_process_message(struct usb_line6_variax *variax)
+void line6_variax_process_message(struct usb_line6 *line6)
 {
+	struct usb_line6_variax *variax = (struct usb_line6_variax *) line6;
 	const unsigned char *buf = variax->line6.buffer_message;
 
 	switch (buf[0]) {
diff --git a/drivers/staging/line6/variax.h b/drivers/staging/line6/variax.h
index 9bf1464..7d445ff 100644
--- a/drivers/staging/line6/variax.h
+++ b/drivers/staging/line6/variax.h
@@ -67,6 +67,6 @@ struct usb_line6_variax {
 extern void line6_variax_disconnect(struct usb_interface *interface);
 extern int line6_variax_init(struct usb_interface *interface,
 			     struct usb_line6 *line6);
-extern void line6_variax_process_message(struct usb_line6_variax *variax);
+extern void line6_variax_process_message(struct usb_line6 *line6);
 
 #endif
-- 
2.1.0

