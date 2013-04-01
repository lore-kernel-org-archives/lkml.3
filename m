Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758294Ab3DARbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 13:31:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47076 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757356Ab3DAR2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 13:28:19 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 03/15] mfd: arizona: Basic support for edge triggered IRQs
Date: Mon,  1 Apr 2013 18:28:00 +0100
Message-Id: <1364837292-30191-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364837292-30191-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130401172748.GG18636@opensource.wolfsonmicro.com>
 <1364837292-30191-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the user to configure edge triggered IRQs, though we do not yet
fully handle new interrupts occurring while an interrupt is being handled.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 arch/arm/mach-s3c64xx/mach-crag6410-module.c |    4 ++--
 drivers/mfd/arizona-irq.c                    |   12 +++++++-----
 include/linux/mfd/arizona/pdata.h            |    3 ++-
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-s3c64xx/mach-crag6410-module.c b/arch/arm/mach-s3c64xx/mach-crag6410-module.c
index bf3d1c0..40b0e75 100644
--- a/arch/arm/mach-s3c64xx/mach-crag6410-module.c
+++ b/arch/arm/mach-s3c64xx/mach-crag6410-module.c
@@ -208,7 +208,7 @@ static const struct i2c_board_info wm1277_devs[] = {
 static struct arizona_pdata wm5102_reva_pdata = {
 	.ldoena = S3C64XX_GPN(7),
 	.gpio_base = CODEC_GPIO_BASE,
-	.irq_active_high = true,
+	.irq_flags = IRQF_TRIGGER_HIGH,
 	.micd_pol_gpio = CODEC_GPIO_BASE + 4,
 	.gpio_defaults = {
 		[2] = 0x10000, /* AIF3TXLRCLK */
@@ -237,7 +237,7 @@ static struct spi_board_info wm5102_reva_spi_devs[] = {
 static struct arizona_pdata wm5102_pdata = {
 	.ldoena = S3C64XX_GPN(7),
 	.gpio_base = CODEC_GPIO_BASE,
-	.irq_active_high = true,
+	.irq_flags = IRQF_TRIGGER_HIGH,
 	.micd_pol_gpio = CODEC_GPIO_BASE + 2,
 	.gpio_defaults = {
 		[2] = 0x10000, /* AIF3TXLRCLK */
diff --git a/drivers/mfd/arizona-irq.c b/drivers/mfd/arizona-irq.c
index 0aa39e2..aa25468 100644
--- a/drivers/mfd/arizona-irq.c
+++ b/drivers/mfd/arizona-irq.c
@@ -195,7 +195,11 @@ int arizona_irq_init(struct arizona *arizona)
 	/* Disable all wake sources by default */
 	regmap_write(arizona->regmap, ARIZONA_WAKE_CONTROL, 0);
 
-	if (arizona->pdata.irq_active_high) {
+	if (!arizona->pdata.irq_flags)
+		arizona->pdata.irq_flags = IRQF_TRIGGER_LOW;
+
+	if (arizona->pdata.irq_flags & (IRQF_TRIGGER_HIGH |
+					IRQF_TRIGGER_RISING)) {
 		ret = regmap_update_bits(arizona->regmap, ARIZONA_IRQ_CTRL_1,
 					 ARIZONA_IRQ_POL, 0);
 		if (ret != 0) {
@@ -203,12 +207,10 @@ int arizona_irq_init(struct arizona *arizona)
 				ret);
 			goto err;
 		}
-
-		flags |= IRQF_TRIGGER_HIGH;
-	} else {
-		flags |= IRQF_TRIGGER_LOW;
 	}
 
+	flags |= arizona->pdata.irq_flags;
+
 	/* Allocate a virtual IRQ domain to distribute to the regmap domains */
 	arizona->virq = irq_domain_add_linear(NULL, 2, &arizona_domain_ops,
 					      arizona);
diff --git a/include/linux/mfd/arizona/pdata.h b/include/linux/mfd/arizona/pdata.h
index 455c51d..84fefed 100644
--- a/include/linux/mfd/arizona/pdata.h
+++ b/include/linux/mfd/arizona/pdata.h
@@ -99,7 +99,8 @@ struct arizona_pdata {
 	/** If a direct 32kHz clock is provided on an MCLK specify it here */
 	int clk32k_src;
 
-	bool irq_active_high; /** IRQ polarity */
+	/** Mode for primary IRQ (defaults to active low) */
+	unsigned int irq_flags;
 
 	/* Base GPIO */
 	int gpio_base;
-- 
1.7.10.4

