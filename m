Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661AbaGXJTc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:19:32 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46480 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751549AbaGXJRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:17:35 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, tj@kernel.org, kishon@ti.com
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v11 3/8] ata: libahci_platform: move port_map parameters into the AHCI structure
Date: Thu, 24 Jul 2014 11:17:25 +0200
Message-Id: <1406193450-17283-4-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406193450-17283-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1406193450-17283-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves force_port_map and mask_port_map into the
ahci_host_priv structure. This allows to modify them into the AHCI
framework. This is needed by the new dt bindings representing ports as
the port_map mask is computed automatically.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 drivers/ata/ahci.h             |  6 +++---
 drivers/ata/ahci_da850.c       |  3 +--
 drivers/ata/ahci_imx.c         |  3 +--
 drivers/ata/ahci_mvebu.c       |  3 +--
 drivers/ata/ahci_platform.c    |  3 +--
 drivers/ata/ahci_st.c          |  2 +-
 drivers/ata/ahci_sunxi.c       |  2 +-
 drivers/ata/ahci_xgene.c       |  2 +-
 drivers/ata/libahci.c          | 17 +++++++----------
 drivers/ata/libahci_platform.c |  8 ++------
 include/linux/ahci_platform.h  |  4 +---
 11 files changed, 20 insertions(+), 33 deletions(-)

diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index 5513296e5e2e..cb8d58926851 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -321,6 +321,8 @@ struct ahci_host_priv {
 	u32			cap;		/* cap to use */
 	u32			cap2;		/* cap2 to use */
 	u32			port_map;	/* port map to use */
+	u32			force_port_map;	/* force port map */
+	u32			mask_port_map;	/* mask out particular bits */
 	u32			saved_cap;	/* saved initial cap */
 	u32			saved_cap2;	/* saved initial cap2 */
 	u32			saved_port_map;	/* saved initial port_map */
@@ -361,9 +363,7 @@ unsigned int ahci_dev_classify(struct ata_port *ap);
 void ahci_fill_cmd_slot(struct ahci_port_priv *pp, unsigned int tag,
 			u32 opts);
 void ahci_save_initial_config(struct device *dev,
-			      struct ahci_host_priv *hpriv,
-			      unsigned int force_port_map,
-			      unsigned int mask_port_map);
+			      struct ahci_host_priv *hpriv);
 void ahci_init_controller(struct ata_host *host);
 int ahci_reset_controller(struct ata_host *host);
 
diff --git a/drivers/ata/ahci_da850.c b/drivers/ata/ahci_da850.c
index 2b77d53bccf8..33b862b2c5db 100644
--- a/drivers/ata/ahci_da850.c
+++ b/drivers/ata/ahci_da850.c
@@ -85,8 +85,7 @@ static int ahci_da850_probe(struct platform_device *pdev)
 
 	da850_sata_init(dev, pwrdn_reg, hpriv->mmio);
 
-	rc = ahci_platform_init_host(pdev, hpriv, &ahci_da850_port_info,
-				     0, 0, 0);
+	rc = ahci_platform_init_host(pdev, hpriv, &ahci_da850_port_info, 0);
 	if (rc)
 		goto disable_resources;
 
diff --git a/drivers/ata/ahci_imx.c b/drivers/ata/ahci_imx.c
index cac4360f272a..c8eef2d745d8 100644
--- a/drivers/ata/ahci_imx.c
+++ b/drivers/ata/ahci_imx.c
@@ -454,8 +454,7 @@ static int imx_ahci_probe(struct platform_device *pdev)
 	reg_val = clk_get_rate(imxpriv->ahb_clk) / 1000;
 	writel(reg_val, hpriv->mmio + IMX_TIMER1MS);
 
-	ret = ahci_platform_init_host(pdev, hpriv, &ahci_imx_port_info,
-				      0, 0, 0);
+	ret = ahci_platform_init_host(pdev, hpriv, &ahci_imx_port_info, 0);
 	if (ret)
 		goto disable_sata;
 
diff --git a/drivers/ata/ahci_mvebu.c b/drivers/ata/ahci_mvebu.c
index fd3dfd733b84..0ba0cf7a9ba9 100644
--- a/drivers/ata/ahci_mvebu.c
+++ b/drivers/ata/ahci_mvebu.c
@@ -88,8 +88,7 @@ static int ahci_mvebu_probe(struct platform_device *pdev)
 	ahci_mvebu_mbus_config(hpriv, dram);
 	ahci_mvebu_regret_option(hpriv);
 
-	rc = ahci_platform_init_host(pdev, hpriv, &ahci_mvebu_port_info,
-				     0, 0, 0);
+	rc = ahci_platform_init_host(pdev, hpriv, &ahci_mvebu_port_info, 0);
 	if (rc)
 		goto disable_resources;
 
diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index b10d81ddb528..95f9ca82082a 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -60,8 +60,7 @@ static int ahci_probe(struct platform_device *pdev)
 	if (of_device_is_compatible(dev->of_node, "hisilicon,hisi-ahci"))
 		hflags |= AHCI_HFLAG_NO_FBS | AHCI_HFLAG_NO_NCQ;
 
-	rc = ahci_platform_init_host(pdev, hpriv, &ahci_port_info,
-				     hflags, 0, 0);
+	rc = ahci_platform_init_host(pdev, hpriv, &ahci_port_info, hflags);
 	if (rc)
 		goto pdata_exit;
 
diff --git a/drivers/ata/ahci_st.c b/drivers/ata/ahci_st.c
index 2595598df9ce..6767c7790b4a 100644
--- a/drivers/ata/ahci_st.c
+++ b/drivers/ata/ahci_st.c
@@ -166,7 +166,7 @@ static int st_ahci_probe(struct platform_device *pdev)
 	if (err)
 		return err;
 
-	err = ahci_platform_init_host(pdev, hpriv, &st_ahci_port_info, 0, 0, 0);
+	err = ahci_platform_init_host(pdev, hpriv, &st_ahci_port_info, 0);
 	if (err) {
 		ahci_platform_disable_resources(hpriv);
 		return err;
diff --git a/drivers/ata/ahci_sunxi.c b/drivers/ata/ahci_sunxi.c
index 02002f125bd4..9f8ff1f9e912 100644
--- a/drivers/ata/ahci_sunxi.c
+++ b/drivers/ata/ahci_sunxi.c
@@ -188,7 +188,7 @@ static int ahci_sunxi_probe(struct platform_device *pdev)
 		 AHCI_HFLAG_NO_PMP | AHCI_HFLAG_YES_NCQ;
 
 	rc = ahci_platform_init_host(pdev, hpriv, &ahci_sunxi_port_info,
-				     hflags, 0, 0);
+				     hflags);
 	if (rc)
 		goto disable_resources;
 
diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
index ee3a3659bd9e..87d39fbe616b 100644
--- a/drivers/ata/ahci_xgene.c
+++ b/drivers/ata/ahci_xgene.c
@@ -487,7 +487,7 @@ static int xgene_ahci_probe(struct platform_device *pdev)
 	hflags = AHCI_HFLAG_NO_PMP | AHCI_HFLAG_YES_NCQ;
 
 	rc = ahci_platform_init_host(pdev, hpriv, &xgene_ahci_port_info,
-				     hflags, 0, 0);
+				     hflags);
 	if (rc)
 		goto disable_resources;
 
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index d72ce0470309..3c0b623747bd 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -398,10 +398,7 @@ static ssize_t ahci_show_em_supported(struct device *dev,
  *	LOCKING:
  *	None.
  */
-void ahci_save_initial_config(struct device *dev,
-			      struct ahci_host_priv *hpriv,
-			      unsigned int force_port_map,
-			      unsigned int mask_port_map)
+void ahci_save_initial_config(struct device *dev, struct ahci_host_priv *hpriv)
 {
 	void __iomem *mmio = hpriv->mmio;
 	u32 cap, cap2, vers, port_map;
@@ -468,17 +465,17 @@ void ahci_save_initial_config(struct device *dev,
 		cap &= ~HOST_CAP_FBS;
 	}
 
-	if (force_port_map && port_map != force_port_map) {
+	if (hpriv->force_port_map && port_map != hpriv->force_port_map) {
 		dev_info(dev, "forcing port_map 0x%x -> 0x%x\n",
-			 port_map, force_port_map);
-		port_map = force_port_map;
+			 port_map, hpriv->force_port_map);
+		port_map = hpriv->force_port_map;
 	}
 
-	if (mask_port_map) {
+	if (hpriv->mask_port_map) {
 		dev_warn(dev, "masking port_map 0x%x -> 0x%x\n",
 			port_map,
-			port_map & mask_port_map);
-		port_map &= mask_port_map;
+			port_map & hpriv->mask_port_map);
+		port_map &= hpriv->mask_port_map;
 	}
 
 	/* cross check port_map and cap.n_ports */
diff --git a/drivers/ata/libahci_platform.c b/drivers/ata/libahci_platform.c
index b0077589f065..db9b90d876dd 100644
--- a/drivers/ata/libahci_platform.c
+++ b/drivers/ata/libahci_platform.c
@@ -289,8 +289,6 @@ EXPORT_SYMBOL_GPL(ahci_platform_get_resources);
  * @hpriv: ahci-host private data for the host
  * @pi_template: template for the ata_port_info to use
  * @host_flags: ahci host flags used in ahci_host_priv
- * @force_port_map: param passed to ahci_save_initial_config
- * @mask_port_map: param passed to ahci_save_initial_config
  *
  * This function does all the usual steps needed to bring up an
  * ahci-platform host, note any necessary resources (ie clks, phy, etc.)
@@ -302,9 +300,7 @@ EXPORT_SYMBOL_GPL(ahci_platform_get_resources);
 int ahci_platform_init_host(struct platform_device *pdev,
 			    struct ahci_host_priv *hpriv,
 			    const struct ata_port_info *pi_template,
-			    unsigned long host_flags,
-			    unsigned int force_port_map,
-			    unsigned int mask_port_map)
+			    unsigned long host_flags)
 {
 	struct device *dev = &pdev->dev;
 	struct ata_port_info pi = *pi_template;
@@ -322,7 +318,7 @@ int ahci_platform_init_host(struct platform_device *pdev,
 	pi.private_data = (void *)host_flags;
 	hpriv->flags |= host_flags;
 
-	ahci_save_initial_config(dev, hpriv, force_port_map, mask_port_map);
+	ahci_save_initial_config(dev, hpriv);
 
 	if (hpriv->cap & HOST_CAP_NCQ)
 		pi.flags |= ATA_FLAG_NCQ;
diff --git a/include/linux/ahci_platform.h b/include/linux/ahci_platform.h
index 6dfd51a04d77..554bcafa7eb4 100644
--- a/include/linux/ahci_platform.h
+++ b/include/linux/ahci_platform.h
@@ -44,9 +44,7 @@ struct ahci_host_priv *ahci_platform_get_resources(
 int ahci_platform_init_host(struct platform_device *pdev,
 			    struct ahci_host_priv *hpriv,
 			    const struct ata_port_info *pi_template,
-			    unsigned long host_flags,
-			    unsigned int force_port_map,
-			    unsigned int mask_port_map);
+			    unsigned long host_flags);
 
 int ahci_platform_suspend_host(struct device *dev);
 int ahci_platform_resume_host(struct device *dev);
-- 
1.9.1

