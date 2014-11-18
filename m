Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbaKRK0E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 05:26:04 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:50735 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957AbaKRKZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 05:25:58 -0500
From: Johan Hovold <johan@kernel.org>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable <stable@vger.kernel.org>
Subject: [PATCH 3/3] USB: ssu100: fix overrun-error reporting
Date: Tue, 18 Nov 2014 11:25:21 +0100
Message-Id: <1416306321-22613-3-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1416306321-22613-1-git-send-email-johan@kernel.org>
References: <1416306321-22613-1-git-send-email-johan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix reporting of overrun errors, which should only be reported once
using the inserted null character.

Fixes: 6b8f1ca5581b ("USB: ssu100: set tty_flags in ssu100_process_packet")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/ssu100.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/serial/ssu100.c b/drivers/usb/serial/ssu100.c
index a7fe664b6b7d..70a098de429f 100644
--- a/drivers/usb/serial/ssu100.c
+++ b/drivers/usb/serial/ssu100.c
@@ -490,10 +490,9 @@ static void ssu100_update_lsr(struct usb_serial_port *port, u8 lsr,
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
 
@@ -511,12 +510,8 @@ static void ssu100_process_read_urb(struct urb *urb)
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
2.0.4

