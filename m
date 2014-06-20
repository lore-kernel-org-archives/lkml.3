Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100AbaFTUjI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 16:39:08 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:58226 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbaFTUjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 16:39:06 -0400
Date: Sat, 21 Jun 2014 02:08:58 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] spi: omap-uwire: use devm_ functions
Message-ID: <20140620203858.GA14718@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the use of devm_clk_get and devm_ioremap instead
of the unmanaged interfaces and removes the corresponding free function
calls.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/spi/spi-omap-uwire.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi-omap-uwire.c b/drivers/spi/spi-omap-uwire.c
index 0f5a0aa..cbf67f9 100644
--- a/drivers/spi/spi-omap-uwire.c
+++ b/drivers/spi/spi-omap-uwire.c
@@ -447,7 +447,6 @@ static void uwire_off(struct uwire_spi *uwire)
 {
 	uwire_write_reg(UWIRE_SR3, 0);
 	clk_disable(uwire->ck);
-	clk_put(uwire->ck);
 	spi_master_put(uwire->bitbang.master);
 }
 
@@ -463,7 +462,7 @@ static int uwire_probe(struct platform_device *pdev)
 
 	uwire = spi_master_get_devdata(master);
 
-	uwire_base = ioremap(UWIRE_BASE_PHYS, UWIRE_IO_SIZE);
+	uwire_base = devm_ioremap(&pdev->dev, UWIRE_BASE_PHYS, UWIRE_IO_SIZE);
 	if (!uwire_base) {
 		dev_dbg(&pdev->dev, "can't ioremap UWIRE\n");
 		spi_master_put(master);
@@ -472,12 +471,11 @@ static int uwire_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, uwire);
 
-	uwire->ck = clk_get(&pdev->dev, "fck");
+	uwire->ck = devm_clk_get(&pdev->dev, "fck");
 	if (IS_ERR(uwire->ck)) {
 		status = PTR_ERR(uwire->ck);
 		dev_dbg(&pdev->dev, "no functional clock?\n");
 		spi_master_put(master);
-		iounmap(uwire_base);
 		return status;
 	}
 	clk_enable(uwire->ck);
@@ -507,7 +505,6 @@ static int uwire_probe(struct platform_device *pdev)
 	status = spi_bitbang_start(&uwire->bitbang);
 	if (status < 0) {
 		uwire_off(uwire);
-		iounmap(uwire_base);
 	}
 	return status;
 }
@@ -520,7 +517,6 @@ static int uwire_remove(struct platform_device *pdev)
 
 	spi_bitbang_stop(&uwire->bitbang);
 	uwire_off(uwire);
-	iounmap(uwire_base);
 	return 0;
 }
 
-- 
1.9.1

