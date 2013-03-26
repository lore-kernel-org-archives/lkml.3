Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965290Ab3CZQUB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 12:20:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53524 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934729Ab3CZPVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:21:43 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oliver Neukum <oliver@neukum.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 015/150] USB: cdc-wdm: fix buffer overflow
Date: Tue, 26 Mar 2013 15:18:34 +0000
Message-Id: <1364311249-14454-16-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.de>

commit c0f5ecee4e741667b2493c742b60b6218d40b3aa upstream.

The buffer for responses must not overflow.
If this would happen, set a flag, drop the data and return
an error after user space has read all remaining data.

Signed-off-by: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/class/cdc-wdm.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index 3cc771e..97c1d8e 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -81,6 +81,7 @@ MODULE_DEVICE_TABLE (usb, wdm_ids);
 #define WDM_RESPONDING		7
 #define WDM_SUSPENDING		8
 #define WDM_RESETTING		9
+#define WDM_OVERFLOW		10
 
 #define WDM_MAX			16
 
@@ -180,6 +181,7 @@ static void wdm_in_callback(struct urb *urb)
 {
 	struct wdm_device *desc = urb->context;
 	int status = urb->status;
+	int length = urb->actual_length;
 
 	spin_lock(&desc->iuspin);
 	clear_bit(WDM_RESPONDING, &desc->flags);
@@ -210,9 +212,17 @@ static void wdm_in_callback(struct urb *urb)
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
 
@@ -460,6 +470,11 @@ retry:
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
@@ -503,6 +518,7 @@ retry:
 			spin_unlock_irq(&desc->iuspin);
 			goto retry;
 		}
+
 		if (!desc->reslength) { /* zero length read */
 			dev_dbg(&desc->intf->dev, "%s: zero length - clearing WDM_READ\n", __func__);
 			clear_bit(WDM_READ, &desc->flags);
@@ -1029,6 +1045,7 @@ static int wdm_post_reset(struct usb_interface *intf)
 	struct wdm_device *desc = wdm_find_device(intf);
 	int rv;
 
+	clear_bit(WDM_OVERFLOW, &desc->flags);
 	clear_bit(WDM_RESETTING, &desc->flags);
 	rv = recover_from_urb_loss(desc);
 	mutex_unlock(&desc->wlock);
-- 
1.8.1.2

