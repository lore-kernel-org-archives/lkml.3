Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422662AbaDQL3w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 07:29:52 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:31102 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbaDQL3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 07:29:47 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-c1-534fbb29d349
From: Andrzej Hajda <a.hajda@samsung.com>
To: dri-devel@lists.freedesktop.org
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org (moderated list:ARM/S5P EXYNOS AR...),
        Tomasz Figa <t.figa@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Airlie <airlied@linux.ie>,
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/S5P EXYNOS
	AR...),
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH RFC 3/3] drm/exynos: use pending_components for components
 tracking
Date: Thu, 17 Apr 2014 13:28:50 +0200
Message-id: <1397734130-21019-4-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <1397734130-21019-1-git-send-email-a.hajda@samsung.com>
References: <1397734130-21019-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrELMWRmVeSWpSXmKPExsVy+t/xq7qau/2DDZbt17e4te4cq0XvuZNM
	Fn8nHWO3uPL1PZtF8+L1bBaT7k9gsTjb9IbdYtPja6wWl3fNYbOYcX4fk8Xty7wWa4/cZbdY
	P+M1iwOvR0tzD5vH71+TGD22f3vA6rF/7hp2j/vdx5k8Ni+p9+jbsorR4/MmuQCOKC6blNSc
	zLLUIn27BK6Mw8vuMRY0vWSsWHXjPWsD45Z9jF2MnBwSAiYS7fuPskLYYhIX7q1n62Lk4hAS
	WMoo0fHjAyuE08ck8enqFBaQKjYBTYm/m2+ygdgiAsoSfyeuYgQpYhbYziLRdHQiWEJYIFTi
	16GlTF2MHBwsAqoS63qyQcK8As4Su+4eY4LYpiCx7MtaZhCbU8BF4t2/LlaQciGgmu9/bScw
	8i5gZFjFKJpamlxQnJSea6hXnJhbXJqXrpecn7uJERKuX3YwLj5mdYhRgINRiYeX47dfsBBr
	YllxZe4hRgkOZiUR3ub1/sFCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGLXPKRnvn1sk3Z81a5nk
	170iJ16cEA9s//yxYPuM6cXGesceT1wZzia369DfyM0z5pVYH7cpcUo6NiMl5XTOxO1TH5wN
	aGG4GGSlsfZ3qbdLqr0Sm+6LF1fv35twVvyt0od8ZwHF5R0lUoe37OTYt/jsjqeZAbXaj6xq
	82aIfi16dCx1T7v4DislluKMREMt5qLiRADtrNh6NQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

exynos_drm is composed from multiple devices which provides different
interfaces. To properly start/stop drm master device it should track
readiness of all its components. This patch uses pending_components
framework to perform this task.
On module initialization before component driver registration all devices
matching drivers are added to pending_components. Drivers during probe
are removed from the list unless deferred probe happens. When list becomes
empty callback is fired to start drm master. Later if any device adds itself
to the list callback is fired to stop drm master.

The core of the changes is in exynos_drm_drv.c. Driver modifications are
limited only to signal its readiness in probe and remove driver callbacks.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/Kconfig              |  1 +
 drivers/gpu/drm/exynos/exynos_dp_core.c     | 36 +++++++++++------
 drivers/gpu/drm/exynos/exynos_drm_drv.c     | 61 +++++++++++++++++++++++++++--
 drivers/gpu/drm/exynos/exynos_drm_drv.h     |  3 ++
 drivers/gpu/drm/exynos/exynos_drm_dsi.c     | 41 +++++++++++--------
 drivers/gpu/drm/exynos/exynos_drm_fimc.c    | 34 ++++++++++------
 drivers/gpu/drm/exynos/exynos_drm_fimd.c    | 37 +++++++++++------
 drivers/gpu/drm/exynos/exynos_drm_g2d.c     | 17 ++++++--
 drivers/gpu/drm/exynos/exynos_drm_gsc.c     | 30 +++++++++-----
 drivers/gpu/drm/exynos/exynos_drm_ipp.c     | 18 ++++++---
 drivers/gpu/drm/exynos/exynos_drm_rotator.c | 27 +++++++++----
 drivers/gpu/drm/exynos/exynos_drm_vidi.c    | 16 +++++---
 drivers/gpu/drm/exynos/exynos_hdmi.c        | 53 +++++++++++++++++--------
 drivers/gpu/drm/exynos/exynos_mixer.c       | 13 ++++--
 14 files changed, 278 insertions(+), 109 deletions(-)

diff --git a/drivers/gpu/drm/exynos/Kconfig b/drivers/gpu/drm/exynos/Kconfig
index 5bf5bca..4ed8eb2 100644
--- a/drivers/gpu/drm/exynos/Kconfig
+++ b/drivers/gpu/drm/exynos/Kconfig
@@ -8,6 +8,7 @@ config DRM_EXYNOS
 	select FB_CFB_IMAGEBLIT
 	select VT_HW_CONSOLE_BINDING if FRAMEBUFFER_CONSOLE
 	select VIDEOMODE_HELPERS
+	select PENDING_COMPONENTS
 	help
 	  Choose this option if you have a Samsung SoC EXYNOS chipset.
 	  If M is selected the module will be called exynosdrm.
diff --git a/drivers/gpu/drm/exynos/exynos_dp_core.c b/drivers/gpu/drm/exynos/exynos_dp_core.c
index 9385e96..24f5c98 100644
--- a/drivers/gpu/drm/exynos/exynos_dp_core.c
+++ b/drivers/gpu/drm/exynos/exynos_dp_core.c
@@ -1240,29 +1240,32 @@ static int exynos_dp_probe(struct platform_device *pdev)
 	dp = devm_kzalloc(&pdev->dev, sizeof(struct exynos_dp_device),
 				GFP_KERNEL);
 	if (!dp) {
-		dev_err(&pdev->dev, "no memory for device data\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out;
 	}
 
 	dp->dev = &pdev->dev;
 	dp->dpms_mode = DRM_MODE_DPMS_OFF;
 
 	dp->video_info = exynos_dp_dt_parse_pdata(&pdev->dev);
-	if (IS_ERR(dp->video_info))
-		return PTR_ERR(dp->video_info);
+	if (IS_ERR(dp->video_info)) {
+		ret = PTR_ERR(dp->video_info);
+		goto out;
+	}
 
 	ret = exynos_dp_dt_parse_phydata(dp);
 	if (ret)
-		return ret;
+		goto out;
 
 	ret = exynos_dp_dt_parse_panel(dp);
 	if (ret)
-		return ret;
+		goto out;
 
 	dp->clock = devm_clk_get(&pdev->dev, "dp");
 	if (IS_ERR(dp->clock)) {
 		dev_err(&pdev->dev, "failed to get clock\n");
-		return PTR_ERR(dp->clock);
+		ret = PTR_ERR(dp->clock);
+		goto out;
 	}
 
 	clk_prepare_enable(dp->clock);
@@ -1270,13 +1273,16 @@ static int exynos_dp_probe(struct platform_device *pdev)
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
 	dp->reg_base = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(dp->reg_base))
-		return PTR_ERR(dp->reg_base);
+	if (IS_ERR(dp->reg_base)) {
+		ret = PTR_ERR(dp->reg_base);
+		goto out;
+	}
 
 	dp->irq = platform_get_irq(pdev, 0);
 	if (dp->irq == -ENXIO) {
 		dev_err(&pdev->dev, "failed to get irq\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto out;
 	}
 
 	INIT_WORK(&dp->hotplug_work, exynos_dp_hotplug);
@@ -1289,7 +1295,7 @@ static int exynos_dp_probe(struct platform_device *pdev)
 				"exynos-dp", dp);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to request irq\n");
-		return ret;
+		goto out;
 	}
 	disable_irq(dp->irq);
 
@@ -1298,13 +1304,19 @@ static int exynos_dp_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, &exynos_dp_display);
 	exynos_drm_display_register(&exynos_dp_display);
 
-	return 0;
+out:
+	if (ret != -EPROBE_DEFER)
+		exynos_drm_dev_ready(&pdev->dev);
+
+	return ret;
 }
 
 static int exynos_dp_remove(struct platform_device *pdev)
 {
 	struct exynos_drm_display *display = platform_get_drvdata(pdev);
 
+	exynos_drm_dev_busy(&pdev->dev);
+
 	exynos_dp_dpms(display, DRM_MODE_DPMS_OFF);
 	exynos_drm_display_unregister(&exynos_dp_display);
 
diff --git a/drivers/gpu/drm/exynos/exynos_drm_drv.c b/drivers/gpu/drm/exynos/exynos_drm_drv.c
index 5067b32..6e73c7f 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_drv.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_drv.c
@@ -14,10 +14,10 @@
 #include <linux/pm_runtime.h>
 #include <drm/drmP.h>
 #include <drm/drm_crtc_helper.h>
+#include <drm/exynos_drm.h>
 
 #include <linux/anon_inodes.h>
-
-#include <drm/exynos_drm.h>
+#include <linux/pending_components.h>
 
 #include "exynos_drm_drv.h"
 #include "exynos_drm_crtc.h"
@@ -355,6 +355,18 @@ static struct drm_driver exynos_drm_driver = {
 	.minor	= DRIVER_MINOR,
 };
 
+static DEFINE_PENDING_COMPONENTS(exynos_drm_blockers);
+
+int exynos_drm_blocker_callback(struct pending_components *set, bool empty)
+{
+	if (empty)
+		return drm_platform_init(&exynos_drm_driver, exynos_drm_pdev);
+
+	drm_put_dev(platform_get_drvdata(exynos_drm_pdev));
+
+	return 0;
+}
+
 static int exynos_drm_platform_probe(struct platform_device *pdev)
 {
 	int ret;
@@ -366,12 +378,19 @@ static int exynos_drm_platform_probe(struct platform_device *pdev)
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_get_sync(&pdev->dev);
 
-	return drm_platform_init(&exynos_drm_driver, pdev);
+	pending_components_set_callback(&exynos_drm_blockers,
+					exynos_drm_blocker_callback);
+	ret = exynos_drm_dev_ready(&pdev->dev);
+	if (ret < 0)
+		pending_components_set_callback(&exynos_drm_blockers, NULL);
+
+	return ret;
 }
 
 static int exynos_drm_platform_remove(struct platform_device *pdev)
 {
-	drm_put_dev(platform_get_drvdata(pdev));
+	exynos_drm_dev_busy(&pdev->dev);
+	pending_components_set_callback(&exynos_drm_blockers, NULL);
 
 	return 0;
 }
@@ -455,6 +474,36 @@ static void exynos_platform_device_drm_unregister(void)
 	platform_device_unregister(exynos_drm_pdev);
 }
 
+int exynos_drm_dev_ready(struct device *dev)
+{
+	return pending_components_delete(&exynos_drm_blockers, dev);
+}
+
+void exynos_drm_dev_busy(struct device *dev)
+{
+	pending_components_insert(&exynos_drm_blockers, dev);
+}
+
+static int exynos_drm_add_blocker(struct device *dev, void *data)
+{
+	struct device_driver *drv = data;
+
+	if (!platform_bus_type.match(dev, drv))
+		return 0;
+
+	device_lock(dev);
+	if (!dev->driver)
+		exynos_drm_dev_busy(dev);
+	device_unlock(dev);
+
+	return 0;
+}
+
+static void exynos_drm_init_blockers(struct device_driver *drv)
+{
+	bus_for_each_dev(&platform_bus_type, NULL, drv, exynos_drm_add_blocker);
+}
+
 extern struct platform_driver exynos_drm_drivers;
 
 static int __init exynos_drm_init(void)
@@ -472,6 +521,7 @@ static int __init exynos_drm_init(void)
 
 	while (pd <= &exynos_drm_drv) {
 		pr_debug("%s: registering %s\n", __func__, pd->driver.name);
+		exynos_drm_init_blockers(&pd->driver);
 		ret = platform_driver_register(pd);
 		if (ret < 0)
 			goto err;
@@ -485,6 +535,8 @@ err:
 err_dev:
 	exynos_platform_device_ipp_unregister();
 
+	pending_components_cleanup(&exynos_drm_blockers);
+
 	return ret;
 }
 
@@ -498,6 +550,7 @@ static void __exit exynos_drm_exit(void)
 	exynos_platform_device_drm_unregister();
 	exynos_platform_device_ipp_unregister();
 
+	pending_components_cleanup(&exynos_drm_blockers);
 }
 
 module_init(exynos_drm_init);
diff --git a/drivers/gpu/drm/exynos/exynos_drm_drv.h b/drivers/gpu/drm/exynos/exynos_drm_drv.h
index 419b9de..03de62b 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_drv.h
+++ b/drivers/gpu/drm/exynos/exynos_drm_drv.h
@@ -359,6 +359,9 @@ static inline int exynos_platform_device_ipp_register(void) { return 0; }
 static inline void exynos_platform_device_ipp_unregister(void) {}
 #endif
 
+int exynos_drm_dev_ready(struct device *dev);
+void exynos_drm_dev_busy(struct device *dev);
+
 #ifdef CONFIG_DRM_EXYNOS_DPI
 int exynos_dpi_probe(struct device *dev);
 int exynos_dpi_remove(struct device *dev);
diff --git a/drivers/gpu/drm/exynos/exynos_drm_dsi.c b/drivers/gpu/drm/exynos/exynos_drm_dsi.c
index 56230e6..f606ec2 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_dsi.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_dsi.c
@@ -1386,8 +1386,8 @@ static int exynos_dsi_probe(struct platform_device *pdev)
 
 	dsi = devm_kzalloc(&pdev->dev, sizeof(*dsi), GFP_KERNEL);
 	if (!dsi) {
-		dev_err(&pdev->dev, "failed to allocate dsi object.\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out;
 	}
 
 	init_completion(&dsi->completed);
@@ -1401,46 +1401,48 @@ static int exynos_dsi_probe(struct platform_device *pdev)
 
 	ret = exynos_dsi_parse_dt(dsi);
 	if (ret)
-		return ret;
+		goto out;
 
 	dsi->supplies[0].supply = "vddcore";
 	dsi->supplies[1].supply = "vddio";
 	ret = devm_regulator_bulk_get(&pdev->dev, ARRAY_SIZE(dsi->supplies),
 				      dsi->supplies);
-	if (ret) {
-		dev_info(&pdev->dev, "failed to get regulators: %d\n", ret);
-		return -EPROBE_DEFER;
-	}
+	if (ret)
+		goto out;
 
 	dsi->pll_clk = devm_clk_get(&pdev->dev, "pll_clk");
 	if (IS_ERR(dsi->pll_clk)) {
-		dev_info(&pdev->dev, "failed to get dsi pll input clock\n");
-		return -EPROBE_DEFER;
+		ret = PTR_ERR(dsi->pll_clk);
+		dev_info(&pdev->dev, "failed to get dsi pll clock\n");
+		goto out;
 	}
 
 	dsi->bus_clk = devm_clk_get(&pdev->dev, "bus_clk");
 	if (IS_ERR(dsi->bus_clk)) {
+		ret = PTR_ERR(dsi->bus_clk);
 		dev_info(&pdev->dev, "failed to get dsi bus clock\n");
-		return -EPROBE_DEFER;
+		goto out;
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	dsi->reg_base = devm_ioremap_resource(&pdev->dev, res);
 	if (!dsi->reg_base) {
 		dev_err(&pdev->dev, "failed to remap io region\n");
-		return -EADDRNOTAVAIL;
+		ret = -EADDRNOTAVAIL;
+		goto out;
 	}
 
 	dsi->phy = devm_phy_get(&pdev->dev, "dsim");
 	if (IS_ERR(dsi->phy)) {
-		dev_info(&pdev->dev, "failed to get dsim phy\n");
-		return -EPROBE_DEFER;
+		ret = PTR_ERR(dsi->phy);
+		goto out;
 	}
 
 	dsi->irq = platform_get_irq(pdev, 0);
 	if (dsi->irq < 0) {
+		ret = dsi->irq;
 		dev_err(&pdev->dev, "failed to request dsi irq resource\n");
-		return dsi->irq;
+		goto out;
 	}
 
 	irq_set_status_flags(dsi->irq, IRQ_NOAUTOEN);
@@ -1449,7 +1451,7 @@ static int exynos_dsi_probe(struct platform_device *pdev)
 					dev_name(&pdev->dev), dsi);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to request dsi irq\n");
-		return ret;
+		goto out;
 	}
 
 	exynos_dsi_display.ctx = dsi;
@@ -1457,7 +1459,12 @@ static int exynos_dsi_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, &exynos_dsi_display);
 	exynos_drm_display_register(&exynos_dsi_display);
 
-	return mipi_dsi_host_register(&dsi->dsi_host);
+	ret = mipi_dsi_host_register(&dsi->dsi_host);
+out:
+	if (ret != -EPROBE_DEFER)
+		exynos_drm_dev_ready(&pdev->dev);
+
+	return ret;
 }
 
 static int exynos_dsi_remove(struct platform_device *pdev)
@@ -1465,7 +1472,7 @@ static int exynos_dsi_remove(struct platform_device *pdev)
 	struct exynos_dsi *dsi = exynos_dsi_display.ctx;
 
 	exynos_dsi_dpms(&exynos_dsi_display, DRM_MODE_DPMS_OFF);
-
+	exynos_drm_dev_busy(&pdev->dev);
 	exynos_drm_display_unregister(&exynos_dsi_display);
 	mipi_dsi_host_unregister(&dsi->dsi_host);
 
diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimc.c b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
index 0865d5d..ce4d77b 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
@@ -1788,37 +1788,44 @@ static int fimc_probe(struct platform_device *pdev)
 
 	if (!dev->of_node) {
 		dev_err(dev, "device tree node not found.\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto out;
 	}
 
 	ctx = devm_kzalloc(dev, sizeof(*ctx), GFP_KERNEL);
-	if (!ctx)
-		return -ENOMEM;
+	if (!ctx) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	ctx->ippdrv.dev = dev;
 
 	ret = fimc_parse_dt(ctx);
 	if (ret < 0)
-		return ret;
+		goto out;
 
 	ctx->sysreg = syscon_regmap_lookup_by_phandle(dev->of_node,
 						"samsung,sysreg");
 	if (IS_ERR(ctx->sysreg)) {
 		dev_err(dev, "syscon regmap lookup failed.\n");
-		return PTR_ERR(ctx->sysreg);
+		ret = PTR_ERR(ctx->sysreg);
+		goto out;
 	}
 
 	/* resource memory */
 	ctx->regs_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	ctx->regs = devm_ioremap_resource(dev, ctx->regs_res);
-	if (IS_ERR(ctx->regs))
-		return PTR_ERR(ctx->regs);
+	if (IS_ERR(ctx->regs)) {
+		ret = PTR_ERR(ctx->regs);
+		goto out;
+	}
 
 	/* resource irq */
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (!res) {
 		dev_err(dev, "failed to request irq resource.\n");
-		return -ENOENT;
+		ret = -ENOENT;
+		goto out;
 	}
 
 	ctx->irq = res->start;
@@ -1826,12 +1833,12 @@ static int fimc_probe(struct platform_device *pdev)
 		IRQF_ONESHOT, "drm_fimc", ctx);
 	if (ret < 0) {
 		dev_err(dev, "failed to request irq.\n");
-		return ret;
+		goto out;
 	}
 
 	ret = fimc_setup_clocks(ctx);
 	if (ret < 0)
-		return ret;
+		goto out;
 
 	ippdrv = &ctx->ippdrv;
 	ippdrv->ops[EXYNOS_DRM_OPS_SRC] = &fimc_src_ops;
@@ -1862,12 +1869,15 @@ static int fimc_probe(struct platform_device *pdev)
 
 	dev_info(dev, "drm fimc registered successfully.\n");
 
-	return 0;
+	goto out;
 
 err_pm_dis:
 	pm_runtime_disable(dev);
 err_put_clk:
 	fimc_put_clocks(ctx);
+out:
+	if (ret != -EPROBE_DEFER)
+		exynos_drm_dev_ready(dev);
 
 	return ret;
 }
@@ -1878,6 +1888,7 @@ static int fimc_remove(struct platform_device *pdev)
 	struct fimc_context *ctx = get_fimc_context(dev);
 	struct exynos_drm_ippdrv *ippdrv = &ctx->ippdrv;
 
+	exynos_drm_dev_busy(dev);
 	exynos_drm_ippdrv_unregister(ippdrv);
 	mutex_destroy(&ctx->lock);
 
@@ -1955,4 +1966,3 @@ EXYNOS_DRM_DRV(fimc_driver) = {
 		.pm	= &fimc_pm_ops,
 	},
 };
-
diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
index a0f5037..8bc37c4 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
@@ -857,12 +857,16 @@ static int fimd_probe(struct platform_device *pdev)
 	int win;
 	int ret = -EINVAL;
 
-	if (!dev->of_node)
-		return -ENODEV;
+	if (!dev->of_node) {
+		ret = -ENODEV;
+		goto out;
+	}
 
 	ctx = devm_kzalloc(dev, sizeof(*ctx), GFP_KERNEL);
-	if (!ctx)
-		return -ENOMEM;
+	if (!ctx) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	ctx->dev = dev;
 	ctx->suspended = true;
@@ -875,32 +879,37 @@ static int fimd_probe(struct platform_device *pdev)
 	ctx->bus_clk = devm_clk_get(dev, "fimd");
 	if (IS_ERR(ctx->bus_clk)) {
 		dev_err(dev, "failed to get bus clock\n");
-		return PTR_ERR(ctx->bus_clk);
+		ret = PTR_ERR(ctx->bus_clk);
+		goto out;
 	}
 
 	ctx->lcd_clk = devm_clk_get(dev, "sclk_fimd");
 	if (IS_ERR(ctx->lcd_clk)) {
 		dev_err(dev, "failed to get lcd clock\n");
-		return PTR_ERR(ctx->lcd_clk);
+		ret = PTR_ERR(ctx->lcd_clk);
+		goto out;
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
 	ctx->regs = devm_ioremap_resource(dev, res);
-	if (IS_ERR(ctx->regs))
-		return PTR_ERR(ctx->regs);
+	if (IS_ERR(ctx->regs)) {
+		ret = PTR_ERR(ctx->regs);
+		goto out;
+	}
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_IRQ, "vsync");
 	if (!res) {
 		dev_err(dev, "irq request failed.\n");
-		return -ENXIO;
+		ret = -ENXIO;
+		goto out;
 	}
 
 	ret = devm_request_irq(dev, res->start, fimd_irq_handler,
 							0, "drm_fimd", ctx);
 	if (ret) {
 		dev_err(dev, "irq request failed.\n");
-		return ret;
+		goto out;
 	}
 
 	ctx->driver_data = drm_fimd_get_driver_data(pdev);
@@ -919,13 +928,19 @@ static int fimd_probe(struct platform_device *pdev)
 	for (win = 0; win < WINDOWS_NR; win++)
 		fimd_clear_win(ctx, win);
 
-	return 0;
+out:
+	if (ret != -EPROBE_DEFER)
+		exynos_drm_dev_ready(dev);
+
+	return ret;
 }
 
 static int fimd_remove(struct platform_device *pdev)
 {
 	struct exynos_drm_manager *mgr = platform_get_drvdata(pdev);
 
+	exynos_drm_dev_busy(&pdev->dev);
+
 	exynos_dpi_remove(&pdev->dev);
 
 	exynos_drm_manager_unregister(&fimd_manager);
diff --git a/drivers/gpu/drm/exynos/exynos_drm_g2d.c b/drivers/gpu/drm/exynos/exynos_drm_g2d.c
index 2eb4676..0dfd23c 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_g2d.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_g2d.c
@@ -1372,13 +1372,17 @@ static int g2d_probe(struct platform_device *pdev)
 	int ret;
 
 	g2d = devm_kzalloc(dev, sizeof(*g2d), GFP_KERNEL);
-	if (!g2d)
-		return -ENOMEM;
+	if (!g2d) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	g2d->runqueue_slab = kmem_cache_create("g2d_runqueue_slab",
 			sizeof(struct g2d_runqueue_node), 0, 0, NULL);
-	if (!g2d->runqueue_slab)
-		return -ENOMEM;
+	if (!g2d->runqueue_slab) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	g2d->dev = dev;
 
@@ -1455,6 +1459,10 @@ err_destroy_workqueue:
 	destroy_workqueue(g2d->g2d_workq);
 err_destroy_slab:
 	kmem_cache_destroy(g2d->runqueue_slab);
+out:
+	if (ret != -EPROBE_DEFER)
+		exynos_drm_dev_ready(dev);
+
 	return ret;
 }
 
@@ -1463,6 +1471,7 @@ static int g2d_remove(struct platform_device *pdev)
 	struct g2d_data *g2d = platform_get_drvdata(pdev);
 
 	cancel_work_sync(&g2d->runqueue_work);
+	exynos_drm_dev_busy(&pdev->dev);
 	exynos_drm_subdrv_unregister(&g2d->subdrv);
 
 	while (g2d->runqueue_node) {
diff --git a/drivers/gpu/drm/exynos/exynos_drm_gsc.c b/drivers/gpu/drm/exynos/exynos_drm_gsc.c
index 76b15fd..3ab602e 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_gsc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_gsc.c
@@ -1659,27 +1659,33 @@ static int gsc_probe(struct platform_device *pdev)
 	int ret;
 
 	ctx = devm_kzalloc(dev, sizeof(*ctx), GFP_KERNEL);
-	if (!ctx)
-		return -ENOMEM;
+	if (!ctx) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	/* clock control */
 	ctx->gsc_clk = devm_clk_get(dev, "gscl");
 	if (IS_ERR(ctx->gsc_clk)) {
 		dev_err(dev, "failed to get gsc clock.\n");
-		return PTR_ERR(ctx->gsc_clk);
+		ret = PTR_ERR(ctx->gsc_clk);
+		goto out;
 	}
 
 	/* resource memory */
 	ctx->regs_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	ctx->regs = devm_ioremap_resource(dev, ctx->regs_res);
-	if (IS_ERR(ctx->regs))
-		return PTR_ERR(ctx->regs);
+	if (IS_ERR(ctx->regs)) {
+		ret = PTR_ERR(ctx->regs);
+		goto out;
+	}
 
 	/* resource irq */
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (!res) {
 		dev_err(dev, "failed to request irq resource.\n");
-		return -ENOENT;
+		ret = -ENOENT;
+		goto out;
 	}
 
 	ctx->irq = res->start;
@@ -1687,7 +1693,7 @@ static int gsc_probe(struct platform_device *pdev)
 		IRQF_ONESHOT, "drm_gsc", ctx);
 	if (ret < 0) {
 		dev_err(dev, "failed to request irq.\n");
-		return ret;
+		goto out;
 	}
 
 	/* context initailization */
@@ -1704,7 +1710,7 @@ static int gsc_probe(struct platform_device *pdev)
 	ret = gsc_init_prop_list(ippdrv);
 	if (ret < 0) {
 		dev_err(dev, "failed to init property list.\n");
-		return ret;
+		goto out;
 	}
 
 	DRM_DEBUG_KMS("id[%d]ippdrv[0x%x]\n", ctx->id, (int)ippdrv);
@@ -1723,10 +1729,14 @@ static int gsc_probe(struct platform_device *pdev)
 
 	dev_info(dev, "drm gsc registered successfully.\n");
 
-	return 0;
+	goto out;
 
 err_ippdrv_register:
 	pm_runtime_disable(dev);
+out:
+	if (ret != -EPROBE_DEFER)
+		exynos_drm_dev_ready(dev);
+
 	return ret;
 }
 
@@ -1736,6 +1746,7 @@ static int gsc_remove(struct platform_device *pdev)
 	struct gsc_context *ctx = get_gsc_context(dev);
 	struct exynos_drm_ippdrv *ippdrv = &ctx->ippdrv;
 
+	exynos_drm_dev_busy(dev);
 	exynos_drm_ippdrv_unregister(ippdrv);
 	mutex_destroy(&ctx->lock);
 
@@ -1805,4 +1816,3 @@ EXYNOS_DRM_DRV(gsc_driver) = {
 		.pm	= &gsc_pm_ops,
 	},
 };
-
diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
index 1393486..bc4338f 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
@@ -1840,8 +1840,10 @@ static int ipp_probe(struct platform_device *pdev)
 	int ret;
 
 	ctx = devm_kzalloc(dev, sizeof(*ctx), GFP_KERNEL);
-	if (!ctx)
-		return -ENOMEM;
+	if (!ctx) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	mutex_init(&ctx->ipp_lock);
 	mutex_init(&ctx->prop_lock);
@@ -1858,7 +1860,8 @@ static int ipp_probe(struct platform_device *pdev)
 	ctx->event_workq = create_singlethread_workqueue("ipp_event");
 	if (!ctx->event_workq) {
 		dev_err(dev, "failed to create event workqueue\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 
 	/*
@@ -1893,12 +1896,15 @@ static int ipp_probe(struct platform_device *pdev)
 
 	dev_info(dev, "drm ipp registered successfully.\n");
 
-	return 0;
-
+	goto out;
 err_cmd_workq:
 	destroy_workqueue(ctx->cmd_workq);
 err_event_workq:
 	destroy_workqueue(ctx->event_workq);
+out:
+	if (ret != -EPROBE_DEFER)
+		exynos_drm_dev_ready(dev);
+
 	return ret;
 }
 
@@ -1907,6 +1913,7 @@ static int ipp_remove(struct platform_device *pdev)
 	struct ipp_context *ctx = platform_get_drvdata(pdev);
 
 	/* unregister sub driver */
+	exynos_drm_dev_busy(&pdev->dev);
 	exynos_drm_subdrv_unregister(&ctx->subdrv);
 
 	/* remove,destroy ipp idr */
@@ -1982,4 +1989,3 @@ EXYNOS_DRM_DRV(ipp_driver) = {
 		.pm	= &ipp_pm_ops,
 	},
 };
-
diff --git a/drivers/gpu/drm/exynos/exynos_drm_rotator.c b/drivers/gpu/drm/exynos/exynos_drm_rotator.c
index 625fd9b..8d6e6cd 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_rotator.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_rotator.c
@@ -707,17 +707,21 @@ static int rotator_probe(struct platform_device *pdev)
 
 	if (!dev->of_node) {
 		dev_err(dev, "cannot find of_node.\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto out;
 	}
 
 	rot = devm_kzalloc(dev, sizeof(*rot), GFP_KERNEL);
-	if (!rot)
-		return -ENOMEM;
+	if (!rot) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	match = of_match_node(exynos_rotator_match, dev->of_node);
 	if (!match) {
 		dev_err(dev, "failed to match node\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto out;
 	}
 	rot->limit_tbl = (struct rot_limit_table *)match->data;
 
@@ -729,20 +733,22 @@ static int rotator_probe(struct platform_device *pdev)
 	rot->irq = platform_get_irq(pdev, 0);
 	if (rot->irq < 0) {
 		dev_err(dev, "failed to get irq\n");
-		return rot->irq;
+		ret = rot->irq;
+		goto out;
 	}
 
 	ret = devm_request_threaded_irq(dev, rot->irq, NULL,
 			rotator_irq_handler, IRQF_ONESHOT, "drm_rotator", rot);
 	if (ret < 0) {
 		dev_err(dev, "failed to request irq\n");
-		return ret;
+		goto out;
 	}
 
 	rot->clock = devm_clk_get(dev, "rotator");
 	if (IS_ERR(rot->clock)) {
 		dev_err(dev, "failed to get clock\n");
-		return PTR_ERR(rot->clock);
+		ret = PTR_ERR(rot->clock);
+		goto out;
 	}
 
 	pm_runtime_enable(dev);
@@ -771,10 +777,14 @@ static int rotator_probe(struct platform_device *pdev)
 
 	dev_info(dev, "The exynos rotator is probed successfully\n");
 
-	return 0;
+	goto out;
 
 err_ippdrv_register:
 	pm_runtime_disable(dev);
+out:
+	if (ret != -EPROBE_DEFER)
+		exynos_drm_dev_ready(dev);
+
 	return ret;
 }
 
@@ -784,6 +794,7 @@ static int rotator_remove(struct platform_device *pdev)
 	struct rot_context *rot = dev_get_drvdata(dev);
 	struct exynos_drm_ippdrv *ippdrv = &rot->ippdrv;
 
+	exynos_drm_dev_busy(dev);
 	exynos_drm_ippdrv_unregister(ippdrv);
 
 	pm_runtime_disable(dev);
diff --git a/drivers/gpu/drm/exynos/exynos_drm_vidi.c b/drivers/gpu/drm/exynos/exynos_drm_vidi.c
index 976a8fe..bfb01a4 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_vidi.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_vidi.c
@@ -593,8 +593,10 @@ static int vidi_probe(struct platform_device *pdev)
 	int ret;
 
 	ctx = devm_kzalloc(dev, sizeof(*ctx), GFP_KERNEL);
-	if (!ctx)
-		return -ENOMEM;
+	if (!ctx) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	ctx->default_win = 0;
 
@@ -607,20 +609,24 @@ static int vidi_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, &vidi_manager);
 
-	ret = device_create_file(dev, &dev_attr_connection);
-	if (ret < 0)
+	if (device_create_file(dev, &dev_attr_connection) < 0)
 		DRM_INFO("failed to create connection sysfs.\n");
 
 	exynos_drm_manager_register(&vidi_manager);
 	exynos_drm_display_register(&vidi_display);
+	ret = 0;
+out:
+	if (ret != -EPROBE_DEFER)
+		exynos_drm_dev_ready(dev);
 
-	return 0;
+	return ret;
 }
 
 static int vidi_remove(struct platform_device *pdev)
 {
 	struct vidi_context *ctx = platform_get_drvdata(pdev);
 
+	exynos_drm_dev_busy(&pdev->dev);
 	exynos_drm_display_unregister(&vidi_display);
 	exynos_drm_manager_unregister(&vidi_manager);
 
diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
index 3e659e9..7947f37 100644
--- a/drivers/gpu/drm/exynos/exynos_hdmi.c
+++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
@@ -2058,24 +2058,32 @@ static int hdmi_probe(struct platform_device *pdev)
 	struct hdmi_driver_data *drv_data;
 	int ret;
 
-	 if (!dev->of_node)
-		return -ENODEV;
+	 if (!dev->of_node) {
+		ret = -ENODEV;
+		goto out;
+	 }
 
 	pdata = drm_hdmi_dt_parse_pdata(dev);
-	if (!pdata)
-		return -EINVAL;
+	if (!pdata) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	hdata = devm_kzalloc(dev, sizeof(struct hdmi_context), GFP_KERNEL);
-	if (!hdata)
-		return -ENOMEM;
+	if (!hdata) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	mutex_init(&hdata->hdmi_mutex);
 
 	platform_set_drvdata(pdev, &hdmi_display);
 
 	match = of_match_node(hdmi_match_types, dev->of_node);
-	if (!match)
-		return -ENODEV;
+	if (!match) {
+		ret = -ENODEV;
+		goto out;
+	}
 
 	drv_data = (struct hdmi_driver_data *)match->data;
 	hdata->type = drv_data->type;
@@ -2086,35 +2094,41 @@ static int hdmi_probe(struct platform_device *pdev)
 	ret = hdmi_resources_init(hdata);
 	if (ret) {
 		DRM_ERROR("hdmi_resources_init failed\n");
-		return -EINVAL;
+		goto out;
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	hdata->regs = devm_ioremap_resource(dev, res);
-	if (IS_ERR(hdata->regs))
-		return PTR_ERR(hdata->regs);
+	if (IS_ERR(hdata->regs)) {
+		ret = PTR_ERR(hdata->regs);
+		goto out;
+	}
 
 	ret = devm_gpio_request(dev, hdata->hpd_gpio, "HPD");
 	if (ret) {
 		DRM_ERROR("failed to request HPD gpio\n");
-		return ret;
+		goto out;
 	}
 
 	/* DDC i2c driver */
 	ddc_node = of_parse_phandle(dev->of_node, "ddc", 0);
 	if (!ddc_node) {
 		DRM_ERROR("Failed to find ddc node in device tree\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto out;
 	}
 	hdata->ddc_adpt = of_find_i2c_adapter_by_node(ddc_node);
 	if (!hdata->ddc_adpt) {
 		DRM_ERROR("Failed to get ddc i2c adapter by node\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto out;
 	}
 
 	/* Not support APB PHY yet. */
-	if (drv_data->is_apb_phy)
-		return -EPERM;
+	if (drv_data->is_apb_phy) {
+		ret = -EPERM;
+		goto out;
+	}
 
 	/* hdmiphy i2c driver */
 	phy_node = of_parse_phandle(dev->of_node, "phy", 0);
@@ -2153,12 +2167,16 @@ static int hdmi_probe(struct platform_device *pdev)
 	hdmi_display.ctx = hdata;
 	exynos_drm_display_register(&hdmi_display);
 
-	return 0;
+	goto out;
 
 err_hdmiphy:
 	put_device(&hdata->hdmiphy_port->dev);
 err_ddc:
 	put_device(&hdata->ddc_adpt->dev);
+out:
+	if (ret != -EPROBE_DEFER)
+		exynos_drm_dev_ready(dev);
+
 	return ret;
 }
 
@@ -2168,6 +2186,7 @@ static int hdmi_remove(struct platform_device *pdev)
 	struct exynos_drm_display *display = get_hdmi_display(dev);
 	struct hdmi_context *hdata = display->ctx;
 
+	exynos_drm_dev_busy(dev);
 	put_device(&hdata->hdmiphy_port->dev);
 	put_device(&hdata->ddc_adpt->dev);
 	pm_runtime_disable(&pdev->dev);
diff --git a/drivers/gpu/drm/exynos/exynos_mixer.c b/drivers/gpu/drm/exynos/exynos_mixer.c
index b978bde..cca1cbb 100644
--- a/drivers/gpu/drm/exynos/exynos_mixer.c
+++ b/drivers/gpu/drm/exynos/exynos_mixer.c
@@ -1205,13 +1205,14 @@ static int mixer_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct mixer_context *ctx;
 	struct mixer_drv_data *drv;
+	int ret;
 
 	dev_info(dev, "probe start\n");
 
 	ctx = devm_kzalloc(&pdev->dev, sizeof(*ctx), GFP_KERNEL);
 	if (!ctx) {
-		DRM_ERROR("failed to alloc mixer context.\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out;
 	}
 
 	mutex_init(&ctx->mixer_mutex);
@@ -1237,12 +1238,18 @@ static int mixer_probe(struct platform_device *pdev)
 	exynos_drm_manager_register(&mixer_manager);
 
 	pm_runtime_enable(dev);
+	ret = 0;
+out:
+	if (ret != -EPROBE_DEFER)
+		exynos_drm_dev_ready(dev);
 
-	return 0;
+	return ret;
 }
 
 static int mixer_remove(struct platform_device *pdev)
 {
+	exynos_drm_dev_busy(&pdev->dev);
+
 	dev_info(&pdev->dev, "remove successful\n");
 
 	pm_runtime_disable(&pdev->dev);
-- 
1.8.3.2

