Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250AbaKKLy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:54:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57397 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796AbaKKLJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:09:59 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Jander <david@protonic.nl>, Marc Kleine-Budde <mkl@pengutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 061/170] can: flexcan: correctly initialize mailboxes
Date: Tue, 11 Nov 2014 11:07:00 +0000
Message-Id: <1415704129-12709-62-git-send-email-luis.henriques@canonical.com>
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

commit fc05b884a31dbf259cc73cc856e634ec3acbebb6 upstream.

Apparently mailboxes may contain random data at startup, causing some of them
being prepared for message reception. This causes overruns being missed or even
confusing the IRQ check for trasmitted messages, increasing the transmit
counter instead of the error counter.

This patch initializes all mailboxes after the FIFO as RX_INACTIVE.

Signed-off-by: David Jander <david@protonic.nl>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/can/flexcan.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index f846bf63e347..0e06098ca05d 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -805,6 +805,7 @@ static int flexcan_chip_start(struct net_device *dev)
 	struct flexcan_regs __iomem *regs = priv->base;
 	int err;
 	u32 reg_mcr, reg_ctrl;
+	int i;
 
 	/* enable module */
 	err = flexcan_chip_enable(priv);
@@ -869,6 +870,12 @@ static int flexcan_chip_start(struct net_device *dev)
 	netdev_dbg(dev, "%s: writing ctrl=0x%08x", __func__, reg_ctrl);
 	flexcan_write(reg_ctrl, &regs->ctrl);
 
+	/* clear and invalidate all mailboxes first */
+	for (i = FLEXCAN_TX_BUF_ID; i < ARRAY_SIZE(regs->cantxfg); i++) {
+		flexcan_write(FLEXCAN_MB_CODE_RX_INACTIVE,
+			      &regs->cantxfg[i].can_ctrl);
+	}
+
 	/* mark TX mailbox as INACTIVE */
 	flexcan_write(FLEXCAN_MB_CODE_TX_INACTIVE,
 		      &regs->cantxfg[FLEXCAN_TX_BUF_ID].can_ctrl);
-- 
2.1.0

