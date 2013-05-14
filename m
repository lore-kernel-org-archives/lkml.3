Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262Ab3ENKBM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 06:01:12 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:54319 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132Ab3ENKBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 06:01:08 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org
Cc: Zhang Rui <rui.zhang@intel.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, amit.kachhap@gmail.com,
        Kukjin Kim <kgene.kim@samsung.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH V4 23/30] thermal: exynos: Fix to set the second point correction value properly
Date: Tue, 14 May 2013 15:28:53 +0530
Message-Id: <1368525540-15034-24-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1368525540-15034-1-git-send-email-amit.daniel@samsung.com>
References: <1368525540-15034-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch sets the second point trimming value according to the platform
data if the register value is 0.

Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 7ca9c4d..28804a5 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -161,10 +161,15 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
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
 
 	/* Count trigger levels to be enabled */
 	for (i = 0; i < MAX_THRESHOLD_LEVS; i++)
-- 
1.7.1

