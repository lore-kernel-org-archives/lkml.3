Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992Ab3FKUJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:09:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42011 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756765Ab3FKUEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:04:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 71/79] USB: serial: add wait_until_sent operation
Date: Tue, 11 Jun 2013 13:03:37 -0700
Message-Id: <20130611195325.361834559@linuxfoundation.org>
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

commit 0693196fe7bbb5e6cafd255dfce91ff6d10bc18f upstream.

Add wait_until_sent operation which can be used to wait for hardware
buffers to drain.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/usb-serial.c |   17 +++++++++++++++++
 include/linux/usb/serial.h      |    1 +
 2 files changed, 18 insertions(+)

--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -379,6 +379,22 @@ static int serial_chars_in_buffer(struct
 	return count;
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
@@ -1204,6 +1220,7 @@ static const struct tty_operations seria
 	.unthrottle =		serial_unthrottle,
 	.break_ctl =		serial_break,
 	.chars_in_buffer =	serial_chars_in_buffer,
+	.wait_until_sent =	serial_wait_until_sent,
 	.tiocmget =		serial_tiocmget,
 	.tiocmset =		serial_tiocmset,
 	.get_icount =		serial_get_icount,
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


