Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965252Ab3GCTMM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:12:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33268 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964901Ab3GCTAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:23 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=5hHyDbuW1RoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=BQbby5QtWxEA:10 a=pGLkceISAAAA:8 a=ag1SF4gXAAAA:8 a=pQFG53Joc4AfjvbZiugA:9 a=MSl-tDqOz04A:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184104.634421051@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:40:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [108/141] USB: serial: add wait_until_sent operation
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0108-USB-serial-add-wait_until_sent-operation.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

[ Upstream commit 0693196fe7bbb5e6cafd255dfce91ff6d10bc18f ]

Add wait_until_sent operation which can be used to wait for hardware
buffers to drain.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/serial/usb-serial.c |   17 +++++++++++++++++
 include/linux/usb/serial.h      |    1 +
 2 files changed, 18 insertions(+)

diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 5f38894..390da63 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -377,6 +377,22 @@ static int serial_chars_in_buffer(struct tty_struct *tty)
 	return port->serial->type->chars_in_buffer(tty);
 }
 
+static void serial_wait_until_sent(struct tty_struct *tty, int timeout)
+{
+	struct usb_serial_port *port = tty->driver_data;
+	struct usb_serial *serial = port->serial;
+
+	dev_dbg(tty->dev, "%s\n", __func__);
+
+	if (!port->serial->type->wait_until_sent)
+		return;
+
+	mutex_lock(&serial->disc_mutex);
+	if (!serial->disconnected)
+		port->serial->type->wait_until_sent(tty, timeout);
+	mutex_unlock(&serial->disc_mutex);
+}
+
 static void serial_throttle(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
@@ -1200,6 +1216,7 @@ static const struct tty_operations serial_ops = {
 	.unthrottle =		serial_unthrottle,
 	.break_ctl =		serial_break,
 	.chars_in_buffer =	serial_chars_in_buffer,
+	.wait_until_sent =	serial_wait_until_sent,
 	.tiocmget =		serial_tiocmget,
 	.tiocmset =		serial_tiocmset,
 	.get_icount =		serial_get_icount,
diff --git a/include/linux/usb/serial.h b/include/linux/usb/serial.h
index 0b61f01..95527e4 100644
--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -267,6 +267,7 @@ struct usb_serial_driver {
 			struct usb_serial_port *port, struct ktermios *old);
 	void (*break_ctl)(struct tty_struct *tty, int break_state);
 	int  (*chars_in_buffer)(struct tty_struct *tty);
+	void (*wait_until_sent)(struct tty_struct *tty, long timeout);
 	void (*throttle)(struct tty_struct *tty);
 	void (*unthrottle)(struct tty_struct *tty);
 	int  (*tiocmget)(struct tty_struct *tty);
-- 
1.7.10.4


