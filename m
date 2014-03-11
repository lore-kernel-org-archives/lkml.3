Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbaCKKAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:00:33 -0400
Received: from michel.telenet-ops.be ([195.130.137.88]:60729 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129AbaCKJ7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 05:59:21 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH 3/3] spi: rspi: Add runtime PM support, using spi core auto_runtime_pm
Date: Tue, 11 Mar 2014 10:59:12 +0100
Message-Id: <1394531952-3905-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394531952-3905-1-git-send-email-geert@linux-m68k.org>
References: <1394531952-3905-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
 drivers/spi/spi-rspi.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/spi/spi-rspi.c b/drivers/spi/spi-rspi.c
index 92bec7e91046..1fb0ad213324 100644
--- a/drivers/spi/spi-rspi.c
+++ b/drivers/spi/spi-rspi.c
@@ -33,6 +33,7 @@
 #include <linux/dmaengine.h>
 #include <linux/dma-mapping.h>
 #include <linux/of_device.h>
+#include <linux/pm_runtime.h>
 #include <linux/sh_dma.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/rspi.h>
@@ -1111,7 +1112,7 @@ static int rspi_remove(struct platform_device *pdev)
 	struct rspi_data *rspi = platform_get_drvdata(pdev);
 
 	rspi_release_dma(rspi);
-	clk_disable_unprepare(rspi->clk);
+	pm_runtime_disable(&pdev->dev);
 
 	return 0;
 }
@@ -1242,16 +1243,13 @@ static int rspi_probe(struct platform_device *pdev)
 		goto error1;
 	}
 
-	ret = clk_prepare_enable(rspi->clk);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "unable to prepare/enable clock\n");
-		goto error1;
-	}
+	pm_runtime_enable(&pdev->dev);
 
 	init_waitqueue_head(&rspi->wait);
 
 	master->bus_num = pdev->id;
 	master->setup = rspi_setup;
+	master->auto_runtime_pm = true;
 	master->transfer_one = ops->transfer_one;
 	master->prepare_message = rspi_prepare_message;
 	master->unprepare_message = rspi_unprepare_message;
@@ -1312,7 +1310,7 @@ static int rspi_probe(struct platform_device *pdev)
 error3:
 	rspi_release_dma(rspi);
 error2:
-	clk_disable_unprepare(rspi->clk);
+	pm_runtime_disable(&pdev->dev);
 error1:
 	spi_master_put(master);
 
-- 
1.7.9.5

