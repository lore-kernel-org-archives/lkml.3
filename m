Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147Ab3EESdQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 14:33:16 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:48090 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab3EESdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 14:33:11 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Peter Hurley <peter@hurleysoftware.com>, Stas Sergeev <stsp@list.ru>,
        Jarkko Huijts <jarkko.huijts@gmail.com>,
        Alan Cox <alan@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Caylan Van Larson <i@caylan.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 6/7] USB: ti_usb_3410_5052: fix chars_in_buffer overhead
Date: Sun,  5 May 2013 20:32:32 +0200
Message-Id: <1367778753-22297-7-git-send-email-jhovold@gmail.com>
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
and thus removes the overhead introduced by commit 2c992cd73 ("USB:
ti_usb_3410_5052: query hardware-buffer status in chars_in_buffer")
without breaking tty_wait_until_sent (used by, for example, tcdrain,
tcsendbreak and close).

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/ti_usb_3410_5052.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
index cac47ae..c92c5ed 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -101,6 +101,7 @@ static int ti_write(struct tty_struct *tty, struct usb_serial_port *port,
 		const unsigned char *data, int count);
 static int ti_write_room(struct tty_struct *tty);
 static int ti_chars_in_buffer(struct tty_struct *tty);
+static bool ti_tx_empty(struct usb_serial_port *port);
 static void ti_throttle(struct tty_struct *tty);
 static void ti_unthrottle(struct tty_struct *tty);
 static int ti_ioctl(struct tty_struct *tty,
@@ -222,6 +223,7 @@ static struct usb_serial_driver ti_1port_device = {
 	.write			= ti_write,
 	.write_room		= ti_write_room,
 	.chars_in_buffer	= ti_chars_in_buffer,
+	.tx_empty		= ti_tx_empty,
 	.throttle		= ti_throttle,
 	.unthrottle		= ti_unthrottle,
 	.ioctl			= ti_ioctl,
@@ -253,6 +255,7 @@ static struct usb_serial_driver ti_2port_device = {
 	.write			= ti_write,
 	.write_room		= ti_write_room,
 	.chars_in_buffer	= ti_chars_in_buffer,
+	.tx_empty		= ti_tx_empty,
 	.throttle		= ti_throttle,
 	.unthrottle		= ti_unthrottle,
 	.ioctl			= ti_ioctl,
@@ -684,8 +687,6 @@ static int ti_chars_in_buffer(struct tty_struct *tty)
 	struct ti_port *tport = usb_get_serial_port_data(port);
 	int chars = 0;
 	unsigned long flags;
-	int ret;
-	u8 lsr;
 
 	if (tport == NULL)
 		return 0;
@@ -694,16 +695,22 @@ static int ti_chars_in_buffer(struct tty_struct *tty)
 	chars = kfifo_len(&tport->write_fifo);
 	spin_unlock_irqrestore(&tport->tp_lock, flags);
 
-	if (!chars) {
-		ret = ti_get_lsr(tport, &lsr);
-		if (!ret && !(lsr & TI_LSR_TX_EMPTY))
-			chars = 1;
-	}
-
 	dev_dbg(&port->dev, "%s - returns %d\n", __func__, chars);
 	return chars;
 }
 
+static bool ti_tx_empty(struct usb_serial_port *port)
+{
+	struct ti_port *tport = usb_get_serial_port_data(port);
+	int ret;
+	u8 lsr;
+
+	ret = ti_get_lsr(tport, &lsr);
+	if (!ret && !(lsr & TI_LSR_TX_EMPTY))
+		return false;
+
+	return true;
+}
 
 static void ti_throttle(struct tty_struct *tty)
 {
-- 
1.8.2.1

