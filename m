Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965268Ab3GCTMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:12:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20027 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933639Ab3GCTAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:22 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=pCstK5fn4NUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Lymzd4RJGzsA:10 a=pGLkceISAAAA:8 a=ag1SF4gXAAAA:8 a=pQFG53Joc4AfjvbZiugA:9 a=MSl-tDqOz04A:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184104.954147678@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:40:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [110/141] USB: io_ti: fix chars_in_buffer overhead
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0110-USB-io_ti-fix-chars_in_buffer-overhead.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

[ Upstream commit b16634adce951a7371be931487034f7365971ed0 ]

Use the new generic usb-serial wait_until_sent implementation to wait
for hardware buffers to drain.

This removes the need to check the hardware buffers in chars_in_buffer
and thus removes the overhead introduced by commit 263e1f9f ("USB:
io_ti: query hardware-buffer status in chars_in_buffer") without
breaking tty_wait_until_sent (used by, for example, tcdrain, tcsendbreak
and close).

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/serial/io_ti.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/usb/serial/io_ti.c b/drivers/usb/serial/io_ti.c
index d2b6008..93cf729 100644
--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -2163,6 +2163,18 @@ static int edge_chars_in_buffer(struct tty_struct *tty)
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
@@ -2739,6 +2751,7 @@ static struct usb_serial_driver edgeport_1port_device = {
 	.write			= edge_write,
 	.write_room		= edge_write_room,
 	.chars_in_buffer	= edge_chars_in_buffer,
+	.tx_empty		= edge_tx_empty,
 	.break_ctl		= edge_break,
 	.read_int_callback	= edge_interrupt_callback,
 	.read_bulk_callback	= edge_bulk_in_callback,
@@ -2770,6 +2783,7 @@ static struct usb_serial_driver edgeport_2port_device = {
 	.write			= edge_write,
 	.write_room		= edge_write_room,
 	.chars_in_buffer	= edge_chars_in_buffer,
+	.tx_empty		= edge_tx_empty,
 	.break_ctl		= edge_break,
 	.read_int_callback	= edge_interrupt_callback,
 	.read_bulk_callback	= edge_bulk_in_callback,
-- 
1.7.10.4


