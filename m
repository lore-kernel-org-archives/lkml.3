Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab3AXEbq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 23:31:46 -0500
Received: from mail.windriver.com ([147.11.1.11]:59545 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab3AXEbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 23:31:39 -0500
From: Liang Li <liang.li@windriver.com>
To: <gregkh@linuxfoundation.org>, <linux-serial@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <liang.li@windriver.com>, <sfr@canb.auug.org.au>, <rdunlap@infradead.org>,
        <linux-next@vger.kernel.org>
Subject: [PATCH] serial: pch_uart: fix sysrq handling for pch_uart
Date: Thu, 24 Jan 2013 12:31:27 +0800
Message-ID: <1359001887-1016-1-git-send-email-liang.li@windriver.com>
X-Mailer: git-send-email 1.7.11.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When PCH_UART_CONSOLE and SERIAL_CORE_CONSOLE is not set neither, the
uart_port will have no 'sysrq' member hence their will need a '#ifdef'
in pch_uart.c to handle the case, otherwise we'll see compile error
like this:

  CC [M]  drivers/tty/serial/pch_uart.o
drivers/tty/serial/pch_uart.c: In function 'pch_uart_hal_read':
drivers/tty/serial/pch_uart.c:572:11: error: 'struct uart_port' has no member named 'sysrq'
make[4]: *** [drivers/tty/serial/pch_uart.o] Error 1

Reported-by: Randy Dunlap <rdunlap@infradead.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Liang Li <liang.li@windriver.com>
---
Hi Greg,

This is for 'tty-next' of your tty tree. Thanks.

 drivers/tty/serial/pch_uart.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 1ddfc66..7a6c989 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -569,10 +569,12 @@ static int pch_uart_hal_read(struct eg20t_port *priv, unsigned char *buf,
 			if (uart_handle_break(port))
 				continue;
 		}
+#ifdef SUPPORT_SYSRQ
 		if (port->sysrq) {
 			if (uart_handle_sysrq_char(port, rbr))
 				continue;
 		}
+#endif
 
 		buf[i++] = rbr;
 	}
-- 
1.7.11.4

