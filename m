Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930AbaEMPfE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:35:04 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:37943 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761AbaEMPc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:32:58 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        dri-devel@lists.freedesktop.org
Cc: Daniel Vetter <daniel@ffwll.ch>, Rob Clark <robdclark@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/7] drivers/base: Allow multiple masters per device
Date: Tue, 13 May 2014 17:30:46 +0200
Message-Id: <1399995050-28435-4-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1399995050-28435-1-git-send-email-thierry.reding@gmail.com>
References: <1399995050-28435-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Currently the component/master framework allows only a single master to
be registered against a struct device. A master is uniquely identified
by the device and the master operations table, but the current API does
not pass enough information along to allow a master to be uniquely
identified when calling component_unbind_all().

To make it possible to register multiple masters on one device, instead
of passing around the device associated with a master, pass around the
master directly. That way it can always be uniquely identified.

The two existing users of the component/master framework need to be
converted as part of this patch because the API is changed in an
incompatible way. Since the master needs to be associated with the DRM
devices at a precise point, this also drops the drm_platform_init() call
and replaces it by direct drm_dev_alloc()/drm_dev_register() usage.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
Changes in v2:
- convert existing users (staging/imx-drm, gpu/drm/msm)

Notes: I'd like to take this through the Tegra DRM tree if possible so
that the Tegra DRM changes later in this series can be merged at the
same time so as not to delay them for another release cycle.

In particular I'm looking for an Acked-by from Greg and Russell.

 drivers/base/component.c                   | 18 +++----
 drivers/gpu/drm/msm/adreno/a3xx_gpu.c      |  8 ++--
 drivers/gpu/drm/msm/hdmi/hdmi.c            |  8 ++--
 drivers/gpu/drm/msm/msm_drv.c              | 75 ++++++++++++++++++++----------
 drivers/gpu/drm/msm/msm_drv.h              |  1 +
 drivers/staging/imx-drm/imx-drm-core.c     | 58 ++++++++++++++---------
 drivers/staging/imx-drm/imx-hdmi.c         |  4 +-
 drivers/staging/imx-drm/imx-ldb.c          |  4 +-
 drivers/staging/imx-drm/imx-tve.c          |  4 +-
 drivers/staging/imx-drm/ipuv3-crtc.c       |  4 +-
 drivers/staging/imx-drm/parallel-display.c |  4 +-
 include/linux/component.h                  | 17 ++++---
 12 files changed, 120 insertions(+), 85 deletions(-)

diff --git a/drivers/base/component.c b/drivers/base/component.c
index fb4510707281..e3693c6d552f 100644
--- a/drivers/base/component.c
+++ b/drivers/base/component.c
@@ -133,7 +133,7 @@ static int try_to_bring_up_master(struct master *master,
 		 * Search the list of components, looking for components that
 		 * belong to this master, and attach them to the master.
 		 */
-		if (master->ops->add_components(master->dev, master)) {
+		if (master->ops->add_components(master, master->dev)) {
 			/* Failed to find all components */
 			master_remove_components(master);
 			ret = 0;
@@ -152,7 +152,7 @@ static int try_to_bring_up_master(struct master *master,
 		}
 
 		/* Found all components */
-		ret = master->ops->bind(master->dev);
+		ret = master->ops->bind(master, master->dev);
 		if (ret < 0) {
 			devres_release_group(master->dev, NULL);
 			dev_info(master->dev, "master bind failed: %d\n", ret);
@@ -185,7 +185,7 @@ static int try_to_bring_up_masters(struct component *component)
 static void take_down_master(struct master *master)
 {
 	if (master->bound) {
-		master->ops->unbind(master->dev);
+		master->ops->unbind(master, master->dev);
 		devres_release_group(master->dev, NULL);
 		master->bound = false;
 	}
@@ -246,21 +246,19 @@ static void component_unbind(struct component *component,
 {
 	WARN_ON(!component->bound);
 
-	component->ops->unbind(component->dev, master->dev, data);
+	component->ops->unbind(component->dev, master, data);
 	component->bound = false;
 
 	/* Release all resources claimed in the binding of this component */
 	devres_release_group(component->dev, component);
 }
 
-void component_unbind_all(struct device *master_dev, void *data)
+void component_unbind_all(struct master *master, void *data)
 {
-	struct master *master;
 	struct component *c;
 
 	WARN_ON(!mutex_is_locked(&component_mutex));
 
-	master = __master_find(master_dev, NULL);
 	if (!master)
 		return;
 
@@ -295,7 +293,7 @@ static int component_bind(struct component *component, struct master *master,
 	dev_dbg(master->dev, "binding %s (ops %ps)\n",
 		dev_name(component->dev), component->ops);
 
-	ret = component->ops->bind(component->dev, master->dev, data);
+	ret = component->ops->bind(component->dev, master, data);
 	if (!ret) {
 		component->bound = true;
 
@@ -321,15 +319,13 @@ static int component_bind(struct component *component, struct master *master,
 	return ret;
 }
 
-int component_bind_all(struct device *master_dev, void *data)
+int component_bind_all(struct master *master, void *data)
 {
-	struct master *master;
 	struct component *c;
 	int ret = 0;
 
 	WARN_ON(!mutex_is_locked(&component_mutex));
 
-	master = __master_find(master_dev, NULL);
 	if (!master)
 		return -EINVAL;
 
diff --git a/drivers/gpu/drm/msm/adreno/a3xx_gpu.c b/drivers/gpu/drm/msm/adreno/a3xx_gpu.c
index f20fbde5dc49..abd70fa8fed8 100644
--- a/drivers/gpu/drm/msm/adreno/a3xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a3xx_gpu.c
@@ -560,7 +560,7 @@ static void set_gpu_pdev(struct drm_device *dev,
 	priv->gpu_pdev = pdev;
 }
 
-static int a3xx_bind(struct device *dev, struct device *master, void *data)
+static int a3xx_bind(struct device *dev, struct master *master, void *data)
 {
 	static struct adreno_platform_config config = {};
 #ifdef CONFIG_OF
@@ -648,14 +648,14 @@ static int a3xx_bind(struct device *dev, struct device *master, void *data)
 #  endif
 #endif
 	dev->platform_data = &config;
-	set_gpu_pdev(dev_get_drvdata(master), to_platform_device(dev));
+	set_gpu_pdev(master_get_drvdata(master), to_platform_device(dev));
 	return 0;
 }
 
-static void a3xx_unbind(struct device *dev, struct device *master,
+static void a3xx_unbind(struct device *dev, struct master *master,
 		void *data)
 {
-	set_gpu_pdev(dev_get_drvdata(master), NULL);
+	set_gpu_pdev(master_get_drvdata(master), NULL);
 }
 
 static const struct component_ops a3xx_ops = {
diff --git a/drivers/gpu/drm/msm/hdmi/hdmi.c b/drivers/gpu/drm/msm/hdmi/hdmi.c
index ae750f6928c1..1bde0ed59795 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi.c
@@ -256,7 +256,7 @@ static void set_hdmi_pdev(struct drm_device *dev,
 	priv->hdmi_pdev = pdev;
 }
 
-static int hdmi_bind(struct device *dev, struct device *master, void *data)
+static int hdmi_bind(struct device *dev, struct master *master, void *data)
 {
 	static struct hdmi_platform_config config = {};
 #ifdef CONFIG_OF
@@ -344,14 +344,14 @@ static int hdmi_bind(struct device *dev, struct device *master, void *data)
 	}
 #endif
 	dev->platform_data = &config;
-	set_hdmi_pdev(dev_get_drvdata(master), to_platform_device(dev));
+	set_hdmi_pdev(master_get_drvdata(master), to_platform_device(dev));
 	return 0;
 }
 
-static void hdmi_unbind(struct device *dev, struct device *master,
+static void hdmi_unbind(struct device *dev, struct master *master,
 		void *data)
 {
-	set_hdmi_pdev(dev_get_drvdata(master), NULL);
+	set_hdmi_pdev(master_get_drvdata(master), NULL);
 }
 
 static const struct component_ops hdmi_ops = {
diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
index bcee218b150b..f2fcd17b439f 100644
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -147,7 +147,7 @@ static int msm_unload(struct drm_device *dev)
 				priv->vram.paddr, &attrs);
 	}
 
-	component_unbind_all(dev->dev, dev);
+	component_unbind_all(priv->master, dev);
 
 	dev->dev_private = NULL;
 
@@ -177,19 +177,10 @@ static int get_mdp_ver(struct platform_device *pdev)
 static int msm_load(struct drm_device *dev, unsigned long flags)
 {
 	struct platform_device *pdev = dev->platformdev;
-	struct msm_drm_private *priv;
+	struct msm_drm_private *priv = dev->dev_private;
 	struct msm_kms *kms;
 	int ret;
 
-
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-	if (!priv) {
-		dev_err(dev->dev, "failed to allocate private data\n");
-		return -ENOMEM;
-	}
-
-	dev->dev_private = priv;
-
 	priv->wq = alloc_ordered_workqueue("msm", 0);
 	init_waitqueue_head(&priv->fence_event);
 
@@ -236,7 +227,7 @@ static int msm_load(struct drm_device *dev, unsigned long flags)
 	platform_set_drvdata(pdev, dev);
 
 	/* Bind all our sub-components: */
-	ret = component_bind_all(dev->dev, dev);
+	ret = component_bind_all(priv->master, dev);
 	if (ret)
 		return ret;
 
@@ -889,9 +880,9 @@ static int compare_of(struct device *dev, void *data)
 	return dev->of_node == data;
 }
 
-static int msm_drm_add_components(struct device *master, struct master *m)
+static int msm_drm_add_components(struct master *master, struct device *dev)
 {
-	struct device_node *np = master->of_node;
+	struct device_node *np = dev->of_node;
 	unsigned i;
 	int ret;
 
@@ -902,7 +893,7 @@ static int msm_drm_add_components(struct device *master, struct master *m)
 		if (!node)
 			break;
 
-		ret = component_master_add_child(m, compare_of, node);
+		ret = component_master_add_child(master, compare_of, node);
 		of_node_put(node);
 
 		if (ret)
@@ -916,7 +907,7 @@ static int compare_dev(struct device *dev, void *data)
 	return dev == data;
 }
 
-static int msm_drm_add_components(struct device *master, struct master *m)
+static int msm_drm_add_components(struct master *master, struct device *dev)
 {
 	/* For non-DT case, it kinda sucks.  We don't actually have a way
 	 * to know whether or not we are waiting for certain devices (or if
@@ -931,17 +922,17 @@ static int msm_drm_add_components(struct device *master, struct master *m)
 	DBG("Adding components..");
 
 	for (i = 0; i < ARRAY_SIZE(devnames); i++) {
-		struct device *dev;
+		struct device *component;
 		int ret;
 
-		dev = bus_find_device_by_name(&platform_bus_type,
+		component = bus_find_device_by_name(&platform_bus_type,
 				NULL, devnames[i]);
-		if (!dev) {
-			dev_info(master, "still waiting for %s\n", devnames[i]);
+		if (!component) {
+			dev_info(dev, "still waiting for %s\n", devnames[i]);
 			return -EPROBE_DEFER;
 		}
 
-		ret = component_master_add_child(m, compare_dev, dev);
+		ret = component_master_add_child(master, compare_dev, component);
 		if (ret) {
 			DBG("could not add child: %d", ret);
 			return ret;
@@ -952,14 +943,48 @@ static int msm_drm_add_components(struct device *master, struct master *m)
 }
 #endif
 
-static int msm_drm_bind(struct device *dev)
+static int msm_drm_bind(struct master *master, struct device *dev)
 {
-	return drm_platform_init(&msm_driver, to_platform_device(dev));
+	struct msm_drm_private *priv;
+	struct drm_device *drm;
+	int err;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv) {
+		dev_err(dev, "failed to allocate private data\n");
+		return -ENOMEM;
+	}
+
+	priv->master = master;
+
+	drm = drm_dev_alloc(&msm_driver, dev);
+	if (!drm) {
+		err = -ENOMEM;
+		goto free;
+	}
+
+	drm_set_unique(drm, "%s", dev_name(dev));
+	master_set_drvdata(master, drm);
+	drm->dev_private = priv;
+
+	err = drm_dev_register(drm, 0);
+	if (err < 0)
+		goto unref;
+
+	return 0;
+
+unref:
+	drm_dev_unref(drm);
+free:
+	kfree(priv);
+	return err;
 }
 
-static void msm_drm_unbind(struct device *dev)
+static void msm_drm_unbind(struct master *master, struct device *dev)
 {
-	drm_put_dev(platform_get_drvdata(to_platform_device(dev)));
+	struct drm_device *drm = master_get_drvdata(master);
+
+	drm_put_dev(drm);
 }
 
 static const struct component_master_ops msm_drm_ops = {
diff --git a/drivers/gpu/drm/msm/msm_drv.h b/drivers/gpu/drm/msm/msm_drv.h
index e5797d8ad927..3b5ca492c598 100644
--- a/drivers/gpu/drm/msm/msm_drv.h
+++ b/drivers/gpu/drm/msm/msm_drv.h
@@ -68,6 +68,7 @@ struct msm_file_private {
 };
 
 struct msm_drm_private {
+	struct master *master;
 
 	struct msm_kms *kms;
 
diff --git a/drivers/staging/imx-drm/imx-drm-core.c b/drivers/staging/imx-drm/imx-drm-core.c
index c270c9ae6d27..ded69beb0652 100644
--- a/drivers/staging/imx-drm/imx-drm-core.c
+++ b/drivers/staging/imx-drm/imx-drm-core.c
@@ -37,6 +37,7 @@ struct imx_drm_component {
 };
 
 struct imx_drm_device {
+	struct master				*master;
 	struct drm_device			*drm;
 	struct imx_drm_crtc			*crtc[MAX_CRTC];
 	int					pipes;
@@ -71,9 +72,7 @@ static void imx_drm_driver_lastclose(struct drm_device *drm)
 
 static int imx_drm_driver_unload(struct drm_device *drm)
 {
-#if IS_ENABLED(CONFIG_DRM_IMX_FB_HELPER)
 	struct imx_drm_device *imxdrm = drm->dev_private;
-#endif
 
 	drm_kms_helper_poll_fini(drm);
 
@@ -82,7 +81,7 @@ static int imx_drm_driver_unload(struct drm_device *drm)
 		drm_fbdev_cma_fini(imxdrm->fbhelper);
 #endif
 
-	component_unbind_all(drm->dev, drm);
+	component_unbind_all(imxdrm->master, drm);
 
 	drm_vblank_cleanup(drm);
 	drm_mode_config_cleanup(drm);
@@ -240,18 +239,10 @@ static struct drm_mode_config_funcs imx_drm_mode_config_funcs = {
  */
 static int imx_drm_driver_load(struct drm_device *drm, unsigned long flags)
 {
-	struct imx_drm_device *imxdrm;
+	struct imx_drm_device *imxdrm = drm->dev_private;
 	struct drm_connector *connector;
 	int ret;
 
-	imxdrm = devm_kzalloc(drm->dev, sizeof(*imxdrm), GFP_KERNEL);
-	if (!imxdrm)
-		return -ENOMEM;
-
-	imxdrm->drm = drm;
-
-	drm->dev_private = imxdrm;
-
 	/*
 	 * enable drm irq mode.
 	 * - with irq_enabled = true, we can use the vblank feature.
@@ -287,10 +278,8 @@ static int imx_drm_driver_load(struct drm_device *drm, unsigned long flags)
 	 */
 	drm->vblank_disable_allowed = true;
 
-	platform_set_drvdata(drm->platformdev, drm);
-
 	/* Now try and bind all our sub-components */
-	ret = component_bind_all(drm->dev, drm);
+	ret = component_bind_all(imxdrm->master, drm);
 	if (ret)
 		goto err_vblank;
 
@@ -334,7 +323,7 @@ static int imx_drm_driver_load(struct drm_device *drm, unsigned long flags)
 	return 0;
 
 err_unbind:
-	component_unbind_all(drm->dev, drm);
+	component_unbind_all(imxdrm->master, drm);
 err_vblank:
 	drm_vblank_cleanup(drm);
 err_kms:
@@ -579,13 +568,13 @@ static int compare_of(struct device *dev, void *data)
 
 static LIST_HEAD(imx_drm_components);
 
-static int imx_drm_add_components(struct device *master, struct master *m)
+static int imx_drm_add_components(struct master *master, struct device *dev)
 {
 	struct imx_drm_component *component;
 	int ret;
 
 	list_for_each_entry(component, &imx_drm_components, list) {
-		ret = component_master_add_child(m, compare_of,
+		ret = component_master_add_child(master, compare_of,
 						 component->of_node);
 		if (ret)
 			return ret;
@@ -593,14 +582,39 @@ static int imx_drm_add_components(struct device *master, struct master *m)
 	return 0;
 }
 
-static int imx_drm_bind(struct device *dev)
+static int imx_drm_bind(struct master *master, struct device *dev)
 {
-	return drm_platform_init(&imx_drm_driver, to_platform_device(dev));
+	struct imx_drm_device *imxdrm;
+	int err;
+
+	imxdrm = devm_kzalloc(dev, sizeof(*imxdrm), GFP_KERNEL);
+	if (!imxdrm)
+		return -ENOMEM;
+
+	imxdrm->master = master;
+
+	imxdrm->drm = drm_dev_alloc(&imx_drm_driver, dev);
+	if (!imxdrm->drm)
+		return -ENOMEM;
+
+	drm_set_unique(imxdrm->drm, "%s", dev_name(dev));
+	master_set_drvdata(master, imxdrm);
+	imxdrm->drm->dev_private = imxdrm;
+
+	err = drm_dev_register(imxdrm->drm, 0);
+	if (err < 0) {
+		drm_dev_unref(imxdrm->drm);
+		return err;
+	}
+
+	return 0;
 }
 
-static void imx_drm_unbind(struct device *dev)
+static void imx_drm_unbind(struct master *master, struct device *dev)
 {
-	drm_put_dev(dev_get_drvdata(dev));
+	struct imx_drm_device *imxdrm = master_get_drvdata(master);
+
+	drm_put_dev(imxdrm->drm);
 }
 
 static const struct component_master_ops imx_drm_ops = {
diff --git a/drivers/staging/imx-drm/imx-hdmi.c b/drivers/staging/imx-drm/imx-hdmi.c
index 886a0d49031b..9ec69a25ade5 100644
--- a/drivers/staging/imx-drm/imx-hdmi.c
+++ b/drivers/staging/imx-drm/imx-hdmi.c
@@ -1584,7 +1584,7 @@ static const struct of_device_id imx_hdmi_dt_ids[] = {
 };
 MODULE_DEVICE_TABLE(of, imx_hdmi_dt_ids);
 
-static int imx_hdmi_bind(struct device *dev, struct device *master, void *data)
+static int imx_hdmi_bind(struct device *dev, struct master *master, void *data)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	const struct of_device_id *of_id =
@@ -1717,7 +1717,7 @@ err_isfr:
 	return ret;
 }
 
-static void imx_hdmi_unbind(struct device *dev, struct device *master,
+static void imx_hdmi_unbind(struct device *dev, struct master *master,
 	void *data)
 {
 	struct imx_hdmi *hdmi = dev_get_drvdata(dev);
diff --git a/drivers/staging/imx-drm/imx-ldb.c b/drivers/staging/imx-drm/imx-ldb.c
index fe4c1ef4e7a5..b42bc2e01b60 100644
--- a/drivers/staging/imx-drm/imx-ldb.c
+++ b/drivers/staging/imx-drm/imx-ldb.c
@@ -436,7 +436,7 @@ static const struct of_device_id imx_ldb_dt_ids[] = {
 };
 MODULE_DEVICE_TABLE(of, imx_ldb_dt_ids);
 
-static int imx_ldb_bind(struct device *dev, struct device *master, void *data)
+static int imx_ldb_bind(struct device *dev, struct master *master, void *data)
 {
 	struct drm_device *drm = data;
 	struct device_node *np = dev->of_node;
@@ -566,7 +566,7 @@ static int imx_ldb_bind(struct device *dev, struct device *master, void *data)
 	return 0;
 }
 
-static void imx_ldb_unbind(struct device *dev, struct device *master,
+static void imx_ldb_unbind(struct device *dev, struct master *master,
 	void *data)
 {
 	struct imx_ldb *imx_ldb = dev_get_drvdata(dev);
diff --git a/drivers/staging/imx-drm/imx-tve.c b/drivers/staging/imx-drm/imx-tve.c
index a23f4f773146..5e6821461f9b 100644
--- a/drivers/staging/imx-drm/imx-tve.c
+++ b/drivers/staging/imx-drm/imx-tve.c
@@ -562,7 +562,7 @@ static const int of_get_tve_mode(struct device_node *np)
 	return -EINVAL;
 }
 
-static int imx_tve_bind(struct device *dev, struct device *master, void *data)
+static int imx_tve_bind(struct device *dev, struct master *master, void *data)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct drm_device *drm = data;
@@ -689,7 +689,7 @@ static int imx_tve_bind(struct device *dev, struct device *master, void *data)
 	return 0;
 }
 
-static void imx_tve_unbind(struct device *dev, struct device *master,
+static void imx_tve_unbind(struct device *dev, struct master *master,
 	void *data)
 {
 	struct imx_tve *tve = dev_get_drvdata(dev);
diff --git a/drivers/staging/imx-drm/ipuv3-crtc.c b/drivers/staging/imx-drm/ipuv3-crtc.c
index 47bec5e17358..866b2a74108c 100644
--- a/drivers/staging/imx-drm/ipuv3-crtc.c
+++ b/drivers/staging/imx-drm/ipuv3-crtc.c
@@ -429,7 +429,7 @@ static struct device_node *ipu_drm_get_port_by_id(struct device_node *parent,
 	return NULL;
 }
 
-static int ipu_drm_bind(struct device *dev, struct device *master, void *data)
+static int ipu_drm_bind(struct device *dev, struct master *master, void *data)
 {
 	struct ipu_client_platformdata *pdata = dev->platform_data;
 	struct drm_device *drm = data;
@@ -451,7 +451,7 @@ static int ipu_drm_bind(struct device *dev, struct device *master, void *data)
 	return 0;
 }
 
-static void ipu_drm_unbind(struct device *dev, struct device *master,
+static void ipu_drm_unbind(struct device *dev, struct master *master,
 	void *data)
 {
 	struct ipu_crtc *ipu_crtc = dev_get_drvdata(dev);
diff --git a/drivers/staging/imx-drm/parallel-display.c b/drivers/staging/imx-drm/parallel-display.c
index eaf4dda1a0c4..d2bfe1e9d32d 100644
--- a/drivers/staging/imx-drm/parallel-display.c
+++ b/drivers/staging/imx-drm/parallel-display.c
@@ -193,7 +193,7 @@ static int imx_pd_register(struct drm_device *drm,
 	return 0;
 }
 
-static int imx_pd_bind(struct device *dev, struct device *master, void *data)
+static int imx_pd_bind(struct device *dev, struct master *master, void *data)
 {
 	struct drm_device *drm = data;
 	struct device_node *np = dev->of_node;
@@ -238,7 +238,7 @@ static int imx_pd_bind(struct device *dev, struct device *master, void *data)
 	return 0;
 }
 
-static void imx_pd_unbind(struct device *dev, struct device *master,
+static void imx_pd_unbind(struct device *dev, struct master *master,
 	void *data)
 {
 	struct imx_parallel_display *imxpd = dev_get_drvdata(dev);
diff --git a/include/linux/component.h b/include/linux/component.h
index f130b34b1575..9c2ec9fe48d6 100644
--- a/include/linux/component.h
+++ b/include/linux/component.h
@@ -2,24 +2,23 @@
 #define COMPONENT_H
 
 struct device;
+struct master;
 
 struct component_ops {
-	int (*bind)(struct device *, struct device *, void *);
-	void (*unbind)(struct device *, struct device *, void *);
+	int (*bind)(struct device *, struct master *, void *);
+	void (*unbind)(struct device *, struct master *, void *);
 };
 
 int component_add(struct device *, const struct component_ops *);
 void component_del(struct device *, const struct component_ops *);
 
-int component_bind_all(struct device *, void *);
-void component_unbind_all(struct device *, void *);
-
-struct master;
+int component_bind_all(struct master *, void *);
+void component_unbind_all(struct master *, void *);
 
 struct component_master_ops {
-	int (*add_components)(struct device *, struct master *);
-	int (*bind)(struct device *);
-	void (*unbind)(struct device *);
+	int (*add_components)(struct master *, struct device *);
+	int (*bind)(struct master *, struct device *);
+	void (*unbind)(struct master *, struct device *);
 };
 
 int component_master_add(struct device *, const struct component_master_ops *);
-- 
1.9.2

