Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbaJJUIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 16:08:53 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:56922 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755108AbaJJUIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 16:08:51 -0400
From: Sumit Semwal <sumit.semwal@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linaro-kernel@lists.linaro.org,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [RFC 2/4] cenalloc: Constraint-Enabled Allocation helpers for dma-buf
Date: Sat, 11 Oct 2014 01:37:56 +0530
Message-Id: <1412971678-4457-3-git-send-email-sumit.semwal@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412971678-4457-1-git-send-email-sumit.semwal@linaro.org>
References: <1412971678-4457-1-git-send-email-sumit.semwal@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Devices sharing buffers using dma-buf could benefit from sharing their
constraints via struct device, and dma-buf framework would manage the
common constraints for all attached devices per buffer.

With that information, we could have a 'generic' allocator helper in
the form of a central dma-buf exporter, which can create dma-bufs, and
allocate backing storage at the time of first call to
dma_buf_map_attachment.

This allocation would utilise the constraint-mask by matching it to
the right allocator from a pool of allocators, and then allocating
buffer backing storage from this allocator.

The pool of allocators could be platform-dependent, allowing for
platforms to hide the specifics of these allocators from the devices
that access the dma-buf buffers.

A sample sequence could be:
- get handle to cenalloc_device,
- create a dmabuf using cenalloc_buffer_create;
- use this dmabuf to attach each device, which has its constraints
   set in the constraints mask (dev->dma_params->access_constraints_mask)
  - at each dma_buf_attach() call, dma-buf will check to see if the constraint
    mask for the device requesting attachment is compatible with the constraints
    of devices already attached to the dma-buf; returns an error if it isn't.
- after all devices have attached, the first call to dma_buf_map_attachment()
  will allocate the backing storage for the buffer.
- follow the dma-buf api for map / unmap etc usage.
- detach all attachments,
- call cenalloc_buffer_free to free the buffer if refcount reaches zero;

** IMPORTANT**
This mechanism of delayed allocation based on constraint-enablement will work
*ONLY IF* the first map_attachment() call is made AFTER all attach() calls are
done.

Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
Cc: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: linaro-mm-sig@lists.linaro.org
---
 MAINTAINERS                      |   1 +
 drivers/cenalloc/cenalloc.c      | 597 +++++++++++++++++++++++++++++++++++++++
 drivers/cenalloc/cenalloc.h      |  99 +++++++
 drivers/cenalloc/cenalloc_priv.h | 188 ++++++++++++
 4 files changed, 885 insertions(+)
 create mode 100644 drivers/cenalloc/cenalloc.c
 create mode 100644 drivers/cenalloc/cenalloc.h
 create mode 100644 drivers/cenalloc/cenalloc_priv.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 40d4796..e88ac81 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3039,6 +3039,7 @@ L:	linux-media@vger.kernel.org
 L:	dri-devel@lists.freedesktop.org
 L:	linaro-mm-sig@lists.linaro.org
 F:	drivers/dma-buf/
+F:	drivers/cenalloc/
 F:	include/linux/dma-buf*
 F:	include/linux/reservation.h
 F:	include/linux/*fence.h
diff --git a/drivers/cenalloc/cenalloc.c b/drivers/cenalloc/cenalloc.c
new file mode 100644
index 0000000..f278056
--- /dev/null
+++ b/drivers/cenalloc/cenalloc.c
@@ -0,0 +1,597 @@
+/*
+ * Allocator helper framework for constraints-aware dma-buf backing storage
+ * allocation.
+ * This allows constraint-sharing devices to deferred-allocate buffers shared
+ * via dma-buf.
+ *
+ * Copyright(C) 2014 Linaro Limited. All rights reserved.
+ * Author: Sumit Semwal <sumit.semwal@linaro.org>
+ *
+ * Structure for management of clients, buffers etc heavily derived from
+ * Android's ION framework.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/miscdevice.h>
+#include <linux/rbtree.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/debugfs.h>
+#include <linux/module.h>
+
+#include "cenalloc.h"
+#include "cenalloc_priv.h"
+
+/*
+ * Constraints-aware allocator framework helper is meant to facilitate
+ * deferred allocation of backing storage for dma-buf buffers.
+ * It works for devices that can share their constraints via dma_params.
+ * These dma_params are then used by dma_buf_attach() to create a mask of
+ * common constraints. The cenalloc constraint helpers then allocate
+ * for the preferred allocator according to the constraint mask.
+ * Allocators and their corresponding constraint masks are pre-populated
+ * for a given system - likely at the time of platform initialization.
+ */
+/**
+ * struct cenalloc_device - the metadata of the cenalloc device node
+ * @dev:			the actual misc device
+ * @buffers:		an rb tree of all the existing buffers
+ * @buffer_lock:	lock protecting the tree of buffers & handles
+ * @lock:			rwsem protecting the tree of allocators
+ * @clients:		list of all the clients created
+ * @allocators:		list of all the allocators in the system
+ */
+struct cenalloc_device {
+	struct miscdevice dev;
+	struct rb_root buffers;
+
+	struct mutex buffer_lock;
+	struct rw_semaphore lock;
+
+	struct plist_head allocators;
+
+};
+
+
+/* this function should only be called while dev->buffer_lock is held */
+static void cenalloc_buffer_add(struct cenalloc_device *dev,
+			   struct cenalloc_buffer *buffer)
+{
+	struct rb_node **p = &dev->buffers.rb_node;
+	struct rb_node *parent = NULL;
+	struct cenalloc_buffer *entry;
+
+	while (*p) {
+		parent = *p;
+		entry = rb_entry(parent, struct cenalloc_buffer, node);
+
+		if (buffer < entry) {
+			p = &(*p)->rb_left;
+		} else if (buffer > entry) {
+			p = &(*p)->rb_right;
+		} else {
+			pr_err("%s: buffer already found.", __func__);
+			BUG();
+		}
+	}
+
+	rb_link_node(&buffer->node, parent, p);
+	rb_insert_color(&buffer->node, &dev->buffers);
+}
+
+static struct dma_buf_ops ca_dma_buf_ops;
+
+static bool is_cenalloc_buffer(struct dma_buf *dmabuf);
+
+/*
+ * cenalloc_buffer_create creates a buffer, exports the dma-buf handle and
+ * associates a dma-buf handle with it.
+ * Returns:
+ *	on success, pointer to the associated dma_buf;
+ *	error if dma-buf cannot be exported or if it is out of memory.
+ */
+struct dma_buf *cenalloc_buffer_create(struct cenalloc_device *dev,
+				     unsigned long len,
+				     unsigned long align,
+				     unsigned long flags)
+{
+	struct cenalloc_buffer *buffer;
+	struct dma_buf *dmabuf;
+
+	buffer = kzalloc(sizeof(struct cenalloc_buffer), GFP_KERNEL);
+	if (!buffer)
+		return ERR_PTR(-ENOMEM);
+
+	buffer->flags = flags;
+	kref_init(&buffer->ref);
+
+	buffer->dev = dev;
+	buffer->size = len;
+	buffer->align = align;
+
+	dmabuf = dma_buf_export(buffer, &ca_dma_buf_ops, buffer->size, O_RDWR,
+							NULL);
+	if (IS_ERR(dmabuf))
+		goto err;
+
+	buffer->dmabuf = dmabuf;
+	dmabuf->priv = buffer;
+
+	mutex_init(&buffer->lock);
+
+	mutex_lock(&dev->buffer_lock);
+	cenalloc_buffer_add(dev, buffer);
+	mutex_unlock(&dev->buffer_lock);
+
+	return dmabuf;
+
+err:
+	kfree(buffer);
+	return ERR_CAST(dmabuf);
+}
+EXPORT_SYMBOL_GPL(cenalloc_buffer_create);
+
+
+static void cenalloc_buffer_destroy(struct cenalloc_buffer *buffer)
+{
+	if (WARN_ON(buffer->kmap_cnt > 0))
+		buffer->allocator->ops->unmap_kernel(buffer->allocator, buffer);
+	buffer->allocator->ops->unmap_dma(buffer->allocator, buffer);
+	buffer->allocator->ops->free(buffer);
+	kfree(buffer);
+}
+
+static void _cenalloc_buffer_destroy(struct cenalloc_buffer *buffer)
+{
+	struct cenalloc_device *dev = buffer->dev;
+
+	mutex_lock(&dev->buffer_lock);
+	rb_erase(&buffer->node, &dev->buffers);
+	mutex_unlock(&dev->buffer_lock);
+
+	cenalloc_buffer_destroy(buffer);
+}
+
+void cenalloc_buffer_free(struct dma_buf *dmabuf)
+{
+	if (is_cenalloc_buffer(dmabuf))
+			dma_buf_put(dmabuf);
+}
+EXPORT_SYMBOL_GPL(cenalloc_buffer_free);
+
+int cenalloc_phys(struct dma_buf *dmabuf,
+	     phys_addr_t *addr, size_t *len)
+{
+	struct cenalloc_buffer *buffer;
+	int ret;
+
+	if (is_cenalloc_buffer(dmabuf))
+		buffer = (struct cenalloc_buffer *)dmabuf->priv;
+	else
+		return -EINVAL;
+
+	if (!buffer->allocator->ops->phys) {
+		pr_err("%s: cenalloc_phys is not implemented by this allocator.\n",
+		       __func__);
+		return -ENODEV;
+	}
+	mutex_lock(&buffer->lock);
+	ret = buffer->allocator->ops->phys(buffer->allocator, buffer, addr,
+						len);
+	mutex_lock(&buffer->lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(cenalloc_phys);
+
+static void *cenalloc_buffer_kmap_get(struct cenalloc_buffer *buffer)
+{
+	void *vaddr;
+
+	if (buffer->kmap_cnt) {
+		buffer->kmap_cnt++;
+		return buffer->vaddr;
+	}
+	vaddr = buffer->allocator->ops->map_kernel(buffer->allocator, buffer);
+	if (WARN_ONCE(vaddr == NULL,
+		  "allocator->ops->map_kernel should return ERR_PTR on error"))
+		return ERR_PTR(-EINVAL);
+	if (IS_ERR(vaddr))
+		return vaddr;
+	buffer->vaddr = vaddr;
+	buffer->kmap_cnt++;
+	return vaddr;
+}
+
+static void cenalloc_buffer_kmap_put(struct cenalloc_buffer *buffer)
+{
+	buffer->kmap_cnt--;
+	if (!buffer->kmap_cnt) {
+		buffer->allocator->ops->unmap_kernel(buffer->allocator, buffer);
+		buffer->vaddr = NULL;
+	}
+}
+
+struct sg_table *cenalloc_sg_table(struct dma_buf *dmabuf)
+{
+	struct sg_table *table;
+	struct cenalloc_buffer *buffer;
+
+	if (is_cenalloc_buffer(dmabuf))
+		buffer = (struct cenalloc_buffer *)dmabuf->priv;
+	else {
+		pr_err("%s: invalid buffer passed to sg_table.\n",
+		       __func__);
+		return ERR_PTR(-EINVAL);
+	}
+
+	mutex_lock(&buffer->lock);
+	table = buffer->sg_table;
+	mutex_unlock(&buffer->lock);
+	return table;
+}
+EXPORT_SYMBOL_GPL(cenalloc_sg_table);
+
+/*
+ * dma_buf ops implementation
+ */
+
+static void cenalloc_buffer_sync_for_device(struct cenalloc_buffer *buffer,
+				       struct device *dev,
+				       enum dma_data_direction direction);
+
+/*
+ * This will find the right allocator for the buffer passed;
+ * assumption is, that all the interested importers have called dma_buf_attach()
+ * with their right constraint masks before the first call to
+ * dma_buf_map_attachment().
+ * At present, using the same priority based mechanism as ION.
+ */
+static int cenalloc_find_allocator(struct cenalloc_device *dev,
+				struct cenalloc_buffer *buf)
+{
+	struct cenalloc_allocator *allocator;
+	unsigned long constraints_mask = buf->dmabuf->access_constraints_mask;
+	size_t len = buf->size;
+
+	/*
+	 * traverse the list of allocators available in this system in priority
+	 * order.  If the allocator type is supported by the client, and matches
+	 * the request of the caller allocate from it.  Repeat until allocate
+	 * has succeeded or all allocators have been tried.
+	 */
+	len = PAGE_ALIGN(len);
+
+	if (!len)
+		return -EINVAL;
+
+	plist_for_each_entry(allocator, &dev->allocators, node) {
+		/* if the caller didn't specify this allocator id */
+		if (!((1 << allocator->id) & constraints_mask))
+			continue;
+		buf->allocator = allocator;
+	}
+
+	if (buf->allocator == NULL)
+		return -ENODEV;
+
+	return 0;
+}
+
+static struct sg_table *cenalloc_buffer_first_alloc(
+					struct cenalloc_buffer *buffer)
+{
+	struct cenalloc_allocator *allocator = buffer->allocator;
+	struct sg_table *table;
+
+	int num_pages = PAGE_ALIGN(buffer->size) / PAGE_SIZE;
+	struct scatterlist *sg;
+	int ret, i, j, k = 0;
+
+	mutex_lock(&buffer->lock);
+	ret = cenalloc_find_allocator(buffer->dev, buffer);
+
+	if (ret) {
+		mutex_unlock(&buffer->lock);
+		return ERR_PTR(-ENODEV);
+	}
+
+	ret = allocator->ops->allocate(allocator, buffer, buffer->size,
+						buffer->align, buffer->flags);
+	if (ret)
+		goto cannot_allocate;
+
+	table = allocator->ops->map_dma(allocator, buffer);
+	if (WARN_ONCE(table == NULL,
+		    "allocator->ops->map_dma should return ERR_PTR on error"))
+		table = ERR_PTR(-EINVAL);
+
+	if (IS_ERR(table)) {
+		/* TODO: find the right way to handle an error here? */
+		allocator->ops->free(buffer);
+
+		mutex_unlock(&buffer->lock);
+		return ERR_CAST(table);
+	}
+
+	buffer->pages = vmalloc(sizeof(struct page *) * num_pages);
+	if (!buffer->pages) {
+		ret = -ENOMEM;
+		goto cannot_allocate;
+	}
+
+	for_each_sg(table->sgl, sg, table->nents, i) {
+		struct page *page = sg_page(sg);
+
+		for (j = 0; j < sg->length / PAGE_SIZE; j++)
+			buffer->pages[k++] = page++;
+	}
+
+	mutex_unlock(&buffer->lock);
+
+	return table;
+
+cannot_allocate:
+	mutex_unlock(&buffer->lock);
+	return ERR_PTR(ret);
+}
+
+static void cenalloc_buffer_sync_for_device(struct cenalloc_buffer *buffer,
+				       struct device *dev,
+				       enum dma_data_direction dir)
+{
+
+	if (!buffer->allocator->ops->sync_for_device) {
+		pr_err("%s: this allocator does not define a method for sync-to-device\n",
+					__func__);
+		return;
+	}
+
+	buffer->allocator->ops->sync_for_device(buffer->allocator, buffer, dev,
+						dir);
+
+}
+
+/*
+ * cenalloc_map_dma_buf() models delayed allocation; so if the buffer is not
+ * backed up by storage, the allocation shall happen here for the first time,
+ * based on the constraint_mask of the dma_buf, which is set based on devices
+ * currently attached to the dma_buf.
+ *
+ * IMP: Assumption is that all participating devices call dma_buf_attach()
+ * before the first dma_buf_map_attachment() is called.
+ *
+ * Migration is not supported at this time.
+ */
+static struct sg_table *cenalloc_map_dma_buf(struct dma_buf_attachment *attach,
+					enum dma_data_direction direction)
+{
+	struct dma_buf *dmabuf = attach->dmabuf;
+	struct cenalloc_buffer *buffer = dmabuf->priv;
+	struct sg_table *table = NULL;
+
+	if (!buffer->sg_table) {
+		down_read(&(buffer->dev->lock));
+		table = cenalloc_buffer_first_alloc(buffer);
+		up_read(&(buffer->dev->lock));
+		if (IS_ERR(table))
+			return table;
+	}
+
+	mutex_lock(&buffer->lock);
+	buffer->sg_table = table;
+
+	cenalloc_buffer_sync_for_device(buffer, attach->dev, direction);
+	mutex_unlock(&buffer->lock);
+
+	return buffer->sg_table;
+
+}
+
+static void cenalloc_unmap_dma_buf(struct dma_buf_attachment *attachment,
+			      struct sg_table *table,
+			      enum dma_data_direction direction)
+{
+	struct dma_buf *dmabuf = attachment->dmabuf;
+	struct cenalloc_buffer *buffer = dmabuf->priv;
+
+	buffer->allocator->ops->unmap_dma(buffer->allocator, buffer);
+}
+
+static int cenalloc_mmap(struct dma_buf *dmabuf, struct vm_area_struct *vma)
+{
+	struct cenalloc_buffer *buffer = dmabuf->priv;
+	int ret = 0;
+
+	if (!buffer->sg_table) {
+		pr_err(
+			"%s: buffer needs to be mapped first before userspace mapping\n",
+			__func__);
+		return -EINVAL;
+	}
+
+	if (!buffer->allocator->ops->map_user) {
+		pr_err(
+			"%s: allocator does not define a method for userspace mapping\n",
+			__func__);
+		return -EINVAL;
+	}
+
+	/*
+	 * NOTE: For now, assume that the allocators will take care of any VMA
+	 * management for the buffer - includes providing vma_ops, and / or
+	 * managing mmap faults.
+	 * struct cenalloc_buffer will still provide struct **pages,
+	 * and also the vma area list for the buffer.
+	 * This also allows for device-specific vma operations.
+	 *
+	 */
+
+	mutex_lock(&buffer->lock);
+	/* now map it to userspace */
+	ret = buffer->allocator->ops->map_user(buffer->allocator, buffer, vma);
+	mutex_unlock(&buffer->lock);
+
+	if (ret)
+		pr_err("%s: failure mapping buffer to userspace\n",
+		       __func__);
+
+	return ret;
+}
+
+static void cenalloc_dma_buf_release(struct dma_buf *dmabuf)
+{
+	struct cenalloc_buffer *buffer = dmabuf->priv;
+
+	_cenalloc_buffer_destroy(buffer);
+}
+
+
+static void *cenalloc_dma_buf_kmap(struct dma_buf *dmabuf, unsigned long offset)
+{
+	struct cenalloc_buffer *buffer = dmabuf->priv;
+
+	return buffer->vaddr + offset * PAGE_SIZE;
+}
+
+static void cenalloc_dma_buf_kunmap(struct dma_buf *dmabuf,
+					unsigned long offset,
+					void *ptr)
+{
+	/* TODO */
+}
+
+static int cenalloc_dma_buf_begin_cpu_access(struct dma_buf *dmabuf,
+						size_t start, size_t len,
+						enum dma_data_direction dir)
+{
+	struct cenalloc_buffer *buffer = dmabuf->priv;
+	void *vaddr;
+
+	if (!buffer->allocator->ops->map_kernel) {
+		pr_err("%s: map kernel is not implemented by this allocator.\n",
+		       __func__);
+		return -ENODEV;
+	}
+
+	mutex_lock(&buffer->lock);
+	vaddr = cenalloc_buffer_kmap_get(buffer);
+	mutex_unlock(&buffer->lock);
+	return PTR_ERR_OR_ZERO(vaddr);
+}
+
+static void cenalloc_dma_buf_end_cpu_access(struct dma_buf *dmabuf,
+						size_t start, size_t len,
+						enum dma_data_direction dir)
+{
+	struct cenalloc_buffer *buffer = dmabuf->priv;
+
+	mutex_lock(&buffer->lock);
+	cenalloc_buffer_kmap_put(buffer);
+	mutex_unlock(&buffer->lock);
+}
+
+static struct dma_buf_ops ca_dma_buf_ops = {
+	.map_dma_buf = cenalloc_map_dma_buf,
+	.unmap_dma_buf = cenalloc_unmap_dma_buf,
+	.mmap = cenalloc_mmap,
+	.release = cenalloc_dma_buf_release,
+	.begin_cpu_access = cenalloc_dma_buf_begin_cpu_access,
+	.end_cpu_access = cenalloc_dma_buf_end_cpu_access,
+	.kmap = cenalloc_dma_buf_kmap,
+	.kunmap = cenalloc_dma_buf_kunmap,
+};
+
+static bool is_cenalloc_buffer(struct dma_buf *dmabuf)
+{
+	return(dmabuf->ops == &ca_dma_buf_ops);
+}
+
+/**
+ * cenalloc_device_add_allocator:
+ *	Adds an allocator to the cenalloc_device; This should be called at
+ *	platform initialization time, for all allocators for the platform.
+ */
+void cenalloc_device_add_allocator(struct cenalloc_device *dev,
+					struct cenalloc_allocator *allocator)
+{
+
+	if (!allocator->ops->allocate || !allocator->ops->free ||
+		!allocator->ops->map_dma || !allocator->ops->unmap_dma)
+		pr_err("%s: can not add allocator with invalid ops struct.\n",
+		       __func__);
+
+	allocator->dev = dev;
+	down_write(&dev->lock);
+	/* use negative allocator->id to reverse the priority -- when traversing
+	   the list later attempt higher id numbers first */
+	plist_node_init(&allocator->node, -allocator->id);
+	plist_add(&allocator->node, &dev->allocators);
+
+	up_write(&dev->lock);
+}
+EXPORT_SYMBOL_GPL(cenalloc_device_add_allocator);
+
+/*
+ * Device Init and Remove
+ */
+static struct cenalloc_device cenalloc_dev = {
+		.dev.minor = MISC_DYNAMIC_MINOR,
+		.dev.name = "cenalloc",
+		.dev.parent = NULL,
+};
+
+/*
+ * TODO: this mechanism of getting a cenalloc device isn't the best,
+ * Need to have a better way of getting handle to device.
+ */
+struct cenalloc_device *cenalloc_get_device(void)
+{
+	return &cenalloc_dev;
+}
+EXPORT_SYMBOL_GPL(cenalloc_get_device);
+
+static int __init cenalloc_device_init(void)
+{
+	int ret;
+
+	ret = misc_register(&cenalloc_dev.dev);
+	if (ret) {
+		pr_err("cenalloc: failed to register misc device.\n");
+		return ret;
+	}
+
+	cenalloc_dev.buffers = RB_ROOT;
+	mutex_init(&cenalloc_dev.buffer_lock);
+	init_rwsem(&cenalloc_dev.lock);
+	plist_head_init(&cenalloc_dev.allocators);
+	return ret;
+}
+
+static void __exit cenalloc_device_remove(void)
+{
+	misc_deregister(&cenalloc_dev.dev);
+
+	/* XXX need to free the allocators? */
+}
+
+module_init(cenalloc_device_init);
+module_exit(cenalloc_device_remove);
+
+MODULE_AUTHOR("Sumit Semwal <sumit.semwal@linaro.org>");
+MODULE_DESCRIPTION("Constraint Aware Central Allocation Helper");
+MODULE_LICENSE("GPL");
diff --git a/drivers/cenalloc/cenalloc.h b/drivers/cenalloc/cenalloc.h
new file mode 100644
index 0000000..91e07b2
--- /dev/null
+++ b/drivers/cenalloc/cenalloc.h
@@ -0,0 +1,99 @@
+/*
+ * Header file for  allocator helper framework for constraints-aware
+ * dma-buf backing storage allocation.
+ *
+ * Copyright(C) 2014 Linaro Limited. All rights reserved.
+ * Author: Sumit Semwal <sumit.semwal@linaro.org>
+ *
+ * Structure for management of device, buffers etc heavily derived from
+ * Android's ION framework.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef CENALLOC_H_
+#define CENALLOC_H_
+
+#include <linux/types.h>
+#include <linux/dma-buf.h>
+
+struct cenalloc_device;
+
+/**
+ * cenalloc_get_device:
+ *	gets a reference to cenalloc_device; this should be used in the
+ *	call to cenalloc_buffer_create.
+ *
+ * TODO: might need to have a better way of getting this device.
+ */
+const struct cenalloc_device *cenalloc_get_device(void);
+
+/**
+ * cenalloc_buffer_create:
+ *	creates a cenalloc_buffer, associates a dma_buf buffer with it,
+ *	and returns the dma_buf; other importers can then use references
+ *	to this dma_buf and attach themselves to it.
+ *
+ * Note: Since this is delayed-allocation model, no actual allocation
+ * will happen at this call.
+ *
+ * @dev:		cenalloc_device to create the buffer from
+ * @len:		size of the buffer
+ * @align:		alignment info, if any
+ * @flags:		flags for the buffer, if any
+ *
+ */
+struct dma_buf *cenalloc_buffer_create(struct cenalloc_device *dev,
+				     unsigned long len,
+				     unsigned long align,
+				     unsigned long flags);
+
+/**
+ * cenalloc_buffer_free:
+ *	calls dma_buf_put(), which in turn may call allocator->free()
+ *	if this was the last reference held.
+ *	For dma-bufs created with cenalloc_buffer_create, this should be
+ *	called instead of dma_buf_put() directly.
+ *
+ * @dma_buf:	the dma_buf to free.
+ */
+void cenalloc_buffer_free(struct dma_buf *dmabuf);
+
+/**
+ * cenalloc_phys:
+ *	returns the phys address and len associated with this buffer - this
+ *	will get refined as the ION 'abuse' of phys_addr_t is corrected.
+ *	This is valid only for buffers that are allocated from physically
+ *	contiguous memory; its output is invalid otherwise. For such cases,
+ *	cenalloc_sg_table() should be used instead.
+ *	Will return -EINVAL if the buffer is invalid.
+ *
+ * @dmabuf:		buffer for which phys address is needed
+ * @phys:		pointer to the phys address
+ * @len:		pointer to teh length of the buffer
+ *
+ */
+int cenalloc_phys(struct dma_buf *dmabuf,
+	     phys_addr_t *addr, size_t *len);
+
+/**
+ * cenalloc_sg_table:
+ *	returns the sg_table associated with the dma_buf.
+ *	Will return -EINVAL in case of error.
+ *
+ * @dmabuf:		handle to buffer who's sg_table is to be returned.
+ *
+ */
+struct sg_table *cenalloc_sg_table(struct dma_buf *dmabuf);
+
+#endif /* CENALLOC_H_ */
diff --git a/drivers/cenalloc/cenalloc_priv.h b/drivers/cenalloc/cenalloc_priv.h
new file mode 100644
index 0000000..31f5e59
--- /dev/null
+++ b/drivers/cenalloc/cenalloc_priv.h
@@ -0,0 +1,188 @@
+/*
+ * Private header file for  allocator helper framework for constraints-aware
+ * dma-buf backing storage allocation.
+ *
+ * Copyright(C) 2014 Linaro Limited. All rights reserved.
+ * Author: Sumit Semwal <sumit.semwal@linaro.org>
+ *
+ * Structure for management of clients, buffers etc heavily derived from
+ * Android's ION framework.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef CENALLOC_PRIV_H_
+#define CENALLOC_PRIV_H_
+
+#include <linux/device.h>
+#include <linux/dma-direction.h>
+#include <linux/kref.h>
+#include <linux/mm_types.h>
+#include <linux/mutex.h>
+#include <linux/rbtree.h>
+#include <linux/sched.h>
+#include <linux/types.h>
+
+#include "cenalloc.h"
+
+/**
+ * TODO: Find a better way to generate and manage allocator IDs
+ * For now, define a couple of allocator types
+ *
+ * @CENALLOC_ALLOCATOR_SYSTEM:		eg memory allocated via vmalloc
+ * @CENALLOC_ALLOCATOR_SYSTEM_CONTIG:	eg memory allocated via kmalloc
+ * @CENALLOC_NUM_ALLOCATORS:		helper for iterating over Allocators
+ *					a bit mask is used to identify the
+ *					allocators, so only 32 total allocator
+ *					types are supported
+ */
+#define CENALLOC_ALLOCATOR_SYSTEM		0x1
+#define	CENALLOC_ALLOCATOR_SYSTEM_CONTIG	(CENALLOC_ALLOCATOR_SYSTEM + 1)
+
+#define CENALLOC_NUM_ALLOCATORS			32
+
+#define CENALLOC_ALLOCATOR_SYSTEM_MASK		(1 << CENALLOC_ALLOCATOR_SYSTEM)
+#define CENALLOC_ALLOCATOR_SYSTEM_CONTIG_MASK	\
+					(1 << CENALLOC_ALLOCATOR_SYSTEM_CONTIG)
+
+
+struct cenalloc_device;
+/**
+ * struct cenalloc_buffer - metadata for a particular buffer
+ * @node:		node in the cenalloc_device buffers tree
+ * @dev:		back pointer to the cenalloc_device
+ * @allocator:		back pointer to the allocator the buffer came from
+ * @flags:		buffer specific flags
+ * @private_flags:	internal buffer specific flags
+ * @size:		size of the buffer
+ * @priv_virt:		private data to the buffer representable as
+ *			a void *
+ * @lock:		protects the buffers cnt fields
+ * @pages:		flat array of pages in the buffer -- used by fault
+ *			 handler and only valid for buffers that are faulted in
+ * @vmas:		list of vma's mapping this buffer
+ * @sg_table:		the sg table for the buffer if dmap_cnt is not zero
+ * @handle_count:	count of handles referencing this buffer
+*/
+struct cenalloc_buffer {
+	struct rb_node node;
+	struct cenalloc_device *dev;
+	struct cenalloc_allocator *allocator;
+	unsigned long flags;
+	unsigned long align;
+	unsigned long private_flags;
+
+	size_t size;
+
+	struct kref ref;
+	unsigned int kmap_cnt;
+	struct mutex lock;
+	void *vaddr;
+	struct page **pages;
+	struct list_head vmas;
+
+	struct sg_table *sg_table;
+	struct dma_buf *dmabuf;
+};
+
+/**
+ * struct cenalloc_allocator_ops - ops to operate on a given allocator
+ * @allocate:		allocate memory
+ * @free:		free memory
+ * @phys:		get physical address of a buffer (only define on
+ *			physically contiguous allocators)
+ * @map_dma:		map the memory for dma to a scatterlist
+ * @unmap_dma:		unmap the memory for dma
+ * @map_kernel:		map memory to the kernel
+ * @unmap_kernel:	unmap memory to the kernel
+ * @map_user:		map memory to userspace
+ * @sync_for_device:	sync the memory for device
+ *
+ * allocate, phys, and map_user return 0 on success, -errno on error.
+ * map_dma and map_kernel return pointer on success, ERR_PTR on
+ * error.
+ */
+struct cenalloc_allocator_ops {
+	int (*allocate)(struct cenalloc_allocator *allocator,
+			struct cenalloc_buffer *buffer, unsigned long len,
+			unsigned long align, unsigned long flags);
+	void (*free)(struct cenalloc_buffer *buffer);
+	int (*phys)(struct cenalloc_allocator *allocator,
+			struct cenalloc_buffer *buffer,
+			phys_addr_t *addr, size_t *len);
+	struct sg_table * (*map_dma)(struct cenalloc_allocator *allocator,
+					struct cenalloc_buffer *buffer);
+	void (*unmap_dma)(struct cenalloc_allocator *allocator,
+					struct cenalloc_buffer *buffer);
+	void * (*map_kernel)(struct cenalloc_allocator *allocator,
+					struct cenalloc_buffer *buffer);
+	void (*unmap_kernel)(struct cenalloc_allocator *allocator,
+					struct cenalloc_buffer *buffer);
+	int (*map_user)(struct cenalloc_allocator *mapper,
+					struct cenalloc_buffer *buffer,
+					struct vm_area_struct *vma);
+
+	void (*sync_for_device)(struct cenalloc_allocator *allocator,
+				struct cenalloc_buffer *buffer,
+				struct device *dev,
+				enum dma_data_direction dir);
+};
+
+/**
+ * struct cenalloc_allocator - represents a allocator in the system
+ * @node:		rb node to put the allocator on the device's tree of
+ *			allocators
+ * @dev:		back pointer to the cenalloc_device
+ * @type:		type of allocator
+ * @ops:		ops struct as above
+ * @flags:		flags
+ * @id:			id of allocator, also indicates priority of this
+ *			allocator when allocating. These MUST be unique.
+ * @name:		used for debugging
+ * @debug_show:		called when allocator debug file is read to add any
+ *			allocator specific debug info to output
+ *
+ * Represents a pool of memory from which buffers can be allocated.  In some
+ * systems the only allocator is regular system memory allocated via vmalloc.
+ * On others, some blocks might require large physically contiguous buffers
+ * that are allocated from a specially reserved allocator.
+ */
+struct cenalloc_allocator {
+	struct plist_node node;
+	struct cenalloc_device *dev;
+	unsigned long type;
+	struct cenalloc_allocator_ops *ops;
+	struct vm_operations_struct *vma_ops;
+	unsigned long flags;
+	unsigned int id;
+	const char *name;
+
+	int (*debug_show)(struct cenalloc_allocator *allocator,
+				struct seq_file *, void *);
+};
+
+/**
+ * cenalloc_device_add_allocator - adds an allocator to the cenalloc device
+ * @dev:	the device
+ * @allocator:	the allocator to add
+ */
+void cenalloc_device_add_allocator(struct cenalloc_device *dev,
+				struct cenalloc_allocator *allocator);
+
+/**
+ * TODO: add some helpers for common allocator operations on buffers;
+ * some candidates might be:
+ * cenalloc_allocator_{map_kernel, unmap_kernel, map_user}
+ * some vma_* management operations
+ */
+
+#endif /* CENALLOC_PRIV_H_ */
-- 
1.9.1

