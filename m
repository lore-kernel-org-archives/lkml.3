Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbaGaRLw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 13:11:52 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64890 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbaGaRLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 13:11:46 -0400
X-AuditID: cbfee61a-f79e46d00000134f-44-53da78d0947a
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH v3 5/8] thermal: exynos: simplify temp_to_code() and
 code_to_temp()
Date: Thu, 31 Jul 2014 19:11:03 +0200
Message-id: <1406826667-2289-6-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1406826667-2289-1-git-send-email-b.zolnierkie@samsung.com>
References: <1406826667-2289-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMLMWRmVeSWpSXmKPExsVy+t9jAd0LFbeCDSb/NrNouBpisXHGelaL
	Nft/MlmcbXrDbnF51xw2i8+9RxgtZpzfx2Rx5vQlVosnD/vYLNbPeM3iwOWxeM9LJo8tV9tZ
	PPq2rGL0OH5jO5PH501yAaxRXDYpqTmZZalF+nYJXBlXf01hKVgvWvH1znyWBsaVgl2MnBwS
	AiYSZw+fYYawxSQu3FvP1sXIxSEksIhR4tnDd+wQTheTxIq7r1lBqtgErCQmtq9iBLFFBPQk
	brx4wgRSxCxwnEni5+/zbCAJYYFQiaYvh1lAbBYBVYnHfx4ygdi8Au4SN192skKsU5TofjYB
	rJ5TwEPiQPsMMFsIqObvppOsExh5FzAyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIDrpn
	UjsYVzZYHGIU4GBU4uGdEX4rWIg1say4MvcQowQHs5IIr0s5UIg3JbGyKrUoP76oNCe1+BCj
	NAeLkjjvgVbrQCGB9MSS1OzU1ILUIpgsEwenVAOj5Zw5sW0TjZb92/E63eL5pa/vPgjIrPmT
	lyhuq5vUVfjUYzrj6kkfsw+FxWX1Ly35IM12h9d/Yk2y/ttkdlO12xGzrq2oDNp20yj320L3
	kJy56mc4dmklyv0vtnopGdQauvgY9xHGTydWzJH0kHb0ytv8WlqwuSKkcqHj0qNHHJJuTnKx
	tHJRYinOSDTUYi4qTgQA0rNNvjYCAAA=
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
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 15574cc..aa4d4fd 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -77,13 +77,6 @@ static int temp_to_code(struct exynos_tmu_data *data, u8 temp)
 	struct exynos_tmu_platform_data *pdata = data->pdata;
 	int temp_code;
 
-	if (data->soc == SOC_ARCH_EXYNOS4210)
-		/* temp should range between 25 and 125 */
-		if (temp < 25 || temp > 125) {
-			temp_code = -EINVAL;
-			goto out;
-		}
-
 	switch (pdata->cal_type) {
 	case TYPE_TWO_POINT_TRIMMING:
 		temp_code = (temp - pdata->first_point_trim) *
@@ -98,7 +91,7 @@ static int temp_to_code(struct exynos_tmu_data *data, u8 temp)
 		temp_code = temp + pdata->default_temp_offset;
 		break;
 	}
-out:
+
 	return temp_code;
 }
 
@@ -111,13 +104,6 @@ static int code_to_temp(struct exynos_tmu_data *data, u8 temp_code)
 	struct exynos_tmu_platform_data *pdata = data->pdata;
 	int temp;
 
-	if (data->soc == SOC_ARCH_EXYNOS4210)
-		/* temp_code should range between 75 and 175 */
-		if (temp_code < 75 || temp_code > 175) {
-			temp = -ENODATA;
-			goto out;
-		}
-
 	switch (pdata->cal_type) {
 	case TYPE_TWO_POINT_TRIMMING:
 		temp = (temp_code - data->temp_error1) *
@@ -132,7 +118,7 @@ static int code_to_temp(struct exynos_tmu_data *data, u8 temp_code)
 		temp = temp_code - pdata->default_temp_offset;
 		break;
 	}
-out:
+
 	return temp;
 }
 
@@ -346,8 +332,16 @@ static int exynos_tmu_read(struct exynos_tmu_data *data)
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

