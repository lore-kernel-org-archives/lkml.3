Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab3FKUJn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:09:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42014 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756640Ab3FKUEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:04:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 72/79] USB: serial: add generic wait_until_sent implementation
Date: Tue, 11 Jun 2013 13:03:38 -0700
Message-Id: <20130611195325.501938037@linuxfoundation.org>
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

commit dcf0105039660e951dfea348d317043d17988dfc upstream.

Add generic wait_until_sent implementation which polls for empty
hardware buffers using the new port-operation tx_empty.

The generic implementation will be used for all sub-drivers that
implement tx_empty but does not define wait_until_sent.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/generic.c    |   31 +++++++++++++++++++++++++++++++
 drivers/usb/serial/usb-serial.c |    2 ++
 include/linux/usb/serial.h      |    3 +++
 3 files changed, 36 insertions(+)

--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -264,6 +264,37 @@ int usb_serial_generic_chars_in_buffer(s
 }
 EXPORT_SYMBOL_GPL(usb_serial_generic_chars_in_buffer);
 
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
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -1346,6 +1346,8 @@ static void fixup_generic(struct usb_ser
 	set_to_generic_if_null(device, close);
 	set_to_generic_if_null(device, write_room);
 	set_to_generic_if_null(device, chars_in_buffer);
+	if (device->tx_empty)
+		set_to_generic_if_null(device, wait_until_sent);
 	set_to_generic_if_null(device, read_bulk_callback);
 	set_to_generic_if_null(device, write_bulk_callback);
 	set_to_generic_if_null(device, disconnect);
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
@@ -326,6 +327,8 @@ extern void usb_serial_generic_close(str
 extern int usb_serial_generic_resume(struct usb_serial *serial);
 extern int usb_serial_generic_write_room(struct tty_struct *tty);
 extern int usb_serial_generic_chars_in_buffer(struct tty_struct *tty);
+extern void usb_serial_generic_wait_until_sent(struct tty_struct *tty,
+								long timeout);
 extern void usb_serial_generic_read_bulk_callback(struct urb *urb);
 extern void usb_serial_generic_write_bulk_callback(struct urb *urb);
 extern void usb_serial_generic_throttle(struct tty_struct *tty);


