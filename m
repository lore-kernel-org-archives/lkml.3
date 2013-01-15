Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817Ab3AOLWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 06:22:53 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5191 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756608Ab3AOLVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 06:21:18 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 15 Jan 2013 03:20:07 -0800
From: Terje Bergstrom <tbergstrom@nvidia.com>
To: <amerilainen@nvidia.com>, <airlied@linux.ie>,
        <thierry.reding@avionic-design.de>
CC: <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Terje Bergstrom <tbergstrom@nvidia.com>
Subject: [PATCHv5 6/8] gpu: host1x: Remove second host1x driver
Date: Tue, 15 Jan 2013 13:26:20 +0200
Message-ID: <1358249182-17486-7-git-send-email-tbergstrom@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358249182-17486-1-git-send-email-tbergstrom@nvidia.com>
References: <1358249182-17486-1-git-send-email-tbergstrom@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove second host1x driver, and bind tegra-drm to the new host1x driver. The
logic to parse device tree and track clients is moved to drm.c.

Signed-off-by: Terje Bergstrom <tbergstrom@nvidia.com>
---
 drivers/gpu/host1x/Makefile        |    2 +-
 drivers/gpu/host1x/dev.c           |   58 +++++++++-
 drivers/gpu/host1x/dev.h           |    6 +
 drivers/gpu/host1x/drm/Kconfig     |    2 +-
 drivers/gpu/host1x/drm/dc.c        |    7 +-
 drivers/gpu/host1x/drm/drm.c       |  213 +++++++++++++++++++++++++++++++++++-
 drivers/gpu/host1x/drm/drm.h       |    3 -
 drivers/gpu/host1x/drm/hdmi.c      |    7 +-
 drivers/gpu/host1x/host1x_client.h |    9 ++
 9 files changed, 294 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/host1x/Makefile b/drivers/gpu/host1x/Makefile
index ffc8bf1..c35ee19 100644
--- a/drivers/gpu/host1x/Makefile
+++ b/drivers/gpu/host1x/Makefile
@@ -16,6 +16,6 @@ host1x-$(CONFIG_TEGRA_HOST1X_CMA) += cma.o
 ccflags-y += -Iinclude/drm
 ccflags-$(CONFIG_DRM_TEGRA_DEBUG) += -DDEBUG
 
-host1x-$(CONFIG_DRM_TEGRA) += drm/drm.o drm/fb.o drm/dc.o drm/host1x.o
+host1x-$(CONFIG_DRM_TEGRA) += drm/drm.o drm/fb.o drm/dc.o
 host1x-$(CONFIG_DRM_TEGRA) += drm/output.o drm/rgb.o drm/hdmi.o
 obj-$(CONFIG_TEGRA_HOST1X) += host1x.o
diff --git a/drivers/gpu/host1x/dev.c b/drivers/gpu/host1x/dev.c
index 5aa7d28..17ee01c 100644
--- a/drivers/gpu/host1x/dev.c
+++ b/drivers/gpu/host1x/dev.c
@@ -28,12 +28,25 @@
 #include "channel.h"
 #include "debug.h"
 #include "hw/host1x01.h"
+#include "host1x_client.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/host1x.h>
 
 #define DRIVER_NAME		"tegra-host1x"
 
+void host1x_set_drm_data(struct platform_device *pdev, void *data)
+{
+	struct host1x *host1x = platform_get_drvdata(pdev);
+	host1x->drm_data = data;
+}
+
+void *host1x_get_drm_data(struct platform_device *pdev)
+{
+	struct host1x *host1x = platform_get_drvdata(pdev);
+	return host1x->drm_data;
+}
+
 void host1x_sync_writel(struct host1x *host1x, u32 v, u32 r)
 {
 	void __iomem *sync_regs = host1x->regs + host1x->info.sync_offset;
@@ -153,6 +166,8 @@ static int host1x_probe(struct platform_device *dev)
 
 	host1x_debug_init(host);
 
+	host1x_drm_alloc(dev);
+
 	dev_info(&dev->dev, "initialized\n");
 
 	return 0;
@@ -173,7 +188,7 @@ static int __exit host1x_remove(struct platform_device *dev)
 	return 0;
 }
 
-static struct platform_driver platform_driver = {
+static struct platform_driver tegra_host1x_driver = {
 	.probe = host1x_probe,
 	.remove = __exit_p(host1x_remove),
 	.driver = {
@@ -183,8 +198,47 @@ static struct platform_driver platform_driver = {
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
+#ifdef CONFIG_TEGRA_DRM
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
+#ifdef CONFIG_TEGRA_DRM
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
+#ifdef CONFIG_TEGRA_DRM
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
index 467a92e..ff3a365 100644
--- a/drivers/gpu/host1x/dev.h
+++ b/drivers/gpu/host1x/dev.h
@@ -142,6 +142,8 @@ struct host1x {
 	int allocated_channels;
 
 	struct dentry *debugfs;
+
+	void *drm_data;
 };
 
 static inline
@@ -161,4 +163,8 @@ u32 host1x_sync_readl(struct host1x *host1x, u32 r);
 void host1x_ch_writel(struct host1x_channel *ch, u32 r, u32 v);
 u32 host1x_ch_readl(struct host1x_channel *ch, u32 r);
 
+extern struct platform_driver tegra_hdmi_driver;
+extern struct platform_driver tegra_dc_driver;
+extern struct platform_driver tegra_gr2d_driver;
+
 #endif
diff --git a/drivers/gpu/host1x/drm/Kconfig b/drivers/gpu/host1x/drm/Kconfig
index be1daf7..7db9b3a 100644
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
index 656b2e3..ac31e96 100644
--- a/drivers/gpu/host1x/drm/dc.c
+++ b/drivers/gpu/host1x/drm/dc.c
@@ -17,6 +17,7 @@
 
 #include "drm.h"
 #include "dc.h"
+#include "host1x_client.h"
 
 struct tegra_dc_window {
 	fixed20_12 x;
@@ -736,7 +737,8 @@ static const struct host1x_client_ops dc_client_ops = {
 
 static int tegra_dc_probe(struct platform_device *pdev)
 {
-	struct host1x *host1x = dev_get_drvdata(pdev->dev.parent);
+	struct host1x *host1x =
+		host1x_get_drm_data(to_platform_device(pdev->dev.parent));
 	struct resource *regs;
 	struct tegra_dc *dc;
 	int err;
@@ -800,7 +802,8 @@ static int tegra_dc_probe(struct platform_device *pdev)
 
 static int tegra_dc_remove(struct platform_device *pdev)
 {
-	struct host1x *host1x = dev_get_drvdata(pdev->dev.parent);
+	struct host1x *host1x =
+		host1x_get_drm_data(to_platform_device(pdev->dev.parent));
 	struct tegra_dc *dc = platform_get_drvdata(pdev);
 	int err;
 
diff --git a/drivers/gpu/host1x/drm/drm.c b/drivers/gpu/host1x/drm/drm.c
index 3a503c9..bef9051 100644
--- a/drivers/gpu/host1x/drm/drm.c
+++ b/drivers/gpu/host1x/drm/drm.c
@@ -16,6 +16,7 @@
 #include <asm/dma-iommu.h>
 
 #include "drm.h"
+#include "host1x_client.h"
 
 #define DRIVER_NAME "tegra"
 #define DRIVER_DESC "NVIDIA Tegra graphics"
@@ -24,13 +25,221 @@
 #define DRIVER_MINOR 0
 #define DRIVER_PATCHLEVEL 0
 
+struct host1x_drm_client {
+	struct host1x_client *client;
+	struct device_node *np;
+	struct list_head list;
+};
+
+static int host1x_add_drm_client(struct host1x *host1x, struct device_node *np)
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
+static int host1x_activate_drm_client(struct host1x *host1x,
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
+static int host1x_remove_drm_client(struct host1x *host1x,
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
+static int host1x_parse_dt(struct host1x *host1x)
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
+	struct host1x *host1x;
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
+	host1x_set_drm_data(pdev, host1x);
+
+	return 0;
+}
+
+int host1x_drm_init(struct host1x *host1x, struct drm_device *drm)
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
+int host1x_drm_exit(struct host1x *host1x)
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
+int host1x_register_client(struct host1x *host1x, struct host1x_client *client)
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
+int host1x_unregister_client(struct host1x *host1x,
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
+	struct platform_device *pdev = to_platform_device(drm->dev);
 	struct host1x *host1x;
 	int err;
 
-	host1x = dev_get_drvdata(dev);
+	host1x = host1x_get_drm_data(pdev);
 	drm->dev_private = host1x;
 	host1x->drm = drm;
 
diff --git a/drivers/gpu/host1x/drm/drm.h b/drivers/gpu/host1x/drm/drm.h
index e68b4ac..e7101d5 100644
--- a/drivers/gpu/host1x/drm/drm.h
+++ b/drivers/gpu/host1x/drm/drm.h
@@ -208,9 +208,6 @@ extern int tegra_output_exit(struct tegra_output *output);
 extern int tegra_drm_fb_init(struct drm_device *drm);
 extern void tegra_drm_fb_exit(struct drm_device *drm);
 
-extern struct platform_driver tegra_host1x_driver;
-extern struct platform_driver tegra_hdmi_driver;
-extern struct platform_driver tegra_dc_driver;
 extern struct drm_driver tegra_drm_driver;
 
 #endif /* HOST1X_DRM_H */
diff --git a/drivers/gpu/host1x/drm/hdmi.c b/drivers/gpu/host1x/drm/hdmi.c
index e060c7e..2f1e7b4 100644
--- a/drivers/gpu/host1x/drm/hdmi.c
+++ b/drivers/gpu/host1x/drm/hdmi.c
@@ -20,6 +20,7 @@
 #include "hdmi.h"
 #include "drm.h"
 #include "dc.h"
+#include "host1x_client.h"
 
 struct tegra_hdmi {
 	struct host1x_client client;
@@ -1198,7 +1199,8 @@ static const struct host1x_client_ops hdmi_client_ops = {
 
 static int tegra_hdmi_probe(struct platform_device *pdev)
 {
-	struct host1x *host1x = dev_get_drvdata(pdev->dev.parent);
+	struct host1x *host1x =
+		host1x_get_drm_data(to_platform_device(pdev->dev.parent));
 	struct tegra_hdmi *hdmi;
 	struct resource *regs;
 	int err;
@@ -1287,7 +1289,8 @@ static int tegra_hdmi_probe(struct platform_device *pdev)
 
 static int tegra_hdmi_remove(struct platform_device *pdev)
 {
-	struct host1x *host1x = dev_get_drvdata(pdev->dev.parent);
+	struct host1x *host1x =
+		host1x_get_drm_data(to_platform_device(pdev->dev.parent));
 	struct tegra_hdmi *hdmi = platform_get_drvdata(pdev);
 	int err;
 
diff --git a/drivers/gpu/host1x/host1x_client.h b/drivers/gpu/host1x/host1x_client.h
index fdd2920..938df7e 100644
--- a/drivers/gpu/host1x/host1x_client.h
+++ b/drivers/gpu/host1x/host1x_client.h
@@ -19,6 +19,15 @@
 
 struct platform_device;
 
+#ifdef CONFIG_DRM_TEGRA
+int host1x_drm_alloc(struct platform_device *pdev);
+#else
+static inline int host1x_drm_alloc(struct platform_device *pdev)
+{
+	return 0;
+}
+#endif
+
 void host1x_set_drm_data(struct platform_device *pdev, void *data);
 void *host1x_get_drm_data(struct platform_device *pdev);
 
-- 
1.7.9.5

