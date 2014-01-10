Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbaAJHAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 02:00:30 -0500
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:34805 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbaAJHAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 02:00:22 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Chen-Yu Tsai <wens@csie.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH v2 02/16] net: stmmac: Enable stmmac main clock when probing hardware
Date: Fri, 10 Jan 2014 15:00:03 +0800
Message-Id: <1389337217-29032-3-git-send-email-wens@csie.org>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389337217-29032-1-git-send-email-wens@csie.org>
References: <1389337217-29032-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guiseppe previously stated that the "stmmaceth" clock is the main clock
that drives the IP. The stmmac driver does not enable this clock during
the probe phase. If the clock was not enabled by the boot loader or
disabled by the kernel, hardware features and the MDIO bus would not be
probed properly.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 26 +++++++++++------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 8a7a23a..786b51c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1604,8 +1604,6 @@ static int stmmac_open(struct net_device *dev)
 	struct stmmac_priv *priv = netdev_priv(dev);
 	int ret;
 
-	clk_prepare_enable(priv->stmmac_clk);
-
 	stmmac_check_ether_addr(priv);
 
 	if (priv->pcs != STMMAC_PCS_RGMII && priv->pcs != STMMAC_PCS_TBI &&
@@ -1796,7 +1794,6 @@ static int stmmac_release(struct net_device *dev)
 #ifdef CONFIG_STMMAC_DEBUG_FS
 	stmmac_exit_fs();
 #endif
-	clk_disable_unprepare(priv->stmmac_clk);
 
 	stmmac_release_ptp(priv);
 
@@ -2682,10 +2679,18 @@ struct stmmac_priv *stmmac_dvr_probe(struct device *device,
 	if ((phyaddr >= 0) && (phyaddr <= 31))
 		priv->plat->phy_addr = phyaddr;
 
+	priv->stmmac_clk = devm_clk_get(priv->device, STMMAC_RESOURCE_NAME);
+	if (IS_ERR(priv->stmmac_clk)) {
+		dev_warn(priv->device, "%s: warning: cannot get CSR clock\n",
+			 __func__);
+		goto error_clk_get;
+	}
+	clk_prepare_enable(priv->stmmac_clk);
+
 	/* Init MAC and get the capabilities */
 	ret = stmmac_hw_init(priv);
 	if (ret)
-		goto error_free_netdev;
+		goto error_hw_init;
 
 	ndev->netdev_ops = &stmmac_netdev_ops;
 
@@ -2723,12 +2728,6 @@ struct stmmac_priv *stmmac_dvr_probe(struct device *device,
 		goto error_netdev_register;
 	}
 
-	priv->stmmac_clk = clk_get(priv->device, STMMAC_RESOURCE_NAME);
-	if (IS_ERR(priv->stmmac_clk)) {
-		pr_warn("%s: warning: cannot get CSR clock\n", __func__);
-		goto error_clk_get;
-	}
-
 	/* If a specific clk_csr value is passed from the platform
 	 * this means that the CSR Clock Range selection cannot be
 	 * changed at run-time and it is fixed. Viceversa the driver'll try to
@@ -2756,12 +2755,12 @@ struct stmmac_priv *stmmac_dvr_probe(struct device *device,
 	return priv;
 
 error_mdio_register:
-	clk_put(priv->stmmac_clk);
-error_clk_get:
 	unregister_netdev(ndev);
 error_netdev_register:
 	netif_napi_del(&priv->napi);
-error_free_netdev:
+error_hw_init:
+	clk_disable_unprepare(priv->stmmac_clk);
+error_clk_get:
 	free_netdev(ndev);
 
 	return NULL;
@@ -2788,6 +2787,7 @@ int stmmac_dvr_remove(struct net_device *ndev)
 		stmmac_mdio_unregister(ndev);
 	netif_carrier_off(ndev);
 	unregister_netdev(ndev);
+	clk_disable_unprepare(priv->stmmac_clk);
 	free_netdev(ndev);
 
 	return 0;
-- 
1.8.5.2

