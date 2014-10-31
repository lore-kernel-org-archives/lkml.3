Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758916AbaJaMiQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 08:38:16 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:59710 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757649AbaJaMiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 08:38:15 -0400
From: Abhilash Kesavan <a.kesavan@samsung.com>
To: linux-iio@vger.kernel.org, jic23@kernel.org
Cc: cw00.choi@samsung.com, naveenkrishna.ch@gmail.com,
        kesavan.abhilash@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH] iio: adc: exynos_adc: Add support for ADCv3 on exynos7
Date: Fri, 31 Oct 2014 18:08:03 +0530
Message-Id: <1414759083-4555-1-git-send-email-a.kesavan@samsung.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ADC on exynos7 is quite similar to ADCv2. The differences are as
follows:
	- v3 has 8 input channels (10 in v2).
	- v3 does not include an ADC PHY control register.
	- Some ADC_CON2 register bits being used in v2 are listed as
	  reserved in v3. This results in a different init_hw function
	  for v3.

Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
---
- Based on Naveen's "iio: exynos-adc: use syscon instead of ioremap" patchset
http://comments.gmane.org/gmane.linux.kernel.iio/13943

 .../devicetree/bindings/arm/samsung/exynos-adc.txt |    2 ++
 drivers/iio/adc/exynos_adc.c                       |   32 ++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
index c368210..a11e32c 100644
--- a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
+++ b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
@@ -14,6 +14,8 @@ Required properties:
 				for exynos4412/5250 and s5pv210 controllers.
 			Must be "samsung,exynos-adc-v2" for
 				future controllers.
+			Must be "samsung,exynos-adc-v3" for
+				the ADC in Exynos7 and compatibles
 			Must be "samsung,exynos3250-adc" for
 				controllers compatible with ADC of Exynos3250.
 			Must be "samsung,s3c2410-adc" for
diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
index fe03177..74d0a9d 100644
--- a/drivers/iio/adc/exynos_adc.c
+++ b/drivers/iio/adc/exynos_adc.c
@@ -390,6 +390,35 @@ static const struct exynos_adc_data exynos3250_adc_data = {
 	.start_conv	= exynos_adc_v2_start_conv,
 };
 
+static void exynos_adc_v3_init_hw(struct exynos_adc *info)
+{
+	u32 con1, con2;
+
+	if (info->data->needs_adc_phy)
+		regmap_write(info->pmu_map, info->data->phy_offset, 1);
+
+	con1 = ADC_V2_CON1_SOFT_RESET;
+	writel(con1, ADC_V2_CON1(info->regs));
+
+	con2 = readl(ADC_V2_CON2(info->regs));
+	con2 &= ~ADC_V2_CON2_C_TIME(7);
+	con2 |= ADC_V2_CON2_C_TIME(0);
+	writel(con2, ADC_V2_CON2(info->regs));
+
+	/* Enable interrupts */
+	writel(1, ADC_V2_INT_EN(info->regs));
+}
+
+static const struct exynos_adc_data exynos_adc_v3_data = {
+	.num_channels	= MAX_ADC_V1_CHANNELS,
+	.mask		= ADC_DATX_MASK, /* 12 bit ADC resolution */
+
+	.init_hw	= exynos_adc_v3_init_hw,
+	.exit_hw	= exynos_adc_v2_exit_hw,
+	.clear_irq	= exynos_adc_v2_clear_irq,
+	.start_conv	= exynos_adc_v2_start_conv,
+};
+
 static const struct of_device_id exynos_adc_match[] = {
 	{
 		.compatible = "samsung,s3c2410-adc",
@@ -413,6 +442,9 @@ static const struct of_device_id exynos_adc_match[] = {
 		.compatible = "samsung,exynos-adc-v2",
 		.data = &exynos_adc_v2_data,
 	}, {
+		.compatible = "samsung,exynos-adc-v3",
+		.data = &exynos_adc_v3_data,
+	}, {
 		.compatible = "samsung,exynos3250-adc",
 		.data = &exynos3250_adc_data,
 	},
-- 
1.7.9.5

