Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbaLOOzV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:55:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38607 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718AbaLOO2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:28:14 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <johan@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 084/168] USB: keyspan: fix tty line-status reporting
Date: Mon, 15 Dec 2014 14:25:38 +0000
Message-Id: <1418653622-21105-85-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 5d1678a33c731b56e245e888fdae5e88efce0997 upstream.

Fix handling of TTY error flags, which are not bitmasks and must
specifically not be ORed together as this prevents the line discipline
from recognising them.

Also insert null characters when reporting overrun errors as these are
not associated with the received character.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
2.1.3

