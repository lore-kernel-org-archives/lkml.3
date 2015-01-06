Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbbAFNX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 08:23:57 -0500
Received: from mga03.intel.com ([134.134.136.65]:38136 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbbAFNXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 08:23:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,708,1413270000"; 
   d="scan'208";a="646993284"
From: Laurentiu Palcu <laurentiu.palcu@intel.com>
To: Mark Brown <broonie@kernel.org>
Cc: Julia Lawall <julia.lawall@lip6.fr>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Laurentiu Palcu <laurentiu.palcu@intel.com>
Subject: [PATCH] spi/dln2: simplify return flow for dln2_spi_transfer_setup and dln2_spi_enable
Date: Tue,  6 Jan 2015 15:23:40 +0200
Message-Id: <1420550620-12693-1-git-send-email-laurentiu.palcu@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following kbuild test robot warnings:

>> drivers/spi/spi-dln2.c:124:1-4: WARNING: end returns can be simplified if negative or 0 value
>> drivers/spi/spi-dln2.c:656:1-4: WARNING: end returns can be simplified if negative or 0 value

Additionally, fix a comment after switching from CONFIG_PM_RUNTIME to
CONFIG_PM.

Reported-by: Julia Lawall <julia.lawall@lip6.fr>
Signed-off-by: Laurentiu Palcu <laurentiu.palcu@intel.com>
---
 drivers/spi/spi-dln2.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/spi/spi-dln2.c b/drivers/spi/spi-dln2.c
index cede063..3b7d91d 100644
--- a/drivers/spi/spi-dln2.c
+++ b/drivers/spi/spi-dln2.c
@@ -103,7 +103,6 @@ struct dln2_spi {
  */
 static int dln2_spi_enable(struct dln2_spi *dln2, bool enable)
 {
-	int ret;
 	u16 cmd;
 	struct {
 		u8 port;
@@ -121,11 +120,7 @@ static int dln2_spi_enable(struct dln2_spi *dln2, bool enable)
 		cmd = DLN2_SPI_DISABLE;
 	}
 
-	ret = dln2_transfer_tx(dln2->pdev, cmd, &tx, len);
-	if (ret < 0)
-		return ret;
-
-	return 0;
+	return dln2_transfer_tx(dln2->pdev, cmd, &tx, len);
 }
 
 /*
@@ -653,11 +648,7 @@ static int dln2_spi_transfer_setup(struct dln2_spi *dln2, u32 speed,
 		dln2->bpw = bpw;
 	}
 
-	ret = dln2_spi_enable(dln2, true);
-	if (ret < 0)
-		return ret;
-
-	return 0;
+	return dln2_spi_enable(dln2, true);
 }
 
 static int dln2_spi_transfer_one(struct spi_master *master,
@@ -866,7 +857,7 @@ static int dln2_spi_runtime_resume(struct device *dev)
 
 	return  dln2_spi_enable(dln2, true);
 }
-#endif /* CONFIG_PM_RUNTIME */
+#endif /* CONFIG_PM */
 
 static const struct dev_pm_ops dln2_spi_pm = {
 	SET_SYSTEM_SLEEP_PM_OPS(dln2_spi_suspend, dln2_spi_resume)
-- 
1.9.1

