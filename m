Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbaAHJrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 04:47:41 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:60035 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982AbaAHJra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 04:47:30 -0500
From: Roger Quadros <rogerq@ti.com>
To: <tj@kernel.org>
CC: <sergei.shtylyov@cogentembedded.com>, <kishon@ti.com>,
        <b.zolnierkie@samsung.com>, <hdegoede@redhat.com>,
        <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Balaji T K <balajitk@ti.com>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH v3 2/3] ata: ahci_platform: Manage SATA PHY
Date: Wed, 8 Jan 2014 15:17:07 +0530
Message-ID: <1389174428-31414-3-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389174428-31414-1-git-send-email-rogerq@ti.com>
References: <1389174428-31414-1-git-send-email-rogerq@ti.com>
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
 drivers/ata/ahci.h          |  2 ++
 drivers/ata/ahci_platform.c | 28 +++++++++++++++++++++++++++-
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index 2289efd..f9bbada 100644
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
+	struct phy		*phy;		/* If platform uses phy */
 	void			*plat_data;	/* Other platform data */
 };
 
diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index d5ced13..f61093b 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -142,6 +142,21 @@ static int ahci_probe(struct platform_device *pdev)
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
@@ -151,7 +166,7 @@ static int ahci_probe(struct platform_device *pdev)
 	if (pdata && pdata->init) {
 		rc = pdata->init(dev, hpriv->mmio);
 		if (rc)
-			goto disable_unprepare_clk;
+			goto disable_phy;
 	}
 
 	ahci_save_initial_config(dev, hpriv,
@@ -221,6 +236,12 @@ static int ahci_probe(struct platform_device *pdev)
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
@@ -239,6 +260,11 @@ static void ahci_host_stop(struct ata_host *host)
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
-- 
1.8.3.2

