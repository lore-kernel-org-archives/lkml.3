Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933557Ab3CMMgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 08:36:08 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11477 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933152Ab3CMMf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 08:35:58 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 13 Mar 2013 05:35:50 -0700
From: Terje Bergstrom <tbergstrom@nvidia.com>
To: <airlied@linux.ie>, <thierry.reding@avionic-design.de>,
        <linux-tegra@vger.kernel.org>, <dri-devel@lists.freedesktop.org>
CC: <linux-kernel@vger.kernel.org>, <amerilainen@nvidia.com>,
        Terje Bergstrom <tbergstrom@nvidia.com>
Subject: [PATCHv7 10/10] drm: tegra: Add gr2d device
Date: Wed, 13 Mar 2013 14:36:26 +0200
Message-ID: <1363178186-2017-11-git-send-email-tbergstrom@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363178186-2017-1-git-send-email-tbergstrom@nvidia.com>
References: <1363178186-2017-1-git-send-email-tbergstrom@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add client driver for 2D device, and IOCTLs to pass work to host1x
channel for 2D.

Also adds functions that can be called to access sync points from
DRM.

Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
Signed-off-by: Terje Bergstrom <tbergstrom@nvidia.com>
---
 drivers/gpu/host1x/Makefile   |    1 +
 drivers/gpu/host1x/dev.c      |    7 +
 drivers/gpu/host1x/drm/drm.c  |  251 ++++++++++++++++++++++++++++++-
 drivers/gpu/host1x/drm/drm.h  |   28 +++-
 drivers/gpu/host1x/drm/gr2d.c |  330 +++++++++++++++++++++++++++++++++++++++++
 drivers/gpu/host1x/host1x.h   |    3 +-
 include/drm/tegra_drm.h       |  131 ++++++++++++++++
 7 files changed, 747 insertions(+), 4 deletions(-)
 create mode 100644 drivers/gpu/host1x/drm/gr2d.c
 create mode 100644 include/drm/tegra_drm.h

diff --git a/drivers/gpu/host1x/Makefile b/drivers/gpu/host1x/Makefile
index e85db5a..29c0c6b 100644
--- a/drivers/gpu/host1x/Makefile
+++ b/drivers/gpu/host1x/Makefile
@@ -16,4 +16,5 @@ ccflags-$(CONFIG_DRM_TEGRA_DEBUG) += -DDEBUG
 host1x-$(CONFIG_DRM_TEGRA) += drm/drm.o drm/fb.o drm/dc.o
 host1x-$(CONFIG_DRM_TEGRA) += drm/output.o drm/rgb.o drm/hdmi.o
 host1x-$(CONFIG_DRM_TEGRA) += drm/cma.o
+host1x-$(CONFIG_DRM_TEGRA) += drm/gr2d.o
 obj-$(CONFIG_TEGRA_HOST1X) += host1x.o
diff --git a/drivers/gpu/host1x/dev.c b/drivers/gpu/host1x/dev.c
index 6af8081..0091632 100644
--- a/drivers/gpu/host1x/dev.c
+++ b/drivers/gpu/host1x/dev.c
@@ -211,11 +211,17 @@ static int __init tegra_host1x_init(void)
 	err = platform_driver_register(&tegra_hdmi_driver);
 	if (err < 0)
 		goto unregister_dc;
+
+	err = platform_driver_register(&tegra_gr2d_driver);
+	if (err < 0)
+		goto unregister_hdmi;
 #endif
 
 	return 0;
 
 #ifdef CONFIG_DRM_TEGRA
+unregister_hdmi:
+	platform_driver_unregister(&tegra_hdmi_driver);
 unregister_dc:
 	platform_driver_unregister(&tegra_dc_driver);
 unregister_host1x:
@@ -228,6 +234,7 @@ module_init(tegra_host1x_init);
 static void __exit tegra_host1x_exit(void)
 {
 #ifdef CONFIG_DRM_TEGRA
+	platform_driver_unregister(&tegra_gr2d_driver);
 	platform_driver_unregister(&tegra_hdmi_driver);
 	platform_driver_unregister(&tegra_dc_driver);
 #endif
diff --git a/drivers/gpu/host1x/drm/drm.c b/drivers/gpu/host1x/drm/drm.c
index dbd4808..9f78f52 100644
--- a/drivers/gpu/host1x/drm/drm.c
+++ b/drivers/gpu/host1x/drm/drm.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2012 Avionic Design GmbH
- * Copyright (C) 2012 NVIDIA CORPORATION.  All rights reserved.
+ * Copyright (C) 2012-2013 NVIDIA CORPORATION.  All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -8,13 +8,21 @@
  */
 
 #include <asm/dma-iommu.h>
+#include <drm/drm.h>
+#include <drm/drmP.h>
+#include <drm/drm_gem_cma_helper.h>
+#include <drm/tegra_drm.h>
 #include <linux/module.h>
 #include <linux/of_address.h>
 #include <linux/of_platform.h>
 #include <linux/dma-mapping.h>
 
+#include "cma.h"
+#include "dev.h"
 #include "drm.h"
+#include "host1x_bo.h"
 #include "host1x_client.h"
+#include "syncpt.h"
 
 #define DRIVER_NAME "tegra"
 #define DRIVER_DESC "NVIDIA Tegra graphics"
@@ -77,8 +85,10 @@ static int host1x_parse_dt(struct host1x_drm *host1x)
 	static const char * const compat[] = {
 		"nvidia,tegra20-dc",
 		"nvidia,tegra20-hdmi",
+		"nvidia,tegra20-gr2d",
 		"nvidia,tegra30-dc",
 		"nvidia,tegra30-hdmi",
+		"nvidia,tegra30-gr2d",
 	};
 	unsigned int i;
 	int err;
@@ -273,9 +283,24 @@ static int tegra_drm_unload(struct drm_device *drm)
 
 static int tegra_drm_open(struct drm_device *drm, struct drm_file *filp)
 {
+	struct host1x_drm_file *fpriv;
+
+	fpriv = kzalloc(sizeof(*fpriv), GFP_KERNEL);
+	if (!fpriv)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&fpriv->contexts);
+	filp->driver_priv = fpriv;
+
 	return 0;
 }
 
+static void host1x_drm_context_free(struct host1x_drm_context *context)
+{
+	context->client->ops->close_channel(context);
+	kfree(context);
+}
+
 static void tegra_drm_lastclose(struct drm_device *drm)
 {
 	struct host1x_drm *host1x = drm->dev_private;
@@ -283,7 +308,222 @@ static void tegra_drm_lastclose(struct drm_device *drm)
 	drm_fbdev_cma_restore_mode(host1x->fbdev);
 }
 
+static int tegra_drm_ioctl_syncpt_read(struct drm_device *drm, void *data,
+				       struct drm_file *file_priv)
+{
+	struct tegra_drm_syncpt_read_args *args = data;
+	struct host1x *host = host1x_get_host(drm->dev);
+	struct host1x_syncpt *sp = host1x_syncpt_get(host, args->id);
+
+	if (!sp)
+		return -EINVAL;
+
+	args->value = host1x_syncpt_read_min(sp);
+	return 0;
+}
+
+static int tegra_drm_ioctl_syncpt_incr(struct drm_device *drm, void *data,
+				       struct drm_file *file_priv)
+{
+	struct tegra_drm_syncpt_incr_args *args = data;
+	struct host1x *host = host1x_get_host(drm->dev);
+	struct host1x_syncpt *sp = host1x_syncpt_get(host, args->id);
+
+	if (!sp)
+		return -EINVAL;
+
+	host1x_syncpt_incr(sp);
+	return 0;
+}
+
+static int tegra_drm_ioctl_syncpt_wait(struct drm_device *drm, void *data,
+				       struct drm_file *file_priv)
+{
+	struct tegra_drm_syncpt_wait_args *args = data;
+	struct host1x *host = host1x_get_host(drm->dev);
+	struct host1x_syncpt *sp = host1x_syncpt_get(host, args->id);
+
+	if (!sp)
+		return -EINVAL;
+
+	return host1x_syncpt_wait(sp, args->thresh, args->timeout,
+				  &args->value);
+}
+
+static inline struct host1x_drm_context *tegra_drm_get_context(
+					struct list_head *contexts,
+					struct host1x_drm_context *_ctx)
+{
+	struct host1x_drm_context *ctx;
+
+	list_for_each_entry(ctx, contexts, list)
+		if (ctx == _ctx)
+			return ctx;
+	return NULL;
+}
+
+static int tegra_drm_ioctl_open_channel(struct drm_device *drm, void *data,
+					struct drm_file *file_priv)
+{
+	struct tegra_drm_open_channel_args *args = data;
+	struct host1x_client *client;
+	struct host1x_drm_context *context;
+	struct host1x_drm_file *fpriv = file_priv->driver_priv;
+	struct host1x_drm *host1x = drm->dev_private;
+	int err = -ENODEV;
+
+	context = kzalloc(sizeof(*context), GFP_KERNEL);
+	if (!context)
+		return -ENOMEM;
+
+	list_for_each_entry(client, &host1x->clients, list)
+		if (client->class == args->class) {
+			context->client = client;
+			err = client->ops->open_channel(client, context);
+			if (err)
+				break;
+
+			list_add(&context->list, &fpriv->contexts);
+			args->context = (uintptr_t)context;
+			return 0;
+		}
+
+	kfree(context);
+	return err;
+}
+
+static int tegra_drm_ioctl_close_channel(struct drm_device *drm, void *data,
+					 struct drm_file *file_priv)
+{
+	struct tegra_drm_open_channel_args *args = data;
+	struct host1x_drm_file *fpriv = file_priv->driver_priv;
+	struct host1x_drm_context *context =
+		(struct host1x_drm_context *)(uintptr_t)args->context;
+
+	if (!tegra_drm_get_context(&fpriv->contexts, context))
+		return -EINVAL;
+
+	list_del(&context->list);
+	host1x_drm_context_free(context);
+
+	return 0;
+}
+
+static int tegra_drm_ioctl_get_syncpoint(struct drm_device *drm, void *data,
+					 struct drm_file *file_priv)
+{
+	struct tegra_drm_get_syncpoint *args = data;
+	struct host1x_drm_file *fpriv = file_priv->driver_priv;
+	struct host1x_drm_context *context =
+		(struct host1x_drm_context *)(uintptr_t)args->context;
+
+	if (!tegra_drm_get_context(&fpriv->contexts, context))
+		return -ENODEV;
+
+	if (context->client->num_syncpts < args->param)
+		return -ENODEV;
+
+	args->value = host1x_syncpt_id(context->client->syncpts[args->param]);
+
+	return 0;
+}
+
+static int tegra_drm_ioctl_submit(struct drm_device *drm, void *data,
+				  struct drm_file *file_priv)
+{
+	struct tegra_drm_submit_args *args = data;
+	struct host1x_drm_file *fpriv = file_priv->driver_priv;
+	struct host1x_drm_context *context =
+		(struct host1x_drm_context *)(uintptr_t)args->context;
+
+	if (!tegra_drm_get_context(&fpriv->contexts, context))
+		return -ENODEV;
+
+	return context->client->ops->submit(context, args, drm, file_priv);
+}
+
+static int tegra_drm_gem_create_ioctl(struct drm_device *drm, void *data,
+				      struct drm_file *file_priv)
+{
+	struct tegra_drm_create *args = data;
+	struct drm_gem_cma_object *cma_obj;
+	struct tegra_drm_bo *cma_bo;
+	int ret;
+
+	cma_bo = kzalloc(sizeof(*cma_bo), GFP_KERNEL);
+	if (!cma_bo)
+		return -ENOMEM;
+
+	host1x_bo_init(&cma_bo->base, &tegra_drm_bo_ops);
+
+	cma_obj = &cma_bo->cma_obj;
+	ret = drm_gem_cma_object_init(drm, cma_obj, args->size);
+	if (ret)
+		goto err_cma_create;
+
+	ret = drm_gem_handle_create(file_priv, &cma_obj->base, &args->handle);
+	if (ret)
+		goto err_handle_create;
+
+	drm_gem_object_unreference(&cma_obj->base);
+
+	return 0;
+
+err_handle_create:
+	drm_gem_cma_free_object(&cma_obj->base);
+err_cma_create:
+	kfree(cma_bo);
+	return -ENOMEM;
+}
+
+static int tegra_drm_ioctl_get_offset(struct drm_device *drm, void *data,
+				      struct drm_file *file_priv)
+{
+	struct tegra_drm_get_offset *args = data;
+	struct drm_gem_cma_object *cma_obj;
+	struct drm_gem_object *obj;
+
+	obj = drm_gem_object_lookup(drm, file_priv, args->handle);
+	if (!obj)
+		return -EINVAL;
+	cma_obj = to_drm_gem_cma_obj(obj);
+
+	args->offset = cma_obj->base.map_list.hash.key << PAGE_SHIFT;
+
+	drm_gem_object_unreference(&cma_obj->base);
+
+	return 0;
+}
+
+static void tegra_drm_gem_free_object(struct drm_gem_object *obj)
+{
+	struct drm_gem_cma_object *cma_obj = to_drm_gem_cma_obj(obj);
+	struct tegra_drm_bo *cma_bo =
+		container_of(cma_obj, struct tegra_drm_bo, cma_obj);
+
+	drm_gem_cma_object_deinit(obj);
+	kfree(cma_bo);
+}
+
 static struct drm_ioctl_desc tegra_drm_ioctls[] = {
+	DRM_IOCTL_DEF_DRV(TEGRA_DRM_GEM_CREATE,
+			tegra_drm_gem_create_ioctl, DRM_UNLOCKED | DRM_AUTH),
+	DRM_IOCTL_DEF_DRV(TEGRA_DRM_SYNCPT_READ,
+			tegra_drm_ioctl_syncpt_read, DRM_UNLOCKED),
+	DRM_IOCTL_DEF_DRV(TEGRA_DRM_SYNCPT_INCR,
+			tegra_drm_ioctl_syncpt_incr, DRM_UNLOCKED),
+	DRM_IOCTL_DEF_DRV(TEGRA_DRM_SYNCPT_WAIT,
+			tegra_drm_ioctl_syncpt_wait, DRM_UNLOCKED),
+	DRM_IOCTL_DEF_DRV(TEGRA_DRM_OPEN_CHANNEL,
+			tegra_drm_ioctl_open_channel, DRM_UNLOCKED),
+	DRM_IOCTL_DEF_DRV(TEGRA_DRM_CLOSE_CHANNEL,
+			tegra_drm_ioctl_close_channel, DRM_UNLOCKED),
+	DRM_IOCTL_DEF_DRV(TEGRA_DRM_GET_SYNCPOINT,
+			tegra_drm_ioctl_get_syncpoint, DRM_UNLOCKED),
+	DRM_IOCTL_DEF_DRV(TEGRA_DRM_SUBMIT,
+			tegra_drm_ioctl_submit, DRM_UNLOCKED),
+	DRM_IOCTL_DEF_DRV(TEGRA_DRM_GEM_GET_OFFSET,
+			tegra_drm_ioctl_get_offset, DRM_UNLOCKED),
 };
 
 static const struct file_operations tegra_drm_fops = {
@@ -345,10 +585,17 @@ static void tegra_drm_disable_vblank(struct drm_device *drm, int pipe)
 
 static void tegra_drm_preclose(struct drm_device *drm, struct drm_file *file)
 {
+	struct host1x_drm_file *fpriv = file->driver_priv;
+	struct host1x_drm_context *context, *tmp;
 	struct drm_crtc *crtc;
 
 	list_for_each_entry(crtc, &drm->mode_config.crtc_list, head)
 		tegra_dc_cancel_page_flip(crtc, file);
+
+	list_for_each_entry_safe(context, tmp, &fpriv->contexts, list)
+		host1x_drm_context_free(context);
+	kfree(fpriv);
+
 }
 
 #ifdef CONFIG_DEBUG_FS
@@ -407,7 +654,7 @@ struct drm_driver tegra_drm_driver = {
 	.debugfs_cleanup = tegra_debugfs_cleanup,
 #endif
 
-	.gem_free_object = drm_gem_cma_free_object,
+	.gem_free_object = tegra_drm_gem_free_object,
 	.gem_vm_ops = &drm_gem_cma_vm_ops,
 	.dumb_create = drm_gem_cma_dumb_create,
 	.dumb_map_offset = drm_gem_cma_dumb_map_offset,
diff --git a/drivers/gpu/host1x/drm/drm.h b/drivers/gpu/host1x/drm/drm.h
index 0b8738f..6a8d7e3 100644
--- a/drivers/gpu/host1x/drm/drm.h
+++ b/drivers/gpu/host1x/drm/drm.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2012 Avionic Design GmbH
- * Copyright (C) 2012 NVIDIA CORPORATION.  All rights reserved.
+ * Copyright (C) 2012-2013 NVIDIA CORPORATION.  All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -17,6 +17,9 @@
 #include <drm/drm_gem_cma_helper.h>
 #include <drm/drm_fb_cma_helper.h>
 #include <drm/drm_fixed.h>
+#include <drm/tegra_drm.h>
+
+#include "host1x.h"
 
 struct host1x_drm {
 	struct drm_device *drm;
@@ -38,9 +41,26 @@ struct host1x_drm {
 
 struct host1x_client;
 
+struct host1x_drm_context {
+	struct host1x_client *client;
+	struct host1x_channel *channel;
+	struct list_head list;
+};
+
 struct host1x_client_ops {
 	int (*drm_init)(struct host1x_client *client, struct drm_device *drm);
 	int (*drm_exit)(struct host1x_client *client);
+	int (*open_channel)(struct host1x_client *client,
+			struct host1x_drm_context *context);
+	void (*close_channel)(struct host1x_drm_context *context);
+	int (*submit)(struct host1x_drm_context *context,
+			struct tegra_drm_submit_args *args,
+			struct drm_device *drm,
+			struct drm_file *file_priv);
+};
+
+struct host1x_drm_file {
+	struct list_head contexts;
 };
 
 struct host1x_client {
@@ -49,6 +69,12 @@ struct host1x_client {
 
 	const struct host1x_client_ops *ops;
 
+	enum host1x_class class;
+	struct host1x_channel *channel;
+
+	struct host1x_syncpt **syncpts;
+	unsigned int num_syncpts;
+
 	struct list_head list;
 };
 
diff --git a/drivers/gpu/host1x/drm/gr2d.c b/drivers/gpu/host1x/drm/gr2d.c
new file mode 100644
index 0000000..f060069
--- /dev/null
+++ b/drivers/gpu/host1x/drm/gr2d.c
@@ -0,0 +1,330 @@
+/*
+ * drivers/video/tegra/host/gr2d/gr2d.c
+ *
+ * Tegra Graphics 2D
+ *
+ * Copyright (c) 2012-2013, NVIDIA Corporation.
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
+#include <linux/export.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/clk.h>
+#include <drm/tegra_drm.h>
+
+#include "channel.h"
+#include "drm.h"
+#include "drm/cma.h"
+#include "job.h"
+#include "host1x.h"
+#include "host1x_bo.h"
+#include "host1x_client.h"
+#include "syncpt.h"
+
+struct gr2d {
+	struct host1x_client client;
+	struct clk *clk;
+	struct host1x_channel *channel;
+	unsigned long *addr_regs;
+};
+
+static int gr2d_is_addr_reg(struct device *dev, u32 class, u32 reg);
+
+static int gr2d_client_init(struct host1x_client *client,
+			    struct drm_device *drm)
+{
+	return 0;
+}
+
+static int gr2d_client_exit(struct host1x_client *client)
+{
+	return 0;
+}
+
+static int gr2d_open_channel(struct host1x_client *client,
+			     struct host1x_drm_context *context)
+{
+	struct gr2d *gr2d = dev_get_drvdata(client->dev);
+	context->channel = host1x_channel_get(gr2d->channel);
+
+	if (!context->channel)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void gr2d_close_channel(struct host1x_drm_context *context)
+{
+	host1x_channel_put(context->channel);
+}
+
+static struct host1x_bo *handle_cma_to_host1x(struct drm_device *drm,
+					      struct drm_file *file_priv,
+					      u32 gem_handle)
+{
+	struct drm_gem_object *gem_obj;
+	struct drm_gem_cma_object *cma_obj;
+	struct tegra_drm_bo *cma_bo;
+
+	gem_obj = drm_gem_object_lookup(drm, file_priv, gem_handle);
+	if (!gem_obj)
+		return 0;
+
+	mutex_lock(&drm->struct_mutex);
+	drm_gem_object_unreference(gem_obj);
+	mutex_unlock(&drm->struct_mutex);
+
+	cma_obj = to_drm_gem_cma_obj(gem_obj);
+	cma_bo = container_of(cma_obj, struct tegra_drm_bo, cma_obj);
+
+	return &cma_bo->base;
+}
+
+static int gr2d_submit(struct host1x_drm_context *context,
+		       struct tegra_drm_submit_args *args,
+		       struct drm_device *drm,
+		       struct drm_file *file_priv)
+{
+	struct host1x_job *job;
+	int num_cmdbufs = args->num_cmdbufs;
+	int num_relocs = args->num_relocs;
+	int num_waitchks = args->num_waitchks;
+	struct tegra_drm_cmdbuf __user *cmdbufs =
+		(void * __user)(uintptr_t)args->cmdbufs;
+	struct tegra_drm_reloc __user *relocs =
+		(void * __user)(uintptr_t)args->relocs;
+	struct tegra_drm_waitchk __user *waitchks =
+		(void * __user)(uintptr_t)args->waitchks;
+	struct tegra_drm_syncpt_incr syncpt_incr;
+	int err;
+
+	/* We don't yet support other than one syncpt_incr struct per submit */
+	if (args->num_syncpt_incrs != 1)
+		return -EINVAL;
+
+	job = host1x_job_alloc(context->channel, args->num_cmdbufs,
+			       args->num_relocs, args->num_waitchks);
+	if (!job)
+		return -ENOMEM;
+
+	job->num_relocs = args->num_relocs;
+	job->num_waitchk = args->num_waitchks;
+	job->client = (u32)args->context;
+	job->class = context->client->class;
+	job->serialize = true;
+
+	while (num_cmdbufs) {
+		struct tegra_drm_cmdbuf cmdbuf;
+		struct host1x_bo *mem_handle;
+		err = copy_from_user(&cmdbuf, cmdbufs, sizeof(cmdbuf));
+		if (err)
+			goto fail;
+
+		mem_handle = handle_cma_to_host1x(drm, file_priv, cmdbuf.mem);
+		if (!mem_handle)
+			goto fail;
+
+		host1x_job_add_gather(job, mem_handle,
+				      cmdbuf.words, cmdbuf.offset);
+		num_cmdbufs--;
+		cmdbufs++;
+	}
+
+	err = copy_from_user(job->relocarray, relocs,
+			     sizeof(*relocs) * num_relocs);
+	if (err)
+		goto fail;
+
+	while (num_relocs--) {
+		job->relocarray[num_relocs].cmdbuf_mem =
+			handle_cma_to_host1x(drm, file_priv,
+			(u32)job->relocarray[num_relocs].cmdbuf_mem);
+		job->relocarray[num_relocs].target =
+			handle_cma_to_host1x(drm, file_priv,
+			(u32)job->relocarray[num_relocs].target);
+
+		if (!job->relocarray[num_relocs].target ||
+		    !job->relocarray[num_relocs].cmdbuf_mem)
+			goto fail;
+	}
+
+	err = copy_from_user(job->waitchk, waitchks,
+			     sizeof(*waitchks) * num_waitchks);
+	if (err)
+		goto fail;
+
+	err = host1x_job_pin(job, context->client->dev);
+	if (err)
+		goto fail;
+
+	err = copy_from_user(&syncpt_incr,
+			     (void * __user)(uintptr_t)args->syncpt_incrs,
+			     sizeof(syncpt_incr));
+	if (err)
+		goto fail;
+
+	job->syncpt_id = syncpt_incr.id;
+	job->syncpt_incrs = syncpt_incr.incrs;
+	job->timeout = 10000;
+	job->is_addr_reg = gr2d_is_addr_reg;
+	if (args->timeout && args->timeout < 10000)
+		job->timeout = args->timeout;
+
+	err = host1x_job_submit(job);
+	if (err)
+		goto fail_submit;
+
+	args->fence = job->syncpt_end;
+
+	host1x_job_put(job);
+	return 0;
+
+fail_submit:
+	host1x_job_unpin(job);
+fail:
+	host1x_job_put(job);
+	return err;
+}
+
+static struct host1x_client_ops gr2d_client_ops = {
+	.drm_init = gr2d_client_init,
+	.drm_exit = gr2d_client_exit,
+	.open_channel = gr2d_open_channel,
+	.close_channel = gr2d_close_channel,
+	.submit = gr2d_submit,
+};
+
+static void gr2d_init_addr_reg_map(struct device *dev, struct gr2d *gr2d)
+{
+	const u32 gr2d_addr_regs[] = {0x1a, 0x1b, 0x26, 0x2b, 0x2c, 0x2d, 0x31,
+				      0x32, 0x48, 0x49, 0x4a, 0x4b, 0x4c};
+	unsigned long *bitmap;
+	int i;
+
+	bitmap = devm_kzalloc(dev, DIV_ROUND_UP(256, BITS_PER_BYTE),
+			      GFP_KERNEL);
+
+	for (i = 0; i < ARRAY_SIZE(gr2d_addr_regs); ++i) {
+		u32 reg = gr2d_addr_regs[i];
+		bitmap[BIT_WORD(reg)] |= BIT_MASK(reg);
+	}
+
+	gr2d->addr_regs = bitmap;
+}
+
+static int gr2d_is_addr_reg(struct device *dev, u32 class, u32 reg)
+{
+	struct gr2d *gr2d = dev_get_drvdata(dev);
+
+	switch (class) {
+	case HOST1X_CLASS_HOST1X:
+		return reg == 0x2b;
+	case HOST1X_CLASS_GR2D:
+		reg &= 0xff;
+		if (gr2d->addr_regs[BIT_WORD(reg)] & BIT_MASK(reg))
+			return 1;
+	default:
+		return 0;
+	}
+}
+
+static const struct of_device_id gr2d_match[] = {
+	{ .compatible = "nvidia,tegra30-gr2d" },
+	{ .compatible = "nvidia,tegra20-gr2d" },
+	{ },
+};
+
+static int gr2d_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct host1x_drm *host1x = host1x_get_drm_data(dev->parent);
+	int err;
+	struct gr2d *gr2d = NULL;
+	struct host1x_syncpt **syncpts;
+
+	gr2d = devm_kzalloc(dev, sizeof(*gr2d), GFP_KERNEL);
+	if (!gr2d)
+		return -ENOMEM;
+
+	syncpts = devm_kzalloc(dev, sizeof(*syncpts), GFP_KERNEL);
+	if (!syncpts)
+		return -ENOMEM;
+
+	gr2d->clk = devm_clk_get(dev, NULL);
+	if (IS_ERR(gr2d->clk)) {
+		dev_err(dev, "cannot get clock\n");
+		return PTR_ERR(gr2d->clk);
+	}
+
+	err = clk_prepare_enable(gr2d->clk);
+	if (err) {
+		dev_err(dev, "cannot turn on clock\n");
+		return err;
+	}
+
+	gr2d->channel = host1x_channel_alloc(dev);
+	if (!gr2d->channel)
+		return -ENOMEM;
+
+	*syncpts = host1x_syncpt_request(dev, 0);
+	if (!(*syncpts)) {
+		host1x_channel_free(gr2d->channel);
+		return -ENOMEM;
+	}
+
+	gr2d->client.ops = &gr2d_client_ops;
+	gr2d->client.dev = dev;
+	gr2d->client.class = HOST1X_CLASS_GR2D;
+	gr2d->client.syncpts = syncpts;
+	gr2d->client.num_syncpts = 1;
+
+	err = host1x_register_client(host1x, &gr2d->client);
+	if (err < 0) {
+		dev_err(dev, "failed to register host1x client: %d\n", err);
+		return err;
+	}
+
+	gr2d_init_addr_reg_map(dev, gr2d);
+
+	dev_set_drvdata(dev, gr2d);
+
+	return 0;
+}
+
+static int __exit gr2d_remove(struct platform_device *pdev)
+{
+	struct host1x_drm *host1x = host1x_get_drm_data(pdev->dev.parent);
+	struct gr2d *gr2d = platform_get_drvdata(pdev);
+	int err;
+
+	err = host1x_unregister_client(host1x, &gr2d->client);
+	if (err < 0) {
+		dev_err(&pdev->dev, "failed to unregister client: %d\n", err);
+		return err;
+	}
+
+	host1x_syncpt_free(*gr2d->client.syncpts);
+	return 0;
+}
+
+struct platform_driver tegra_gr2d_driver = {
+	.probe = gr2d_probe,
+	.remove = __exit_p(gr2d_remove),
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = "gr2d",
+		.of_match_table = gr2d_match,
+	}
+};
diff --git a/drivers/gpu/host1x/host1x.h b/drivers/gpu/host1x/host1x.h
index bca6563..128cc9e 100644
--- a/drivers/gpu/host1x/host1x.h
+++ b/drivers/gpu/host1x/host1x.h
@@ -22,7 +22,8 @@
 #define __LINUX_HOST1X_H
 
 enum host1x_class {
-	HOST1X_CLASS_HOST1X	= 0x1
+	HOST1X_CLASS_HOST1X	= 0x1,
+	HOST1X_CLASS_GR2D	= 0x51
 };
 
 #endif
diff --git a/include/drm/tegra_drm.h b/include/drm/tegra_drm.h
new file mode 100644
index 0000000..6f7f7e6
--- /dev/null
+++ b/include/drm/tegra_drm.h
@@ -0,0 +1,131 @@
+/*
+ * Copyright (c) 2012-2013, NVIDIA CORPORATION.  All rights reserved.
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
+#ifndef _TEGRA_DRM_H_
+#define _TEGRA_DRM_H_
+
+struct tegra_drm_create {
+	__u64 size;
+	u32 flags;
+	u32 handle;
+	u32 offset;
+	u32 padding;
+};
+
+struct tegra_drm_get_offset {
+	__u32 handle;
+	__u32 offset;
+};
+
+struct tegra_drm_syncpt_read_args {
+	__u32 id;
+	__u32 value;
+};
+
+struct tegra_drm_syncpt_incr_args {
+	__u32 id;
+	__u32 pad;
+};
+
+struct tegra_drm_syncpt_wait_args {
+	__u32 id;
+	__u32 thresh;
+	__u32 timeout;
+	__u32 value;
+};
+
+#define DRM_TEGRA_NO_TIMEOUT	(0xffffffff)
+
+struct tegra_drm_open_channel_args {
+	__u32 class;
+	__u32 pad;
+	__u64 context;
+};
+
+struct tegra_drm_get_syncpoint {
+	__u64 context;
+	__u32 param;
+	__u32 value;
+};
+
+struct tegra_drm_syncpt_incr {
+	__u32 id;
+	__u32 incrs;
+};
+
+struct tegra_drm_cmdbuf {
+	__u32 mem;
+	__u32 offset;
+	__u32 words;
+	__u32 pad;
+};
+
+struct tegra_drm_reloc {
+	__u32 cmdbuf_mem;
+	__u32 cmdbuf_offset;
+	__u32 target;
+	__u32 target_offset;
+	__u32 shift;
+	__u32 pad;
+};
+
+struct tegra_drm_waitchk {
+	__u32 mem;
+	__u32 offset;
+	__u32 syncpt_id;
+	__u32 thresh;
+};
+
+struct tegra_drm_submit_args {
+	__u64 context;
+	__u32 num_syncpt_incrs;
+	__u32 num_cmdbufs;
+	__u32 num_relocs;
+	__u32 submit_version;
+	__u32 num_waitchks;
+	__u32 waitchk_mask;
+	__u32 timeout;
+	__u32 pad;
+	__u64 syncpt_incrs;
+	__u64 cmdbufs;
+	__u64 relocs;
+	__u64 waitchks;
+	__u32 fence;		/* Return value */
+
+	__u32 reserved[5];	/* future expansion */
+};
+
+#define DRM_TEGRA_DRM_GEM_CREATE	0x00
+#define DRM_TEGRA_DRM_SYNCPT_READ	0x01
+#define DRM_TEGRA_DRM_SYNCPT_INCR	0x02
+#define DRM_TEGRA_DRM_SYNCPT_WAIT	0x03
+#define DRM_TEGRA_DRM_OPEN_CHANNEL	0x04
+#define DRM_TEGRA_DRM_CLOSE_CHANNEL	0x05
+#define DRM_TEGRA_DRM_GET_SYNCPOINT	0x06
+#define DRM_TEGRA_DRM_SUBMIT		0x08
+#define DRM_TEGRA_DRM_GEM_GET_OFFSET	0x09
+
+#define DRM_IOCTL_TEGRA_DRM_GEM_CREATE DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_DRM_GEM_CREATE, struct tegra_drm_create)
+#define DRM_IOCTL_TEGRA_DRM_SYNCPT_READ DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_DRM_SYNCPT_READ, struct tegra_drm_syncpt_read_args)
+#define DRM_IOCTL_TEGRA_DRM_SYNCPT_INCR DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_DRM_SYNCPT_INCR, struct tegra_drm_syncpt_incr_args)
+#define DRM_IOCTL_TEGRA_DRM_SYNCPT_WAIT DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_DRM_SYNCPT_WAIT, struct tegra_drm_syncpt_wait_args)
+#define DRM_IOCTL_TEGRA_DRM_OPEN_CHANNEL DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_DRM_OPEN_CHANNEL, struct tegra_drm_open_channel_args)
+#define DRM_IOCTL_TEGRA_DRM_CLOSE_CHANNEL DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_DRM_CLOSE_CHANNEL, struct tegra_drm_open_channel_args)
+#define DRM_IOCTL_TEGRA_DRM_GET_SYNCPOINT DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_DRM_GET_SYNCPOINT, struct tegra_drm_get_syncpoint)
+#define DRM_IOCTL_TEGRA_DRM_SUBMIT DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_DRM_SUBMIT, struct tegra_drm_submit_args)
+#define DRM_IOCTL_TEGRA_DRM_GEM_GET_OFFSET DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_DRM_GEM_GET_OFFSET, struct tegra_drm_get_offset)
+
+#endif
-- 
1.7.9.5

