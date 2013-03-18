Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933101Ab3CRVYM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:24:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46018 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756474Ab3CRVKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:10:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oliver Neukum <oliver@neukum.org>
Subject: [ 04/40] USB: cdc-wdm: fix buffer overflow
Date: Mon, 18 Mar 2013 14:10:42 -0700
Message-Id: <20130318211016.568434509@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318211016.254453918@linuxfoundation.org>
References: <20130318211016.254453918@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.de>

commit c0f5ecee4e741667b2493c742b60b6218d40b3aa upstream.

The buffer for responses must not overflow.
If this would happen, set a flag, drop the data and return
an error after user space has read all remaining data.

Signed-off-by: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/cdc-wdm.c |   23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -54,6 +54,7 @@ MODULE_DEVICE_TABLE (usb, wdm_ids);
 #define WDM_POLL_RUNNING	6
 #define WDM_RESPONDING		7
 #define WDM_SUSPENDING		8
+#define WDM_OVERFLOW		10
 
 #define WDM_MAX			16
 
@@ -118,6 +119,7 @@ static void wdm_in_callback(struct urb *
 {
 	struct wdm_device *desc = urb->context;
 	int status = urb->status;
+	int length = urb->actual_length;
 
 	spin_lock(&desc->iuspin);
 	clear_bit(WDM_RESPONDING, &desc->flags);
@@ -148,9 +150,17 @@ static void wdm_in_callback(struct urb *
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
 skip_error:
 	wake_up(&desc->wait);
 
@@ -417,6 +427,11 @@ retry:
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
@@ -456,6 +471,7 @@ retry:
 			spin_unlock_irq(&desc->iuspin);
 			goto retry;
 		}
+
 		if (!desc->reslength) { /* zero length read */
 			dev_dbg(&desc->intf->dev, "%s: zero length - clearing WDM_READ\n", __func__);
 			clear_bit(WDM_READ, &desc->flags);
@@ -901,6 +917,7 @@ static int wdm_post_reset(struct usb_int
 	struct wdm_device *desc = usb_get_intfdata(intf);
 	int rv;
 
+	clear_bit(WDM_OVERFLOW, &desc->flags);
 	rv = recover_from_urb_loss(desc);
 	mutex_unlock(&desc->wlock);
 	mutex_unlock(&desc->rlock);


