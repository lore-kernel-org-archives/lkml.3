Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757081Ab3EHPwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 11:52:05 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:43376 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558Ab3EHPwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 11:52:03 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Peter Hurley <peter@hurleysoftware.com>, Stas Sergeev <stsp@list.ru>,
        Jarkko Huijts <jarkko.huijts@gmail.com>,
        Alan Cox <alan@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Caylan Van Larson <i@caylan.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH v2 2/8] USB: serial: add generic wait_until_sent implementation
Date: Wed,  8 May 2013 17:51:43 +0200
Message-Id: <1368028303-11923-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1367778753-22297-3-git-send-email-jhovold@gmail.com>
References: <1367778753-22297-3-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add generic wait_until_sent implementation which polls for empty
hardware buffers using the new port-operation tx_empty.

The generic implementation will be used for all sub-drivers that
implement tx_empty but does not define wait_until_sent.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---

v2: make sure to handle B0

 drivers/usb/serial/generic.c    | 31 +++++++++++++++++++++++++++++++
 drivers/usb/serial/usb-serial.c |  2 ++
 include/linux/usb/serial.h      |  3 +++
 3 files changed, 36 insertions(+)

diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index 297665f..ba45170 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -253,6 +253,37 @@ int usb_serial_generic_chars_in_buffer(struct tty_struct *tty)
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
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 31d2768..60caf9c 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -1333,6 +1333,8 @@ static void usb_serial_operations_init(struct usb_serial_driver *device)
 	set_to_generic_if_null(device, close);
 	set_to_generic_if_null(device, write_room);
 	set_to_generic_if_null(device, chars_in_buffer);
+	if (device->tx_empty)
+		set_to_generic_if_null(device, wait_until_sent);
 	set_to_generic_if_null(device, read_bulk_callback);
 	set_to_generic_if_null(device, write_bulk_callback);
 	set_to_generic_if_null(device, process_read_urb);
diff --git a/include/linux/usb/serial.h b/include/linux/usb/serial.h
index afbb7ee..302ddf5 100644
--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -269,6 +269,7 @@ struct usb_serial_driver {
 	void (*break_ctl)(struct tty_struct *tty, int break_state);
 	int  (*chars_in_buffer)(struct tty_struct *tty);
 	void (*wait_until_sent)(struct tty_struct *tty, long timeout);
+	bool (*tx_empty)(struct usb_serial_port *port);
 	void (*throttle)(struct tty_struct *tty);
 	void (*unthrottle)(struct tty_struct *tty);
 	int  (*tiocmget)(struct tty_struct *tty);
@@ -328,6 +329,8 @@ extern void usb_serial_generic_close(struct usb_serial_port *port);
 extern int usb_serial_generic_resume(struct usb_serial *serial);
 extern int usb_serial_generic_write_room(struct tty_struct *tty);
 extern int usb_serial_generic_chars_in_buffer(struct tty_struct *tty);
+extern void usb_serial_generic_wait_until_sent(struct tty_struct *tty,
+								long timeout);
 extern void usb_serial_generic_read_bulk_callback(struct urb *urb);
 extern void usb_serial_generic_write_bulk_callback(struct urb *urb);
 extern void usb_serial_generic_throttle(struct tty_struct *tty);
-- 
1.8.2.1

