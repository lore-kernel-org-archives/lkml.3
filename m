Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941AbaKMPCp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 10:02:45 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:50290 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004AbaKMPCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 10:02:41 -0500
X-AuditID: cbfee61a-f79c06d000004e71-5c-5464c80fdeb4
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH v2 05/33] thermal: exynos: remove needless test_mux_addr_shift
 abstraction
Date: Thu, 13 Nov 2014 16:01:00 +0100
Message-id: <1415890888-8881-6-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
References: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJLMWRmVeSWpSXmKPExsVy+t9jQV2BEykhBl+us1s0XA2x2DhjPavF
	/CvXWC3ONr1ht3jzcDOjxeVdc9gsPvceYbSYcX4fk8WTh31sDpweO2fdZfdYvOclk0ffllWM
	Hp83yQWwRHHZpKTmZJalFunbJXBlvLm5i71ggUzFhYv7WBsYt0l0MXJySAiYSKz5Po8RwhaT
	uHBvPVsXIxeHkMB0Rolt6+6wQDhdTBIPOm+ygFSxCVhJTGxfBdYhIqAlceLSdiaQImaBZUwS
	l77NZwJJCAvESPyf8gGsgUVAVWLxvg5mEJtXwF3i0OmvTBDrFCW6n01gA7E5BTwkXk39CzZU
	CKjm2qN3zBMYeRcwMqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECA6wZ1I7GFc2WBxiFOBg
	VOLhfcGSEiLEmlhWXJl7iFGCg1lJhNf7MFCINyWxsiq1KD++qDQntfgQozQHi5I474FW60Ah
	gfTEktTs1NSC1CKYLBMHp1QDI6unwfT9GXs3P67/6Dg/9VlNrS/DxlmXdlxQX1+xQdbT1Wxp
	1e/sP7+lpb5LLjrfFqThPKWsOahlA1vmMb2ns3ZfMmOZOHXdt28/fXYmX2As+Tu32fXP7u/a
	59r/7g25cjlTLWflsvorJ5yKpef8XLJrvdxTZ6a0pKP7Hvz/cb/S5qAet+uTEwxKLMUZiYZa
	zEXFiQCyRESgLAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reg->test_mux_addr_shift is used only if pdata->test_mux is
non-zero.  pdata->test_mux is defined only on Exynos3250 and
Exynos4412 (other SoC types don't even have pdata->test_mux
entry assigned in their struct exynos_tmu_registers instances)
so the abstraction is not needed and can be removed.

There should be no functional changes caused by this patch.

Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c      | 2 +-
 drivers/thermal/samsung/exynos_tmu.h      | 2 --
 drivers/thermal/samsung/exynos_tmu_data.c | 2 --
 3 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 160e7fa..c8d6cdde 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -295,7 +295,7 @@ static void exynos_tmu_control(struct platform_device *pdev, bool on)
 	con = readl(data->base + reg->tmu_ctrl);
 
 	if (pdata->test_mux)
-		con |= (pdata->test_mux << reg->test_mux_addr_shift);
+		con |= (pdata->test_mux << EXYNOS4412_MUX_ADDR_SHIFT);
 
 	con &= ~(EXYNOS_TMU_REF_VOLTAGE_MASK << EXYNOS_TMU_REF_VOLTAGE_SHIFT);
 	con |= pdata->reference_voltage << EXYNOS_TMU_REF_VOLTAGE_SHIFT;
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index cee81a1..0fb10d1 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -77,7 +77,6 @@ enum soc_type {
  * bitfields. The register validity, offsets and bitfield values may vary
  * slightly across different exynos SOC's.
  * @tmu_ctrl: TMU main controller register.
- * @test_mux_addr_shift: shift bits of test mux address.
  * @therm_trip_mode_shift: shift bits of tripping mode in tmu_ctrl register.
  * @therm_trip_mode_mask: mask bits of tripping mode in tmu_ctrl register.
  * @therm_trip_en_shift: shift bits of tripping enable in tmu_ctrl register.
@@ -103,7 +102,6 @@ enum soc_type {
  */
 struct exynos_tmu_registers {
 	u32	tmu_ctrl;
-	u32     test_mux_addr_shift;
 	u32	therm_trip_mode_shift;
 	u32	therm_trip_mode_mask;
 	u32	therm_trip_en_shift;
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index d4b9a68..4ca1283 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -83,7 +83,6 @@ struct exynos_tmu_init_data const exynos4210_default_tmu_data = {
 #if defined(CONFIG_SOC_EXYNOS3250)
 static const struct exynos_tmu_registers exynos3250_tmu_registers = {
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
-	.test_mux_addr_shift = EXYNOS4412_MUX_ADDR_SHIFT,
 	.therm_trip_mode_shift = EXYNOS_TMU_TRIP_MODE_SHIFT,
 	.therm_trip_mode_mask = EXYNOS_TMU_TRIP_MODE_MASK,
 	.therm_trip_en_shift = EXYNOS_TMU_THERM_TRIP_EN_SHIFT,
@@ -159,7 +158,6 @@ struct exynos_tmu_init_data const exynos3250_default_tmu_data = {
 #if defined(CONFIG_SOC_EXYNOS4412) || defined(CONFIG_SOC_EXYNOS5250)
 static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
-	.test_mux_addr_shift = EXYNOS4412_MUX_ADDR_SHIFT,
 	.therm_trip_mode_shift = EXYNOS_TMU_TRIP_MODE_SHIFT,
 	.therm_trip_mode_mask = EXYNOS_TMU_TRIP_MODE_MASK,
 	.therm_trip_en_shift = EXYNOS_TMU_THERM_TRIP_EN_SHIFT,
-- 
1.8.2.3

