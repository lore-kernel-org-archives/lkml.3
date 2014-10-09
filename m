Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158AbaJIVc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:32:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59310 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757527AbaJIVI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:08:57 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Jander <david@protonic.nl>, Marc Kleine-Budde <mkl@pengutronix.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 121/163] can: flexcan: correctly initialize mailboxes
Date: Thu,  9 Oct 2014 14:02:26 -0700
Message-Id: <1412888588-26755-122-git-send-email-kamal@canonical.com>
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

commit fc05b884a31dbf259cc73cc856e634ec3acbebb6 upstream.

Apparently mailboxes may contain random data at startup, causing some of them
being prepared for message reception. This causes overruns being missed or even
confusing the IRQ check for trasmitted messages, increasing the transmit
counter instead of the error counter.

This patch initializes all mailboxes after the FIFO as RX_INACTIVE.

Signed-off-by: David Jander <david@protonic.nl>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/can/flexcan.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index c847e80..6360356 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -749,6 +749,7 @@ static int flexcan_chip_start(struct net_device *dev)
 	struct flexcan_regs __iomem *regs = priv->base;
 	int err;
 	u32 reg_mcr, reg_ctrl;
+	int i;
 
 	/* enable module */
 	err = flexcan_chip_enable(priv);
@@ -820,6 +821,12 @@ static int flexcan_chip_start(struct net_device *dev)
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

