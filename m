Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbaGNHs7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 03:48:59 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:33957 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbaGNHsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 03:48:41 -0400
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@freescale.com, mkl@pengutronix.de
Cc: kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stefan@agner.ch
Subject: [PATCH v2 3/4] can: flexcan: switch on clocks before accessing ecr register
Date: Mon, 14 Jul 2014 09:48:30 +0200
Message-Id: <3901272074d5a3e680a7ecfda3ffbfca4c544a86.1405322992.git.stefan@agner.ch>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <cover.1405322992.git.stefan@agner.ch>
References: <cover.1405322992.git.stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: Ashutosh Singh <ashuleapyear@gmail.com>
Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
[stefan@agner.ch: added return check for clk_enable_prepare]

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 drivers/net/can/flexcan.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index f425ec2..4c598c9 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -383,11 +383,25 @@ static int flexcan_get_berr_counter(const struct net_device *dev,
 {
 	const struct flexcan_priv *priv = netdev_priv(dev);
 	struct flexcan_regs __iomem *regs = priv->base;
-	u32 reg = flexcan_read(&regs->ecr);
+	u32 reg, err;
+
+	err = clk_prepare_enable(priv->clk_ipg);
+	if (err)
+		return err;
+
+	err = clk_prepare_enable(priv->clk_per);
+	if (err)
+		goto out_disable_ipg;
+
+	reg = flexcan_read(&regs->ecr);
 
 	bec->txerr = (reg >> 0) & 0xff;
 	bec->rxerr = (reg >> 8) & 0xff;
 
+	clk_disable_unprepare(priv->clk_per);
+ out_disable_ipg:
+	clk_disable_unprepare(priv->clk_ipg);
+
 	return 0;
 }
 
-- 
2.0.1

