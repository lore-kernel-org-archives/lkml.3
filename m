Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130AbaK0Isw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:48:52 -0500
Received: from mail.kernel.org ([198.145.19.201]:42313 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932070AbaK0Isu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:48:50 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Jander <david@protonic.nl>,
        Marc Kleine-Budde <mkl@pengutronix.de>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 56/91] can: flexcan: implement workaround for errata ERR005829
Date: Thu, 27 Nov 2014 16:42:39 +0800
Message-Id: <1417077794-9299-56-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Jander <david@protonic.nl>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/net/can/flexcan.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 1331558..681fb9c 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -123,7 +123,9 @@
 	 FLEXCAN_ESR_BOFF_INT | FLEXCAN_ESR_ERR_INT)
 
 /* FLEXCAN interrupt flag register (IFLAG) bits */
-#define FLEXCAN_TX_BUF_ID		8
+/* Errata ERR005829 step7: Reserve first valid MB */
+#define FLEXCAN_TX_BUF_RESERVED		8
+#define FLEXCAN_TX_BUF_ID		9
 #define FLEXCAN_IFLAG_BUF(x)		BIT(x)
 #define FLEXCAN_IFLAG_RX_FIFO_OVERFLOW	BIT(7)
 #define FLEXCAN_IFLAG_RX_FIFO_WARN	BIT(6)
@@ -317,6 +319,14 @@ static int flexcan_start_xmit(struct sk_buff *skb, struct net_device *dev)
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
 
@@ -752,6 +762,10 @@ static int flexcan_chip_start(struct net_device *dev)
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
1.9.1

