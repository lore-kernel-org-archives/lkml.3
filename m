Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbaKKLKL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:10:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57406 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbaKKLKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:10:00 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marc Kleine-Budde <mkl@pengutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 063/170] can: flexcan: put TX mailbox into TX_INACTIVE mode after tx-complete
Date: Tue, 11 Nov 2014 11:07:02 +0000
Message-Id: <1415704129-12709-64-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit de5944883ebbedbf5adc8497659772f5da7b7d72 upstream.

After sending a RTR frame the TX mailbox becomes a RX_EMPTY mailbox. To avoid
side effects when the RX-FIFO is full, this patch puts the TX mailbox into
TX_INACTIVE mode in the transmission complete interrupt handler. This, of
course, leaves a race window between the actual completion of the transmission
and the handling of tx-complete interrupt. However this is the best we can do
without busy polling the tx complete interrupt.

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/can/flexcan.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 037b1ea41036..9fc6f2cc2ed2 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -758,6 +758,9 @@ static irqreturn_t flexcan_irq(int irq, void *dev_id)
 		stats->tx_bytes += can_get_echo_skb(dev, 0);
 		stats->tx_packets++;
 		can_led_event(dev, CAN_LED_EVENT_TX);
+		/* after sending a RTR frame mailbox is in RX mode */
+		flexcan_write(FLEXCAN_MB_CODE_TX_INACTIVE,
+			      &regs->cantxfg[FLEXCAN_TX_BUF_ID].can_ctrl);
 		flexcan_write((1 << FLEXCAN_TX_BUF_ID), &regs->iflag1);
 		netif_wake_queue(dev);
 	}
-- 
2.1.0

