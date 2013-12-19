Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740Ab3LSMUN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:20:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45136 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755587Ab3LSL6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:58:50 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Colin Leitner <colin.leitner@gmail.com>, Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 147/208] USB: pl2303: fixed handling of CS5 setting
Date: Thu, 19 Dec 2013 11:54:05 +0000
Message-Id: <1387454106-19326-148-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/pl2303.c | 31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index cb6bbed..28088cc 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -303,24 +303,21 @@ static void pl2303_set_termios(struct tty_struct *tty,
 			    0, 0, buf, 7, 100);
 	dev_dbg(&port->dev, "0xa1:0x21:0:0  %d - %7ph\n", i, buf);
 
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
-		dev_dbg(&port->dev, "data bits = %d\n", buf[6]);
+	switch (cflag & CSIZE) {
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
-- 
1.8.3.2

