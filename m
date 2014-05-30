Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933047AbaE3KHz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 06:07:55 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:43352 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932997AbaE3KHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 06:07:53 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, sameo@linux.intel.com, sachin.kamat@linaro.org
Subject: [PATCH 1/1] mfd: asic3: Fix potential null pointer dereference
Date: Fri, 30 May 2014 15:35:28 +0530
Message-Id: <1401444328-10746-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We previously assumed 'mem_sdio' could be null but it is
dereferenced in ioremap(). Add a check to avoid a potential
null pointer dereference error.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/mfd/asic3.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index 9f6294f2a070..9fc4186d4132 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -899,13 +899,15 @@ static int __init asic3_mfd_probe(struct platform_device *pdev,
 	ds1wm_resources[0].end   >>= asic->bus_shift;
 
 	/* MMC */
-	asic->tmio_cnf = ioremap((ASIC3_SD_CONFIG_BASE >> asic->bus_shift) +
+	if (mem_sdio) {
+		asic->tmio_cnf = ioremap((ASIC3_SD_CONFIG_BASE >> asic->bus_shift) +
 				 mem_sdio->start,
 				 ASIC3_SD_CONFIG_SIZE >> asic->bus_shift);
-	if (!asic->tmio_cnf) {
-		ret = -ENOMEM;
-		dev_dbg(asic->dev, "Couldn't ioremap SD_CONFIG\n");
-		goto out;
+		if (!asic->tmio_cnf) {
+			ret = -ENOMEM;
+			dev_dbg(asic->dev, "Couldn't ioremap SD_CONFIG\n");
+			goto out;
+		}
 	}
 	asic3_mmc_resources[0].start >>= asic->bus_shift;
 	asic3_mmc_resources[0].end   >>= asic->bus_shift;
-- 
1.7.9.5

