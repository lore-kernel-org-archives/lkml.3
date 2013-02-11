Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080Ab3BKDyp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 22:54:45 -0500
Received: from mail-yh0-f45.google.com ([209.85.213.45]:36884 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab3BKDyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 22:54:43 -0500
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com
Subject: [PATCH V3] thermal: exynos: Adapt to temperature emulation core thermal framework
Date: Sun, 10 Feb 2013 19:54:23 -0800
Message-Id: <1360554863-25285-1-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the driver specific sysfs support of the temperature
emulation and uses the newly added core thermal framework for thermal
emulation. An exynos platform specific handler is added to support this.

In this patch, the exynos senor(tmu) related code and exynos framework
related (thermal zone, cooling devices) code are intentionally kept separate.
So an emulated function pointer is passed from sensor to framework. This is
beneficial in adding more sensor support using the same framework code
which is an ongoing work. The goal is to finally split them totally. Even
the existing read_temperature also follows the same execution method.

Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
Changes in V3:
* Added an invalid return from function when CONFIG_THERMAL_EMULATION
  is not defined.
* Added more details in the patch description.
 
Changes in V2:
* Added config option CONFIG_THERMAL_EMULATION instead of
 CONFIG_EXYNOS_THERMAL_EMUL 

This patchset is based on thermal maintainer next tree.
git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git next 

 Documentation/thermal/exynos_thermal_emulation |    8 +-
 drivers/thermal/Kconfig                        |    9 --
 drivers/thermal/exynos_thermal.c               |  158 ++++++++++--------------
 3 files changed, 67 insertions(+), 108 deletions(-)

diff --git a/Documentation/thermal/exynos_thermal_emulation b/Documentation/thermal/exynos_thermal_emulation
index b73bbfb..36a3e79 100644
--- a/Documentation/thermal/exynos_thermal_emulation
+++ b/Documentation/thermal/exynos_thermal_emulation
@@ -13,11 +13,11 @@ Thermal emulation mode supports software debug for TMU's operation. User can set
 manually with software code and TMU will read current temperature from user value not from
 sensor's value.
 
-Enabling CONFIG_EXYNOS_THERMAL_EMUL option will make this support in available.
-When it's enabled, sysfs node will be created under
-/sys/bus/platform/devices/'exynos device name'/ with name of 'emulation'.
+Enabling CONFIG_THERMAL_EMULATION option will make this support available.
+When it's enabled, sysfs node will be created as
+/sys/devices/virtual/thermal/thermal_zone'zone id'/emul_temp.
 
-The sysfs node, 'emulation', will contain value 0 for the initial state. When you input any
+The sysfs node, 'emul_node', will contain value 0 for the initial state. When you input any
 temperature you want to update to sysfs node, it automatically enable emulation mode and
 current temperature will be changed into it.
 (Exynos also supports user changable delay time which would be used to delay of
diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index a764f16..da4c19e 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -117,15 +117,6 @@ config EXYNOS_THERMAL
 	  If you say yes here you get support for TMU (Thermal Management
 	  Unit) on SAMSUNG EXYNOS series of SoC.
 
-config EXYNOS_THERMAL_EMUL
-	bool "EXYNOS TMU emulation mode support"
-	depends on EXYNOS_THERMAL
-	help
-	  Exynos 4412 and 4414 and 5 series has emulation mode on TMU.
-	  Enable this option will be make sysfs node in exynos thermal platform
-	  device directory to support emulation mode. With emulation mode sysfs
-	  node, you can manually input temperature to TMU for simulation purpose.
-
 config DOVE_THERMAL
 	tristate "Temperature sensor on Marvell Dove SoCs"
 	depends on ARCH_DOVE
diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/exynos_thermal.c
index 64aa8b4..7ff62b0 100644
--- a/drivers/thermal/exynos_thermal.c
+++ b/drivers/thermal/exynos_thermal.c
@@ -100,13 +100,13 @@
 #define IDLE_INTERVAL 10000
 #define MCELSIUS	1000
 
-#ifdef CONFIG_EXYNOS_THERMAL_EMUL
+#ifdef CONFIG_THERMAL_EMULATION
 #define EXYNOS_EMUL_TIME	0x57F0
 #define EXYNOS_EMUL_TIME_SHIFT	16
 #define EXYNOS_EMUL_DATA_SHIFT	8
 #define EXYNOS_EMUL_DATA_MASK	0xFF
 #define EXYNOS_EMUL_ENABLE	0x1
-#endif /* CONFIG_EXYNOS_THERMAL_EMUL */
+#endif /* CONFIG_THERMAL_EMULATION */
 
 /* CPU Zone information */
 #define PANIC_ZONE      4
@@ -145,6 +145,7 @@ struct	thermal_cooling_conf {
 struct thermal_sensor_conf {
 	char name[SENSOR_NAME_LEN];
 	int (*read_temperature)(void *data);
+	int (*write_emul_temp)(void *drv_data, unsigned long temp);
 	struct thermal_trip_point_conf trip_data;
 	struct thermal_cooling_conf cooling_data;
 	void *private_data;
@@ -369,6 +370,23 @@ static int exynos_get_temp(struct thermal_zone_device *thermal,
 	return 0;
 }
 
+/* Get temperature callback functions for thermal zone */
+static int exynos_set_emul_temp(struct thermal_zone_device *thermal,
+						unsigned long temp)
+{
+	void *data;
+	int ret = -EINVAL;
+
+	if (!th_zone->sensor_conf) {
+		pr_info("Temperature sensor not initialised\n");
+		return -EINVAL;
+	}
+	data = th_zone->sensor_conf->private_data;
+	if (th_zone->sensor_conf->write_emul_temp)
+		ret = th_zone->sensor_conf->write_emul_temp(data, temp);
+	return ret;
+}
+
 /* Get the temperature trend */
 static int exynos_get_trend(struct thermal_zone_device *thermal,
 			int trip, enum thermal_trend *trend)
@@ -392,6 +410,7 @@ static struct thermal_zone_device_ops const exynos_dev_ops = {
 	.bind = exynos_bind,
 	.unbind = exynos_unbind,
 	.get_temp = exynos_get_temp,
+	.set_emul_temp = exynos_set_emul_temp,
 	.get_trend = exynos_get_trend,
 	.get_mode = exynos_get_mode,
 	.set_mode = exynos_set_mode,
@@ -714,6 +733,47 @@ static int exynos_tmu_read(struct exynos_tmu_data *data)
 	return temp;
 }
 
+#ifdef CONFIG_THERMAL_EMULATION
+static int exynos_tmu_set_emulation(void *drv_data, unsigned long temp)
+{
+	struct exynos_tmu_data *data = drv_data;
+	unsigned int reg;
+	int ret = -EINVAL;
+
+	if (data->soc == SOC_ARCH_EXYNOS4210)
+		goto out;
+
+	if (temp && temp < MCELSIUS)
+		goto out;
+
+	mutex_lock(&data->lock);
+	clk_enable(data->clk);
+
+	reg = readl(data->base + EXYNOS_EMUL_CON);
+
+	if (temp) {
+		temp /= MCELSIUS;
+
+		reg = (EXYNOS_EMUL_TIME << EXYNOS_EMUL_TIME_SHIFT) |
+			(temp_to_code(data, temp)
+			 << EXYNOS_EMUL_DATA_SHIFT) | EXYNOS_EMUL_ENABLE;
+	} else {
+		reg &= ~EXYNOS_EMUL_ENABLE;
+	}
+
+	writel(reg, data->base + EXYNOS_EMUL_CON);
+
+	clk_disable(data->clk);
+	mutex_unlock(&data->lock);
+	return 0;
+out:
+	return ret;
+}
+#else
+static int exynos_tmu_set_emulation(void *drv_data,	unsigned long temp)
+	{ return -EINVAL; }
+#endif/*CONFIG_THERMAL_EMULATION*/
+
 static void exynos_tmu_work(struct work_struct *work)
 {
 	struct exynos_tmu_data *data = container_of(work,
@@ -747,6 +807,7 @@ static irqreturn_t exynos_tmu_irq(int irq, void *id)
 static struct thermal_sensor_conf exynos_sensor_conf = {
 	.name			= "exynos-therm",
 	.read_temperature	= (int (*)(void *))exynos_tmu_read,
+	.write_emul_temp	= exynos_tmu_set_emulation,
 };
 
 #if defined(CONFIG_CPU_EXYNOS4210)
@@ -853,93 +914,6 @@ static inline struct  exynos_tmu_platform_data *exynos_get_driver_data(
 			platform_get_device_id(pdev)->driver_data;
 }
 
-#ifdef CONFIG_EXYNOS_THERMAL_EMUL
-static ssize_t exynos_tmu_emulation_show(struct device *dev,
-					 struct device_attribute *attr,
-					 char *buf)
-{
-	struct platform_device *pdev = container_of(dev,
-					struct platform_device, dev);
-	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
-	unsigned int reg;
-	u8 temp_code;
-	int temp = 0;
-
-	if (data->soc == SOC_ARCH_EXYNOS4210)
-		goto out;
-
-	mutex_lock(&data->lock);
-	clk_enable(data->clk);
-	reg = readl(data->base + EXYNOS_EMUL_CON);
-	clk_disable(data->clk);
-	mutex_unlock(&data->lock);
-
-	if (reg & EXYNOS_EMUL_ENABLE) {
-		reg >>= EXYNOS_EMUL_DATA_SHIFT;
-		temp_code = reg & EXYNOS_EMUL_DATA_MASK;
-		temp = code_to_temp(data, temp_code);
-	}
-out:
-	return sprintf(buf, "%d\n", temp * MCELSIUS);
-}
-
-static ssize_t exynos_tmu_emulation_store(struct device *dev,
-					struct device_attribute *attr,
-					const char *buf, size_t count)
-{
-	struct platform_device *pdev = container_of(dev,
-					struct platform_device, dev);
-	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
-	unsigned int reg;
-	int temp;
-
-	if (data->soc == SOC_ARCH_EXYNOS4210)
-		goto out;
-
-	if (!sscanf(buf, "%d\n", &temp) || temp < 0)
-		return -EINVAL;
-
-	mutex_lock(&data->lock);
-	clk_enable(data->clk);
-
-	reg = readl(data->base + EXYNOS_EMUL_CON);
-
-	if (temp) {
-		/* Both CELSIUS and MCELSIUS type are available for input */
-		if (temp > MCELSIUS)
-			temp /= MCELSIUS;
-
-		reg = (EXYNOS_EMUL_TIME << EXYNOS_EMUL_TIME_SHIFT) |
-			(temp_to_code(data, (temp / MCELSIUS))
-			 << EXYNOS_EMUL_DATA_SHIFT) | EXYNOS_EMUL_ENABLE;
-	} else {
-		reg &= ~EXYNOS_EMUL_ENABLE;
-	}
-
-	writel(reg, data->base + EXYNOS_EMUL_CON);
-
-	clk_disable(data->clk);
-	mutex_unlock(&data->lock);
-
-out:
-	return count;
-}
-
-static DEVICE_ATTR(emulation, 0644, exynos_tmu_emulation_show,
-					exynos_tmu_emulation_store);
-static int create_emulation_sysfs(struct device *dev)
-{
-	return device_create_file(dev, &dev_attr_emulation);
-}
-static void remove_emulation_sysfs(struct device *dev)
-{
-	device_remove_file(dev, &dev_attr_emulation);
-}
-#else
-static inline int create_emulation_sysfs(struct device *dev) { return 0; }
-static inline void remove_emulation_sysfs(struct device *dev) {}
-#endif
-
 static int __devinit exynos_tmu_probe(struct platform_device *pdev)
 {
 	struct exynos_tmu_data *data;
@@ -1041,10 +1015,6 @@ static int __devinit exynos_tmu_probe(struct platform_device *pdev)
 		goto err_clk;
 	}
 
-	ret = create_emulation_sysfs(&pdev->dev);
-	if (ret)
-		dev_err(&pdev->dev, "Failed to create emulation mode sysfs node\n");
-
 	return 0;
 err_clk:
 	platform_set_drvdata(pdev, NULL);
@@ -1056,8 +1026,6 @@ static int __devexit exynos_tmu_remove(struct platform_device *pdev)
 {
 	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
 
-	remove_emulation_sysfs(&pdev->dev);
-
 	exynos_tmu_control(pdev, false);
 
 	exynos_unregister_thermal();
-- 
1.7.5.4

