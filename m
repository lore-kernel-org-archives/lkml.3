Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbaBGLno (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:43:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41000 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbaBGLYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:24:24 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Colin Leitner <colin.leitner@gmail.com>, Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 40/88] USB: ftdi_sio: added CS5 quirk for broken smartcard readers
Date: Fri,  7 Feb 2014 11:22:37 +0000
Message-Id: <1391772205-22239-41-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
References: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.30 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5:
  - adjusted context
  - replace dev_dbg() by dbg() ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/ftdi_sio.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 947da9d..82c392f 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -2162,10 +2162,20 @@ static void ftdi_set_termios(struct tty_struct *tty,
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
 		dev_warn(&port->dev, "requested CSIZE setting not supported\n");
 
 		termios->c_cflag &= ~CSIZE;
@@ -2212,6 +2222,9 @@ no_skip:
 		urb_value |= FTDI_SIO_SET_DATA_PARITY_NONE;
 	}
 	switch (cflag & CSIZE) {
+	case CS5:
+		dbg("Setting CS5 quirk\n");
+		break;
 	case CS7:
 		urb_value |= 7;
 		dbg("Setting CS7\n");
-- 
1.8.3.2

