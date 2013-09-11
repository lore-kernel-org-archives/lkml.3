Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758Ab3IKE6X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:58:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22176 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab3IKE46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:56:58 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=-QJv-X64qMoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=wYe-Gp7TkDUA:10 a=w1kHd-t2AAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=FAIMgEkjMsOo7ODWMWYA:9 a=ddkTOqJZVZQA:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042927.264251908@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:30:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Matt Burtch <matt@grid-net.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [211/251] USB-Serial: Fix error handling of usb_wwan
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0211-USB-Serial-Fix-error-handling-of-usb_wwan.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Matt Burtch <matt@grid-net.com>

[ Upstream commit 6c1ee66a0b2bdbd64c078fba684d640cf2fd38a9 ]

This fixes an issue where the bulk-in urb used for incoming data transfer
is not resubmitted if the packet recieved contains an error status.  This
results in the driver locking until the port is closed and re-opened.

Tested on a custom board with a Cinterion GSM module.

Signed-off-by: Matt Burtch <matt@grid-net.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/serial/usb_wwan.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
index 188b5b3..5e9e1df 100644
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -299,18 +299,18 @@ static void usb_wwan_indat_callback(struct urb *urb)
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
1.7.10.4


