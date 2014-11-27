Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbaK0JA7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 04:00:59 -0500
Received: from mail.kernel.org ([198.145.19.201]:42303 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755091AbaK0Isr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:48:47 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Jander <david@protonic.nl>,
        Marc Kleine-Budde <mkl@pengutronix.de>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 55/91] can: flexcan: correctly initialize mailboxes
Date: Thu, 27 Nov 2014 16:42:38 +0800
Message-Id: <1417077794-9299-55-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Jander <david@protonic.nl>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit fc05b884a31dbf259cc73cc856e634ec3acbebb6 upstream.

Apparently mailboxes may contain random data at startup, causing some of them
being prepared for message reception. This causes overruns being missed or even
confusing the IRQ check for trasmitted messages, increasing the transmit
counter instead of the error counter.

This patch initializes all mailboxes after the FIFO as RX_INACTIVE.

Signed-off-by: David Jander <david@protonic.nl>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/net/can/flexcan.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 062bbe2..1331558 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -680,6 +680,7 @@ static int flexcan_chip_start(struct net_device *dev)
 	struct flexcan_regs __iomem *regs = priv->base;
 	int err;
 	u32 reg_mcr, reg_ctrl;
+	int i;
 
 	/* enable module */
 	flexcan_chip_enable(priv);
@@ -745,6 +746,12 @@ static int flexcan_chip_start(struct net_device *dev)
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
1.9.1

