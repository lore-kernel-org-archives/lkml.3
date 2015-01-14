Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751212AbbANGFt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 01:05:49 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:42891 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbbANGFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 01:05:47 -0500
From: Baruch Siach <baruch@tkos.co.il>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH] tty/serial: digicolor: remove sysrq reference
Date: Wed, 14 Jan 2015 08:04:21 +0200
Message-Id: <445cef8cec6347114a20c79c77272e25ee804668.1421215461.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Digicolor USART hardware does not support detecting the BREAK condition.
This means that we can't support sysrq on this hardware. Remove all reference
to sysrq from the code.

This also fixes build when sysrq is disabled:

drivers/tty/serial/digicolor-usart.c: In function 'digicolor_uart_console_write':
drivers/tty/serial/digicolor-usart.c:407:33: error: 'struct uart_port' has no member named 'sysrq'

Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 drivers/tty/serial/digicolor-usart.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/tty/serial/digicolor-usart.c b/drivers/tty/serial/digicolor-usart.c
index 09ce0b3764e2..a80cdad114f3 100644
--- a/drivers/tty/serial/digicolor-usart.c
+++ b/drivers/tty/serial/digicolor-usart.c
@@ -170,9 +170,6 @@ static void digicolor_uart_rx(struct uart_port *port)
 				ch_flag = TTY_OVERRUN;
 		}
 
-		if (uart_handle_sysrq_char(port, ch))
-			continue;
-
 		if (status & port->ignore_status_mask)
 			continue;
 
@@ -404,7 +401,7 @@ static void digicolor_uart_console_write(struct console *co, const char *c,
 	unsigned long flags;
 	int locked = 1;
 
-	if (port->sysrq || oops_in_progress)
+	if (oops_in_progress)
 		locked = spin_trylock_irqsave(&port->lock, flags);
 	else
 		spin_lock_irqsave(&port->lock, flags);
-- 
2.1.4

