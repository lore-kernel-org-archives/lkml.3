Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310AbaIRP2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 11:28:44 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:47317 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932278AbaIRP2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 11:28:40 -0400
X-AuditID: cbfee61b-f79f86d00000144c-99-541afa26a058
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 06/33] thermal: exynos: remove needless
 therm_trip_[mode,mask]_shift abstractions
Date: Thu, 18 Sep 2014 17:27:23 +0200
Message-id: <1411054070-25757-7-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1411054070-25757-1-git-send-email-b.zolnierkie@samsung.com>
References: <1411054070-25757-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLLMWRmVeSWpSXmKPExsVy+t9jAV21X1IhBrd6BS0aroZYbJyxntXi
	7vPDjBbzr1xjtTjb9Ibd4s3DzYwWl3fNYbP43HuE0WLG+X1MFk8e9rE5cHnsnHWX3WPxnpdM
	Hn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJVxf3JQwVLtipYvl9kaGM+qdjFyckgImEg8u7+X
	HcIWk7hwbz1bFyMXh5DAIkaJvz1LmCGcLiaJhhlNjCBVbAJWEhPbV4HZIgJaEicubWcCKWIW
	uMUk8frGZLCEsECyxOLZF9hAbBYBVYmPiw6CreAV8JD42bmUEWKdokT3swlgNZwCnhINtzaB
	1QgB1bRtucs8gZF3ASPDKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgQHsmvYNxVYPFIUYB
	DkYlHt4DvFIhQqyJZcWVuYcYJTiYlUR4/3wECvGmJFZWpRblxxeV5qQWH2KU5mBREuc92God
	KCSQnliSmp2aWpBaBJNl4uCUamCcsrwltHDd4XMmpqslHxU+Wqy3pf+0y+qVel5hfHeXzD0f
	V8dT9t1vhYTmCTlLkTixTc7ZhWGV5dPPPQqo7n5j8S/z5+ElXKuiv2W/6uhz59k6n+OXY/Dj
	J2wXjc717/qb9K+I4+L23Qt67pp9SlNPTeWXlLpXfC/+gs+2tJbjLr/tZT5si16nxFKckWio
	xVxUnAgAkHVrAzACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reg->therm_trip_mode_shift and reg->therm_trip_mode_mask are
used only in exynos_tmu_control() and accessed only if
pdata->noise_cancel_mode is non-zero.  pdata->noise_cancel
field is not defined on Exynos4210 (also therm_trip_mode_shift
and therm_trip_mode_mask entries are not even assigned in
exynos4210_tmu_registers but they are assigned to identical
values for all other SoC types) so the abstractions are not
needed and can be removed.

There should be no functional changes caused by this patch.

Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c      |  5 ++---
 drivers/thermal/samsung/exynos_tmu.h      |  4 ----
 drivers/thermal/samsung/exynos_tmu_data.c | 10 ----------
 3 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 1527b25..7c9793a 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -289,9 +289,8 @@ static void exynos_tmu_control(struct platform_device *pdev, bool on)
 	con |= (pdata->gain << EXYNOS_TMU_BUF_SLOPE_SEL_SHIFT);
 
 	if (pdata->noise_cancel_mode) {
-		con &= ~(reg->therm_trip_mode_mask <<
-					reg->therm_trip_mode_shift);
-		con |= (pdata->noise_cancel_mode << reg->therm_trip_mode_shift);
+		con &= ~(EXYNOS_TMU_TRIP_MODE_MASK << EXYNOS_TMU_TRIP_MODE_SHIFT);
+		con |= (pdata->noise_cancel_mode << EXYNOS_TMU_TRIP_MODE_SHIFT);
 	}
 
 	if (on) {
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index 5bcf7a8..6341d74 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -77,8 +77,6 @@ enum soc_type {
  * bitfields. The register validity, offsets and bitfield values may vary
  * slightly across different exynos SOC's.
  * @tmu_ctrl: TMU main controller register.
- * @therm_trip_mode_shift: shift bits of tripping mode in tmu_ctrl register.
- * @therm_trip_mode_mask: mask bits of tripping mode in tmu_ctrl register.
  * @therm_trip_en_shift: shift bits of tripping enable in tmu_ctrl register.
  * @tmu_cur_temp: register containing the current temperature of the TMU.
  * @threshold_th0: Register containing first set of rising levels.
@@ -106,8 +104,6 @@ enum soc_type {
  */
 struct exynos_tmu_registers {
 	u32	tmu_ctrl;
-	u32	therm_trip_mode_shift;
-	u32	therm_trip_mode_mask;
 	u32	therm_trip_en_shift;
 
 	u32	tmu_cur_temp;
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index 988e327..22a0ade 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -84,8 +84,6 @@ struct exynos_tmu_init_data const exynos4210_default_tmu_data = {
 #if defined(CONFIG_SOC_EXYNOS3250)
 static const struct exynos_tmu_registers exynos3250_tmu_registers = {
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
-	.therm_trip_mode_shift = EXYNOS_TMU_TRIP_MODE_SHIFT,
-	.therm_trip_mode_mask = EXYNOS_TMU_TRIP_MODE_MASK,
 	.therm_trip_en_shift = EXYNOS_TMU_THERM_TRIP_EN_SHIFT,
 	.tmu_cur_temp = EXYNOS_TMU_REG_CURRENT_TEMP,
 	.threshold_th0 = EXYNOS_THD_TEMP_RISE,
@@ -163,8 +161,6 @@ struct exynos_tmu_init_data const exynos3250_default_tmu_data = {
 #if defined(CONFIG_SOC_EXYNOS4412) || defined(CONFIG_SOC_EXYNOS5250)
 static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
-	.therm_trip_mode_shift = EXYNOS_TMU_TRIP_MODE_SHIFT,
-	.therm_trip_mode_mask = EXYNOS_TMU_TRIP_MODE_MASK,
 	.therm_trip_en_shift = EXYNOS_TMU_THERM_TRIP_EN_SHIFT,
 	.tmu_cur_temp = EXYNOS_TMU_REG_CURRENT_TEMP,
 	.threshold_th0 = EXYNOS_THD_TEMP_RISE,
@@ -255,8 +251,6 @@ struct exynos_tmu_init_data const exynos5250_default_tmu_data = {
 #if defined(CONFIG_SOC_EXYNOS5260)
 static const struct exynos_tmu_registers exynos5260_tmu_registers = {
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
-	.therm_trip_mode_shift = EXYNOS_TMU_TRIP_MODE_SHIFT,
-	.therm_trip_mode_mask = EXYNOS_TMU_TRIP_MODE_MASK,
 	.therm_trip_en_shift = EXYNOS_TMU_THERM_TRIP_EN_SHIFT,
 	.tmu_cur_temp = EXYNOS_TMU_REG_CURRENT_TEMP,
 	.threshold_th0 = EXYNOS_THD_TEMP_RISE,
@@ -336,8 +330,6 @@ struct exynos_tmu_init_data const exynos5260_default_tmu_data = {
 #if defined(CONFIG_SOC_EXYNOS5420)
 static const struct exynos_tmu_registers exynos5420_tmu_registers = {
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
-	.therm_trip_mode_shift = EXYNOS_TMU_TRIP_MODE_SHIFT,
-	.therm_trip_mode_mask = EXYNOS_TMU_TRIP_MODE_MASK,
 	.therm_trip_en_shift = EXYNOS_TMU_THERM_TRIP_EN_SHIFT,
 	.tmu_cur_temp = EXYNOS_TMU_REG_CURRENT_TEMP,
 	.threshold_th0 = EXYNOS_THD_TEMP_RISE,
@@ -425,8 +417,6 @@ struct exynos_tmu_init_data const exynos5420_default_tmu_data = {
 #if defined(CONFIG_SOC_EXYNOS5440)
 static const struct exynos_tmu_registers exynos5440_tmu_registers = {
 	.tmu_ctrl = EXYNOS5440_TMU_S0_7_CTRL,
-	.therm_trip_mode_shift = EXYNOS_TMU_TRIP_MODE_SHIFT,
-	.therm_trip_mode_mask = EXYNOS_TMU_TRIP_MODE_MASK,
 	.therm_trip_en_shift = EXYNOS_TMU_THERM_TRIP_EN_SHIFT,
 	.tmu_cur_temp = EXYNOS5440_TMU_S0_7_TEMP,
 	.threshold_th0 = EXYNOS5440_TMU_S0_7_TH0,
-- 
1.8.2.3

