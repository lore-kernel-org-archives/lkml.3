Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545AbaDKWLC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 18:11:02 -0400
Received: from mail.ispras.ru ([83.149.199.45]:52788 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520AbaDKWK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 18:10:59 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Oliver Neukum <oliver@neukum.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH] USB: cdc-acm: fix double usb_autopm_put_interface() in acm_port_activate()
Date: Sat, 12 Apr 2014 02:10:45 +0400
Message-Id: <1397254245-7498-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If acm_submit_read_urbs() fails in acm_port_activate(), error handling
code calls usb_autopm_put_interface() while it is already called
before acm_submit_read_urbs(). The patch reorganizes error handling code
to avoid double decrement of USB interface's PM-usage counter.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/usb/class/cdc-acm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 900f7ff805ee..d5d2c922186a 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -518,13 +518,16 @@ static int acm_port_activate(struct tty_port *port, struct tty_struct *tty)
 	if (usb_submit_urb(acm->ctrlurb, GFP_KERNEL)) {
 		dev_err(&acm->control->dev,
 			"%s - usb_submit_urb(ctrl irq) failed\n", __func__);
+		usb_autopm_put_interface(acm->control);
 		goto error_submit_urb;
 	}
 
 	acm->ctrlout = ACM_CTRL_DTR | ACM_CTRL_RTS;
 	if (acm_set_control(acm, acm->ctrlout) < 0 &&
-	    (acm->ctrl_caps & USB_CDC_CAP_LINE))
+	    (acm->ctrl_caps & USB_CDC_CAP_LINE)) {
+		usb_autopm_put_interface(acm->control);
 		goto error_set_control;
+	}
 
 	usb_autopm_put_interface(acm->control);
 
@@ -549,7 +552,6 @@ error_submit_read_urbs:
 error_set_control:
 	usb_kill_urb(acm->ctrlurb);
 error_submit_urb:
-	usb_autopm_put_interface(acm->control);
 error_get_interface:
 disconnected:
 	mutex_unlock(&acm->mutex);
-- 
1.8.3.2

