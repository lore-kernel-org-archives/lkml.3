Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbaAOVyN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 16:54:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40751 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbaAOVyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:54:05 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Colin Leitner <colin.leitner@gmail.com>, Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 021/166] USB: pl2303: fixed handling of CS5 setting
Date: Wed, 15 Jan 2014 13:50:35 -0800
Message-Id: <1389822780-4729-22-git-send-email-kamal@canonical.com>
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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/pl2303.c | 31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index a16d378..037fd68 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -303,24 +303,21 @@ static void pl2303_set_termios(struct tty_struct *tty,
 	dev_dbg(&port->dev, "0xa1:0x21:0:0  %d - %x %x %x %x %x %x %x\n", i,
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
-		dev_dbg(&port->dev, "data bits = %d\n", buf[6]);
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
-- 
1.8.3.2

