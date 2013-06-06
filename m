Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab3FFVMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 17:12:42 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4725 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab3FFVMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 17:12:40 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 06 Jun 2013 14:11:55 -0700
From: Andrew Chew <achew@nvidia.com>
To: <rklein@nvidia.com>, <cbou@mail.ru>, <dwmw2@infradead.org>
CC: <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <achew@nvidia.com>
Subject: [PATCH 1/1] tps65090-charger: Fix AC detect
Date: Thu, 6 Jun 2013 14:12:43 -0700
Message-ID: <1370553163-31804-1-git-send-email-achew@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The VACG interrupt was not being enabled.  Thus, interrupts were never
generated when AC status changes.  In addition, interrupts were never
cleared after taking and processing the interrupt.

Added the register offset for the INTR_MASK register, since this is needed
to unmask the VACG interrupt.

Enabled the VACG interrupt in tps65090_config_charger().

Cleared interrupts after processing, in tps65090_charger_isr().

Also removed unused variable "enable" in tps65090_enable_charging(),
and fixed a typo in one of the dev_err() prints.

Signed-off-by: Andrew Chew <achew@nvidia.com>
---
 drivers/power/tps65090-charger.c | 35 ++++++++++++++++++++++++++++++-----
 1 file changed, 30 insertions(+), 5 deletions(-)

diff --git a/drivers/power/tps65090-charger.c b/drivers/power/tps65090-charger.c
index 9fbca31..a09f8c4 100644
--- a/drivers/power/tps65090-charger.c
+++ b/drivers/power/tps65090-charger.c
@@ -27,6 +27,7 @@
 #include <linux/mfd/tps65090.h>
 
 #define TPS65090_REG_INTR_STS	0x00
+#define TPS65090_REG_INTR_MASK	0x02
 #define TPS65090_REG_CG_CTRL0	0x04
 #define TPS65090_REG_CG_CTRL1	0x05
 #define TPS65090_REG_CG_CTRL2	0x06
@@ -67,8 +68,7 @@ static int tps65090_low_chrg_current(struct tps65090_charger *charger)
 	return 0;
 }
 
-static int tps65090_enable_charging(struct tps65090_charger *charger,
-	uint8_t enable)
+static int tps65090_enable_charging(struct tps65090_charger *charger)
 {
 	int ret;
 	uint8_t ctrl0 = 0;
@@ -84,7 +84,7 @@ static int tps65090_enable_charging(struct tps65090_charger *charger,
 	ret = tps65090_write(charger->dev->parent, TPS65090_REG_CG_CTRL0,
 				(ctrl0 | TPS65090_CHARGER_ENABLE));
 	if (ret < 0) {
-		dev_err(charger->dev, "%s(): error reading in register 0x%x\n",
+		dev_err(charger->dev, "%s(): error writing in register 0x%x\n",
 				__func__, TPS65090_REG_CG_CTRL0);
 		return ret;
 	}
@@ -93,6 +93,7 @@ static int tps65090_enable_charging(struct tps65090_charger *charger,
 
 static int tps65090_config_charger(struct tps65090_charger *charger)
 {
+	uint8_t intrmask = 0;
 	int ret;
 
 	if (charger->pdata->enable_low_current_chrg) {
@@ -104,6 +105,23 @@ static int tps65090_config_charger(struct tps65090_charger *charger)
 		}
 	}
 
+	/* Enable the VACG interrupt for AC power detect */
+	ret = tps65090_read(charger->dev->parent, TPS65090_REG_INTR_MASK,
+			    &intrmask);
+	if (ret < 0) {
+		dev_err(charger->dev, "%s(): error reading in register 0x%x\n",
+			__func__, TPS65090_REG_INTR_MASK);
+		return ret;
+	}
+
+	ret = tps65090_write(charger->dev->parent, TPS65090_REG_INTR_MASK,
+			     (intrmask | TPS65090_VACG));
+	if (ret < 0) {
+		dev_err(charger->dev, "%s(): error writing in register 0x%x\n",
+			__func__, TPS65090_REG_CG_CTRL0);
+		return ret;
+	}
+
 	return 0;
 }
 
@@ -146,7 +164,7 @@ static irqreturn_t tps65090_charger_isr(int irq, void *dev_id)
 	}
 
 	if (intrsts & TPS65090_VACG) {
-		ret = tps65090_enable_charging(charger, 1);
+		ret = tps65090_enable_charging(charger);
 		if (ret < 0)
 			return IRQ_HANDLED;
 		charger->ac_online = 1;
@@ -154,6 +172,13 @@ static irqreturn_t tps65090_charger_isr(int irq, void *dev_id)
 		charger->ac_online = 0;
 	}
 
+	/* Clear interrupts. */
+	ret = tps65090_write(charger->dev->parent, TPS65090_REG_INTR_STS, 0x00);
+	if (ret < 0) {
+		dev_err(charger->dev, "%s(): Error in writing reg 0x%x\n",
+				__func__, TPS65090_REG_INTR_STS);
+	}
+
 	if (charger->prev_ac_online != charger->ac_online)
 		power_supply_changed(&charger->ac);
 
@@ -270,7 +295,7 @@ static int tps65090_charger_probe(struct platform_device *pdev)
 	}
 
 	if (status1 != 0) {
-		ret = tps65090_enable_charging(cdata, 1);
+		ret = tps65090_enable_charging(cdata);
 		if (ret < 0) {
 			dev_err(cdata->dev, "error enabling charger\n");
 			goto fail_free_irq;
-- 
1.8.1.5

