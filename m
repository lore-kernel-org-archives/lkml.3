Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819Ab3DARbQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 13:31:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47079 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757407Ab3DAR2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 13:28:19 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 05/15] mfd: arizona: Try to use interrupt flags from interrupt controller
Date: Mon,  1 Apr 2013 18:28:02 +0100
Message-Id: <1364837292-30191-5-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364837292-30191-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130401172748.GG18636@opensource.wolfsonmicro.com>
 <1364837292-30191-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If no irq_flags are passed in platform data then query the interrupt
controller for the trigger type and try to use that. This provides
default operation with a wider range of hardware and will be needed
for device tree support where the interrupt flags are configured on
the interrupt controller.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-irq.c |   27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/arizona-irq.c b/drivers/mfd/arizona-irq.c
index f761cc1..64cd9b6 100644
--- a/drivers/mfd/arizona-irq.c
+++ b/drivers/mfd/arizona-irq.c
@@ -189,6 +189,7 @@ int arizona_irq_init(struct arizona *arizona)
 	int ret, i;
 	const struct regmap_irq_chip *aod, *irq;
 	bool ctrlif_error = true;
+	struct irq_data *irq_data;
 
 	switch (arizona->type) {
 #ifdef CONFIG_MFD_WM5102
@@ -215,8 +216,30 @@ int arizona_irq_init(struct arizona *arizona)
 	/* Disable all wake sources by default */
 	regmap_write(arizona->regmap, ARIZONA_WAKE_CONTROL, 0);
 
-	if (!arizona->pdata.irq_flags)
-		arizona->pdata.irq_flags = IRQF_TRIGGER_LOW;
+	/* Read the flags from the interrupt controller if not specified */
+	if (!arizona->pdata.irq_flags) {
+		irq_data = irq_get_irq_data(arizona->irq);
+		if (!irq_data) {
+			dev_err(arizona->dev, "Invalid IRQ: %d\n",
+				arizona->irq);
+			return -EINVAL;
+		}
+
+		arizona->pdata.irq_flags = irqd_get_trigger_type(irq_data);
+		switch (arizona->pdata.irq_flags) {
+		case IRQF_TRIGGER_LOW:
+		case IRQF_TRIGGER_HIGH:
+		case IRQF_TRIGGER_RISING:
+		case IRQF_TRIGGER_FALLING:
+			break;
+
+		case IRQ_TYPE_NONE:
+		default:
+			/* Device default */
+			arizona->pdata.irq_flags = IRQF_TRIGGER_LOW;
+			break;
+		}
+	}
 
 	if (arizona->pdata.irq_flags & (IRQF_TRIGGER_HIGH |
 					IRQF_TRIGGER_RISING)) {
-- 
1.7.10.4

