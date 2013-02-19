Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151Ab3BSMtQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 07:49:16 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:38861 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510Ab3BSMtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 07:49:12 -0500
From: Philip Avinash <avinashphilip@ti.com>
To: <khilman@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <dwmw2@infradead.org>
CC: <afzal@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <nsekhar@ti.com>,
        <gururaja.hebbar@ti.com>, <hvaibhav@ti.com>,
        Philip Avinash <avinashphilip@ti.com>
Subject: [PATCH v3 1/3] arm: gpmc: Converts GPMC driver to pm_runtime capable
Date: Tue, 19 Feb 2013 18:20:17 +0530
Message-ID: <1361278219-23108-2-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361278219-23108-1-git-send-email-avinashphilip@ti.com>
References: <1361278219-23108-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support for pm_runtime add to GPMC driver.

Signed-off-by: Philip Avinash <avinashphilip@ti.com>
---
 arch/arm/mach-omap2/gpmc.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
index 2c57f81..b1cd6c1 100644
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -29,6 +29,7 @@
 #include <linux/of_mtd.h>
 #include <linux/of_device.h>
 #include <linux/mtd/nand.h>
+#include <linux/pm_runtime.h>
 
 #include <linux/platform_data/mtd-nand-omap2.h>
 
@@ -1317,7 +1318,8 @@ static int gpmc_probe(struct platform_device *pdev)
 		return PTR_ERR(gpmc_l3_clk);
 	}
 
-	clk_prepare_enable(gpmc_l3_clk);
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_get_sync(&pdev->dev);
 
 	gpmc_dev = &pdev->dev;
 
@@ -1329,7 +1331,7 @@ static int gpmc_probe(struct platform_device *pdev)
 
 	rc = gpmc_mem_init();
 	if (IS_ERR_VALUE(rc)) {
-		clk_disable_unprepare(gpmc_l3_clk);
+		pm_runtime_put_sync(&pdev->dev);
 		clk_put(gpmc_l3_clk);
 		dev_err(gpmc_dev, "failed to reserve memory\n");
 		return rc;
@@ -1340,7 +1342,7 @@ static int gpmc_probe(struct platform_device *pdev)
 
 	rc = gpmc_probe_dt(pdev);
 	if (rc < 0) {
-		clk_disable_unprepare(gpmc_l3_clk);
+		pm_runtime_put_sync(&pdev->dev);
 		clk_put(gpmc_l3_clk);
 		dev_err(gpmc_dev, "failed to probe DT parameters\n");
 		return rc;
@@ -1353,6 +1355,8 @@ static __devexit int gpmc_remove(struct platform_device *pdev)
 {
 	gpmc_free_irq();
 	gpmc_mem_exit();
+	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
 	gpmc_dev = NULL;
 	return 0;
 }
-- 
1.7.9.5

