Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655AbaFXQGl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 12:06:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33297 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964985AbaFXP4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:56:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 3.15 32/61] USB: cdc-acm: fix open and suspend race
Date: Tue, 24 Jun 2014 11:51:15 -0400
Message-Id: <20140624154954.243403713@linuxfoundation.org>
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

commit 703df3297fb1950b0aa53e656108eb936d3f21d9 upstream.

We must not do the usb_autopm_put_interface() before submitting the read
urbs or we might end up doing I/O to a suspended device.

Fixes: 088c64f81284 ("USB: cdc-acm: re-write read processing")
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/cdc-acm.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -528,19 +528,15 @@ static int acm_port_activate(struct tty_
 	if (usb_submit_urb(acm->ctrlurb, GFP_KERNEL)) {
 		dev_err(&acm->control->dev,
 			"%s - usb_submit_urb(ctrl irq) failed\n", __func__);
-		usb_autopm_put_interface(acm->control);
 		goto error_submit_urb;
 	}
 
 	acm->ctrlout = ACM_CTRL_DTR | ACM_CTRL_RTS;
 	if (acm_set_control(acm, acm->ctrlout) < 0 &&
 	    (acm->ctrl_caps & USB_CDC_CAP_LINE)) {
-		usb_autopm_put_interface(acm->control);
 		goto error_set_control;
 	}
 
-	usb_autopm_put_interface(acm->control);
-
 	/*
 	 * Unthrottle device in case the TTY was closed while throttled.
 	 */
@@ -552,6 +548,8 @@ static int acm_port_activate(struct tty_
 	if (acm_submit_read_urbs(acm, GFP_KERNEL))
 		goto error_submit_read_urbs;
 
+	usb_autopm_put_interface(acm->control);
+
 	mutex_unlock(&acm->mutex);
 
 	return 0;
@@ -562,6 +560,7 @@ error_submit_read_urbs:
 error_set_control:
 	usb_kill_urb(acm->ctrlurb);
 error_submit_urb:
+	usb_autopm_put_interface(acm->control);
 error_get_interface:
 disconnected:
 	mutex_unlock(&acm->mutex);


