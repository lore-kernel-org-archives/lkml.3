Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbaLFPYx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:24:53 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:47686 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752047AbaLFPIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:08:02 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 34/66] USB: ssu100: fix overrun-error reporting
Date: Sat,  6 Dec 2014 16:07:26 +0100
Message-Id: <6aac77da2f675a7b47ef4a48a0f58a3d3d2c0026.1417878427.git.jslaby@suse.cz>
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

commit 75bcbf29c284dd0154c3e895a0bd1ef0e796160e upstream.

Fix reporting of overrun errors, which should only be reported once
using the inserted null character.

Fixes: 6b8f1ca5581b ("USB: ssu100: set tty_flags in ssu100_process_packet")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/serial/ssu100.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/serial/ssu100.c b/drivers/usb/serial/ssu100.c
index e5750be49054..d667ff95ade4 100644
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
2.1.3

