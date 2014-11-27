Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbaK0I74 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:59:56 -0500
Received: from mail.kernel.org ([198.145.19.201]:42323 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755119AbaK0Isw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:48:52 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 57/91] can: flexcan: put TX mailbox into TX_INACTIVE mode after tx-complete
Date: Thu, 27 Nov 2014 16:42:40 +0800
Message-Id: <1417077794-9299-57-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit de5944883ebbedbf5adc8497659772f5da7b7d72 upstream.

After sending a RTR frame the TX mailbox becomes a RX_EMPTY mailbox. To avoid
side effects when the RX-FIFO is full, this patch puts the TX mailbox into
TX_INACTIVE mode in the transmission complete interrupt handler. This, of
course, leaves a race window between the actual completion of the transmission
and the handling of tx-complete interrupt. However this is the best we can do
without busy polling the tx complete interrupt.

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
[lizf: Backported to 3.4: adjust context]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/net/can/flexcan.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 681fb9c..b523e65 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -633,6 +633,9 @@ static irqreturn_t flexcan_irq(int irq, void *dev_id)
 	if (reg_iflag1 & (1 << FLEXCAN_TX_BUF_ID)) {
 		stats->tx_bytes += can_get_echo_skb(dev, 0);
 		stats->tx_packets++;
+		/* after sending a RTR frame mailbox is in RX mode */
+		flexcan_write(FLEXCAN_MB_CODE_TX_INACTIVE,
+			&regs->cantxfg[FLEXCAN_TX_BUF_ID].can_ctrl);
 		flexcan_write((1 << FLEXCAN_TX_BUF_ID), &regs->iflag1);
 		netif_wake_queue(dev);
 	}
-- 
1.9.1

