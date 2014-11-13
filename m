Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbaKMPEy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 10:04:54 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:50413 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbaKMPEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 10:04:52 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-b4-5464c8921f52
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH v2 17/33] thermal: exynos: add get_th_reg() helper
Date: Thu, 13 Nov 2014 16:01:12 +0100
Message-id: <1415890888-8881-18-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
References: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t9jQd1JJ1JCDD6/NbRouBpisXHGelaL
	+VeusVqcbXrDbvHm4WZGi8u75rBZfO49wmgx4/w+JosnD/vYHDg9ds66y+6xeM9LJo++LasY
	PT5vkgtgieKySUnNySxLLdK3S+DKuN/UwVTwQKzi38nr7A2Mr4W6GDk5JARMJFYe3MMIYYtJ
	XLi3nq2LkYtDSGA6o8Sh6f+ZIZwuJokF758wgVSxCVhJTGxfBdYhIqAlceLSdiaQImaBZUwS
	l77NBysSFnCSuPVgNdAoDg4WAVWJ/mvKIGFeAQ+JKV/XM0NsU5TofjaBDcTmBIq/mvoXbKaQ
	gLvEtUfvmCcw8i5gZFjFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERxez6R3MK5qsDjEKMDB
	qMTD+4IlJUSINbGsuDL3EKMEB7OSCK/3YaAQb0piZVVqUX58UWlOavEhRmkOFiVx3oOt1oFC
	AumJJanZqakFqUUwWSYOTqkGRu+aCvHuUwdUHk41Ylwck57uvWZz91EO+WjtrtnhRqcnsZq8
	WLeh2Ff2+bk339e89lfY3b2o7/AsT7WvC1XOWKXs/Kgu/VT0k47LuuVPfzyIvz2Vxfjd0zne
	olpPuGQLMj6sjeN0Z/cUDlr/9YSZxvYZhVHSV3dfubL0+dUV4ZMME+IPp07eek+JpTgj0VCL
	uag4EQAcaDl0KwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out code for preparing threshold register value from
exynos_tmu_initialize() into get_th_reg().

This is a preparation for introducing per-SoC type tmu_initialize
method.

There should be no functional changes caused by this patch.

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
index b0c0715..6e82fdd 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -158,6 +158,25 @@ static void sanitize_temp_error(struct exynos_tmu_data *data, u32 trim_info)
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
@@ -221,8 +240,6 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 	}
 	sanitize_temp_error(data, trim_info);
 
-	rising_threshold = readl(data->base + reg->threshold_th0);
-
 	if (data->soc == SOC_ARCH_EXYNOS4210) {
 		/* Write temperature code for threshold */
 		threshold_code = temp_to_code(data, pdata->threshold);
@@ -235,18 +252,10 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 		exynos_tmu_clear_irqs(data);
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

