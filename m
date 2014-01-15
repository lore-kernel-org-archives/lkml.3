Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbaAOVyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 16:54:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40746 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000AbaAOVyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:54:03 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Colin Leitner <colin.leitner@gmail.com>, Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 020/166] USB: ftdi_sio: fixed handling of unsupported CSIZE setting
Date: Wed, 15 Jan 2014 13:50:34 -0800
Message-Id: <1389822780-4729-21-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/ftdi_sio.c | 37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 2bc1966..ede7f9f 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -2180,6 +2180,20 @@ static void ftdi_set_termios(struct tty_struct *tty,
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
@@ -2216,19 +2230,16 @@ no_skip:
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
-- 
1.8.3.2

