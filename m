Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243Ab3ENKBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 06:01:05 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:40064 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932218Ab3ENKBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 06:01:00 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org
Cc: Zhang Rui <rui.zhang@intel.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, amit.kachhap@gmail.com,
        Kukjin Kim <kgene.kim@samsung.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH V4 21/30] thermal: exynos: Add support to access common register for multistance
Date: Tue, 14 May 2013 15:28:51 +0530
Message-Id: <1368525540-15034-22-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1368525540-15034-1-git-send-email-amit.daniel@samsung.com>
References: <1368525540-15034-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support to parse one more common set of TMU register. First
set of register belongs to each instance of TMU and second set belongs to
common TMU registers.

Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c |   24 +++++++++++++++++++++++-
 1 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index e627150..7f7b1cf 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -40,6 +40,7 @@
  * @id: identifier of the one instance of the TMU controller.
  * @pdata: pointer to the tmu platform/configuration data
  * @base: base address of the single instance of the TMU controller.
+ * @base_common: base address of the common registers of the TMU controller.
  * @irq: irq number of the TMU controller.
  * @soc: id of the SOC type.
  * @irq_work: pointer to the irq work structure.
@@ -53,6 +54,7 @@ struct exynos_tmu_data {
 	int id;
 	struct exynos_tmu_platform_data *pdata;
 	void __iomem *base;
+	void __iomem *base_common;
 	int irq;
 	enum soc_type soc;
 	struct work_struct irq_work;
@@ -421,6 +423,7 @@ static inline struct  exynos_tmu_platform_data *exynos_get_driver_data(
 static int exynos_map_dt_data(struct platform_device *pdev)
 {
 	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
+	struct exynos_tmu_platform_data *pdata = data->pdata;
 	struct resource res;
 
 	if (!data)
@@ -437,7 +440,7 @@ static int exynos_map_dt_data(struct platform_device *pdev)
 	}
 
 	if (of_address_to_resource(pdev->dev.of_node, 0, &res)) {
-		dev_err(&pdev->dev, "failed to get Resource\n");
+		dev_err(&pdev->dev, "failed to get Resource 0\n");
 		return -ENODEV;
 	}
 
@@ -447,6 +450,25 @@ static int exynos_map_dt_data(struct platform_device *pdev)
 		return -EADDRNOTAVAIL;
 	}
 
+	/*
+	 * Check if the TMU is multi instance type and then try to map the
+	 * memory of common registers.
+	 */
+	if (!TMU_SUPPORTS(pdata, MULTI_INST))
+		return 0;
+
+	if (of_address_to_resource(pdev->dev.of_node, 1, &res)) {
+		dev_err(&pdev->dev, "failed to get Resource 1\n");
+		return -ENODEV;
+	}
+
+	data->base_common = devm_ioremap(&pdev->dev, res.start,
+					resource_size(&res));
+	if (!data->base) {
+		dev_err(&pdev->dev, "Failed to ioremap memory\n");
+		return -ENOMEM;
+	}
+
 	return 0;
 }
 
-- 
1.7.1

