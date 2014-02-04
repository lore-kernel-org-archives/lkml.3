Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935848AbaBDWYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:24:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56611 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933809AbaBDVIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:08:22 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Heinrich Siebmanns <H.Siebmanns@t-online.de>,
        Colin Leitner <colin.leitner@gmail.com>,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 3.12 022/133] USB: ftdi_sio: added CS5 quirk for broken smartcard readers
Date: Tue,  4 Feb 2014 13:07:03 -0800
Message-Id: <20140204210737.653796786@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210737.008598235@linuxfoundation.org>
References: <20140204210737.008598235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Leitner <colin.leitner@googlemail.com>

commit c1f15196ac3b541d084dc80a8fbd8a74c6a0bd44 upstream.

Genuine FTDI chips support only CS7/8. A previous fix in commit
8704211f65a2 ("USB: ftdi_sio: fixed handling of unsupported CSIZE
setting") enforced this limitation and reported it back to userspace.

However, certain types of smartcard readers depend on specific
driver behaviour that requests 0 data bits (not 5) to change into a
different operating mode if CS5 has been set.

This patch reenables this behaviour for all FTDI devices.

Tagged to be added to stable, because it affects a lot of users of
embedded systems which rely on these readers to work properly.

Reported-by: Heinrich Siebmanns <H.Siebmanns@t-online.de>
Tested-by: Heinrich Siebmanns <H.Siebmanns@t-online.de>
Signed-off-by: Colin Leitner <colin.leitner@gmail.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ftdi_sio.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -2116,10 +2116,20 @@ static void ftdi_set_termios(struct tty_
 	}
 
 	/*
-	 * All FTDI UART chips are limited to CS7/8. We won't pretend to
+	 * All FTDI UART chips are limited to CS7/8. We shouldn't pretend to
 	 * support CS5/6 and revert the CSIZE setting instead.
+	 *
+	 * CS5 however is used to control some smartcard readers which abuse
+	 * this limitation to switch modes. Original FTDI chips fall back to
+	 * eight data bits.
+	 *
+	 * TODO: Implement a quirk to only allow this with mentioned
+	 *       readers. One I know of (Argolis Smartreader V1)
+	 *       returns "USB smartcard server" as iInterface string.
+	 *       The vendor didn't bother with a custom VID/PID of
+	 *       course.
 	 */
-	if ((C_CSIZE(tty) != CS8) && (C_CSIZE(tty) != CS7)) {
+	if (C_CSIZE(tty) == CS6) {
 		dev_warn(ddev, "requested CSIZE setting not supported\n");
 
 		termios->c_cflag &= ~CSIZE;
@@ -2166,6 +2176,9 @@ no_skip:
 		urb_value |= FTDI_SIO_SET_DATA_PARITY_NONE;
 	}
 	switch (cflag & CSIZE) {
+	case CS5:
+		dev_dbg(ddev, "Setting CS5 quirk\n");
+		break;
 	case CS7:
 		urb_value |= 7;
 		dev_dbg(ddev, "Setting CS7\n");


