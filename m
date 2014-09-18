Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932743AbaIRPet (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 11:34:49 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:29247 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932372AbaIRP30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 11:29:26 -0400
X-AuditID: cbfee61a-f79e46d00000134f-86-541afa554ee3
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 16/33] thermal: exynos: add sanitize_temp_error() helper
Date: Thu, 18 Sep 2014 17:27:33 +0200
Message-id: <1411054070-25757-17-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1411054070-25757-1-git-send-email-b.zolnierkie@samsung.com>
References: <1411054070-25757-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHLMWRmVeSWpSXmKPExsVy+t9jAd3QX1IhBvOX81s0XA2x2DhjPavF
	3eeHGS3mX7nGanG26Q27xZuHmxktLu+aw2bxufcIo8WM8/uYLJ487GNz4PLYOesuu8fiPS+Z
	PPq2rGL0+LxJLoAlissmJTUnsyy1SN8ugStj9aIbTAUHRCpmzW5lbGA8LtjFyMkhIWAi0b/v
	ICOELSZx4d56ti5GLg4hgUWMEvt2XmWGcLqYJCYd7WECqWITsJKY2L4KrENEQEvixKXtTCBF
	zAK3mCRe35gMlhAW8JCY3T4LzGYRUJV48HQ+O4jNK+ApcXPXKSaIdYoS3c8msIHYnEDxhlub
	wGqEgHrbttxlnsDIu4CRYRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcKg9k9rBuLLB4hCj
	AAejEg/vAV6pECHWxLLiytxDjBIczEoivH8+AoV4UxIrq1KL8uOLSnNSiw8xSnOwKInzHmi1
	DhQSSE8sSc1OTS1ILYLJMnFwSjUwJiwMZlU+J6Xz6nSYTv3izdISkybIq0/c4bXq9f+rX2qP
	C1TvT5a8/1HqgcEPk/gtj8s93m9VMjoQ8cp2bYJbY9T6nqOMgXKNxQf1UucxdS//Oo1DPXtK
	QaKqu1i/wjqnddeNk6e9S+idqVG8coZQkBKvVp+f+KqcUx8zu1yTa5//fzavS+qbEktxRqKh
	FnNRcSIAezto5zECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out code for initializing data->temp_error[1,2] values
from exynos_tmu_initialize() into sanitize_temp_error().

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
 drivers/thermal/samsung/exynos_tmu.c | 33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 4903a6e..a32ca04 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -122,6 +122,25 @@ static int code_to_temp(struct exynos_tmu_data *data, u8 temp_code)
 	return temp;
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
@@ -183,19 +202,7 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
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

