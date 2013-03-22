Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933412Ab3CVIcP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 04:32:15 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19356 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab3CVIau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 04:30:50 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 22 Mar 2013 01:30:41 -0700
From: Terje Bergstrom <tbergstrom@nvidia.com>
To: <airlied@linux.ie>, <thierry.reding@avionic-design.de>,
        <linux-tegra@vger.kernel.org>, <dri-devel@lists.freedesktop.org>
CC: <linux-kernel@vger.kernel.org>, <amerilainen@nvidia.com>,
        Terje Bergstrom <tbergstrom@nvidia.com>
Subject: [PATCHv8 9/9] drm: tegra: Add gr2d device
Date: Fri, 22 Mar 2013 10:30:06 +0200
Message-ID: <1363941006-14204-10-git-send-email-tbergstrom@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363941006-14204-1-git-send-email-tbergstrom@nvidia.com>
References: <1363941006-14204-1-git-send-email-tbergstrom@nvidia.com>
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
 drivers/gpu/host1x/Makefile    |    1 +
 drivers/gpu/host1x/dev.c       |    7 +
 drivers/gpu/host1x/drm/Kconfig |    9 ++
 drivers/gpu/host1x/drm/drm.c   |  213 ++++++++++++++++++++++++-
 drivers/gpu/host1x/drm/drm.h   |   27 +++-
 drivers/gpu/host1x/drm/gr2d.c  |  340 ++++++++++++++++++++++++++++++++++++++++
 drivers/gpu/host1x/host1x.h    |    4 +-
 include/uapi/drm/tegra_drm.h   |  136 ++++++++++++++++
 8 files changed, 734 insertions(+), 3 deletions(-)
 create mode 100644 drivers/gpu/host1x/drm/gr2d.c
 create mode 100644 include/uapi/drm/tegra_drm.h

diff --git a/drivers/gpu/host1x/Makefile b/drivers/gpu/host1x/Makefile
index 3768dbc..3b037b6 100644
--- a/drivers/gpu/host1x/Makefile
+++ b/drivers/gpu/host1x/Makefile
@@ -16,4 +16,5 @@ ccflags-$(CONFIG_DRM_TEGRA_DEBUG) += -DDEBUG
 host1x-$(CONFIG_DRM_TEGRA) += drm/drm.o drm/fb.o drm/dc.o
 host1x-$(CONFIG_DRM_TEGRA) += drm/output.o drm/rgb.o drm/hdmi.o
 host1x-$(CONFIG_DRM_TEGRA) += drm/gem.o
+host1x-$(CONFIG_DRM_TEGRA) += drm/gr2d.o
 obj-$(CONFIG_TEGRA_HOST1X) += host1x.o
diff --git a/drivers/gpu/host1x/dev.c b/drivers/gpu/host1x/dev.c
index 8ce9889..28e28a2 100644
--- a/drivers/gpu/host1x/dev.c
+++ b/drivers/gpu/host1x/dev.c
@@ -209,11 +209,17 @@ static int __init tegra_host1x_init(void)
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
@@ -226,6 +232,7 @@ module_init(tegra_host1x_init);
 static void __exit tegra_host1x_exit(void)
 {
 #ifdef CONFIG_DRM_TEGRA
+	platform_driver_unregister(&tegra_gr2d_driver);
 	platform_driver_unregister(&tegra_hdmi_driver);
 	platform_driver_unregister(&tegra_dc_driver);
 #endif
diff --git a/drivers/gpu/host1x/drm/Kconfig b/drivers/gpu/host1x/drm/Kconfig
index f743540..6e3f567 100644
--- a/drivers/gpu/host1x/drm/Kconfig
+++ b/drivers/gpu/host1x/drm/Kconfig
@@ -13,6 +13,15 @@ config DRM_TEGRA
 
 if DRM_TEGRA
 
+config DRM_TEGRA_STAGING
+	bool "Enable HOST1X interface"
+	depends on STAGING
+	default n
+	help
+	  Say yes if HOST1X should be available for userspace DRM users.
+
+	  If unsure, choose N.
+
 config DRM_TEGRA_DEBUG
 	bool "NVIDIA Tegra DRM debug support"
 	help
diff --git a/drivers/gpu/host1x/drm/drm.c b/drivers/gpu/host1x/drm/drm.c
index c4e45c1..6db1bd6 100644
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
@@ -14,6 +14,11 @@
 #include <linux/dma-mapping.h>
 #include <asm/dma-iommu.h>
 
+#include <drm/drm.h>
+#include <drm/drmP.h>
+
+#include <uapi/drm/tegra_drm.h>
+
 #include "host1x_client.h"
 #include "dev.h"
 #include "drm.h"
@@ -81,8 +86,10 @@ static int host1x_parse_dt(struct host1x_drm *host1x)
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
@@ -277,9 +284,24 @@ static int tegra_drm_unload(struct drm_device *drm)
 
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
@@ -287,7 +309,189 @@ static void tegra_drm_lastclose(struct drm_device *drm)
 	tegra_fbdev_restore_mode(host1x->fbdev);
 }
 
+#ifdef CONFIG_DRM_TEGRA_STAGING
+static int tegra_drm_ioctl_syncpt_read(struct drm_device *drm, void *data,
+				       struct drm_file *file)
+{
+	struct drm_tegra_syncpt_read *args = data;
+	struct host1x *host = dev_get_drvdata(drm->dev);
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
+				       struct drm_file *file)
+{
+	struct drm_tegra_syncpt_incr *args = data;
+	struct host1x *host = dev_get_drvdata(drm->dev);
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
+				       struct drm_file *file)
+{
+	struct drm_tegra_syncpt_wait *args = data;
+	struct host1x *host = dev_get_drvdata(drm->dev);
+	struct host1x_syncpt *sp = host1x_syncpt_get(host, args->id);
+
+	if (!sp)
+		return -EINVAL;
+
+	return host1x_syncpt_wait(sp, args->thresh, args->timeout,
+				  &args->value);
+}
+
+static bool host1x_drm_file_owns_context(struct host1x_drm_file *file,
+					 struct host1x_drm_context *context)
+{
+	struct host1x_drm_context *ctx;
+
+	list_for_each_entry(ctx, &file->contexts, list)
+		if (ctx == context)
+			return true;
+
+	return false;
+}
+
+static int tegra_drm_ioctl_open_channel(struct drm_device *drm, void *data,
+					struct drm_file *file)
+{
+	struct drm_tegra_open_channel *args = data;
+	struct host1x_client *client;
+	struct host1x_drm_context *context;
+	struct host1x_drm_file *fpriv = file->driver_priv;
+	struct host1x_drm *host1x = drm->dev_private;
+	int err = -ENODEV;
+
+	context = kzalloc(sizeof(*context), GFP_KERNEL);
+	if (!context)
+		return -ENOMEM;
+
+	list_for_each_entry(client, &host1x->clients, list)
+		if (client->class == args->client) {
+			err = client->ops->open_channel(client, context);
+			if (err)
+				break;
+
+			context->client = client;
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
+					 struct drm_file *file)
+{
+	struct drm_tegra_close_channel *args = data;
+	struct host1x_drm_file *fpriv = file->driver_priv;
+	struct host1x_drm_context *context =
+		(struct host1x_drm_context *)(uintptr_t)args->context;
+
+	if (!host1x_drm_file_owns_context(fpriv, context))
+		return -EINVAL;
+
+	list_del(&context->list);
+	host1x_drm_context_free(context);
+
+	return 0;
+}
+
+static int tegra_drm_ioctl_get_syncpt(struct drm_device *drm, void *data,
+				      struct drm_file *file)
+{
+	struct drm_tegra_get_syncpt *args = data;
+	struct host1x_drm_file *fpriv = file->driver_priv;
+	struct host1x_drm_context *context =
+		(struct host1x_drm_context *)(uintptr_t)args->context;
+	struct host1x_syncpt *syncpt;
+
+	if (!host1x_drm_file_owns_context(fpriv, context))
+		return -ENODEV;
+
+	if (args->index >= context->client->num_syncpts)
+		return -EINVAL;
+
+	syncpt = context->client->syncpts[args->index];
+	args->id = host1x_syncpt_id(syncpt);
+
+	return 0;
+}
+
+static int tegra_drm_ioctl_submit(struct drm_device *drm, void *data,
+				  struct drm_file *file)
+{
+	struct drm_tegra_submit *args = data;
+	struct host1x_drm_file *fpriv = file->driver_priv;
+	struct host1x_drm_context *context =
+		(struct host1x_drm_context *)(uintptr_t)args->context;
+
+	if (!host1x_drm_file_owns_context(fpriv, context))
+		return -ENODEV;
+
+	return context->client->ops->submit(context, args, drm, file);
+}
+
+static int tegra_drm_ioctl_gem_create(struct drm_device *drm, void *data,
+				      struct drm_file *file)
+{
+	struct drm_tegra_gem_create *args = data;
+	struct tegra_bo *bo;
+
+	bo = tegra_bo_create_with_handle(file, drm, args->size, &args->handle);
+	if (IS_ERR(bo))
+		return PTR_ERR(bo);
+
+	return 0;
+}
+
+static int tegra_drm_ioctl_gem_mmap(struct drm_device *drm, void *data,
+				    struct drm_file *file)
+{
+	struct drm_tegra_gem_mmap *args = data;
+	struct drm_gem_object *gem;
+	struct tegra_bo *bo;
+
+	gem = drm_gem_object_lookup(drm, file, args->handle);
+	if (!gem)
+		return -EINVAL;
+
+	bo = to_tegra_bo(gem);
+
+	args->offset = tegra_bo_get_mmap_offset(bo);
+
+	drm_gem_object_unreference(gem);
+
+	return 0;
+}
+#endif
+
 static struct drm_ioctl_desc tegra_drm_ioctls[] = {
+#ifdef CONFIG_DRM_TEGRA_STAGING
+	DRM_IOCTL_DEF_DRV(TEGRA_GEM_CREATE, tegra_drm_ioctl_gem_create, DRM_UNLOCKED | DRM_AUTH),
+	DRM_IOCTL_DEF_DRV(TEGRA_GEM_MMAP, tegra_drm_ioctl_gem_mmap, DRM_UNLOCKED),
+	DRM_IOCTL_DEF_DRV(TEGRA_SYNCPT_READ, tegra_drm_ioctl_syncpt_read, DRM_UNLOCKED),
+	DRM_IOCTL_DEF_DRV(TEGRA_SYNCPT_INCR, tegra_drm_ioctl_syncpt_incr, DRM_UNLOCKED),
+	DRM_IOCTL_DEF_DRV(TEGRA_SYNCPT_WAIT, tegra_drm_ioctl_syncpt_wait, DRM_UNLOCKED),
+	DRM_IOCTL_DEF_DRV(TEGRA_OPEN_CHANNEL, tegra_drm_ioctl_open_channel, DRM_UNLOCKED),
+	DRM_IOCTL_DEF_DRV(TEGRA_CLOSE_CHANNEL, tegra_drm_ioctl_close_channel, DRM_UNLOCKED),
+	DRM_IOCTL_DEF_DRV(TEGRA_GET_SYNCPT, tegra_drm_ioctl_get_syncpt, DRM_UNLOCKED),
+	DRM_IOCTL_DEF_DRV(TEGRA_SUBMIT, tegra_drm_ioctl_submit, DRM_UNLOCKED),
+#endif
 };
 
 static const struct file_operations tegra_drm_fops = {
@@ -349,10 +553,17 @@ static void tegra_drm_disable_vblank(struct drm_device *drm, int pipe)
 
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
+
+	kfree(fpriv);
 }
 
 #ifdef CONFIG_DEBUG_FS
diff --git a/drivers/gpu/host1x/drm/drm.h b/drivers/gpu/host1x/drm/drm.h
index 3864a39..02ce020 100644
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
@@ -15,6 +15,9 @@
 #include <drm/drm_edid.h>
 #include <drm/drm_fb_helper.h>
 #include <drm/drm_fixed.h>
+#include <uapi/drm/tegra_drm.h>
+
+#include "host1x.h"
 
 struct tegra_fb {
 	struct drm_framebuffer base;
@@ -47,9 +50,25 @@ struct host1x_drm {
 
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
+			    struct host1x_drm_context *context);
+	void (*close_channel)(struct host1x_drm_context *context);
+	int (*submit)(struct host1x_drm_context *context,
+		      struct drm_tegra_submit *args, struct drm_device *drm,
+		      struct drm_file *file);
+};
+
+struct host1x_drm_file {
+	struct list_head contexts;
 };
 
 struct host1x_client {
@@ -58,6 +77,12 @@ struct host1x_client {
 
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
index 0000000..9d5fe79
--- /dev/null
+++ b/drivers/gpu/host1x/drm/gr2d.c
@@ -0,0 +1,340 @@
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
+#include <uapi/drm/tegra_drm.h>
+
+#include "channel.h"
+#include "drm.h"
+#include "gem.h"
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
+static inline struct gr2d *to_gr2d(struct host1x_client *client)
+{
+	return container_of(client, struct gr2d, client);
+}
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
+	struct gr2d *gr2d = to_gr2d(client);
+
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
+static struct host1x_bo *host1x_bo_lookup(struct drm_device *drm,
+					  struct drm_file *file,
+					  u32 handle)
+{
+	struct drm_gem_object *gem;
+	struct tegra_bo *bo;
+
+	gem = drm_gem_object_lookup(drm, file, handle);
+	if (!gem)
+		return 0;
+
+	mutex_lock(&drm->struct_mutex);
+	drm_gem_object_unreference(gem);
+	mutex_unlock(&drm->struct_mutex);
+
+	bo = to_tegra_bo(gem);
+	return &bo->base;
+}
+
+static int gr2d_submit(struct host1x_drm_context *context,
+		       struct drm_tegra_submit *args, struct drm_device *drm,
+		       struct drm_file *file)
+{
+	struct host1x_job *job;
+	unsigned int num_cmdbufs = args->num_cmdbufs;
+	unsigned int num_relocs = args->num_relocs;
+	unsigned int num_waitchks = args->num_waitchks;
+	struct drm_tegra_cmdbuf __user *cmdbufs =
+		(void * __user)(uintptr_t)args->cmdbufs;
+	struct drm_tegra_reloc __user *relocs =
+		(void * __user)(uintptr_t)args->relocs;
+	struct drm_tegra_waitchk __user *waitchks =
+		(void * __user)(uintptr_t)args->waitchks;
+	struct drm_tegra_syncpt syncpt;
+	int err;
+
+	/* We don't yet support other than one syncpt_incr struct per submit */
+	if (args->num_syncpts != 1)
+		return -EINVAL;
+
+	job = host1x_job_alloc(context->channel, args->num_cmdbufs,
+				args->num_relocs, args->num_waitchks);
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
+		struct drm_tegra_cmdbuf cmdbuf;
+		struct host1x_bo *bo;
+
+		err = copy_from_user(&cmdbuf, cmdbufs, sizeof(cmdbuf));
+		if (err)
+			goto fail;
+
+		bo = host1x_bo_lookup(drm, file, cmdbuf.handle);
+		if (!bo)
+			goto fail;
+
+		host1x_job_add_gather(job, bo, cmdbuf.words, cmdbuf.offset);
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
+		struct host1x_reloc *reloc = &job->relocarray[num_relocs];
+		struct host1x_bo *cmdbuf, *target;
+
+		cmdbuf = host1x_bo_lookup(drm, file, (u32)reloc->cmdbuf);
+		target = host1x_bo_lookup(drm, file, (u32)reloc->target);
+
+		reloc->cmdbuf = cmdbuf;
+		reloc->target = target;
+
+		if (!reloc->target || !reloc->cmdbuf)
+			goto fail;
+	}
+
+	err = copy_from_user(job->waitchk, waitchks,
+			     sizeof(*waitchks) * num_waitchks);
+	if (err)
+		goto fail;
+
+	err = copy_from_user(&syncpt, (void * __user)(uintptr_t)args->syncpts,
+			     sizeof(syncpt));
+	if (err)
+		goto fail;
+
+	job->syncpt_id = syncpt.id;
+	job->syncpt_incrs = syncpt.incrs;
+	job->timeout = 10000;
+	job->is_addr_reg = gr2d_is_addr_reg;
+
+	if (args->timeout && args->timeout < 10000)
+		job->timeout = args->timeout;
+
+	err = host1x_job_pin(job, context->client->dev);
+	if (err)
+		goto fail;
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
+	case HOST1X_CLASS_GR2D_SB:
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
+	gr2d->channel = host1x_channel_request(dev);
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
+	platform_set_drvdata(pdev, gr2d);
+
+	return 0;
+}
+
+static int __exit gr2d_remove(struct platform_device *pdev)
+{
+	struct host1x_drm *host1x = host1x_get_drm_data(pdev->dev.parent);
+	struct gr2d *gr2d = platform_get_drvdata(pdev);
+	unsigned int i;
+	int err;
+
+	err = host1x_unregister_client(host1x, &gr2d->client);
+	if (err < 0) {
+		dev_err(&pdev->dev, "failed to unregister client: %d\n", err);
+		return err;
+	}
+
+	for (i = 0; i < gr2d->client.num_syncpts; i++)
+		host1x_syncpt_free(gr2d->client.syncpts[i]);
+
+	host1x_channel_free(gr2d->channel);
+	clk_disable_unprepare(gr2d->clk);
+
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
index bca6563..a2bc1e6 100644
--- a/drivers/gpu/host1x/host1x.h
+++ b/drivers/gpu/host1x/host1x.h
@@ -22,7 +22,9 @@
 #define __LINUX_HOST1X_H
 
 enum host1x_class {
-	HOST1X_CLASS_HOST1X	= 0x1
+	HOST1X_CLASS_HOST1X	= 0x1,
+	HOST1X_CLASS_GR2D	= 0x51,
+	HOST1X_CLASS_GR2D_SB    = 0x52
 };
 
 #endif
diff --git a/include/uapi/drm/tegra_drm.h b/include/uapi/drm/tegra_drm.h
new file mode 100644
index 0000000..6e132a2
--- /dev/null
+++ b/include/uapi/drm/tegra_drm.h
@@ -0,0 +1,136 @@
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
+#ifndef _UAPI_TEGRA_DRM_H_
+#define _UAPI_TEGRA_DRM_H_
+
+struct drm_tegra_gem_create {
+	__u64 size;
+	__u32 flags;
+	__u32 handle;
+};
+
+struct drm_tegra_gem_mmap {
+	__u32 handle;
+	__u32 offset;
+};
+
+struct drm_tegra_syncpt_read {
+	__u32 id;
+	__u32 value;
+};
+
+struct drm_tegra_syncpt_incr {
+	__u32 id;
+	__u32 pad;
+};
+
+struct drm_tegra_syncpt_wait {
+	__u32 id;
+	__u32 thresh;
+	__u32 timeout;
+	__u32 value;
+};
+
+#define DRM_TEGRA_NO_TIMEOUT	(0xffffffff)
+
+struct drm_tegra_open_channel {
+	__u32 client;
+	__u32 pad;
+	__u64 context;
+};
+
+struct drm_tegra_close_channel {
+	__u64 context;
+};
+
+struct drm_tegra_get_syncpt {
+	__u64 context;
+	__u32 index;
+	__u32 id;
+};
+
+struct drm_tegra_syncpt {
+	__u32 id;
+	__u32 incrs;
+};
+
+struct drm_tegra_cmdbuf {
+	__u32 handle;
+	__u32 offset;
+	__u32 words;
+	__u32 pad;
+};
+
+struct drm_tegra_reloc {
+	struct {
+		__u32 handle;
+		__u32 offset;
+	} cmdbuf;
+	struct {
+		__u32 handle;
+		__u32 offset;
+	} target;
+	__u32 shift;
+	__u32 pad;
+};
+
+struct drm_tegra_waitchk {
+	__u32 handle;
+	__u32 offset;
+	__u32 syncpt;
+	__u32 thresh;
+};
+
+struct drm_tegra_submit {
+	__u64 context;
+	__u32 num_syncpts;
+	__u32 num_cmdbufs;
+	__u32 num_relocs;
+	__u32 num_waitchks;
+	__u32 waitchk_mask;
+	__u32 timeout;
+	__u32 pad;
+	__u64 syncpts;
+	__u64 cmdbufs;
+	__u64 relocs;
+	__u64 waitchks;
+	__u32 fence;		/* Return value */
+
+	__u32 reserved[5];	/* future expansion */
+};
+
+#define DRM_TEGRA_GEM_CREATE	0x00
+#define DRM_TEGRA_GEM_MMAP	0x01
+#define DRM_TEGRA_SYNCPT_READ	0x02
+#define DRM_TEGRA_SYNCPT_INCR	0x03
+#define DRM_TEGRA_SYNCPT_WAIT	0x04
+#define DRM_TEGRA_OPEN_CHANNEL	0x05
+#define DRM_TEGRA_CLOSE_CHANNEL	0x06
+#define DRM_TEGRA_GET_SYNCPT	0x07
+#define DRM_TEGRA_SUBMIT	0x08
+
+#define DRM_IOCTL_TEGRA_GEM_CREATE DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_GEM_CREATE, struct drm_tegra_gem_create)
+#define DRM_IOCTL_TEGRA_GEM_MMAP DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_GEM_MMAP, struct drm_tegra_gem_mmap)
+#define DRM_IOCTL_TEGRA_SYNCPT_READ DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_SYNCPT_READ, struct drm_tegra_syncpt_read)
+#define DRM_IOCTL_TEGRA_SYNCPT_INCR DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_SYNCPT_INCR, struct drm_tegra_syncpt_incr)
+#define DRM_IOCTL_TEGRA_SYNCPT_WAIT DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_SYNCPT_WAIT, struct drm_tegra_syncpt_wait)
+#define DRM_IOCTL_TEGRA_OPEN_CHANNEL DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_OPEN_CHANNEL, struct drm_tegra_open_channel)
+#define DRM_IOCTL_TEGRA_CLOSE_CHANNEL DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_CLOSE_CHANNEL, struct drm_tegra_open_channel)
+#define DRM_IOCTL_TEGRA_GET_SYNCPT DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_GET_SYNCPT, struct drm_tegra_get_syncpt)
+#define DRM_IOCTL_TEGRA_SUBMIT DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_SUBMIT, struct drm_tegra_submit)
+
+#endif
-- 
1.7.9.5

