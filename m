Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbaKMPEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 10:04:39 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:50398 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264AbaKMPEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 10:04:35 -0500
X-AuditID: cbfee61a-f79c06d000004e71-79-5464c88226ff
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH v2 16/33] thermal: exynos: add sanitize_temp_error() helper
Date: Thu, 13 Nov 2014 16:01:11 +0100
Message-id: <1415890888-8881-17-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
References: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t9jQd2mEykhBj1PeS0aroZYbJyxntVi
	/pVrrBZnm96wW7x5uJnR4vKuOWwWn3uPMFrMOL+PyeLJwz42B06PnbPusnss3vOSyaNvyypG
	j8+b5AJYorhsUlJzMstSi/TtErgyWiceYCxYJVJx7tROlgbG7YJdjJwcEgImEhs79zFB2GIS
	F+6tZ+ti5OIQEpjOKPHp6DIWkISQQBeTxLQfxSA2m4CVxMT2VYwgtoiAlsSJS9uZQBqYBZYx
	SVz6Nh9skrCAt8TVX1eYQWwWAVWJeW3HweK8Ah4Saz4sY4PYpijR/WwCmM0JFH819S8jxDJ3
	iWuP3jFPYORdwMiwilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4vJ5J7WBc2WBxiFGAg1GJ
	h/cFS0qIEGtiWXFl7iFGCQ5mJRFe78NAId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwHWq0DhQTS
	E0tSs1NTC1KLYLJMHJxSDYymgvcF/jlOmvz8jdUZ26Wms051dnIoFBqlG0gcEvp53OCT/Jw3
	kZf3v+4OU7wrxyFgfa3oS4/fsnsWihIKfMcTb0z4njHrT1Q5W3WC5Cnv3kYlz0tytlsMVKWe
	rM//1bpoFnetXRDPCnktnn0/fy4RfbzmOMeN/sBpbeu+VaXvZF3kU3kx+7ISS3FGoqEWc1Fx
	IgD/hYtXKwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out code for initializing data->temp_error[1,2] values
from exynos_tmu_initialize() into sanitize_temp_error().

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
 drivers/thermal/samsung/exynos_tmu.c | 33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index e4d75a1..b0c0715 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -139,6 +139,25 @@ static void exynos_tmu_clear_irqs(struct exynos_tmu_data *data)
 	writel(val_irq, data->base + reg->tmu_intclear);
 }
 
+static void sanitize_temp_error(struct exynos_tmu_data *data, u32 trim_info)
+{
+	struct exynos_tmu_platform_data *pdata = data->pdata;
+
+	data->temp_error1 = trim_info & EXYNOS_TMU_TEMP_MASK;
+	data->temp_error2 = ((trim_info >> EXYNOS_TRIMINFO_85_SHIFT) &
+				EXYNOS_TMU_TEMP_MASK);
+
+	if (!data->temp_error1 ||
+		(pdata->min_efuse_value > data->temp_error1) ||
+		(data->temp_error1 > pdata->max_efuse_value))
+		data->temp_error1 = pdata->efuse_value & EXYNOS_TMU_TEMP_MASK;
+
+	if (!data->temp_error2)
+		data->temp_error2 =
+			(pdata->efuse_value >> EXYNOS_TRIMINFO_85_SHIFT) &
+			EXYNOS_TMU_TEMP_MASK;
+}
+
 static int exynos_tmu_initialize(struct platform_device *pdev)
 {
 	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
@@ -200,19 +219,7 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 		else
 			trim_info = readl(data->base + EXYNOS_TMU_REG_TRIMINFO);
 	}
-	data->temp_error1 = trim_info & EXYNOS_TMU_TEMP_MASK;
-	data->temp_error2 = ((trim_info >> EXYNOS_TRIMINFO_85_SHIFT) &
-				EXYNOS_TMU_TEMP_MASK);
-
-	if (!data->temp_error1 ||
-		(pdata->min_efuse_value > data->temp_error1) ||
-		(data->temp_error1 > pdata->max_efuse_value))
-		data->temp_error1 = pdata->efuse_value & EXYNOS_TMU_TEMP_MASK;
-
-	if (!data->temp_error2)
-		data->temp_error2 =
-			(pdata->efuse_value >> EXYNOS_TRIMINFO_85_SHIFT) &
-			EXYNOS_TMU_TEMP_MASK;
+	sanitize_temp_error(data, trim_info);
 
 	rising_threshold = readl(data->base + reg->threshold_th0);
 
-- 
1.8.2.3

