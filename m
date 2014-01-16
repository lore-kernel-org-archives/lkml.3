Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbaAPEd2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 23:33:28 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:45789 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbaAPEdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 23:33:24 -0500
From: David Fries <David@Fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>, GregKH <greg@kroah.com>
Subject: [PATCH 10/15] w1: ds2490 reduce magic numbers
Date: Wed, 15 Jan 2014 22:29:21 -0600
Message-Id: <1389846566-28862-11-git-send-email-David@Fries.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1389846566-28862-1-git-send-email-David@Fries.net>
References: <1389846566-28862-1-git-send-email-David@Fries.net>
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Wed, 15 Jan 2014 22:33:17 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a #define for the usb vendor request type, clear the status
byte and use that instead of a magic offset in checking if idle.

Signed-off-by: David Fries <David@Fries.net>
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
---
 drivers/w1/masters/ds2490.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/w1/masters/ds2490.c b/drivers/w1/masters/ds2490.c
index 4f7e1d7..6a3d0a1 100644
--- a/drivers/w1/masters/ds2490.c
+++ b/drivers/w1/masters/ds2490.c
@@ -1,5 +1,5 @@
 /*
- *	dscore.c
+ *	ds2490.c  USB to one wire bridge
  *
  * Copyright (c) 2004 Evgeniy Polyakov <zbr@ioremap.net>
  *
@@ -28,6 +28,10 @@
 #include "../w1_int.h"
 #include "../w1.h"
 
+/* USB Standard */
+/* USB Control request vendor type */
+#define VENDOR				0x40
+
 /* COMMAND TYPE CODES */
 #define CONTROL_CMD			0x00
 #define COMM_CMD			0x01
@@ -107,6 +111,8 @@
 #define ST_HALT				0x10  /* DS2490 is currently halted */
 #define ST_IDLE				0x20  /* DS2490 is currently idle */
 #define ST_EPOF				0x80
+/* Status transfer size, 16 bytes status, 16 byte result flags */
+#define ST_SIZE				0x20
 
 /* Result Register flags */
 #define RR_DETECT			0xA5 /* New device detected */
@@ -198,7 +204,7 @@ static int ds_send_control_cmd(struct ds_device *dev, u16 value, u16 index)
 	int err;
 
 	err = usb_control_msg(dev->udev, usb_sndctrlpipe(dev->udev, dev->ep[EP_CONTROL]),
-			CONTROL_CMD, 0x40, value, index, NULL, 0, 1000);
+			CONTROL_CMD, VENDOR, value, index, NULL, 0, 1000);
 	if (err < 0) {
 		printk(KERN_ERR "Failed to send command control message %x.%x: err=%d.\n",
 				value, index, err);
@@ -213,7 +219,7 @@ static int ds_send_control_mode(struct ds_device *dev, u16 value, u16 index)
 	int err;
 
 	err = usb_control_msg(dev->udev, usb_sndctrlpipe(dev->udev, dev->ep[EP_CONTROL]),
-			MODE_CMD, 0x40, value, index, NULL, 0, 1000);
+			MODE_CMD, VENDOR, value, index, NULL, 0, 1000);
 	if (err < 0) {
 		printk(KERN_ERR "Failed to send mode control message %x.%x: err=%d.\n",
 				value, index, err);
@@ -228,7 +234,7 @@ static int ds_send_control(struct ds_device *dev, u16 value, u16 index)
 	int err;
 
 	err = usb_control_msg(dev->udev, usb_sndctrlpipe(dev->udev, dev->ep[EP_CONTROL]),
-			COMM_CMD, 0x40, value, index, NULL, 0, 1000);
+			COMM_CMD, VENDOR, value, index, NULL, 0, 1000);
 	if (err < 0) {
 		printk(KERN_ERR "Failed to send control message %x.%x: err=%d.\n",
 				value, index, err);
@@ -353,7 +359,7 @@ static int ds_recv_data(struct ds_device *dev, unsigned char *buf, int size)
 	err = usb_bulk_msg(dev->udev, usb_rcvbulkpipe(dev->udev, dev->ep[EP_DATA_IN]),
 				buf, size, &count, 1000);
 	if (err < 0) {
-		u8 buf[0x20];
+		u8 buf[ST_SIZE];
 		int count;
 
 		printk(KERN_INFO "Clearing ep0x%x.\n", dev->ep[EP_DATA_IN]);
@@ -398,7 +404,7 @@ int ds_stop_pulse(struct ds_device *dev, int limit)
 {
 	struct ds_status st;
 	int count = 0, err = 0;
-	u8 buf[0x20];
+	u8 buf[ST_SIZE];
 
 	do {
 		err = ds_send_control(dev, CTL_HALT_EXE_IDLE, 0);
@@ -450,10 +456,11 @@ int ds_detect(struct ds_device *dev, struct ds_status *st)
 
 static int ds_wait_status(struct ds_device *dev, struct ds_status *st)
 {
-	u8 buf[0x20];
+	u8 buf[ST_SIZE];
 	int err, count = 0;
 
 	do {
+		st->status = 0;
 		err = ds_recv_status_nodump(dev, st, buf, sizeof(buf));
 #if 0
 		if (err >= 0) {
@@ -464,7 +471,7 @@ static int ds_wait_status(struct ds_device *dev, struct ds_status *st)
 			printk("\n");
 		}
 #endif
-	} while (!(buf[0x08] & ST_IDLE) && !(err < 0) && ++count < 100);
+	} while (!(st->status & ST_IDLE) && !(err < 0) && ++count < 100);
 
 	if (err >= 16 && st->status & ST_EPOF) {
 		printk(KERN_INFO "Resetting device after ST_EPOF.\n");
-- 
1.7.10.4

