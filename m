Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917AbaATOmB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 09:42:01 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:47797 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753779AbaATOly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 09:41:54 -0500
From: Roger Quadros <rogerq@ti.com>
To: <tj@kernel.org>
CC: <sergei.shtylyov@cogentembedded.com>, <kishon@ti.com>,
        <b.zolnierkie@samsung.com>, <hdegoede@redhat.com>, <arnd@arndb.de>,
        <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Balaji T K <balajitk@ti.com>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH v5 3/4] ata: ahci_platform: Manage SATA PHY
Date: Mon, 20 Jan 2014 16:41:27 +0200
Message-ID: <1390228888-5537-4-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1390228888-5537-1-git-send-email-rogerq@ti.com>
References: <1390228888-5537-1-git-send-email-rogerq@ti.com>
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

Signed-off-by: Balaji T K <balajitk@ti.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/ata/ahci.h          |  2 ++
 drivers/ata/ahci_platform.c | 44 +++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 45 insertions(+), 1 deletion(-)

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
index d5ced13..580567f 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -142,6 +142,37 @@ static int ahci_probe(struct platform_device *pdev)
 		}
 	}
 
+	hpriv->phy = devm_phy_get(dev, "sata-phy");
+	if (IS_ERR(hpriv->phy)) {
+		rc = PTR_ERR(hpriv->phy);
+		switch (rc) {
+		case -ENODEV:
+		case -ENOSYS:
+			/* continue normally */
+			hpriv->phy = NULL;
+			break;
+
+		case -EPROBE_DEFER:
+			goto disable_unprepare_clk;
+
+		default:
+			dev_err(dev, "couldn't get sata-phy\n");
+			goto disable_unprepare_clk;
+		}
+	}
+
+	if (hpriv->phy) {
+		rc = phy_init(hpriv->phy);
+		if (rc)
+			goto disable_unprepare_clk;
+
+		rc = phy_power_on(hpriv->phy);
+		if (rc) {
+			phy_exit(hpriv->phy);
+			goto disable_unprepare_clk;
+		}
+	}
+
 	/*
 	 * Some platforms might need to prepare for mmio region access,
 	 * which could be done in the following init call. So, the mmio
@@ -151,7 +182,7 @@ static int ahci_probe(struct platform_device *pdev)
 	if (pdata && pdata->init) {
 		rc = pdata->init(dev, hpriv->mmio);
 		if (rc)
-			goto disable_unprepare_clk;
+			goto disable_phy;
 	}
 
 	ahci_save_initial_config(dev, hpriv,
@@ -221,6 +252,12 @@ static int ahci_probe(struct platform_device *pdev)
 pdata_exit:
 	if (pdata && pdata->exit)
 		pdata->exit(dev);
+disable_phy:
+	if (hpriv->phy) {
+		phy_power_off(hpriv->phy);
+		phy_exit(hpriv->phy);
+	}
+
 disable_unprepare_clk:
 	if (!IS_ERR(hpriv->clk))
 		clk_disable_unprepare(hpriv->clk);
@@ -239,6 +276,11 @@ static void ahci_host_stop(struct ata_host *host)
 	if (pdata && pdata->exit)
 		pdata->exit(dev);
 
+	if (hpriv->phy) {
+		phy_power_off(hpriv->phy);
+		phy_exit(hpriv->phy);
+	}
+
 	if (!IS_ERR(hpriv->clk)) {
 		clk_disable_unprepare(hpriv->clk);
 		clk_put(hpriv->clk);
-- 
1.8.3.2

