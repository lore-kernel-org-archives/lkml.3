Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbaAQN1w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 08:27:52 -0500
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:34730 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbaAQNY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 08:24:59 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: netdev@vger.kernel.org
Cc: Chen-Yu Tsai <wens@csie.org>, Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH net-next v3 3/8] net: stmmac: Allocate and pass soc/board specific data to callbacks
Date: Fri, 17 Jan 2014 21:24:42 +0800
Message-Id: <1389965087-21971-4-git-send-email-wens@csie.org>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389965087-21971-1-git-send-email-wens@csie.org>
References: <1389965087-21971-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current .init and .exit callbacks requires access to driver
private data structures. This is not a good seperation and abstraction.

Instead, we add a new .setup callback for allocating private data, and
pass the returned pointer to the other callbacks.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 Documentation/networking/stmmac.txt                   | 12 ++++++++----
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 18 ++++++++++++++----
 include/linux/stmmac.h                                |  6 ++++--
 3 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/Documentation/networking/stmmac.txt b/Documentation/networking/stmmac.txt
index cdd916d..2090895 100644
--- a/Documentation/networking/stmmac.txt
+++ b/Documentation/networking/stmmac.txt
@@ -127,8 +127,9 @@ struct plat_stmmacenet_data {
 	int riwt_off;
 	void (*fix_mac_speed)(void *priv, unsigned int speed);
 	void (*bus_setup)(void __iomem *ioaddr);
-	int (*init)(struct platform_device *pdev);
-	void (*exit)(struct platform_device *pdev);
+	void *(*setup)(struct platform_device *pdev);
+	int (*init)(struct platform_device *pdev, void *priv);
+	void (*exit)(struct platform_device *pdev, void *priv);
 	void *custom_cfg;
 	void *custom_data;
 	void *bsp_priv;
@@ -169,10 +170,13 @@ Where:
  o bus_setup: perform HW setup of the bus. For example, on some ST platforms
 	     this field is used to configure the AMBA  bridge to generate more
 	     efficient STBus traffic.
- o init/exit: callbacks used for calling a custom initialization;
+ o setup/init/exit: callbacks used for calling a custom initialization;
 	     this is sometime necessary on some platforms (e.g. ST boxes)
 	     where the HW needs to have set some PIO lines or system cfg
-	     registers.
+	     registers. setup should return a pointer to private data,
+	     which will be stored in bsp_priv, and then passed to init and
+	     exit callbacks. init/exit callbacks should not use or modify
+	     platform data.
  o custom_cfg/custom_data: this is a custom configuration that can be passed
 			   while initializing the resources.
  o bsp_priv: another private pointer.
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index cc6b89a7..704a5e0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -144,9 +144,16 @@ static int stmmac_pltfr_probe(struct platform_device *pdev)
 		}
 	}
 
+	/* Custom setup (if needed) */
+	if (plat_dat->setup) {
+		plat_dat->bsp_priv = plat_dat->setup(pdev);
+		if (IS_ERR(plat_dat->bsp_priv))
+			return PTR_ERR(plat_dat->bsp_priv);
+	}
+
 	/* Custom initialisation (if needed)*/
 	if (plat_dat->init) {
-		ret = plat_dat->init(pdev);
+		ret = plat_dat->init(pdev, plat_dat->bsp_priv);
 		if (unlikely(ret))
 			return ret;
 	}
@@ -203,7 +210,10 @@ static int stmmac_pltfr_remove(struct platform_device *pdev)
 	int ret = stmmac_dvr_remove(ndev);
 
 	if (priv->plat->exit)
-		priv->plat->exit(pdev);
+		priv->plat->exit(pdev, priv->plat->bsp_priv);
+
+	if (priv->plat->free)
+		priv->plat->free(pdev, priv->plat->bsp_priv);
 
 	return ret;
 }
@@ -218,7 +228,7 @@ static int stmmac_pltfr_suspend(struct device *dev)
 
 	ret = stmmac_suspend(ndev);
 	if (priv->plat->exit)
-		priv->plat->exit(pdev);
+		priv->plat->exit(pdev, priv->plat->bsp_priv);
 
 	return ret;
 }
@@ -230,7 +240,7 @@ static int stmmac_pltfr_resume(struct device *dev)
 	struct platform_device *pdev = to_platform_device(dev);
 
 	if (priv->plat->init)
-		priv->plat->init(pdev);
+		priv->plat->init(pdev, priv->plat->bsp_priv);
 
 	return stmmac_resume(ndev);
 }
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index 33ace71..0a5a7ac 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -113,8 +113,10 @@ struct plat_stmmacenet_data {
 	int max_speed;
 	void (*fix_mac_speed)(void *priv, unsigned int speed);
 	void (*bus_setup)(void __iomem *ioaddr);
-	int (*init)(struct platform_device *pdev);
-	void (*exit)(struct platform_device *pdev);
+	void *(*setup)(struct platform_device *pdev);
+	void (*free)(struct platform_device *pdev, void *priv);
+	int (*init)(struct platform_device *pdev, void *priv);
+	void (*exit)(struct platform_device *pdev, void *priv);
 	void *custom_cfg;
 	void *custom_data;
 	void *bsp_priv;
-- 
1.8.5.2

