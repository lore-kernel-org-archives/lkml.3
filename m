Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966102AbaCUA70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:59:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36832 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965478AbaCUAEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:04:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 3.13 128/149] can: flexcan: fix transition from and to low power mode in chip_{en,dis}able
Date: Thu, 20 Mar 2014 17:04:51 -0700
Message-Id: <20140321000441.392533925@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/flexcan.c |   50 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 38 insertions(+), 12 deletions(-)

--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -144,6 +144,8 @@
 
 #define FLEXCAN_MB_CODE_MASK		(0xf0ffffff)
 
+#define FLEXCAN_TIMEOUT_US             (50)
+
 /*
  * FLEXCAN hardware feature flags
  *
@@ -266,26 +268,42 @@ static inline int flexcan_has_and_handle
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
@@ -706,7 +724,9 @@ static int flexcan_chip_start(struct net
 	u32 reg_mcr, reg_ctrl;
 
 	/* enable module */
-	flexcan_chip_enable(priv);
+	err = flexcan_chip_enable(priv);
+	if (err)
+		return err;
 
 	/* soft reset */
 	flexcan_write(FLEXCAN_MCR_SOFTRST, &regs->mcr);
@@ -946,12 +966,16 @@ static int register_flexcandev(struct ne
 		goto out_disable_ipg;
 
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
@@ -968,14 +992,15 @@ static int register_flexcandev(struct ne
 	if (!(reg & FLEXCAN_MCR_FEN)) {
 		netdev_err(dev, "Could not enable RX FIFO, unsupported core\n");
 		err = -ENODEV;
-		goto out_disable_per;
+		goto out_chip_disable;
 	}
 
 	err = register_candev(dev);
 
- out_disable_per:
 	/* disable core and turn off clocks */
+ out_chip_disable:
 	flexcan_chip_disable(priv);
+ out_disable_per:
 	clk_disable_unprepare(priv->clk_per);
  out_disable_ipg:
 	clk_disable_unprepare(priv->clk_ipg);
@@ -1118,8 +1143,11 @@ static int flexcan_suspend(struct device
 {
 	struct net_device *dev = dev_get_drvdata(device);
 	struct flexcan_priv *priv = netdev_priv(dev);
+	int err;
 
-	flexcan_chip_disable(priv);
+	err = flexcan_chip_disable(priv);
+	if (err)
+		return err;
 
 	if (netif_running(dev)) {
 		netif_stop_queue(dev);
@@ -1140,9 +1168,7 @@ static int flexcan_resume(struct device
 		netif_device_attach(dev);
 		netif_start_queue(dev);
 	}
-	flexcan_chip_enable(priv);
-
-	return 0;
+	return flexcan_chip_enable(priv);
 }
 #endif /* CONFIG_PM_SLEEP */
 


