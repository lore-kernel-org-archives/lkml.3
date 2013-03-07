Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932788Ab3CGMOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 07:14:48 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:49742 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757083Ab3CGMMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 07:12:49 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: peter@hurleysoftware.com, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org, Bill Pemberton <wfp5p@virginia.edu>
Subject: [PATCH 07/16] TTY: quatech2, remove unneeded is_open
Date: Thu,  7 Mar 2013 13:12:31 +0100
Message-Id: <1362658360-26629-7-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1362658360-26629-1-git-send-email-jslaby@suse.cz>
References: <1362658360-26629-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tty->ops->break_ctl cannot be called outside the gap between open and
close. So there is no need to check whether the port is open in
break_ctl in quatech2. Remove the check and also that member
completely.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Bill Pemberton <wfp5p@virginia.edu>
---
 drivers/usb/serial/quatech2.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/usb/serial/quatech2.c b/drivers/usb/serial/quatech2.c
index 00e6c9b..d853104 100644
--- a/drivers/usb/serial/quatech2.c
+++ b/drivers/usb/serial/quatech2.c
@@ -116,7 +116,6 @@ struct qt2_serial_private {
 };
 
 struct qt2_port_private {
-	bool is_open;
 	u8   device_port;
 
 	spinlock_t urb_lock;
@@ -398,7 +397,6 @@ static int qt2_open(struct tty_struct *tty, struct usb_serial_port *port)
 		return status;
 	}
 
-	port_priv->is_open = true;
 	port_priv->device_port = (u8) device_port;
 
 	if (tty)
@@ -418,8 +416,6 @@ static void qt2_close(struct usb_serial_port *port)
 	serial = port->serial;
 	port_priv = usb_get_serial_port_data(port);
 
-	port_priv->is_open = false;
-
 	spin_lock_irqsave(&port_priv->urb_lock, flags);
 	usb_kill_urb(port_priv->write_urb);
 	port_priv->urb_in_use = false;
@@ -905,12 +901,6 @@ static void qt2_break_ctl(struct tty_struct *tty, int break_state)
 
 	port_priv = usb_get_serial_port_data(port);
 
-	if (!port_priv->is_open) {
-		dev_err(&port->dev,
-			"%s - port is not open\n", __func__);
-		return;
-	}
-
 	val = (break_state == -1) ? 1 : 0;
 
 	status = qt2_control_msg(port->serial->dev, QT2_BREAK_CONTROL,
-- 
1.8.1.4


