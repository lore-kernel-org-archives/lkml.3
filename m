Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab3EESd7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 14:33:59 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41321 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab3EESdM (ORCPT
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
Subject: [PATCH 5/7] USB: io_ti: fix chars_in_buffer overhead
Date: Sun,  5 May 2013 20:32:31 +0200
Message-Id: <1367778753-22297-6-git-send-email-jhovold@gmail.com>
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
and thus removes the overhead introduced by commit 263e1f9f ("USB:
io_ti: query hardware-buffer status in chars_in_buffer") without
breaking tty_wait_until_sent (used by, for example, tcdrain, tcsendbreak
and close).

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/io_ti.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/serial/io_ti.c b/drivers/usb/serial/io_ti.c
index 158bf4b..1be6ba7 100644
--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -2019,8 +2019,6 @@ static int edge_chars_in_buffer(struct tty_struct *tty)
 	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
 	int chars = 0;
 	unsigned long flags;
-	int ret;
-
 	if (edge_port == NULL)
 		return 0;
 
@@ -2028,16 +2026,22 @@ static int edge_chars_in_buffer(struct tty_struct *tty)
 	chars = kfifo_len(&edge_port->write_fifo);
 	spin_unlock_irqrestore(&edge_port->ep_lock, flags);
 
-	if (!chars) {
-		ret = tx_active(edge_port);
-		if (ret > 0)
-			chars = ret;
-	}
-
 	dev_dbg(&port->dev, "%s - returns %d\n", __func__, chars);
 	return chars;
 }
 
+static bool edge_tx_empty(struct usb_serial_port *port)
+{
+	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
+	int ret;
+
+	ret = tx_active(edge_port);
+	if (ret > 0)
+		return false;
+
+	return true;
+}
+
 static void edge_throttle(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
@@ -2557,6 +2561,7 @@ static struct usb_serial_driver edgeport_1port_device = {
 	.write			= edge_write,
 	.write_room		= edge_write_room,
 	.chars_in_buffer	= edge_chars_in_buffer,
+	.tx_empty		= edge_tx_empty,
 	.break_ctl		= edge_break,
 	.read_int_callback	= edge_interrupt_callback,
 	.read_bulk_callback	= edge_bulk_in_callback,
@@ -2589,6 +2594,7 @@ static struct usb_serial_driver edgeport_2port_device = {
 	.write			= edge_write,
 	.write_room		= edge_write_room,
 	.chars_in_buffer	= edge_chars_in_buffer,
+	.tx_empty		= edge_tx_empty,
 	.break_ctl		= edge_break,
 	.read_int_callback	= edge_interrupt_callback,
 	.read_bulk_callback	= edge_bulk_in_callback,
-- 
1.8.2.1

