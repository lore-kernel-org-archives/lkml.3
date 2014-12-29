Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbaL2Ler (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 06:34:47 -0500
Received: from www.osadl.org ([62.245.132.105]:43781 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310AbaL2Lek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 06:34:40 -0500
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH] mtd: fsmc_nand: fix handling of wait_for_completion_timeout result
Date: Mon, 29 Dec 2014 06:30:51 -0500
Message-Id: <1419852651-4706-1-git-send-email-der.herr@hofr.at>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wait_for_completion_timeout does not return negative values so
"result" handling here should be simplified to cover the actually
possible cases only.

patch was only compile tested for nhk8815_defconfig

patch is against linux-next 3.19.0-rc1 -next-20141226

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---
 drivers/mtd/nand/fsmc_nand.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/nand/fsmc_nand.c b/drivers/mtd/nand/fsmc_nand.c
index edfaa21..7c0508f 100644
--- a/drivers/mtd/nand/fsmc_nand.c
+++ b/drivers/mtd/nand/fsmc_nand.c
@@ -604,11 +604,10 @@ static int dma_xfer(struct fsmc_nand_data *host, void *buffer, int len,
 	ret =
 	wait_for_completion_timeout(&host->dma_access_complete,
 				msecs_to_jiffies(3000));
-	if (ret <= 0) {
+	if (ret == 0) {
 		dmaengine_terminate_all(chan);
 		dev_err(host->dev, "wait_for_completion_timeout\n");
-		if (!ret)
-			ret = -ETIMEDOUT;
+		ret = -ETIMEDOUT;
 		goto unmap_dma;
 	}
 
-- 
1.7.10.4

