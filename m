Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944AbaAJHHA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 02:07:00 -0500
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:34813 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbaAJHAW (ORCPT
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
Subject: [PATCH v2 03/16] net: stmmac: Add support for optional reset control
Date: Fri, 10 Jan 2014 15:00:04 +0800
Message-Id: <1389337217-29032-4-git-send-email-wens@csie.org>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389337217-29032-1-git-send-email-wens@csie.org>
References: <1389337217-29032-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DWMAC has a reset assert line, which is used on some SoCs. Add an
optional reset control to stmmac driver core.

To support reset control deferred probing, this patch changes the driver
probe function to return the actual error, instead of just -EINVAL.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 Documentation/devicetree/bindings/net/stmmac.txt      |  3 +++
 drivers/net/ethernet/stmicro/stmmac/stmmac.h          |  2 ++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c     | 19 ++++++++++++++++++-
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c      |  4 ++--
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c |  4 ++--
 5 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/stmmac.txt b/Documentation/devicetree/bindings/net/stmmac.txt
index eba0e5e..d132513 100644
--- a/Documentation/devicetree/bindings/net/stmmac.txt
+++ b/Documentation/devicetree/bindings/net/stmmac.txt
@@ -30,6 +30,9 @@ Required properties:
 
 Optional properties:
 - mac-address: 6 bytes, mac address
+- resets: Should contain a phandle to the STMMAC reset signal, if any
+- reset-names: Should contain the reset signal name "stmmaceth", if a
+	reset phandle is given
 
 Examples:
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index 22f89ff..f19a040 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -32,6 +32,7 @@
 #include <linux/pci.h>
 #include "common.h"
 #include <linux/ptp_clock_kernel.h>
+#include <linux/reset.h>
 
 struct stmmac_priv {
 	/* Frequently used values are kept adjacent for cache effect */
@@ -91,6 +92,7 @@ struct stmmac_priv {
 	int wolopts;
 	int wol_irq;
 	struct clk *stmmac_clk;
+	struct reset_control *stmmac_rst;
 	int clk_csr;
 	struct timer_list eee_ctrl_timer;
 	int lpi_irq;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 786b51c..af2a313 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -50,6 +50,7 @@
 #include <linux/net_tstamp.h>
 #include "stmmac_ptp.h"
 #include "stmmac.h"
+#include <linux/reset.h>
 
 #define STMMAC_ALIGN(x)	L1_CACHE_ALIGN(x)
 #define JUMBO_LEN	9000
@@ -2683,10 +2684,24 @@ struct stmmac_priv *stmmac_dvr_probe(struct device *device,
 	if (IS_ERR(priv->stmmac_clk)) {
 		dev_warn(priv->device, "%s: warning: cannot get CSR clock\n",
 			 __func__);
+		ret = PTR_ERR(priv->stmmac_clk);
 		goto error_clk_get;
 	}
 	clk_prepare_enable(priv->stmmac_clk);
 
+	priv->stmmac_rst = devm_reset_control_get(priv->device,
+						  STMMAC_RESOURCE_NAME);
+	if (IS_ERR(priv->stmmac_rst)) {
+		if (PTR_ERR(priv->stmmac_rst) == -EPROBE_DEFER) {
+			ret = -EPROBE_DEFER;
+			goto error_hw_init;
+		}
+		dev_info(priv->device, "no reset control found\n");
+		priv->stmmac_rst = NULL;
+	}
+	if (priv->stmmac_rst)
+		reset_control_deassert(priv->stmmac_rst);
+
 	/* Init MAC and get the capabilities */
 	ret = stmmac_hw_init(priv);
 	if (ret)
@@ -2763,7 +2778,7 @@ error_hw_init:
 error_clk_get:
 	free_netdev(ndev);
 
-	return NULL;
+	return ERR_PTR(ret);
 }
 
 /**
@@ -2787,6 +2802,8 @@ int stmmac_dvr_remove(struct net_device *ndev)
 		stmmac_mdio_unregister(ndev);
 	netif_carrier_off(ndev);
 	unregister_netdev(ndev);
+	if (priv->stmmac_rst)
+		reset_control_assert(priv->stmmac_rst);
 	clk_disable_unprepare(priv->stmmac_clk);
 	free_netdev(ndev);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
index 644d80e..f3f6218 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
@@ -100,9 +100,9 @@ static int stmmac_pci_probe(struct pci_dev *pdev,
 	stmmac_default_data();
 
 	priv = stmmac_dvr_probe(&(pdev->dev), &plat_dat, addr);
-	if (!priv) {
+	if (IS_ERR(priv)) {
 		pr_err("%s: main driver probe failed", __func__);
-		ret = -ENODEV;
+		ret = PTR_ERR(priv);
 		goto err_out;
 	}
 	priv->dev->irq = pdev->irq;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 51c9069..3974586 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -148,9 +148,9 @@ static int stmmac_pltfr_probe(struct platform_device *pdev)
 	}
 
 	priv = stmmac_dvr_probe(&(pdev->dev), plat_dat, addr);
-	if (!priv) {
+	if (IS_ERR(priv)) {
 		pr_err("%s: main driver probe failed", __func__);
-		return -ENODEV;
+		return PTR_ERR(priv);
 	}
 
 	/* Get MAC address if available (DT) */
-- 
1.8.5.2

