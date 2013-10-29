Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab3J2SMB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:12:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59630 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339Ab3J2SKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:10:00 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 27/81] can: flexcan: flexcan_chip_start: fix regression, mark one MB for TX and abort pending TX
Date: Tue, 29 Oct 2013 11:03:48 -0700
Message-Id: <1383069882-11437-28-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383069882-11437-1-git-send-email-kamal@canonical.com>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit d5a7b406c529e4595ce03dc8f6dcf7fa36f106fa upstream.

In patch

    0d1862e can: flexcan: fix flexcan_chip_start() on imx6

the loop in flexcan_chip_start() that iterates over all mailboxes after the
soft reset of the CAN core was removed. This loop put all mailboxes (even the
ones marked as reserved 1...7) into EMPTY/INACTIVE mode. On mailboxes 8...63,
this aborts any pending TX messages.

After a cold boot there is random garbage in the mailboxes, which leads to
spontaneous transmit of CAN frames during first activation. Further if the
interface was disabled with a pending message (usually due to an error
condition on the CAN bus), this message is retransmitted after enabling the
interface again.

This patch fixes the regression by:
1) Limiting the maximum number of used mailboxes to 8, 0...7 are used by the RX
FIFO, 8 is used by TX.
2) Marking the TX mailbox as EMPTY/INACTIVE, so that any pending TX of that
mailbox is aborted.

Cc: Lothar Waßmann <LW@KARO-electronics.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/can/flexcan.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 15d5abb..5817a39 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -62,7 +62,7 @@
 #define FLEXCAN_MCR_BCC			BIT(16)
 #define FLEXCAN_MCR_LPRIO_EN		BIT(13)
 #define FLEXCAN_MCR_AEN			BIT(12)
-#define FLEXCAN_MCR_MAXMB(x)		((x) & 0xf)
+#define FLEXCAN_MCR_MAXMB(x)		((x) & 0x1f)
 #define FLEXCAN_MCR_IDAM_A		(0 << 8)
 #define FLEXCAN_MCR_IDAM_B		(1 << 8)
 #define FLEXCAN_MCR_IDAM_C		(2 << 8)
@@ -740,9 +740,11 @@ static int flexcan_chip_start(struct net_device *dev)
 	 *
 	 */
 	reg_mcr = flexcan_read(&regs->mcr);
+	reg_mcr &= ~FLEXCAN_MCR_MAXMB(0xff);
 	reg_mcr |= FLEXCAN_MCR_FRZ | FLEXCAN_MCR_FEN | FLEXCAN_MCR_HALT |
 		FLEXCAN_MCR_SUPV | FLEXCAN_MCR_WRN_EN |
-		FLEXCAN_MCR_IDAM_C | FLEXCAN_MCR_SRX_DIS;
+		FLEXCAN_MCR_IDAM_C | FLEXCAN_MCR_SRX_DIS |
+		FLEXCAN_MCR_MAXMB(FLEXCAN_TX_BUF_ID);
 	netdev_dbg(dev, "%s: writing mcr=0x%08x", __func__, reg_mcr);
 	flexcan_write(reg_mcr, &regs->mcr);
 
@@ -776,6 +778,10 @@ static int flexcan_chip_start(struct net_device *dev)
 	netdev_dbg(dev, "%s: writing ctrl=0x%08x", __func__, reg_ctrl);
 	flexcan_write(reg_ctrl, &regs->ctrl);
 
+	/* Abort any pending TX, mark Mailbox as INACTIVE */
+	flexcan_write(FLEXCAN_MB_CNT_CODE(0x4),
+		      &regs->cantxfg[FLEXCAN_TX_BUF_ID].can_ctrl);
+
 	/* acceptance mask/acceptance code (accept everything) */
 	flexcan_write(0x0, &regs->rxgmask);
 	flexcan_write(0x0, &regs->rx14mask);
-- 
1.8.1.2

