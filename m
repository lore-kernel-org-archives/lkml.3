Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035AbaDVPNz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:13:55 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:39296 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756810AbaDVPLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:11:00 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: [RFC 5/5] drm/tegra: Convert to master/component framework
Date: Tue, 22 Apr 2014 17:09:33 +0200
Message-Id: <1398179373-29966-6-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398179373-29966-1-git-send-email-thierry.reding@gmail.com>
References: <1398179373-29966-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Instead of the current implementation, reuse the recently introduced
master/component framework, which is equivalent in most regards. One
issue is that there is no device to bind the DRM driver to. In order
to still allow the driver to be probed, expose an interface from the
host1x device and provide an interface driver to bind to that.

The interface driver then registers (or removes) the master that will be
used to instantiate and bind the DRM driver. Since the drm_host1x bus
implementation is now gone the dummy device instantiated by it can no
longer be used as the parent for the DRM device. However since the
parent device doesn't need to be modified, the host1x parent device that
exposes the interface can be used instead.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/gpu/drm/tegra/Makefile |   1 -
 drivers/gpu/drm/tegra/bus.c    |  64 -----
 drivers/gpu/drm/tegra/dc.c     |  58 ++---
 drivers/gpu/drm/tegra/drm.c    | 171 +++++++++----
 drivers/gpu/drm/tegra/drm.h    |  27 +-
 drivers/gpu/drm/tegra/dsi.c    | 144 +++++------
 drivers/gpu/drm/tegra/gr2d.c   |  78 +++---
 drivers/gpu/drm/tegra/gr3d.c   |  77 +++---
 drivers/gpu/drm/tegra/hdmi.c   |  69 ++---
 drivers/gpu/drm/tegra/sor.c    |  71 ++----
 drivers/gpu/host1x/Makefile    |   1 -
 drivers/gpu/host1x/bus.c       | 553 -----------------------------------------
 drivers/gpu/host1x/bus.h       |  29 ---
 drivers/gpu/host1x/dev.c       |  21 +-
 drivers/gpu/host1x/dev.h       |   7 +-
 include/linux/host1x.h         |  64 +----
 16 files changed, 332 insertions(+), 1103 deletions(-)
 delete mode 100644 drivers/gpu/drm/tegra/bus.c
 delete mode 100644 drivers/gpu/host1x/bus.c
 delete mode 100644 drivers/gpu/host1x/bus.h

diff --git a/drivers/gpu/drm/tegra/Makefile b/drivers/gpu/drm/tegra/Makefile
index 905f6cad1061..e24584eb2e58 100644
--- a/drivers/gpu/drm/tegra/Makefile
+++ b/drivers/gpu/drm/tegra/Makefile
@@ -1,7 +1,6 @@
 ccflags-$(CONFIG_DRM_TEGRA_DEBUG) += -DDEBUG
 
 tegra-drm-y := \
-	bus.o \
 	drm.o \
 	gem.o \
 	fb.o \
diff --git a/drivers/gpu/drm/tegra/bus.c b/drivers/gpu/drm/tegra/bus.c
deleted file mode 100644
index b3a66d65cb53..000000000000
--- a/drivers/gpu/drm/tegra/bus.c
+++ /dev/null
@@ -1,64 +0,0 @@
-/*
- * Copyright (C) 2013 NVIDIA Corporation
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include "drm.h"
-
-static int drm_host1x_set_busid(struct drm_device *dev,
-				struct drm_master *master)
-{
-	const char *device = dev_name(dev->dev);
-	const char *bus = dev->dev->bus->name;
-
-	master->unique_len = strlen(bus) + 1 + strlen(device);
-	master->unique_size = master->unique_len;
-
-	master->unique = kmalloc(master->unique_len + 1, GFP_KERNEL);
-	if (!master->unique)
-		return -ENOMEM;
-
-	snprintf(master->unique, master->unique_len + 1, "%s:%s", bus, device);
-
-	return 0;
-}
-
-static struct drm_bus drm_host1x_bus = {
-	.set_busid = drm_host1x_set_busid,
-};
-
-int drm_host1x_init(struct drm_driver *driver, struct host1x_device *device)
-{
-	struct drm_device *drm;
-	int ret;
-
-	driver->bus = &drm_host1x_bus;
-
-	drm = drm_dev_alloc(driver, &device->dev);
-	if (!drm)
-		return -ENOMEM;
-
-	ret = drm_dev_register(drm, 0);
-	if (ret)
-		goto err_free;
-
-	DRM_INFO("Initialized %s %d.%d.%d %s on minor %d\n", driver->name,
-		 driver->major, driver->minor, driver->patchlevel,
-		 driver->date, drm->primary->index);
-
-	return 0;
-
-err_free:
-	drm_dev_unref(drm);
-	return ret;
-}
-
-void drm_host1x_exit(struct drm_driver *driver, struct host1x_device *device)
-{
-	struct tegra_drm *tegra = dev_get_drvdata(&device->dev);
-
-	drm_put_dev(tegra->drm);
-}
diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index 3a54cf01e9fc..fc97d8a64cb6 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -1102,10 +1102,10 @@ static int tegra_dc_debugfs_exit(struct tegra_dc *dc)
 	return 0;
 }
 
-static int tegra_dc_init(struct host1x_client *client)
+static int tegra_dc_bind(struct device *dev, struct master *master, void *data)
 {
-	struct tegra_drm *tegra = dev_get_drvdata(client->parent);
-	struct tegra_dc *dc = host1x_client_to_dc(client);
+	struct tegra_drm *tegra = master_get_drvdata(master);
+	struct tegra_dc *dc = dev_get_drvdata(dev);
 	int err;
 
 	drm_crtc_init(tegra->drm, &dc->base, &tegra_crtc_funcs);
@@ -1114,7 +1114,7 @@ static int tegra_dc_init(struct host1x_client *client)
 
 	err = tegra_dc_rgb_init(tegra->drm, dc);
 	if (err < 0 && err != -ENODEV) {
-		dev_err(dc->dev, "failed to initialize RGB output: %d\n", err);
+		dev_err(dev, "failed to initialize RGB output: %d\n", err);
 		return err;
 	}
 
@@ -1125,23 +1125,23 @@ static int tegra_dc_init(struct host1x_client *client)
 	if (IS_ENABLED(CONFIG_DEBUG_FS)) {
 		err = tegra_dc_debugfs_init(dc, tegra->drm->primary);
 		if (err < 0)
-			dev_err(dc->dev, "debugfs setup failed: %d\n", err);
+			dev_err(dev, "debugfs setup failed: %d\n", err);
 	}
 
-	err = devm_request_irq(dc->dev, dc->irq, tegra_dc_irq, 0,
-			       dev_name(dc->dev), dc);
+	err = devm_request_irq(dev, dc->irq, tegra_dc_irq, 0, dev_name(dev),
+			       dc);
 	if (err < 0) {
-		dev_err(dc->dev, "failed to request IRQ#%u: %d\n", dc->irq,
-			err);
+		dev_err(dev, "failed to request IRQ#%u: %d\n", dc->irq, err);
 		return err;
 	}
 
 	return 0;
 }
 
-static int tegra_dc_exit(struct host1x_client *client)
+static void tegra_dc_unbind(struct device *dev, struct master *master,
+			    void *data)
 {
-	struct tegra_dc *dc = host1x_client_to_dc(client);
+	struct tegra_dc *dc = dev_get_drvdata(dev);
 	int err;
 
 	devm_free_irq(dc->dev, dc->irq, dc);
@@ -1149,21 +1149,17 @@ static int tegra_dc_exit(struct host1x_client *client)
 	if (IS_ENABLED(CONFIG_DEBUG_FS)) {
 		err = tegra_dc_debugfs_exit(dc);
 		if (err < 0)
-			dev_err(dc->dev, "debugfs cleanup failed: %d\n", err);
+			dev_err(dev, "debugfs cleanup failed: %d\n", err);
 	}
 
 	err = tegra_dc_rgb_exit(dc);
-	if (err) {
-		dev_err(dc->dev, "failed to shutdown RGB output: %d\n", err);
-		return err;
-	}
-
-	return 0;
+	if (err)
+		dev_err(dev, "failed to shutdown RGB output: %d\n", err);
 }
 
-static const struct host1x_client_ops dc_client_ops = {
-	.init = tegra_dc_init,
-	.exit = tegra_dc_exit,
+static const struct component_ops tegra_dc_component_ops = {
+	.bind = tegra_dc_bind,
+	.unbind = tegra_dc_unbind,
 };
 
 static const struct tegra_dc_soc_info tegra20_dc_soc_info = {
@@ -1239,6 +1235,8 @@ static int tegra_dc_probe(struct platform_device *pdev)
 	if (!dc)
 		return -ENOMEM;
 
+	platform_set_drvdata(pdev, dc);
+
 	id = of_match_node(tegra_dc_of_match, pdev->dev.of_node);
 	if (!id)
 		return -ENODEV;
@@ -1279,25 +1277,18 @@ static int tegra_dc_probe(struct platform_device *pdev)
 		return -ENXIO;
 	}
 
-	INIT_LIST_HEAD(&dc->client.list);
-	dc->client.ops = &dc_client_ops;
-	dc->client.dev = &pdev->dev;
-
 	err = tegra_dc_rgb_probe(dc);
 	if (err < 0 && err != -ENODEV) {
 		dev_err(&pdev->dev, "failed to probe RGB output: %d\n", err);
 		return err;
 	}
 
-	err = host1x_client_register(&dc->client);
+	err = component_add(&pdev->dev, &tegra_dc_component_ops);
 	if (err < 0) {
-		dev_err(&pdev->dev, "failed to register host1x client: %d\n",
-			err);
+		dev_err(&pdev->dev, "failed to register component: %d\n", err);
 		return err;
 	}
 
-	platform_set_drvdata(pdev, dc);
-
 	return 0;
 }
 
@@ -1306,12 +1297,7 @@ static int tegra_dc_remove(struct platform_device *pdev)
 	struct tegra_dc *dc = platform_get_drvdata(pdev);
 	int err;
 
-	err = host1x_client_unregister(&dc->client);
-	if (err < 0) {
-		dev_err(&pdev->dev, "failed to unregister host1x client: %d\n",
-			err);
-		return err;
-	}
+	component_del(&pdev->dev, &tegra_dc_component_ops);
 
 	err = tegra_dc_rgb_remove(dc);
 	if (err < 0) {
diff --git a/drivers/gpu/drm/tegra/drm.c b/drivers/gpu/drm/tegra/drm.c
index d492c2f12ca8..78f7ab6d355b 100644
--- a/drivers/gpu/drm/tegra/drm.c
+++ b/drivers/gpu/drm/tegra/drm.c
@@ -7,7 +7,9 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/component.h>
 #include <linux/host1x.h>
+#include <linux/interface.h>
 
 #include "drm.h"
 #include "gem.h"
@@ -25,20 +27,9 @@ struct tegra_drm_file {
 
 static int tegra_drm_load(struct drm_device *drm, unsigned long flags)
 {
-	struct host1x_device *device = to_host1x_device(drm->dev);
-	struct tegra_drm *tegra;
+	struct tegra_drm *tegra = drm->dev_private;
 	int err;
 
-	tegra = kzalloc(sizeof(*tegra), GFP_KERNEL);
-	if (!tegra)
-		return -ENOMEM;
-
-	dev_set_drvdata(drm->dev, tegra);
-	mutex_init(&tegra->clients_lock);
-	INIT_LIST_HEAD(&tegra->clients);
-	drm->dev_private = tegra;
-	tegra->drm = drm;
-
 	drm_mode_config_init(drm);
 
 	err = tegra_drm_fb_prepare(drm);
@@ -47,7 +38,7 @@ static int tegra_drm_load(struct drm_device *drm, unsigned long flags)
 
 	drm_kms_helper_poll_init(drm);
 
-	err = host1x_device_init(device);
+	err = component_bind_all(tegra->master, drm);
 	if (err < 0)
 		return err;
 
@@ -71,17 +62,14 @@ static int tegra_drm_load(struct drm_device *drm, unsigned long flags)
 
 static int tegra_drm_unload(struct drm_device *drm)
 {
-	struct host1x_device *device = to_host1x_device(drm->dev);
-	int err;
+	struct tegra_drm *tegra = drm->dev_private;
 
 	drm_kms_helper_poll_fini(drm);
 	tegra_drm_fb_exit(drm);
-	drm_vblank_cleanup(drm);
 	drm_mode_config_cleanup(drm);
+	drm_vblank_cleanup(drm);
 
-	err = host1x_device_exit(device);
-	if (err < 0)
-		return err;
+	component_unbind_all(tegra->master, drm);
 
 	return 0;
 }
@@ -162,7 +150,7 @@ int tegra_drm_submit(struct tegra_drm_context *context,
 	job->num_relocs = args->num_relocs;
 	job->num_waitchk = args->num_waitchks;
 	job->client = (u32)args->context;
-	job->class = context->client->base.class;
+	job->class = context->client->class;
 	job->serialize = true;
 
 	while (num_cmdbufs) {
@@ -227,7 +215,7 @@ int tegra_drm_submit(struct tegra_drm_context *context,
 	if (args->timeout && args->timeout < 10000)
 		job->timeout = args->timeout;
 
-	err = host1x_job_pin(job, context->client->base.dev);
+	err = host1x_job_pin(job, context->client->dev);
 	if (err)
 		goto fail;
 
@@ -303,7 +291,7 @@ static int tegra_gem_mmap(struct drm_device *drm, void *data,
 static int tegra_syncpt_read(struct drm_device *drm, void *data,
 			     struct drm_file *file)
 {
-	struct host1x *host = dev_get_drvdata(drm->dev->parent);
+	struct host1x *host = dev_get_drvdata(drm->dev);
 	struct drm_tegra_syncpt_read *args = data;
 	struct host1x_syncpt *sp;
 
@@ -318,7 +306,7 @@ static int tegra_syncpt_read(struct drm_device *drm, void *data,
 static int tegra_syncpt_incr(struct drm_device *drm, void *data,
 			     struct drm_file *file)
 {
-	struct host1x *host1x = dev_get_drvdata(drm->dev->parent);
+	struct host1x *host1x = dev_get_drvdata(drm->dev);
 	struct drm_tegra_syncpt_incr *args = data;
 	struct host1x_syncpt *sp;
 
@@ -332,7 +320,7 @@ static int tegra_syncpt_incr(struct drm_device *drm, void *data,
 static int tegra_syncpt_wait(struct drm_device *drm, void *data,
 			     struct drm_file *file)
 {
-	struct host1x *host1x = dev_get_drvdata(drm->dev->parent);
+	struct host1x *host1x = dev_get_drvdata(drm->dev);
 	struct drm_tegra_syncpt_wait *args = data;
 	struct host1x_syncpt *sp;
 
@@ -359,7 +347,7 @@ static int tegra_open_channel(struct drm_device *drm, void *data,
 		return -ENOMEM;
 
 	list_for_each_entry(client, &tegra->clients, list)
-		if (client->base.class == args->client) {
+		if (client->class == args->client) {
 			err = client->ops->open_channel(client, context);
 			if (err)
 				break;
@@ -405,10 +393,10 @@ static int tegra_get_syncpt(struct drm_device *drm, void *data,
 	if (!tegra_drm_file_owns_context(fpriv, context))
 		return -ENODEV;
 
-	if (args->index >= context->client->base.num_syncpts)
+	if (args->index >= context->client->num_syncpts)
 		return -EINVAL;
 
-	syncpt = context->client->base.syncpts[args->index];
+	syncpt = context->client->syncpts[args->index];
 	args->id = host1x_syncpt_id(syncpt);
 
 	return 0;
@@ -443,10 +431,10 @@ static int tegra_get_syncpt_base(struct drm_device *drm, void *data,
 	if (!tegra_drm_file_owns_context(fpriv, context))
 		return -ENODEV;
 
-	if (args->syncpt >= context->client->base.num_syncpts)
+	if (args->syncpt >= context->client->num_syncpts)
 		return -EINVAL;
 
-	syncpt = context->client->base.syncpts[args->syncpt];
+	syncpt = context->client->syncpts[args->syncpt];
 
 	base = host1x_syncpt_get_base(syncpt);
 	if (!base)
@@ -644,19 +632,7 @@ int tegra_drm_unregister_client(struct tegra_drm *tegra,
 	return 0;
 }
 
-static int host1x_drm_probe(struct host1x_device *device)
-{
-	return drm_host1x_init(&tegra_drm_driver, device);
-}
-
-static int host1x_drm_remove(struct host1x_device *device)
-{
-	drm_host1x_exit(&tegra_drm_driver, device);
-
-	return 0;
-}
-
-static const struct of_device_id host1x_drm_subdevs[] = {
+static const struct of_device_id tegra_drm_subdevs[] = {
 	{ .compatible = "nvidia,tegra20-dc", },
 	{ .compatible = "nvidia,tegra20-hdmi", },
 	{ .compatible = "nvidia,tegra20-gr2d", },
@@ -674,18 +650,105 @@ static const struct of_device_id host1x_drm_subdevs[] = {
 	{ /* sentinel */ }
 };
 
-static struct host1x_driver host1x_drm_driver = {
-	.name = "drm",
-	.probe = host1x_drm_probe,
-	.remove = host1x_drm_remove,
-	.subdevs = host1x_drm_subdevs,
+static int tegra_drm_compare(struct device *dev, void *data)
+{
+	struct device_node *np = data;
+
+	return dev->of_node == np;
+}
+
+static int tegra_drm_add_components(struct master *master, struct device *dev)
+{
+	struct device_node *np;
+	int err = 0;
+
+	for_each_child_of_node(dev->of_node, np) {
+		if (!of_device_is_available(np))
+			continue;
+
+		if (!of_match_node(tegra_drm_subdevs, np))
+			continue;
+
+		err = component_master_add_child(master, tegra_drm_compare, np);
+		if (err < 0)
+			break;
+	}
+
+	return err;
+}
+
+static int tegra_drm_bind(struct master *master, struct device *dev)
+{
+	struct tegra_drm *tegra;
+	struct drm_device *drm;
+	int err;
+
+	tegra = kzalloc(sizeof(*tegra), GFP_KERNEL);
+	if (!tegra)
+		return -ENOMEM;
+
+	mutex_init(&tegra->clients_lock);
+	INIT_LIST_HEAD(&tegra->clients);
+	tegra->master = master;
+
+	drm = drm_dev_alloc(&tegra_drm_driver, dev);
+	if (!dev) {
+		err = -ENOMEM;
+		goto free;
+	}
+
+	drm_set_unique(drm, "%s", dev_name(dev));
+	master_set_drvdata(master, tegra);
+	drm->dev_private = tegra;
+	tegra->drm = drm;
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
+	kfree(tegra);
+	return err;
+}
+
+static void tegra_drm_unbind(struct master *master, struct device *dev)
+{
+	struct tegra_drm *tegra = master_get_drvdata(master);
+
+	drm_put_dev(tegra->drm);
+}
+
+static const struct component_master_ops tegra_drm_master_ops = {
+	.add_components = tegra_drm_add_components,
+	.bind = tegra_drm_bind,
+	.unbind = tegra_drm_unbind,
+};
+
+static int host1x_interface_bind(struct interface *intf)
+{
+	return component_master_add(intf->dev, &tegra_drm_master_ops);
+}
+
+static void host1x_interface_unbind(struct interface *intf)
+{
+	component_master_del(intf->dev, &tegra_drm_master_ops);
+}
+
+static struct interface_driver host1x_interface_driver = {
+	.name = "nvidia,tegra-host1x",
+	.bind = host1x_interface_bind,
+	.unbind = host1x_interface_unbind,
 };
 
-static int __init host1x_drm_init(void)
+static int __init tegra_drm_init(void)
 {
 	int err;
 
-	err = host1x_driver_register(&host1x_drm_driver);
+	err = interface_register_driver(&host1x_interface_driver);
 	if (err < 0)
 		return err;
 
@@ -732,12 +795,12 @@ unregister_dsi:
 unregister_dc:
 	platform_driver_unregister(&tegra_dc_driver);
 unregister_host1x:
-	host1x_driver_unregister(&host1x_drm_driver);
+	interface_unregister_driver(&host1x_interface_driver);
 	return err;
 }
-module_init(host1x_drm_init);
+module_init(tegra_drm_init);
 
-static void __exit host1x_drm_exit(void)
+static void __exit tegra_drm_exit(void)
 {
 	platform_driver_unregister(&tegra_gr3d_driver);
 	platform_driver_unregister(&tegra_gr2d_driver);
@@ -746,9 +809,9 @@ static void __exit host1x_drm_exit(void)
 	platform_driver_unregister(&tegra_sor_driver);
 	platform_driver_unregister(&tegra_dsi_driver);
 	platform_driver_unregister(&tegra_dc_driver);
-	host1x_driver_unregister(&host1x_drm_driver);
+	interface_unregister_driver(&host1x_interface_driver);
 }
-module_exit(host1x_drm_exit);
+module_exit(tegra_drm_exit);
 
 MODULE_AUTHOR("Thierry Reding <thierry.reding@avionic-design.de>");
 MODULE_DESCRIPTION("NVIDIA Tegra DRM driver");
diff --git a/drivers/gpu/drm/tegra/drm.h b/drivers/gpu/drm/tegra/drm.h
index d100f706d818..ff29611e8a97 100644
--- a/drivers/gpu/drm/tegra/drm.h
+++ b/drivers/gpu/drm/tegra/drm.h
@@ -36,6 +36,7 @@ struct tegra_fbdev {
 
 struct tegra_drm {
 	struct drm_device *drm;
+	struct master *master;
 
 	struct mutex clients_lock;
 	struct list_head clients;
@@ -68,31 +69,25 @@ int tegra_drm_submit(struct tegra_drm_context *context,
 		     struct drm_file *file);
 
 struct tegra_drm_client {
-	struct host1x_client base;
 	struct list_head list;
+	struct device *dev;
+
+	enum host1x_class class;
+	struct host1x_syncpt **syncpts;
+	unsigned int num_syncpts;
 
 	const struct tegra_drm_client_ops *ops;
 };
 
-static inline struct tegra_drm_client *
-host1x_to_drm_client(struct host1x_client *client)
-{
-	return container_of(client, struct tegra_drm_client, base);
-}
-
 int tegra_drm_register_client(struct tegra_drm *tegra,
 			      struct tegra_drm_client *client);
 int tegra_drm_unregister_client(struct tegra_drm *tegra,
 				struct tegra_drm_client *client);
 
-int tegra_drm_init(struct tegra_drm *tegra, struct drm_device *drm);
-int tegra_drm_exit(struct tegra_drm *tegra);
-
 struct tegra_dc_soc_info;
 struct tegra_output;
 
 struct tegra_dc {
-	struct host1x_client client;
 	struct device *dev;
 	spinlock_t lock;
 
@@ -118,12 +113,6 @@ struct tegra_dc {
 	const struct tegra_dc_soc_info *soc;
 };
 
-static inline struct tegra_dc *
-host1x_client_to_dc(struct host1x_client *client)
-{
-	return container_of(client, struct tegra_dc, client);
-}
-
 static inline struct tegra_dc *to_tegra_dc(struct drm_crtc *crtc)
 {
 	return crtc ? container_of(crtc, struct tegra_dc, base) : NULL;
@@ -249,10 +238,6 @@ static inline int tegra_output_check_mode(struct tegra_output *output,
 	return output ? -ENOSYS : -EINVAL;
 }
 
-/* from bus.c */
-int drm_host1x_init(struct drm_driver *driver, struct host1x_device *device);
-void drm_host1x_exit(struct drm_driver *driver, struct host1x_device *device);
-
 /* from rgb.c */
 int tegra_dc_rgb_probe(struct tegra_dc *dc);
 int tegra_dc_rgb_remove(struct tegra_dc *dc);
diff --git a/drivers/gpu/drm/tegra/dsi.c b/drivers/gpu/drm/tegra/dsi.c
index 3838575f71c6..0325e5206b66 100644
--- a/drivers/gpu/drm/tegra/dsi.c
+++ b/drivers/gpu/drm/tegra/dsi.c
@@ -30,7 +30,6 @@
 #define DSI_HOST_FIFO_DEPTH 64
 
 struct tegra_dsi {
-	struct host1x_client client;
 	struct tegra_output output;
 	struct device *dev;
 
@@ -56,12 +55,6 @@ struct tegra_dsi {
 	bool enabled;
 };
 
-static inline struct tegra_dsi *
-host1x_client_to_dsi(struct host1x_client *client)
-{
-	return container_of(client, struct tegra_dsi, client);
-}
-
 static inline struct tegra_dsi *host_to_tegra(struct mipi_dsi_host *host)
 {
 	return container_of(host, struct tegra_dsi, host);
@@ -713,68 +706,6 @@ static int tegra_dsi_pad_calibrate(struct tegra_dsi *dsi)
 	return tegra_mipi_calibrate(dsi->mipi);
 }
 
-static int tegra_dsi_init(struct host1x_client *client)
-{
-	struct tegra_drm *tegra = dev_get_drvdata(client->parent);
-	struct tegra_dsi *dsi = host1x_client_to_dsi(client);
-	int err;
-
-	dsi->output.type = TEGRA_OUTPUT_DSI;
-	dsi->output.dev = client->dev;
-	dsi->output.ops = &dsi_ops;
-
-	err = tegra_output_init(tegra->drm, &dsi->output);
-	if (err < 0) {
-		dev_err(client->dev, "output setup failed: %d\n", err);
-		return err;
-	}
-
-	if (IS_ENABLED(CONFIG_DEBUG_FS)) {
-		err = tegra_dsi_debugfs_init(dsi, tegra->drm->primary);
-		if (err < 0)
-			dev_err(dsi->dev, "debugfs setup failed: %d\n", err);
-	}
-
-	err = tegra_dsi_pad_calibrate(dsi);
-	if (err < 0) {
-		dev_err(dsi->dev, "MIPI calibration failed: %d\n", err);
-		return err;
-	}
-
-	return 0;
-}
-
-static int tegra_dsi_exit(struct host1x_client *client)
-{
-	struct tegra_dsi *dsi = host1x_client_to_dsi(client);
-	int err;
-
-	if (IS_ENABLED(CONFIG_DEBUG_FS)) {
-		err = tegra_dsi_debugfs_exit(dsi);
-		if (err < 0)
-			dev_err(dsi->dev, "debugfs cleanup failed: %d\n", err);
-	}
-
-	err = tegra_output_disable(&dsi->output);
-	if (err < 0) {
-		dev_err(client->dev, "output failed to disable: %d\n", err);
-		return err;
-	}
-
-	err = tegra_output_exit(&dsi->output);
-	if (err < 0) {
-		dev_err(client->dev, "output cleanup failed: %d\n", err);
-		return err;
-	}
-
-	return 0;
-}
-
-static const struct host1x_client_ops dsi_client_ops = {
-	.init = tegra_dsi_init,
-	.exit = tegra_dsi_exit,
-};
-
 static int tegra_dsi_setup_clocks(struct tegra_dsi *dsi)
 {
 	struct clk *parent;
@@ -831,6 +762,62 @@ static const struct mipi_dsi_host_ops tegra_dsi_host_ops = {
 	.detach = tegra_dsi_host_detach,
 };
 
+static int dsi_bind(struct device *dev, struct master *master, void *data)
+{
+	struct tegra_drm *tegra = master_get_drvdata(master);
+	struct tegra_dsi *dsi = dev_get_drvdata(dev);
+	int err;
+
+	dsi->output.type = TEGRA_OUTPUT_DSI;
+	dsi->output.ops = &dsi_ops;
+	dsi->output.dev = dev;
+
+	err = tegra_output_init(tegra->drm, &dsi->output);
+	if (err < 0) {
+		dev_err(dev, "output setup failed: %d\n", err);
+		return err;
+	}
+
+	if (IS_ENABLED(CONFIG_DEBUG_FS)) {
+		err = tegra_dsi_debugfs_init(dsi, tegra->drm->primary);
+		if (err < 0)
+			dev_err(dev, "debugfs setup failed: %d\n", err);
+	}
+
+	err = tegra_dsi_pad_calibrate(dsi);
+	if (err < 0) {
+		dev_err(dev, "MIPI calibration failed: %d\n", err);
+		return err;
+	}
+
+	return 0;
+}
+
+static void dsi_unbind(struct device *dev, struct master *master, void *data)
+{
+	struct tegra_dsi *dsi = dev_get_drvdata(dev);
+	int err;
+
+	if (IS_ENABLED(CONFIG_DEBUG_FS)) {
+		err = tegra_dsi_debugfs_exit(dsi);
+		if (err < 0)
+			dev_err(dev, "debugfs cleanup failed: %d\n", err);
+	}
+
+	err = tegra_output_disable(&dsi->output);
+	if (err < 0)
+		dev_err(dev, "output failed to disable: %d\n", err);
+
+	err = tegra_output_exit(&dsi->output);
+	if (err < 0)
+		dev_err(dev, "output cleanup failed: %d\n", err);
+}
+
+static const struct component_ops dsi_component_ops = {
+	.bind = dsi_bind,
+	.unbind = dsi_unbind,
+};
+
 static int tegra_dsi_probe(struct platform_device *pdev)
 {
 	struct tegra_dsi *dsi;
@@ -842,6 +829,7 @@ static int tegra_dsi_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	dsi->output.dev = dsi->dev = &pdev->dev;
+	platform_set_drvdata(pdev, dsi);
 
 	err = tegra_output_probe(&dsi->output);
 	if (err < 0)
@@ -932,19 +920,12 @@ static int tegra_dsi_probe(struct platform_device *pdev)
 		return err;
 	}
 
-	INIT_LIST_HEAD(&dsi->client.list);
-	dsi->client.ops = &dsi_client_ops;
-	dsi->client.dev = &pdev->dev;
-
-	err = host1x_client_register(&dsi->client);
+	err = component_add(&pdev->dev, &dsi_component_ops);
 	if (err < 0) {
-		dev_err(&pdev->dev, "failed to register host1x client: %d\n",
-			err);
+		dev_err(&pdev->dev, "failed to register component: %d\n", err);
 		return err;
 	}
 
-	platform_set_drvdata(pdev, dsi);
-
 	return 0;
 }
 
@@ -953,12 +934,7 @@ static int tegra_dsi_remove(struct platform_device *pdev)
 	struct tegra_dsi *dsi = platform_get_drvdata(pdev);
 	int err;
 
-	err = host1x_client_unregister(&dsi->client);
-	if (err < 0) {
-		dev_err(&pdev->dev, "failed to unregister host1x client: %d\n",
-			err);
-		return err;
-	}
+	component_del(&pdev->dev, &dsi_component_ops);
 
 	mipi_dsi_host_unregister(&dsi->host);
 	tegra_mipi_free(dsi->mipi);
diff --git a/drivers/gpu/drm/tegra/gr2d.c b/drivers/gpu/drm/tegra/gr2d.c
index 2c7ca748edf5..f4bfdd0079d8 100644
--- a/drivers/gpu/drm/tegra/gr2d.c
+++ b/drivers/gpu/drm/tegra/gr2d.c
@@ -25,46 +25,49 @@ static inline struct gr2d *to_gr2d(struct tegra_drm_client *client)
 	return container_of(client, struct gr2d, client);
 }
 
-static int gr2d_init(struct host1x_client *client)
+static int gr2d_bind(struct device *dev, struct master *master, void *data)
 {
-	struct tegra_drm_client *drm = host1x_to_drm_client(client);
-	struct tegra_drm *tegra = dev_get_drvdata(client->parent);
+	struct tegra_drm *tegra = master_get_drvdata(master);
 	unsigned long flags = HOST1X_SYNCPT_HAS_BASE;
-	struct gr2d *gr2d = to_gr2d(drm);
+	struct gr2d *gr2d = dev_get_drvdata(dev);
+	int err;
 
-	gr2d->channel = host1x_channel_request(client->dev);
+	gr2d->channel = host1x_channel_request(dev);
 	if (!gr2d->channel)
 		return -ENOMEM;
 
-	client->syncpts[0] = host1x_syncpt_request(client->dev, flags);
-	if (!client->syncpts[0]) {
+	gr2d->client.syncpts[0] = host1x_syncpt_request(dev, flags);
+	if (!gr2d->client.syncpts[0]) {
 		host1x_channel_free(gr2d->channel);
 		return -ENOMEM;
 	}
 
-	return tegra_drm_register_client(tegra, drm);
+	err = tegra_drm_register_client(tegra, &gr2d->client);
+	if (err < 0) {
+		dev_err(dev, "failed to register client: %d\n", err);
+		return err;
+	}
+
+	return 0;
 }
 
-static int gr2d_exit(struct host1x_client *client)
+static void gr2d_unbind(struct device *dev, struct master *master, void *data)
 {
-	struct tegra_drm_client *drm = host1x_to_drm_client(client);
-	struct tegra_drm *tegra = dev_get_drvdata(client->parent);
-	struct gr2d *gr2d = to_gr2d(drm);
+	struct tegra_drm *tegra = master_get_drvdata(master);
+	struct gr2d *gr2d = dev_get_drvdata(dev);
 	int err;
 
-	err = tegra_drm_unregister_client(tegra, drm);
+	err = tegra_drm_unregister_client(tegra, &gr2d->client);
 	if (err < 0)
-		return err;
+		dev_err(dev, "failed to unregister client: %d\n", err);
 
-	host1x_syncpt_free(client->syncpts[0]);
+	host1x_syncpt_free(gr2d->client.syncpts[0]);
 	host1x_channel_free(gr2d->channel);
-
-	return 0;
 }
 
-static const struct host1x_client_ops gr2d_client_ops = {
-	.init = gr2d_init,
-	.exit = gr2d_exit,
+static const struct component_ops tegra_gr2d_component_ops = {
+	.bind = gr2d_bind,
+	.unbind = gr2d_unbind,
 };
 
 static int gr2d_open_channel(struct tegra_drm_client *client,
@@ -150,6 +153,8 @@ static int gr2d_probe(struct platform_device *pdev)
 	if (!gr2d)
 		return -ENOMEM;
 
+	platform_set_drvdata(pdev, gr2d);
+
 	syncpts = devm_kzalloc(dev, sizeof(*syncpts), GFP_KERNEL);
 	if (!syncpts)
 		return -ENOMEM;
@@ -166,28 +171,22 @@ static int gr2d_probe(struct platform_device *pdev)
 		return err;
 	}
 
-	INIT_LIST_HEAD(&gr2d->client.base.list);
-	gr2d->client.base.ops = &gr2d_client_ops;
-	gr2d->client.base.dev = dev;
-	gr2d->client.base.class = HOST1X_CLASS_GR2D;
-	gr2d->client.base.syncpts = syncpts;
-	gr2d->client.base.num_syncpts = 1;
-
 	INIT_LIST_HEAD(&gr2d->client.list);
+	gr2d->client.class = HOST1X_CLASS_GR2D;
+	gr2d->client.syncpts = syncpts;
+	gr2d->client.num_syncpts = 1;
 	gr2d->client.ops = &gr2d_ops;
-
-	err = host1x_client_register(&gr2d->client.base);
-	if (err < 0) {
-		dev_err(dev, "failed to register host1x client: %d\n", err);
-		clk_disable_unprepare(gr2d->clk);
-		return err;
-	}
+	gr2d->client.dev = dev;
 
 	/* initialize address register map */
 	for (i = 0; i < ARRAY_SIZE(gr2d_addr_regs); i++)
 		set_bit(gr2d_addr_regs[i], gr2d->addr_regs);
 
-	platform_set_drvdata(pdev, gr2d);
+	err = component_add(&pdev->dev, &tegra_gr2d_component_ops);
+	if (err < 0) {
+		dev_err(&pdev->dev, "failed to register component: %d\n", err);
+		return err;
+	}
 
 	return 0;
 }
@@ -195,15 +194,8 @@ static int gr2d_probe(struct platform_device *pdev)
 static int gr2d_remove(struct platform_device *pdev)
 {
 	struct gr2d *gr2d = platform_get_drvdata(pdev);
-	int err;
-
-	err = host1x_client_unregister(&gr2d->client.base);
-	if (err < 0) {
-		dev_err(&pdev->dev, "failed to unregister host1x client: %d\n",
-			err);
-		return err;
-	}
 
+	component_del(&pdev->dev, &tegra_gr2d_component_ops);
 	clk_disable_unprepare(gr2d->clk);
 
 	return 0;
diff --git a/drivers/gpu/drm/tegra/gr3d.c b/drivers/gpu/drm/tegra/gr3d.c
index 0cbb24b1ae04..c45502ad684e 100644
--- a/drivers/gpu/drm/tegra/gr3d.c
+++ b/drivers/gpu/drm/tegra/gr3d.c
@@ -34,46 +34,49 @@ static inline struct gr3d *to_gr3d(struct tegra_drm_client *client)
 	return container_of(client, struct gr3d, client);
 }
 
-static int gr3d_init(struct host1x_client *client)
+static int gr3d_bind(struct device *dev, struct master *master, void *data)
 {
-	struct tegra_drm_client *drm = host1x_to_drm_client(client);
-	struct tegra_drm *tegra = dev_get_drvdata(client->parent);
+	struct tegra_drm *tegra = master_get_drvdata(master);
 	unsigned long flags = HOST1X_SYNCPT_HAS_BASE;
-	struct gr3d *gr3d = to_gr3d(drm);
+	struct gr3d *gr3d = dev_get_drvdata(dev);
+	int err;
 
-	gr3d->channel = host1x_channel_request(client->dev);
+	gr3d->channel = host1x_channel_request(dev);
 	if (!gr3d->channel)
 		return -ENOMEM;
 
-	client->syncpts[0] = host1x_syncpt_request(client->dev, flags);
-	if (!client->syncpts[0]) {
+	gr3d->client.syncpts[0] = host1x_syncpt_request(dev, flags);
+	if (!gr3d->client.syncpts[0]) {
 		host1x_channel_free(gr3d->channel);
 		return -ENOMEM;
 	}
 
-	return tegra_drm_register_client(tegra, drm);
+	err = tegra_drm_register_client(tegra, &gr3d->client);
+	if (err < 0) {
+		dev_err(dev, "failed to register client: %d\n", err);
+		return err;
+	}
+
+	return 0;
 }
 
-static int gr3d_exit(struct host1x_client *client)
+static void gr3d_unbind(struct device *dev, struct master *master, void *data)
 {
-	struct tegra_drm_client *drm = host1x_to_drm_client(client);
-	struct tegra_drm *tegra = dev_get_drvdata(client->parent);
-	struct gr3d *gr3d = to_gr3d(drm);
+	struct tegra_drm *tegra = master_get_drvdata(master);
+	struct gr3d *gr3d = dev_get_drvdata(dev);
 	int err;
 
-	err = tegra_drm_unregister_client(tegra, drm);
+	err = tegra_drm_unregister_client(tegra, &gr3d->client);
 	if (err < 0)
-		return err;
+		dev_err(dev, "failed to unregister client: %d\n", err);
 
-	host1x_syncpt_free(client->syncpts[0]);
+	host1x_syncpt_free(gr3d->client.syncpts[0]);
 	host1x_channel_free(gr3d->channel);
-
-	return 0;
 }
 
-static const struct host1x_client_ops gr3d_client_ops = {
-	.init = gr3d_init,
-	.exit = gr3d_exit,
+static const struct component_ops tegra_gr3d_component_ops = {
+	.bind = gr3d_bind,
+	.unbind = gr3d_unbind,
 };
 
 static int gr3d_open_channel(struct tegra_drm_client *client,
@@ -248,6 +251,8 @@ static int gr3d_probe(struct platform_device *pdev)
 	if (!gr3d)
 		return -ENOMEM;
 
+	platform_set_drvdata(pdev, gr3d);
+
 	syncpts = devm_kzalloc(&pdev->dev, sizeof(*syncpts), GFP_KERNEL);
 	if (!syncpts)
 		return -ENOMEM;
@@ -297,28 +302,22 @@ static int gr3d_probe(struct platform_device *pdev)
 		}
 	}
 
-	INIT_LIST_HEAD(&gr3d->client.base.list);
-	gr3d->client.base.ops = &gr3d_client_ops;
-	gr3d->client.base.dev = &pdev->dev;
-	gr3d->client.base.class = HOST1X_CLASS_GR3D;
-	gr3d->client.base.syncpts = syncpts;
-	gr3d->client.base.num_syncpts = 1;
-
 	INIT_LIST_HEAD(&gr3d->client.list);
+	gr3d->client.class = HOST1X_CLASS_GR3D;
+	gr3d->client.syncpts = syncpts;
+	gr3d->client.num_syncpts = 1;
 	gr3d->client.ops = &gr3d_ops;
-
-	err = host1x_client_register(&gr3d->client.base);
-	if (err < 0) {
-		dev_err(&pdev->dev, "failed to register host1x client: %d\n",
-			err);
-		return err;
-	}
+	gr3d->client.dev = &pdev->dev;
 
 	/* initialize address register map */
 	for (i = 0; i < ARRAY_SIZE(gr3d_addr_regs); i++)
 		set_bit(gr3d_addr_regs[i], gr3d->addr_regs);
 
-	platform_set_drvdata(pdev, gr3d);
+	err = component_add(&pdev->dev, &tegra_gr3d_component_ops);
+	if (err < 0) {
+		dev_err(&pdev->dev, "failed to register component: %d\n", err);
+		return err;
+	}
 
 	return 0;
 }
@@ -326,14 +325,8 @@ static int gr3d_probe(struct platform_device *pdev)
 static int gr3d_remove(struct platform_device *pdev)
 {
 	struct gr3d *gr3d = platform_get_drvdata(pdev);
-	int err;
 
-	err = host1x_client_unregister(&gr3d->client.base);
-	if (err < 0) {
-		dev_err(&pdev->dev, "failed to unregister host1x client: %d\n",
-			err);
-		return err;
-	}
+	component_del(&pdev->dev, &tegra_gr3d_component_ops);
 
 	if (gr3d->clk_secondary) {
 		tegra_powergate_power_off(TEGRA_POWERGATE_3D1);
diff --git a/drivers/gpu/drm/tegra/hdmi.c b/drivers/gpu/drm/tegra/hdmi.c
index fec1a63d32c9..c27149718753 100644
--- a/drivers/gpu/drm/tegra/hdmi.c
+++ b/drivers/gpu/drm/tegra/hdmi.c
@@ -37,7 +37,6 @@ struct tegra_hdmi_config {
 };
 
 struct tegra_hdmi {
-	struct host1x_client client;
 	struct tegra_output output;
 	struct device *dev;
 	bool enabled;
@@ -65,12 +64,6 @@ struct tegra_hdmi {
 	struct dentry *debugfs;
 };
 
-static inline struct tegra_hdmi *
-host1x_client_to_hdmi(struct host1x_client *client)
-{
-	return container_of(client, struct tegra_hdmi, client);
-}
-
 static inline struct tegra_hdmi *to_hdmi(struct tegra_output *output)
 {
 	return container_of(output, struct tegra_hdmi, output);
@@ -1345,41 +1338,40 @@ static int tegra_hdmi_debugfs_exit(struct tegra_hdmi *hdmi)
 	return 0;
 }
 
-static int tegra_hdmi_init(struct host1x_client *client)
+static int hdmi_bind(struct device *dev, struct master *master, void *data)
 {
-	struct tegra_drm *tegra = dev_get_drvdata(client->parent);
-	struct tegra_hdmi *hdmi = host1x_client_to_hdmi(client);
+	struct tegra_drm *tegra = master_get_drvdata(master);
+	struct tegra_hdmi *hdmi = dev_get_drvdata(dev);
 	int err;
 
 	hdmi->output.type = TEGRA_OUTPUT_HDMI;
-	hdmi->output.dev = client->dev;
 	hdmi->output.ops = &hdmi_ops;
+	hdmi->output.dev = dev;
 
 	err = tegra_output_init(tegra->drm, &hdmi->output);
 	if (err < 0) {
-		dev_err(client->dev, "output setup failed: %d\n", err);
+		dev_err(dev, "output setup failed: %d\n", err);
 		return err;
 	}
 
 	if (IS_ENABLED(CONFIG_DEBUG_FS)) {
 		err = tegra_hdmi_debugfs_init(hdmi, tegra->drm->primary);
 		if (err < 0)
-			dev_err(client->dev, "debugfs setup failed: %d\n", err);
+			dev_err(dev, "debugfs setup failed: %d\n", err);
 	}
 
 	err = regulator_enable(hdmi->hdmi);
 	if (err < 0) {
-		dev_err(client->dev, "failed to enable HDMI regulator: %d\n",
-			err);
+		dev_err(dev, "failed to enable HDMI regulator: %d\n", err);
 		return err;
 	}
 
 	return 0;
 }
 
-static int tegra_hdmi_exit(struct host1x_client *client)
+static void hdmi_unbind(struct device *dev, struct master *master, void *data)
 {
-	struct tegra_hdmi *hdmi = host1x_client_to_hdmi(client);
+	struct tegra_hdmi *hdmi = dev_get_drvdata(dev);
 	int err;
 
 	regulator_disable(hdmi->hdmi);
@@ -1387,28 +1379,21 @@ static int tegra_hdmi_exit(struct host1x_client *client)
 	if (IS_ENABLED(CONFIG_DEBUG_FS)) {
 		err = tegra_hdmi_debugfs_exit(hdmi);
 		if (err < 0)
-			dev_err(client->dev, "debugfs cleanup failed: %d\n",
-				err);
+			dev_err(dev, "debugfs cleanup failed: %d\n", err);
 	}
 
 	err = tegra_output_disable(&hdmi->output);
-	if (err < 0) {
-		dev_err(client->dev, "output failed to disable: %d\n", err);
-		return err;
-	}
+	if (err < 0)
+		dev_err(dev, "output failed to disable: %d\n", err);
 
 	err = tegra_output_exit(&hdmi->output);
-	if (err < 0) {
-		dev_err(client->dev, "output cleanup failed: %d\n", err);
-		return err;
-	}
-
-	return 0;
+	if (err < 0)
+		dev_err(dev, "output cleanup failed: %d\n", err);
 }
 
-static const struct host1x_client_ops hdmi_client_ops = {
-	.init = tegra_hdmi_init,
-	.exit = tegra_hdmi_exit,
+static const struct component_ops hdmi_component_ops = {
+	.bind = hdmi_bind,
+	.unbind = hdmi_unbind,
 };
 
 static const struct tegra_hdmi_config tegra20_hdmi_config = {
@@ -1466,6 +1451,8 @@ static int tegra_hdmi_probe(struct platform_device *pdev)
 	if (!hdmi)
 		return -ENOMEM;
 
+	platform_set_drvdata(pdev, hdmi);
+
 	hdmi->config = match->data;
 	hdmi->dev = &pdev->dev;
 	hdmi->audio_source = AUTO;
@@ -1530,19 +1517,12 @@ static int tegra_hdmi_probe(struct platform_device *pdev)
 
 	hdmi->irq = err;
 
-	INIT_LIST_HEAD(&hdmi->client.list);
-	hdmi->client.ops = &hdmi_client_ops;
-	hdmi->client.dev = &pdev->dev;
-
-	err = host1x_client_register(&hdmi->client);
+	err = component_add(&pdev->dev, &hdmi_component_ops);
 	if (err < 0) {
-		dev_err(&pdev->dev, "failed to register host1x client: %d\n",
-			err);
+		dev_err(&pdev->dev, "failed to register component: %d\n", err);
 		return err;
 	}
 
-	platform_set_drvdata(pdev, hdmi);
-
 	return 0;
 }
 
@@ -1551,12 +1531,7 @@ static int tegra_hdmi_remove(struct platform_device *pdev)
 	struct tegra_hdmi *hdmi = platform_get_drvdata(pdev);
 	int err;
 
-	err = host1x_client_unregister(&hdmi->client);
-	if (err < 0) {
-		dev_err(&pdev->dev, "failed to unregister host1x client: %d\n",
-			err);
-		return err;
-	}
+	component_del(&pdev->dev, &hdmi_component_ops);
 
 	err = tegra_output_remove(&hdmi->output);
 	if (err < 0) {
diff --git a/drivers/gpu/drm/tegra/sor.c b/drivers/gpu/drm/tegra/sor.c
index 7d66f6e53919..60535e380d18 100644
--- a/drivers/gpu/drm/tegra/sor.c
+++ b/drivers/gpu/drm/tegra/sor.c
@@ -20,7 +20,6 @@
 #include "sor.h"
 
 struct tegra_sor {
-	struct host1x_client client;
 	struct tegra_output output;
 	struct device *dev;
 
@@ -40,12 +39,6 @@ struct tegra_sor {
 	struct dentry *debugfs;
 };
 
-static inline struct tegra_sor *
-host1x_client_to_sor(struct host1x_client *client)
-{
-	return container_of(client, struct tegra_sor, client);
-}
-
 static inline struct tegra_sor *to_sor(struct tegra_output *output)
 {
 	return container_of(output, struct tegra_sor, output);
@@ -1042,10 +1035,10 @@ static int tegra_sor_debugfs_exit(struct tegra_sor *sor)
 	return 0;
 }
 
-static int tegra_sor_init(struct host1x_client *client)
+static int sor_bind(struct device *dev, struct master *master, void *data)
 {
-	struct tegra_drm *tegra = dev_get_drvdata(client->parent);
-	struct tegra_sor *sor = host1x_client_to_sor(client);
+	struct tegra_drm *tegra = master_get_drvdata(master);
+	struct tegra_sor *sor = dev_get_drvdata(dev);
 	int err;
 
 	if (!sor->dpaux)
@@ -1058,7 +1051,7 @@ static int tegra_sor_init(struct host1x_client *client)
 
 	err = tegra_output_init(tegra->drm, &sor->output);
 	if (err < 0) {
-		dev_err(sor->dev, "output setup failed: %d\n", err);
+		dev_err(dev, "output setup failed: %d\n", err);
 		return err;
 	}
 
@@ -1067,13 +1060,13 @@ static int tegra_sor_init(struct host1x_client *client)
 
 		err = tegra_sor_debugfs_init(sor, root);
 		if (err < 0)
-			dev_err(sor->dev, "debugfs setup failed: %d\n", err);
+			dev_err(dev, "debugfs setup failed: %d\n", err);
 	}
 
 	if (sor->dpaux) {
 		err = tegra_dpaux_attach(sor->dpaux, &sor->output);
 		if (err < 0) {
-			dev_err(sor->dev, "failed to attach DP: %d\n", err);
+			dev_err(dev, "failed to attach DP: %d\n", err);
 			return err;
 		}
 	}
@@ -1081,43 +1074,35 @@ static int tegra_sor_init(struct host1x_client *client)
 	return 0;
 }
 
-static int tegra_sor_exit(struct host1x_client *client)
+static void sor_unbind(struct device *dev, struct master *master, void *data)
 {
-	struct tegra_sor *sor = host1x_client_to_sor(client);
+	struct tegra_sor *sor = dev_get_drvdata(dev);
 	int err;
 
 	err = tegra_output_disable(&sor->output);
-	if (err < 0) {
-		dev_err(sor->dev, "output failed to disable: %d\n", err);
-		return err;
-	}
+	if (err < 0)
+		dev_err(dev, "output failed to disable: %d\n", err);
 
 	if (sor->dpaux) {
 		err = tegra_dpaux_detach(sor->dpaux);
-		if (err < 0) {
-			dev_err(sor->dev, "failed to detach DP: %d\n", err);
-			return err;
-		}
+		if (err < 0)
+			dev_err(dev, "failed to detach DP: %d\n", err);
 	}
 
 	if (IS_ENABLED(CONFIG_DEBUG_FS)) {
 		err = tegra_sor_debugfs_exit(sor);
 		if (err < 0)
-			dev_err(sor->dev, "debugfs cleanup failed: %d\n", err);
+			dev_err(dev, "debugfs cleanup failed: %d\n", err);
 	}
 
 	err = tegra_output_exit(&sor->output);
-	if (err < 0) {
-		dev_err(sor->dev, "output cleanup failed: %d\n", err);
-		return err;
-	}
-
-	return 0;
+	if (err < 0)
+		dev_err(dev, "output cleanup failed: %d\n", err);
 }
 
-static const struct host1x_client_ops sor_client_ops = {
-	.init = tegra_sor_init,
-	.exit = tegra_sor_exit,
+static const struct component_ops tegra_sor_component_ops = {
+	.bind = sor_bind,
+	.unbind = sor_unbind,
 };
 
 static int tegra_sor_probe(struct platform_device *pdev)
@@ -1132,6 +1117,7 @@ static int tegra_sor_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	sor->output.dev = sor->dev = &pdev->dev;
+	platform_set_drvdata(pdev, sor);
 
 	np = of_parse_phandle(pdev->dev.of_node, "nvidia,dpaux", 0);
 	if (np) {
@@ -1183,35 +1169,22 @@ static int tegra_sor_probe(struct platform_device *pdev)
 	if (err < 0)
 		return err;
 
-	INIT_LIST_HEAD(&sor->client.list);
-	sor->client.ops = &sor_client_ops;
-	sor->client.dev = &pdev->dev;
-
 	mutex_init(&sor->lock);
 
-	err = host1x_client_register(&sor->client);
+	err = component_add(&pdev->dev, &tegra_sor_component_ops);
 	if (err < 0) {
-		dev_err(&pdev->dev, "failed to register host1x client: %d\n",
-			err);
+		dev_err(&pdev->dev, "failed to register component: %d\n", err);
 		return err;
 	}
 
-	platform_set_drvdata(pdev, sor);
-
 	return 0;
 }
 
 static int tegra_sor_remove(struct platform_device *pdev)
 {
 	struct tegra_sor *sor = platform_get_drvdata(pdev);
-	int err;
 
-	err = host1x_client_unregister(&sor->client);
-	if (err < 0) {
-		dev_err(&pdev->dev, "failed to unregister host1x client: %d\n",
-			err);
-		return err;
-	}
+	component_del(&pdev->dev, &tegra_sor_component_ops);
 
 	clk_disable_unprepare(sor->clk_parent);
 	clk_disable_unprepare(sor->clk_safe);
diff --git a/drivers/gpu/host1x/Makefile b/drivers/gpu/host1x/Makefile
index c1189f004441..2ff37ab71fd2 100644
--- a/drivers/gpu/host1x/Makefile
+++ b/drivers/gpu/host1x/Makefile
@@ -1,5 +1,4 @@
 host1x-y = \
-	bus.o \
 	syncpt.o \
 	dev.o \
 	intr.o \
diff --git a/drivers/gpu/host1x/bus.c b/drivers/gpu/host1x/bus.c
deleted file mode 100644
index ccdd2e6da5e3..000000000000
--- a/drivers/gpu/host1x/bus.c
+++ /dev/null
@@ -1,553 +0,0 @@
-/*
- * Copyright (C) 2012 Avionic Design GmbH
- * Copyright (C) 2012-2013, NVIDIA Corporation
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program.  If not, see <http://www.gnu.org/licenses/>.
- */
-
-#include <linux/host1x.h>
-#include <linux/of.h>
-#include <linux/slab.h>
-
-#include "bus.h"
-#include "dev.h"
-
-static DEFINE_MUTEX(clients_lock);
-static LIST_HEAD(clients);
-
-static DEFINE_MUTEX(drivers_lock);
-static LIST_HEAD(drivers);
-
-static DEFINE_MUTEX(devices_lock);
-static LIST_HEAD(devices);
-
-struct host1x_subdev {
-	struct host1x_client *client;
-	struct device_node *np;
-	struct list_head list;
-};
-
-/**
- * host1x_subdev_add() - add a new subdevice with an associated device node
- */
-static int host1x_subdev_add(struct host1x_device *device,
-			     struct device_node *np)
-{
-	struct host1x_subdev *subdev;
-
-	subdev = kzalloc(sizeof(*subdev), GFP_KERNEL);
-	if (!subdev)
-		return -ENOMEM;
-
-	INIT_LIST_HEAD(&subdev->list);
-	subdev->np = of_node_get(np);
-
-	mutex_lock(&device->subdevs_lock);
-	list_add_tail(&subdev->list, &device->subdevs);
-	mutex_unlock(&device->subdevs_lock);
-
-	return 0;
-}
-
-/**
- * host1x_subdev_del() - remove subdevice
- */
-static void host1x_subdev_del(struct host1x_subdev *subdev)
-{
-	list_del(&subdev->list);
-	of_node_put(subdev->np);
-	kfree(subdev);
-}
-
-/**
- * host1x_device_parse_dt() - scan device tree and add matching subdevices
- */
-static int host1x_device_parse_dt(struct host1x_device *device)
-{
-	struct device_node *np;
-	int err;
-
-	for_each_child_of_node(device->dev.parent->of_node, np) {
-		if (of_match_node(device->driver->subdevs, np) &&
-		    of_device_is_available(np)) {
-			err = host1x_subdev_add(device, np);
-			if (err < 0)
-				return err;
-		}
-	}
-
-	return 0;
-}
-
-static void host1x_subdev_register(struct host1x_device *device,
-				   struct host1x_subdev *subdev,
-				   struct host1x_client *client)
-{
-	int err;
-
-	/*
-	 * Move the subdevice to the list of active (registered) subdevices
-	 * and associate it with a client. At the same time, associate the
-	 * client with its parent device.
-	 */
-	mutex_lock(&device->subdevs_lock);
-	mutex_lock(&device->clients_lock);
-	list_move_tail(&client->list, &device->clients);
-	list_move_tail(&subdev->list, &device->active);
-	client->parent = &device->dev;
-	subdev->client = client;
-	mutex_unlock(&device->clients_lock);
-	mutex_unlock(&device->subdevs_lock);
-
-	/*
-	 * When all subdevices have been registered, the composite device is
-	 * ready to be probed.
-	 */
-	if (list_empty(&device->subdevs)) {
-		err = device->driver->probe(device);
-		if (err < 0)
-			dev_err(&device->dev, "probe failed: %d\n", err);
-	}
-}
-
-static void __host1x_subdev_unregister(struct host1x_device *device,
-				       struct host1x_subdev *subdev)
-{
-	struct host1x_client *client = subdev->client;
-	int err;
-
-	/*
-	 * If all subdevices have been activated, we're about to remove the
-	 * first active subdevice, so unload the driver first.
-	 */
-	if (list_empty(&device->subdevs)) {
-		err = device->driver->remove(device);
-		if (err < 0)
-			dev_err(&device->dev, "remove failed: %d\n", err);
-	}
-
-	/*
-	 * Move the subdevice back to the list of idle subdevices and remove
-	 * it from list of clients.
-	 */
-	mutex_lock(&device->clients_lock);
-	subdev->client = NULL;
-	client->parent = NULL;
-	list_move_tail(&subdev->list, &device->subdevs);
-	/*
-	 * XXX: Perhaps don't do this here, but rather explicitly remove it
-	 * when the device is about to be deleted.
-	 *
-	 * This is somewhat complicated by the fact that this function is
-	 * used to remove the subdevice when a client is unregistered but
-	 * also when the composite device is about to be removed.
-	 */
-	list_del_init(&client->list);
-	mutex_unlock(&device->clients_lock);
-}
-
-static void host1x_subdev_unregister(struct host1x_device *device,
-				     struct host1x_subdev *subdev)
-{
-	mutex_lock(&device->subdevs_lock);
-	__host1x_subdev_unregister(device, subdev);
-	mutex_unlock(&device->subdevs_lock);
-}
-
-int host1x_device_init(struct host1x_device *device)
-{
-	struct host1x_client *client;
-	int err;
-
-	mutex_lock(&device->clients_lock);
-
-	list_for_each_entry(client, &device->clients, list) {
-		if (client->ops && client->ops->init) {
-			err = client->ops->init(client);
-			if (err < 0) {
-				dev_err(&device->dev,
-					"failed to initialize %s: %d\n",
-					dev_name(client->dev), err);
-				mutex_unlock(&device->clients_lock);
-				return err;
-			}
-		}
-	}
-
-	mutex_unlock(&device->clients_lock);
-
-	return 0;
-}
-EXPORT_SYMBOL(host1x_device_init);
-
-int host1x_device_exit(struct host1x_device *device)
-{
-	struct host1x_client *client;
-	int err;
-
-	mutex_lock(&device->clients_lock);
-
-	list_for_each_entry_reverse(client, &device->clients, list) {
-		if (client->ops && client->ops->exit) {
-			err = client->ops->exit(client);
-			if (err < 0) {
-				dev_err(&device->dev,
-					"failed to cleanup %s: %d\n",
-					dev_name(client->dev), err);
-				mutex_unlock(&device->clients_lock);
-				return err;
-			}
-		}
-	}
-
-	mutex_unlock(&device->clients_lock);
-
-	return 0;
-}
-EXPORT_SYMBOL(host1x_device_exit);
-
-static int host1x_register_client(struct host1x *host1x,
-				  struct host1x_client *client)
-{
-	struct host1x_device *device;
-	struct host1x_subdev *subdev;
-
-	mutex_lock(&host1x->devices_lock);
-
-	list_for_each_entry(device, &host1x->devices, list) {
-		list_for_each_entry(subdev, &device->subdevs, list) {
-			if (subdev->np == client->dev->of_node) {
-				host1x_subdev_register(device, subdev, client);
-				mutex_unlock(&host1x->devices_lock);
-				return 0;
-			}
-		}
-	}
-
-	mutex_unlock(&host1x->devices_lock);
-	return -ENODEV;
-}
-
-static int host1x_unregister_client(struct host1x *host1x,
-				    struct host1x_client *client)
-{
-	struct host1x_device *device, *dt;
-	struct host1x_subdev *subdev;
-
-	mutex_lock(&host1x->devices_lock);
-
-	list_for_each_entry_safe(device, dt, &host1x->devices, list) {
-		list_for_each_entry(subdev, &device->active, list) {
-			if (subdev->client == client) {
-				host1x_subdev_unregister(device, subdev);
-				mutex_unlock(&host1x->devices_lock);
-				return 0;
-			}
-		}
-	}
-
-	mutex_unlock(&host1x->devices_lock);
-	return -ENODEV;
-}
-
-static struct bus_type host1x_bus_type = {
-	.name = "host1x",
-};
-
-int host1x_bus_init(void)
-{
-	return bus_register(&host1x_bus_type);
-}
-
-void host1x_bus_exit(void)
-{
-	bus_unregister(&host1x_bus_type);
-}
-
-static void host1x_device_release(struct device *dev)
-{
-	struct host1x_device *device = to_host1x_device(dev);
-
-	kfree(device);
-}
-
-static int host1x_device_add(struct host1x *host1x,
-			     struct host1x_driver *driver)
-{
-	struct host1x_client *client, *tmp;
-	struct host1x_subdev *subdev;
-	struct host1x_device *device;
-	int err;
-
-	device = kzalloc(sizeof(*device), GFP_KERNEL);
-	if (!device)
-		return -ENOMEM;
-
-	mutex_init(&device->subdevs_lock);
-	INIT_LIST_HEAD(&device->subdevs);
-	INIT_LIST_HEAD(&device->active);
-	mutex_init(&device->clients_lock);
-	INIT_LIST_HEAD(&device->clients);
-	INIT_LIST_HEAD(&device->list);
-	device->driver = driver;
-
-	device->dev.coherent_dma_mask = host1x->dev->coherent_dma_mask;
-	device->dev.dma_mask = &device->dev.coherent_dma_mask;
-	device->dev.release = host1x_device_release;
-	dev_set_name(&device->dev, "%s", driver->name);
-	device->dev.bus = &host1x_bus_type;
-	device->dev.parent = host1x->dev;
-
-	err = device_register(&device->dev);
-	if (err < 0)
-		return err;
-
-	err = host1x_device_parse_dt(device);
-	if (err < 0) {
-		device_unregister(&device->dev);
-		return err;
-	}
-
-	mutex_lock(&host1x->devices_lock);
-	list_add_tail(&device->list, &host1x->devices);
-	mutex_unlock(&host1x->devices_lock);
-
-	mutex_lock(&clients_lock);
-
-	list_for_each_entry_safe(client, tmp, &clients, list) {
-		list_for_each_entry(subdev, &device->subdevs, list) {
-			if (subdev->np == client->dev->of_node) {
-				host1x_subdev_register(device, subdev, client);
-				break;
-			}
-		}
-	}
-
-	mutex_unlock(&clients_lock);
-
-	return 0;
-}
-
-/*
- * Removes a device by first unregistering any subdevices and then removing
- * itself from the list of devices.
- *
- * This function must be called with the host1x->devices_lock held.
- */
-static void host1x_device_del(struct host1x *host1x,
-			      struct host1x_device *device)
-{
-	struct host1x_subdev *subdev, *sd;
-	struct host1x_client *client, *cl;
-
-	mutex_lock(&device->subdevs_lock);
-
-	/* unregister subdevices */
-	list_for_each_entry_safe(subdev, sd, &device->active, list) {
-		/*
-		 * host1x_subdev_unregister() will remove the client from
-		 * any lists, so we'll need to manually add it back to the
-		 * list of idle clients.
-		 *
-		 * XXX: Alternatively, perhaps don't remove the client from
-		 * any lists in host1x_subdev_unregister() and instead do
-		 * that explicitly from host1x_unregister_client()?
-		 */
-		client = subdev->client;
-
-		__host1x_subdev_unregister(device, subdev);
-
-		/* add the client to the list of idle clients */
-		mutex_lock(&clients_lock);
-		list_add_tail(&client->list, &clients);
-		mutex_unlock(&clients_lock);
-	}
-
-	/* remove subdevices */
-	list_for_each_entry_safe(subdev, sd, &device->subdevs, list)
-		host1x_subdev_del(subdev);
-
-	mutex_unlock(&device->subdevs_lock);
-
-	/* move clients to idle list */
-	mutex_lock(&clients_lock);
-	mutex_lock(&device->clients_lock);
-
-	list_for_each_entry_safe(client, cl, &device->clients, list)
-		list_move_tail(&client->list, &clients);
-
-	mutex_unlock(&device->clients_lock);
-	mutex_unlock(&clients_lock);
-
-	/* finally remove the device */
-	list_del_init(&device->list);
-	device_unregister(&device->dev);
-}
-
-static void host1x_attach_driver(struct host1x *host1x,
-				 struct host1x_driver *driver)
-{
-	struct host1x_device *device;
-	int err;
-
-	mutex_lock(&host1x->devices_lock);
-
-	list_for_each_entry(device, &host1x->devices, list) {
-		if (device->driver == driver) {
-			mutex_unlock(&host1x->devices_lock);
-			return;
-		}
-	}
-
-	mutex_unlock(&host1x->devices_lock);
-
-	err = host1x_device_add(host1x, driver);
-	if (err < 0)
-		dev_err(host1x->dev, "failed to allocate device: %d\n", err);
-}
-
-static void host1x_detach_driver(struct host1x *host1x,
-				 struct host1x_driver *driver)
-{
-	struct host1x_device *device, *tmp;
-
-	mutex_lock(&host1x->devices_lock);
-
-	list_for_each_entry_safe(device, tmp, &host1x->devices, list)
-		if (device->driver == driver)
-			host1x_device_del(host1x, device);
-
-	mutex_unlock(&host1x->devices_lock);
-}
-
-int host1x_register(struct host1x *host1x)
-{
-	struct host1x_driver *driver;
-
-	mutex_lock(&devices_lock);
-	list_add_tail(&host1x->list, &devices);
-	mutex_unlock(&devices_lock);
-
-	mutex_lock(&drivers_lock);
-
-	list_for_each_entry(driver, &drivers, list)
-		host1x_attach_driver(host1x, driver);
-
-	mutex_unlock(&drivers_lock);
-
-	return 0;
-}
-
-int host1x_unregister(struct host1x *host1x)
-{
-	struct host1x_driver *driver;
-
-	mutex_lock(&drivers_lock);
-
-	list_for_each_entry(driver, &drivers, list)
-		host1x_detach_driver(host1x, driver);
-
-	mutex_unlock(&drivers_lock);
-
-	mutex_lock(&devices_lock);
-	list_del_init(&host1x->list);
-	mutex_unlock(&devices_lock);
-
-	return 0;
-}
-
-int host1x_driver_register(struct host1x_driver *driver)
-{
-	struct host1x *host1x;
-
-	INIT_LIST_HEAD(&driver->list);
-
-	mutex_lock(&drivers_lock);
-	list_add_tail(&driver->list, &drivers);
-	mutex_unlock(&drivers_lock);
-
-	mutex_lock(&devices_lock);
-
-	list_for_each_entry(host1x, &devices, list)
-		host1x_attach_driver(host1x, driver);
-
-	mutex_unlock(&devices_lock);
-
-	return 0;
-}
-EXPORT_SYMBOL(host1x_driver_register);
-
-void host1x_driver_unregister(struct host1x_driver *driver)
-{
-	mutex_lock(&drivers_lock);
-	list_del_init(&driver->list);
-	mutex_unlock(&drivers_lock);
-}
-EXPORT_SYMBOL(host1x_driver_unregister);
-
-int host1x_client_register(struct host1x_client *client)
-{
-	struct host1x *host1x;
-	int err;
-
-	mutex_lock(&devices_lock);
-
-	list_for_each_entry(host1x, &devices, list) {
-		err = host1x_register_client(host1x, client);
-		if (!err) {
-			mutex_unlock(&devices_lock);
-			return 0;
-		}
-	}
-
-	mutex_unlock(&devices_lock);
-
-	mutex_lock(&clients_lock);
-	list_add_tail(&client->list, &clients);
-	mutex_unlock(&clients_lock);
-
-	return 0;
-}
-EXPORT_SYMBOL(host1x_client_register);
-
-int host1x_client_unregister(struct host1x_client *client)
-{
-	struct host1x_client *c;
-	struct host1x *host1x;
-	int err;
-
-	mutex_lock(&devices_lock);
-
-	list_for_each_entry(host1x, &devices, list) {
-		err = host1x_unregister_client(host1x, client);
-		if (!err) {
-			mutex_unlock(&devices_lock);
-			return 0;
-		}
-	}
-
-	mutex_unlock(&devices_lock);
-	mutex_lock(&clients_lock);
-
-	list_for_each_entry(c, &clients, list) {
-		if (c == client) {
-			list_del_init(&c->list);
-			break;
-		}
-	}
-
-	mutex_unlock(&clients_lock);
-
-	return 0;
-}
-EXPORT_SYMBOL(host1x_client_unregister);
diff --git a/drivers/gpu/host1x/bus.h b/drivers/gpu/host1x/bus.h
deleted file mode 100644
index 4099e99212c8..000000000000
--- a/drivers/gpu/host1x/bus.h
+++ /dev/null
@@ -1,29 +0,0 @@
-/*
- * Copyright (C) 2012 Avionic Design GmbH
- * Copyright (C) 2012-2013, NVIDIA Corporation
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program.  If not, see <http://www.gnu.org/licenses/>.
- */
-
-#ifndef HOST1X_BUS_H
-#define HOST1X_BUS_H
-
-struct host1x;
-
-int host1x_bus_init(void);
-void host1x_bus_exit(void);
-
-int host1x_register(struct host1x *host1x);
-int host1x_unregister(struct host1x *host1x);
-
-#endif
diff --git a/drivers/gpu/host1x/dev.c b/drivers/gpu/host1x/dev.c
index 2529908d304b..b92812ba6f18 100644
--- a/drivers/gpu/host1x/dev.c
+++ b/drivers/gpu/host1x/dev.c
@@ -27,7 +27,6 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/host1x.h>
 
-#include "bus.h"
 #include "dev.h"
 #include "intr.h"
 #include "channel.h"
@@ -124,8 +123,8 @@ static int host1x_probe(struct platform_device *pdev)
 	if (!host)
 		return -ENOMEM;
 
-	mutex_init(&host->devices_lock);
-	INIT_LIST_HEAD(&host->devices);
+	mutex_init(&host->masters_lock);
+	INIT_LIST_HEAD(&host->masters);
 	INIT_LIST_HEAD(&host->list);
 	host->dev = &pdev->dev;
 	host->info = id->data;
@@ -176,7 +175,10 @@ static int host1x_probe(struct platform_device *pdev)
 
 	host1x_debug_init(host);
 
-	err = host1x_register(host);
+	host->interface.name = "nvidia,tegra-host1x";
+	host->interface.dev = &pdev->dev;
+
+	err = interface_add(&host->interface);
 	if (err < 0)
 		goto fail_deinit_intr;
 
@@ -195,7 +197,7 @@ static int host1x_remove(struct platform_device *pdev)
 {
 	struct host1x *host = platform_get_drvdata(pdev);
 
-	host1x_unregister(host);
+	interface_remove(&host->interface);
 	host1x_intr_deinit(host);
 	host1x_syncpt_deinit(host);
 	clk_disable_unprepare(host->clk);
@@ -216,13 +218,9 @@ static int __init tegra_host1x_init(void)
 {
 	int err;
 
-	err = host1x_bus_init();
-	if (err < 0)
-		return err;
-
 	err = platform_driver_register(&tegra_host1x_driver);
 	if (err < 0)
-		goto unregister_bus;
+		return err;
 
 	err = platform_driver_register(&tegra_mipi_driver);
 	if (err < 0)
@@ -232,8 +230,6 @@ static int __init tegra_host1x_init(void)
 
 unregister_host1x:
 	platform_driver_unregister(&tegra_host1x_driver);
-unregister_bus:
-	host1x_bus_exit();
 	return err;
 }
 module_init(tegra_host1x_init);
@@ -242,7 +238,6 @@ static void __exit tegra_host1x_exit(void)
 {
 	platform_driver_unregister(&tegra_mipi_driver);
 	platform_driver_unregister(&tegra_host1x_driver);
-	host1x_bus_exit();
 }
 module_exit(tegra_host1x_exit);
 
diff --git a/drivers/gpu/host1x/dev.h b/drivers/gpu/host1x/dev.h
index 0b6e8e9629c5..90e4716ee220 100644
--- a/drivers/gpu/host1x/dev.h
+++ b/drivers/gpu/host1x/dev.h
@@ -17,6 +17,7 @@
 #ifndef HOST1X_DEV_H
 #define HOST1X_DEV_H
 
+#include <linux/interface.h>
 #include <linux/platform_device.h>
 #include <linux/device.h>
 
@@ -127,9 +128,9 @@ struct host1x {
 
 	struct dentry *debugfs;
 
-	struct mutex devices_lock;
-	struct list_head devices;
-
+	struct interface interface;
+	struct mutex masters_lock;
+	struct list_head masters;
 	struct list_head list;
 };
 
diff --git a/include/linux/host1x.h b/include/linux/host1x.h
index b432b3ddbc13..14b6161328df 100644
--- a/include/linux/host1x.h
+++ b/include/linux/host1x.h
@@ -19,6 +19,7 @@
 #ifndef __LINUX_HOST1X_H
 #define __LINUX_HOST1X_H
 
+#include <linux/component.h>
 #include <linux/device.h>
 #include <linux/types.h>
 
@@ -30,27 +31,6 @@ enum host1x_class {
 	HOST1X_CLASS_GPU = 0x61,
 };
 
-struct host1x_client;
-
-struct host1x_client_ops {
-	int (*init)(struct host1x_client *client);
-	int (*exit)(struct host1x_client *client);
-};
-
-struct host1x_client {
-	struct list_head list;
-	struct device *parent;
-	struct device *dev;
-
-	const struct host1x_client_ops *ops;
-
-	enum host1x_class class;
-	struct host1x_channel *channel;
-
-	struct host1x_syncpt **syncpts;
-	unsigned int num_syncpts;
-};
-
 /*
  * host1x buffer objects
  */
@@ -241,48 +221,6 @@ void host1x_job_put(struct host1x_job *job);
 int host1x_job_pin(struct host1x_job *job, struct device *dev);
 void host1x_job_unpin(struct host1x_job *job);
 
-/*
- * subdevice probe infrastructure
- */
-
-struct host1x_device;
-
-struct host1x_driver {
-	const struct of_device_id *subdevs;
-	struct list_head list;
-	const char *name;
-
-	int (*probe)(struct host1x_device *device);
-	int (*remove)(struct host1x_device *device);
-};
-
-int host1x_driver_register(struct host1x_driver *driver);
-void host1x_driver_unregister(struct host1x_driver *driver);
-
-struct host1x_device {
-	struct host1x_driver *driver;
-	struct list_head list;
-	struct device dev;
-
-	struct mutex subdevs_lock;
-	struct list_head subdevs;
-	struct list_head active;
-
-	struct mutex clients_lock;
-	struct list_head clients;
-};
-
-static inline struct host1x_device *to_host1x_device(struct device *dev)
-{
-	return container_of(dev, struct host1x_device, dev);
-}
-
-int host1x_device_init(struct host1x_device *device);
-int host1x_device_exit(struct host1x_device *device);
-
-int host1x_client_register(struct host1x_client *client);
-int host1x_client_unregister(struct host1x_client *client);
-
 struct tegra_mipi_device;
 
 struct tegra_mipi_device *tegra_mipi_request(struct device *device);
-- 
1.9.2

