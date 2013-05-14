Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134Ab3ENKA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 06:00:26 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:33692 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111Ab3ENKAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 06:00:20 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org
Cc: Zhang Rui <rui.zhang@intel.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, amit.kachhap@gmail.com,
        Kukjin Kim <kgene.kim@samsung.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH V4 12/30] thermal: exynos: Fix to clear only the generated interrupts
Date: Tue, 14 May 2013 15:28:42 +0530
Message-Id: <1368525540-15034-13-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1368525540-15034-1-git-send-email-amit.daniel@samsung.com>
References: <1368525540-15034-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses the TMU status register to know the generated interrupts
and only clear them in the interrupt handler.

Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c      |   11 +++++------
 drivers/thermal/samsung/exynos_tmu_data.c |    2 ++
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 3ad97ff..41e0bf9 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -321,17 +321,16 @@ static void exynos_tmu_work(struct work_struct *work)
 			struct exynos_tmu_data, irq_work);
 	struct exynos_tmu_platform_data *pdata = data->pdata;
 	const struct exynos_tmu_registers *reg = pdata->registers;
+	unsigned int val_irq;
 
 	exynos_report_trigger();
 	mutex_lock(&data->lock);
 	clk_enable(data->clk);
 
-	if (data->soc == SOC_ARCH_EXYNOS)
-		writel((reg->inten_rise_mask << reg->inten_rise_shift) |
-			(reg->inten_fall_mask << reg->inten_fall_shift),
-				data->base + reg->tmu_intclear);
-	else
-		writel(reg->inten_rise_mask, data->base + reg->tmu_intclear);
+	/* TODO: take action based on particular interrupt */
+	val_irq = readl(data->base + reg->tmu_intstat);
+	/* clear the interrupts */
+	writel(val_irq, data->base + reg->tmu_intclear);
 
 	clk_disable(data->clk);
 	mutex_unlock(&data->lock);
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index bdefd14..bf01210 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -45,6 +45,7 @@ static const struct exynos_tmu_registers exynos4210_tmu_registers = {
 	.inten_rise1_shift = EXYNOS_TMU_INTEN_RISE1_SHIFT,
 	.inten_rise2_shift = EXYNOS_TMU_INTEN_RISE2_SHIFT,
 	.inten_rise3_shift = EXYNOS_TMU_INTEN_RISE3_SHIFT,
+	.tmu_intstat = EXYNOS_TMU_REG_INTSTAT,
 	.tmu_intclear = EXYNOS_TMU_REG_INTCLEAR,
 };
 struct exynos_tmu_platform_data const exynos4210_default_tmu_data = {
@@ -111,6 +112,7 @@ static const struct exynos_tmu_registers exynos5250_tmu_registers = {
 	.inten_rise2_shift = EXYNOS_TMU_INTEN_RISE2_SHIFT,
 	.inten_rise3_shift = EXYNOS_TMU_INTEN_RISE3_SHIFT,
 	.inten_fall0_shift = EXYNOS_TMU_INTEN_FALL0_SHIFT,
+	.tmu_intstat = EXYNOS_TMU_REG_INTSTAT,
 	.tmu_intclear = EXYNOS_TMU_REG_INTCLEAR,
 	.emul_con = EXYNOS_EMUL_CON,
 	.emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
-- 
1.7.1

