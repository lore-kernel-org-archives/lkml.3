Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755Ab3LLOhu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 09:37:50 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:34596 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab3LLOht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 09:37:49 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Cc: dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org
Subject: [RFC] dma-buf: Implement test module
Date: Thu, 12 Dec 2013 15:36:29 +0100
Message-Id: <1386858989-1487-1-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a simple test module that can be used to allocate, export and
delete DMA-BUF objects. It can be used to test DMA-BUF sharing in
systems that lack a real second driver.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/base/Kconfig        |   4 +
 drivers/base/Makefile       |   1 +
 drivers/base/dma-buf-test.c | 308 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 313 insertions(+)
 create mode 100644 drivers/base/dma-buf-test.c

diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index e373671652b0..bed2abb9491b 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -200,6 +200,10 @@ config DMA_SHARED_BUFFER
 	  APIs extension; the file's descriptor can then be passed on to other
 	  driver.
 
+config DMA_BUF_TEST
+	tristate "DMA-BUF test module"
+	depends on DMA_SHARED_BUFFER
+
 config DMA_CMA
 	bool "DMA Contiguous Memory Allocator"
 	depends on HAVE_DMA_CONTIGUOUS && CMA
diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 94e8a80e87f8..cad983b6626f 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -25,3 +25,4 @@ obj-$(CONFIG_PINCTRL) += pinctrl.o
 
 ccflags-$(CONFIG_DEBUG_DRIVER) := -DDEBUG
 
+obj-$(CONFIG_DMA_BUF_TEST) += dma-buf-test.o
diff --git a/drivers/base/dma-buf-test.c b/drivers/base/dma-buf-test.c
new file mode 100644
index 000000000000..f5498b74a09b
--- /dev/null
+++ b/drivers/base/dma-buf-test.c
@@ -0,0 +1,308 @@
+#include <linux/dma-buf.h>
+#include <linux/err.h>
+#include <linux/fs.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+
+struct dmabuf_create {
+	__u32 flags;
+	__u32 size;
+};
+
+#define DMABUF_IOCTL_BASE	'D'
+#define DMABUF_IOCTL_CREATE	_IOWR(DMABUF_IOCTL_BASE, 0, struct dmabuf_create)
+#define DMABUF_IOCTL_DELETE	_IOWR(DMABUF_IOCTL_BASE, 1, int)
+#define DMABUF_IOCTL_EXPORT	_IOWR(DMABUF_IOCTL_BASE, 2, int)
+
+struct dmabuf_file {
+	struct dma_buf *buf;
+	dma_addr_t phys;
+	size_t size;
+	void *virt;
+};
+
+static int dmabuf_attach(struct dma_buf *buf, struct device *dev,
+			 struct dma_buf_attachment *attach)
+{
+	return 0;
+}
+
+static void dmabuf_detach(struct dma_buf *buf,
+			  struct dma_buf_attachment *attach)
+{
+}
+
+static struct sg_table *dmabuf_map_dma_buf(struct dma_buf_attachment *attach,
+					   enum dma_data_direction dir)
+{
+	struct dmabuf_file *priv = attach->dmabuf->priv;
+	struct sg_table *sgt;
+
+	sgt = kmalloc(sizeof(*sgt), GFP_KERNEL);
+	if (!sgt)
+		return NULL;
+
+	if (sg_alloc_table(sgt, 1, GFP_KERNEL)) {
+		kfree(sgt);
+		return NULL;
+	}
+
+	sg_dma_address(sgt->sgl) = priv->phys;
+	sg_dma_len(sgt->sgl) = priv->size;
+
+	return sgt;
+}
+
+static void dmabuf_unmap_dma_buf(struct dma_buf_attachment *attach,
+				 struct sg_table *sgt,
+				 enum dma_data_direction dir)
+{
+	sg_free_table(sgt);
+	kfree(sgt);
+}
+
+static void dmabuf_release(struct dma_buf *buf)
+{
+}
+
+static int dmabuf_begin_cpu_access(struct dma_buf *buf, size_t size,
+				   size_t length,
+				   enum dma_data_direction direction)
+{
+	return 0;
+}
+
+static void dmabuf_end_cpu_access(struct dma_buf *buf, size_t size,
+				  size_t length,
+				  enum dma_data_direction direction)
+{
+}
+
+static void *dmabuf_kmap_atomic(struct dma_buf *buf, unsigned long page)
+{
+	return NULL;
+}
+
+static void dmabuf_kunmap_atomic(struct dma_buf *buf, unsigned long page,
+				 void *vaddr)
+{
+}
+
+static void *dmabuf_kmap(struct dma_buf *buf, unsigned long page)
+{
+	return NULL;
+}
+
+static void dmabuf_kunmap(struct dma_buf *buf, unsigned long page, void *vaddr)
+{
+}
+
+static void dmabuf_vm_open(struct vm_area_struct *vma)
+{
+}
+
+static void dmabuf_vm_close(struct vm_area_struct *vma)
+{
+}
+
+static int dmabuf_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	return 0;
+}
+
+static const struct vm_operations_struct dmabuf_vm_ops = {
+	.open = dmabuf_vm_open,
+	.close = dmabuf_vm_close,
+	.fault = dmabuf_vm_fault,
+};
+
+static int dmabuf_mmap(struct dma_buf *buf, struct vm_area_struct *vma)
+{
+	pgprot_t prot = vm_get_page_prot(vma->vm_flags);
+	struct dmabuf_file *priv = buf->priv;
+
+	vma->vm_flags |= VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP;
+	vma->vm_ops = &dmabuf_vm_ops;
+	vma->vm_private_data = priv;
+	vma->vm_page_prot = pgprot_writecombine(prot);
+
+	return remap_pfn_range(vma, vma->vm_start, priv->phys >> PAGE_SHIFT,
+			       vma->vm_end - vma->vm_start, vma->vm_page_prot);
+}
+
+static void *dmabuf_vmap(struct dma_buf *buf)
+{
+	return NULL;
+}
+
+static void dmabuf_vunmap(struct dma_buf *buf, void *vaddr)
+{
+}
+
+static const struct dma_buf_ops dmabuf_ops = {
+	.attach = dmabuf_attach,
+	.detach = dmabuf_detach,
+	.map_dma_buf = dmabuf_map_dma_buf,
+	.unmap_dma_buf = dmabuf_unmap_dma_buf,
+	.release = dmabuf_release,
+	.begin_cpu_access = dmabuf_begin_cpu_access,
+	.end_cpu_access = dmabuf_end_cpu_access,
+	.kmap_atomic = dmabuf_kmap_atomic,
+	.kunmap_atomic = dmabuf_kunmap_atomic,
+	.kmap = dmabuf_kmap,
+	.kunmap = dmabuf_kunmap,
+	.mmap = dmabuf_mmap,
+	.vmap = dmabuf_vmap,
+	.vunmap = dmabuf_vunmap,
+};
+
+static int dmabuf_file_open(struct inode *inode, struct file *file)
+{
+	struct dmabuf_file *priv;
+	int ret = 0;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	file->private_data = priv;
+
+	return ret;
+}
+
+static int dmabuf_file_release(struct inode *inode, struct file *file)
+{
+	struct dmabuf_file *priv = file->private_data;
+	int ret = 0;
+
+	if (priv->virt)
+		dma_free_writecombine(NULL, priv->size, priv->virt, priv->phys);
+
+	if (priv->buf)
+		dma_buf_put(priv->buf);
+
+	kfree(priv);
+
+	return ret;
+}
+
+static int dmabuf_ioctl_create(struct dmabuf_file *priv, const void __user *data)
+{
+	struct dmabuf_create args;
+	int ret = 0;
+
+	if (priv->buf || priv->virt)
+		return -EBUSY;
+
+	if (copy_from_user(&args, data, sizeof(args)))
+		return -EFAULT;
+
+	priv->virt = dma_alloc_writecombine(NULL, args.size, &priv->phys,
+					    GFP_KERNEL | __GFP_NOWARN);
+	if (!priv->virt)
+		return -ENOMEM;
+
+	priv->buf = dma_buf_export(priv, &dmabuf_ops, args.size, args.flags);
+	if (!priv->buf) {
+		ret = -ENOMEM;
+		goto free;
+	}
+
+	if (IS_ERR(priv->buf)) {
+		ret = PTR_ERR(priv->buf);
+		goto free;
+	}
+
+	priv->size = args.size;
+
+	return 0;
+
+free:
+	dma_free_writecombine(NULL, priv->size, priv->virt, priv->phys);
+	priv->virt = NULL;
+	return ret;
+}
+
+static int dmabuf_ioctl_delete(struct dmabuf_file *priv, unsigned long flags)
+{
+	dma_free_writecombine(NULL, priv->size, priv->virt, priv->phys);
+	priv->virt = NULL;
+	priv->phys = 0;
+	priv->size = 0;
+
+	dma_buf_put(priv->buf);
+	priv->buf = NULL;
+
+	return 0;
+}
+
+static int dmabuf_ioctl_export(struct dmabuf_file *priv, unsigned long flags)
+{
+	int err;
+
+	get_dma_buf(priv->buf);
+
+	err = dma_buf_fd(priv->buf, flags);
+	if (err < 0)
+		dma_buf_put(priv->buf);
+
+	return err;
+}
+
+static long dmabuf_file_ioctl(struct file *file, unsigned int cmd,
+			      unsigned long arg)
+{
+	struct dmabuf_file *priv = file->private_data;
+	long ret = 0;
+
+	switch (cmd) {
+	case DMABUF_IOCTL_CREATE:
+		ret = dmabuf_ioctl_create(priv, (const void __user *)arg);
+		break;
+
+	case DMABUF_IOCTL_DELETE:
+		ret = dmabuf_ioctl_delete(priv, arg);
+		break;
+
+	case DMABUF_IOCTL_EXPORT:
+		ret = dmabuf_ioctl_export(priv, arg);
+		break;
+
+	default:
+		ret = -ENOTTY;
+		break;
+	}
+
+	return ret;
+}
+
+static const struct file_operations dmabuf_fops = {
+	.owner = THIS_MODULE,
+	.open = dmabuf_file_open,
+	.release = dmabuf_file_release,
+	.unlocked_ioctl = dmabuf_file_ioctl,
+};
+
+static struct miscdevice dmabuf_device = {
+	.minor = 128,
+	.name = "dmabuf",
+	.fops = &dmabuf_fops,
+};
+
+static int __init dmabuf_init(void)
+{
+	return misc_register(&dmabuf_device);
+}
+module_init(dmabuf_init);
+
+static void __exit dmabuf_exit(void)
+{
+	misc_deregister(&dmabuf_device);
+}
+module_exit(dmabuf_exit);
+
+MODULE_AUTHOR("Thierry Reding <treding@nvidia.com>");
+MODULE_DESCRIPTION("DMA-BUF test driver");
+MODULE_LICENSE("GPL v2");
-- 
1.8.4.2

