Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933639Ab3CMMiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 08:38:09 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4284 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933053Ab3CMMf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 08:35:57 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 13 Mar 2013 05:35:50 -0700
From: Terje Bergstrom <tbergstrom@nvidia.com>
To: <airlied@linux.ie>, <thierry.reding@avionic-design.de>,
        <linux-tegra@vger.kernel.org>, <dri-devel@lists.freedesktop.org>
CC: <linux-kernel@vger.kernel.org>, <amerilainen@nvidia.com>,
        Terje Bergstrom <tbergstrom@nvidia.com>
Subject: [PATCHv7 08/10] gpu: host1x: Remove second host1x driver
Date: Wed, 13 Mar 2013 14:36:24 +0200
Message-ID: <1363178186-2017-9-git-send-email-tbergstrom@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363178186-2017-1-git-send-email-tbergstrom@nvidia.com>
References: <1363178186-2017-1-git-send-email-tbergstrom@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove second host1x driver, and bind tegra-drm to the new host1x
driver. The logic to parse device tree and track clients is moved
to drm.c.

Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
Signed-off-by: Terje Bergstrom <tbergstrom@nvidia.com>
---
 drivers/gpu/host1x/Makefile        |    2 +-
 drivers/gpu/host1x/dev.c           |   58 ++++++-
 drivers/gpu/host1x/dev.h           |    6 +
 drivers/gpu/host1x/drm/Kconfig     |    2 +-
 drivers/gpu/host1x/drm/dc.c        |    5 +-
 drivers/gpu/host1x/drm/drm.c       |  217 +++++++++++++++++++++++-
 drivers/gpu/host1x/drm/drm.h       |    3 -
 drivers/gpu/host1x/drm/hdmi.c      |    5 +-
 drivers/gpu/host1x/drm/host1x.c    |  329 ------------------------------------
 drivers/gpu/host1x/host1x_client.h |   35 ++++
 10 files changed, 318 insertions(+), 344 deletions(-)
 delete mode 100644 drivers/gpu/host1x/drm/host1x.c
 create mode 100644 drivers/gpu/host1x/host1x_client.h

diff --git a/drivers/gpu/host1x/Makefile b/drivers/gpu/host1x/Makefile
index 4761e8a..9a6fc76 100644
--- a/drivers/gpu/host1x/Makefile
+++ b/drivers/gpu/host1x/Makefile
@@ -13,6 +13,6 @@ host1x-y = \
 ccflags-y += -Iinclude/drm
 ccflags-$(CONFIG_DRM_TEGRA_DEBUG) += -DDEBUG
 
-host1x-$(CONFIG_DRM_TEGRA) += drm/drm.o drm/fb.o drm/dc.o drm/host1x.o
+host1x-$(CONFIG_DRM_TEGRA) += drm/drm.o drm/fb.o drm/dc.o
 host1x-$(CONFIG_DRM_TEGRA) += drm/output.o drm/rgb.o drm/hdmi.o
 obj-$(CONFIG_TEGRA_HOST1X) += host1x.o
diff --git a/drivers/gpu/host1x/dev.c b/drivers/gpu/host1x/dev.c
index d7c6e3e..6af8081 100644
--- a/drivers/gpu/host1x/dev.c
+++ b/drivers/gpu/host1x/dev.c
@@ -32,6 +32,19 @@
 #include "channel.h"
 #include "debug.h"
 #include "hw/host1x01.h"
+#include "host1x_client.h"
+
+void host1x_set_drm_data(struct device *dev, void *data)
+{
+	struct host1x *host1x = dev_get_drvdata(dev);
+	host1x->drm_data = data;
+}
+
+void *host1x_get_drm_data(struct device *dev)
+{
+	struct host1x *host1x = dev_get_drvdata(dev);
+	return host1x->drm_data;
+}
 
 void host1x_sync_writel(struct host1x *host1x, u32 v, u32 r)
 {
@@ -154,6 +167,8 @@ static int host1x_probe(struct platform_device *pdev)
 
 	host1x_debug_init(host);
 
+	host1x_drm_alloc(pdev);
+
 	return 0;
 
 fail_deinit_syncpt:
@@ -170,7 +185,7 @@ static int __exit host1x_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static struct platform_driver platform_driver = {
+static struct platform_driver tegra_host1x_driver = {
 	.probe = host1x_probe,
 	.remove = __exit_p(host1x_remove),
 	.driver = {
@@ -180,8 +195,47 @@ static struct platform_driver platform_driver = {
 	},
 };
 
-module_platform_driver(platform_driver);
+static int __init tegra_host1x_init(void)
+{
+	int err;
+
+	err = platform_driver_register(&tegra_host1x_driver);
+	if (err < 0)
+		return err;
+
+#ifdef CONFIG_DRM_TEGRA
+	err = platform_driver_register(&tegra_dc_driver);
+	if (err < 0)
+		goto unregister_host1x;
+
+	err = platform_driver_register(&tegra_hdmi_driver);
+	if (err < 0)
+		goto unregister_dc;
+#endif
+
+	return 0;
+
+#ifdef CONFIG_DRM_TEGRA
+unregister_dc:
+	platform_driver_unregister(&tegra_dc_driver);
+unregister_host1x:
+	platform_driver_unregister(&tegra_host1x_driver);
+	return err;
+#endif
+}
+module_init(tegra_host1x_init);
+
+static void __exit tegra_host1x_exit(void)
+{
+#ifdef CONFIG_DRM_TEGRA
+	platform_driver_unregister(&tegra_hdmi_driver);
+	platform_driver_unregister(&tegra_dc_driver);
+#endif
+	platform_driver_unregister(&tegra_host1x_driver);
+}
+module_exit(tegra_host1x_exit);
 
+MODULE_AUTHOR("Thierry Reding <thierry.reding@avionic-design.de>");
 MODULE_AUTHOR("Terje Bergstrom <tbergstrom@nvidia.com>");
 MODULE_DESCRIPTION("Host1x driver for Tegra products");
 MODULE_LICENSE("GPL");
diff --git a/drivers/gpu/host1x/dev.h b/drivers/gpu/host1x/dev.h
index 4a56233..ca2ba8a 100644
--- a/drivers/gpu/host1x/dev.h
+++ b/drivers/gpu/host1x/dev.h
@@ -124,6 +124,8 @@ struct host1x {
 	unsigned int num_allocated_channels;
 
 	struct dentry *debugfs;
+
+	void *drm_data;
 };
 
 static inline struct host1x *host1x_get_host(struct device *dev)
@@ -307,4 +309,8 @@ static inline void host1x_hw_show_mlocks(struct host1x *host, struct output *o)
 	host->debug_op->show_mlocks(host, o);
 }
 
+extern struct platform_driver tegra_hdmi_driver;
+extern struct platform_driver tegra_dc_driver;
+extern struct platform_driver tegra_gr2d_driver;
+
 #endif
diff --git a/drivers/gpu/host1x/drm/Kconfig b/drivers/gpu/host1x/drm/Kconfig
index c92955d..8fb6545 100644
--- a/drivers/gpu/host1x/drm/Kconfig
+++ b/drivers/gpu/host1x/drm/Kconfig
@@ -1,5 +1,5 @@
 config DRM_TEGRA
-	tristate "NVIDIA Tegra DRM"
+	bool "NVIDIA Tegra DRM"
 	depends on DRM && OF && ARCH_TEGRA
 	select DRM_KMS_HELPER
 	select DRM_GEM_CMA_HELPER
diff --git a/drivers/gpu/host1x/drm/dc.c b/drivers/gpu/host1x/drm/dc.c
index d1f6609..29a79b6 100644
--- a/drivers/gpu/host1x/drm/dc.c
+++ b/drivers/gpu/host1x/drm/dc.c
@@ -16,6 +16,7 @@
 
 #include "drm.h"
 #include "dc.h"
+#include "host1x_client.h"
 
 struct tegra_plane {
 	struct drm_plane base;
@@ -1097,7 +1098,7 @@ static const struct host1x_client_ops dc_client_ops = {
 
 static int tegra_dc_probe(struct platform_device *pdev)
 {
-	struct host1x_drm *host1x = dev_get_drvdata(pdev->dev.parent);
+	struct host1x_drm *host1x = host1x_get_drm_data(pdev->dev.parent);
 	struct resource *regs;
 	struct tegra_dc *dc;
 	int err;
@@ -1160,7 +1161,7 @@ static int tegra_dc_probe(struct platform_device *pdev)
 
 static int tegra_dc_remove(struct platform_device *pdev)
 {
-	struct host1x_drm *host1x = dev_get_drvdata(pdev->dev.parent);
+	struct host1x_drm *host1x = host1x_get_drm_data(pdev->dev.parent);
 	struct tegra_dc *dc = platform_get_drvdata(pdev);
 	int err;
 
diff --git a/drivers/gpu/host1x/drm/drm.c b/drivers/gpu/host1x/drm/drm.c
index 6c59bcd..dbd4808 100644
--- a/drivers/gpu/host1x/drm/drm.c
+++ b/drivers/gpu/host1x/drm/drm.c
@@ -7,14 +7,14 @@
  * published by the Free Software Foundation.
  */
 
+#include <asm/dma-iommu.h>
 #include <linux/module.h>
 #include <linux/of_address.h>
 #include <linux/of_platform.h>
-
 #include <linux/dma-mapping.h>
-#include <asm/dma-iommu.h>
 
 #include "drm.h"
+#include "host1x_client.h"
 
 #define DRIVER_NAME "tegra"
 #define DRIVER_DESC "NVIDIA Tegra graphics"
@@ -23,13 +23,222 @@
 #define DRIVER_MINOR 0
 #define DRIVER_PATCHLEVEL 0
 
+struct host1x_drm_client {
+	struct host1x_client *client;
+	struct device_node *np;
+	struct list_head list;
+};
+
+static int host1x_add_drm_client(struct host1x_drm *host1x,
+				 struct device_node *np)
+{
+	struct host1x_drm_client *client;
+
+	client = kzalloc(sizeof(*client), GFP_KERNEL);
+	if (!client)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&client->list);
+	client->np = of_node_get(np);
+
+	list_add_tail(&client->list, &host1x->drm_clients);
+
+	return 0;
+}
+
+static int host1x_activate_drm_client(struct host1x_drm *host1x,
+				      struct host1x_drm_client *drm,
+				      struct host1x_client *client)
+{
+	mutex_lock(&host1x->drm_clients_lock);
+	list_del_init(&drm->list);
+	list_add_tail(&drm->list, &host1x->drm_active);
+	drm->client = client;
+	mutex_unlock(&host1x->drm_clients_lock);
+
+	return 0;
+}
+
+static int host1x_remove_drm_client(struct host1x_drm *host1x,
+				    struct host1x_drm_client *client)
+{
+	mutex_lock(&host1x->drm_clients_lock);
+	list_del_init(&client->list);
+	mutex_unlock(&host1x->drm_clients_lock);
+
+	of_node_put(client->np);
+	kfree(client);
+
+	return 0;
+}
+
+static int host1x_parse_dt(struct host1x_drm *host1x)
+{
+	static const char * const compat[] = {
+		"nvidia,tegra20-dc",
+		"nvidia,tegra20-hdmi",
+		"nvidia,tegra30-dc",
+		"nvidia,tegra30-hdmi",
+	};
+	unsigned int i;
+	int err;
+
+	for (i = 0; i < ARRAY_SIZE(compat); i++) {
+		struct device_node *np;
+
+		for_each_child_of_node(host1x->dev->of_node, np) {
+			if (of_device_is_compatible(np, compat[i]) &&
+			    of_device_is_available(np)) {
+				err = host1x_add_drm_client(host1x, np);
+				if (err < 0)
+					return err;
+			}
+		}
+	}
+
+	return 0;
+}
+
+int host1x_drm_alloc(struct platform_device *pdev)
+{
+	struct host1x_drm *host1x;
+	int err;
+
+	host1x = devm_kzalloc(&pdev->dev, sizeof(*host1x), GFP_KERNEL);
+	if (!host1x)
+		return -ENOMEM;
+
+	mutex_init(&host1x->drm_clients_lock);
+	INIT_LIST_HEAD(&host1x->drm_clients);
+	INIT_LIST_HEAD(&host1x->drm_active);
+	mutex_init(&host1x->clients_lock);
+	INIT_LIST_HEAD(&host1x->clients);
+	host1x->dev = &pdev->dev;
+
+	err = host1x_parse_dt(host1x);
+	if (err < 0) {
+		dev_err(&pdev->dev, "failed to parse DT: %d\n", err);
+		return err;
+	}
+
+	host1x_set_drm_data(&pdev->dev, host1x);
+
+	return 0;
+}
+
+int host1x_drm_init(struct host1x_drm *host1x, struct drm_device *drm)
+{
+	struct host1x_client *client;
+
+	mutex_lock(&host1x->clients_lock);
+
+	list_for_each_entry(client, &host1x->clients, list) {
+		if (client->ops && client->ops->drm_init) {
+			int err = client->ops->drm_init(client, drm);
+			if (err < 0) {
+				dev_err(host1x->dev,
+					"DRM setup failed for %s: %d\n",
+					dev_name(client->dev), err);
+				return err;
+			}
+		}
+	}
+
+	mutex_unlock(&host1x->clients_lock);
+
+	return 0;
+}
+
+int host1x_drm_exit(struct host1x_drm *host1x)
+{
+	struct platform_device *pdev = to_platform_device(host1x->dev);
+	struct host1x_client *client;
+
+	if (!host1x->drm)
+		return 0;
+
+	mutex_lock(&host1x->clients_lock);
+
+	list_for_each_entry_reverse(client, &host1x->clients, list) {
+		if (client->ops && client->ops->drm_exit) {
+			int err = client->ops->drm_exit(client);
+			if (err < 0) {
+				dev_err(host1x->dev,
+					"DRM cleanup failed for %s: %d\n",
+					dev_name(client->dev), err);
+				return err;
+			}
+		}
+	}
+
+	mutex_unlock(&host1x->clients_lock);
+
+	drm_platform_exit(&tegra_drm_driver, pdev);
+	host1x->drm = NULL;
+
+	return 0;
+}
+
+int host1x_register_client(struct host1x_drm *host1x,
+			   struct host1x_client *client)
+{
+	struct host1x_drm_client *drm, *tmp;
+	int err;
+
+	mutex_lock(&host1x->clients_lock);
+	list_add_tail(&client->list, &host1x->clients);
+	mutex_unlock(&host1x->clients_lock);
+
+	list_for_each_entry_safe(drm, tmp, &host1x->drm_clients, list)
+		if (drm->np == client->dev->of_node)
+			host1x_activate_drm_client(host1x, drm, client);
+
+	if (list_empty(&host1x->drm_clients)) {
+		struct platform_device *pdev = to_platform_device(host1x->dev);
+
+		err = drm_platform_init(&tegra_drm_driver, pdev);
+		if (err < 0) {
+			dev_err(host1x->dev, "drm_platform_init(): %d\n", err);
+			return err;
+		}
+	}
+
+	return 0;
+}
+
+int host1x_unregister_client(struct host1x_drm *host1x,
+			     struct host1x_client *client)
+{
+	struct host1x_drm_client *drm, *tmp;
+	int err;
+
+	list_for_each_entry_safe(drm, tmp, &host1x->drm_active, list) {
+		if (drm->client == client) {
+			err = host1x_drm_exit(host1x);
+			if (err < 0) {
+				dev_err(host1x->dev, "host1x_drm_exit(): %d\n",
+					err);
+				return err;
+			}
+
+			host1x_remove_drm_client(host1x, drm);
+			break;
+		}
+	}
+
+	mutex_lock(&host1x->clients_lock);
+	list_del_init(&client->list);
+	mutex_unlock(&host1x->clients_lock);
+
+	return 0;
+}
+
 static int tegra_drm_load(struct drm_device *drm, unsigned long flags)
 {
-	struct device *dev = drm->dev;
 	struct host1x_drm *host1x;
 	int err;
 
-	host1x = dev_get_drvdata(dev);
+	host1x = host1x_get_drm_data(drm->dev);
 	drm->dev_private = host1x;
 	host1x->drm = drm;
 
diff --git a/drivers/gpu/host1x/drm/drm.h b/drivers/gpu/host1x/drm/drm.h
index 7fedb6c..0b8738f 100644
--- a/drivers/gpu/host1x/drm/drm.h
+++ b/drivers/gpu/host1x/drm/drm.h
@@ -229,9 +229,6 @@ extern int tegra_output_exit(struct tegra_output *output);
 extern int tegra_drm_fb_init(struct drm_device *drm);
 extern void tegra_drm_fb_exit(struct drm_device *drm);
 
-extern struct platform_driver tegra_host1x_driver;
-extern struct platform_driver tegra_hdmi_driver;
-extern struct platform_driver tegra_dc_driver;
 extern struct drm_driver tegra_drm_driver;
 
 #endif /* HOST1X_DRM_H */
diff --git a/drivers/gpu/host1x/drm/hdmi.c b/drivers/gpu/host1x/drm/hdmi.c
index f438f80..01097da 100644
--- a/drivers/gpu/host1x/drm/hdmi.c
+++ b/drivers/gpu/host1x/drm/hdmi.c
@@ -22,6 +22,7 @@
 #include "hdmi.h"
 #include "drm.h"
 #include "dc.h"
+#include "host1x_client.h"
 
 struct tegra_hdmi {
 	struct host1x_client client;
@@ -1189,7 +1190,7 @@ static const struct host1x_client_ops hdmi_client_ops = {
 
 static int tegra_hdmi_probe(struct platform_device *pdev)
 {
-	struct host1x_drm *host1x = dev_get_drvdata(pdev->dev.parent);
+	struct host1x_drm *host1x = host1x_get_drm_data(pdev->dev.parent);
 	struct tegra_hdmi *hdmi;
 	struct resource *regs;
 	int err;
@@ -1278,7 +1279,7 @@ static int tegra_hdmi_probe(struct platform_device *pdev)
 
 static int tegra_hdmi_remove(struct platform_device *pdev)
 {
-	struct host1x_drm *host1x = dev_get_drvdata(pdev->dev.parent);
+	struct host1x_drm *host1x = host1x_get_drm_data(pdev->dev.parent);
 	struct tegra_hdmi *hdmi = platform_get_drvdata(pdev);
 	int err;
 
diff --git a/drivers/gpu/host1x/drm/host1x.c b/drivers/gpu/host1x/drm/host1x.c
deleted file mode 100644
index c3d8ee5..0000000
--- a/drivers/gpu/host1x/drm/host1x.c
+++ /dev/null
@@ -1,329 +0,0 @@
-/*
- * Copyright (C) 2012 Avionic Design GmbH
- * Copyright (C) 2012 NVIDIA CORPORATION.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/clk.h>
-#include <linux/err.h>
-#include <linux/module.h>
-#include <linux/of.h>
-#include <linux/platform_device.h>
-
-#include "drm.h"
-
-struct host1x_drm_client {
-	struct host1x_client *client;
-	struct device_node *np;
-	struct list_head list;
-};
-
-static int host1x_add_drm_client(struct host1x_drm *host1x,
-				 struct device_node *np)
-{
-	struct host1x_drm_client *client;
-
-	client = kzalloc(sizeof(*client), GFP_KERNEL);
-	if (!client)
-		return -ENOMEM;
-
-	INIT_LIST_HEAD(&client->list);
-	client->np = of_node_get(np);
-
-	list_add_tail(&client->list, &host1x->drm_clients);
-
-	return 0;
-}
-
-static int host1x_activate_drm_client(struct host1x_drm *host1x,
-				      struct host1x_drm_client *drm,
-				      struct host1x_client *client)
-{
-	mutex_lock(&host1x->drm_clients_lock);
-	list_del_init(&drm->list);
-	list_add_tail(&drm->list, &host1x->drm_active);
-	drm->client = client;
-	mutex_unlock(&host1x->drm_clients_lock);
-
-	return 0;
-}
-
-static int host1x_remove_drm_client(struct host1x_drm *host1x,
-				    struct host1x_drm_client *client)
-{
-	mutex_lock(&host1x->drm_clients_lock);
-	list_del_init(&client->list);
-	mutex_unlock(&host1x->drm_clients_lock);
-
-	of_node_put(client->np);
-	kfree(client);
-
-	return 0;
-}
-
-static int host1x_parse_dt(struct host1x_drm *host1x)
-{
-	static const char * const compat[] = {
-		"nvidia,tegra20-dc",
-		"nvidia,tegra20-hdmi",
-		"nvidia,tegra30-dc",
-		"nvidia,tegra30-hdmi",
-	};
-	unsigned int i;
-	int err;
-
-	for (i = 0; i < ARRAY_SIZE(compat); i++) {
-		struct device_node *np;
-
-		for_each_child_of_node(host1x->dev->of_node, np) {
-			if (of_device_is_compatible(np, compat[i]) &&
-			    of_device_is_available(np)) {
-				err = host1x_add_drm_client(host1x, np);
-				if (err < 0)
-					return err;
-			}
-		}
-	}
-
-	return 0;
-}
-
-static int tegra_host1x_probe(struct platform_device *pdev)
-{
-	struct host1x_drm *host1x;
-	struct resource *regs;
-	int err;
-
-	host1x = devm_kzalloc(&pdev->dev, sizeof(*host1x), GFP_KERNEL);
-	if (!host1x)
-		return -ENOMEM;
-
-	mutex_init(&host1x->drm_clients_lock);
-	INIT_LIST_HEAD(&host1x->drm_clients);
-	INIT_LIST_HEAD(&host1x->drm_active);
-	mutex_init(&host1x->clients_lock);
-	INIT_LIST_HEAD(&host1x->clients);
-	host1x->dev = &pdev->dev;
-
-	err = host1x_parse_dt(host1x);
-	if (err < 0) {
-		dev_err(&pdev->dev, "failed to parse DT: %d\n", err);
-		return err;
-	}
-
-	host1x->clk = devm_clk_get(&pdev->dev, NULL);
-	if (IS_ERR(host1x->clk))
-		return PTR_ERR(host1x->clk);
-
-	err = clk_prepare_enable(host1x->clk);
-	if (err < 0)
-		return err;
-
-	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!regs) {
-		err = -ENXIO;
-		goto err;
-	}
-
-	err = platform_get_irq(pdev, 0);
-	if (err < 0)
-		goto err;
-
-	host1x->syncpt = err;
-
-	err = platform_get_irq(pdev, 1);
-	if (err < 0)
-		goto err;
-
-	host1x->irq = err;
-
-	host1x->regs = devm_ioremap_resource(&pdev->dev, regs);
-	if (IS_ERR(host1x->regs)) {
-		err = PTR_ERR(host1x->regs);
-		goto err;
-	}
-
-	platform_set_drvdata(pdev, host1x);
-
-	return 0;
-
-err:
-	clk_disable_unprepare(host1x->clk);
-	return err;
-}
-
-static int tegra_host1x_remove(struct platform_device *pdev)
-{
-	struct host1x_drm *host1x = platform_get_drvdata(pdev);
-
-	clk_disable_unprepare(host1x->clk);
-
-	return 0;
-}
-
-int host1x_drm_init(struct host1x_drm *host1x, struct drm_device *drm)
-{
-	struct host1x_client *client;
-
-	mutex_lock(&host1x->clients_lock);
-
-	list_for_each_entry(client, &host1x->clients, list) {
-		if (client->ops && client->ops->drm_init) {
-			int err = client->ops->drm_init(client, drm);
-			if (err < 0) {
-				dev_err(host1x->dev,
-					"DRM setup failed for %s: %d\n",
-					dev_name(client->dev), err);
-				return err;
-			}
-		}
-	}
-
-	mutex_unlock(&host1x->clients_lock);
-
-	return 0;
-}
-
-int host1x_drm_exit(struct host1x_drm *host1x)
-{
-	struct platform_device *pdev = to_platform_device(host1x->dev);
-	struct host1x_client *client;
-
-	if (!host1x->drm)
-		return 0;
-
-	mutex_lock(&host1x->clients_lock);
-
-	list_for_each_entry_reverse(client, &host1x->clients, list) {
-		if (client->ops && client->ops->drm_exit) {
-			int err = client->ops->drm_exit(client);
-			if (err < 0) {
-				dev_err(host1x->dev,
-					"DRM cleanup failed for %s: %d\n",
-					dev_name(client->dev), err);
-				return err;
-			}
-		}
-	}
-
-	mutex_unlock(&host1x->clients_lock);
-
-	drm_platform_exit(&tegra_drm_driver, pdev);
-	host1x->drm = NULL;
-
-	return 0;
-}
-
-int host1x_register_client(struct host1x_drm *host1x,
-			   struct host1x_client *client)
-{
-	struct host1x_drm_client *drm, *tmp;
-	int err;
-
-	mutex_lock(&host1x->clients_lock);
-	list_add_tail(&client->list, &host1x->clients);
-	mutex_unlock(&host1x->clients_lock);
-
-	list_for_each_entry_safe(drm, tmp, &host1x->drm_clients, list)
-		if (drm->np == client->dev->of_node)
-			host1x_activate_drm_client(host1x, drm, client);
-
-	if (list_empty(&host1x->drm_clients)) {
-		struct platform_device *pdev = to_platform_device(host1x->dev);
-
-		err = drm_platform_init(&tegra_drm_driver, pdev);
-		if (err < 0) {
-			dev_err(host1x->dev, "drm_platform_init(): %d\n", err);
-			return err;
-		}
-	}
-
-	client->host1x = host1x;
-
-	return 0;
-}
-
-int host1x_unregister_client(struct host1x_drm *host1x,
-			     struct host1x_client *client)
-{
-	struct host1x_drm_client *drm, *tmp;
-	int err;
-
-	list_for_each_entry_safe(drm, tmp, &host1x->drm_active, list) {
-		if (drm->client == client) {
-			err = host1x_drm_exit(host1x);
-			if (err < 0) {
-				dev_err(host1x->dev, "host1x_drm_exit(): %d\n",
-					err);
-				return err;
-			}
-
-			host1x_remove_drm_client(host1x, drm);
-			break;
-		}
-	}
-
-	mutex_lock(&host1x->clients_lock);
-	list_del_init(&client->list);
-	mutex_unlock(&host1x->clients_lock);
-
-	return 0;
-}
-
-static struct of_device_id tegra_host1x_of_match[] = {
-	{ .compatible = "nvidia,tegra30-host1x", },
-	{ .compatible = "nvidia,tegra20-host1x", },
-	{ },
-};
-MODULE_DEVICE_TABLE(of, tegra_host1x_of_match);
-
-struct platform_driver tegra_host1x_driver = {
-	.driver = {
-		.name = "tegra-host1x",
-		.owner = THIS_MODULE,
-		.of_match_table = tegra_host1x_of_match,
-	},
-	.probe = tegra_host1x_probe,
-	.remove = tegra_host1x_remove,
-};
-
-static int __init tegra_host1x_init(void)
-{
-	int err;
-
-	err = platform_driver_register(&tegra_host1x_driver);
-	if (err < 0)
-		return err;
-
-	err = platform_driver_register(&tegra_dc_driver);
-	if (err < 0)
-		goto unregister_host1x;
-
-	err = platform_driver_register(&tegra_hdmi_driver);
-	if (err < 0)
-		goto unregister_dc;
-
-	return 0;
-
-unregister_dc:
-	platform_driver_unregister(&tegra_dc_driver);
-unregister_host1x:
-	platform_driver_unregister(&tegra_host1x_driver);
-	return err;
-}
-module_init(tegra_host1x_init);
-
-static void __exit tegra_host1x_exit(void)
-{
-	platform_driver_unregister(&tegra_hdmi_driver);
-	platform_driver_unregister(&tegra_dc_driver);
-	platform_driver_unregister(&tegra_host1x_driver);
-}
-module_exit(tegra_host1x_exit);
-
-MODULE_AUTHOR("Thierry Reding <thierry.reding@avionic-design.de>");
-MODULE_DESCRIPTION("NVIDIA Tegra DRM driver");
-MODULE_LICENSE("GPL");
diff --git a/drivers/gpu/host1x/host1x_client.h b/drivers/gpu/host1x/host1x_client.h
new file mode 100644
index 0000000..9b85f10
--- /dev/null
+++ b/drivers/gpu/host1x/host1x_client.h
@@ -0,0 +1,35 @@
+/*
+ * Copyright (c) 2013, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef HOST1X_CLIENT_H
+#define HOST1X_CLIENT_H
+
+struct device;
+struct platform_device;
+
+#ifdef CONFIG_DRM_TEGRA
+int host1x_drm_alloc(struct platform_device *pdev);
+#else
+static inline int host1x_drm_alloc(struct platform_device *pdev)
+{
+	return 0;
+}
+#endif
+
+void host1x_set_drm_data(struct device *dev, void *data);
+void *host1x_get_drm_data(struct device *dev);
+
+#endif
-- 
1.7.9.5

