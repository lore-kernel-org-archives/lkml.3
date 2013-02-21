Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026Ab3BURQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 12:16:34 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:58955 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257Ab3BURQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 12:16:31 -0500
From: sjur.brandeland@stericsson.com
To: Ido Yariv <ido@wizery.com>, Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-kernel@vger.kernel.org,
        Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Erwan Yvin <erwan.yvin@stericsson.com>, sjur@brendeland.net,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [PATCHv2 08/10] remoteproc: Always perserve resource table data
Date: Thu, 21 Feb 2013 18:15:38 +0100
Message-Id: <1361466940-6813-9-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361466940-6813-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1361466940-6813-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Copy resource table from first to second firmware loading.
After firmware is loaded to memory, update the vdevs resource
pointer to the resource table kept in device memory.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/remoteproc/Kconfig           |    1 +
 drivers/remoteproc/remoteproc_core.c |   99 ++++++++++++++++++++++++++-------
 include/linux/remoteproc.h           |    9 +++
 3 files changed, 88 insertions(+), 21 deletions(-)

diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
index 96ce101..ea060e9 100644
--- a/drivers/remoteproc/Kconfig
+++ b/drivers/remoteproc/Kconfig
@@ -5,6 +5,7 @@ config REMOTEPROC
 	tristate
 	depends on EXPERIMENTAL
 	depends on HAS_DMA
+	select CRC32
 	select FW_CONFIG
 	select VIRTIO
 
diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index a747d95..6466f39 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -37,6 +37,7 @@
 #include <linux/iommu.h>
 #include <linux/idr.h>
 #include <linux/elf.h>
+#include <linux/crc32.h>
 #include <linux/virtio_ids.h>
 #include <linux/virtio_ring.h>
 #include <asm/byteorder.h>
@@ -45,7 +46,8 @@
 
 typedef int (*rproc_handle_resources_t)(struct rproc *rproc,
 				struct resource_table *table, int len);
-typedef int (*rproc_handle_resource_t)(struct rproc *rproc, void *, int avail);
+typedef int (*rproc_handle_resource_t)(struct rproc *rproc,
+				 void *, int offset, int avail);
 
 /* Unique indices for remoteproc devices */
 static DEFINE_IDA(rproc_dev_index);
@@ -306,7 +308,7 @@ void rproc_free_vring(struct rproc_vring *rvring)
  * Returns 0 on success, or an appropriate error code otherwise
  */
 static int rproc_handle_vdev(struct rproc *rproc, struct fw_rsc_vdev *rsc,
-								int avail)
+							int offset, int avail)
 {
 	struct device *dev = &rproc->dev;
 	struct rproc_vdev *rvdev;
@@ -350,6 +352,9 @@ static int rproc_handle_vdev(struct rproc *rproc, struct fw_rsc_vdev *rsc,
 	/* remember the device features */
 	rvdev->dfeatures = rsc->dfeatures;
 
+	/* remember the resource offset*/
+	rvdev->rsc_offset = offset;
+
 	list_add_tail(&rvdev->node, &rproc->rvdevs);
 
 	/* it is now safe to add the virtio device */
@@ -383,7 +388,7 @@ free_rvdev:
  * Returns 0 on success, or an appropriate error code otherwise
  */
 static int rproc_handle_trace(struct rproc *rproc, struct fw_rsc_trace *rsc,
-								int avail)
+							int offset, int avail)
 {
 	struct rproc_mem_entry *trace;
 	struct device *dev = &rproc->dev;
@@ -465,7 +470,7 @@ static int rproc_handle_trace(struct rproc *rproc, struct fw_rsc_trace *rsc,
  * are outside those ranges.
  */
 static int rproc_handle_devmem(struct rproc *rproc, struct fw_rsc_devmem *rsc,
-								int avail)
+							int offset, int avail)
 {
 	struct rproc_mem_entry *mapping;
 	struct device *dev = &rproc->dev;
@@ -538,7 +543,9 @@ out:
  * pressure is important; it may have a substantial impact on performance.
  */
 static int rproc_handle_carveout(struct rproc *rproc,
-				struct fw_rsc_carveout *rsc, int avail)
+						struct fw_rsc_carveout *rsc,
+						int offset, int avail)
+
 {
 	struct rproc_mem_entry *carveout, *mapping;
 	struct device *dev = &rproc->dev;
@@ -661,7 +668,7 @@ free_carv:
 }
 
 static int rproc_handle_notifyid(struct rproc *rproc, struct fw_rsc_vdev *rsc,
-								int avail)
+							int offset, int avail)
 {
 	/* Summerize the number of notification IDs */
 	rproc->max_notifyid += rsc->num_of_vrings;
@@ -690,17 +697,16 @@ static rproc_handle_resource_t rproc_handle_notifyid_rsc[RSC_LAST] = {
 
 /* handle firmware resource entries before booting the remote processor */
 static int
-rproc_handle_resource(struct rproc *rproc, struct resource_table *table,
-				int len,
-				rproc_handle_resource_t handlers[RSC_LAST])
+rproc_handle_resource(struct rproc *rproc, int len,
+		      rproc_handle_resource_t handlers[RSC_LAST])
 {
 	struct device *dev = &rproc->dev;
 	rproc_handle_resource_t handler;
 	int ret = 0, i;
 
-	for (i = 0; i < table->num; i++) {
-		int offset = table->offset[i];
-		struct fw_rsc_hdr *hdr = (void *)table + offset;
+	for (i = 0; i < rproc->rsc->num; i++) {
+		int offset = rproc->rsc->offset[i];
+		struct fw_rsc_hdr *hdr = (void *)rproc->rsc + offset;
 		int avail = len - offset - sizeof(*hdr);
 		void *rsc = (void *)hdr + sizeof(*hdr);
 
@@ -721,7 +727,7 @@ rproc_handle_resource(struct rproc *rproc, struct resource_table *table,
 		if (!handler)
 			continue;
 
-		ret = handler(rproc, rsc, avail);
+		ret = handler(rproc, rsc, offset + sizeof(*hdr), avail);
 		if (ret)
 			break;
 	}
@@ -779,9 +785,12 @@ static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
 {
 	struct device *dev = &rproc->dev;
 	const char *name = rproc->firmware;
-	struct resource_table *table;
+	struct resource_table *table, *devmem_rsc;
 	int ret, tablesz;
 
+	if (!rproc->rsc)
+		return -ENOMEM;
+
 	ret = rproc_fw_sanity_check(rproc, fw);
 	if (ret)
 		return ret;
@@ -807,8 +816,15 @@ static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
 		goto clean_up;
 	}
 
+	/* Verify that resource table in loaded fw is unchanged */
+	if (rproc->rsc_csum != crc32(0, table, tablesz)) {
+		dev_err(dev, "resource checksum failed, fw changed?\n");
+		ret = -EINVAL;
+		goto clean_up;
+	}
+
 	/* handle fw resources which are required to boot rproc */
-	ret = rproc_handle_resource(rproc, table, tablesz, rproc_handle_rsc);
+	ret = rproc_handle_resource(rproc, tablesz, rproc_handle_rsc);
 	if (ret) {
 		dev_err(dev, "Failed to process resources: %d\n", ret);
 		goto clean_up;
@@ -821,6 +837,19 @@ static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
 		goto clean_up;
 	}
 
+	/*
+	 * The starting device has been given the rproc->rsc_copy as the
+	 * resource table. The address of the vring along with the other
+	 * allocated resources (carveouts etc) is stored in rsc_copy.
+	 * In order to pass this information to the remote device we must
+	 * copy this information to device memory.
+	 */
+	devmem_rsc = rproc_get_rsctab_va(rproc, fw);
+	if (!devmem_rsc)
+		goto clean_up;
+
+	memcpy(devmem_rsc, rproc->rsc_copy, tablesz);
+
 	/* power up the remote processor */
 	ret = rproc->ops->start(rproc);
 	if (ret) {
@@ -828,6 +857,12 @@ static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
 		goto clean_up;
 	}
 
+	/*
+	 * Update rproc->rsc so that all subsequent allocations updates the
+	 * resource table in device memory.
+	 */
+	rproc->rsc = devmem_rsc;
+
 	rproc->state = RPROC_RUNNING;
 
 	dev_info(dev, "remote processor %s is now up\n", rproc->name);
@@ -862,17 +897,30 @@ static void rproc_fw_config_virtio(const struct firmware *fw, void *context)
 	if (!table)
 		goto out;
 
+	rproc->rsc_csum = crc32(0, table, tablesz);
+
+	/*
+	 * Create a copy of the resource table. When a virtio device starts
+	 * and calls vring_new_virtqueue() the address of the allocated vring
+	 * will be stored in the rsc_copy. Before the device is started,
+	 * rsc_copy will be copied into devic memory.
+	 */
+	rproc->rsc_copy = kmalloc(tablesz, GFP_KERNEL);
+	if (!rproc->rsc_copy)
+		goto out;
+
+	memcpy(rproc->rsc_copy, table, tablesz);
+	rproc->rsc = rproc->rsc_copy;
+
 	/* count the number of notify-ids */
 	rproc->max_notifyid = -1;
-	ret = rproc_handle_resource(rproc, table, tablesz,
-						rproc_handle_notifyid_rsc);
-
-	/* look for virtio devices and register them */
-	ret = rproc_handle_resource(rproc, table, tablesz,
-						rproc_handle_vdev_rsc);
+	ret = rproc_handle_resource(rproc, tablesz, rproc_handle_notifyid_rsc);
 	if (ret)
 		goto out;
 
+	/* look for virtio devices and register them */
+	ret = rproc_handle_resource(rproc, tablesz, rproc_handle_vdev_rsc);
+
 out:
 	release_firmware(fw);
 	/* allow rproc_del() contexts, if any, to proceed */
@@ -930,6 +978,9 @@ int rproc_trigger_recovery(struct rproc *rproc)
 	/* wait until there is no more rproc users */
 	wait_for_completion(&rproc->crash_comp);
 
+	/* Free the copy of the resource table */
+	kfree(rproc->rsc_copy);
+
 	return rproc_add_virtio_devices(rproc);
 }
 
@@ -1085,6 +1136,9 @@ void rproc_shutdown(struct rproc *rproc)
 
 	rproc_disable_iommu(rproc);
 
+	/* Give the next start a clean resource table */
+	rproc->rsc = rproc->rsc_copy;
+
 	/* if in crash state, unlock crash handler */
 	if (rproc->state == RPROC_CRASHED)
 		complete_all(&rproc->crash_comp);
@@ -1296,6 +1350,9 @@ int rproc_del(struct rproc *rproc)
 	list_for_each_entry_safe(rvdev, tmp, &rproc->rvdevs, node)
 		rproc_remove_virtio_dev(rvdev);
 
+	/* Free the copy of the resource table */
+	kfree(rproc->rsc_copy);
+
 	device_del(&rproc->dev);
 
 	return 0;
diff --git a/include/linux/remoteproc.h b/include/linux/remoteproc.h
index faf3332..272f088 100644
--- a/include/linux/remoteproc.h
+++ b/include/linux/remoteproc.h
@@ -401,6 +401,9 @@ enum rproc_crash_type {
  * @crash_comp: completion used to sync crash handler and the rproc reload
  * @recovery_disabled: flag that state if recovery was disabled
  * @max_notifyid: largest allocated notify id.
+ * @rsc: resource table entry
+ * @rsc_copy: copy of the resource table
+ * @rsc_csum: checksum of the resource table
  */
 struct rproc {
 	struct klist_node node;
@@ -429,9 +432,13 @@ struct rproc {
 	struct completion crash_comp;
 	bool recovery_disabled;
 	int max_notifyid;
+	struct resource_table *rsc;
+	struct resource_table *rsc_copy;
+	u32 rsc_csum;
 };
 
 /* we currently support only two vrings per rvdev */
+
 #define RVDEV_NUM_VRINGS 2
 
 /**
@@ -464,6 +471,7 @@ struct rproc_vring {
  * @vring: the vrings for this vdev
  * @dfeatures: virtio device features
  * @gfeatures: virtio guest features
+ * @rsc_offset: offset of the vdev's resource entry
  */
 struct rproc_vdev {
 	struct list_head node;
@@ -472,6 +480,7 @@ struct rproc_vdev {
 	struct rproc_vring vring[RVDEV_NUM_VRINGS];
 	unsigned long dfeatures;
 	unsigned long gfeatures;
+	u32 rsc_offset;
 };
 
 struct rproc *rproc_alloc(struct device *dev, const char *name,
-- 
1.7.5.4

