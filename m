Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615Ab3FQGtD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 02:49:03 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:32805 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932537Ab3FQGs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 02:48:59 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.kachhap@gmail.com, Kukjin Kim <kgene.kim@samsung.com>,
        jonghwa3.lee@samsung.com
Subject: [PATCH V6 25/30] thermal: exynos: Fix to set the second point correction value
Date: Mon, 17 Jun 2013 12:16:34 +0530
Message-Id: <1371451599-31035-26-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1371451599-31035-1-git-send-email-amit.daniel@samsung.com>
References: <1371451599-31035-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch sets the second point trimming value according to the platform
data if the register value is 0.

Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index a4dbc84..af0e6ca 100644
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

