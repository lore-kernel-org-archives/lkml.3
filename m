Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631Ab3DARa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 13:30:27 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47078 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757468Ab3DAR2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 13:28:20 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 08/15] mfd: arizona: Fully support the use of MCLK1 as the 32kHz clock source
Date: Mon,  1 Apr 2013 18:28:05 +0100
Message-Id: <1364837292-30191-8-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364837292-30191-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130401172748.GG18636@opensource.wolfsonmicro.com>
 <1364837292-30191-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MCLK1 is not in the AoD power domain so if it is used as the 32kHz clock
source we need to hold a runtime PM reference to keep the device from going
into low power mode.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index c9df7be..f8ffc3e 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -39,11 +39,21 @@ int arizona_clk32k_enable(struct arizona *arizona)
 
 	arizona->clk32k_ref++;
 
-	if (arizona->clk32k_ref == 1)
+	if (arizona->clk32k_ref == 1) {
+		switch (arizona->pdata.clk32k_src) {
+		case ARIZONA_32KZ_MCLK1:
+			ret = pm_runtime_get_sync(arizona->dev);
+			if (ret != 0)
+				goto out;
+			break;
+		}
+
 		ret = regmap_update_bits(arizona->regmap, ARIZONA_CLOCK_32K_1,
 					 ARIZONA_CLK_32K_ENA,
 					 ARIZONA_CLK_32K_ENA);
+	}
 
+out:
 	if (ret != 0)
 		arizona->clk32k_ref--;
 
@@ -63,10 +73,17 @@ int arizona_clk32k_disable(struct arizona *arizona)
 
 	arizona->clk32k_ref--;
 
-	if (arizona->clk32k_ref == 0)
+	if (arizona->clk32k_ref == 0) {
 		regmap_update_bits(arizona->regmap, ARIZONA_CLOCK_32K_1,
 				   ARIZONA_CLK_32K_ENA, 0);
 
+		switch (arizona->pdata.clk32k_src) {
+		case ARIZONA_32KZ_MCLK1:
+			pm_runtime_put_sync(arizona->dev);
+			break;
+		}
+	}
+
 	mutex_unlock(&arizona->clk_lock);
 
 	return ret;
-- 
1.7.10.4

