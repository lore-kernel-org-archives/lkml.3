Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041AbaJJUIk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 16:08:40 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:57907 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907AbaJJUIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 16:08:38 -0400
From: Sumit Semwal <sumit.semwal@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linaro-kernel@lists.linaro.org,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [RFC 1/4] dma-buf: Add constraints sharing information
Date: Sat, 11 Oct 2014 01:37:55 +0530
Message-Id: <1412971678-4457-2-git-send-email-sumit.semwal@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412971678-4457-1-git-send-email-sumit.semwal@linaro.org>
References: <1412971678-4457-1-git-send-email-sumit.semwal@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At present, struct device lacks a mechanism of exposing memory
access constraints for the device.

Consequently, there is also no mechanism to share these constraints
while sharing buffers using dma-buf.

If we add support for sharing such constraints, we could use that
to try to collect requirements of different buffer-sharing devices
to allocate buffers from a pool that satisfies requirements of all
such devices.

This is an attempt to add this support; at the moment, only a bitmask
is added, but if post discussion, we realise we need more information,
we could always extend the definition of constraint.

A new dma-buf op is also added, to allow exporters to interpret or decide
on constraint-masks on their own. A default implementation is provided to
just AND (&) all the constraint-masks.

What constitutes a constraint-mask could be left for interpretation on a
per-platform basis, while defining some common masks.

Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
Cc: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: linaro-mm-sig@lists.linaro.org
---
 drivers/dma-buf/dma-buf.c | 50 ++++++++++++++++++++++++++++++++++++++++++-----
 include/linux/device.h    |  7 ++++++-
 include/linux/dma-buf.h   | 14 +++++++++++++
 3 files changed, 65 insertions(+), 6 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index f3014c4..33bdb6a 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -264,6 +264,30 @@ static inline int is_dma_buf_file(struct file *file)
 	return file->f_op == &dma_buf_fops;
 }
 
+/*
+ * def_calc_access_constraints - default implementation of constraint checking
+ */
+static int def_calc_access_constraints(struct dma_buf *dmabuf,
+		struct dma_buf_attachment *attach)
+{
+	unsigned long access_mask;
+
+	access_mask = attach->dev->dma_parms->access_constraints_mask;
+
+	if (!access_mask) {
+		pr_warn("%s dev has no access_constraints_mask; using default\n",
+				dev_name(attach->dev));
+		 access_mask = DMA_BUF_ALL_MEMORY_ACCESS_MASK;
+	}
+
+	dmabuf->access_constraints_mask &= access_mask;
+
+	if (!dmabuf->access_constraints_mask)
+		return -EINVAL;
+
+	return 0;
+}
+
 /**
  * dma_buf_export_named - Creates a new dma_buf, and associates an anon file
  * with this buffer, so it can be exported.
@@ -313,6 +337,8 @@ struct dma_buf *dma_buf_export_named(void *priv, const struct dma_buf_ops *ops,
 	dmabuf->ops = ops;
 	dmabuf->size = size;
 	dmabuf->exp_name = exp_name;
+	dmabuf->access_constraints_mask = DMA_BUF_ALL_MEMORY_ACCESS_MASK;
+
 	init_waitqueue_head(&dmabuf->poll);
 	dmabuf->cb_excl.poll = dmabuf->cb_shared.poll = &dmabuf->poll;
 	dmabuf->cb_excl.active = dmabuf->cb_shared.active = 0;
@@ -410,8 +436,10 @@ void dma_buf_put(struct dma_buf *dmabuf)
 EXPORT_SYMBOL_GPL(dma_buf_put);
 
 /**
- * dma_buf_attach - Add the device to dma_buf's attachments list; optionally,
- * calls attach() of dma_buf_ops to allow device-specific attach functionality
+ * dma_buf_attach - Add the device to dma_buf's attachments list;
+ *	calculates access_constraints and throws error if constraints aren't
+ *	satisfied. Optionally, calls attach() of dma_buf_ops to allow
+ *	device-specific attach functionality.
  * @dmabuf:	[in]	buffer to attach device to.
  * @dev:	[in]	device to be attached.
  *
@@ -436,11 +464,20 @@ struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
 
 	mutex_lock(&dmabuf->lock);
 
+	if (!dmabuf->ops->calc_access_constraints)
+		ret = def_calc_access_constraints(dmabuf, attach);
+	else
+		ret = dmabuf->ops->calc_access_constraints(dmabuf, attach);
+
+	if (ret)
+		goto err_attach;
+
 	if (dmabuf->ops->attach) {
 		ret = dmabuf->ops->attach(dmabuf, dev, attach);
 		if (ret)
 			goto err_attach;
 	}
+
 	list_add(&attach->node, &dmabuf->attachments);
 
 	mutex_unlock(&dmabuf->lock);
@@ -785,7 +822,7 @@ static int dma_buf_describe(struct seq_file *s)
 		return ret;
 
 	seq_puts(s, "\nDma-buf Objects:\n");
-	seq_puts(s, "size\tflags\tmode\tcount\texp_name\n");
+	seq_puts(s, "size\tflags\tmode\tcount\tconstraints\texp_name\n");
 
 	list_for_each_entry(buf_obj, &db_list.head, list_node) {
 		ret = mutex_lock_interruptible(&buf_obj->lock);
@@ -796,10 +833,11 @@ static int dma_buf_describe(struct seq_file *s)
 			continue;
 		}
 
-		seq_printf(s, "%08zu\t%08x\t%08x\t%08ld\t%s\n",
+		seq_printf(s, "%08zu\t%08x\t%08x\t%08ld\t%08lx\t%s\n",
 				buf_obj->size,
 				buf_obj->file->f_flags, buf_obj->file->f_mode,
 				(long)(buf_obj->file->f_count.counter),
+				buf_obj->access_constraints_mask,
 				buf_obj->exp_name);
 
 		seq_puts(s, "\tAttached Devices:\n");
@@ -808,7 +846,9 @@ static int dma_buf_describe(struct seq_file *s)
 		list_for_each_entry(attach_obj, &buf_obj->attachments, node) {
 			seq_puts(s, "\t");
 
-			seq_printf(s, "%s\n", dev_name(attach_obj->dev));
+			seq_printf(s, "%s\t:%lx\n",
+					dev_name(attach_obj->dev),
+			  attach_obj->dev->dma_parms->access_constraints_mask);
 			attach_count++;
 		}
 
diff --git a/include/linux/device.h b/include/linux/device.h
index a608e23..f9aefa2 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -647,6 +647,11 @@ struct device_dma_parameters {
 	 */
 	unsigned int max_segment_size;
 	unsigned long segment_boundary_mask;
+	/*
+	 * access_constraints_mask: this would be used to share constraints
+	 * about memories that this device can access.
+	 */
+	unsigned long access_constraints_mask;
 };
 
 struct acpi_device;
@@ -696,7 +701,7 @@ struct acpi_dev_node {
  * 		such descriptors.
  * @dma_pfn_offset: offset of DMA memory range relatively of RAM
  * @dma_parms:	A low level driver may set these to teach IOMMU code about
- * 		segment limitations.
+ *		segment limitations, and access constraints.
  * @dma_pools:	Dma pools (if dma'ble device).
  * @dma_mem:	Internal for coherent mem override.
  * @cma_area:	Contiguous memory area for dma allocations
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index 694e1fe..8429a38 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -37,6 +37,8 @@ struct device;
 struct dma_buf;
 struct dma_buf_attachment;
 
+#define DMA_BUF_ALL_MEMORY_ACCESS_MASK ((unsigned long)-1)
+
 /**
  * struct dma_buf_ops - operations possible on struct dma_buf
  * @attach: [optional] allows different devices to 'attach' themselves to the
@@ -44,6 +46,12 @@ struct dma_buf_attachment;
  *	    is already allocated and incompatible with the requirements
  *	    of requesting device.
  * @detach: [optional] detach a given device from this buffer.
+ * @calc_access_constraints(): [optional] will be called at the end of each
+ *		attach - to calculate and set the constraints for this dma_buf
+ *		according to this attachment's access_constraint_mask in
+ *		dev->dma_parms.
+ *		A default implementation is provided, but exporters are free to
+ *		provide	custom version if needed.
  * @map_dma_buf: returns list of scatter pages allocated, increases usecount
  *		 of the buffer. Requires atleast one attach to be called
  *		 before. Returned sg list should already be mapped into
@@ -77,6 +85,9 @@ struct dma_buf_ops {
 
 	void (*detach)(struct dma_buf *, struct dma_buf_attachment *);
 
+	int (*calc_access_constraints)(struct dma_buf *,
+			struct dma_buf_attachment *);
+
 	/* For {map,unmap}_dma_buf below, any specific buffer attributes
 	 * required should get added to device_dma_parameters accessible
 	 * via dev->dma_params.
@@ -86,6 +97,7 @@ struct dma_buf_ops {
 	void (*unmap_dma_buf)(struct dma_buf_attachment *,
 						struct sg_table *,
 						enum dma_data_direction);
+
 	/* TODO: Add try_map_dma_buf version, to return immed with -EBUSY
 	 * if the call would block.
 	 */
@@ -116,6 +128,7 @@ struct dma_buf_ops {
  * @ops: dma_buf_ops associated with this buffer object.
  * @exp_name: name of the exporter; useful for debugging.
  * @list_node: node for dma_buf accounting and debugging.
+ * @access_constraints_mask: mask to share access constraints.
  * @priv: exporter specific private data for this buffer object.
  * @resv: reservation object linked to this dma-buf
  */
@@ -130,6 +143,7 @@ struct dma_buf {
 	void *vmap_ptr;
 	const char *exp_name;
 	struct list_head list_node;
+	unsigned long access_constraints_mask;
 	void *priv;
 	struct reservation_object *resv;
 
-- 
1.9.1

