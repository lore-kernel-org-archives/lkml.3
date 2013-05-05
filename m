Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210Ab3EESdR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 14:33:17 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:63267 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab3EESdM (ORCPT
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
Subject: [PATCH 3/7] USB: ftdi_sio: clean up get_modem_status
Date: Sun,  5 May 2013 20:32:29 +0200
Message-Id: <1367778753-22297-4-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1367778753-22297-1-git-send-email-jhovold@gmail.com>
References: <20130505182913.GE16818@localhost>
 <1367778753-22297-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use usb-serial port rather than tty as argument to get_modem_status.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/ftdi_sio.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 242b577..1159fd4 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -925,7 +925,7 @@ static int  ftdi_ioctl(struct tty_struct *tty,
 			unsigned int cmd, unsigned long arg);
 static void ftdi_break_ctl(struct tty_struct *tty, int break_state);
 static int ftdi_chars_in_buffer(struct tty_struct *tty);
-static int ftdi_get_modem_status(struct tty_struct *tty,
+static int ftdi_get_modem_status(struct usb_serial_port *port,
 						unsigned char status[2]);
 
 static unsigned short int ftdi_232am_baud_base_to_divisor(int baud, int base);
@@ -2068,7 +2068,7 @@ static int ftdi_chars_in_buffer(struct tty_struct *tty)
 		goto out;
 
 	/* Check if hardware buffer is empty. */
-	ret = ftdi_get_modem_status(tty, buf);
+	ret = ftdi_get_modem_status(port, buf);
 	if (ret == 2) {
 		if (!(buf[1] & FTDI_RS_TEMT))
 			chars = 1;
@@ -2268,10 +2268,9 @@ no_c_cflag_changes:
  * Returns the number of status bytes retrieved (device dependant), or
  * negative error code.
  */
-static int ftdi_get_modem_status(struct tty_struct *tty,
+static int ftdi_get_modem_status(struct usb_serial_port *port,
 						unsigned char status[2])
 {
-	struct usb_serial_port *port = tty->driver_data;
 	struct ftdi_private *priv = usb_get_serial_port_data(port);
 	unsigned char *buf;
 	int len;
@@ -2336,7 +2335,7 @@ static int ftdi_tiocmget(struct tty_struct *tty)
 	unsigned char buf[2];
 	int ret;
 
-	ret = ftdi_get_modem_status(tty, buf);
+	ret = ftdi_get_modem_status(port, buf);
 	if (ret < 0)
 		return ret;
 
-- 
1.8.2.1

