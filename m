Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760443Ab3ICQif (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 12:38:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46424 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733Ab3ICQYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 12:24:13 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Matt Burtch <matt@grid-net.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 12/58] USB-Serial: Fix error handling of usb_wwan
Date: Tue,  3 Sep 2013 09:23:16 -0700
Message-Id: <1378225442-20654-13-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378225442-20654-1-git-send-email-kamal@canonical.com>
References: <1378225442-20654-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Burtch <matt@grid-net.com>

commit 6c1ee66a0b2bdbd64c078fba684d640cf2fd38a9 upstream.

This fixes an issue where the bulk-in urb used for incoming data transfer
is not resubmitted if the packet recieved contains an error status.  This
results in the driver locking until the port is closed and re-opened.

Tested on a custom board with a Cinterion GSM module.

Signed-off-by: Matt Burtch <matt@grid-net.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/usb_wwan.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
index 1355a6c..c9691c8 100644
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -296,18 +296,18 @@ static void usb_wwan_indat_callback(struct urb *urb)
 				dev_dbg(dev, "%s: empty read urb received\n", __func__);
 			tty_kref_put(tty);
 		}
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
1.8.1.2

