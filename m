Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178AbaEELTM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 07:19:12 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:59632 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144AbaEELTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 07:19:10 -0400
X-AuditID: cbfee61b-b7f766d00000646c-52-536773acd50e
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 06/10] thermal: exynos: remove redundant threshold_code checks
 from exynos_tmu_initialize()
Date: Mon, 05 May 2014 13:15:35 +0200
Message-id: <1399288539-1793-7-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1399288539-1793-1-git-send-email-b.zolnierkie@samsung.com>
References: <1399288539-1793-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrALMWRmVeSWpSXmKPExsVy+t9jAd01xenBBheW2lg0XA2x2DhjPavF
	mv0/mSzONr1ht7i8aw6bxefeI4wWM87vY7I4c/oSq8WTh31sFutnvGZx4PJYvOclk8eWq+0s
	Hn1bVjF6HL+xncnj8ya5ANYoLpuU1JzMstQifbsErozJrR4FfwUr9s5Xa2BcwtfFyMkhIWAi
	cWHuQiYIW0ziwr31bF2MXBxCAosYJU5dbWSBcLqYJI5MesYMUsUmYCUxsX0VI4gtIqAncePF
	EyaQImaB40wSP3+fB2rn4BAWyJVo+JUIUsMioCqx8UY3WD2vgLvExOYPLBDbFCW6n01gA7E5
	BTwk9r98DDZfCKjm4OPJzBMYeRcwMqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECA63Z9I7
	GFc1WBxiFOBgVOLhTWBODxZiTSwrrsw9xCjBwawkwpudCBTiTUmsrEotyo8vKs1JLT7EKM3B
	oiTOe7DVOlBIID2xJDU7NbUgtQgmy8TBKdXAuCo7ZENXnV+G/dnMlg0XXT9cXl3yvUpOTvq5
	9s7UhsO6R5mtvTunbc297xzm6nnq5v/U1tDmixo1PYISOun+/S+cV3xvqPv6ovhe1p/VNxX+
	/L1U91Z7hvDTboZ3mgHPH+45IOsdZLHf5NrNTUnu036di/49h8vqWqT8lTQN4Zt2vy5azprv
	pMRSnJFoqMVcVJwIABX1wbkzAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove runtime checks for negative return values of temp_to_code()
from exynos_tmu_initialize().  The current level temperature data
hardcoded in pdata will never cause a negative temp_to_code()
return values and for the new code potential mistakes should be
caught during development/review phases.

Theres should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 789d745..a415829 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -170,10 +170,6 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 	if (data->soc == SOC_ARCH_EXYNOS4210) {
 		/* Write temperature code for threshold */
 		threshold_code = temp_to_code(data, pdata->threshold);
-		if (threshold_code < 0) {
-			ret = threshold_code;
-			goto out;
-		}
 		writeb(threshold_code,
 			data->base + reg->threshold_temp);
 		for (i = 0; i < trigger_levs; i++)
@@ -187,18 +183,12 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 		i < trigger_levs && i < EXYNOS_MAX_TRIGGER_PER_REG; i++) {
 			threshold_code = temp_to_code(data,
 						pdata->trigger_levels[i]);
-			if (threshold_code < 0) {
-				ret = threshold_code;
-				goto out;
-			}
 			rising_threshold |= threshold_code << 8 * i;
 			if (pdata->threshold_falling) {
 				threshold_code = temp_to_code(data,
 						pdata->trigger_levels[i] -
 						pdata->threshold_falling);
-				if (threshold_code > 0)
-					falling_threshold |=
-						threshold_code << 8 * i;
+				falling_threshold |= threshold_code << 8 * i;
 			}
 		}
 
@@ -217,10 +207,6 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 				(pdata->trigger_type[i] == HW_TRIP)) {
 			threshold_code = temp_to_code(data,
 						pdata->trigger_levels[i]);
-			if (threshold_code < 0) {
-				ret = threshold_code;
-				goto out;
-			}
 			if (i == EXYNOS_MAX_TRIGGER_PER_REG - 1) {
 				/* 1-4 level to be assigned in th0 reg */
 				rising_threshold |= threshold_code << 8 * i;
-- 
1.8.2.3

