Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbaESJYX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 05:24:23 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:16204 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbaESJYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 05:24:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 19 May 2014 02:19:27 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>, Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC: <nouveau@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 1/5] drm/nouveau: support for probing platform devices
Date: Mon, 19 May 2014 18:24:06 +0900
Message-ID: <1400491450-19223-2-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400491450-19223-1-git-send-email-acourbot@nvidia.com>
References: <1400491450-19223-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a platform driver for Nouveau devices declared using the device tree
or platform data. This driver currently supports GK20A on Tegra
platforms and is only compiled for these platforms if Nouveau is
enabled.

Nouveau will probe the chip type itself using the BOOT0 register, so all
this driver really needs to do is to make sure the module is powered and
its clocks active before calling nouveau_drm_platform_probe().

Heavily based on work done by Thierry Reding.

Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpu/drm/nouveau/Kconfig            |   8 ++
 drivers/gpu/drm/nouveau/Makefile           |   3 +
 drivers/gpu/drm/nouveau/nouveau_drm.c      |  33 ++---
 drivers/gpu/drm/nouveau/nouveau_drm.h      |  21 ++++
 drivers/gpu/drm/nouveau/nouveau_platform.c | 191 +++++++++++++++++++++++++++++
 5 files changed, 241 insertions(+), 15 deletions(-)
 create mode 100644 drivers/gpu/drm/nouveau/nouveau_platform.c

diff --git a/drivers/gpu/drm/nouveau/Kconfig b/drivers/gpu/drm/nouveau/Kconfig
index 637c29a33127..b8834ad55eb8 100644
--- a/drivers/gpu/drm/nouveau/Kconfig
+++ b/drivers/gpu/drm/nouveau/Kconfig
@@ -25,6 +25,14 @@ config DRM_NOUVEAU
 	help
 	  Choose this option for open-source nVidia support.
 
+config NOUVEAU_PLATFORM_DRIVER
+	bool
+	depends on DRM_NOUVEAU
+	default y if ARCH_TEGRA
+	help
+	 Support for Nouveau platform driver, used for integrated GPUs as found
+	 on NVIDIA Tegra K1.
+
 config NOUVEAU_DEBUG
 	int "Maximum debug level"
 	depends on DRM_NOUVEAU
diff --git a/drivers/gpu/drm/nouveau/Makefile b/drivers/gpu/drm/nouveau/Makefile
index 1aaa2ef577d9..45b17b6b1b59 100644
--- a/drivers/gpu/drm/nouveau/Makefile
+++ b/drivers/gpu/drm/nouveau/Makefile
@@ -331,6 +331,9 @@ nouveau-y += nv50_display.o
 # drm/pm
 nouveau-y += nouveau_hwmon.o nouveau_sysfs.o
 
+# platform driver
+nouveau-$(CONFIG_NOUVEAU_PLATFORM_DRIVER) += nouveau_platform.o
+
 # other random bits
 nouveau-$(CONFIG_COMPAT) += nouveau_ioc32.o
 ifdef CONFIG_X86
diff --git a/drivers/gpu/drm/nouveau/nouveau_drm.c b/drivers/gpu/drm/nouveau/nouveau_drm.c
index ddd83756b9a2..1538d0004e6e 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -359,6 +359,9 @@ nouveau_drm_load(struct drm_device *dev, unsigned long flags)
 
 	dev->dev_private = drm;
 	drm->dev = dev;
+	if (dev->platformdev)
+		platform_set_drvdata(dev->platformdev, dev);
+
 	nouveau_client(drm)->debug = nouveau_dbgopt(nouveau_debug, "DRM");
 
 	INIT_LIST_HEAD(&drm->clients);
@@ -1003,23 +1006,19 @@ nouveau_drm_pci_driver = {
 	.driver.pm = &nouveau_pm_ops,
 };
 
-int nouveau_drm_platform_probe(struct platform_device *pdev)
+int nouveau_drm_platform_device_create(struct platform_device *pdev, int length,
+				       void **pobject)
 {
-	struct nouveau_device *device;
-	int ret;
-
-	ret = nouveau_device_create(pdev, NOUVEAU_BUS_PLATFORM,
-				    nouveau_platform_name(pdev),
-				    dev_name(&pdev->dev), nouveau_config,
-				    nouveau_debug, &device);
-
-	ret = drm_platform_init(&driver, pdev);
-	if (ret) {
-		nouveau_object_ref(NULL, (struct nouveau_object **)&device);
-		return ret;
-	}
+	return nouveau_device_create_(pdev, NOUVEAU_BUS_PLATFORM,
+				      nouveau_platform_name(pdev),
+				      dev_name(&pdev->dev),
+				      nouveau_config, nouveau_debug, length,
+				      pobject);
+}
 
-	return ret;
+int nouveau_drm_platform_device_init(struct platform_device *pdev)
+{
+	return drm_platform_init(&driver, pdev);
 }
 
 static int __init
@@ -1035,6 +1034,8 @@ nouveau_drm_init(void)
 	if (!nouveau_modeset)
 		return 0;
 
+	nouveau_platform_driver_init();
+
 	nouveau_register_dsm_handler();
 	return drm_pci_init(&driver, &nouveau_drm_pci_driver);
 }
@@ -1047,6 +1048,8 @@ nouveau_drm_exit(void)
 
 	drm_pci_exit(&driver, &nouveau_drm_pci_driver);
 	nouveau_unregister_dsm_handler();
+
+	nouveau_platform_driver_exit();
 }
 
 module_init(nouveau_drm_init);
diff --git a/drivers/gpu/drm/nouveau/nouveau_drm.h b/drivers/gpu/drm/nouveau/nouveau_drm.h
index 7efbafaf7c1d..178f8cfb148c 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drm.h
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.h
@@ -157,6 +157,27 @@ nouveau_dev(struct drm_device *dev)
 int nouveau_pmops_suspend(struct device *);
 int nouveau_pmops_resume(struct device *);
 
+int nouveau_drm_platform_device_create(struct platform_device *, int, void **);
+int nouveau_drm_platform_device_init(struct platform_device *);
+
+#if IS_ENABLED(CONFIG_NOUVEAU_PLATFORM_DRIVER)
+
+int nouveau_platform_driver_init(void);
+void nouveau_platform_driver_exit(void);
+
+#else
+
+static inline int nouveau_platform_driver_init(void)
+{
+	return 0;
+}
+
+static inline void nouveau_platform_driver_exit(void)
+{
+}
+
+#endif
+
 #define NV_FATAL(cli, fmt, args...) nv_fatal((cli), fmt, ##args)
 #define NV_ERROR(cli, fmt, args...) nv_error((cli), fmt, ##args)
 #define NV_WARN(cli, fmt, args...) nv_warn((cli), fmt, ##args)
diff --git a/drivers/gpu/drm/nouveau/nouveau_platform.c b/drivers/gpu/drm/nouveau/nouveau_platform.c
new file mode 100644
index 000000000000..0d55e04c816a
--- /dev/null
+++ b/drivers/gpu/drm/nouveau/nouveau_platform.c
@@ -0,0 +1,191 @@
+/*
+ * Copyright (c) 2014, NVIDIA CORPORATION. All rights reserved.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ */
+
+#include <linux/clk.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/of.h>
+#include <linux/reset.h>
+#include <linux/regulator/consumer.h>
+#include <linux/tegra-powergate.h>
+
+#include "engine/device.h"
+#include "nouveau_drm.h"
+
+struct nouveau_platform_gpu {
+	struct nouveau_device device;
+
+	struct reset_control *rst;
+	struct clk *clk;
+	struct clk *clk_pll;
+
+	struct regulator *vdd;
+};
+
+#define nv_device_to_gpu(d) container_of(d, struct nouveau_platform_gpu, device)
+
+static int nouveau_platform_power_up(struct nouveau_platform_gpu *gpu)
+{
+	int err;
+
+	reset_control_assert(gpu->rst);
+
+	err = regulator_enable(gpu->vdd);
+	if (err)
+		goto err_power;
+
+	err = clk_prepare_enable(gpu->clk);
+	if (err)
+		goto err_clk;
+
+	udelay(10);
+	err = tegra_powergate_remove_clamping(TEGRA_POWERGATE_3D);
+	if (err)
+		goto err_clamp;
+
+	udelay(10);
+	reset_control_deassert(gpu->rst);
+
+	return 0;
+
+err_clamp:
+	clk_disable_unprepare(gpu->clk);
+err_clk:
+	regulator_disable(gpu->vdd);
+err_power:
+	return err;
+}
+
+static int nouveau_platform_power_down(struct nouveau_platform_gpu *gpu)
+{
+	int err;
+
+	clk_disable_unprepare(gpu->clk);
+
+	err = regulator_disable(gpu->vdd);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static int nouveau_platform_probe(struct platform_device *pdev)
+{
+	struct nouveau_platform_gpu *gpu;
+	struct regulator *vdd;
+	struct reset_control *rst;
+	struct clk *clk, *pll;
+	int err;
+
+	/*
+	 * get the resources we need before we allocate the device' memory
+	 * in case we need to return -EPROBE_DEFER
+	 */
+	vdd = devm_regulator_get(&pdev->dev, "vdd");
+	if (IS_ERR(vdd))
+		return PTR_ERR(vdd);
+
+	rst = devm_reset_control_get(&pdev->dev, "gpu");
+	if (IS_ERR(rst))
+		return PTR_ERR(rst);
+
+	clk = devm_clk_get(&pdev->dev, "gpu");
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
+
+	pll = devm_clk_get(&pdev->dev, "pll");
+	if (IS_ERR(pll))
+		return PTR_ERR(pll);
+
+	err = nouveau_drm_platform_device_create(pdev, sizeof(*gpu),
+						 (void **)&gpu);
+	if (err)
+		return err;
+
+	gpu->vdd = vdd;
+	gpu->rst = rst;
+	gpu->clk = clk;
+	gpu->clk_pll = pll;
+
+	err = nouveau_platform_power_up(gpu);
+	if (err)
+		goto err_probe;
+
+	err = nouveau_drm_platform_device_init(pdev);
+	if (err)
+		goto err_probe;
+
+	return 0;
+
+err_probe:
+	nouveau_object_ref(NULL, (struct nouveau_object **)&gpu->device);
+	return err;
+}
+
+static int nouveau_platform_remove(struct platform_device *pdev)
+{
+	struct drm_device *drm_dev = platform_get_drvdata(pdev);
+	struct nouveau_device *device = nouveau_dev(drm_dev);
+	struct nouveau_platform_gpu *gpu = nv_device_to_gpu(device);
+	int err;
+
+	drm_dev->irq_enabled = false;
+	drm_put_dev(drm_dev);
+
+	err = nouveau_platform_power_down(gpu);
+	if (err)
+		return err;
+
+	nouveau_object_ref(NULL, (struct nouveau_object **)&device);
+	nouveau_object_debug();
+
+	return 0;
+}
+
+#if IS_ENABLED(CONFIG_OF)
+static const struct of_device_id nouveau_platform_match[] = {
+	{ .compatible = "nvidia,gk20a" },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(of, nouveau_platform_match);
+#endif
+
+struct platform_driver nouveau_platform_driver = {
+	.driver = {
+		.name = "nouveau",
+		.of_match_table = of_match_ptr(nouveau_platform_match),
+	},
+	.probe = nouveau_platform_probe,
+	.remove = nouveau_platform_remove,
+};
+
+int __init nouveau_platform_driver_init(void)
+{
+	return platform_driver_register(&nouveau_platform_driver);
+}
+
+void __exit nouveau_platform_driver_exit(void)
+{
+	platform_driver_unregister(&nouveau_platform_driver);
+}
-- 
1.9.2

