Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbaKKLx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:53:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57405 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876AbaKKLKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:10:00 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Jander <david@protonic.nl>, Marc Kleine-Budde <mkl@pengutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 062/170] can: flexcan: implement workaround for errata ERR005829
Date: Tue, 11 Nov 2014 11:07:01 +0000
Message-Id: <1415704129-12709-63-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Jander <david@protonic.nl>

commit 25e924450fcb23c11c07c95ea8964dd9f174652e upstream.

This patch implements the workaround mentioned in ERR005829:

    ERR005829: FlexCAN: FlexCAN does not transmit a message that is enabled to
    be transmitted in a specific moment during the arbitration process.

Workaround: The workaround consists of two extra steps after setting up a
message for transmission:

Step 8: Reserve the first valid mailbox as an inactive mailbox (CODE=0b1000).
If RX FIFO is disabled, this mailbox must be message buffer 0. Otherwise, the
first valid mailbox can be found using the "RX FIFO filters" table in the
FlexCAN chapter of the chip reference manual.

Step 9: Write twice INACTIVE code (0b1000) into the first valid mailbox.

Signed-off-by: David Jander <david@protonic.nl>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/can/flexcan.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 0e06098ca05d..037b1ea41036 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -125,7 +125,9 @@
 	 FLEXCAN_ESR_BOFF_INT | FLEXCAN_ESR_ERR_INT)
 
 /* FLEXCAN interrupt flag register (IFLAG) bits */
-#define FLEXCAN_TX_BUF_ID		8
+/* Errata ERR005829 step7: Reserve first valid MB */
+#define FLEXCAN_TX_BUF_RESERVED		8
+#define FLEXCAN_TX_BUF_ID		9
 #define FLEXCAN_IFLAG_BUF(x)		BIT(x)
 #define FLEXCAN_IFLAG_RX_FIFO_OVERFLOW	BIT(7)
 #define FLEXCAN_IFLAG_RX_FIFO_WARN	BIT(6)
@@ -439,6 +441,14 @@ static int flexcan_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	flexcan_write(can_id, &regs->cantxfg[FLEXCAN_TX_BUF_ID].can_id);
 	flexcan_write(ctrl, &regs->cantxfg[FLEXCAN_TX_BUF_ID].can_ctrl);
 
+	/* Errata ERR005829 step8:
+	 * Write twice INACTIVE(0x8) code to first MB.
+	 */
+	flexcan_write(FLEXCAN_MB_CODE_TX_INACTIVE,
+		      &regs->cantxfg[FLEXCAN_TX_BUF_RESERVED].can_ctrl);
+	flexcan_write(FLEXCAN_MB_CODE_TX_INACTIVE,
+		      &regs->cantxfg[FLEXCAN_TX_BUF_RESERVED].can_ctrl);
+
 	return NETDEV_TX_OK;
 }
 
@@ -876,6 +886,10 @@ static int flexcan_chip_start(struct net_device *dev)
 			      &regs->cantxfg[i].can_ctrl);
 	}
 
+	/* Errata ERR005829: mark first TX mailbox as INACTIVE */
+	flexcan_write(FLEXCAN_MB_CODE_TX_INACTIVE,
+		      &regs->cantxfg[FLEXCAN_TX_BUF_RESERVED].can_ctrl);
+
 	/* mark TX mailbox as INACTIVE */
 	flexcan_write(FLEXCAN_MB_CODE_TX_INACTIVE,
 		      &regs->cantxfg[FLEXCAN_TX_BUF_ID].can_ctrl);
-- 
2.1.0

