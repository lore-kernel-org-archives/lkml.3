Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbaLIJLs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 04:11:48 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:62405 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbaLIJLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 04:11:43 -0500
From: Jiada Wang <jiada_wang@mentor.com>
To: <gregkh@linuxfoundation.org>, <jslaby@suse.cz>,
        <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <jiada_wang@mentor.com>, <anton_bondarenko@mentor.com>,
        <dirk.behme@de.bosch.com>
Subject: [PATCH v1 01/15] serial: imx: add CREAD flag support
Date: Tue, 9 Dec 2014 18:11:22 +0900
Message-ID: <1418116296-12082-2-git-send-email-jiada_wang@mentor.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418116296-12082-1-git-send-email-jiada_wang@mentor.com>
References: <1418116296-12082-1-git-send-email-jiada_wang@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add CREAD flag hanlding in set_termios and UART DMA mode
which ignores all received chars when CREAD flag cleared.

Signed-off-by: Jiada Wang <jiada_wang@mentor.com>
Signed-off-by: Anton Bondarenko <anton_bondarenko@mentor.com>
---
 drivers/tty/serial/imx.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 8f62a3c..4d3fa53 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -74,6 +74,7 @@
 #define IMX21_UTS 0xb4 /* UART Test Register on all other i.mx*/
 
 /* UART Control Register Bit Fields.*/
+#define URXD_DUMMY_READ (1<<16)
 #define URXD_CHARRDY	(1<<15)
 #define URXD_ERR	(1<<14)
 #define URXD_OVRRUN	(1<<13)
@@ -710,6 +711,9 @@ static irqreturn_t imx_rxint(int irq, void *dev_id)
 #endif
 		}
 
+		if (sport->port.ignore_status_mask & URXD_DUMMY_READ)
+			goto out;
+
 		tty_insert_flip_char(port, rx, flg);
 	}
 
@@ -910,7 +914,8 @@ static void dma_rx_callback(void *data)
 	dev_dbg(sport->port.dev, "We get %d bytes.\n", count);
 
 	if (count) {
-		tty_insert_flip_string(port, sport->rx_buf, count);
+		if (!(sport->port.ignore_status_mask & URXD_DUMMY_READ))
+			tty_insert_flip_string(port, sport->rx_buf, count);
 		tty_flip_buffer_push(port);
 
 		start_rx_dma(sport);
@@ -1382,6 +1387,9 @@ imx_set_termios(struct uart_port *port, struct ktermios *termios,
 			sport->port.ignore_status_mask |= URXD_OVRRUN;
 	}
 
+	if ((termios->c_cflag & CREAD) == 0)
+		sport->port.ignore_status_mask |= URXD_DUMMY_READ;
+
 	/*
 	 * Update the per-port timeout.
 	 */
-- 
1.9.3

