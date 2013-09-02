Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758942Ab3IBJLp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 05:11:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37688 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758297Ab3IBIzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:55:04 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Matt Burtch <matt@grid-net.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 14/58] USB-Serial: Fix error handling of usb_wwan
Date: Mon,  2 Sep 2013 09:53:59 +0100
Message-Id: <1378112083-9475-15-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
References: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Burtch <matt@grid-net.com>

commit 6c1ee66a0b2bdbd64c078fba684d640cf2fd38a9 upstream.

This fixes an issue where the bulk-in urb used for incoming data transfer
is not resubmitted if the packet recieved contains an error status.  This
results in the driver locking until the port is closed and re-opened.

Tested on a custom board with a Cinterion GSM module.

Signed-off-by: Matt Burtch <matt@grid-net.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ luis: backported to 3.5:
  - adjusted context
  - replaced dev_err() by printk() ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/usb_wwan.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
index 25c8ee9..2956414 100644
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -297,18 +297,18 @@ static void usb_wwan_indat_callback(struct urb *urb)
 			tty_kref_put(tty);
 		}
 
-		/* Resubmit urb so we continue receiving */
-		err = usb_submit_urb(urb, GFP_ATOMIC);
-		if (err) {
-			if (err != -EPERM) {
-				printk(KERN_ERR "%s: resubmit read urb failed. "
-					"(%d)", __func__, err);
-				/* busy also in error unless we are killed */
-				usb_mark_last_busy(port->serial->dev);
-			}
-		} else {
+	}
+	/* Resubmit urb so we continue receiving */
+	err = usb_submit_urb(urb, GFP_ATOMIC);
+	if (err) {
+		if (err != -EPERM) {
+			printk(KERN_ERR "%s: resubmit read urb failed. (%d)\n",
+				__func__, err);
+			/* busy also in error unless we are killed */
 			usb_mark_last_busy(port->serial->dev);
 		}
+	} else {
+		usb_mark_last_busy(port->serial->dev);
 	}
 }
 
-- 
1.8.3.2

