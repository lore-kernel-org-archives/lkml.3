Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933476AbaKMPGN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 10:06:13 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:43018 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933457AbaKMPGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 10:06:08 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-07-5464c8de811f
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH v2 23/33] thermal: exynos: add ->tmu_set_emulation method
Date: Thu, 13 Nov 2014 16:01:18 +0100
Message-id: <1415890888-8881-24-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
References: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t9jQd17J1JCDHZ8krZouBpisXHGelaL
	+VeusVqcbXrDbvHm4WZGi8u75rBZfO49wmgx4/w+JosnD/vYHDg9ds66y+6xeM9LJo++LasY
	PT5vkgtgieKySUnNySxLLdK3S+DKOLfyGmNBi3HFsQ2bGRsYu7S7GDk5JARMJA6s+80EYYtJ
	XLi3nq2LkYtDSGA6o8TS7pPMIAkhgS4midXtWiA2m4CVxMT2VYwgtoiAlsSJS9uZQBqYBZYx
	SVz6Nh9skrCAp8S2/YdYQGwWAVWJ0y/Os4PYvAIeEruOLWeD2KYo0f1sApjNCRR/NfUvI8Qy
	d4lrj94xT2DkXcDIsIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOLyeSe9gXNVgcYhRgINR
	iYf3BUtKiBBrYllxZe4hRgkOZiURXu/DQCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8B1utA4UE
	0hNLUrNTUwtSi2CyTBycUg2MMZOqj0bZ7JWYaL4m4Mob9x1Kvh2vni1rN7BWO/tVLqLyfN5y
	i9ONcl8awiXT9/ho9+5/8yl3yz+/D5uvP515g6lded+moKwVTuxPkr/926K1+sxeFz4xRTVu
	Fd+ld7O9/x7QYGRJjI6U2bF7Le/ClMcBFQd2R0bN2vsrveBnJfeT1brh/JGTlFiKMxINtZiL
	ihMBBh7Z/CsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ->tmu_set_emulation method to struct exynos_tmu_data and
use it in exynos_tmu_set_emulation().  Then add ->tmu_set_emulation
implementations for Exynos4412+ and Exynos5440.  Finally remove
no longer needed reg->emul_con abstraction.

There should be no functional changes caused by this patch.

Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c      | 41 +++++++++++++++++++++++++------
 drivers/thermal/samsung/exynos_tmu.h      |  2 --
 drivers/thermal/samsung/exynos_tmu_data.c |  5 ----
 3 files changed, 34 insertions(+), 14 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 1b622ce..01aa548 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -55,6 +55,7 @@
  * @tmu_initialize: SoC specific TMU initialization method
  * @tmu_control: SoC specific TMU control method
  * @tmu_read: SoC specific TMU temperature read method
+ * @tmu_set_emulation: SoC specific TMU emulation setting method
  */
 struct exynos_tmu_data {
 	int id;
@@ -72,6 +73,8 @@ struct exynos_tmu_data {
 	int (*tmu_initialize)(struct platform_device *pdev);
 	void (*tmu_control)(struct platform_device *pdev, bool on);
 	int (*tmu_read)(struct exynos_tmu_data *data);
+	void (*tmu_set_emulation)(struct exynos_tmu_data *data,
+				  unsigned long temp);
 };
 
 /*
@@ -460,12 +463,36 @@ static u32 get_emul_con_reg(struct exynos_tmu_data *data, unsigned int val,
 	return val;
 }
 
+static void exynos4412_tmu_set_emulation(struct exynos_tmu_data *data,
+					 unsigned long temp)
+{
+	unsigned int val;
+	u32 emul_con;
+
+	if (data->soc == SOC_ARCH_EXYNOS5260)
+		emul_con = EXYNOS5260_EMUL_CON;
+	else
+		emul_con = EXYNOS_EMUL_CON;
+
+	val = readl(data->base + emul_con);
+	val = get_emul_con_reg(data, val, temp);
+	writel(val, data->base + emul_con);
+}
+
+static void exynos5440_tmu_set_emulation(struct exynos_tmu_data *data,
+					 unsigned long temp)
+{
+	unsigned int val;
+
+	val = readl(data->base + EXYNOS5440_TMU_S0_7_DEBUG);
+	val = get_emul_con_reg(data, val, temp);
+	writel(val, data->base + EXYNOS5440_TMU_S0_7_DEBUG);
+}
+
 static int exynos_tmu_set_emulation(void *drv_data, unsigned long temp)
 {
 	struct exynos_tmu_data *data = drv_data;
 	struct exynos_tmu_platform_data *pdata = data->pdata;
-	const struct exynos_tmu_registers *reg = pdata->registers;
-	unsigned int val;
 	int ret = -EINVAL;
 
 	if (!TMU_SUPPORTS(pdata, EMULATION))
@@ -476,11 +503,7 @@ static int exynos_tmu_set_emulation(void *drv_data, unsigned long temp)
 
 	mutex_lock(&data->lock);
 	clk_enable(data->clk);
-
-	val = readl(data->base + reg->emul_con);
-	val = get_emul_con_reg(data, val, temp);
-	writel(val, data->base + reg->emul_con);
-
+	data->tmu_set_emulation(data, temp);
 	clk_disable(data->clk);
 	mutex_unlock(&data->lock);
 	return 0;
@@ -488,6 +511,8 @@ out:
 	return ret;
 }
 #else
+#define exynos4412_tmu_set_emulation NULL
+#define exynos5440_tmu_set_emulation NULL
 static int exynos_tmu_set_emulation(void *drv_data,	unsigned long temp)
 	{ return -EINVAL; }
 #endif/*CONFIG_THERMAL_EMULATION*/
@@ -745,11 +770,13 @@ static int exynos_tmu_probe(struct platform_device *pdev)
 		data->tmu_initialize = exynos4412_tmu_initialize;
 		data->tmu_control = exynos4210_tmu_control;
 		data->tmu_read = exynos4412_tmu_read;
+		data->tmu_set_emulation = exynos4412_tmu_set_emulation;
 		break;
 	case SOC_ARCH_EXYNOS5440:
 		data->tmu_initialize = exynos5440_tmu_initialize;
 		data->tmu_control = exynos5440_tmu_control;
 		data->tmu_read = exynos5440_tmu_read;
+		data->tmu_set_emulation = exynos5440_tmu_set_emulation;
 		break;
 	default:
 		ret = -EINVAL;
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index 9460e6e..785eccf 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -72,12 +72,10 @@ enum soc_type {
  * The register validity may vary slightly across different exynos SOC's.
  * @tmu_intstat: Register containing the interrupt status values.
  * @tmu_intclear: Register for clearing the raised interrupt status.
- * @emul_con: TMU emulation controller register.
  */
 struct exynos_tmu_registers {
 	u32	tmu_intstat;
 	u32	tmu_intclear;
-	u32	emul_con;
 };
 
 /**
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index 769b89d..d0bb4b3 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -75,7 +75,6 @@ struct exynos_tmu_init_data const exynos4210_default_tmu_data = {
 static const struct exynos_tmu_registers exynos3250_tmu_registers = {
 	.tmu_intstat = EXYNOS_TMU_REG_INTSTAT,
 	.tmu_intclear = EXYNOS_TMU_REG_INTCLEAR,
-	.emul_con = EXYNOS_EMUL_CON,
 };
 
 #define EXYNOS3250_TMU_DATA \
@@ -135,7 +134,6 @@ struct exynos_tmu_init_data const exynos3250_default_tmu_data = {
 static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 	.tmu_intstat = EXYNOS_TMU_REG_INTSTAT,
 	.tmu_intclear = EXYNOS_TMU_REG_INTCLEAR,
-	.emul_con = EXYNOS_EMUL_CON,
 };
 
 #define EXYNOS4412_TMU_DATA \
@@ -207,7 +205,6 @@ struct exynos_tmu_init_data const exynos5250_default_tmu_data = {
 static const struct exynos_tmu_registers exynos5260_tmu_registers = {
 	.tmu_intstat = EXYNOS5260_TMU_REG_INTSTAT,
 	.tmu_intclear = EXYNOS5260_TMU_REG_INTCLEAR,
-	.emul_con = EXYNOS5260_EMUL_CON,
 };
 
 #define __EXYNOS5260_TMU_DATA	\
@@ -269,7 +266,6 @@ struct exynos_tmu_init_data const exynos5260_default_tmu_data = {
 static const struct exynos_tmu_registers exynos5420_tmu_registers = {
 	.tmu_intstat = EXYNOS_TMU_REG_INTSTAT,
 	.tmu_intclear = EXYNOS_TMU_REG_INTCLEAR,
-	.emul_con = EXYNOS_EMUL_CON,
 };
 
 #define __EXYNOS5420_TMU_DATA	\
@@ -337,7 +333,6 @@ struct exynos_tmu_init_data const exynos5420_default_tmu_data = {
 static const struct exynos_tmu_registers exynos5440_tmu_registers = {
 	.tmu_intstat = EXYNOS5440_TMU_S0_7_IRQ,
 	.tmu_intclear = EXYNOS5440_TMU_S0_7_IRQ,
-	.emul_con = EXYNOS5440_TMU_S0_7_DEBUG,
 };
 
 #define EXYNOS5440_TMU_DATA \
-- 
1.8.2.3

