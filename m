Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914Ab3LJIjy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:39:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58395 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab3LJH7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 02:59:25 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Colin Leitner <colin.leitner@gmail.com>,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 3.4 21/25] USB: pl2303: fixed handling of CS5 setting
Date: Tue, 10 Dec 2013 00:00:29 -0800
Message-Id: <20131210075932.304861291@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131210075930.808460227@linuxfoundation.org>
References: <20131210075930.808460227@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/usb/serial/pl2303.c |   32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -290,24 +290,22 @@ static void pl2303_set_termios(struct tt
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
+		break;
 	}
+	dbg("%s - data bits = %d", __func__, buf[6]);
 
 	/* For reference buf[0]:buf[3] baud rate value */
 	/* NOTE: Only the values defined in baud_sup are supported !


