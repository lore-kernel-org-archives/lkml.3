Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab3LQSYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:24:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:32850 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924Ab3LQSP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:15:27 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Colin Leitner <colin.leitner@gmail.com>, Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 075/103] USB: ftdi_sio: fixed handling of unsupported CSIZE setting
Date: Tue, 17 Dec 2013 18:13:04 +0000
Message-Id: <1387304012-23805-76-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
References: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.28 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/ftdi_sio.c | 31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 6a979cd..947da9d 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -2161,6 +2161,20 @@ static void ftdi_set_termios(struct tty_struct *tty,
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
@@ -2197,13 +2211,16 @@ no_skip:
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
+		dbg("Setting CS7\n");
+		break;
+	default:
+	case CS8:
+		urb_value |= 8;
+		dbg("Setting CS8\n");
+		break;
 	}
 
 	/* This is needed by the break command since it uses the same command
-- 
1.8.3.2

