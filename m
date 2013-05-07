Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932618Ab3EGNCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:02:51 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:51151 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932393Ab3EGNCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:02:47 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org
Cc: Zhang Rui <rui.zhang@intel.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, amit.kachhap@gmail.com,
        Kukjin Kim <kgene.kim@samsung.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH V3 15/21] thermal: exynos: Add support to handle many instances of TMU
Date: Tue,  7 May 2013 18:31:05 +0530
Message-Id: <1367931671-3906-16-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1367931671-3906-1-git-send-email-amit.daniel@samsung.com>
References: <1367931671-3906-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support to handle multiple instances of the TMU controllers.
This is done by removing the static structure to register with the core thermal
and creating it dynamically for each instance of the TMU controller. The
interrupt is made shared type to handle interrupts for all the TMU. Also
the identifier of the TMU controller is extracted from device tree alias.

Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c |  125 +++++++++++++++++++++++-----------
 1 files changed, 84 insertions(+), 41 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index bdf40ef..94d6e8e 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -29,6 +29,8 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/workqueue.h>
@@ -36,9 +38,24 @@
 #include "exynos_tmu.h"
 #include "exynos_tmu_data.h"
 
+/**
+ * struct exynos_tmu_data : A structure to hold the private data of the TMU
+	driver
+ * @id: identifier of the one instance of the TMU controller.
+ * @pdata: pointer to the tmu platform/configuration data
+ * @base: base address of the single instance of the TMU controller.
+ * @irq: irq number of the TMU controller.
+ * @soc: id of the SOC type.
+ * @irq_work: pointer to the irq work structure.
+ * @lock: lock to implement synchronization.
+ * @clk: pointer to the clock structure.
+ * @temp_error1: fused value of the first point trim.
+ * @temp_error2: fused value of the second point trim.
+ * @reg_conf: pointer to structure to register with core thermal.
+ */
 struct exynos_tmu_data {
+	int id;
 	struct exynos_tmu_platform_data *pdata;
-	struct resource *mem;
 	void __iomem *base;
 	int irq;
 	enum soc_type soc;
@@ -46,6 +63,7 @@ struct exynos_tmu_data {
 	struct mutex lock;
 	struct clk *clk;
 	u8 temp_error1, temp_error2;
+	struct thermal_sensor_conf *reg_conf;
 };
 
 /*
@@ -319,12 +337,6 @@ static int exynos_tmu_set_emulation(void *drv_data,	unsigned long temp)
 	{ return -EINVAL; }
 #endif/*CONFIG_THERMAL_EMULATION*/
 
-static struct thermal_sensor_conf exynos_sensor_conf = {
-	.name			= "exynos-therm",
-	.read_temperature	= (int (*)(void *))exynos_tmu_read,
-	.write_emul_temp	= exynos_tmu_set_emulation,
-};
-
 static void exynos_tmu_work(struct work_struct *work)
 {
 	struct exynos_tmu_data *data = container_of(work,
@@ -333,7 +345,7 @@ static void exynos_tmu_work(struct work_struct *work)
 	struct exynos_tmu_registers *reg = pdata->registers;
 	unsigned int val_irq;
 
-	exynos_report_trigger(&exynos_sensor_conf);
+	exynos_report_trigger(data->reg_conf);
 	mutex_lock(&data->lock);
 	clk_enable(data->clk);
 
@@ -405,10 +417,42 @@ static inline struct  exynos_tmu_platform_data *exynos_get_driver_data(
 			platform_get_device_id(pdev)->driver_data;
 }
 
+static int exynos_map_dt_data(struct platform_device *pdev)
+{
+	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
+	struct resource res;
+
+	if (!data)
+		return -ENODEV;
+
+	data->id = of_alias_get_id(pdev->dev.of_node, "tmuctrl");
+	if (data->id < 0)
+		data->id = 0;
+
+	data->irq = irq_of_parse_and_map(pdev->dev.of_node, 0);
+	if (data->irq <= 0) {
+		dev_err(&pdev->dev, "failed to get IRQ\n");
+		return -ENODEV;
+	}
+
+	if (of_address_to_resource(pdev->dev.of_node, 0, &res)) {
+		dev_err(&pdev->dev, "failed to get Resource\n");
+		return -ENODEV;
+	}
+
+	data->base = devm_ioremap(&pdev->dev, res.start, resource_size(&res));
+	if (!data->base) {
+		dev_err(&pdev->dev, "Failed to ioremap memory\n");
+		return -ENOMEM;
+	}
+	return 0;
+}
+
 static int exynos_tmu_probe(struct platform_device *pdev)
 {
 	struct exynos_tmu_data *data;
 	struct exynos_tmu_platform_data *pdata = pdev->dev.platform_data;
+	struct thermal_sensor_conf *sensor_conf;
 	int ret, i;
 
 	if (!pdata)
@@ -425,26 +469,17 @@ static int exynos_tmu_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	data->irq = platform_get_irq(pdev, 0);
-	if (data->irq < 0) {
-		dev_err(&pdev->dev, "Failed to get platform irq\n");
-		return data->irq;
-	}
-
-	INIT_WORK(&data->irq_work, exynos_tmu_work);
-
-	data->mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!data->mem) {
-		dev_err(&pdev->dev, "Failed to get platform resource\n");
-		return -ENOENT;
-	}
+	data->pdata = pdata;
+	platform_set_drvdata(pdev, data);
+	mutex_init(&data->lock);
 
-	data->base = devm_ioremap_resource(&pdev->dev, data->mem);
-	if (IS_ERR(data->base))
-		return PTR_ERR(data->base);
+	ret = exynos_map_dt_data(pdev);
+	if (ret)
+		return ret;
 
+	INIT_WORK(&data->irq_work, exynos_tmu_work);
 	ret = devm_request_irq(&pdev->dev, data->irq, exynos_tmu_irq,
-		IRQF_TRIGGER_RISING, "exynos-tmu", data);
+		IRQF_TRIGGER_RISING | IRQF_SHARED, dev_name(&pdev->dev), data);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to request irq: %d\n", data->irq);
 		return ret;
@@ -469,10 +504,6 @@ static int exynos_tmu_probe(struct platform_device *pdev)
 		goto err_clk;
 	}
 
-	data->pdata = pdata;
-	platform_set_drvdata(pdev, data);
-	mutex_init(&data->lock);
-
 	ret = exynos_tmu_initialize(pdev);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to initialize TMU\n");
@@ -481,28 +512,40 @@ static int exynos_tmu_probe(struct platform_device *pdev)
 
 	exynos_tmu_control(pdev, true);
 
-	/* Register the sensor with thermal management interface */
-	(&exynos_sensor_conf)->driver_data = data;
-	exynos_sensor_conf.trip_data.trip_count = pdata->trigger_enable[0] +
+	/* Allocate a structure to register with the exynos core thermal */
+	sensor_conf = devm_kzalloc(&pdev->dev,
+				sizeof(struct thermal_sensor_conf), GFP_KERNEL);
+	if (!sensor_conf) {
+		dev_err(&pdev->dev, "Failed to allocate registration struct\n");
+		ret = -ENOMEM;
+		goto err_clk;
+	}
+	data->reg_conf = sensor_conf;
+	sprintf(sensor_conf->name, "therm_zone%d", data->id);
+	sensor_conf->read_temperature = (int (*)(void *))exynos_tmu_read;
+	sensor_conf->write_emul_temp =
+		(int (*)(void *, unsigned long))exynos_tmu_set_emulation;
+	sensor_conf->driver_data = data;
+	sensor_conf->trip_data.trip_count = pdata->trigger_enable[0] +
 			pdata->trigger_enable[1] + pdata->trigger_enable[2]+
 			pdata->trigger_enable[3];
 
-	for (i = 0; i < exynos_sensor_conf.trip_data.trip_count; i++)
-		exynos_sensor_conf.trip_data.trip_val[i] =
+	for (i = 0; i < sensor_conf->trip_data.trip_count; i++)
+		sensor_conf->trip_data.trip_val[i] =
 			pdata->threshold + pdata->trigger_levels[i];
 
-	exynos_sensor_conf.trip_data.trigger_falling = pdata->threshold_falling;
+	sensor_conf->trip_data.trigger_falling = pdata->threshold_falling;
 
-	exynos_sensor_conf.cooling_data.freq_clip_count =
-						pdata->freq_tab_count;
+	sensor_conf->cooling_data.freq_clip_count = pdata->freq_tab_count;
 	for (i = 0; i < pdata->freq_tab_count; i++) {
-		exynos_sensor_conf.cooling_data.freq_data[i].freq_clip_max =
+		sensor_conf->cooling_data.freq_data[i].freq_clip_max =
 					pdata->freq_tab[i].freq_clip_max;
-		exynos_sensor_conf.cooling_data.freq_data[i].temp_level =
+		sensor_conf->cooling_data.freq_data[i].temp_level =
 					pdata->freq_tab[i].temp_level;
 	}
 
-	ret = exynos_register_thermal(&exynos_sensor_conf);
+	/* Register the sensor with thermal management interface */
+	ret = exynos_register_thermal(sensor_conf);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to register thermal interface\n");
 		goto err_clk;
@@ -521,7 +564,7 @@ static int exynos_tmu_remove(struct platform_device *pdev)
 
 	exynos_tmu_control(pdev, false);
 
-	exynos_unregister_thermal(&exynos_sensor_conf);
+	exynos_unregister_thermal(data->reg_conf);
 
 	clk_unprepare(data->clk);
 
-- 
1.7.1

