Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965280Ab3GCTMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:12:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23390 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964805Ab3GCTAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:23 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=G3hx10RCfHwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=wZz4qTnmNj4A:10 a=pGLkceISAAAA:8 a=ag1SF4gXAAAA:8 a=xYyZaYpZ8SH__yWiF3EA:9 a=MSl-tDqOz04A:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184104.791916500@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:40:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [109/141] USB: serial: add generic wait_until_sent implementation
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0109-USB-serial-add-generic-wait_until_sent-implementatio.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

[ Upstream commit dcf0105039660e951dfea348d317043d17988dfc ]

Add generic wait_until_sent implementation which polls for empty
hardware buffers using the new port-operation tx_empty.

The generic implementation will be used for all sub-drivers that
implement tx_empty but does not define wait_until_sent.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/serial/generic.c    |   31 +++++++++++++++++++++++++++++++
 drivers/usb/serial/usb-serial.c |    2 ++
 include/linux/usb/serial.h      |    3 +++
 3 files changed, 36 insertions(+)

diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index 9b026bf..3b59dd8 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -267,6 +267,37 @@ int usb_serial_generic_chars_in_buffer(struct tty_struct *tty)
 	return chars;
 }
 
+void usb_serial_generic_wait_until_sent(struct tty_struct *tty, long timeout)
+{
+	struct usb_serial_port *port = tty->driver_data;
+	unsigned int bps;
+	unsigned long period;
+	unsigned long expire;
+
+	bps = tty_get_baud_rate(tty);
+	if (!bps)
+		bps = 9600;	/* B0 */
+	/*
+	 * Use a poll-period of roughly the time it takes to send one
+	 * character or at least one jiffy.
+	 */
+	period = max_t(unsigned long, (10 * HZ / bps), 1);
+	period = min_t(unsigned long, period, timeout);
+
+	dev_dbg(&port->dev, "%s - timeout = %u ms, period = %u ms\n",
+					__func__, jiffies_to_msecs(timeout),
+					jiffies_to_msecs(period));
+	expire = jiffies + timeout;
+	while (!port->serial->type->tx_empty(port)) {
+		schedule_timeout_interruptible(period);
+		if (signal_pending(current))
+			break;
+		if (time_after(jiffies, expire))
+			break;
+	}
+}
+EXPORT_SYMBOL_GPL(usb_serial_generic_wait_until_sent);
+
 static int usb_serial_generic_submit_read_urb(struct usb_serial_port *port,
 						int index, gfp_t mem_flags)
 {
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 390da63..ac03c58 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -1349,6 +1349,8 @@ static void fixup_generic(struct usb_serial_driver *device)
 	set_to_generic_if_null(device, close);
 	set_to_generic_if_null(device, write_room);
 	set_to_generic_if_null(device, chars_in_buffer);
+	if (device->tx_empty)
+		set_to_generic_if_null(device, wait_until_sent);
 	set_to_generic_if_null(device, read_bulk_callback);
 	set_to_generic_if_null(device, write_bulk_callback);
 	set_to_generic_if_null(device, disconnect);
diff --git a/include/linux/usb/serial.h b/include/linux/usb/serial.h
index 95527e4..f0950dc 100644
--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -268,6 +268,7 @@ struct usb_serial_driver {
 	void (*break_ctl)(struct tty_struct *tty, int break_state);
 	int  (*chars_in_buffer)(struct tty_struct *tty);
 	void (*wait_until_sent)(struct tty_struct *tty, long timeout);
+	bool (*tx_empty)(struct usb_serial_port *port);
 	void (*throttle)(struct tty_struct *tty);
 	void (*unthrottle)(struct tty_struct *tty);
 	int  (*tiocmget)(struct tty_struct *tty);
@@ -330,6 +331,8 @@ extern void usb_serial_generic_close(struct usb_serial_port *port);
 extern int usb_serial_generic_resume(struct usb_serial *serial);
 extern int usb_serial_generic_write_room(struct tty_struct *tty);
 extern int usb_serial_generic_chars_in_buffer(struct tty_struct *tty);
+extern void usb_serial_generic_wait_until_sent(struct tty_struct *tty,
+								long timeout);
 extern void usb_serial_generic_read_bulk_callback(struct urb *urb);
 extern void usb_serial_generic_write_bulk_callback(struct urb *urb);
 extern void usb_serial_generic_throttle(struct tty_struct *tty);
-- 
1.7.10.4


