Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762935Ab3DDQRf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 12:17:35 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:54238 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762887Ab3DDQRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 12:17:33 -0400
X-AuditID: cbfee61b-b7f076d0000034b6-6a-515da79c22c3
From: Tomasz Figa <t.figa@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-samsung-soc@vger.kernel.org,
        kyungmin.park@samsung.com, lrg@ti.com,
        broonie@opensource.wolfsonmicro.com, myungjoo.ham@samsung.com,
        kgene.kim@samsung.com, Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH 1/2] regulator: max8952: Separate constraints from platform
 data struct
Date: Thu, 04 Apr 2013 18:17:19 +0200
Message-id: <1365092240-8956-2-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1365092240-8956-1-git-send-email-t.figa@samsung.com>
References: <1365092240-8956-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNLMWRmVeSWpSXmKPExsVy+t9jAd05y2MDDc7O0bf4N/sUm8WB2Q9Z
	LXoXXGWzONv0ht3i8q45bBYzzu9jsmjaPoHd4nbjCjaL9TNeszhwepyfsZDR4+XE32wefVtW
	MXocv7GdyePzJrkA1igum5TUnMyy1CJ9uwSujL8tu1gK3klU3N24krmB8ZZIFyMHh4SAiUTj
	HJkuRk4gU0ziwr31bF2MXBxCAosYJf49usYK4XQxSSz+uJEVpIpNQE3ic8MjNhBbREBBYnPv
	M7AiZoH3jBK3bvUxgkwVFoiUuHiLE8RkEVCV2Lw8BaScV8BR4sbGGcwQy+Qlnt7vAxvDKeAk
	cXXLEVaQciGgmq/Pqycw8i5gZFjFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERxkz6R3MK5q
	sDjEKMDBqMTDm9EXGyjEmlhWXJl7iFGCg1lJhPdoC1CINyWxsiq1KD++qDQntfgQozQHi5I4
	78FW60AhgfTEktTs1NSC1CKYLBMHp1QDo8c91rC9K/kqpG65ld6qv2/9J/GsYcCBq4d0fJzv
	fDCpv7nnFOtez/7EnqchumJb28TsokLWu1W2vZ7qc37VigkM0/gu7ixTf1J07pLk1+qD5oH8
	Z1dJLz5mfuaxD7u31B5ui3I2i9Vf/4nmRUm+ftvBU2lxeOEGgby5v5bOPXdJYGbKicuc/5VY
	ijMSDbWYi4oTAZO35wouAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies platform data structure of max8952 driver to
use pointer to regulator_init_data struct instead of embedding it.

This is a prerequisite for adding Device Tree support for the driver.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos/mach-universal_c210.c | 27 ++++++++++++++-------------
 drivers/regulator/max8952.c                |  4 ++--
 include/linux/regulator/max8952.h          |  2 +-
 3 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/arch/arm/mach-exynos/mach-universal_c210.c b/arch/arm/mach-exynos/mach-universal_c210.c
index 366abb3..c876b5b 100644
--- a/arch/arm/mach-exynos/mach-universal_c210.c
+++ b/arch/arm/mach-exynos/mach-universal_c210.c
@@ -97,6 +97,19 @@ static struct s3c2410_uartcfg universal_uartcfgs[] __initdata = {
 static struct regulator_consumer_supply max8952_consumer =
 	REGULATOR_SUPPLY("vdd_arm", NULL);
 
+static struct regulator_init_data universal_max8952_reg_data = {
+	.constraints	= {
+		.name		= "VARM_1.2V",
+		.min_uV		= 770000,
+		.max_uV		= 1400000,
+		.valid_ops_mask	= REGULATOR_CHANGE_VOLTAGE,
+		.always_on	= 1,
+		.boot_on	= 1,
+	},
+	.num_consumer_supplies	= 1,
+	.consumer_supplies	= &max8952_consumer,
+};
+
 static struct max8952_platform_data universal_max8952_pdata __initdata = {
 	.gpio_vid0	= EXYNOS4_GPX0(3),
 	.gpio_vid1	= EXYNOS4_GPX0(4),
@@ -105,19 +118,7 @@ static struct max8952_platform_data universal_max8952_pdata __initdata = {
 	.dvs_mode	= { 48, 32, 28, 18 }, /* 1.25, 1.20, 1.05, 0.95V */
 	.sync_freq	= 0, /* default: fastest */
 	.ramp_speed	= 0, /* default: fastest */
-
-	.reg_data	= {
-		.constraints	= {
-			.name		= "VARM_1.2V",
-			.min_uV		= 770000,
-			.max_uV		= 1400000,
-			.valid_ops_mask	= REGULATOR_CHANGE_VOLTAGE,
-			.always_on	= 1,
-			.boot_on	= 1,
-		},
-		.num_consumer_supplies	= 1,
-		.consumer_supplies	= &max8952_consumer,
-	},
+	.reg_data	= &universal_max8952_reg_data,
 };
 
 static struct regulator_consumer_supply lp3974_buck1_consumer =
diff --git a/drivers/regulator/max8952.c b/drivers/regulator/max8952.c
index fc7935a..100b917 100644
--- a/drivers/regulator/max8952.c
+++ b/drivers/regulator/max8952.c
@@ -154,11 +154,11 @@ static int max8952_pmic_probe(struct i2c_client *client,
 	max8952->pdata = pdata;
 
 	config.dev = max8952->dev;
-	config.init_data = &pdata->reg_data;
+	config.init_data = pdata->reg_data;
 	config.driver_data = max8952;
 
 	config.ena_gpio = pdata->gpio_en;
-	if (pdata->reg_data.constraints.boot_on)
+	if (pdata->reg_data->constraints.boot_on)
 		config.ena_gpio_flags |= GPIOF_OUT_INIT_HIGH;
 
 	max8952->rdev = regulator_register(&regulator, &config);
diff --git a/include/linux/regulator/max8952.h b/include/linux/regulator/max8952.h
index 45e4285..c13aa34 100644
--- a/include/linux/regulator/max8952.h
+++ b/include/linux/regulator/max8952.h
@@ -128,7 +128,7 @@ struct max8952_platform_data {
 	u8 sync_freq;
 	u8 ramp_speed;
 
-	struct regulator_init_data reg_data;
+	struct regulator_init_data *reg_data;
 };
 
 
-- 
1.8.1.5

