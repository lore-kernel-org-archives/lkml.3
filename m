Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734Ab3APOti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 09:49:38 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:37989 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756300Ab3APOom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 09:44:42 -0500
From: sjur.brandeland@stericsson.com
To: Ido Yariv <ido@wizery.com>, Ohad Ben-Cohen <ohad@wizery.com>
Cc: mporter@ti.com, =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Loic Pallardy <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Suman Anna <s-anna@ti.com>, Mark Grosen <mgrosen@ti.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [RFCv3 09/11] remoteproc: Load firmware once.
Date: Wed, 16 Jan 2013 15:43:48 +0100
Message-Id: <1358347430-9243-10-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358347430-9243-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1358347430-9243-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Add support for two-way virtio configuration space and status.
Ring-addresses and negotiated feature-bits are readable from device.
Allocation of larger Carveouts are also supported. And when
adding a new rproc device, the firmware is now loaded once not
twice. But there is a catch:

       This patch requires device firmware change!

The device memory layout changes.The virtio rings are no longer
located at start of the device memory. But the device must read the
vring address from the resource table.

This patch also re-organizes the resource handling.
rproc_fw_load() will allocate all resource table resources:
carveouts, trace buffers and vrings. To undo rproc_fw_load(),
vdevs must be unregistered and rproc_resource_cleanup() must
be called.

rproc_boot() will increment power ref-count and module ref-count,
enable iommu, and start the device. rproc_shutdown() reverses all this.

Cycles of rproc_shutdown(), rproc_boot() is handeled by reloading
the firmware (rproc_boot() will reload if state != RPROC_LOADED).

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/remoteproc/remoteproc_core.c     |  158 +++++++++++++++--------------
 drivers/remoteproc/remoteproc_internal.h |    3 +
 2 files changed, 85 insertions(+), 76 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 8604b60..da1ff4f 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -698,7 +698,7 @@ static rproc_handle_resource_t rproc_handle_vdev_rsc[RSC_LAST] = {
 	[RSC_VDEV] = (rproc_handle_resource_t)rproc_handle_vdev,
 };
 
-/* handle firmware resource entries before booting the remote processor */
+/* handle firmware resource entries */
 static int
 rproc_handle_resource(struct rproc *rproc, struct resource_table *table,
 				int len,
@@ -782,11 +782,34 @@ static void rproc_resource_cleanup(struct rproc *rproc)
 	}
 }
 
+static int rproc_fw_reload(struct rproc *rproc)
+{
+	const struct firmware *fw;
+	int err;
+
+	err = request_firmware(&fw, rproc->firmware, &rproc->dev);
+	if (err < 0)
+		return err;
+
+	/* TODO: Compare FW checksum between old and new image */
+
+	/* load the ELF segments to memory */
+	err = rproc_load_segments(rproc, fw);
+	release_firmware(fw);
+	return err;
+}
+
 /*
- * take a firmware and boot a remote processor with it.
+ * take a firmware, parse the resouce table and load it
+ *
+ * Note: this function is called asynchronously upon registration of the
+ * remote processor (so we must wait until it completes before we try
+ * to unregister the device. one other option is just to use kref here,
+ * that might be cleaner).
  */
-static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
+static void rproc_fw_load(const struct firmware *fw, void *context)
 {
+	struct rproc *rproc = context;
 	struct device *dev = &rproc->dev;
 	const char *name = rproc->firmware;
 	struct resource_table *table;
@@ -794,7 +817,7 @@ static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
 
 	ret = rproc_fw_sanity_check(rproc, fw);
 	if (ret)
-		return ret;
+		goto release_fw;
 
 	dev_info(dev, "Booting fw image %s, size %zd\n", name, fw->size);
 
@@ -807,7 +830,7 @@ static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
 		goto clean_up;
 	}
 
-	/* handle fw resources which are required to boot rproc */
+	/* handle fw resources which are required to load rproc */
 	ret = rproc_handle_resource(rproc, table, tablesz, rproc_handle_rsc);
 	if (ret) {
 		dev_err(dev, "Failed to process resources: %d\n", ret);
@@ -821,60 +844,37 @@ static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
 		goto clean_up;
 	}
 
-	/* power up the remote processor */
-	ret = rproc->ops->start(rproc);
-	if (ret) {
-		dev_err(dev, "can't start rproc %s: %d\n", rproc->name, ret);
+	/* look for the resource table in device memory */
+	table = rproc_get_rsctab_addr(rproc, fw);
+	if (!table) {
+		ret = -EINVAL;
 		goto clean_up;
 	}
 
-	rproc->state = RPROC_RUNNING;
+	rproc->state = RPROC_LOADED;
 
-	dev_info(dev, "remote processor %s is now up\n", rproc->name);
+	/* handle vdev resources, this will normally start the device */
+	ret = rproc_handle_resource(rproc, table, tablesz,
+				    rproc_handle_vdev_rsc);
+	if (ret) {
+		dev_err(dev, "Failed to process resources: %d\n", ret);
+		goto clean_up;
+	}
 
-	return 0;
+	dev_info(dev, "remote processor %s is loaded to memory\n", rproc->name);
 
 clean_up:
-	rproc_resource_cleanup(rproc);
-	rproc_disable_iommu(rproc);
-	return ret;
-}
-
-/*
- * take a firmware and look for virtio devices to register.
- *
- * Note: this function is called asynchronously upon registration of the
- * remote processor (so we must wait until it completes before we try
- * to unregister the device. one other option is just to use kref here,
- * that might be cleaner).
- */
-static void rproc_fw_config_virtio(const struct firmware *fw, void *context)
-{
-	struct rproc *rproc = context;
-	struct resource_table *table;
-	int ret, tablesz;
-
-	if (rproc_fw_sanity_check(rproc, fw) < 0)
-		goto out;
-
-	/* look for the resource table */
-	table = rproc_find_rsc_table(rproc, fw,  &tablesz);
-	if (!table)
-		goto out;
-
-	/* look for virtio devices and register them */
-	ret = rproc_handle_resource(rproc, table, tablesz,
-						rproc_handle_vdev_rsc);
-	if (ret)
-		goto out;
-
-out:
+	if (ret) {
+		rproc->state = RPROC_OFFLINE;
+		rproc_resource_cleanup(rproc);
+	}
+release_fw:
 	release_firmware(fw);
 	/* allow rproc_del() contexts, if any, to proceed */
 	complete_all(&rproc->firmware_loading_complete);
 }
 
-static int rproc_add_virtio_devices(struct rproc *rproc)
+static int rproc_load_firmware(struct rproc *rproc)
 {
 	int ret;
 
@@ -882,16 +882,12 @@ static int rproc_add_virtio_devices(struct rproc *rproc)
 	init_completion(&rproc->firmware_loading_complete);
 
 	/*
-	 * We must retrieve early virtio configuration info from
-	 * the firmware (e.g. whether to register a virtio device,
-	 * what virtio features does it support, ...).
-	 *
 	 * We're initiating an asynchronous firmware loading, so we can
 	 * be built-in kernel code, without hanging the boot process.
 	 */
 	ret = request_firmware_nowait(THIS_MODULE, FW_ACTION_HOTPLUG,
 				      rproc->firmware, &rproc->dev, GFP_KERNEL,
-				      rproc, rproc_fw_config_virtio);
+				      rproc, rproc_fw_load);
 	if (ret < 0) {
 		dev_err(&rproc->dev, "request_firmware_nowait err: %d\n", ret);
 		complete_all(&rproc->firmware_loading_complete);
@@ -925,7 +921,10 @@ int rproc_trigger_recovery(struct rproc *rproc)
 	/* wait until there is no more rproc users */
 	wait_for_completion(&rproc->crash_comp);
 
-	return rproc_add_virtio_devices(rproc);
+	/* clean up all acquired resources */
+	rproc_resource_cleanup(rproc);
+
+	return rproc_load_firmware(rproc);
 }
 
 /**
@@ -972,7 +971,6 @@ static void rproc_crash_handler_work(struct work_struct *work)
  */
 int rproc_boot(struct rproc *rproc)
 {
-	const struct firmware *firmware_p;
 	struct device *dev;
 	int ret;
 
@@ -989,26 +987,17 @@ int rproc_boot(struct rproc *rproc)
 		return ret;
 	}
 
-	/* prevent underlying implementation from being removed */
-	if (!try_module_get(dev->parent->driver->owner)) {
-		dev_err(dev, "%s: can't get owner\n", __func__);
-		ret = -EINVAL;
-		goto unlock_mutex;
-	}
-
 	/* skip the boot process if rproc is already powered up */
 	if (atomic_inc_return(&rproc->power) > 1) {
 		ret = 0;
 		goto unlock_mutex;
 	}
 
-	dev_info(dev, "powering up %s\n", rproc->name);
-
-	/* load firmware */
-	ret = request_firmware(&firmware_p, rproc->firmware, dev);
-	if (ret < 0) {
-		dev_err(dev, "request_firmware failed: %d\n", ret);
-		goto downref_rproc;
+	/* Reload segments to memory unless we've already loaded the segments */
+	if (rproc->state != RPROC_LOADED) {
+		ret = rproc_fw_reload(rproc);
+		if (ret)
+			goto downref_rproc;
 	}
 
 	/*
@@ -1021,14 +1010,31 @@ int rproc_boot(struct rproc *rproc)
 		goto downref_rproc;
 	}
 
-	ret = rproc_fw_boot(rproc, firmware_p);
+	/* prevent underlying implementation from being removed */
+	if (!try_module_get(dev->parent->driver->owner)) {
+		dev_err(dev, "%s: can't get owner\n", __func__);
+		ret = -EINVAL;
+		goto downref_rproc;
+	}
+
+	dev_info(dev, "powering up %s\n", rproc->name);
+
+	/* power up the remote processor */
+	ret = rproc->ops->start(rproc);
+	if (ret) {
+		dev_err(dev, "can't start rproc %s: %d\n", rproc->name, ret);
+		rproc->state = RPROC_OFFLINE;
+		module_put(dev->parent->driver->owner);
+		goto downref_rproc;
+	}
 
-	release_firmware(firmware_p);
+	rproc->state = RPROC_RUNNING;
+	dev_info(dev, "powering up %s\n", rproc->name);
 
 downref_rproc:
 	if (ret) {
+		/* disabling iommu is nop if already disabled */
 		rproc_disable_iommu(rproc);
-		module_put(dev->parent->driver->owner);
 		atomic_dec(&rproc->power);
 	}
 unlock_mutex:
@@ -1079,8 +1085,7 @@ void rproc_shutdown(struct rproc *rproc)
 		goto out;
 	}
 
-	/* clean up all acquired resources */
-	rproc_resource_cleanup(rproc);
+	module_put(dev->parent->driver->owner);
 
 	rproc_disable_iommu(rproc);
 
@@ -1094,8 +1099,6 @@ void rproc_shutdown(struct rproc *rproc)
 
 out:
 	mutex_unlock(&rproc->lock);
-	if (!ret)
-		module_put(dev->parent->driver->owner);
 }
 EXPORT_SYMBOL(rproc_shutdown);
 
@@ -1142,7 +1145,7 @@ int rproc_add(struct rproc *rproc)
 	/* create debugfs entries */
 	rproc_create_debug_dir(rproc);
 
-	return rproc_add_virtio_devices(rproc);
+	return rproc_load_firmware(rproc);
 }
 EXPORT_SYMBOL(rproc_add);
 
@@ -1301,6 +1304,9 @@ int rproc_del(struct rproc *rproc)
 	list_for_each_entry_safe(rvdev, tmp, &rproc->rvdevs, node)
 		rproc_remove_virtio_dev(rvdev);
 
+	/* clean up all acquired resources */
+	rproc_resource_cleanup(rproc);
+
 	device_del(&rproc->dev);
 
 	return 0;
diff --git a/drivers/remoteproc/remoteproc_internal.h b/drivers/remoteproc/remoteproc_internal.h
index 3a5cb7d..860b687 100644
--- a/drivers/remoteproc/remoteproc_internal.h
+++ b/drivers/remoteproc/remoteproc_internal.h
@@ -71,6 +71,9 @@ int rproc_trigger_recovery(struct rproc *rproc);
 static inline
 int rproc_fw_sanity_check(struct rproc *rproc, const struct firmware *fw)
 {
+	if (!fw)
+		return -EINVAL;
+
 	if (rproc->fw_ops->sanity_check)
 		return rproc->fw_ops->sanity_check(rproc, fw);
 
-- 
1.7.5.4

