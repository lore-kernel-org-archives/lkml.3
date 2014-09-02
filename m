Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbaIBVnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 17:43:46 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:50330 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755184AbaIBVkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 17:40:05 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 04/26] serial: core: Fix x_char race
Date: Tue,  2 Sep 2014 17:39:13 -0400
Message-Id: <1409693975-1028-5-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409693975-1028-1-git-send-email-peter@hurleysoftware.com>
References: <1409693975-1028-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The UART driver is expected to clear port->x_char after
transmission while holding the port->lock. However, the serial
core fails to take the port->lock before assigning port->xchar.
This allows for the following race

CPU 0                         |  CPU 1
                              |
                              | serial8250_handle_irq
                              |   ...
                              |   serial8250_tx_chars
                              |     if (port->x_char)
                              |       serial_out(up, UART_TX, port->x_char)
uart_send_xchar               |
  port->x_char = ch           |
                              |       port->x_char = 0
  port->ops->start_tx()       |
                              |

The x_char on CPU 0 will never be sent.

Take the port->lock in uart_send_xchar() before assigning port->x_char.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/serial/serial_core.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 87cde4c..a68bff0 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -596,12 +596,11 @@ static void uart_send_xchar(struct tty_struct *tty, char ch)
 	if (port->ops->send_xchar)
 		port->ops->send_xchar(port, ch);
 	else {
+		spin_lock_irqsave(&port->lock, flags);
 		port->x_char = ch;
-		if (ch) {
-			spin_lock_irqsave(&port->lock, flags);
+		if (ch)
 			port->ops->start_tx(port);
-			spin_unlock_irqrestore(&port->lock, flags);
-		}
+		spin_unlock_irqrestore(&port->lock, flags);
 	}
 }
 
-- 
2.1.0

