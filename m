Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259AbaFXQBK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 12:01:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33414 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965171AbaFXP4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:56:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 3.15 33/61] USB: cdc-acm: fix failed open not being detected
Date: Tue, 24 Jun 2014 11:51:16 -0400
Message-Id: <20140624154954.288766205@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140624154952.751713761@linuxfoundation.org>
References: <20140624154952.751713761@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 8727bf689a77a79816065e23a7a58a474ad544f9 upstream.

Fix errors during open not being returned to userspace. Specifically,
failed control-line manipulations or control or read urb submissions
would not be detected.

Fixes: 7fb57a019f94 ("USB: cdc-acm: Fix potential deadlock (lockdep
warning)")

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/cdc-acm.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -525,17 +525,17 @@ static int acm_port_activate(struct tty_
 	acm->control->needs_remote_wakeup = 1;
 
 	acm->ctrlurb->dev = acm->dev;
-	if (usb_submit_urb(acm->ctrlurb, GFP_KERNEL)) {
+	retval = usb_submit_urb(acm->ctrlurb, GFP_KERNEL);
+	if (retval) {
 		dev_err(&acm->control->dev,
 			"%s - usb_submit_urb(ctrl irq) failed\n", __func__);
 		goto error_submit_urb;
 	}
 
 	acm->ctrlout = ACM_CTRL_DTR | ACM_CTRL_RTS;
-	if (acm_set_control(acm, acm->ctrlout) < 0 &&
-	    (acm->ctrl_caps & USB_CDC_CAP_LINE)) {
+	retval = acm_set_control(acm, acm->ctrlout);
+	if (retval < 0 && (acm->ctrl_caps & USB_CDC_CAP_LINE))
 		goto error_set_control;
-	}
 
 	/*
 	 * Unthrottle device in case the TTY was closed while throttled.
@@ -545,7 +545,8 @@ static int acm_port_activate(struct tty_
 	acm->throttle_req = 0;
 	spin_unlock_irq(&acm->read_lock);
 
-	if (acm_submit_read_urbs(acm, GFP_KERNEL))
+	retval = acm_submit_read_urbs(acm, GFP_KERNEL);
+	if (retval)
 		goto error_submit_read_urbs;
 
 	usb_autopm_put_interface(acm->control);
@@ -564,7 +565,8 @@ error_submit_urb:
 error_get_interface:
 disconnected:
 	mutex_unlock(&acm->mutex);
-	return retval;
+
+	return usb_translate_errors(retval);
 }
 
 static void acm_port_destruct(struct tty_port *port)


