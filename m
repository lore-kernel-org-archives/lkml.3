Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760714Ab3JPLnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 07:43:41 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50003 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760182Ab3JPLnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 07:43:05 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tj@kernel.org>
CC: <sergei.shtylyov@cogentembedded.com>, <kishon@ti.com>,
        <b.zolnierkie@samsung.com>, <linux-ide@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Balaji T K <balajitk@ti.com>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH v2 1/2] ata: ahci_platform: Manage SATA PHY
Date: Wed, 16 Oct 2013 14:42:52 +0300
Message-ID: <1381923773-10596-2-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381923773-10596-1-git-send-email-rogerq@ti.com>
References: <1381923773-10596-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Balaji T K <balajitk@ti.com>

Some platforms have a PHY hooked up to the
SATA controller. The PHY needs to be initialized
and powered up for SATA to work. We do that
using the PHY framework.

[Roger Q] Cleaned up.

CC: Tejun Heo <tj@kernel.org>
Signed-off-by: Balaji T K <balajitk@ti.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 .../devicetree/bindings/ata/ahci-platform.txt      |    3 +-
 drivers/ata/ahci.h                                 |    2 ++
 drivers/ata/ahci_platform.c                        |   29 +++++++++++++++++++-
 3 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/ata/ahci-platform.txt b/Documentation/devicetree/bindings/ata/ahci-platform.txt
index 89de156..c8a6cea 100644
--- a/Documentation/devicetree/bindings/ata/ahci-platform.txt
+++ b/Documentation/devicetree/bindings/ata/ahci-platform.txt
@@ -4,7 +4,8 @@ SATA nodes are defined to describe on-chip Serial ATA controllers.
 Each SATA controller should have its own node.
 
 Required properties:
-- compatible        : compatible list, contains "snps,spear-ahci"
+- compatible        : compatible list, contains "snps,spear-ahci",
+			snps,exynos5440-ahci or "snps,dwc-ahci"
 - interrupts        : <interrupt mapping for SATA IRQ>
 - reg               : <registers mapping>
 
diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index 1145637..94484cb 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -37,6 +37,7 @@
 
 #include <linux/clk.h>
 #include <linux/libata.h>
+#include <linux/phy/phy.h>
 
 /* Enclosure Management Control */
 #define EM_CTRL_MSG_TYPE              0x000f0000
@@ -322,6 +323,7 @@ struct ahci_host_priv {
 	u32			em_buf_sz;	/* EM buffer size in byte */
 	u32			em_msg_type;	/* EM message type */
 	struct clk		*clk;		/* Only for platforms supporting clk */
+	struct phy		*phy;		/* If platforms use phy */
 	void			*plat_data;	/* Other platform data */
 };
 
diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index 2daaee0..5a0f1418 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -141,6 +141,21 @@ static int ahci_probe(struct platform_device *pdev)
 		}
 	}
 
+	hpriv->phy = devm_phy_get(dev, "sata-phy");
+	if (IS_ERR(hpriv->phy)) {
+		dev_dbg(dev, "can't get sata-phy\n");
+		/* return only if -EPROBE_DEFER */
+		if (PTR_ERR(hpriv->phy) == -EPROBE_DEFER) {
+			rc = -EPROBE_DEFER;
+			goto disable_unprepare_clk;
+		}
+	}
+
+	if (!IS_ERR(hpriv->phy)) {
+		phy_init(hpriv->phy);
+		phy_power_on(hpriv->phy);
+	}
+
 	/*
 	 * Some platforms might need to prepare for mmio region access,
 	 * which could be done in the following init call. So, the mmio
@@ -150,7 +165,7 @@ static int ahci_probe(struct platform_device *pdev)
 	if (pdata && pdata->init) {
 		rc = pdata->init(dev, hpriv->mmio);
 		if (rc)
-			goto disable_unprepare_clk;
+			goto disable_phy;
 	}
 
 	ahci_save_initial_config(dev, hpriv,
@@ -220,6 +235,12 @@ static int ahci_probe(struct platform_device *pdev)
 pdata_exit:
 	if (pdata && pdata->exit)
 		pdata->exit(dev);
+disable_phy:
+	if (!IS_ERR(hpriv->phy)) {
+		phy_power_off(hpriv->phy);
+		phy_exit(hpriv->phy);
+	}
+
 disable_unprepare_clk:
 	if (!IS_ERR(hpriv->clk))
 		clk_disable_unprepare(hpriv->clk);
@@ -238,6 +259,11 @@ static void ahci_host_stop(struct ata_host *host)
 	if (pdata && pdata->exit)
 		pdata->exit(dev);
 
+	if (!IS_ERR(hpriv->phy)) {
+		phy_power_off(hpriv->phy);
+		phy_exit(hpriv->phy);
+	}
+
 	if (!IS_ERR(hpriv->clk)) {
 		clk_disable_unprepare(hpriv->clk);
 		clk_put(hpriv->clk);
@@ -328,6 +354,7 @@ static SIMPLE_DEV_PM_OPS(ahci_pm_ops, ahci_suspend, ahci_resume);
 static const struct of_device_id ahci_of_match[] = {
 	{ .compatible = "snps,spear-ahci", },
 	{ .compatible = "snps,exynos5440-ahci", },
+	{ .compatible = "snps,dwc-ahci", },
 	{},
 };
 MODULE_DEVICE_TABLE(of, ahci_of_match);
-- 
1.7.9.5

