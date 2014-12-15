Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412AbaLOT2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:28:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40659 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaLOT2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:28:08 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <johan@kernel.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 42/96] USB: ssu100: fix overrun-error reporting
Date: Mon, 15 Dec 2014 11:26:02 -0800
Message-Id: <1418671616-25482-43-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418671616-25482-1-git-send-email-kamal@canonical.com>
References: <1418671616-25482-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 75bcbf29c284dd0154c3e895a0bd1ef0e796160e upstream.

Fix reporting of overrun errors, which should only be reported once
using the inserted null character.

Fixes: 6b8f1ca5581b ("USB: ssu100: set tty_flags in ssu100_process_packet")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/ssu100.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/serial/ssu100.c b/drivers/usb/serial/ssu100.c
index e5750be..d667ff9 100644
--- a/drivers/usb/serial/ssu100.c
+++ b/drivers/usb/serial/ssu100.c
@@ -495,10 +495,9 @@ static void ssu100_update_lsr(struct usb_serial_port *port, u8 lsr,
 			if (*tty_flag == TTY_NORMAL)
 				*tty_flag = TTY_FRAME;
 		}
-		if (lsr & UART_LSR_OE){
+		if (lsr & UART_LSR_OE) {
 			port->icount.overrun++;
-			if (*tty_flag == TTY_NORMAL)
-				*tty_flag = TTY_OVERRUN;
+			tty_insert_flip_char(&port->port, 0, TTY_OVERRUN);
 		}
 	}
 
@@ -516,12 +515,8 @@ static void ssu100_process_read_urb(struct urb *urb)
 	if ((len >= 4) &&
 	    (packet[0] == 0x1b) && (packet[1] == 0x1b) &&
 	    ((packet[2] == 0x00) || (packet[2] == 0x01))) {
-		if (packet[2] == 0x00) {
+		if (packet[2] == 0x00)
 			ssu100_update_lsr(port, packet[3], &flag);
-			if (flag == TTY_OVERRUN)
-				tty_insert_flip_char(&port->port, 0,
-						TTY_OVERRUN);
-		}
 		if (packet[2] == 0x01)
 			ssu100_update_msr(port, packet[3]);
 
-- 
1.9.1

