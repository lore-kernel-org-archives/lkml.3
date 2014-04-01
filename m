Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbaDAMNc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 08:13:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42222 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbaDALQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:16:40 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 032/144] can: flexcan: Check the return value from clk_prepare_enable()
Date: Tue,  1 Apr 2014 12:13:56 +0100
Message-Id: <1396350948-29910-33-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <fabio.estevam@freescale.com>

commit aa10181bdac99a623517f0f2bfa14cd98c749246 upstream.

clk_prepare_enable() may fail, so let's check its return value and propagate it
in the case of error.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/can/flexcan.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 394b2eb..0bd9e2f 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -846,12 +846,17 @@ static int flexcan_open(struct net_device *dev)
 	struct flexcan_priv *priv = netdev_priv(dev);
 	int err;
 
-	clk_prepare_enable(priv->clk_ipg);
-	clk_prepare_enable(priv->clk_per);
+	err = clk_prepare_enable(priv->clk_ipg);
+	if (err)
+		return err;
+
+	err = clk_prepare_enable(priv->clk_per);
+	if (err)
+		goto out_disable_ipg;
 
 	err = open_candev(dev);
 	if (err)
-		goto out;
+		goto out_disable_per;
 
 	err = request_irq(dev->irq, flexcan_irq, IRQF_SHARED, dev->name, dev);
 	if (err)
@@ -873,8 +878,9 @@ static int flexcan_open(struct net_device *dev)
 	free_irq(dev->irq, dev);
  out_close:
 	close_candev(dev);
- out:
+ out_disable_per:
 	clk_disable_unprepare(priv->clk_per);
+ out_disable_ipg:
 	clk_disable_unprepare(priv->clk_ipg);
 
 	return err;
@@ -931,8 +937,13 @@ static int register_flexcandev(struct net_device *dev)
 	struct flexcan_regs __iomem *regs = priv->base;
 	u32 reg, err;
 
-	clk_prepare_enable(priv->clk_ipg);
-	clk_prepare_enable(priv->clk_per);
+	err = clk_prepare_enable(priv->clk_ipg);
+	if (err)
+		return err;
+
+	err = clk_prepare_enable(priv->clk_per);
+	if (err)
+		goto out_disable_ipg;
 
 	/* select "bus clock", chip must be disabled */
 	flexcan_chip_disable(priv);
@@ -957,15 +968,16 @@ static int register_flexcandev(struct net_device *dev)
 	if (!(reg & FLEXCAN_MCR_FEN)) {
 		netdev_err(dev, "Could not enable RX FIFO, unsupported core\n");
 		err = -ENODEV;
-		goto out;
+		goto out_disable_per;
 	}
 
 	err = register_candev(dev);
 
- out:
+ out_disable_per:
 	/* disable core and turn off clocks */
 	flexcan_chip_disable(priv);
 	clk_disable_unprepare(priv->clk_per);
+ out_disable_ipg:
 	clk_disable_unprepare(priv->clk_ipg);
 
 	return err;
-- 
1.9.1

