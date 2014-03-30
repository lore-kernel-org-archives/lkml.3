Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293AbaC3Xmj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:42:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753812AbaC3Xmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:42:35 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Heinrich Siebmanns" <H.Siebmanns@t-online.de>,
        "Colin Leitner" <colin.leitner@googlemail.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Colin Leitner" <colin.leitner@gmail.com>,
        "Johan Hovold" <jhovold@gmail.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.183788792@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 024/200] USB: ftdi_sio: added CS5 quirk for broken
 smartcard readers
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: s/ddev/\&port->dev/]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/ftdi_sio.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -2193,10 +2193,20 @@ static void ftdi_set_termios(struct tty_
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
@@ -2243,6 +2253,9 @@ no_skip:
 		urb_value |= FTDI_SIO_SET_DATA_PARITY_NONE;
 	}
 	switch (cflag & CSIZE) {
+	case CS5:
+		dev_dbg(&port->dev, "Setting CS5 quirk\n");
+		break;
 	case CS7:
 		urb_value |= 7;
 		dev_dbg(&port->dev, "Setting CS7\n");

