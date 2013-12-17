Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab3LQNks (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 08:40:48 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33163 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753647Ab3LQNk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 08:40:29 -0500
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>
CC: <devicetree@vger.kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        <ijc+devicetree@hellion.org.uk>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <grygorii.strashko@ti.com>,
        <dwmw2@infradead.org>, <computersforpeace@gmail.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: [PATCH v4 9/9] mtd: nand: davinci: don't request AEMIF address range
Date: Tue, 17 Dec 2013 15:38:31 +0200
Message-ID: <1387287511-19975-1-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387285155-19182-1-git-send-email-ivan.khoronzhuk@ti.com>
References: <1387285155-19182-1-git-send-email-ivan.khoronzhuk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TI AEMIF driver registers are used to setup timings for each chip
select. The same registers range is used to setup NAND settings.
The AEMIF and NAND drivers not use the same registers in this range.

In case with TI AEMIF driver, the memory address range is requested
already by AEMIF, so we cannot request it twice, just ioremap.

Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>
Reviewed-by: Taras Kondratiuk <taras@ti.com>
Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
---
 drivers/mtd/nand/davinci_nand.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_nand.c
index 8a61a40..0104d26 100644
--- a/drivers/mtd/nand/davinci_nand.c
+++ b/drivers/mtd/nand/davinci_nand.c
@@ -637,9 +637,17 @@ static int nand_davinci_probe(struct platform_device *pdev)
 	if (IS_ERR(vaddr))
 		return PTR_ERR(vaddr);
 
-	base = devm_ioremap_resource(&pdev->dev, res2);
-	if (IS_ERR(base))
-		return PTR_ERR(base);
+	/*
+	 * This registers range is used to setup NAND settings. In case with
+	 * TI AEMIF driver, the same memory address range is requested already
+	 * by AEMIF, so we cannot request it twice, just ioremap.
+	 * The AEMIF and NAND drivers not use the same registers in this range.
+	 */
+	base = devm_ioremap(&pdev->dev, res2->start, resource_size(res2));
+	if (!base) {
+		dev_err(&pdev->dev, "ioremap failed for resource %pR\n", res2);
+		return -EADDRNOTAVAIL;
+	}
 
 	info->dev		= &pdev->dev;
 	info->base		= base;
-- 
1.7.9.5

