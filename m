Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbaDWLiT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 07:38:19 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:36954 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbaDWLhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 07:37:10 -0400
From: Kefeng Wang <kefeng.wang@linaro.org>
To: Tejun Heo <tj@kernel.org>, Hans de Goede <hdegoede@redhat.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: wangkefeng.wang@huawei.com, kefeng.wang@linaro.org
Subject: [PATCH v4 2/3] libahci_platform: add host_flags parameter in ahci_platform_init_host()
Date: Wed, 23 Apr 2014 19:36:46 +0800
Message-Id: <1398253008-17059-3-git-send-email-kefeng.wang@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398253008-17059-1-git-send-email-kefeng.wang@linaro.org>
References: <1398253008-17059-1-git-send-email-kefeng.wang@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a dynamic host flags argument to make ahci_platform_init_host more flexible,
then remove the AHCI_HFLAGS(...) argument from some driver's ata_port_info,
and pass that in as the new arguments.

Cc: Hans de Geode <hdegoede@redhat.com>
Signed-off-by: Kefeng Wang <kefeng.wang@linaro.org>
---
 drivers/ata/ahci_da850.c       |    3 ++-
 drivers/ata/ahci_imx.c         |    3 ++-
 drivers/ata/ahci_platform.c    |    2 +-
 drivers/ata/ahci_st.c          |    2 +-
 drivers/ata/ahci_sunxi.c       |    9 ++++++---
 drivers/ata/ahci_xgene.c       |    6 +++++-
 drivers/ata/libahci_platform.c |    2 ++
 include/linux/ahci_platform.h  |    1 +
 8 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/ata/ahci_da850.c b/drivers/ata/ahci_da850.c
index 2c83613..2b77d53 100644
--- a/drivers/ata/ahci_da850.c
+++ b/drivers/ata/ahci_da850.c
@@ -85,7 +85,8 @@ static int ahci_da850_probe(struct platform_device *pdev)
 
 	da850_sata_init(dev, pwrdn_reg, hpriv->mmio);
 
-	rc = ahci_platform_init_host(pdev, hpriv, &ahci_da850_port_info, 0, 0);
+	rc = ahci_platform_init_host(pdev, hpriv, &ahci_da850_port_info,
+				     0, 0, 0);
 	if (rc)
 		goto disable_resources;
 
diff --git a/drivers/ata/ahci_imx.c b/drivers/ata/ahci_imx.c
index 497c7ab..e7e44a7 100644
--- a/drivers/ata/ahci_imx.c
+++ b/drivers/ata/ahci_imx.c
@@ -267,7 +267,8 @@ static int imx_ahci_probe(struct platform_device *pdev)
 	reg_val = clk_get_rate(imxpriv->ahb_clk) / 1000;
 	writel(reg_val, hpriv->mmio + HOST_TIMER1MS);
 
-	ret = ahci_platform_init_host(pdev, hpriv, &ahci_imx_port_info, 0, 0);
+	ret = ahci_platform_init_host(pdev, hpriv, &ahci_imx_port_info,
+				      0, 0, 0);
 	if (ret)
 		imx_sata_disable(hpriv);
 
diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index ef67e79..a476a1f 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -55,7 +55,7 @@ static int ahci_probe(struct platform_device *pdev)
 			goto disable_resources;
 	}
 
-	rc = ahci_platform_init_host(pdev, hpriv, &ahci_port_info, 0, 0);
+	rc = ahci_platform_init_host(pdev, hpriv, &ahci_port_info, 0, 0, 0);
 	if (rc)
 		goto pdata_exit;
 
diff --git a/drivers/ata/ahci_st.c b/drivers/ata/ahci_st.c
index 6332222..2595598 100644
--- a/drivers/ata/ahci_st.c
+++ b/drivers/ata/ahci_st.c
@@ -166,7 +166,7 @@ static int st_ahci_probe(struct platform_device *pdev)
 	if (err)
 		return err;
 
-	err = ahci_platform_init_host(pdev, hpriv, &st_ahci_port_info, 0, 0);
+	err = ahci_platform_init_host(pdev, hpriv, &st_ahci_port_info, 0, 0, 0);
 	if (err) {
 		ahci_platform_disable_resources(hpriv);
 		return err;
diff --git a/drivers/ata/ahci_sunxi.c b/drivers/ata/ahci_sunxi.c
index 42d3f64..543132a 100644
--- a/drivers/ata/ahci_sunxi.c
+++ b/drivers/ata/ahci_sunxi.c
@@ -157,8 +157,6 @@ static void ahci_sunxi_start_engine(struct ata_port *ap)
 }
 
 static const struct ata_port_info ahci_sunxi_port_info = {
-	AHCI_HFLAGS(AHCI_HFLAG_32BIT_ONLY | AHCI_HFLAG_NO_MSI |
-			  AHCI_HFLAG_NO_PMP | AHCI_HFLAG_YES_NCQ),
 	.flags		= AHCI_FLAG_COMMON | ATA_FLAG_NCQ,
 	.pio_mask	= ATA_PIO4,
 	.udma_mask	= ATA_UDMA6,
@@ -169,6 +167,7 @@ static int ahci_sunxi_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct ahci_host_priv *hpriv;
+	unsigned int hflags;
 	int rc;
 
 	hpriv = ahci_platform_get_resources(pdev);
@@ -185,7 +184,11 @@ static int ahci_sunxi_probe(struct platform_device *pdev)
 	if (rc)
 		goto disable_resources;
 
-	rc = ahci_platform_init_host(pdev, hpriv, &ahci_sunxi_port_info, 0, 0);
+	hflags = AHCI_HFLAG_32BIT_ONLY | AHCI_HFLAG_NO_MSI |
+		 AHCI_HFLAG_NO_PMP | AHCI_HFLAG_YES_NCQ,
+
+	rc = ahci_platform_init_host(pdev, hpriv, &ahci_sunxi_port_info,
+				     hflags, 0, 0);
 	if (rc)
 		goto disable_resources;
 
diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
index 77c89bf..8022b5a 100644
--- a/drivers/ata/ahci_xgene.c
+++ b/drivers/ata/ahci_xgene.c
@@ -382,6 +382,7 @@ static int xgene_ahci_probe(struct platform_device *pdev)
 	struct ahci_host_priv *hpriv;
 	struct xgene_ahci_context *ctx;
 	struct resource *res;
+	unsigned int hflags;
 	int rc;
 
 	hpriv = ahci_platform_get_resources(pdev);
@@ -450,7 +451,10 @@ static int xgene_ahci_probe(struct platform_device *pdev)
 		goto disable_resources;
 	}
 
-	rc = ahci_platform_init_host(pdev, hpriv, &xgene_ahci_port_info, 0, 0);
+	hflags = AHCI_HFLAG_NO_PMP | AHCI_HFLAG_YES_NCQ,
+
+	rc = ahci_platform_init_host(pdev, hpriv, &xgene_ahci_port_info,
+				     hflags, 0, 0);
 	if (rc)
 		goto disable_resources;
 
diff --git a/drivers/ata/libahci_platform.c b/drivers/ata/libahci_platform.c
index 7cb3a85..ebd880e 100644
--- a/drivers/ata/libahci_platform.c
+++ b/drivers/ata/libahci_platform.c
@@ -283,6 +283,7 @@ EXPORT_SYMBOL_GPL(ahci_platform_get_resources);
  * @pdev: platform device pointer for the host
  * @hpriv: ahci-host private data for the host
  * @pi_template: template for the ata_port_info to use
+ * @host_flags: ahci host flags used in ahci_host_priv
  * @force_port_map: param passed to ahci_save_initial_config
  * @mask_port_map: param passed to ahci_save_initial_config
  *
@@ -296,6 +297,7 @@ EXPORT_SYMBOL_GPL(ahci_platform_get_resources);
 int ahci_platform_init_host(struct platform_device *pdev,
 			    struct ahci_host_priv *hpriv,
 			    const struct ata_port_info *pi_template,
+			    unsigned int host_flags,
 			    unsigned int force_port_map,
 			    unsigned int mask_port_map)
 {
diff --git a/include/linux/ahci_platform.h b/include/linux/ahci_platform.h
index 1f16d50..45897f6 100644
--- a/include/linux/ahci_platform.h
+++ b/include/linux/ahci_platform.h
@@ -44,6 +44,7 @@ struct ahci_host_priv *ahci_platform_get_resources(
 int ahci_platform_init_host(struct platform_device *pdev,
 			    struct ahci_host_priv *hpriv,
 			    const struct ata_port_info *pi_template,
+			    unsigned int host_flags,
 			    unsigned int force_port_map,
 			    unsigned int mask_port_map);
 
-- 
1.7.9.5

