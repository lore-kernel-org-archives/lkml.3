Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949AbaDAQUO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:20:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44708 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140AbaDAQQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:16:14 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marc Kleine-Budde <mkl@pengutronix.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 40/86] can: flexcan: fix transition from and to low power mode in chip_{en,dis}able
Date: Tue,  1 Apr 2014 09:07:53 -0700
Message-Id: <1396368519-12728-41-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396368519-12728-1-git-send-email-kamal@canonical.com>
References: <1396368519-12728-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit 9b00b300e7bce032c467c36ca47fe2a776887fc2 upstream.

In flexcan_chip_enable() and flexcan_chip_disable() fixed delays are used.
Experiments have shown that the transition from and to low power mode may take
several microseconds.

This patch adds a while loop which polls the Low Power Mode ACK bit (LPM_ACK)
that indicates a successfull mode change. If the function runs into a timeout a
error value is returned.

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/can/flexcan.c | 50 +++++++++++++++++++++++++++++++++++------------
 1 file changed, 38 insertions(+), 12 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 9771652..275b721 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -144,6 +144,8 @@
 
 #define FLEXCAN_MB_CODE_MASK		(0xf0ffffff)
 
+#define FLEXCAN_TIMEOUT_US             (50)
+
 /*
  * FLEXCAN hardware feature flags
  *
@@ -274,26 +276,42 @@ static inline int flexcan_has_and_handle_berr(const struct flexcan_priv *priv,
 		(reg_esr & FLEXCAN_ESR_ERR_BUS);
 }
 
-static inline void flexcan_chip_enable(struct flexcan_priv *priv)
+static int flexcan_chip_enable(struct flexcan_priv *priv)
 {
 	struct flexcan_regs __iomem *regs = priv->base;
+	unsigned int timeout = FLEXCAN_TIMEOUT_US / 10;
 	u32 reg;
 
 	reg = flexcan_read(&regs->mcr);
 	reg &= ~FLEXCAN_MCR_MDIS;
 	flexcan_write(reg, &regs->mcr);
 
-	udelay(10);
+	while (timeout-- && (flexcan_read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK))
+		usleep_range(10, 20);
+
+	if (flexcan_read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK)
+		return -ETIMEDOUT;
+
+	return 0;
 }
 
-static inline void flexcan_chip_disable(struct flexcan_priv *priv)
+static int flexcan_chip_disable(struct flexcan_priv *priv)
 {
 	struct flexcan_regs __iomem *regs = priv->base;
+	unsigned int timeout = FLEXCAN_TIMEOUT_US / 10;
 	u32 reg;
 
 	reg = flexcan_read(&regs->mcr);
 	reg |= FLEXCAN_MCR_MDIS;
 	flexcan_write(reg, &regs->mcr);
+
+	while (timeout-- && !(flexcan_read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK))
+		usleep_range(10, 20);
+
+	if (!(flexcan_read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK))
+		return -ETIMEDOUT;
+
+	return 0;
 }
 
 static int flexcan_get_berr_counter(const struct net_device *dev,
@@ -711,7 +729,9 @@ static int flexcan_chip_start(struct net_device *dev)
 	u32 reg_mcr, reg_ctrl;
 
 	/* enable module */
-	flexcan_chip_enable(priv);
+	err = flexcan_chip_enable(priv);
+	if (err)
+		return err;
 
 	/* soft reset */
 	flexcan_write(FLEXCAN_MCR_SOFTRST, &regs->mcr);
@@ -930,12 +950,16 @@ static int register_flexcandev(struct net_device *dev)
 	clk_prepare_enable(priv->clk_per);
 
 	/* select "bus clock", chip must be disabled */
-	flexcan_chip_disable(priv);
+	err = flexcan_chip_disable(priv);
+	if (err)
+		goto out_disable_per;
 	reg = flexcan_read(&regs->ctrl);
 	reg |= FLEXCAN_CTRL_CLK_SRC;
 	flexcan_write(reg, &regs->ctrl);
 
-	flexcan_chip_enable(priv);
+	err = flexcan_chip_enable(priv);
+	if (err)
+		goto out_chip_disable;
 
 	/* set freeze, halt and activate FIFO, restrict register access */
 	reg = flexcan_read(&regs->mcr);
@@ -952,14 +976,15 @@ static int register_flexcandev(struct net_device *dev)
 	if (!(reg & FLEXCAN_MCR_FEN)) {
 		netdev_err(dev, "Could not enable RX FIFO, unsupported core\n");
 		err = -ENODEV;
-		goto out;
+		goto out_chip_disable;
 	}
 
 	err = register_candev(dev);
 
- out:
 	/* disable core and turn off clocks */
+ out_chip_disable:
 	flexcan_chip_disable(priv);
+ out_disable_per:
 	clk_disable_unprepare(priv->clk_per);
 	clk_disable_unprepare(priv->clk_ipg);
 
@@ -1130,8 +1155,11 @@ static int flexcan_suspend(struct platform_device *pdev, pm_message_t state)
 {
 	struct net_device *dev = platform_get_drvdata(pdev);
 	struct flexcan_priv *priv = netdev_priv(dev);
+	int err;
 
-	flexcan_chip_disable(priv);
+	err = flexcan_chip_disable(priv);
+	if (err)
+		return err;
 
 	if (netif_running(dev)) {
 		netif_stop_queue(dev);
@@ -1152,9 +1180,7 @@ static int flexcan_resume(struct platform_device *pdev)
 		netif_device_attach(dev);
 		netif_start_queue(dev);
 	}
-	flexcan_chip_enable(priv);
-
-	return 0;
+	return flexcan_chip_enable(priv);
 }
 #else
 #define flexcan_suspend NULL
-- 
1.8.3.2

