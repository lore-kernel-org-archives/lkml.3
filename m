Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbaKRK0A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 05:26:00 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:37085 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943AbaKRKZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 05:25:57 -0500
From: Johan Hovold <johan@kernel.org>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable <stable@vger.kernel.org>
Subject: [PATCH 1/3] USB: keyspan: fix tty line-status reporting
Date: Tue, 18 Nov 2014 11:25:19 +0100
Message-Id: <1416306321-22613-1-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix handling of TTY error flags, which are not bitmasks and must
specifically not be ORed together as this prevents the line discipline
from recognising them.

Also insert null characters when reporting overrun errors as these are
not associated with the received character.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/keyspan.c | 76 ++++++++++++++++++++++++++++----------------
 1 file changed, 48 insertions(+), 28 deletions(-)

diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index 93cb7cebda62..7799d8bc4a63 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -321,14 +321,19 @@ static void	usa26_indat_callback(struct urb *urb)
 			/* some bytes had errors, every byte has status */
 			dev_dbg(&port->dev, "%s - RX error!!!!\n", __func__);
 			for (i = 0; i + 1 < urb->actual_length; i += 2) {
-				int stat = data[i], flag = 0;
-				if (stat & RXERROR_OVERRUN)
-					flag |= TTY_OVERRUN;
-				if (stat & RXERROR_FRAMING)
-					flag |= TTY_FRAME;
-				if (stat & RXERROR_PARITY)
-					flag |= TTY_PARITY;
+				int stat = data[i];
+				int flag = TTY_NORMAL;
+
+				if (stat & RXERROR_OVERRUN) {
+					tty_insert_flip_char(&port->port, 0,
+								TTY_OVERRUN);
+				}
 				/* XXX should handle break (0x10) */
+				if (stat & RXERROR_PARITY)
+					flag = TTY_PARITY;
+				else if (stat & RXERROR_FRAMING)
+					flag = TTY_FRAME;
+
 				tty_insert_flip_char(&port->port, data[i+1],
 						flag);
 			}
@@ -649,14 +654,19 @@ static void	usa49_indat_callback(struct urb *urb)
 		} else {
 			/* some bytes had errors, every byte has status */
 			for (i = 0; i + 1 < urb->actual_length; i += 2) {
-				int stat = data[i], flag = 0;
-				if (stat & RXERROR_OVERRUN)
-					flag |= TTY_OVERRUN;
-				if (stat & RXERROR_FRAMING)
-					flag |= TTY_FRAME;
-				if (stat & RXERROR_PARITY)
-					flag |= TTY_PARITY;
+				int stat = data[i];
+				int flag = TTY_NORMAL;
+
+				if (stat & RXERROR_OVERRUN) {
+					tty_insert_flip_char(&port->port, 0,
+								TTY_OVERRUN);
+				}
 				/* XXX should handle break (0x10) */
+				if (stat & RXERROR_PARITY)
+					flag = TTY_PARITY;
+				else if (stat & RXERROR_FRAMING)
+					flag = TTY_FRAME;
+
 				tty_insert_flip_char(&port->port, data[i+1],
 						flag);
 			}
@@ -713,15 +723,19 @@ static void usa49wg_indat_callback(struct urb *urb)
 			 */
 			for (x = 0; x + 1 < len &&
 				    i + 1 < urb->actual_length; x += 2) {
-				int stat = data[i], flag = 0;
+				int stat = data[i];
+				int flag = TTY_NORMAL;
 
-				if (stat & RXERROR_OVERRUN)
-					flag |= TTY_OVERRUN;
-				if (stat & RXERROR_FRAMING)
-					flag |= TTY_FRAME;
-				if (stat & RXERROR_PARITY)
-					flag |= TTY_PARITY;
+				if (stat & RXERROR_OVERRUN) {
+					tty_insert_flip_char(&port->port, 0,
+								TTY_OVERRUN);
+				}
 				/* XXX should handle break (0x10) */
+				if (stat & RXERROR_PARITY)
+					flag = TTY_PARITY;
+				else if (stat & RXERROR_FRAMING)
+					flag = TTY_FRAME;
+
 				tty_insert_flip_char(&port->port, data[i+1],
 						     flag);
 				i += 2;
@@ -784,14 +798,20 @@ static void usa90_indat_callback(struct urb *urb)
 			/* some bytes had errors, every byte has status */
 				dev_dbg(&port->dev, "%s - RX error!!!!\n", __func__);
 				for (i = 0; i + 1 < urb->actual_length; i += 2) {
-					int stat = data[i], flag = 0;
-					if (stat & RXERROR_OVERRUN)
-						flag |= TTY_OVERRUN;
-					if (stat & RXERROR_FRAMING)
-						flag |= TTY_FRAME;
-					if (stat & RXERROR_PARITY)
-						flag |= TTY_PARITY;
+					int stat = data[i];
+					int flag = TTY_NORMAL;
+
+					if (stat & RXERROR_OVERRUN) {
+						tty_insert_flip_char(
+								&port->port, 0,
+								TTY_OVERRUN);
+					}
 					/* XXX should handle break (0x10) */
+					if (stat & RXERROR_PARITY)
+						flag = TTY_PARITY;
+					else if (stat & RXERROR_FRAMING)
+						flag = TTY_FRAME;
+
 					tty_insert_flip_char(&port->port,
 							data[i+1], flag);
 				}
-- 
2.0.4

