Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932777Ab3DZKiv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 06:38:51 -0400
Received: from mail-da0-f50.google.com ([209.85.210.50]:55311 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760034Ab3DZKio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 06:38:44 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org
Cc: Zhang Rui <rui.zhang@intel.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, amit.kachhap@gmail.com,
        Kukjin Kim <kgene.kim@samsung.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH V2 08/20] thermal: exynos: Support thermal tripping
Date: Fri, 26 Apr 2013 16:07:39 +0530
Message-Id: <1366972671-9227-9-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1366972671-9227-1-git-send-email-amit.daniel@samsung.com>
References: <1366972671-9227-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TMU urgently sends active-high signal (thermal trip) to PMU, and thermal
tripping by hardware logic. Thermal tripping means that PMU cuts off the
whole power of SoC by controlling external voltage regulator.

Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c      |    8 +++++++-
 drivers/thermal/samsung/exynos_tmu_data.c |    2 ++
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 77b6a37..23baeeb 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -88,6 +88,7 @@
 #define EXYNOS_TMU_CLEAR_FALL_INT	(0x111 << 12)
 #define EXYNOS_TMU_TRIP_MODE_SHIFT	13
 #define EXYNOS_TMU_TRIP_MODE_MASK	0x7
+#define EXYNOS_TMU_THERM_TRIP_EN_SHIFT	12
 
 #define EXYNOS_TMU_INTEN_RISE0_SHIFT	0
 #define EXYNOS_TMU_INTEN_RISE1_SHIFT	4
@@ -190,7 +191,7 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 {
 	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
 	struct exynos_tmu_platform_data *pdata = data->pdata;
-	unsigned int status, trim_info;
+	unsigned int status, trim_info, con;
 	unsigned int rising_threshold = 0, falling_threshold = 0;
 	int ret = 0, threshold_code, i, trigger_levs = 0;
 
@@ -255,6 +256,11 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 					falling_threshold |=
 						threshold_code << 8 * i;
 			}
+			if (pdata->trigger_type[i] != HW_TRIP)
+				continue;
+			con = readl(data->base + EXYNOS_TMU_REG_CONTROL);
+			con |= (1 << EXYNOS_TMU_THERM_TRIP_EN_SHIFT);
+			writel(con, data->base + EXYNOS_TMU_REG_CONTROL);
 		}
 
 		writel(rising_threshold,
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index ee6a3c9..6b937f5 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -64,6 +64,7 @@ struct exynos_tmu_platform_data const exynos5250_default_tmu_data = {
 	.trigger_levels[0] = 85,
 	.trigger_levels[1] = 103,
 	.trigger_levels[2] = 110,
+	.trigger_levels[3] = 120,
 	.trigger_enable[0] = 1,
 	.trigger_enable[1] = 1,
 	.trigger_enable[2] = 1,
@@ -71,6 +72,7 @@ struct exynos_tmu_platform_data const exynos5250_default_tmu_data = {
 	.trigger_type[0] = 0,
 	.trigger_type[1] = 0,
 	.trigger_type[2] = 1,
+	.trigger_type[3] = 2,
 	.gain = 8,
 	.reference_voltage = 16,
 	.noise_cancel_mode = 4,
-- 
1.7.1

