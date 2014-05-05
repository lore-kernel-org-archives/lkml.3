Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198AbaEELTo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 07:19:44 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:54981 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756134AbaEELTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 07:19:42 -0400
X-AuditID: cbfee61a-b7f2b6d000006c4d-69-536773cdff17
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 07/10] thermal: exynos: simplify temp_to_code() and
 code_to_temp()
Date: Mon, 05 May 2014 13:15:36 +0200
Message-id: <1399288539-1793-8-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1399288539-1793-1-git-send-email-b.zolnierkie@samsung.com>
References: <1399288539-1793-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrALMWRmVeSWpSXmKPExsVy+t9jAd2zxenBBvsXqVk0XA2x2DhjPavF
	mv0/mSzONr1ht7i8aw6bxefeI4wWM87vY7I4c/oSq8WTh31sFutnvGZx4PJYvOclk8eWq+0s
	Hn1bVjF6HL+xncnj8ya5ANYoLpuU1JzMstQifbsEroyeTasYC3YJV5xuy2lgfM/fxcjJISFg
	IrF5ejsrhC0mceHeejYQW0hgEaPEru+6XYxcQHYXk8Sh1q9MIAk2ASuJie2rGEFsEQE9iRsv
	njCBFDELHGeS+Pn7PFA3B4ewQIjErL1+IDUsAqoSx9d3gw3lFXCXaJh+mgVimaJE97MJYHFO
	AQ+J/S8fM0Msdpc4+Hgy8wRG3gWMDKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgsPtmdQO
	xpUNFocYBTgYlXh4E5jTg4VYE8uKK3MPMUpwMCuJ8GYnAoV4UxIrq1KL8uOLSnNSiw8xSnOw
	KInzHmi1DhQSSE8sSc1OTS1ILYLJMnFwSjUwxoi+/vB58bL4V9/ZJiWXqSy/uzrNbPeXZTEl
	LjlJxeLXGcOe9gSofzc+qDeHfa6+OGdb/a2rnIJZF3ezz+Upend3S9SvJHVtvc0PWKa8Wymb
	zbm22Dj6nojlqx+vuErFF68pr3rgtVf08I2/mXPcU2ctPNZ+77tR2IZZ2x59fLOA90p0bUDV
	fSWW4oxEQy3mouJEACvE/o0zAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Remove dead temp check from temp_to_code() (this function users
  in exynos_tmu_initialize() always pass correct temperatures and
  exynos_tmu_set_emulation() returns early for EXYNOS4210 because
  TMU_SUPPORT_EMULATION flag is not set on this SoC).

* Move temp_code check from code_to_temp() to exynos_tmu_read()
  (code_to_temp() only user).

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c | 38 +++++++++++-------------------------
 1 file changed, 11 insertions(+), 27 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index a415829..20379eb 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -71,19 +71,7 @@ struct exynos_tmu_data {
  */
 static int temp_to_code(struct exynos_tmu_data *data, u8 temp)
 {
-	struct exynos_tmu_platform_data *pdata = data->pdata;
-	int temp_code;
-
-	if (data->soc == SOC_ARCH_EXYNOS4210)
-		/* temp should range between 25 and 125 */
-		if (temp < 25 || temp > 125) {
-			temp_code = -EINVAL;
-			goto out;
-		}
-
-	temp_code = temp + data->temp_error - pdata->first_point_trim;
-out:
-	return temp_code;
+	return temp + data->temp_error - data->pdata->first_point_trim;
 }
 
 /*
@@ -92,19 +80,7 @@ out:
  */
 static int code_to_temp(struct exynos_tmu_data *data, u8 temp_code)
 {
-	struct exynos_tmu_platform_data *pdata = data->pdata;
-	int temp;
-
-	if (data->soc == SOC_ARCH_EXYNOS4210)
-		/* temp_code should range between 75 and 175 */
-		if (temp_code < 75 || temp_code > 175) {
-			temp = -ENODATA;
-			goto out;
-		}
-
-	temp = temp_code - data->temp_error + pdata->first_point_trim;
-out:
-	return temp;
+	return temp_code - data->temp_error + data->pdata->first_point_trim;
 }
 
 static int exynos_tmu_initialize(struct platform_device *pdev)
@@ -297,8 +273,16 @@ static int exynos_tmu_read(struct exynos_tmu_data *data)
 	clk_enable(data->clk);
 
 	temp_code = readb(data->base + reg->tmu_cur_temp);
-	temp = code_to_temp(data, temp_code);
 
+	if (data->soc == SOC_ARCH_EXYNOS4210)
+		/* temp_code should range between 75 and 175 */
+		if (temp_code < 75 || temp_code > 175) {
+			temp = -ENODATA;
+			goto out;
+		}
+
+	temp = code_to_temp(data, temp_code);
+out:
 	clk_disable(data->clk);
 	mutex_unlock(&data->lock);
 
-- 
1.8.2.3

