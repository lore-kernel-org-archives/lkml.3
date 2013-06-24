Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab3FXKxD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 06:53:03 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:50468 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321Ab3FXKw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 06:52:59 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.kachhap@gmail.com, Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH V7 26/30] thermal: exynos: Support for TMU regulator defined at device tree
Date: Mon, 24 Jun 2013 16:20:47 +0530
Message-Id: <1372071051-3167-27-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1372071051-3167-1-git-send-email-amit.daniel@samsung.com>
References: <1372071051-3167-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TMU probe function now checks for a device tree defined regulator.
For compatibility reasons it is allowed to probe driver even without
this regulator defined.

Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Acked-by: Eduardo Valentin <eduardo.valentin@ti.com>
Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 34b999b..80d1786 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -29,6 +29,7 @@
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 #include <linux/platform_device.h>
+#include <linux/regulator/consumer.h>
 
 #include "exynos_thermal_common.h"
 #include "exynos_tmu.h"
@@ -48,6 +49,7 @@
  * @clk: pointer to the clock structure.
  * @temp_error1: fused value of the first point trim.
  * @temp_error2: fused value of the second point trim.
+ * @regulator: pointer to the TMU regulator structure.
  * @reg_conf: pointer to structure to register with core thermal.
  */
 struct exynos_tmu_data {
@@ -61,6 +63,7 @@ struct exynos_tmu_data {
 	struct mutex lock;
 	struct clk *clk;
 	u8 temp_error1, temp_error2;
+	struct regulator *regulator;
 	struct thermal_sensor_conf *reg_conf;
 };
 
@@ -511,10 +514,27 @@ static int exynos_map_dt_data(struct platform_device *pdev)
 	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
 	struct exynos_tmu_platform_data *pdata;
 	struct resource res;
+	int ret;
 
 	if (!data)
 		return -ENODEV;
 
+	/*
+	 * Try enabling the regulator if found
+	 * TODO: Add regulator as an SOC feature, so that regulator enable
+	 * is a compulsory call.
+	 */
+	data->regulator = devm_regulator_get(&pdev->dev, "vtmu");
+	if (!IS_ERR(data->regulator)) {
+		ret = regulator_enable(data->regulator);
+		if (ret) {
+			dev_err(&pdev->dev, "failed to enable vtmu\n");
+			return ret;
+		}
+	} else {
+		dev_info(&pdev->dev, "Regulator node (vtmu) not found\n");
+	}
+
 	data->id = of_alias_get_id(pdev->dev.of_node, "tmuctrl");
 	if (data->id < 0)
 		data->id = 0;
@@ -682,6 +702,9 @@ static int exynos_tmu_remove(struct platform_device *pdev)
 
 	clk_unprepare(data->clk);
 
+	if (!IS_ERR(data->regulator))
+		regulator_disable(data->regulator);
+
 	return 0;
 }
 
-- 
1.7.1

