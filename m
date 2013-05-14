Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224Ab3ENKBX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 06:01:23 -0400
Received: from mail-da0-f42.google.com ([209.85.210.42]:51223 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932281Ab3ENKBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 06:01:17 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org
Cc: Zhang Rui <rui.zhang@intel.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, amit.kachhap@gmail.com,
        Kukjin Kim <kgene.kim@samsung.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH V4 25/30] thermal: exynos: Add a compensation logic on swapped e-fuse values
Date: Tue, 14 May 2013 15:28:55 +0530
Message-Id: <1368525540-15034-26-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1368525540-15034-1-git-send-email-amit.daniel@samsung.com>
References: <1368525540-15034-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds compensation logic on swapped e-fuse values with boundary
conditions. Currently, e-fused trim values for sensor0 is swapped with
sensor2 so the logic in this patch is needed. sensor1 e-fused trim value is
correct.

Signed-off-by: Jungseok Lee <jays.lee@samsung.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c      |   23 +++++++++++++++++++++--
 drivers/thermal/samsung/exynos_tmu_data.h |    1 +
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 671061b..f32d275 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -137,7 +137,7 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
 	struct exynos_tmu_platform_data *pdata = data->pdata;
 	const struct exynos_tmu_registers *reg = pdata->registers;
-	unsigned int status, trim_info, con;
+	unsigned int status, trim_info = 0, con;
 	unsigned int rising_threshold = 0, falling_threshold = 0;
 	int ret = 0, threshold_code, i, trigger_levs = 0;
 
@@ -156,7 +156,26 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 		__raw_writel(1, data->base + reg->triminfo_ctrl);
 
 	/* Save trimming info in order to perform calibration */
-	trim_info = readl(data->base + reg->triminfo_data);
+	if (data->soc == SOC_ARCH_EXYNOS5440) {
+		/*
+		 * For exynos5440 soc triminfo value is swapped between TMU0 and
+		 * TMU2, so the below logic is needed.
+		 */
+		switch (data->id) {
+		case 0:
+			trim_info = readl(data->base +
+			EXYNOS5440_EFUSE_SWAP_OFFSET + reg->triminfo_data);
+			break;
+		case 1:
+			trim_info = readl(data->base + reg->triminfo_data);
+			break;
+		case 2:
+			trim_info = readl(data->base -
+			EXYNOS5440_EFUSE_SWAP_OFFSET + reg->triminfo_data);
+		}
+	} else {
+		trim_info = readl(data->base + reg->triminfo_data);
+	}
 	data->temp_error1 = trim_info & EXYNOS_TMU_TEMP_MASK;
 	data->temp_error2 = ((trim_info >> reg->triminfo_85_shift) &
 				EXYNOS_TMU_TEMP_MASK);
diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
index eb7250d..a1cc8ab 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.h
+++ b/drivers/thermal/samsung/exynos_tmu_data.h
@@ -127,6 +127,7 @@
 #define EXYNOS5440_TMU_TH_RISE2_SHIFT		16
 #define EXYNOS5440_TMU_TH_RISE3_SHIFT		24
 #define EXYNOS5440_TMU_TH_RISE4_SHIFT		24
+#define EXYNOS5440_EFUSE_SWAP_OFFSET		8
 
 #if defined(CONFIG_CPU_EXYNOS4210)
 extern struct exynos_tmu_platform_data const exynos4210_default_tmu_data;
-- 
1.7.1

