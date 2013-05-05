Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394Ab3EESeF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 14:34:05 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:61969 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977Ab3EESdM (ORCPT
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
Subject: [PATCH 1/7] USB: serial: add wait_until_sent operation
Date: Sun,  5 May 2013 20:32:27 +0200
Message-Id: <1367778753-22297-2-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1367778753-22297-1-git-send-email-jhovold@gmail.com>
References: <20130505182913.GE16818@localhost>
 <1367778753-22297-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add wait_until_sent operation which can be used to wait for hardware
buffers to drain.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/usb-serial.c | 17 +++++++++++++++++
 include/linux/usb/serial.h      |  1 +
 2 files changed, 18 insertions(+)

diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index cf75beb..31d2768 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -375,6 +375,22 @@ static int serial_chars_in_buffer(struct tty_struct *tty)
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
@@ -1191,6 +1207,7 @@ static const struct tty_operations serial_ops = {
 	.unthrottle =		serial_unthrottle,
 	.break_ctl =		serial_break,
 	.chars_in_buffer =	serial_chars_in_buffer,
+	.wait_until_sent =	serial_wait_until_sent,
 	.tiocmget =		serial_tiocmget,
 	.tiocmset =		serial_tiocmset,
 	.get_icount =		serial_get_icount,
diff --git a/include/linux/usb/serial.h b/include/linux/usb/serial.h
index b9b0f7b4..afbb7ee 100644
--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -268,6 +268,7 @@ struct usb_serial_driver {
 			struct usb_serial_port *port, struct ktermios *old);
 	void (*break_ctl)(struct tty_struct *tty, int break_state);
 	int  (*chars_in_buffer)(struct tty_struct *tty);
+	void (*wait_until_sent)(struct tty_struct *tty, long timeout);
 	void (*throttle)(struct tty_struct *tty);
 	void (*unthrottle)(struct tty_struct *tty);
 	int  (*tiocmget)(struct tty_struct *tty);
-- 
1.8.2.1

