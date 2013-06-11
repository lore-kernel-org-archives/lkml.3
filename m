Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880Ab3FKUIr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:08:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42024 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756717Ab3FKUEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:04:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 75/79] USB: io_ti: fix chars_in_buffer overhead
Date: Tue, 11 Jun 2013 13:03:41 -0700
Message-Id: <20130611195325.880757823@linuxfoundation.org>
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

commit b16634adce951a7371be931487034f7365971ed0 upstream.

Use the new generic usb-serial wait_until_sent implementation to wait
for hardware buffers to drain.

This removes the need to check the hardware buffers in chars_in_buffer
and thus removes the overhead introduced by commit 263e1f9f ("USB:
io_ti: query hardware-buffer status in chars_in_buffer") without
breaking tty_wait_until_sent (used by, for example, tcdrain, tcsendbreak
and close).

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/io_ti.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -2033,8 +2033,6 @@ static int edge_chars_in_buffer(struct t
 	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
 	int chars = 0;
 	unsigned long flags;
-	int ret;
-
 	if (edge_port == NULL)
 		return 0;
 
@@ -2042,16 +2040,22 @@ static int edge_chars_in_buffer(struct t
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
@@ -2622,6 +2626,7 @@ static struct usb_serial_driver edgeport
 	.write			= edge_write,
 	.write_room		= edge_write_room,
 	.chars_in_buffer	= edge_chars_in_buffer,
+	.tx_empty		= edge_tx_empty,
 	.break_ctl		= edge_break,
 	.read_int_callback	= edge_interrupt_callback,
 	.read_bulk_callback	= edge_bulk_in_callback,
@@ -2653,6 +2658,7 @@ static struct usb_serial_driver edgeport
 	.write			= edge_write,
 	.write_room		= edge_write_room,
 	.chars_in_buffer	= edge_chars_in_buffer,
+	.tx_empty		= edge_tx_empty,
 	.break_ctl		= edge_break,
 	.read_int_callback	= edge_interrupt_callback,
 	.read_bulk_callback	= edge_bulk_in_callback,


