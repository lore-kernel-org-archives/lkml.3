Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbaBDQDE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 11:03:04 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:46126 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131AbaBDP7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 10:59:43 -0500
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Cc: Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Chris Ball <chris@printf.net>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 09/17] spi: pl022: Simplify clock handling
Date: Tue,  4 Feb 2014 16:58:50 +0100
Message-Id: <1391529538-21685-10-git-send-email-ulf.hansson@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org>
References: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of clk_prepare_enable and clk_disable_unprepare to simplify
code. No functional change.

Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/spi/spi-pl022.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/spi/spi-pl022.c b/drivers/spi/spi-pl022.c
index 2bb238f..2f44c81 100644
--- a/drivers/spi/spi-pl022.c
+++ b/drivers/spi/spi-pl022.c
@@ -2183,13 +2183,7 @@ static int pl022_probe(struct amba_device *adev, const struct amba_id *id)
 		goto err_no_clk;
 	}
 
-	status = clk_prepare(pl022->clk);
-	if (status) {
-		dev_err(&adev->dev, "could not prepare SSP/SPI bus clock\n");
-		goto  err_clk_prep;
-	}
-
-	status = clk_enable(pl022->clk);
+	status = clk_prepare_enable(pl022->clk);
 	if (status) {
 		dev_err(&adev->dev, "could not enable SSP/SPI bus clock\n");
 		goto err_no_clk_en;
@@ -2250,10 +2244,8 @@ static int pl022_probe(struct amba_device *adev, const struct amba_id *id)
 	if (platform_info->enable_dma)
 		pl022_dma_remove(pl022);
  err_no_irq:
-	clk_disable(pl022->clk);
+	clk_disable_unprepare(pl022->clk);
  err_no_clk_en:
-	clk_unprepare(pl022->clk);
- err_clk_prep:
  err_no_clk:
  err_no_ioremap:
 	amba_release_regions(adev);
@@ -2281,8 +2273,7 @@ pl022_remove(struct amba_device *adev)
 	if (pl022->master_info->enable_dma)
 		pl022_dma_remove(pl022);
 
-	clk_disable(pl022->clk);
-	clk_unprepare(pl022->clk);
+	clk_disable_unprepare(pl022->clk);
 	amba_release_regions(adev);
 	tasklet_disable(&pl022->pump_transfers);
 	return 0;
-- 
1.7.9.5

