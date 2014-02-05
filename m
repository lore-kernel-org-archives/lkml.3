Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498AbaBEU1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:27:19 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48452 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142AbaBEUHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:07:09 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Oliver Neukum <oneukum@suse.de>, Oliver Neukum <oliver@neukum.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 148/213] USB: cdc-wdm: fix buffer overflow
Date: Wed, 5 Feb 2014 15:01:43 -0500
Message-ID: <1391630568-49251-149-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oliver Neukum <oneukum@suse.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit c0f5ecee4e741667b2493c742b60b6218d40b3aa upstream.

The buffer for responses must not overflow.
If this would happen, set a flag, drop the data and return
an error after user space has read all remaining data.

Signed-off-by: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[PG: minor adjustment since RESET from 880442027569 isn't in .34]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/class/cdc-wdm.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index 189141ca4e05..ce1af28e54ff 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -54,6 +54,7 @@ MODULE_DEVICE_TABLE (usb, wdm_ids);
 #define WDM_POLL_RUNNING	6
 #define WDM_RESPONDING		7
 #define WDM_SUSPENDING		8
+#define WDM_OVERFLOW		10
 
 #define WDM_MAX			16
 
@@ -114,6 +115,7 @@ static void wdm_in_callback(struct urb *urb)
 {
 	struct wdm_device *desc = urb->context;
 	int status = urb->status;
+	int length = urb->actual_length;
 
 	spin_lock(&desc->iuspin);
 	clear_bit(WDM_RESPONDING, &desc->flags);
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
 skip_error:
 	wake_up(&desc->wait);
 
@@ -410,6 +420,11 @@ retry:
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
@@ -449,6 +464,7 @@ retry:
 			spin_unlock_irq(&desc->iuspin);
 			goto retry;
 		}
+
 		if (!desc->reslength) { /* zero length read */
 			spin_unlock_irq(&desc->iuspin);
 			goto retry;
@@ -860,6 +876,7 @@ static int wdm_post_reset(struct usb_interface *intf)
 	struct wdm_device *desc = usb_get_intfdata(intf);
 	int rv;
 
+	clear_bit(WDM_OVERFLOW, &desc->flags);
 	rv = recover_from_urb_loss(desc);
 	mutex_unlock(&desc->lock);
 	return 0;
-- 
1.8.5.2

