Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758211AbaGCNYQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:24:16 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:51012 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895AbaGCNXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:23:12 -0400
From: Manuel Lauss <manuel.lauss@gmail.com>
To: Linux-MIPS <linux-mips@linux-mips.org>,
        Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, Manuel Lauss <manuel.lauss@gmail.com>
Subject: [RFC PATCH v2 10/11] MIPS: Alchemy: au1xmmc: use clk framework
Date: Thu,  3 Jul 2014 15:22:41 +0200
Message-Id: <1404393762-858019-11-git-send-email-manuel.lauss@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404393762-858019-1-git-send-email-manuel.lauss@gmail.com>
References: <1404393762-858019-1-git-send-email-manuel.lauss@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the clock framework to get the peripheral clock rate to
correctly set the MMC/SD bus clock divider.

Signed-off-by: Manuel Lauss <manuel.lauss@gmail.com>
---
 drivers/mmc/host/au1xmmc.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/mmc/host/au1xmmc.c b/drivers/mmc/host/au1xmmc.c
index 1837309..0c0ed16 100644
--- a/drivers/mmc/host/au1xmmc.c
+++ b/drivers/mmc/host/au1xmmc.c
@@ -32,6 +32,7 @@
  * (the low to high transition will not occur).
  */
 
+#include <linux/clk.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
@@ -118,6 +119,7 @@ struct au1xmmc_host {
 	struct au1xmmc_platform_data *platdata;
 	struct platform_device *pdev;
 	struct resource *ioarea;
+	struct clk *clk;
 };
 
 /* Status flags used by the host structure */
@@ -596,17 +598,10 @@ static void au1xmmc_cmd_complete(struct au1xmmc_host *host, u32 status)
 
 static void au1xmmc_set_clock(struct au1xmmc_host *host, int rate)
 {
-	unsigned int pbus = get_au1x00_speed();
-	unsigned int divisor;
+	unsigned int pbus = clk_get_rate(host->clk);
+	unsigned int divisor = ((pbus / rate) / 2) - 1;
 	u32 config;
 
-	/* From databook:
-	 * divisor = ((((cpuclock / sbus_divisor) / 2) / mmcclock) / 2) - 1
-	 */
-	pbus /= ((AU1X_RDSYS(AU1000_SYS_POWERCTRL) & 0x3) + 2);
-	pbus /= 2;
-	divisor = ((pbus / rate) / 2) - 1;
-
 	config = __raw_readl(HOST_CONFIG(host));
 
 	config &= ~(SD_CONFIG_DIV);
@@ -1029,6 +1024,16 @@ static int au1xmmc_probe(struct platform_device *pdev)
 		goto out3;
 	}
 
+	host->clk = clk_get(&pdev->dev, ALCHEMY_PERIPH_CLK);
+	if (IS_ERR(host->clk)) {
+		dev_err(&pdev->dev, "cannot find clock\n");
+		goto out_irq;
+	}
+	if (clk_prepare_enable(host->clk)) {
+		dev_err(&pdev->dev, "cannot enable clock\n");
+		goto out_clk;
+	}
+
 	host->status = HOST_S_IDLE;
 
 	/* board-specific carddetect setup, if any */
@@ -1105,7 +1110,10 @@ out5:
 	if (host->platdata && host->platdata->cd_setup &&
 	    !(mmc->caps & MMC_CAP_NEEDS_POLL))
 		host->platdata->cd_setup(mmc, 0);
-
+out_clk:
+	clk_disable_unprepare(host->clk);
+	clk_put(host->clk);
+out_irq:
 	free_irq(host->irq, host);
 out3:
 	iounmap((void *)host->iobase);
@@ -1147,6 +1155,9 @@ static int au1xmmc_remove(struct platform_device *pdev)
 
 		au1xmmc_set_power(host, 0);
 
+		clk_disable_unprepare(host->clk);
+		clk_put(host->clk);
+
 		free_irq(host->irq, host);
 		iounmap((void *)host->iobase);
 		release_resource(host->ioarea);
-- 
2.0.0

