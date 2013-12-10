Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab3LJICn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:02:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59021 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab3LJICh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:02:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Colin Leitner <colin.leitner@gmail.com>,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 3.12 57/62] USB: pl2303: fixed handling of CS5 setting
Date: Tue, 10 Dec 2013 00:01:28 -0800
Message-Id: <20131210080101.404569544@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131210080057.415644748@linuxfoundation.org>
References: <20131210080057.415644748@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/serial/pl2303.c |   30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -361,23 +361,21 @@ static void pl2303_set_termios(struct tt
 			    0, 0, buf, 7, 100);
 	dev_dbg(&port->dev, "0xa1:0x21:0:0  %d - %7ph\n", i, buf);
 
-	if (C_CSIZE(tty)) {
-		switch (C_CSIZE(tty)) {
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
 	pl2303_encode_baudrate(tty, port, &buf[0]);


