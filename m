Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233AbaLEXP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:15:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54664 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923AbaLEXGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 18:06:36 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 3.10 25/45] USB: keyspan: fix tty line-status reporting
Date: Fri,  5 Dec 2014 14:45:08 -0800
Message-Id: <20141205223320.688448673@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223316.738290875@linuxfoundation.org>
References: <20141205223316.738290875@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/keyspan.c |   76 +++++++++++++++++++++++++++----------------
 1 file changed, 48 insertions(+), 28 deletions(-)

--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -319,14 +319,19 @@ static void	usa26_indat_callback(struct
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
@@ -673,14 +678,19 @@ static void	usa49_indat_callback(struct
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
@@ -737,15 +747,19 @@ static void usa49wg_indat_callback(struc
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
@@ -808,14 +822,20 @@ static void usa90_indat_callback(struct
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


