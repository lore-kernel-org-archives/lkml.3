Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457Ab3FQGvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 02:51:16 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:53144 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132Ab3FQGsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 02:48:46 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.kachhap@gmail.com, Kukjin Kim <kgene.kim@samsung.com>,
        jonghwa3.lee@samsung.com
Subject: [PATCH V6 22/30] thermal: exynos: Add support to access common register for multistance
Date: Mon, 17 Jun 2013 12:16:31 +0530
Message-Id: <1371451599-31035-23-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1371451599-31035-1-git-send-email-amit.daniel@samsung.com>
References: <1371451599-31035-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support to parse one more common set of TMU register. First
set of register belongs to each instance of TMU and second set belongs to
common TMU registers.

Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 .../devicetree/bindings/thermal/exynos-thermal.txt |    6 +++++-
 drivers/thermal/samsung/exynos_tmu.c               |   20 ++++++++++++++++++++
 2 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
index 535fd0e..0ea33f7 100644
--- a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
+++ b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
@@ -7,7 +7,11 @@
 	       "samsung,exynos4210-tmu"
 	       "samsung,exynos5250-tmu"
 - interrupt-parent : The phandle for the interrupt controller
-- reg : Address range of the thermal registers
+- reg : Address range of the thermal registers. For soc's which has multiple
+	instances of TMU and some registers are shared across all TMU's like
+	interrupt related then 2 set of register has to supplied. First set
+	belongs	to each instance of TMU and second set belongs to common TMU
+	registers.
 - interrupts : Should contain interrupt for thermal system
 - clocks : The main clock for TMU device
 - clock-names : Thermal system clock name
diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 877dab8..150a869 100644
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
@@ -478,6 +480,24 @@ static int exynos_map_dt_data(struct platform_device *pdev)
 		return -ENODEV;
 	}
 	data->pdata = pdata;
+	/*
+	 * Check if the TMU shares some registers and then try to map the
+	 * memory of common registers.
+	 */
+	if (!TMU_SUPPORTS(pdata, SHARED_MEMORY))
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
 
 	return 0;
 }
-- 
1.7.1

