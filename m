Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767Ab3AOLWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 06:22:25 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10542 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756619Ab3AOLVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 06:21:20 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 15 Jan 2013 03:21:09 -0800
From: Terje Bergstrom <tbergstrom@nvidia.com>
To: <amerilainen@nvidia.com>, <airlied@linux.ie>,
        <thierry.reding@avionic-design.de>
CC: <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Terje Bergstrom <tbergstrom@nvidia.com>
Subject: [PATCHv5 8/8] drm: tegra: Add gr2d device
Date: Tue, 15 Jan 2013 13:26:22 +0200
Message-ID: <1358249182-17486-9-git-send-email-tbergstrom@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358249182-17486-1-git-send-email-tbergstrom@nvidia.com>
References: <1358249182-17486-1-git-send-email-tbergstrom@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add client driver for 2D device, and IOCTLs to pass work to host1x
channel for 2D.

Also adds functions that can be called to access sync points from DRM.

Signed-off-by: Terje Bergstrom <tbergstrom@nvidia.com>
---
 drivers/gpu/host1x/Makefile   |    1 +
 drivers/gpu/host1x/dev.c      |    7 +
 drivers/gpu/host1x/drm/drm.c  |  226 +++++++++++++++++++++++++++-
 drivers/gpu/host1x/drm/drm.h  |   28 ++++
 drivers/gpu/host1x/drm/gr2d.c |  325 +++++++++++++++++++++++++++++++++++++++++
 drivers/gpu/host1x/syncpt.c   |    5 +
 drivers/gpu/host1x/syncpt.h   |    3 +
 include/drm/tegra_drm.h       |  131 +++++++++++++++++
 8 files changed, 725 insertions(+), 1 deletion(-)
 create mode 100644 drivers/gpu/host1x/drm/gr2d.c
 create mode 100644 include/drm/tegra_drm.h

diff --git a/drivers/gpu/host1x/Makefile b/drivers/gpu/host1x/Makefile
index c35ee19..c2120ad 100644
--- a/drivers/gpu/host1x/Makefile
+++ b/drivers/gpu/host1x/Makefile
@@ -18,4 +18,5 @@ ccflags-$(CONFIG_DRM_TEGRA_DEBUG) += -DDEBUG
 
 host1x-$(CONFIG_DRM_TEGRA) += drm/drm.o drm/fb.o drm/dc.o
 host1x-$(CONFIG_DRM_TEGRA) += drm/output.o drm/rgb.o drm/hdmi.o
+host1x-$(CONFIG_DRM_TEGRA) += drm/gr2d.o
 obj-$(CONFIG_TEGRA_HOST1X) += host1x.o
diff --git a/drivers/gpu/host1x/dev.c b/drivers/gpu/host1x/dev.c
index 17ee01c..40d9938 100644
--- a/drivers/gpu/host1x/dev.c
+++ b/drivers/gpu/host1x/dev.c
@@ -214,11 +214,17 @@ static int __init tegra_host1x_init(void)
 	err = platform_driver_register(&tegra_hdmi_driver);
 	if (err < 0)
 		goto unregister_dc;
+
+	err = platform_driver_register(&tegra_gr2d_driver);
+	if (err < 0)
+		goto unregister_hdmi;
 #endif
 
 	return 0;
 
 #ifdef CONFIG_TEGRA_DRM
+unregister_hdmi:
+	platform_driver_unregister(&tegra_hdmi_driver);
 unregister_dc:
 	platform_driver_unregister(&tegra_dc_driver);
 unregister_host1x:
@@ -231,6 +237,7 @@ module_init(tegra_host1x_init);
 static void __exit tegra_host1x_exit(void)
 {
 #ifdef CONFIG_TEGRA_DRM
+	platform_driver_unregister(&tegra_gr2d_driver);
 	platform_driver_unregister(&tegra_hdmi_driver);
 	platform_driver_unregister(&tegra_dc_driver);
 #endif
diff --git a/drivers/gpu/host1x/drm/drm.c b/drivers/gpu/host1x/drm/drm.c
index bef9051..f8f8508 100644
--- a/drivers/gpu/host1x/drm/drm.c
+++ b/drivers/gpu/host1x/drm/drm.c
@@ -14,9 +14,11 @@
 #include <mach/clk.h>
 #include <linux/dma-mapping.h>
 #include <asm/dma-iommu.h>
+#include <drm/tegra_drm.h>
 
 #include "drm.h"
 #include "host1x_client.h"
+#include "syncpt.h"
 
 #define DRIVER_NAME "tegra"
 #define DRIVER_DESC "NVIDIA Tegra graphics"
@@ -78,8 +80,10 @@ static int host1x_parse_dt(struct host1x *host1x)
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
@@ -270,7 +274,29 @@ static int tegra_drm_unload(struct drm_device *drm)
 
 static int tegra_drm_open(struct drm_device *drm, struct drm_file *filp)
 {
-	return 0;
+	struct host1x_drm_fpriv *fpriv;
+	int err = 0;
+
+	fpriv = kzalloc(sizeof(*fpriv), GFP_KERNEL);
+	if (!fpriv)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&fpriv->contexts);
+	filp->driver_priv = fpriv;
+
+	return err;
+}
+
+static void tegra_drm_close(struct drm_device *drm, struct drm_file *filp)
+{
+	struct host1x_drm_fpriv *fpriv = host1x_drm_fpriv(filp);
+	struct host1x_drm_context *context, *tmp;
+
+	list_for_each_entry_safe(context, tmp, &fpriv->contexts, list) {
+		context->client->ops->close_channel(context);
+		kfree(context);
+	}
+	kfree(fpriv);
 }
 
 static void tegra_drm_lastclose(struct drm_device *drm)
@@ -280,7 +306,204 @@ static void tegra_drm_lastclose(struct drm_device *drm)
 	drm_fbdev_cma_restore_mode(host1x->fbdev);
 }
 
+static int
+tegra_drm_ioctl_syncpt_read(struct drm_device *drm, void *data,
+			 struct drm_file *file_priv)
+{
+	struct host1x *host1x = drm->dev_private;
+	struct tegra_drm_syncpt_read_args *args = data;
+	struct host1x_syncpt *sp =
+		host1x_syncpt_get_bydev(host1x->dev, args->id);
+
+	if (!sp)
+		return -EINVAL;
+
+	args->value = host1x_syncpt_read_min(sp);
+	return 0;
+}
+
+static int
+tegra_drm_ioctl_syncpt_incr(struct drm_device *drm, void *data,
+			 struct drm_file *file_priv)
+{
+	struct host1x *host1x = drm->dev_private;
+	struct tegra_drm_syncpt_incr_args *args = data;
+	struct host1x_syncpt *sp =
+		host1x_syncpt_get_bydev(host1x->dev, args->id);
+
+	if (!sp)
+		return -EINVAL;
+
+	host1x_syncpt_incr(sp);
+	return 0;
+}
+
+static int
+tegra_drm_ioctl_syncpt_wait(struct drm_device *drm, void *data,
+			 struct drm_file *file_priv)
+{
+	struct host1x *host1x = drm->dev_private;
+	struct tegra_drm_syncpt_wait_args *args = data;
+	struct host1x_syncpt *sp =
+		host1x_syncpt_get_bydev(host1x->dev, args->id);
+
+	if (!sp)
+		return -EINVAL;
+
+	return host1x_syncpt_wait(sp, args->thresh,
+			args->timeout, &args->value);
+}
+
+static int
+tegra_drm_ioctl_open_channel(struct drm_device *drm, void *data,
+			 struct drm_file *file_priv)
+{
+	struct tegra_drm_open_channel_args *args = data;
+	struct host1x_client *client;
+	struct host1x_drm_context *context;
+	struct host1x_drm_fpriv *fpriv = host1x_drm_fpriv(file_priv);
+	struct host1x *host1x = drm->dev_private;
+	int err = 0;
+
+	context = kzalloc(sizeof(*context), GFP_KERNEL);
+	if (!context)
+		return -ENOMEM;
+
+	list_for_each_entry(client, &host1x->clients, list) {
+		if (client->class == args->class) {
+			context->client = client;
+			err = client->ops->open_channel(client, context);
+			if (err)
+				goto out;
+
+			list_add(&context->list, &fpriv->contexts);
+			args->context = (uintptr_t)context;
+			goto out;
+		}
+	}
+	err = -ENODEV;
+
+out:
+	if (err)
+		kfree(context);
+
+	return err;
+}
+
+static int
+tegra_drm_ioctl_close_channel(struct drm_device *drm, void *data,
+			 struct drm_file *file_priv)
+{
+	struct tegra_drm_open_channel_args *args = data;
+	struct host1x_drm_context *context, *tmp;
+	struct host1x_drm_fpriv *fpriv = host1x_drm_fpriv(file_priv);
+	int err = 0;
+
+	list_for_each_entry_safe(context, tmp, &fpriv->contexts, list) {
+		if ((uintptr_t)context == args->context) {
+			context->client->ops->close_channel(context);
+			list_del(&context->list);
+			kfree(context);
+			goto out;
+		}
+	}
+	err = -EINVAL;
+
+out:
+	return err;
+}
+
+static int
+tegra_drm_ioctl_get_syncpoint(struct drm_device *drm, void *data,
+			 struct drm_file *file_priv)
+{
+	struct tegra_drm_get_channel_param_args *args = data;
+	struct host1x_drm_context *context;
+	struct host1x_drm_fpriv *fpriv = host1x_drm_fpriv(file_priv);
+	int err = 0;
+
+	list_for_each_entry(context, &fpriv->contexts, list) {
+		if ((uintptr_t)context == args->context) {
+			args->value =
+				context->client->ops->get_syncpoint(context,
+						args->param);
+			goto out;
+		}
+	}
+	err = -ENODEV;
+
+out:
+	return err;
+}
+
+static int
+tegra_drm_ioctl_submit(struct drm_device *drm, void *data,
+			 struct drm_file *file_priv)
+{
+	struct tegra_drm_submit_args *args = data;
+	struct host1x_drm_context *context;
+	struct host1x_drm_fpriv *fpriv = host1x_drm_fpriv(file_priv);
+	int err = 0;
+
+	list_for_each_entry(context, &fpriv->contexts, list) {
+		if ((uintptr_t)context == args->context) {
+			err = context->client->ops->submit(context, args, drm,
+				file_priv);
+			goto out;
+		}
+	}
+	err = -ENODEV;
+
+out:
+	return err;
+
+}
+
+static int
+tegra_drm_create_ioctl(struct drm_device *drm, void *data,
+			 struct drm_file *file_priv)
+{
+	struct tegra_gem_create *args = data;
+	struct drm_gem_cma_object *cma_obj;
+	int ret;
+
+	cma_obj = drm_gem_cma_create(drm, args->size);
+	if (IS_ERR(cma_obj))
+		goto err_cma_create;
+
+	ret = drm_gem_handle_create(file_priv, &cma_obj->base, &args->handle);
+	if (ret)
+		goto err_handle_create;
+
+	args->offset = cma_obj->base.map_list.hash.key << PAGE_SHIFT;
+
+	drm_gem_object_unreference(&cma_obj->base);
+
+	return 0;
+
+err_handle_create:
+	drm_gem_cma_free_object(&cma_obj->base);
+err_cma_create:
+	return -ENOMEM;
+}
+
 static struct drm_ioctl_desc tegra_drm_ioctls[] = {
+	DRM_IOCTL_DEF_DRV(TEGRA_GEM_CREATE,
+			tegra_drm_create_ioctl, DRM_UNLOCKED | DRM_AUTH),
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
 };
 
 static const struct file_operations tegra_drm_fops = {
@@ -303,6 +526,7 @@ struct drm_driver tegra_drm_driver = {
 	.load = tegra_drm_load,
 	.unload = tegra_drm_unload,
 	.open = tegra_drm_open,
+	.preclose = tegra_drm_close,
 	.lastclose = tegra_drm_lastclose,
 
 	.gem_free_object = drm_gem_cma_free_object,
diff --git a/drivers/gpu/host1x/drm/drm.h b/drivers/gpu/host1x/drm/drm.h
index e7101d5..dc4c128 100644
--- a/drivers/gpu/host1x/drm/drm.h
+++ b/drivers/gpu/host1x/drm/drm.h
@@ -17,6 +17,7 @@
 #include <drm/drm_gem_cma_helper.h>
 #include <drm/drm_fb_cma_helper.h>
 #include <drm/drm_fixed.h>
+#include <drm/tegra_drm.h>
 
 struct tegra_framebuffer {
 	struct drm_framebuffer base;
@@ -49,17 +50,44 @@ struct host1x {
 
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
+	int (*open_channel)(struct host1x_client *,
+			struct host1x_drm_context *);
+	void (*close_channel)(struct host1x_drm_context *);
+	u32 (*get_syncpoint)(struct host1x_drm_context *, int index);
+	int (*submit)(struct host1x_drm_context *,
+			struct tegra_drm_submit_args *,
+			struct drm_device *,
+			struct drm_file *);
+};
+
+struct host1x_drm_fpriv {
+	struct list_head contexts;
 };
 
+static inline struct host1x_drm_fpriv *
+host1x_drm_fpriv(struct drm_file *file_priv)
+{
+	return file_priv ? file_priv->driver_priv : NULL;
+}
+
 struct host1x_client {
 	struct host1x *host1x;
 	struct device *dev;
 
 	const struct host1x_client_ops *ops;
 
+	u32 class;
+	struct host1x_channel *channel;
+
 	struct list_head list;
 };
 
diff --git a/drivers/gpu/host1x/drm/gr2d.c b/drivers/gpu/host1x/drm/gr2d.c
new file mode 100644
index 0000000..dc7d6c6
--- /dev/null
+++ b/drivers/gpu/host1x/drm/gr2d.c
@@ -0,0 +1,325 @@
+/*
+ * drivers/video/tegra/host/gr2d/gr2d.c
+ *
+ * Tegra Graphics 2D
+ *
+ * Copyright (c) 2012, NVIDIA Corporation.
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
+#include "drm.h"
+#include "job.h"
+#include "channel.h"
+#include "host1x.h"
+#include "syncpt.h"
+#include "memmgr.h"
+#include "host1x_client.h"
+
+struct gr2d {
+	struct host1x_client client;
+	struct clk *clk;
+	struct host1x_syncpt *syncpt;
+	struct host1x_channel *channel;
+};
+
+static int gr2d_is_addr_reg(struct platform_device *dev, u32 class, u32 reg);
+
+static int gr2d_client_init(struct host1x_client *client,
+		struct drm_device *drm)
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
+		struct host1x_drm_context *context)
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
+static u32 gr2d_get_syncpoint(struct host1x_drm_context *context, int index)
+{
+	struct gr2d *gr2d = dev_get_drvdata(context->client->dev);
+	if (index != 0)
+		return UINT_MAX;
+
+	return host1x_syncpt_id(gr2d->syncpt);
+}
+
+static u32 handle_cma_to_host1x(struct drm_device *drm,
+				struct drm_file *file_priv, u32 gem_handle)
+{
+	struct drm_gem_object *obj;
+	struct drm_gem_cma_object *cma_obj;
+	u32 host1x_handle;
+
+	obj = drm_gem_object_lookup(drm, file_priv, gem_handle);
+	if (!obj)
+		return 0;
+
+	cma_obj = to_drm_gem_cma_obj(obj);
+	host1x_handle = host1x_memmgr_host1x_id(mem_mgr_type_cma, (u32)cma_obj);
+	drm_gem_object_unreference(obj);
+
+	return host1x_handle;
+}
+
+static int gr2d_submit(struct host1x_drm_context *context,
+		struct tegra_drm_submit_args *args,
+		struct drm_device *drm,
+		struct drm_file *file_priv)
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
+	job = host1x_job_alloc(context->channel,
+			args->num_cmdbufs,
+			args->num_relocs,
+			args->num_waitchks);
+	if (!job)
+		return -ENOMEM;
+
+	job->num_relocs = args->num_relocs;
+	job->num_waitchk = args->num_waitchks;
+	job->clientid = (u32)args->context;
+	job->class = context->client->class;
+	job->serialize = true;
+
+	while (num_cmdbufs) {
+		struct tegra_drm_cmdbuf cmdbuf;
+		err = copy_from_user(&cmdbuf, cmdbufs, sizeof(cmdbuf));
+		if (err)
+			goto fail;
+
+		cmdbuf.mem = handle_cma_to_host1x(drm, file_priv, cmdbuf.mem);
+		if (!cmdbuf.mem)
+			goto fail;
+
+		host1x_job_add_gather(job,
+				cmdbuf.mem, cmdbuf.words, cmdbuf.offset);
+		num_cmdbufs--;
+		cmdbufs++;
+	}
+
+	err = copy_from_user(job->relocarray,
+			relocs, sizeof(*relocs) * num_relocs);
+	if (err)
+		goto fail;
+
+	while (num_relocs--) {
+		job->relocarray[num_relocs].cmdbuf_mem =
+			handle_cma_to_host1x(drm, file_priv,
+			job->relocarray[num_relocs].cmdbuf_mem);
+		job->relocarray[num_relocs].target =
+			handle_cma_to_host1x(drm, file_priv,
+			job->relocarray[num_relocs].target);
+
+		if (!job->relocarray[num_relocs].target ||
+			!job->relocarray[num_relocs].cmdbuf_mem)
+			goto fail;
+	}
+
+	err = copy_from_user(job->waitchk,
+			waitchks, sizeof(*waitchks) * num_waitchks);
+	if (err)
+		goto fail;
+
+	err = host1x_job_pin(job, to_platform_device(context->client->dev));
+	if (err)
+		goto fail;
+
+	err = copy_from_user(&syncpt_incr,
+			(void * __user)(uintptr_t)args->syncpt_incrs,
+			sizeof(syncpt_incr));
+	if (err)
+		goto fail;
+
+	job->syncpt_id = syncpt_incr.syncpt_id;
+	job->syncpt_incrs = syncpt_incr.syncpt_incrs;
+	job->timeout = 10000;
+	job->is_addr_reg = gr2d_is_addr_reg;
+	if (args->timeout && args->timeout < 10000)
+		job->timeout = args->timeout;
+
+	err = host1x_channel_submit(job);
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
+	.get_syncpoint = gr2d_get_syncpoint,
+	.submit = gr2d_submit,
+};
+
+static int gr2d_is_addr_reg(struct platform_device *dev, u32 class, u32 reg)
+{
+	int ret;
+
+	if (class == NV_HOST1X_CLASS_ID)
+		ret = reg == 0x2b;
+	else
+		switch (reg) {
+		case 0x1a:
+		case 0x1b:
+		case 0x26:
+		case 0x2b:
+		case 0x2c:
+		case 0x2d:
+		case 0x31:
+		case 0x32:
+		case 0x48:
+		case 0x49:
+		case 0x4a:
+		case 0x4b:
+		case 0x4c:
+			ret = 1;
+			break;
+		default:
+			ret = 0;
+			break;
+		}
+
+	return ret;
+}
+
+static struct of_device_id gr2d_match[] = {
+	{ .compatible = "nvidia,tegra30-gr2d" },
+	{ .compatible = "nvidia,tegra20-gr2d" },
+	{ },
+};
+
+static int gr2d_probe(struct platform_device *dev)
+{
+	struct host1x *host1x =
+		host1x_get_drm_data(to_platform_device(dev->dev.parent));
+	int err;
+	struct gr2d *gr2d = NULL;
+
+	gr2d = devm_kzalloc(&dev->dev, sizeof(*gr2d), GFP_KERNEL);
+	if (!gr2d)
+		return -ENOMEM;
+
+	gr2d->clk = devm_clk_get(&dev->dev, "gr2d");
+	if (IS_ERR(gr2d->clk)) {
+		dev_err(&dev->dev, "cannot get clock\n");
+		return PTR_ERR(gr2d->clk);
+	}
+
+	err = clk_prepare_enable(gr2d->clk);
+	if (err) {
+		dev_err(&dev->dev, "cannot turn on clock\n");
+		return err;
+	}
+
+	gr2d->channel = host1x_channel_alloc(dev);
+	if (!gr2d->channel)
+		return -ENOMEM;
+
+	gr2d->syncpt = host1x_syncpt_alloc(dev, 0);
+	if (!gr2d->syncpt) {
+		host1x_channel_free(gr2d->channel);
+		return -ENOMEM;
+	}
+
+	gr2d->client.ops = &gr2d_client_ops;
+	gr2d->client.dev = &dev->dev;
+	gr2d->client.class = NV_GRAPHICS_2D_CLASS_ID;
+
+	err = host1x_register_client(host1x, &gr2d->client);
+	if (err < 0) {
+		dev_err(&dev->dev, "failed to register host1x client: %d\n",
+			err);
+		return err;
+	}
+
+	platform_set_drvdata(dev, gr2d);
+	return 0;
+}
+
+static int __exit gr2d_remove(struct platform_device *dev)
+{
+	struct host1x *host1x =
+		host1x_get_drm_data(to_platform_device(dev->dev.parent));
+	struct gr2d *gr2d = platform_get_drvdata(dev);
+	int err;
+
+	err = host1x_unregister_client(host1x, &gr2d->client);
+	if (err < 0) {
+		dev_err(&dev->dev, "failed to unregister host1x client: %d\n",
+			err);
+		return err;
+	}
+
+	host1x_syncpt_free(gr2d->syncpt);
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
diff --git a/drivers/gpu/host1x/syncpt.c b/drivers/gpu/host1x/syncpt.c
index 191f65f..ccaaece 100644
--- a/drivers/gpu/host1x/syncpt.c
+++ b/drivers/gpu/host1x/syncpt.c
@@ -392,3 +392,8 @@ struct host1x_syncpt *host1x_syncpt_get(struct host1x *dev, u32 id)
 {
 	return dev->syncpt + id;
 }
+
+struct host1x_syncpt *host1x_syncpt_get_bydev(struct device *dev, u32 id)
+{
+	return host1x_syncpt_get(dev_get_drvdata(dev), id);
+}
diff --git a/drivers/gpu/host1x/syncpt.h b/drivers/gpu/host1x/syncpt.h
index 255a3a3..d15d4c5 100644
--- a/drivers/gpu/host1x/syncpt.h
+++ b/drivers/gpu/host1x/syncpt.h
@@ -110,6 +110,9 @@ static inline bool host1x_syncpt_min_eq_max(struct host1x_syncpt *sp)
 /* Return pointer to struct denoting sync point id. */
 struct host1x_syncpt *host1x_syncpt_get(struct host1x *dev, u32 id);
 
+/* Return pointer to struct denoting sync point id, when given client pdev. */
+struct host1x_syncpt *host1x_syncpt_get_bydev(struct device *dev, u32 id);
+
 /* Request incrementing a sync point. */
 void host1x_syncpt_cpu_incr(struct host1x_syncpt *sp);
 
diff --git a/include/drm/tegra_drm.h b/include/drm/tegra_drm.h
new file mode 100644
index 0000000..11fb019
--- /dev/null
+++ b/include/drm/tegra_drm.h
@@ -0,0 +1,131 @@
+/*
+ * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
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
+struct tegra_gem_create {
+	__u64 size;
+	unsigned int flags;
+	unsigned int handle;
+	unsigned int offset;
+};
+
+struct tegra_gem_invalidate {
+	unsigned int handle;
+};
+
+struct tegra_gem_flush {
+	unsigned int handle;
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
+	__s32 timeout;
+	__u32 value;
+};
+
+#define DRM_TEGRA_NO_TIMEOUT	(-1)
+
+struct tegra_drm_open_channel_args {
+	__u32 class;
+	__u32 pad;
+	__u64 context;
+};
+
+struct tegra_drm_get_channel_param_args {
+	__u64 context;
+	__u32 param;
+	__u32 value;
+};
+
+struct tegra_drm_syncpt_incr {
+	__u32 syncpt_id;
+	__u32 syncpt_incrs;
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
+#define DRM_TEGRA_GEM_CREATE		0x00
+#define DRM_TEGRA_DRM_SYNCPT_READ	0x01
+#define DRM_TEGRA_DRM_SYNCPT_INCR	0x02
+#define DRM_TEGRA_DRM_SYNCPT_WAIT	0x03
+#define DRM_TEGRA_DRM_OPEN_CHANNEL	0x04
+#define DRM_TEGRA_DRM_CLOSE_CHANNEL	0x05
+#define DRM_TEGRA_DRM_GET_SYNCPOINT	0x06
+#define DRM_TEGRA_DRM_SUBMIT		0x08
+
+#define DRM_IOCTL_TEGRA_GEM_CREATE DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_GEM_CREATE, struct tegra_gem_create)
+#define DRM_IOCTL_TEGRA_DRM_SYNCPT_READ DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_DRM_SYNCPT_READ, struct tegra_drm_syncpt_read_args)
+#define DRM_IOCTL_TEGRA_DRM_SYNCPT_INCR DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_DRM_SYNCPT_INCR, struct tegra_drm_syncpt_incr_args)
+#define DRM_IOCTL_TEGRA_DRM_SYNCPT_WAIT DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_DRM_SYNCPT_WAIT, struct tegra_drm_syncpt_wait_args)
+#define DRM_IOCTL_TEGRA_DRM_OPEN_CHANNEL DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_DRM_OPEN_CHANNEL, struct tegra_drm_open_channel_args)
+#define DRM_IOCTL_TEGRA_DRM_CLOSE_CHANNEL DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_DRM_CLOSE_CHANNEL, struct tegra_drm_open_channel_args)
+#define DRM_IOCTL_TEGRA_DRM_GET_SYNCPOINT DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_DRM_GET_SYNCPOINT, struct tegra_drm_get_channel_param_args)
+#define DRM_IOCTL_TEGRA_DRM_SUBMIT DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_DRM_SUBMIT, struct tegra_drm_submit_args)
+
+#endif
-- 
1.7.9.5

