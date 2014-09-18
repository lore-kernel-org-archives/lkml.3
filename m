Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932714AbaIRPdj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 11:33:39 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:14646 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932531AbaIRP3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 11:29:50 -0400
X-AuditID: cbfee61b-f79f86d00000144c-ee-541afa6d1d67
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 22/33] thermal: exynos: add get_emul_con_reg() helper
Date: Thu, 18 Sep 2014 17:27:39 +0200
Message-id: <1411054070-25757-23-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1411054070-25757-1-git-send-email-b.zolnierkie@samsung.com>
References: <1411054070-25757-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDLMWRmVeSWpSXmKPExsVy+t9jAd3cX1IhBtNeiVs0XA2x2DhjPavF
	3eeHGS3mX7nGanG26Q27xZuHmxktLu+aw2bxufcIo8WM8/uYLJ487GNz4PLYOesuu8fiPS+Z
	PPq2rGL0+LxJLoAlissmJTUnsyy1SN8ugSvj16ezTAVPhSvm/V3I3MB4UqCLkYNDQsBE4sJH
	IJMTyBSTuHBvPVsXIxeHkMAiRonNP24yQThdTBI7PnSwgVSxCVhJTGxfxQhiiwhoSZy4tB2s
	iFngFpPE6xuTGUGmCgu4Sqy5WQZSwyKgKvF4+XdWEJtXwFNixfOljBDbFCW6n00Am8kJFG+4
	tYkdxBYS8JBo23KXeQIj7wJGhlWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwWH2THoH46oG
	i0OMAhyMSjy8B3ilQoRYE8uKK3MPMUpwMCuJ8P75CBTiTUmsrEotyo8vKs1JLT7EKM3BoiTO
	e7DVOlBIID2xJDU7NbUgtQgmy8TBKdXAOE19yq8t30+1zOG8cGiP1AZhHlGT98rbrs658jY8
	Jin8nWTyuT/77s0O65FfdfrYj0W9l55NOvd8TfamHvvkmTqN8bpixdx5javP7/73b0GYxl/+
	ZJ+LJ/0LdISaN37sf6GUHe3q4XVs6TfDWYpx09fvkSuZsa7+u2dEr9wft1ULbT5lszfU71Bi
	Kc5INNRiLipOBAAdlxYLLwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out code for preparing EMUL_CON register value from
exynos_tmu_set_emulation() into get_emul_con_reg().

This is a preparation for introducing per-SoC type
tmu_set_emulation method.

There should be no functional changes caused by this patch.

Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c | 38 ++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index a35f045..59708b6 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -436,6 +436,28 @@ static int exynos_tmu_read(struct exynos_tmu_data *data)
 }
 
 #ifdef CONFIG_THERMAL_EMULATION
+static u32 get_emul_con_reg(struct exynos_tmu_data *data, unsigned int val,
+			    unsigned long temp)
+{
+	struct exynos_tmu_platform_data *pdata = data->pdata;
+
+	if (temp) {
+		temp /= MCELSIUS;
+
+		if (TMU_SUPPORTS(pdata, EMUL_TIME)) {
+			val &= ~(EXYNOS_EMUL_TIME_MASK << EXYNOS_EMUL_TIME_SHIFT);
+			val |= (EXYNOS_EMUL_TIME << EXYNOS_EMUL_TIME_SHIFT);
+		}
+		val &= ~(EXYNOS_EMUL_DATA_MASK << EXYNOS_EMUL_DATA_SHIFT);
+		val |= (temp_to_code(data, temp) << EXYNOS_EMUL_DATA_SHIFT) |
+			EXYNOS_EMUL_ENABLE;
+	} else {
+		val &= ~EXYNOS_EMUL_ENABLE;
+	}
+
+	return val;
+}
+
 static int exynos_tmu_set_emulation(void *drv_data, unsigned long temp)
 {
 	struct exynos_tmu_data *data = drv_data;
@@ -454,21 +476,7 @@ static int exynos_tmu_set_emulation(void *drv_data, unsigned long temp)
 	clk_enable(data->clk);
 
 	val = readl(data->base + reg->emul_con);
-
-	if (temp) {
-		temp /= MCELSIUS;
-
-		if (TMU_SUPPORTS(pdata, EMUL_TIME)) {
-			val &= ~(EXYNOS_EMUL_TIME_MASK << EXYNOS_EMUL_TIME_SHIFT);
-			val |= (EXYNOS_EMUL_TIME << EXYNOS_EMUL_TIME_SHIFT);
-		}
-		val &= ~(EXYNOS_EMUL_DATA_MASK << EXYNOS_EMUL_DATA_SHIFT);
-		val |= (temp_to_code(data, temp) << EXYNOS_EMUL_DATA_SHIFT) |
-			EXYNOS_EMUL_ENABLE;
-	} else {
-		val &= ~EXYNOS_EMUL_ENABLE;
-	}
-
+	val = get_emul_con_reg(data, val, temp);
 	writel(val, data->base + reg->emul_con);
 
 	clk_disable(data->clk);
-- 
1.8.2.3

