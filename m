Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505AbaIRP3m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 11:29:42 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:29257 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932464AbaIRP3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 11:29:38 -0400
X-AuditID: cbfee61a-f79e46d00000134f-92-541afa60217a
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 19/33] thermal: exynos: add get_con_reg() helper
Date: Thu, 18 Sep 2014 17:27:36 +0200
Message-id: <1411054070-25757-20-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1411054070-25757-1-git-send-email-b.zolnierkie@samsung.com>
References: <1411054070-25757-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDLMWRmVeSWpSXmKPExsVy+t9jAd2EX1IhBi8PG1o0XA2x2DhjPavF
	3eeHGS3mX7nGanG26Q27xZuHmxktLu+aw2bxufcIo8WM8/uYLJ487GNz4PLYOesuu8fiPS+Z
	PPq2rGL0+LxJLoAlissmJTUnsyy1SN8ugSvj7L7ZjAWfBCt2bc9pYJzP38XIySEhYCLRv2UK
	C4QtJnHh3nq2LkYuDiGBRYwSO3oWskA4XUwSGxo6mECq2ASsJCa2r2IEsUUEtCROXNrOBFLE
	LHCLSeL1jclgCWEBB4mOT4fAGlgEVCW+bZnB3MXIwcEr4CnR/0AHYpuiRPezCWwgNidQuOHW
	JnYQW0jAQ6Jty13mCYy8CxgZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEh9kzqR2MKxss
	DjEKcDAq8fAe4JUKEWJNLCuuzD3EKMHBrCTC++cjUIg3JbGyKrUoP76oNCe1+BCjNAeLkjjv
	gVbrQCGB9MSS1OzU1ILUIpgsEwenVAMjb8+9dwwHdd8dX52RfmT+yikmDpnaeifrtrnE33ml
	r8C1q95no9LtlWeSIo71lStan3Dd0N24+qv2DoY9mxweHLzDKdZxUfDq4869LE1RW+7+Pqz0
	JtHo0gWeyb+vGtVoTI07btdvvb5GNpejne0f77/uWzfqHtxKXJqYvLE/STTY8If8Sc19SizF
	GYmGWsxFxYkADuE/+i8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out code for preparing TMU_CONTROL register value from
exynos_tmu_control() into get_con_reg().

This is a preparation for introducing per-SoC type tmu_control
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
 drivers/thermal/samsung/exynos_tmu.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 8dc5bf6..785a584 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -180,17 +180,9 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 	return ret;
 }
 
-static void exynos_tmu_control(struct platform_device *pdev, bool on)
+static u32 get_con_reg(struct exynos_tmu_data *data, u32 con)
 {
-	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
 	struct exynos_tmu_platform_data *pdata = data->pdata;
-	const struct exynos_tmu_registers *reg = pdata->registers;
-	unsigned int con, interrupt_en;
-
-	mutex_lock(&data->lock);
-	clk_enable(data->clk);
-
-	con = readl(data->base + reg->tmu_ctrl);
 
 	if (pdata->test_mux)
 		con |= (pdata->test_mux << EXYNOS4412_MUX_ADDR_SHIFT);
@@ -206,6 +198,21 @@ static void exynos_tmu_control(struct platform_device *pdev, bool on)
 		con |= (pdata->noise_cancel_mode << EXYNOS_TMU_TRIP_MODE_SHIFT);
 	}
 
+	return con;
+}
+
+static void exynos_tmu_control(struct platform_device *pdev, bool on)
+{
+	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
+	struct exynos_tmu_platform_data *pdata = data->pdata;
+	const struct exynos_tmu_registers *reg = pdata->registers;
+	unsigned int con, interrupt_en;
+
+	mutex_lock(&data->lock);
+	clk_enable(data->clk);
+
+	con = get_con_reg(data, readl(data->base + reg->tmu_ctrl));
+
 	if (on) {
 		con |= (1 << EXYNOS_TMU_CORE_EN_SHIFT);
 		interrupt_en =
-- 
1.8.2.3

