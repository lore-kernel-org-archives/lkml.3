Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757805Ab3DAR2a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 13:28:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47088 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757163Ab3DAR2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 13:28:21 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 12/15] mfd: arizona: Factor out register polling
Date: Mon,  1 Apr 2013 18:28:09 +0100
Message-Id: <1364837292-30191-12-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364837292-30191-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130401172748.GG18636@opensource.wolfsonmicro.com>
 <1364837292-30191-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

Factor out the polling of the interrupt status register whilst we wait
for boot done to allow the polling to be reused in other situations.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c |   52 +++++++++++++++++++++++++-------------------
 1 file changed, 30 insertions(+), 22 deletions(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 4a8093d4..559129e 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -196,42 +196,50 @@ static irqreturn_t arizona_overclocked(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static int arizona_wait_for_boot(struct arizona *arizona)
+static int arizona_poll_reg(struct arizona *arizona,
+			    int timeout, unsigned int reg,
+			    unsigned int mask, unsigned int target)
 {
-	unsigned int reg;
+	unsigned int val = 0;
 	int ret, i;
 
-	/*
-	 * We can't use an interrupt as we need to runtime resume to do so,
-	 * we won't race with the interrupt handler as it'll be blocked on
-	 * runtime resume.
-	 */
-	for (i = 0; i < 5; i++) {
-		msleep(1);
-
-		ret = regmap_read(arizona->regmap,
-				  ARIZONA_INTERRUPT_RAW_STATUS_5, &reg);
+	for (i = 0; i < timeout; i++) {
+		ret = regmap_read(arizona->regmap, reg, &val);
 		if (ret != 0) {
-			dev_err(arizona->dev, "Failed to read boot state: %d\n",
-				ret);
+			dev_err(arizona->dev, "Failed to read reg %u: %d\n",
+				reg, ret);
 			continue;
 		}
 
-		if (reg & ARIZONA_BOOT_DONE_STS)
-			break;
+		if ((val & mask) == target)
+			return 0;
+
+		msleep(1);
 	}
 
-	if (reg & ARIZONA_BOOT_DONE_STS) {
+	dev_err(arizona->dev, "Polling reg %u timed out: %x\n", reg, val);
+	return -ETIMEDOUT;
+}
+
+static int arizona_wait_for_boot(struct arizona *arizona)
+{
+	int ret;
+
+	/*
+	 * We can't use an interrupt as we need to runtime resume to do so,
+	 * we won't race with the interrupt handler as it'll be blocked on
+	 * runtime resume.
+	 */
+	ret = arizona_poll_reg(arizona, 5, ARIZONA_INTERRUPT_RAW_STATUS_5,
+			       ARIZONA_BOOT_DONE_STS, ARIZONA_BOOT_DONE_STS);
+
+	if (!ret)
 		regmap_write(arizona->regmap, ARIZONA_INTERRUPT_STATUS_5,
 			     ARIZONA_BOOT_DONE_STS);
-	} else {
-		dev_err(arizona->dev, "Device boot timed out: %x\n", reg);
-		return -ETIMEDOUT;
-	}
 
 	pm_runtime_mark_last_busy(arizona->dev);
 
-	return 0;
+	return ret;
 }
 
 #ifdef CONFIG_PM_RUNTIME
-- 
1.7.10.4

