Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab3FXKym (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 06:54:42 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:46389 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab3FXKwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 06:52:50 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.kachhap@gmail.com, Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH V7 24/30] thermal: exynos: Fix to set the second point correction value
Date: Mon, 24 Jun 2013 16:20:45 +0530
Message-Id: <1372071051-3167-25-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1372071051-3167-1-git-send-email-amit.daniel@samsung.com>
References: <1372071051-3167-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch sets the second point trimming value according to the platform
data if the register value is 0.

Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Acked-by: Eduardo Valentin <eduardo.valentin@ti.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 651f460..3fac0f9 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -180,10 +180,15 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 	data->temp_error2 = ((trim_info >> reg->triminfo_85_shift) &
 				EXYNOS_TMU_TEMP_MASK);
 
-	if ((pdata->min_efuse_value > data->temp_error1) ||
-			(data->temp_error1 > pdata->max_efuse_value) ||
-			(data->temp_error2 != 0))
-		data->temp_error1 = pdata->efuse_value;
+	if (!data->temp_error1 ||
+		(pdata->min_efuse_value > data->temp_error1) ||
+		(data->temp_error1 > pdata->max_efuse_value))
+		data->temp_error1 = pdata->efuse_value & EXYNOS_TMU_TEMP_MASK;
+
+	if (!data->temp_error2)
+		data->temp_error2 =
+			(pdata->efuse_value >> reg->triminfo_85_shift) &
+			EXYNOS_TMU_TEMP_MASK;
 
 	if (pdata->max_trigger_level > MAX_THRESHOLD_LEVS) {
 		dev_err(&pdev->dev, "Invalid max trigger level\n");
-- 
1.7.1

