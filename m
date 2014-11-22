Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbaKVAR1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 19:17:27 -0500
Received: from mailout.easymail.ca ([64.68.201.169]:50775 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356AbaKVAR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 19:17:26 -0500
X-Spam-Flag: NO
X-Spam-Score: -4.399
From: Shuah Khan <shuahkh@osg.samsung.com>
To: m.chehab@samsung.com, ttmesterr@gmail.com, dheitmueller@kernellabs.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media/au0828: Fix IR stop, poll to not access device during disconnect
Date: Fri, 21 Nov 2014 17:17:08 -0700
Message-Id: <1416615428-9010-1-git-send-email-shuahkh@osg.samsung.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

au0828 IR stop and poll routines continue to access device
while usb disconnect is in progress. There is small window
between device disconnect and usb interface is set to null.
This results in filling the log with several of the following
error messages. Fix it to detect device disconnect condition
and avoid device access.

Nov 20 18:58:02 anduin kernel: [  102.949819] au0828: au0828_usb_disconnect()
Nov 20 18:58:02 anduin kernel: [  102.950046] au0828: send_control_msg() Failed sending control message, error -71.
Nov 20 18:58:02 anduin kernel: [  102.950052] au0828: send_control_msg() Failed sending control message, error -19.
Nov 20 18:58:02 anduin kernel: [  102.950056] au0828: send_control_msg() Failed sending control message, error -19.
Nov 20 18:58:02 anduin kernel: [  102.950061] au0828: send_control_msg() Failed sending control message, error -19.
Nov 20 18:58:02 anduin kernel: [  102.950065] au0828: recv_control_msg() Failed receiving control message, error -19.
Nov 20 18:58:02 anduin kernel: [  102.950069] au0828: recv_control_msg() Failed receiving control message, error -19.
Nov 20 18:58:02 anduin kernel: [  102.950072] au0828: recv_control_msg() Failed receiving control message, error -19.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c  |    8 ++++++++
 drivers/media/usb/au0828/au0828-input.c |   11 +++++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index bc06480..2c3d3c1 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -153,6 +153,14 @@ static void au0828_usb_disconnect(struct usb_interface *interface)
 
 	dprintk(1, "%s()\n", __func__);
 
+	/* there is a small window after disconnect, before
+	   dev->usbdev is NULL, for poll (e.g: IR) try to access
+	   the device and fill the dmesg with error messages.
+	   Set the status so poll routines can check and avoid
+	   access after disconnect.
+	*/
+	dev->dev_state = DEV_DISCONNECTED;
+
 	au0828_rc_unregister(dev);
 	/* Digital TV */
 	au0828_dvb_unregister(dev);
diff --git a/drivers/media/usb/au0828/au0828-input.c b/drivers/media/usb/au0828/au0828-input.c
index 63995f9..c7185c1 100644
--- a/drivers/media/usb/au0828/au0828-input.c
+++ b/drivers/media/usb/au0828/au0828-input.c
@@ -129,6 +129,10 @@ static int au0828_get_key_au8522(struct au0828_rc *ir)
 	int prv_bit, bit, width;
 	bool first = true;
 
+	/* do nothing if device is disconnected */
+	if (ir->dev->dev_state == DEV_DISCONNECTED)
+		return 0;
+
 	/* Check IR int */
 	rc = au8522_rc_read(ir, 0xe1, -1, buf, 1);
 	if (rc < 0 || !(buf[0] & (1 << 4))) {
@@ -255,8 +259,11 @@ static void au0828_rc_stop(struct rc_dev *rc)
 
 	cancel_delayed_work_sync(&ir->work);
 
-	/* Disable IR */
-	au8522_rc_clear(ir, 0xe0, 1 << 4);
+	/* do nothing if device is disconnected */
+	if (ir->dev->dev_state != DEV_DISCONNECTED) {
+		/* Disable IR */
+		au8522_rc_clear(ir, 0xe0, 1 << 4);
+	}
 }
 
 static int au0828_probe_i2c_ir(struct au0828_dev *dev)
-- 
1.7.10.4

