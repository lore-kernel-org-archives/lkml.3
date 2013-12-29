Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057Ab3L2CKp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:10:45 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55240 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752250Ab3L2CKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:33 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Johan Hovold" <jhovold@gmail.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Colin Leitner" <colin.leitner@gmail.com>,
        "Colin Leitner" <colin.leitner@googlemail.com>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.282215900@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 119/185] USB: ftdi_sio: fixed handling of unsupported
 CSIZE setting
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Leitner <colin.leitner@googlemail.com>

commit 8704211f65a2106ba01b6ac9727cdaf9ca11594c upstream.

FTDI UARTs support only 7 or 8 data bits. Until now the ftdi_sio driver would
only report this limitation for CS6 to dmesg and fail to reflect this fact to
tcgetattr.

This patch reverts the unsupported CSIZE setting and reports the fact with less
severance to dmesg for both CS5 and CS6.

To test the patch it's sufficient to call

    stty -F /dev/ttyUSB0 cs5

which will succeed without the patch and report an error with the patch
applied.

As an additional fix this patch ensures that the control request will always
include a data bit size.

Signed-off-by: Colin Leitner <colin.leitner@gmail.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2:
 - Old code is cosmetically different
 - s/ddev/\&port->dev/]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/ftdi_sio.c | 37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -2192,6 +2192,20 @@ static void ftdi_set_termios(struct tty_
 		termios->c_cflag |= CRTSCTS;
 	}
 
+	/*
+	 * All FTDI UART chips are limited to CS7/8. We won't pretend to
+	 * support CS5/6 and revert the CSIZE setting instead.
+	 */
+	if ((C_CSIZE(tty) != CS8) && (C_CSIZE(tty) != CS7)) {
+		dev_warn(&port->dev, "requested CSIZE setting not supported\n");
+
+		termios->c_cflag &= ~CSIZE;
+		if (old_termios)
+			termios->c_cflag |= old_termios->c_cflag & CSIZE;
+		else
+			termios->c_cflag |= CS8;
+	}
+
 	cflag = termios->c_cflag;
 
 	if (!old_termios)
@@ -2228,13 +2242,16 @@ no_skip:
 	} else {
 		urb_value |= FTDI_SIO_SET_DATA_PARITY_NONE;
 	}
-	if (cflag & CSIZE) {
-		switch (cflag & CSIZE) {
-		case CS7: urb_value |= 7; dbg("Setting CS7"); break;
-		case CS8: urb_value |= 8; dbg("Setting CS8"); break;
-		default:
-			dev_err(&port->dev, "CSIZE was set but not CS7-CS8\n");
-		}
+	switch (cflag & CSIZE) {
+	case CS7:
+		urb_value |= 7;
+		dev_dbg(&port->dev, "Setting CS7\n");
+		break;
+	default:
+	case CS8:
+		urb_value |= 8;
+		dev_dbg(&port->dev, "Setting CS8\n");
+		break;
 	}
 
 	/* This is needed by the break command since it uses the same command

