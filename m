Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503Ab3HLRRN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 13:17:13 -0400
Received: from mail.grid-net.com ([97.65.115.18]:47261 "EHLO mail.grid-net.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757062Ab3HLRRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 13:17:12 -0400
X-Greylist: delayed 320 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Aug 2013 13:17:11 EDT
From: Matt Burtch <matt@grid-net.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johan Hovold <jhovold@gmail.com>, Jiri Slaby <jslaby@suse.cz>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <matt@grid-net.com>
Subject: [PATCH 1/1] USB-Serial: Fix error handling of usb_wwan
Date: Mon, 12 Aug 2013 10:11:39 -0700
Message-ID: <1376327499-528-1-git-send-email-matt@grid-net.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.0.124]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes an issue where the bulk-in urb used for incoming data transfer
is not resubmitted if the packet recieved contains an error status.  This
results in the driver locking until the port is closed and re-opened.

Tested on a custom board with a Cinterion GSM module.

Signed-off-by: Matt Burtch <matt@grid-net.com>
---
 drivers/usb/serial/usb_wwan.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
index 8257d30..9eefc33 100644
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -291,18 +291,18 @@ static void usb_wwan_indat_callback(struct urb *urb)
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
 
-- 
1.7.9.5

