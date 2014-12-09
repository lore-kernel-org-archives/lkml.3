Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247AbaLIJWn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 04:22:43 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:62481 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755509AbaLIJL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 04:11:57 -0500
From: Jiada Wang <jiada_wang@mentor.com>
To: <gregkh@linuxfoundation.org>, <jslaby@suse.cz>,
        <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <jiada_wang@mentor.com>, <anton_bondarenko@mentor.com>,
        <dirk.behme@de.bosch.com>
Subject: [PATCH v1 12/15] serial: imx: start rx_dma once RXFIFO is not empty
Date: Tue, 9 Dec 2014 18:11:33 +0900
Message-ID: <1418116296-12082-13-git-send-email-jiada_wang@mentor.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418116296-12082-1-git-send-email-jiada_wang@mentor.com>
References: <1418116296-12082-1-git-send-email-jiada_wang@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Gong <b38343@freescale.com>

Start rx_dma once RXFIFO is not empty that can avoid dma request lost
and causes data delay issue.

Signed-off-by: Robin Gong <b38343@freescale.com>
Signed-off-by: Fugang Duan <B38611@freescale.com>
---
 drivers/tty/serial/imx.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index a0f27b4..f0df233 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -946,8 +946,21 @@ static void dma_rx_callback(void *data)
 		tty_flip_buffer_push(port);
 
 		start_rx_dma(sport);
-	} else
+	} else if (readl(sport->port.membase + USR2) & USR2_RDR) {
+		/*
+		 * start rx_dma directly once data in RXFIFO, more efficient
+		 * than before:
+		 *	1. call imx_rx_dma_done to stop dma if no data received
+		 *	2. wait next  RDR interrupt to start dma transfer.
+		 */
+		start_rx_dma(sport);
+	} else {
+		/*
+		 * stop dma to prevent too many IDLE event trigged if no data
+		 * in RXFIFO
+		 */
 		imx_rx_dma_done(sport);
+	}
 }
 
 static int start_rx_dma(struct imx_port *sport)
-- 
1.9.3

