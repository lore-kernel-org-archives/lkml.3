Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065AbaFDLjA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 07:39:00 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:58901 "EHLO dev.rtsoft.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752745AbaFDLgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 07:36:08 -0400
From: nyushchenko@dev.rtsoft.ru
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, lugovskoy@dev.rtsoft.ru,
        Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
Subject: [PATCH 14/21] net/ethernet: use devm_irq_of_parse_and_map() where appropriate
Date: Wed,  4 Jun 2014 15:13:14 +0400
Message-Id: <1401880402-30091-15-git-send-email-nyushchenko@dev.rtsoft.ru>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401880402-30091-1-git-send-email-nyushchenko@dev.rtsoft.ru>
References: <1401880402-30091-1-git-send-email-nyushchenko@dev.rtsoft.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>

This avoids leak of IRQ mapping on error paths, and makes it possible
to use devm_request_irq() without facing unmap-while-handler-installed
issues.

Signed-off-by: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
---
 drivers/net/ethernet/allwinner/sun4i-emac.c        |    6 ++---
 drivers/net/ethernet/arc/emac_main.c               |    6 ++---
 drivers/net/ethernet/marvell/mvneta.c              |   15 +++++-------
 drivers/net/ethernet/moxa/moxart_ether.c           |    4 ++--
 .../net/ethernet/samsung/sxgbe/sxgbe_platform.c    |   24 ++++++++------------
 5 files changed, 23 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/allwinner/sun4i-emac.c b/drivers/net/ethernet/allwinner/sun4i-emac.c
index 2846067..9c2d0d7 100644
--- a/drivers/net/ethernet/allwinner/sun4i-emac.c
+++ b/drivers/net/ethernet/allwinner/sun4i-emac.c
@@ -839,10 +839,10 @@ static int emac_probe(struct platform_device *pdev)
 
 	/* fill in parameters for net-dev structure */
 	ndev->base_addr = (unsigned long)db->membase;
-	ndev->irq = irq_of_parse_and_map(np, 0);
-	if (ndev->irq == -ENXIO) {
+	ndev->irq = devm_irq_of_parse_and_map(&pdev->dev, np, 0);
+	if (ndev->irq <= 0) {
 		netdev_err(ndev, "No irq resource\n");
-		ret = ndev->irq;
+		ret = ndev->irq ? ndev->irq : -EINVAL;
 		goto out;
 	}
 
diff --git a/drivers/net/ethernet/arc/emac_main.c b/drivers/net/ethernet/arc/emac_main.c
index d647a7d..4de428d 100644
--- a/drivers/net/ethernet/arc/emac_main.c
+++ b/drivers/net/ethernet/arc/emac_main.c
@@ -650,10 +650,10 @@ static int arc_emac_probe(struct platform_device *pdev)
 	}
 
 	/* Get IRQ from device tree */
-	irq = irq_of_parse_and_map(pdev->dev.of_node, 0);
-	if (!irq) {
+	irq = devm_irq_of_parse_and_map(&pdev->dev, pdev->dev.of_node, 0);
+	if (irq <= 0) {
 		dev_err(&pdev->dev, "failed to retrieve <irq> value from device tree\n");
-		return -ENODEV;
+		return irq ? irq : -ENODEV;
 	}
 
 	ndev = alloc_etherdev(sizeof(struct arc_emac_priv));
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 14786c8..42043f2 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2789,9 +2789,9 @@ static int mvneta_probe(struct platform_device *pdev)
 	if (!dev)
 		return -ENOMEM;
 
-	dev->irq = irq_of_parse_and_map(dn, 0);
-	if (dev->irq == 0) {
-		err = -EINVAL;
+	dev->irq = devm_irq_of_parse_and_map(&pdev->dev, dn, 0);
+	if (dev->irq <= 0) {
+		err = dev->irq ? dev->irq : -EINVAL;
 		goto err_free_netdev;
 	}
 
@@ -2799,14 +2799,14 @@ static int mvneta_probe(struct platform_device *pdev)
 	if (!phy_node) {
 		dev_err(&pdev->dev, "no associated PHY\n");
 		err = -ENODEV;
-		goto err_free_irq;
+		goto err_free_netdev;
 	}
 
 	phy_mode = of_get_phy_mode(dn);
 	if (phy_mode < 0) {
 		dev_err(&pdev->dev, "incorrect phy-mode\n");
 		err = -EINVAL;
-		goto err_free_irq;
+		goto err_free_netdev;
 	}
 
 	dev->tx_queue_len = MVNETA_MAX_TXD;
@@ -2824,7 +2824,7 @@ static int mvneta_probe(struct platform_device *pdev)
 	pp->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(pp->clk)) {
 		err = PTR_ERR(pp->clk);
-		goto err_free_irq;
+		goto err_free_netdev;
 	}
 
 	clk_prepare_enable(pp->clk);
@@ -2906,8 +2906,6 @@ err_free_stats:
 	free_percpu(pp->stats);
 err_clk:
 	clk_disable_unprepare(pp->clk);
-err_free_irq:
-	irq_dispose_mapping(dev->irq);
 err_free_netdev:
 	free_netdev(dev);
 	return err;
@@ -2923,7 +2921,6 @@ static int mvneta_remove(struct platform_device *pdev)
 	mvneta_deinit(pp);
 	clk_disable_unprepare(pp->clk);
 	free_percpu(pp->stats);
-	irq_dispose_mapping(dev->irq);
 	free_netdev(dev);
 
 	return 0;
diff --git a/drivers/net/ethernet/moxa/moxart_ether.c b/drivers/net/ethernet/moxa/moxart_ether.c
index 5020fd4..b4de432 100644
--- a/drivers/net/ethernet/moxa/moxart_ether.c
+++ b/drivers/net/ethernet/moxa/moxart_ether.c
@@ -443,10 +443,10 @@ static int moxart_mac_probe(struct platform_device *pdev)
 	if (!ndev)
 		return -ENOMEM;
 
-	irq = irq_of_parse_and_map(node, 0);
+	irq = devm_irq_of_parse_and_map(p_dev, node, 0);
 	if (irq <= 0) {
 		netdev_err(ndev, "irq_of_parse_and_map failed\n");
-		ret = -EINVAL;
+		ret = irq ? irq : -EINVAL;
 		goto irq_map_fail;
 	}
 
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_platform.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_platform.c
index b147d46..9118905 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_platform.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_platform.c
@@ -122,7 +122,7 @@ static int sxgbe_platform_probe(struct platform_device *pdev)
 	}
 
 	/* Get the SXGBE common INT information */
-	priv->irq  = irq_of_parse_and_map(node, 0);
+	priv->irq = devm_irq_of_parse_and_map(dev, node, 0);
 	if (priv->irq <= 0) {
 		dev_err(dev, "sxgbe common irq parsing failed\n");
 		goto err_drv_remove;
@@ -130,25 +130,27 @@ static int sxgbe_platform_probe(struct platform_device *pdev)
 
 	/* Get the TX/RX IRQ numbers */
 	for (i = 0, chan = 1; i < SXGBE_TX_QUEUES; i++) {
-		priv->txq[i]->irq_no = irq_of_parse_and_map(node, chan++);
+		priv->txq[i]->irq_no = devm_irq_of_parse_and_map(dev,
+				node, chan++);
 		if (priv->txq[i]->irq_no <= 0) {
 			dev_err(dev, "sxgbe tx irq parsing failed\n");
-			goto err_tx_irq_unmap;
+			goto err_drv_remove;
 		}
 	}
 
 	for (i = 0; i < SXGBE_RX_QUEUES; i++) {
-		priv->rxq[i]->irq_no = irq_of_parse_and_map(node, chan++);
+		priv->rxq[i]->irq_no = devm_irq_of_parse_and_map(dev,
+				node, chan++);
 		if (priv->rxq[i]->irq_no <= 0) {
 			dev_err(dev, "sxgbe rx irq parsing failed\n");
-			goto err_rx_irq_unmap;
+			goto err_drv_remove;
 		}
 	}
 
-	priv->lpi_irq = irq_of_parse_and_map(node, chan);
+	priv->lpi_irq = devm_irq_of_parse_and_map(dev, node, chan);
 	if (priv->lpi_irq <= 0) {
 		dev_err(dev, "sxgbe lpi irq parsing failed\n");
-		goto err_rx_irq_unmap;
+		goto err_drv_remove;
 	}
 
 	platform_set_drvdata(pdev, priv->dev);
@@ -157,14 +159,6 @@ static int sxgbe_platform_probe(struct platform_device *pdev)
 
 	return 0;
 
-err_rx_irq_unmap:
-	while (--i)
-		irq_dispose_mapping(priv->rxq[i]->irq_no);
-	i = SXGBE_TX_QUEUES;
-err_tx_irq_unmap:
-	while (--i)
-		irq_dispose_mapping(priv->txq[i]->irq_no);
-	irq_dispose_mapping(priv->irq);
 err_drv_remove:
 	sxgbe_drv_remove(ndev);
 err_out:
-- 
1.7.10.4

