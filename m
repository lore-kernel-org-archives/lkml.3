Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbaAXIqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 03:46:42 -0500
Received: from michel.telenet-ops.be ([195.130.137.88]:56750 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbaAXIoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 03:44:19 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH v2 11/14] spi: rspi: Convert to clk_prepare_enable/disable_unprepare
Date: Fri, 24 Jan 2014 09:44:01 +0100
Message-Id: <1390553044-11860-12-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390553044-11860-1-git-send-email-geert@linux-m68k.org>
References: <1390553044-11860-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Get the driver ready for the migration to the common clock framework by
calling clk_prepare_enable() and clk_disable_unprepare().

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
v2:
  - No changes

 drivers/spi/spi-rspi.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-rspi.c b/drivers/spi/spi-rspi.c
index 28db8770aaf3..a648b40c271b 100644
--- a/drivers/spi/spi-rspi.c
+++ b/drivers/spi/spi-rspi.c
@@ -980,7 +980,7 @@ static int rspi_remove(struct platform_device *pdev)
 	struct rspi_data *rspi = platform_get_drvdata(pdev);
 
 	rspi_release_dma(rspi);
-	clk_disable(rspi->clk);
+	clk_disable_unprepare(rspi->clk);
 
 	return 0;
 }
@@ -1041,7 +1041,12 @@ static int rspi_probe(struct platform_device *pdev)
 		ret = PTR_ERR(rspi->clk);
 		goto error1;
 	}
-	clk_enable(rspi->clk);
+
+	ret = clk_prepare_enable(rspi->clk);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "unable to prepare/enable clock\n");
+		goto error1;
+	}
 
 	init_waitqueue_head(&rspi->wait);
 
@@ -1112,7 +1117,7 @@ static int rspi_probe(struct platform_device *pdev)
 error3:
 	rspi_release_dma(rspi);
 error2:
-	clk_disable(rspi->clk);
+	clk_disable_unprepare(rspi->clk);
 error1:
 	spi_master_put(master);
 
-- 
1.7.9.5

