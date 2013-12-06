Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166Ab3LFSG7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 13:06:59 -0500
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:38806 "EHLO
	mirror2.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab3LFSG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 13:06:57 -0500
X-Greylist: delayed 2177 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Dec 2013 13:06:57 EST
From: Chen-Yu Tsai <wens@csie.org>
To: Giuseppe Cavallaro <peppe.cavallaro@st.com>, netdev@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Cc: Chen-Yu Tsai <wens@csie.org>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 01/10] net: stmmac: Enable stmmac main clock when probing hardware
Date: Sat,  7 Dec 2013 01:29:34 +0800
Message-Id: <1386350983-13281-2-git-send-email-wens@csie.org>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1386350983-13281-1-git-send-email-wens@csie.org>
References: <1386350983-13281-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---

Guiseppe previously stated that the "stmmaceth" clock is the
main clock that drives the IP. The stmmac driver does not
enable this clock during the probe phase. When the driver is
built in to the kernel, this is fine because the clock maybe
on by default, or the boot loader had enabled it.

If stmmac is built as a module, when the module is loaded,
the clock may be found unused and disabled by the kernel.

 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 24 +++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 8d4ccd3..7da71ed 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2688,10 +2688,17 @@ struct stmmac_priv *stmmac_dvr_probe(struct device *device,
 	if ((phyaddr >= 0) && (phyaddr <= 31))
 		priv->plat->phy_addr = phyaddr;
 
+	priv->stmmac_clk = clk_get(priv->device, STMMAC_RESOURCE_NAME);
+	if (IS_ERR(priv->stmmac_clk)) {
+		pr_warn("%s: warning: cannot get CSR clock\n", __func__);
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
 
@@ -2729,12 +2736,6 @@ struct stmmac_priv *stmmac_dvr_probe(struct device *device,
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
@@ -2759,15 +2760,18 @@ struct stmmac_priv *stmmac_dvr_probe(struct device *device,
 		}
 	}
 
+	clk_disable_unprepare(priv->stmmac_clk);
+
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
+	clk_put(priv->stmmac_clk);
+error_clk_get:
 	free_netdev(ndev);
 
 	return NULL;
-- 
1.8.5.1

