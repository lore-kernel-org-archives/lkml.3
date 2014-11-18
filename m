Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbaKRK0D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 05:26:03 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:46881 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954AbaKRKZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 05:25:58 -0500
From: Johan Hovold <johan@kernel.org>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable <stable@vger.kernel.org>
Subject: [PATCH 2/3] USB: keyspan: fix overrun-error reporting
Date: Tue, 18 Nov 2014 11:25:20 +0100
Message-Id: <1416306321-22613-2-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1416306321-22613-1-git-send-email-johan@kernel.org>
References: <1416306321-22613-1-git-send-email-johan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix reporting of overrun errors, which are not associated with a
character. Instead insert a null character and report only once.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/keyspan.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index 7799d8bc4a63..077c714f1285 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -311,12 +311,13 @@ static void	usa26_indat_callback(struct urb *urb)
 		if ((data[0] & 0x80) == 0) {
 			/* no errors on individual bytes, only
 			   possible overrun err */
-			if (data[0] & RXERROR_OVERRUN)
-				err = TTY_OVERRUN;
-			else
-				err = 0;
+			if (data[0] & RXERROR_OVERRUN) {
+				tty_insert_flip_char(&port->port, 0,
+								TTY_OVERRUN);
+			}
 			for (i = 1; i < urb->actual_length ; ++i)
-				tty_insert_flip_char(&port->port, data[i], err);
+				tty_insert_flip_char(&port->port, data[i],
+								TTY_NORMAL);
 		} else {
 			/* some bytes had errors, every byte has status */
 			dev_dbg(&port->dev, "%s - RX error!!!!\n", __func__);
@@ -787,13 +788,13 @@ static void usa90_indat_callback(struct urb *urb)
 			if ((data[0] & 0x80) == 0) {
 				/* no errors on individual bytes, only
 				   possible overrun err*/
-				if (data[0] & RXERROR_OVERRUN)
-					err = TTY_OVERRUN;
-				else
-					err = 0;
+				if (data[0] & RXERROR_OVERRUN) {
+					tty_insert_flip_char(&port->port, 0,
+								TTY_OVERRUN);
+				}
 				for (i = 1; i < urb->actual_length ; ++i)
 					tty_insert_flip_char(&port->port,
-							data[i], err);
+							data[i], TTY_NORMAL);
 			}  else {
 			/* some bytes had errors, every byte has status */
 				dev_dbg(&port->dev, "%s - RX error!!!!\n", __func__);
-- 
2.0.4

