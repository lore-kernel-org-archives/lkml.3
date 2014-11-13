Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbaKMPEl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 10:04:41 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:42879 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbaKMPEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 10:04:34 -0500
X-AuditID: cbfee61a-f79c06d000004e71-4a-5464c85cac86
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH v2 12/33] thermal: exynos: simplify HW_TRIP level setting
Date: Thu, 13 Nov 2014 16:01:07 +0100
Message-id: <1415890888-8881-13-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
References: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t9jQd2YEykhBq3TuSwaroZYbJyxntVi
	/pVrrBZnm96wW7x5uJnR4vKuOWwWn3uPMFrMOL+PyeLJwz42B06PnbPusnss3vOSyaNvyypG
	j8+b5AJYorhsUlJzMstSi/TtErgynjx8wFywWqli5qX3LA2MLbJdjJwcEgImEheWXGeDsMUk
	LtxbD2RzcQgJTGeU6F99iRHC6WKSmDnvN1gVm4CVxMT2VYwgtoiAlsSJS9uZQIqYBZYxSVz6
	Nh/I4eAQFvCUePA7D6SGRUBVor+hkwnE5hXwkNj86xETxDZFie5nE8BmcgLFX039CzZTSMBd
	4tqjd8wTGHkXMDKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAgOr2dSOxhXNlgcYhTgYFTi
	4X3BkhIixJpYVlyZe4hRgoNZSYTX+zBQiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+BVutAIYH0
	xJLU7NTUgtQimCwTB6dUA2OH7ZKSF97/5sr8kok7EBPufPL8bPuKrs7yj9P+nkp5MKHarH/T
	RtZjgUJtWSvnbz/hY81lESZ4tLptxeNpUVorgrvYH508P3PWERYGd6U9aceOey7TSYvxCtpz
	d3a1bI3Eb+tz2SuPLVLv+arBW3zhNWfWzz+JR2c09oZc2yHfGFbN7zDp/GQlluKMREMt5qLi
	RABNQD99KwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify HW_TRIP level setting in exynos_tmu_initialize() (don't
pretend that the current code is hardware and configuration
independent and just do SoC type check explicitly).  Then remove
no longer needed reg->threshold_[th2,th3_l0_shift] abstractions
(only assigned for Exynos5440 in exynos5440_tmu_registers) and
EXYNOS_MAX_TRIGGER_PER_REG define.

There should be no functional changes caused by this patch.

Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c      | 10 +++++-----
 drivers/thermal/samsung/exynos_tmu.h      |  4 ----
 drivers/thermal/samsung/exynos_tmu_data.c |  2 --
 drivers/thermal/samsung/exynos_tmu_data.h |  2 --
 4 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 411c465..1c15b37 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -252,18 +252,18 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 				(pdata->trigger_type[i] == HW_TRIP)) {
 			threshold_code = temp_to_code(data,
 						pdata->trigger_levels[i]);
-			if (i == EXYNOS_MAX_TRIGGER_PER_REG - 1) {
+			if (data->soc != SOC_ARCH_EXYNOS5440) {
 				/* 1-4 level to be assigned in th0 reg */
 				rising_threshold &= ~(0xff << 8 * i);
 				rising_threshold |= threshold_code << 8 * i;
 				writel(rising_threshold,
-					data->base + reg->threshold_th0);
-			} else if (i == EXYNOS_MAX_TRIGGER_PER_REG) {
+					data->base + EXYNOS_THD_TEMP_RISE);
+			} else {
 				/* 5th level to be assigned in th2 reg */
 				rising_threshold =
-				threshold_code << reg->threshold_th3_l0_shift;
+				threshold_code << EXYNOS5440_TMU_TH_RISE4_SHIFT;
 				writel(rising_threshold,
-					data->base + reg->threshold_th2);
+					data->base + EXYNOS5440_TMU_S0_7_TH2);
 			}
 			con = readl(data->base + reg->tmu_ctrl);
 			con |= (1 << EXYNOS_TMU_THERM_TRIP_EN_SHIFT);
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index e8510aa..ebe39b4 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -80,8 +80,6 @@ enum soc_type {
  * @tmu_cur_temp: register containing the current temperature of the TMU.
  * @threshold_th0: Register containing first set of rising levels.
  * @threshold_th1: Register containing second set of rising levels.
- * @threshold_th2: Register containing third set of rising levels.
- * @threshold_th3_l0_shift: shift bits of level0 threshold temperature.
  * @tmu_inten: register containing the different threshold interrupt
 	enable bits.
  * @inten_rise0_shift: shift bits of rising 0 interrupt bits.
@@ -100,8 +98,6 @@ struct exynos_tmu_registers {
 
 	u32	threshold_th0;
 	u32	threshold_th1;
-	u32	threshold_th2;
-	u32	threshold_th3_l0_shift;
 
 	u32	tmu_inten;
 	u32	inten_rise0_shift;
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index fe063d4..f81c940 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -391,8 +391,6 @@ static const struct exynos_tmu_registers exynos5440_tmu_registers = {
 	.tmu_cur_temp = EXYNOS5440_TMU_S0_7_TEMP,
 	.threshold_th0 = EXYNOS5440_TMU_S0_7_TH0,
 	.threshold_th1 = EXYNOS5440_TMU_S0_7_TH1,
-	.threshold_th2 = EXYNOS5440_TMU_S0_7_TH2,
-	.threshold_th3_l0_shift = EXYNOS5440_TMU_TH_RISE4_SHIFT,
 	.tmu_inten = EXYNOS5440_TMU_S0_7_IRQEN,
 	.inten_rise0_shift = EXYNOS5440_TMU_INTEN_RISE0_SHIFT,
 	.inten_rise1_shift = EXYNOS5440_TMU_INTEN_RISE1_SHIFT,
diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
index e02ef99..2af312d 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.h
+++ b/drivers/thermal/samsung/exynos_tmu_data.h
@@ -72,8 +72,6 @@
 #define EXYNOS_EMUL_DATA_MASK	0xFF
 #define EXYNOS_EMUL_ENABLE	0x1
 
-#define EXYNOS_MAX_TRIGGER_PER_REG	4
-
 /* Exynos5260 specific */
 #define EXYNOS5260_TMU_REG_INTEN		0xC0
 #define EXYNOS5260_TMU_REG_INTSTAT		0xC4
-- 
1.8.2.3

