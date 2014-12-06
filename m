Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbaLFPYe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:24:34 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:47690 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752049AbaLFPID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:08:03 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 36/66] USB: keyspan: fix tty line-status reporting
Date: Sat,  6 Dec 2014 16:07:28 +0100
Message-Id: <b20d1dbcbf5fec5ae4d574ad482073d9476cd7c1.1417878427.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
References: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
In-Reply-To: <cover.1417878427.git.jslaby@suse.cz>
References: <cover.1417878427.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 5d1678a33c731b56e245e888fdae5e88efce0997 upstream.

Fix handling of TTY error flags, which are not bitmasks and must
specifically not be ORed together as this prevents the line discipline
from recognising them.

Also insert null characters when reporting overrun errors as these are
not associated with the received character.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/serial/keyspan.c | 76 ++++++++++++++++++++++++++++----------------
 1 file changed, 48 insertions(+), 28 deletions(-)

diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index 7053e0a9bb05..dc3a77c8cd83 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -323,14 +323,19 @@ static void	usa26_indat_callback(struct urb *urb)
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
@@ -668,14 +673,19 @@ static void	usa49_indat_callback(struct urb *urb)
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
@@ -732,15 +742,19 @@ static void usa49wg_indat_callback(struct urb *urb)
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
@@ -803,14 +817,20 @@ static void usa90_indat_callback(struct urb *urb)
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

