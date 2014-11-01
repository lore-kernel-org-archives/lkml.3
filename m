Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbaKAW4o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:56:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60106 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751513AbaKAWj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:27 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Marc Kleine-Budde" <mkl@pengutronix.de>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.394145548@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 064/102] can: flexcan: put TX mailbox into TX_INACTIVE
 mode after tx-complete
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/can/flexcan.c | 3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -632,6 +632,9 @@ static irqreturn_t flexcan_irq(int irq,
 	if (reg_iflag1 & (1 << FLEXCAN_TX_BUF_ID)) {
 		/* tx_bytes is incremented in flexcan_start_xmit */
 		stats->tx_packets++;
+		/* after sending a RTR frame mailbox is in RX mode */
+		flexcan_write(FLEXCAN_MB_CODE_TX_INACTIVE,
+			      &regs->cantxfg[FLEXCAN_TX_BUF_ID].can_ctrl);
 		flexcan_write((1 << FLEXCAN_TX_BUF_ID), &regs->iflag1);
 		netif_wake_queue(dev);
 	}

