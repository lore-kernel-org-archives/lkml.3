Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737AbaLIJMB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 04:12:01 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:62476 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755424AbaLIJLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 04:11:55 -0500
From: Jiada Wang <jiada_wang@mentor.com>
To: <gregkh@linuxfoundation.org>, <jslaby@suse.cz>,
        <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <jiada_wang@mentor.com>, <anton_bondarenko@mentor.com>,
        <dirk.behme@de.bosch.com>
Subject: [PATCH v1 11/15] serial: imx: initialized DMA w/o HW flow enabled
Date: Tue, 9 Dec 2014 18:11:32 +0900
Message-ID: <1418116296-12082-12-git-send-email-jiada_wang@mentor.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418116296-12082-1-git-send-email-jiada_wang@mentor.com>
References: <1418116296-12082-1-git-send-email-jiada_wang@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Bondarenko <anton_bondarenko@mentor.com>

DMA mode for UART can be used even w/o HW flow control with RTS/CTS.
So it need to be initialized and enabled earlier.

Signed-off-by: Anton Bondarenko <anton_bondarenko@mentor.com>
Signed-off-by: Jiada Wang <jiada_wang@mentor.com>
---
 drivers/tty/serial/imx.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index d501628..a0f27b4 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -1173,12 +1173,20 @@ static int imx_startup(struct uart_port *port)
 		}
 	}
 
+	/* Can we enable the DMA support? */
+	if (is_imx6q_uart(sport) && !uart_console(port) &&
+	    !sport->dma_is_inited)
+		imx_uart_dma_init(sport);
+
 	spin_lock_irqsave(&sport->port.lock, flags);
 	/*
 	 * Finally, clear and enable interrupts
 	 */
 	writel(USR1_RTSD, sport->port.membase + USR1);
 
+	if (sport->dma_is_inited && !sport->dma_is_enabled)
+		imx_enable_dma(sport);
+
 	temp = readl(sport->port.membase + UCR1);
 	temp |= UCR1_RRDYEN | UCR1_RTSDEN | UCR1_UARTEN;
 
@@ -1378,11 +1386,6 @@ imx_set_termios(struct uart_port *port, struct ktermios *termios,
 		if (sport->have_rtscts) {
 			ucr2 &= ~UCR2_IRTS;
 			ucr2 |= UCR2_CTSC;
-
-			/* Can we enable the DMA support? */
-			if (is_imx6q_uart(sport) && !uart_console(port)
-				&& !sport->dma_is_inited)
-				imx_uart_dma_init(sport);
 		} else {
 			termios->c_cflag &= ~CRTSCTS;
 		}
@@ -1504,8 +1507,6 @@ imx_set_termios(struct uart_port *port, struct ktermios *termios,
 	if (UART_ENABLE_MS(&sport->port, termios->c_cflag))
 		imx_enable_ms(&sport->port);
 
-	if (sport->dma_is_inited && !sport->dma_is_enabled)
-		imx_enable_dma(sport);
 	spin_unlock_irqrestore(&sport->port.lock, flags);
 }
 
-- 
1.9.3

