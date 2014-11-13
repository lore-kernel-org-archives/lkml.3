Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933629AbaKMPHS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 10:07:18 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:41178 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933164AbaKMPHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 10:07:14 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-4c-5464c921df7e
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH v2 30/33] thermal: exynos: remove test_mux pdata field
Date: Thu, 13 Nov 2014 16:01:25 +0100
Message-id: <1415890888-8881-31-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
References: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOLMWRmVeSWpSXmKPExsVy+t9jQV3FkykhBsd+Clg0XA2x2DhjPavF
	/CvXWC3ONr1ht3jzcDOjxeVdc9gsPvceYbSYcX4fk8WTh31sDpweO2fdZfdYvOclk0ffllWM
	Hp83yQWwRHHZpKTmZJalFunbJXBlfPpzhq1gr0RF2/adLA2M10S6GDk5JARMJJ4v+s8GYYtJ
	XLi3Hsjm4hASmM4oMfXNWyaQhJBAF5PEr1+lIDabgJXExPZVjCC2iICWxIlL25lAGpgFljFJ
	XPo2H8jh4BAWcJN4fYALpIZFQFXi6O9d7CA2r4CHxNdDTUwQyxQlup9NAFvMCRR/NfUvI8Qu
	d4lrj94xT2DkXcDIsIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOLieSe9gXNVgcYhRgINR
	iYf3BUtKiBBrYllxZe4hRgkOZiURXu/DQCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8B1utA4UE
	0hNLUrNTUwtSi2CyTBycUg2M/Yv9Ni5/5/Yoag73leeZZqa1KX8yH92VVViStqlQYc70Wqtt
	6jevPz7KGjrDZpOTunn4/wtWXYGNXz11HQPnyVRs/qIlJ+VzX22L9R3HBawSzzcem9yq3v9/
	ww23awoOxZxR8p/MUt0TzwuXH7j+JWjajfI8dof/e+6Hs33ZsFCMt4N731RxJZbijERDLeai
	4kQAfubW7SoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace pdata->test_mux check in get_con_reg() by explicitly
checking for SoC type.

Also since the used pdata->test_mux value is always identical
use it directly and remove pdata->test_mux completely.

There should be no functional changes caused by this patch.

Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c      | 5 +++--
 drivers/thermal/samsung/exynos_tmu.h      | 2 --
 drivers/thermal/samsung/exynos_tmu_data.c | 2 --
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 65eeecc..2fcb4cd 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -193,8 +193,9 @@ static u32 get_con_reg(struct exynos_tmu_data *data, u32 con)
 {
 	struct exynos_tmu_platform_data *pdata = data->pdata;
 
-	if (pdata->test_mux)
-		con |= (pdata->test_mux << EXYNOS4412_MUX_ADDR_SHIFT);
+	if (data->soc == SOC_ARCH_EXYNOS4412 ||
+	    data->soc == SOC_ARCH_EXYNOS3250)
+		con |= (EXYNOS4412_MUX_ADDR_VALUE << EXYNOS4412_MUX_ADDR_SHIFT);
 
 	con &= ~(EXYNOS_TMU_REF_VOLTAGE_MASK << EXYNOS_TMU_REF_VOLTAGE_SHIFT);
 	con |= pdata->reference_voltage << EXYNOS_TMU_REF_VOLTAGE_SHIFT;
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index 2eb4cb9..8de0f82 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -89,7 +89,6 @@ enum soc_type {
  * @first_point_trim: temp value of the first point trimming
  * @second_point_trim: temp value of the second point trimming
  * @default_temp_offset: default temperature offset in case of no trimming
- * @test_mux; information if SoC supports test MUX
  * @cal_type: calibration type for temperature
  * @freq_clip_table: Table representing frequency reduction percentage.
  * @freq_tab_count: Count of the above table as frequency reduction may
@@ -115,7 +114,6 @@ struct exynos_tmu_platform_data {
 	u8 first_point_trim;
 	u8 second_point_trim;
 	u8 default_temp_offset;
-	u8 test_mux;
 
 	enum calibration_type cal_type;
 	enum soc_type type;
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index d90b050..708c3e1 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -109,7 +109,6 @@ struct exynos_tmu_init_data const exynos3250_default_tmu_data = {
 		{
 			EXYNOS3250_TMU_DATA,
 			.type = SOC_ARCH_EXYNOS3250,
-			.test_mux = EXYNOS4412_MUX_ADDR_VALUE,
 		},
 	},
 	.tmu_count = 1,
@@ -160,7 +159,6 @@ struct exynos_tmu_init_data const exynos4412_default_tmu_data = {
 		{
 			EXYNOS4412_TMU_DATA,
 			.type = SOC_ARCH_EXYNOS4412,
-			.test_mux = EXYNOS4412_MUX_ADDR_VALUE,
 		},
 	},
 	.tmu_count = 1,
-- 
1.8.2.3

