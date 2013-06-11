Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955Ab3FKUJA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:09:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42020 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756777Ab3FKUEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:04:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stas Sergeev <stsp@list.ru>, Johan Hovold <jhovold@gmail.com>
Subject: [ 74/79] USB: ftdi_sio: fix chars_in_buffer overhead
Date: Tue, 11 Jun 2013 13:03:40 -0700
Message-Id: <20130611195325.751066809@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611195312.352656079@linuxfoundation.org>
References: <20130611195312.352656079@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit a37025b5c702aaf87191cd75fcc42c54454f16f5 upstream.

Use the new generic usb-serial wait_until_sent implementation to wait
for hardware buffers to drain.

This removes the need to check the hardware buffers in chars_in_buffer
and thus removes the overhead introduced by commit 6f602912 ("usb:
serial: ftdi_sio: Add missing chars_in_buffer function") without
breaking tty_wait_until_sent (used by, for example, tcdrain, tcsendbreak
and close).

Reported-by: Stas Sergeev <stsp@list.ru>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ftdi_sio.c |   19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -931,7 +931,7 @@ static int ftdi_get_icount(struct tty_st
 static int  ftdi_ioctl(struct tty_struct *tty,
 			unsigned int cmd, unsigned long arg);
 static void ftdi_break_ctl(struct tty_struct *tty, int break_state);
-static int ftdi_chars_in_buffer(struct tty_struct *tty);
+static bool ftdi_tx_empty(struct usb_serial_port *port);
 static int ftdi_get_modem_status(struct usb_serial_port *port,
 						unsigned char status[2]);
 
@@ -968,7 +968,7 @@ static struct usb_serial_driver ftdi_sio
 	.ioctl =		ftdi_ioctl,
 	.set_termios =		ftdi_set_termios,
 	.break_ctl =		ftdi_break_ctl,
-	.chars_in_buffer =      ftdi_chars_in_buffer,
+	.tx_empty =		ftdi_tx_empty,
 };
 
 static struct usb_serial_driver * const serial_drivers[] = {
@@ -2092,27 +2092,18 @@ static void ftdi_break_ctl(struct tty_st
 
 }
 
-static int ftdi_chars_in_buffer(struct tty_struct *tty)
+static bool ftdi_tx_empty(struct usb_serial_port *port)
 {
-	struct usb_serial_port *port = tty->driver_data;
-	int chars;
 	unsigned char buf[2];
 	int ret;
 
-	chars = usb_serial_generic_chars_in_buffer(tty);
-	if (chars)
-		goto out;
-
-	/* Check if hardware buffer is empty. */
 	ret = ftdi_get_modem_status(port, buf);
 	if (ret == 2) {
 		if (!(buf[1] & FTDI_RS_TEMT))
-			chars = 1;
+			return false;
 	}
-out:
-	dev_dbg(&port->dev, "%s - %d\n", __func__, chars);
 
-	return chars;
+	return true;
 }
 
 /* old_termios contains the original termios settings and tty->termios contains


