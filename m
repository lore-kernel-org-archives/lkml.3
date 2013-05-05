Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327Ab3EESeD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 14:34:03 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:56293 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab3EESdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 14:33:12 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Peter Hurley <peter@hurleysoftware.com>, Stas Sergeev <stsp@list.ru>,
        Jarkko Huijts <jarkko.huijts@gmail.com>,
        Alan Cox <alan@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Caylan Van Larson <i@caylan.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 4/7] USB: ftdi_sio: fix chars_in_buffer overhead
Date: Sun,  5 May 2013 20:32:30 +0200
Message-Id: <1367778753-22297-5-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1367778753-22297-1-git-send-email-jhovold@gmail.com>
References: <20130505182913.GE16818@localhost>
 <1367778753-22297-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new generic usb-serial wait_until_sent implementation to wait
for hardware buffers to drain.

This removes the need to check the hardware buffers in chars_in_buffer
and thus removes the overhead introduced by commit 6f602912 ("usb:
serial: ftdi_sio: Add missing chars_in_buffer function") without
breaking tty_wait_until_sent (used by, for example, tcdrain, tcsendbreak
and close).

Reported-by: Stas Sergeev <stsp@list.ru>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/ftdi_sio.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 1159fd4..a62a75a 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -924,7 +924,7 @@ static int  ftdi_tiocmset(struct tty_struct *tty,
 static int  ftdi_ioctl(struct tty_struct *tty,
 			unsigned int cmd, unsigned long arg);
 static void ftdi_break_ctl(struct tty_struct *tty, int break_state);
-static int ftdi_chars_in_buffer(struct tty_struct *tty);
+static bool ftdi_tx_empty(struct usb_serial_port *port);
 static int ftdi_get_modem_status(struct usb_serial_port *port,
 						unsigned char status[2]);
 
@@ -961,7 +961,7 @@ static struct usb_serial_driver ftdi_sio_device = {
 	.ioctl =		ftdi_ioctl,
 	.set_termios =		ftdi_set_termios,
 	.break_ctl =		ftdi_break_ctl,
-	.chars_in_buffer =      ftdi_chars_in_buffer,
+	.tx_empty =		ftdi_tx_empty,
 };
 
 static struct usb_serial_driver * const serial_drivers[] = {
@@ -2056,27 +2056,18 @@ static void ftdi_break_ctl(struct tty_struct *tty, int break_state)
 
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
-- 
1.8.2.1

