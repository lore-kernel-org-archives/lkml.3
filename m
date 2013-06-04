Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab3FDWmn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:42:43 -0400
Received: from 1wt.eu ([62.212.114.60]:35501 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120Ab3FDWmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:42:32 -0400
Message-Id: <20130604172134.911364563@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:23:21 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Oliver Neukum <oliver@neukum.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 111/184] USB: cdc-wdm: fix buffer overflow
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.de>

commit c0f5ecee4e741667b2493c742b60b6218d40b3aa upstream.

The buffer for responses must not overflow.
If this would happen, set a flag, drop the data and return
an error after user space has read all remaining data.

Signed-off-by: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 2.6.32: adjust context]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/usb/class/cdc-wdm.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index 37f2899..01ae519 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -52,6 +52,7 @@ MODULE_DEVICE_TABLE (usb, wdm_ids);
 #define WDM_READ		4
 #define WDM_INT_STALL		5
 #define WDM_POLL_RUNNING	6
+#define WDM_OVERFLOW		10
 
 
 #define WDM_MAX			16
@@ -115,6 +116,7 @@ static void wdm_in_callback(struct urb *urb)
 {
 	struct wdm_device *desc = urb->context;
 	int status = urb->status;
+	int length = urb->actual_length;
 
 	spin_lock(&desc->iuspin);
 
@@ -144,9 +146,17 @@ static void wdm_in_callback(struct urb *urb)
 	}
 
 	desc->rerr = status;
-	desc->reslength = urb->actual_length;
-	memmove(desc->ubuf + desc->length, desc->inbuf, desc->reslength);
-	desc->length += desc->reslength;
+	if (length + desc->length > desc->wMaxCommand) {
+		/* The buffer would overflow */
+		set_bit(WDM_OVERFLOW, &desc->flags);
+	} else {
+		/* we may already be in overflow */
+		if (!test_bit(WDM_OVERFLOW, &desc->flags)) {
+			memmove(desc->ubuf + desc->length, desc->inbuf, length);
+			desc->length += length;
+			desc->reslength = length;
+		}
+	}
 	wake_up(&desc->wait);
 
 	set_bit(WDM_READ, &desc->flags);
@@ -398,6 +408,11 @@ retry:
 			rv = -ENODEV;
 			goto err;
 		}
+		if (test_bit(WDM_OVERFLOW, &desc->flags)) {
+			clear_bit(WDM_OVERFLOW, &desc->flags);
+			rv = -ENOBUFS;
+			goto err;
+		}
 		i++;
 		if (file->f_flags & O_NONBLOCK) {
 			if (!test_bit(WDM_READ, &desc->flags)) {
@@ -440,6 +455,7 @@ retry:
 			spin_unlock_irq(&desc->iuspin);
 			goto retry;
 		}
+
 		if (!desc->reslength) { /* zero length read */
 			dev_dbg(&desc->intf->dev, "%s: zero length - clearing WDM_READ\n", __func__);
 			clear_bit(WDM_READ, &desc->flags);
@@ -844,6 +860,7 @@ static int wdm_post_reset(struct usb_interface *intf)
 	struct wdm_device *desc = usb_get_intfdata(intf);
 	int rv;
 
+	clear_bit(WDM_OVERFLOW, &desc->flags);
 	rv = recover_from_urb_loss(desc);
 	mutex_unlock(&desc->plock);
 	return 0;
-- 
1.7.12.2.21.g234cd45.dirty



