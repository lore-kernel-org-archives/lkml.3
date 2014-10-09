Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758592AbaJIVeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:34:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59251 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757414AbaJIVIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:08:37 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marc Kleine-Budde <mkl@pengutronix.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 123/163] can: flexcan: put TX mailbox into TX_INACTIVE mode after tx-complete
Date: Thu,  9 Oct 2014 14:02:28 -0700
Message-Id: <1412888588-26755-124-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/can/flexcan.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 3a1859b..deea3a9 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -702,6 +702,9 @@ static irqreturn_t flexcan_irq(int irq, void *dev_id)
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
1.9.1

