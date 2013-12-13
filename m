Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab3LMW3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:29:17 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:41828 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273Ab3LMW23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:28:29 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 090/115] ion: add test device for unit tests to interact with dma_bufs
Date: Fri, 13 Dec 2013 14:25:04 -0800
Message-Id: <1386973529-4884-91-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

Add a /dev/ion-test device that will be created if CONFIG_ION_TEST
is set.  The device accepts a dma_buf fd and allows reading and
writing to the backing memory using DMA-like apis or kernel mapping
apis.  Can be used to test the dma_buf mapping ops, including
the ion implementations, from userspace.

Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/Kconfig     |   7 +
 drivers/staging/android/ion/Makefile    |   1 +
 drivers/staging/android/ion/ion_test.c  | 281 ++++++++++++++++++++++++++++++++
 drivers/staging/android/uapi/ion_test.h |  71 ++++++++
 4 files changed, 360 insertions(+)
 create mode 100644 drivers/staging/android/ion/ion_test.c
 create mode 100644 drivers/staging/android/uapi/ion_test.h

diff --git a/drivers/staging/android/ion/Kconfig b/drivers/staging/android/ion/Kconfig
index c62f2cb..6a5d8cf 100644
--- a/drivers/staging/android/ion/Kconfig
+++ b/drivers/staging/android/ion/Kconfig
@@ -6,6 +6,13 @@ menuconfig ION
 	help
 	  Chose this option to enable the ION Memory Manager.
 
+config ION_TEST
+	tristate "Ion Test Device"
+	depends on ION
+	help
+	  Choose this option to create a device that can be used to test the
+	  kernel and device side ION functions.
+
 config ION_TEGRA
 	tristate "Ion for Tegra"
 	depends on ARCH_TEGRA && ION
diff --git a/drivers/staging/android/ion/Makefile b/drivers/staging/android/ion/Makefile
index 9c95665..75039b9 100644
--- a/drivers/staging/android/ion/Makefile
+++ b/drivers/staging/android/ion/Makefile
@@ -1,5 +1,6 @@
 obj-$(CONFIG_ION) +=	ion.o ion_heap.o ion_page_pool.o ion_system_heap.o \
 			ion_carveout_heap.o ion_chunk_heap.o ion_cma_heap.o
+obj-$(CONFIG_ION_TEST) += ion_test.o
 ifdef CONFIG_COMPAT
 obj-$(CONFIG_ION) += compat_ion.o
 endif
diff --git a/drivers/staging/android/ion/ion_test.c b/drivers/staging/android/ion/ion_test.c
new file mode 100644
index 0000000..3e20349
--- /dev/null
+++ b/drivers/staging/android/ion/ion_test.c
@@ -0,0 +1,281 @@
+/*
+ *
+ * Copyright (C) 2013 Google, Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#define pr_fmt(fmt) "ion-test: " fmt
+
+#include <linux/dma-buf.h>
+#include <linux/dma-direction.h>
+#include <linux/fs.h>
+#include <linux/miscdevice.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <linux/vmalloc.h>
+
+#include "ion.h"
+#include "../uapi/ion_test.h"
+
+#define u64_to_uptr(x) ((void __user *)(unsigned long)(x))
+
+struct ion_test_device {
+	struct miscdevice misc;
+};
+
+struct ion_test_data {
+	struct dma_buf *dma_buf;
+	struct device *dev;
+};
+
+static int ion_handle_test_dma(struct device *dev, struct dma_buf *dma_buf,
+		void __user *ptr, size_t offset, size_t size, bool write)
+{
+	int ret = 0;
+	struct dma_buf_attachment *attach;
+	struct sg_table *table;
+	pgprot_t pgprot = pgprot_writecombine(PAGE_KERNEL);
+	enum dma_data_direction dir = write ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
+	struct sg_page_iter sg_iter;
+	unsigned long offset_page;
+
+	attach = dma_buf_attach(dma_buf, dev);
+	if (IS_ERR(attach))
+		return PTR_ERR(attach);
+
+	table = dma_buf_map_attachment(attach, dir);
+	if (IS_ERR(table))
+		return PTR_ERR(table);
+
+	offset_page = offset >> PAGE_SHIFT;
+	offset %= PAGE_SIZE;
+
+	for_each_sg_page(table->sgl, &sg_iter, table->nents, offset_page) {
+		struct page *page = sg_page_iter_page(&sg_iter);
+		void *vaddr = vmap(&page, 1, VM_MAP, pgprot);
+		size_t to_copy = PAGE_SIZE - offset;
+
+		to_copy = min(to_copy, size);
+		if (!vaddr) {
+			ret = -ENOMEM;
+			goto err;
+		}
+
+		if (write)
+			ret = copy_from_user(vaddr + offset, ptr, to_copy);
+		else
+			ret = copy_to_user(ptr, vaddr + offset, to_copy);
+
+		vunmap(vaddr);
+		if (ret) {
+			ret = -EFAULT;
+			goto err;
+		}
+		size -= to_copy;
+		if (!size)
+			break;
+		ptr += to_copy;
+		offset = 0;
+	}
+
+err:
+	dma_buf_unmap_attachment(attach, table, dir);
+	dma_buf_detach(dma_buf, attach);
+	return ret;
+}
+
+static int ion_handle_test_kernel(struct dma_buf *dma_buf, void __user *ptr,
+		size_t offset, size_t size, bool write)
+{
+	int ret;
+	unsigned long page_offset = offset >> PAGE_SHIFT;
+	size_t copy_offset = offset % PAGE_SIZE;
+	size_t copy_size = size;
+	enum dma_data_direction dir = write ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
+
+	if (offset > dma_buf->size || size > dma_buf->size - offset)
+		return -EINVAL;
+
+	ret = dma_buf_begin_cpu_access(dma_buf, offset, size, dir);
+	if (ret)
+		return ret;
+
+	while (copy_size > 0) {
+		size_t to_copy;
+		void *vaddr = dma_buf_kmap(dma_buf, page_offset);
+
+		if (!vaddr)
+			goto err;
+
+		to_copy = min_t(size_t, PAGE_SIZE - copy_offset, copy_size);
+
+		if (write)
+			ret = copy_from_user(vaddr + copy_offset, ptr, to_copy);
+		else
+			ret = copy_to_user(ptr, vaddr + copy_offset, to_copy);
+
+		dma_buf_kunmap(dma_buf, page_offset, vaddr);
+		if (ret) {
+			ret = -EFAULT;
+			goto err;
+		}
+
+		copy_size -= to_copy;
+		ptr += to_copy;
+		page_offset++;
+		copy_offset = 0;
+	}
+err:
+	dma_buf_end_cpu_access(dma_buf, offset, size, dir);
+	return ret;
+}
+
+static long ion_test_ioctl(struct file *filp, unsigned int cmd,
+						unsigned long arg)
+{
+	struct ion_test_data *test_data = filp->private_data;
+	int ret = 0;
+
+	union {
+		struct ion_test_rw_data test_rw;
+	} data;
+
+	if (_IOC_SIZE(cmd) > sizeof(data))
+		return -EINVAL;
+
+	if (_IOC_DIR(cmd) & _IOC_WRITE)
+		if (copy_from_user(&data, (void __user *)arg, _IOC_SIZE(cmd)))
+			return -EFAULT;
+
+	switch (cmd) {
+	case ION_IOC_TEST_SET_FD:
+	{
+		struct dma_buf *dma_buf = NULL;
+		int fd = arg;
+
+		if (fd >= 0) {
+			dma_buf = dma_buf_get((int)arg);
+			if (IS_ERR(dma_buf))
+				return PTR_ERR(dma_buf);
+		}
+		if (test_data->dma_buf)
+			dma_buf_put(test_data->dma_buf);
+		test_data->dma_buf = dma_buf;
+		break;
+	}
+	case ION_IOC_TEST_DMA_MAPPING:
+	{
+		ret = ion_handle_test_dma(test_data->dev, test_data->dma_buf,
+					u64_to_uptr(data.test_rw.ptr),
+					data.test_rw.offset, data.test_rw.size,
+					data.test_rw.write);
+		break;
+	}
+	case ION_IOC_TEST_KERNEL_MAPPING:
+	{
+		ret = ion_handle_test_kernel(test_data->dma_buf,
+					u64_to_uptr(data.test_rw.ptr),
+					data.test_rw.offset, data.test_rw.size,
+					data.test_rw.write);
+		break;
+	}
+	default:
+		return -ENOTTY;
+	}
+
+	if (_IOC_DIR(cmd) & _IOC_READ) {
+		if (copy_to_user((void __user *)arg, &data, sizeof(data)))
+			return -EFAULT;
+	}
+	return ret;
+}
+
+static int ion_test_open(struct inode *inode, struct file *file)
+{
+	struct ion_test_data *data;
+	struct miscdevice *miscdev = file->private_data;
+
+	data = kzalloc(sizeof(struct ion_test_data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	data->dev = miscdev->parent;
+
+	file->private_data = data;
+
+	return 0;
+}
+
+static int ion_test_release(struct inode *inode, struct file *file)
+{
+	struct ion_test_data *data = file->private_data;
+
+	kfree(data);
+
+	return 0;
+}
+
+static const struct file_operations ion_test_fops = {
+	.owner = THIS_MODULE,
+	.unlocked_ioctl = ion_test_ioctl,
+	.open = ion_test_open,
+	.release = ion_test_release,
+};
+
+static int __init ion_test_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct ion_test_device *testdev;
+
+	testdev = devm_kzalloc(&pdev->dev, sizeof(struct ion_test_device),
+				GFP_KERNEL);
+	if (!testdev)
+		return -ENOMEM;
+
+	testdev->misc.minor = MISC_DYNAMIC_MINOR;
+	testdev->misc.name = "ion-test";
+	testdev->misc.fops = &ion_test_fops;
+	testdev->misc.parent = &pdev->dev;
+	ret = misc_register(&testdev->misc);
+	if (ret) {
+		pr_err("failed to register misc device.\n");
+		return ret;
+	}
+
+	platform_set_drvdata(pdev, testdev);
+
+	return 0;
+}
+
+static struct platform_driver ion_test_platform_driver = {
+	.driver = {
+		.name = "ion-test",
+	},
+};
+
+static int __init ion_test_init(void)
+{
+	platform_device_register_simple("ion-test", -1, NULL, 0);
+	return platform_driver_probe(&ion_test_platform_driver, ion_test_probe);
+}
+
+static void __exit ion_test_exit(void)
+{
+	platform_driver_unregister(&ion_test_platform_driver);
+}
+
+module_init(ion_test_init);
+module_exit(ion_test_exit);
diff --git a/drivers/staging/android/uapi/ion_test.h b/drivers/staging/android/uapi/ion_test.h
new file mode 100644
index 0000000..352379a
--- /dev/null
+++ b/drivers/staging/android/uapi/ion_test.h
@@ -0,0 +1,71 @@
+/*
+ * drivers/staging/android/uapi/ion.h
+ *
+ * Copyright (C) 2011 Google, Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef _UAPI_LINUX_ION_TEST_H
+#define _UAPI_LINUX_ION_TEST_H
+
+#include <linux/ioctl.h>
+#include <linux/types.h>
+
+typedef int ion_user_handle_t;
+
+/**
+ * struct ion_test_rw_data - metadata passed to the kernel to read handle
+ * @ptr:	a pointer to an area at least as large as size
+ * @offset:	offset into the ion buffer to start reading
+ * @size:	size to read or write
+ * @write:	1 to write, 0 to read
+ */
+struct ion_test_rw_data {
+	__u64 ptr;
+	__u64 offset;
+	__u64 size;
+	int write;
+};
+
+#define ION_IOC_MAGIC		'I'
+
+/**
+ * DOC: ION_IOC_TEST_SET_DMA_BUF - attach a dma buf to the test driver
+ *
+ * Attaches a dma buf fd to the test driver.  Passing a second fd or -1 will
+ * release the first fd.
+ */
+#define ION_IOC_TEST_SET_FD \
+			_IO(ION_IOC_MAGIC, 0xf0)
+
+/**
+ * DOC: ION_IOC_TEST_DMA_MAPPING - read or write memory from a handle as DMA
+ *
+ * Reads or writes the memory from a handle using an uncached mapping.  Can be
+ * used by unit tests to emulate a DMA engine as close as possible.  Only
+ * expected to be used for debugging and testing, may not always be available.
+ */
+#define ION_IOC_TEST_DMA_MAPPING \
+			_IOW(ION_IOC_MAGIC, 0xf1, struct ion_test_rw_data)
+
+/**
+ * DOC: ION_IOC_TEST_KERNEL_MAPPING - read or write memory from a handle
+ *
+ * Reads or writes the memory from a handle using a kernel mapping.  Can be
+ * used by unit tests to test heap map_kernel functions.  Only expected to be
+ * used for debugging and testing, may not always be available.
+ */
+#define ION_IOC_TEST_KERNEL_MAPPING \
+			_IOW(ION_IOC_MAGIC, 0xf2, struct ion_test_rw_data)
+
+
+#endif /* _UAPI_LINUX_ION_H */
-- 
1.8.3.2

