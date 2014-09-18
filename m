Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358AbaIRP2y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 11:28:54 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:47330 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932311AbaIRP2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 11:28:50 -0400
X-AuditID: cbfee61a-f79e46d00000134f-40-541afa30df79
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 08/33] thermal: exynos: remove needless emul_temp_shift
 abstraction
Date: Thu, 18 Sep 2014 17:27:25 +0200
Message-id: <1411054070-25757-9-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1411054070-25757-1-git-send-email-b.zolnierkie@samsung.com>
References: <1411054070-25757-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHLMWRmVeSWpSXmKPExsVy+t9jAV2DX1IhBq2zLCwaroZYbJyxntXi
	7vPDjBbzr1xjtTjb9Ibd4s3DzYwWl3fNYbP43HuE0WLG+X1MFk8e9rE5cHnsnHWX3WPxnpdM
	Hn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJUxr7WPueCUUsW3Hx+ZGxgPyHYxcnJICJhI7N95
	lQnCFpO4cG89WxcjF4eQwCJGiVt/prBAOF1MEuf6JzGDVLEJWElMbF/FCGKLCGhJnLi0nQmk
	iFngFpPE6xuTwRLCAqESE7pOgjWwCKhKvDqyFyzOK+AhMXfzDqh1ihLdzyawgdicAp4SDbc2
	sYPYQkA1bVvuMk9g5F3AyLCKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzjUnkntYFzZYHGI
	UYCDUYmH9wCvVIgQa2JZcWXuIUYJDmYlEd4/H4FCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeQ+0
	WgcKCaQnlqRmp6YWpBbBZJk4OKUaGAM+ljXdXHyZ/Ztl4Cymp0uevOX6OetkacdK5T0VV7YX
	rr1es1XsldSx+MsMPAJTGlaer1saMf98JIPJnsofjhmLE//FyU3WbtVd/Orh1gmrN119cUZP
	ZAuHr82imtkClbPXPJJYp6OeW2Eufvqr9knJN0zS5yXt17zbobby7bKfb5+sUJukxy+ixFKc
	kWioxVxUnAgA8YoR9jECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reg->emul_temp_shift is used only in exynos_tmu_set_emulation()
and accessed only if TMU_SUPPORT_EMULATION flag is set.  This
flag is not set for Exynos4210 (reg->emul_temp_shift field is
not even assigned in exynos4210_tmu_registers and is assigned
to identical value for all other SoC types) so the abstraction
is not needed and can be removed.

There should be no functional changes caused by this patch.

Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c      | 4 ++--
 drivers/thermal/samsung/exynos_tmu.h      | 2 --
 drivers/thermal/samsung/exynos_tmu_data.c | 5 -----
 3 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 350a1f5..974c337 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -368,8 +368,8 @@ static int exynos_tmu_set_emulation(void *drv_data, unsigned long temp)
 			val &= ~(EXYNOS_EMUL_TIME_MASK << reg->emul_time_shift);
 			val |= (EXYNOS_EMUL_TIME << reg->emul_time_shift);
 		}
-		val &= ~(EXYNOS_EMUL_DATA_MASK << reg->emul_temp_shift);
-		val |= (temp_to_code(data, temp) << reg->emul_temp_shift) |
+		val &= ~(EXYNOS_EMUL_DATA_MASK << EXYNOS_EMUL_DATA_SHIFT);
+		val |= (temp_to_code(data, temp) << EXYNOS_EMUL_DATA_SHIFT) |
 			EXYNOS_EMUL_ENABLE;
 	} else {
 		val &= ~EXYNOS_EMUL_ENABLE;
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index 8f5ffcb..649a654 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -96,7 +96,6 @@ enum soc_type {
  * @intclr_rise_mask: mask bits of all rising interrupt bits.
  * @intclr_fall_mask: mask bits of all rising interrupt bits.
  * @emul_con: TMU emulation controller register.
- * @emul_temp_shift: shift bits of emulation temperature.
  * @emul_time_shift: shift bits of emulation time.
  * @tmu_irqstatus: register to find which TMU generated interrupts.
  * @tmu_pmin: register to get/set the Pmin value.
@@ -127,7 +126,6 @@ struct exynos_tmu_registers {
 	u32	intclr_rise_mask;
 
 	u32	emul_con;
-	u32	emul_temp_shift;
 	u32	emul_time_shift;
 
 	u32	tmu_irqstatus;
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index a37f490..3ae0376 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -99,7 +99,6 @@ static const struct exynos_tmu_registers exynos3250_tmu_registers = {
 	.intclr_rise_mask = EXYNOS_TMU_RISE_INT_MASK,
 	.intclr_fall_mask = EXYNOS_TMU_FALL_INT_MASK,
 	.emul_con = EXYNOS_EMUL_CON,
-	.emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
 	.emul_time_shift = EXYNOS_EMUL_TIME_SHIFT,
 };
 
@@ -176,7 +175,6 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 	.intclr_rise_mask = EXYNOS_TMU_RISE_INT_MASK,
 	.intclr_fall_mask = EXYNOS_TMU_FALL_INT_MASK,
 	.emul_con = EXYNOS_EMUL_CON,
-	.emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
 	.emul_time_shift = EXYNOS_EMUL_TIME_SHIFT,
 };
 
@@ -265,7 +263,6 @@ static const struct exynos_tmu_registers exynos5260_tmu_registers = {
 	.intclr_rise_mask = EXYNOS5260_TMU_RISE_INT_MASK,
 	.intclr_fall_mask = EXYNOS5260_TMU_FALL_INT_MASK,
 	.emul_con = EXYNOS5260_EMUL_CON,
-	.emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
 	.emul_time_shift = EXYNOS_EMUL_TIME_SHIFT,
 };
 
@@ -344,7 +341,6 @@ static const struct exynos_tmu_registers exynos5420_tmu_registers = {
 	.intclr_rise_mask = EXYNOS_TMU_RISE_INT_MASK,
 	.intclr_fall_mask = EXYNOS_TMU_FALL_INT_MASK,
 	.emul_con = EXYNOS_EMUL_CON,
-	.emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
 	.emul_time_shift = EXYNOS_EMUL_TIME_SHIFT,
 };
 
@@ -432,7 +428,6 @@ static const struct exynos_tmu_registers exynos5440_tmu_registers = {
 	.intclr_fall_mask = EXYNOS5440_TMU_FALL_INT_MASK,
 	.tmu_irqstatus = EXYNOS5440_TMU_IRQ_STATUS,
 	.emul_con = EXYNOS5440_TMU_S0_7_DEBUG,
-	.emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
 	.tmu_pmin = EXYNOS5440_TMU_PMIN,
 };
 
-- 
1.8.2.3

