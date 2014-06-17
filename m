Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965092AbaFQRbS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 13:31:18 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:45550 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965038AbaFQRbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 13:31:14 -0400
X-AuditID: cbfee61b-b7fbb6d000001be3-2a-53a07b2dbd81
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH v2 5/9] thermal: exynos: remove redundant threshold_code checks
 from exynos_tmu_initialize()
Date: Tue, 17 Jun 2014 19:27:21 +0200
Message-id: <1403026045-16024-6-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1403026045-16024-1-git-send-email-b.zolnierkie@samsung.com>
References: <1403026045-16024-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrELMWRmVeSWpSXmKPExsVy+t9jQV3d6gXBBg92Glo0XA2x2DhjPavF
	mv0/mSzONr1ht7i8aw6bxefeI4wWM87vY7I4c/oSq8WTh31sFutnvGZx4PJYvOclk8eWq+0s
	Hn1bVjF6HL+xncnj8ya5ANYoLpuU1JzMstQifbsEroybJ5eyFWwVrfj8+gp7A2ObYBcjJ4eE
	gInEvxermCFsMYkL99azdTFycQgJTGeUWLfhCyuE08UkcXhvAwtIFZuAlcTE9lWMILaIgJ7E
	jRdPmECKmAWOM0n8/H0eqJ2DQ1ggT2L5C0uQGhYBVYmvN1+C1fMKeEjcXfETapuiRPezCWwg
	NqeAp8SNey1gthBQzfyLnUwTGHkXMDKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAgOuWfS
	OxhXNVgcYhTgYFTi4eXIXRAsxJpYVlyZe4hRgoNZSYT3XBZQiDclsbIqtSg/vqg0J7X4EKM0
	B4uSOO/BVutAIYH0xJLU7NTUgtQimCwTB6dUA6NLk1PLOuV1U914d5y0sbro83jK/X0pDwPi
	7/MacF2tq4qe8T1Qdgo738cZSTfM8nk3Ki9kun49ZI9DeGBN4Gbnb0x6Uww/8onnfP9/9UwB
	x/Z9l1Zy8OvH856ouaVh8ObU7e4rVZd145a/TJmlem7/RtudTjfieI+pviq0mpy5Inej5Ub2
	q0ZKLMUZiYZazEXFiQC0+PBVNQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove runtime checks for negative return values of temp_to_code()
from exynos_tmu_initialize().

The current level temperature data hardcoded in pdata will never
cause a negative temp_to_code() return values and checking itself
is not proper.  The checks in question are done at runtime in
a production code for data that is hardcoded inside driver during
development time and later it doesn't change.  Such data should
be verified during development and review time (i.e. by a script
parsing relevant data from exynos_tmu_data.c, one can also argue
that verification to be done is so simple that the review by
a maintainer should be enough).

Theres should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index f061580..204f811 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -180,10 +180,6 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
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
@@ -197,19 +193,13 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 		i < trigger_levs && i < EXYNOS_MAX_TRIGGER_PER_REG; i++) {
 			threshold_code = temp_to_code(data,
 						pdata->trigger_levels[i]);
-			if (threshold_code < 0) {
-				ret = threshold_code;
-				goto out;
-			}
 			rising_threshold &= ~(0xff << 8 * i);
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
 
@@ -228,10 +218,6 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 				(pdata->trigger_type[i] == HW_TRIP)) {
 			threshold_code = temp_to_code(data,
 						pdata->trigger_levels[i]);
-			if (threshold_code < 0) {
-				ret = threshold_code;
-				goto out;
-			}
 			if (i == EXYNOS_MAX_TRIGGER_PER_REG - 1) {
 				/* 1-4 level to be assigned in th0 reg */
 				rising_threshold &= ~(0xff << 8 * i);
-- 
1.8.2.3

