Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab3HRUfS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:35:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43718 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756476Ab3HRUfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:35:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Matt Burtch <matt@grid-net.com>
Subject: [ 36/45] USB-Serial: Fix error handling of usb_wwan
Date: Sun, 18 Aug 2013 13:36:25 -0700
Message-Id: <20130818203623.502671168@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130818203620.996166594@linuxfoundation.org>
References: <20130818203620.996166594@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Burtch <matt@grid-net.com>

commit 6c1ee66a0b2bdbd64c078fba684d640cf2fd38a9 upstream.

This fixes an issue where the bulk-in urb used for incoming data transfer
is not resubmitted if the packet recieved contains an error status.  This
results in the driver locking until the port is closed and re-opened.

Tested on a custom board with a Cinterion GSM module.

Signed-off-by: Matt Burtch <matt@grid-net.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/usb_wwan.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -291,18 +291,18 @@ static void usb_wwan_indat_callback(stru
 			tty_flip_buffer_push(&port->port);
 		} else
 			dev_dbg(dev, "%s: empty read urb received\n", __func__);
-
-		/* Resubmit urb so we continue receiving */
-		err = usb_submit_urb(urb, GFP_ATOMIC);
-		if (err) {
-			if (err != -EPERM) {
-				dev_err(dev, "%s: resubmit read urb failed. (%d)\n", __func__, err);
-				/* busy also in error unless we are killed */
-				usb_mark_last_busy(port->serial->dev);
-			}
-		} else {
+	}
+	/* Resubmit urb so we continue receiving */
+	err = usb_submit_urb(urb, GFP_ATOMIC);
+	if (err) {
+		if (err != -EPERM) {
+			dev_err(dev, "%s: resubmit read urb failed. (%d)\n",
+				__func__, err);
+			/* busy also in error unless we are killed */
 			usb_mark_last_busy(port->serial->dev);
 		}
+	} else {
+		usb_mark_last_busy(port->serial->dev);
 	}
 }
 


