Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab3EESeB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 14:34:01 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:54036 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab3EESdM (ORCPT
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
Subject: [PATCH 7/7] USB: serial: clean up chars_in_buffer
Date: Sun,  5 May 2013 20:32:33 +0200
Message-Id: <1367778753-22297-8-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1367778753-22297-1-git-send-email-jhovold@gmail.com>
References: <20130505182913.GE16818@localhost>
 <1367778753-22297-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to grab disconnect mutex in chars_in_buffer now that no
sub-driver is or should be querying hardware buffers anymore. (They
should use wait_until_sent.)

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/usb-serial.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 60caf9c..4753c00 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -359,20 +359,13 @@ static int serial_chars_in_buffer(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct usb_serial *serial = port->serial;
-	int count = 0;
 
 	dev_dbg(tty->dev, "%s\n", __func__);
 
-	mutex_lock(&serial->disc_mutex);
-	/* if the device was unplugged then any remaining characters
-	   fell out of the connector ;) */
 	if (serial->disconnected)
-		count = 0;
-	else
-		count = serial->type->chars_in_buffer(tty);
-	mutex_unlock(&serial->disc_mutex);
+		return 0;
 
-	return count;
+	return serial->type->chars_in_buffer(tty);
 }
 
 static void serial_wait_until_sent(struct tty_struct *tty, int timeout)
-- 
1.8.2.1

