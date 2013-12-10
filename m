Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab3LJI0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:26:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58751 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367Ab3LJIAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:00:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Colin Leitner <colin.leitner@gmail.com>,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 3.10 46/52] USB: ftdi_sio: fixed handling of unsupported CSIZE setting
Date: Tue, 10 Dec 2013 00:01:19 -0800
Message-Id: <20131210075957.414492150@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131210075954.196229872@linuxfoundation.org>
References: <20131210075954.196229872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/serial/ftdi_sio.c |   37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -2131,6 +2131,20 @@ static void ftdi_set_termios(struct tty_
 		termios->c_cflag |= CRTSCTS;
 	}
 
+	/*
+	 * All FTDI UART chips are limited to CS7/8. We won't pretend to
+	 * support CS5/6 and revert the CSIZE setting instead.
+	 */
+	if ((C_CSIZE(tty) != CS8) && (C_CSIZE(tty) != CS7)) {
+		dev_warn(ddev, "requested CSIZE setting not supported\n");
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
@@ -2167,19 +2181,16 @@ no_skip:
 	} else {
 		urb_value |= FTDI_SIO_SET_DATA_PARITY_NONE;
 	}
-	if (cflag & CSIZE) {
-		switch (cflag & CSIZE) {
-		case CS7:
-			urb_value |= 7;
-			dev_dbg(ddev, "Setting CS7\n");
-			break;
-		case CS8:
-			urb_value |= 8;
-			dev_dbg(ddev, "Setting CS8\n");
-			break;
-		default:
-			dev_err(ddev, "CSIZE was set but not CS7-CS8\n");
-		}
+	switch (cflag & CSIZE) {
+	case CS7:
+		urb_value |= 7;
+		dev_dbg(ddev, "Setting CS7\n");
+		break;
+	default:
+	case CS8:
+		urb_value |= 8;
+		dev_dbg(ddev, "Setting CS8\n");
+		break;
 	}
 
 	/* This is needed by the break command since it uses the same command


