Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932483AbaIRP3f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 11:29:35 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:14622 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932464AbaIRP3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 11:29:30 -0400
X-AuditID: cbfee61a-f79e46d00000134f-8b-541afa582b54
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 17/33] thermal: exynos: add get_th_reg() helper
Date: Thu, 18 Sep 2014 17:27:34 +0200
Message-id: <1411054070-25757-18-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1411054070-25757-1-git-send-email-b.zolnierkie@samsung.com>
References: <1411054070-25757-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLLMWRmVeSWpSXmKPExsVy+t9jAd3IX1IhBvs3sVs0XA2x2DhjPavF
	3eeHGS3mX7nGanG26Q27xZuHmxktLu+aw2bxufcIo8WM8/uYLJ487GNz4PLYOesuu8fiPS+Z
	PPq2rGL0+LxJLoAlissmJTUnsyy1SN8ugSujZXZ0wQ7xirv9h1gaGHcJdzFyckgImEgc+dHL
	AmGLSVy4t56ti5GLQ0hgEaPEuf9roZwuJokbXx+AVbEJWElMbF/FCGKLCGhJnLi0nQmkiFng
	FpPE6xuTwRLCAvYSV6YfYgKxWQRUJaYuP8YMYvMKeEp0Hr7FCrFOUaL72QQ2EJsTKN5waxM7
	iC0k4CHRtuUu8wRG3gWMDKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxggPtmdQOxpUNFocY
	BTgYlXh4D/BKhQixJpYVV+YeYpTgYFYS4f3zESjEm5JYWZValB9fVJqTWnyIUZqDRUmc90Cr
	daCQQHpiSWp2ampBahFMlomDU6qBca7urinlXcknvxhukzERaHu2qDphVovXIi/OAi511m/9
	yivTnqXuFrYXiz98teRW2iyrjb0zhJ27Mu2t/5QKfI2JmN36QmZPddyhLy8mRm01KwpTEaze
	EjRNUuJ92B5R3w0H71h0uAZ8njx1unhMxhae2tSqTyct+GfySi7sdbt128pyb4iDEktxRqKh
	FnNRcSIAq4ddJjACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out code for preparing threshold register value from
exynos_tmu_initialize() into get_th_reg().

This is a preparation for introducing per-SoC type tmu_initialize
method.

There should be no functional changes caused by this patch.

Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c | 37 ++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 14 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index a32ca04..80b781d 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -141,6 +141,25 @@ static void sanitize_temp_error(struct exynos_tmu_data *data, u32 trim_info)
 			EXYNOS_TMU_TEMP_MASK;
 }
 
+static u32 get_th_reg(struct exynos_tmu_data *data, u32 threshold, bool falling)
+{
+	struct exynos_tmu_platform_data *pdata = data->pdata;
+	int i;
+
+	for (i = 0; i < pdata->non_hw_trigger_levels; i++) {
+		u8 temp = pdata->trigger_levels[i];
+
+		if (falling)
+			temp -= pdata->threshold_falling;
+		else
+			threshold &= ~(0xff << 8 * i);
+
+		threshold |= temp_to_code(data, temp) << 8 * i;
+	}
+
+	return threshold;
+}
+
 static int exynos_tmu_initialize(struct platform_device *pdev)
 {
 	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
@@ -204,8 +223,6 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 	}
 	sanitize_temp_error(data, trim_info);
 
-	rising_threshold = readl(data->base + reg->threshold_th0);
-
 	if (data->soc == SOC_ARCH_EXYNOS4210) {
 		/* Write temperature code for threshold */
 		threshold_code = temp_to_code(data, pdata->threshold);
@@ -218,18 +235,10 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 		writel(reg->intclr_rise_mask, data->base + reg->tmu_intclear);
 	} else {
 		/* Write temperature code for rising and falling threshold */
-		for (i = 0; i < pdata->non_hw_trigger_levels; i++) {
-			threshold_code = temp_to_code(data,
-						pdata->trigger_levels[i]);
-			rising_threshold &= ~(0xff << 8 * i);
-			rising_threshold |= threshold_code << 8 * i;
-			if (data->soc != SOC_ARCH_EXYNOS5440) {
-				threshold_code = temp_to_code(data,
-						pdata->trigger_levels[i] -
-						pdata->threshold_falling);
-				falling_threshold |= threshold_code << 8 * i;
-			}
-		}
+		rising_threshold = readl(data->base + reg->threshold_th0);
+		rising_threshold = get_th_reg(data, rising_threshold, false);
+		if (data->soc != SOC_ARCH_EXYNOS5440)
+			falling_threshold = get_th_reg(data, 0, true);
 
 		writel(rising_threshold,
 				data->base + reg->threshold_th0);
-- 
1.8.2.3

