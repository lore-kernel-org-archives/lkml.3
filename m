Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564AbaLIJV4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 04:21:56 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:62487 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554AbaLIJL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 04:11:59 -0500
From: Jiada Wang <jiada_wang@mentor.com>
To: <gregkh@linuxfoundation.org>, <jslaby@suse.cz>,
        <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <jiada_wang@mentor.com>, <anton_bondarenko@mentor.com>,
        <dirk.behme@de.bosch.com>
Subject: [PATCH v1 13/15] serial: imx: Enable UCR4_OREN in startup interface
Date: Tue, 9 Dec 2014 18:11:34 +0900
Message-ID: <1418116296-12082-14-git-send-email-jiada_wang@mentor.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418116296-12082-1-git-send-email-jiada_wang@mentor.com>
References: <1418116296-12082-1-git-send-email-jiada_wang@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Other than enable Receiver Overrun Interrupt Enable (UCR4_OREN)
in start_tx interface, UCR4_OREN should be enabled before enable
of Receiver.

Signed-off-by: Jiada Wang <jiada_wang@mentor.com>
---
 drivers/tty/serial/imx.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index f0df233..94ee7c5 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -611,13 +611,6 @@ static void imx_start_tx(struct uart_port *port)
 		temp &= ~(UCR1_RRDYEN);
 		writel(temp, sport->port.membase + UCR1);
 	}
-	/* Clear any pending ORE flag before enabling interrupt */
-	temp = readl(sport->port.membase + USR2);
-	writel(temp | USR2_ORE, sport->port.membase + USR2);
-
-	temp = readl(sport->port.membase + UCR4);
-	temp |= UCR4_OREN;
-	writel(temp, sport->port.membase + UCR4);
 
 	if (!sport->dma_is_enabled) {
 		temp = readl(sport->port.membase + UCR1);
@@ -1210,6 +1203,14 @@ static int imx_startup(struct uart_port *port)
 
 	writel(temp, sport->port.membase + UCR1);
 
+	/* Clear any pending ORE flag before enabling interrupt */
+	temp = readl(sport->port.membase + USR2);
+	writel(temp | USR2_ORE, sport->port.membase + USR2);
+
+	temp = readl(sport->port.membase + UCR4);
+	temp |= UCR4_OREN;
+	writel(temp, sport->port.membase + UCR4);
+
 	temp = readl(sport->port.membase + UCR2);
 	temp |= (UCR2_RXEN | UCR2_TXEN);
 	if (!sport->have_rtscts)
-- 
1.9.3

