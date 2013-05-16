Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab3EPFLf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 01:11:35 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:51832 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955Ab3EPFLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 01:11:34 -0400
MIME-Version: 1.0
Date: Thu, 16 May 2013 13:11:32 +0800
Message-ID: <CAPgLHd93xOKX3ot+RUP5FXM_Nz6xZD-ODU_=ZEebBEJm=OM76g@mail.gmail.com>
Subject: [PATCH] spi: coldfire-qspi: fix error return code in mcfqspi_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: broonie@kernel.org, grant.likely@linaro.org
Cc: yongjun_wei@trendmicro.com.cn, spi-devel-general@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

If pdev->dev.platform_data is not set, mcfqspi_probe() will return 0
and release all the resources, in this case, we should return a error
code instead of 0.
This patch fix to return -ENOENT in this case and move the check for
pdev->dev.platform_data to the begin of this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/spi/spi-coldfire-qspi.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spi-coldfire-qspi.c b/drivers/spi/spi-coldfire-qspi.c
index 3f17660..f2acb90 100644
--- a/drivers/spi/spi-coldfire-qspi.c
+++ b/drivers/spi/spi-coldfire-qspi.c
@@ -408,6 +408,12 @@ static int mcfqspi_probe(struct platform_device *pdev)
 	struct mcfqspi_platform_data *pdata;
 	int status;
 
+	pdata = pdev->dev.platform_data;
+	if (!pdata) {
+		dev_dbg(&pdev->dev, "platform data is missing\n");
+		return -ENOENT;
+	}
+
 	master = spi_alloc_master(&pdev->dev, sizeof(*mcfqspi));
 	if (master == NULL) {
 		dev_dbg(&pdev->dev, "spi_alloc_master failed\n");
@@ -458,11 +464,6 @@ static int mcfqspi_probe(struct platform_device *pdev)
 	}
 	clk_enable(mcfqspi->clk);
 
-	pdata = pdev->dev.platform_data;
-	if (!pdata) {
-		dev_dbg(&pdev->dev, "platform data is missing\n");
-		goto fail4;
-	}
 	master->bus_num = pdata->bus_num;
 	master->num_chipselect = pdata->num_chipselect;
 

