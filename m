Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257AbaJIVfg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:35:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59244 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757440AbaJIVIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:08:34 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Jander <david@protonic.nl>, Marc Kleine-Budde <mkl@pengutronix.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 122/163] can: flexcan: implement workaround for errata ERR005829
Date: Thu,  9 Oct 2014 14:02:27 -0700
Message-Id: <1412888588-26755-123-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/can/flexcan.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 6360356..3a1859b 100644
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
@@ -383,6 +385,14 @@ static int flexcan_start_xmit(struct sk_buff *skb, struct net_device *dev)
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
 
@@ -827,6 +837,10 @@ static int flexcan_chip_start(struct net_device *dev)
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

