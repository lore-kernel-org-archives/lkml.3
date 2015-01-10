Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbbAJFhI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 00:37:08 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:38296 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540AbbAJFhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 00:37:05 -0500
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
Subject: [PATCH 23/25] staging: line6: Call *_process_message() via pointer
Date: Fri,  9 Jan 2015 23:36:09 -0600
Message-Id: <1420868171-2031-24-git-send-email-chris@rorvick.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420868171-2031-1-git-send-email-chris@rorvick.com>
References: <1420868171-2031-1-git-send-email-chris@rorvick.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Which *_process_message() function (if any) to call when data is
received is known at initialization.  Add a function pointer to the
`usb_line6' struct and use to call into the appropriate logic instead
of evaluating the conditional logic for each message.

Signed-off-by: Chris Rorvick <chris@rorvick.com>
---
 drivers/staging/line6/driver.c | 33 ++-------------------------------
 drivers/staging/line6/driver.h |  2 ++
 drivers/staging/line6/pod.c    |  4 +++-
 drivers/staging/line6/pod.h    |  1 -
 drivers/staging/line6/variax.c |  4 +++-
 drivers/staging/line6/variax.h |  1 -
 6 files changed, 10 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/line6/driver.c b/drivers/staging/line6/driver.c
index 369e60e..f7629cb 100644
--- a/drivers/staging/line6/driver.c
+++ b/drivers/staging/line6/driver.c
@@ -537,37 +537,8 @@ static void line6_data_received(struct urb *urb)
 		line6->message_length = done;
 		line6_midi_receive(line6, line6->buffer_message, done);
 
-		switch (line6->type) {
-		case LINE6_BASSPODXT:
-		case LINE6_BASSPODXTLIVE:
-		case LINE6_BASSPODXTPRO:
-		case LINE6_PODXT:
-		case LINE6_PODXTPRO:
-		case LINE6_POCKETPOD:
-			line6_pod_process_message(line6);
-			break;
-
-		case LINE6_PODHD300:
-		case LINE6_PODHD400:
-		case LINE6_PODHD500_0:
-		case LINE6_PODHD500_1:
-			break; /* let userspace handle MIDI */
-
-		case LINE6_PODXTLIVE_POD:
-			line6_pod_process_message(line6);
-			break;
-
-		case LINE6_PODXTLIVE_VARIAX:
-			line6_variax_process_message(line6);
-			break;
-
-		case LINE6_VARIAX:
-			line6_variax_process_message(line6);
-			break;
-
-		default:
-			MISSING_CASE;
-		}
+		if (line6->process_message)
+			line6->process_message(line6);
 	}
 
 	line6_start_listen(line6);
diff --git a/drivers/staging/line6/driver.h b/drivers/staging/line6/driver.h
index a4bde71..220813f 100644
--- a/drivers/staging/line6/driver.h
+++ b/drivers/staging/line6/driver.h
@@ -194,6 +194,8 @@ struct usb_line6 {
 		 Length of message to be processed.
 	*/
 	int message_length;
+
+	void (*process_message)(struct usb_line6 *);
 };
 
 extern char *line6_alloc_sysex_buffer(struct usb_line6 *line6, int code1,
diff --git a/drivers/staging/line6/pod.c b/drivers/staging/line6/pod.c
index aa8977d..79dcff4 100644
--- a/drivers/staging/line6/pod.c
+++ b/drivers/staging/line6/pod.c
@@ -131,7 +131,7 @@ static char *pod_alloc_sysex_buffer(struct usb_line6_pod *pod, int code,
 /*
 	Process a completely received message.
 */
-void line6_pod_process_message(struct usb_line6 *line6)
+static void line6_pod_process_message(struct usb_line6 *line6)
 {
 	struct usb_line6_pod *pod = (struct usb_line6_pod *) line6;
 	const unsigned char *buf = pod->line6.buffer_message;
@@ -359,6 +359,8 @@ static int pod_try_init(struct usb_interface *interface,
 	int err;
 	struct usb_line6_pod *pod = (struct usb_line6_pod *) line6;
 
+	line6->process_message = line6_pod_process_message;
+
 	init_timer(&pod->startup_timer);
 	INIT_WORK(&pod->startup_work, pod_startup4);
 
diff --git a/drivers/staging/line6/pod.h b/drivers/staging/line6/pod.h
index 984a00b..0d78ca7 100644
--- a/drivers/staging/line6/pod.h
+++ b/drivers/staging/line6/pod.h
@@ -89,6 +89,5 @@ struct usb_line6_pod {
 extern void line6_pod_disconnect(struct usb_interface *interface);
 extern int line6_pod_init(struct usb_interface *interface,
 			  struct usb_line6 *line6);
-extern void line6_pod_process_message(struct usb_line6 *line6);
 
 #endif
diff --git a/drivers/staging/line6/variax.c b/drivers/staging/line6/variax.c
index 4d41994..ccb1f68 100644
--- a/drivers/staging/line6/variax.c
+++ b/drivers/staging/line6/variax.c
@@ -130,7 +130,7 @@ static void variax_startup6(struct work_struct *work)
 /*
 	Process a completely received message.
 */
-void line6_variax_process_message(struct usb_line6 *line6)
+static void line6_variax_process_message(struct usb_line6 *line6)
 {
 	struct usb_line6_variax *variax = (struct usb_line6_variax *) line6;
 	const unsigned char *buf = variax->line6.buffer_message;
@@ -180,6 +180,8 @@ static int variax_try_init(struct usb_interface *interface,
 	struct usb_line6_variax *variax = (struct usb_line6_variax *) line6;
 	int err;
 
+	line6->process_message = line6_variax_process_message;
+
 	init_timer(&variax->startup_timer1);
 	init_timer(&variax->startup_timer2);
 	INIT_WORK(&variax->startup_work, variax_startup6);
diff --git a/drivers/staging/line6/variax.h b/drivers/staging/line6/variax.h
index 7d445ff..f21ff20 100644
--- a/drivers/staging/line6/variax.h
+++ b/drivers/staging/line6/variax.h
@@ -67,6 +67,5 @@ struct usb_line6_variax {
 extern void line6_variax_disconnect(struct usb_interface *interface);
 extern int line6_variax_init(struct usb_interface *interface,
 			     struct usb_line6 *line6);
-extern void line6_variax_process_message(struct usb_line6 *line6);
 
 #endif
-- 
2.1.0

