Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab3L2CJ5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:09:57 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54984 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751753Ab3L2CJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:09:49 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Johan Hovold" <jhovold@gmail.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Colin Leitner" <colin.leitner@googlemail.com>,
        "Colin Leitner" <colin.leitner@gmail.com>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.350029538@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 120/185] USB: pl2303: fixed handling of CS5 setting
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

commit a313249937820f8b1996133fc285efbd6aad2c5b upstream.

This patch fixes the CS5 setting on the PL2303 USB-to-serial devices. CS5 has a
value of 0 and the CSIZE setting has been skipped altogether by the enclosing
if. Tested on 3.11.6 and the scope shows the correct output after the fix has
been applied.

Tagged to be added to stable, because it fixes a user visible driver bug and is
simple enough to backport easily.

Signed-off-by: Colin Leitner <colin.leitner@gmail.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2:
 - Old code is cosmetically different]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/pl2303.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -290,24 +290,21 @@ static void pl2303_set_termios(struct tt
 	dbg("0xa1:0x21:0:0  %d - %x %x %x %x %x %x %x", i,
 	    buf[0], buf[1], buf[2], buf[3], buf[4], buf[5], buf[6]);
 
-	if (cflag & CSIZE) {
-		switch (cflag & CSIZE) {
-		case CS5:
-			buf[6] = 5;
-			break;
-		case CS6:
-			buf[6] = 6;
-			break;
-		case CS7:
-			buf[6] = 7;
-			break;
-		default:
-		case CS8:
-			buf[6] = 8;
-			break;
-		}
-		dbg("%s - data bits = %d", __func__, buf[6]);
+	switch (C_CSIZE(tty)) {
+	case CS5:
+		buf[6] = 5;
+		break;
+	case CS6:
+		buf[6] = 6;
+		break;
+	case CS7:
+		buf[6] = 7;
+		break;
+	default:
+	case CS8:
+		buf[6] = 8;
 	}
+	dev_dbg(&port->dev, "data bits = %d\n", buf[6]);
 
 	/* For reference buf[0]:buf[3] baud rate value */
 	/* NOTE: Only the values defined in baud_sup are supported !

