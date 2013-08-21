Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab3HURxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 13:53:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:18994 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964Ab3HURxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 13:53:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,929,1367996400"; 
   d="scan'208";a="366352466"
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Rob Landley <rob@landley.net>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux-doc@vger.kernel.org,
        Asias He <asias@redhat.com>
Cc: Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Caz Yokoyama <Caz.Yokoyama@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>
Subject: [PATCH v3 5/7] Intel MIC Host Driver Changes for Virtio Devices.
Date: Wed, 21 Aug 2013 10:52:35 -0700
Message-Id: <cc6933977b2884ea378f25f4608724a8db084d0c.1377104309.git.sudeep.dutt@intel.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1377104309.git.sudeep.dutt@intel.com>
References: <cover.1377104309.git.sudeep.dutt@intel.com>
In-Reply-To: <cover.1377104309.git.sudeep.dutt@intel.com>
References: <cover.1377104309.git.sudeep.dutt@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ashutosh Dixit <ashutosh.dixit@intel.com>

This patch introduces the host "Virtio over PCIe" interface for
Intel MIC. It allows creating user space backends on the host and instantiating
virtio devices for them on the Intel MIC card. It uses the existing VRINGH
infrastructure in the kernel to access virtio rings from the host. A character
device per MIC is exposed with IOCTL, mmap and poll callbacks. This allows the
user space backend to:
(a) add/remove a virtio device via a device page.
(b) map (R/O) virtio rings and device page to user space.
(c) poll for availability of data.
(d) copy a descriptor or entire descriptor chain to/from the card.
(e) modify virtio configuration.
(f) handle virtio device reset.
The buffers are copied over using CPU copies for this initial patch
and host initiated MIC DMA support is planned for future patches.
The avail and desc virtio rings are in host memory and the used ring
is in card memory to maximize writes across PCIe for performance.

Co-author: Sudeep Dutt <sudeep.dutt@intel.com>
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: Caz Yokoyama <Caz.Yokoyama@intel.com>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>
Signed-off-by: Nikhil Rao <nikhil.rao@intel.com>
Signed-off-by: Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>
Signed-off-by: Sudeep Dutt <sudeep.dutt@intel.com>
Acked-by: Yaozu (Eddie) Dong <eddie.dong@intel.com>
Reviewed-by: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
---
 drivers/misc/mic/Kconfig             |   1 +
 drivers/misc/mic/common/mic_device.h |   7 +
 drivers/misc/mic/host/Makefile       |   2 +
 drivers/misc/mic/host/mic_boot.c     |   3 +-
 drivers/misc/mic/host/mic_debugfs.c  | 140 +++++++
 drivers/misc/mic/host/mic_device.h   |   5 +
 drivers/misc/mic/host/mic_fops.c     | 221 +++++++++++
 drivers/misc/mic/host/mic_fops.h     |  32 ++
 drivers/misc/mic/host/mic_main.c     |  27 +-
 drivers/misc/mic/host/mic_virtio.c   | 704 +++++++++++++++++++++++++++++++++++
 drivers/misc/mic/host/mic_virtio.h   | 138 +++++++
 include/uapi/linux/Kbuild            |   1 +
 include/uapi/linux/mic_common.h      | 166 ++++++++-
 include/uapi/linux/mic_ioctl.h       |  74 ++++
 14 files changed, 1518 insertions(+), 3 deletions(-)
 create mode 100644 drivers/misc/mic/host/mic_fops.c
 create mode 100644 drivers/misc/mic/host/mic_fops.h
 create mode 100644 drivers/misc/mic/host/mic_virtio.c
 create mode 100644 drivers/misc/mic/host/mic_virtio.h
 create mode 100644 include/uapi/linux/mic_ioctl.h

diff --git a/drivers/misc/mic/Kconfig b/drivers/misc/mic/Kconfig
index 279a2e6..01f1a4a 100644
--- a/drivers/misc/mic/Kconfig
+++ b/drivers/misc/mic/Kconfig
@@ -3,6 +3,7 @@ comment "Intel MIC Host Driver"
 config INTEL_MIC_HOST
 	tristate "Intel MIC Host Driver"
 	depends on 64BIT && PCI
+	select VHOST_RING
 	default N
 	help
 	  This enables Host Driver support for the Intel Many Integrated
diff --git a/drivers/misc/mic/common/mic_device.h b/drivers/misc/mic/common/mic_device.h
index 6440e9d..01eb74f 100644
--- a/drivers/misc/mic/common/mic_device.h
+++ b/drivers/misc/mic/common/mic_device.h
@@ -41,4 +41,11 @@ struct mic_mw {
 #define MIC_DPLO_SPAD 14
 #define MIC_DPHI_SPAD 15
 
+/*
+ * These values are supposed to be in the config_change field of the
+ * device page when the host sends a config change interrupt to the card.
+ */
+#define MIC_VIRTIO_PARAM_DEV_REMOVE 0x1
+#define MIC_VIRTIO_PARAM_CONFIG_CHANGED 0x2
+
 #endif
diff --git a/drivers/misc/mic/host/Makefile b/drivers/misc/mic/host/Makefile
index 98bf565..e73ac74 100644
--- a/drivers/misc/mic/host/Makefile
+++ b/drivers/misc/mic/host/Makefile
@@ -9,3 +9,5 @@ mic_host-objs += mic_sysfs.o
 mic_host-objs += mic_smpt.o
 mic_host-objs += mic_boot.o
 mic_host-objs += mic_debugfs.o
+mic_host-objs += mic_fops.o
+mic_host-objs += mic_virtio.o
diff --git a/drivers/misc/mic/host/mic_boot.c b/drivers/misc/mic/host/mic_boot.c
index 936fc58..fd9ff6d 100644
--- a/drivers/misc/mic/host/mic_boot.c
+++ b/drivers/misc/mic/host/mic_boot.c
@@ -20,12 +20,12 @@
  */
 #include <linux/delay.h>
 #include <linux/firmware.h>
-#include <linux/interrupt.h>
 
 #include <linux/mic_common.h>
 #include "../common/mic_device.h"
 #include "mic_device.h"
 #include "mic_smpt.h"
+#include "mic_virtio.h"
 
 /**
  * mic_reset - Reset the MIC device.
@@ -117,6 +117,7 @@ void mic_stop(struct mic_device *mdev, bool force)
 {
 	mutex_lock(&mdev->mic_mutex);
 	if (MIC_OFFLINE != mdev->state || force) {
+		mic_virtio_reset_devices(mdev);
 		mic_bootparam_init(mdev);
 		mic_reset(mdev);
 		if (MIC_RESET_FAILED == mdev->state)
diff --git a/drivers/misc/mic/host/mic_debugfs.c b/drivers/misc/mic/host/mic_debugfs.c
index 904374e..440541f 100644
--- a/drivers/misc/mic/host/mic_debugfs.c
+++ b/drivers/misc/mic/host/mic_debugfs.c
@@ -27,6 +27,7 @@
 #include "mic_device.h"
 #include "mic_x100.h"
 #include "mic_smpt.h"
+#include "mic_virtio.h"
 
 /* Debugfs parent dir */
 static struct dentry *mic_dbg;
@@ -194,7 +195,13 @@ static const struct file_operations post_code_ops = {
 static int mic_dp_show(struct seq_file *s, void *pos)
 {
 	struct mic_device *mdev = s->private;
+	struct mic_device_desc *d;
+	struct mic_device_ctrl *dc;
+	struct mic_vqconfig *vqconfig;
+	__u32 *features;
+	__u8 *config;
 	struct mic_bootparam *bootparam = mdev->dp;
+	int i, j;
 
 	seq_printf(s, "Bootparam: magic 0x%x\n",
 		bootparam->magic);
@@ -209,6 +216,53 @@ static int mic_dp_show(struct seq_file *s, void *pos)
 	seq_printf(s, "Bootparam: shutdown_card %d\n",
 		bootparam->shutdown_card);
 
+	for (i = sizeof(*bootparam); i < MIC_DP_SIZE;
+	     i += mic_total_desc_size(d)) {
+		d = mdev->dp + i;
+		dc = (void *)d + mic_aligned_desc_size(d);
+
+		/* end of list */
+		if (d->type == 0)
+			break;
+
+		if (d->type == -1)
+			continue;
+
+		seq_printf(s, "Type %d ", d->type);
+		seq_printf(s, "Num VQ %d ", d->num_vq);
+		seq_printf(s, "Feature Len %d\n", d->feature_len);
+		seq_printf(s, "Config Len %d ", d->config_len);
+		seq_printf(s, "Shutdown Status %d\n", d->status);
+
+		for (j = 0; j < d->num_vq; j++) {
+			vqconfig = mic_vq_config(d) + j;
+			seq_printf(s, "vqconfig[%d]: ", j);
+			seq_printf(s, "address 0x%llx ", vqconfig->address);
+			seq_printf(s, "num %d ", vqconfig->num);
+			seq_printf(s, "used address 0x%llx\n",
+				vqconfig->used_address);
+		}
+
+		features = (__u32 *) mic_vq_features(d);
+		seq_printf(s, "Features: Host 0x%x ", features[0]);
+		seq_printf(s, "Guest 0x%x\n", features[1]);
+
+		config = mic_vq_configspace(d);
+		for (j = 0; j < d->config_len; j++)
+			seq_printf(s, "config[%d]=%d\n", j, config[j]);
+
+		seq_puts(s, "Device control:\n");
+		seq_printf(s, "Config Change %d ", dc->config_change);
+		seq_printf(s, "Vdev reset %d\n", dc->vdev_reset);
+		seq_printf(s, "Guest Ack %d ", dc->guest_ack);
+		seq_printf(s, "Host ack %d\n", dc->host_ack);
+		seq_printf(s, "Used address updated %d ",
+			dc->used_address_updated);
+		seq_printf(s, "Vdev 0x%llx\n", dc->vdev);
+		seq_printf(s, "c2h doorbell %d ", dc->c2h_vdev_db);
+		seq_printf(s, "h2c doorbell %d\n", dc->h2c_vdev_db);
+	}
+
 	return 0;
 }
 
@@ -230,6 +284,89 @@ static const struct file_operations dp_ops = {
 	.release = mic_dp_debug_release
 };
 
+static int mic_vdev_info_show(struct seq_file *s, void *unused)
+{
+	struct mic_device *mdev = s->private;
+	struct list_head *pos, *tmp;
+	struct mic_vdev *mvdev;
+	int i, j;
+
+	mutex_lock(&mdev->mic_mutex);
+	list_for_each_safe(pos, tmp, &mdev->vdev_list) {
+		mvdev = list_entry(pos, struct mic_vdev, list);
+		seq_printf(s, "VDEV type %d state %s in %ld out %ld\n",
+			mvdev->virtio_id,
+			mic_vdevup(mvdev) ? "UP" : "DOWN",
+			mvdev->in_bytes,
+			mvdev->out_bytes);
+		for (i = 0; i < MIC_MAX_VRINGS; i++) {
+			struct vring_desc *desc;
+			struct vring_avail *avail;
+			struct vring_used *used;
+			struct mic_vringh *mvr = &mvdev->mvr[i];
+			struct vringh *vrh = &mvr->vrh;
+			int num = vrh->vring.num;
+			if (!num)
+				continue;
+			desc = vrh->vring.desc;
+			seq_printf(s, "vring i %d avail_idx %d",
+				i, mvr->vring.info->avail_idx & (num - 1));
+			seq_printf(s, " vring i %d avail_idx %d\n",
+				i, mvr->vring.info->avail_idx);
+			seq_printf(s, "vrh i %d weak_barriers %d",
+				i, vrh->weak_barriers);
+			seq_printf(s, " last_avail_idx %d last_used_idx %d",
+				vrh->last_avail_idx, vrh->last_used_idx);
+			seq_printf(s, " completed %d\n", vrh->completed);
+			for (j = 0; j < num; j++) {
+				seq_printf(s, "desc[%d] addr 0x%llx len %d",
+					j, desc->addr, desc->len);
+				seq_printf(s, " flags 0x%x next %d\n",
+					desc->flags,
+					desc->next);
+				desc++;
+			}
+			avail = vrh->vring.avail;
+			seq_printf(s, "avail flags 0x%x idx %d\n",
+				avail->flags, avail->idx & (num - 1));
+			seq_printf(s, "avail flags 0x%x idx %d\n",
+				avail->flags, avail->idx);
+			for (j = 0; j < num; j++)
+				seq_printf(s, "avail ring[%d] %d\n",
+					j, avail->ring[j]);
+			used = vrh->vring.used;
+			seq_printf(s, "used flags 0x%x idx %d\n",
+				used->flags, used->idx & (num - 1));
+			seq_printf(s, "used flags 0x%x idx %d\n",
+				used->flags, used->idx);
+			for (j = 0; j < num; j++)
+				seq_printf(s, "used ring[%d] id %d len %d\n",
+					j, used->ring[j].id, used->ring[j].len);
+		}
+	}
+	mutex_unlock(&mdev->mic_mutex);
+
+	return 0;
+}
+
+static int mic_vdev_info_debug_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, mic_vdev_info_show, inode->i_private);
+}
+
+static int mic_vdev_info_debug_release(struct inode *inode, struct file *file)
+{
+	return single_release(inode, file);
+}
+
+static const struct file_operations vdev_info_ops = {
+	.owner   = THIS_MODULE,
+	.open    = mic_vdev_info_debug_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = mic_vdev_info_debug_release
+};
+
 static int mic_msi_irq_info_show(struct seq_file *s, void *pos)
 {
 	struct mic_device *mdev  = s->private;
@@ -322,6 +459,9 @@ void mic_create_debug_dir(struct mic_device *mdev)
 	debugfs_create_file("dp", 0444, mdev->dbg_dir,
 		mdev, &dp_ops);
 
+	debugfs_create_file("vdev_info", 0444, mdev->dbg_dir,
+		mdev, &vdev_info_ops);
+
 	debugfs_create_file("msi_irq_info", 0444, mdev->dbg_dir,
 		mdev, &msi_irq_info_ops);
 }
diff --git a/drivers/misc/mic/host/mic_device.h b/drivers/misc/mic/host/mic_device.h
index c2ca811..4592e7d 100644
--- a/drivers/misc/mic/host/mic_device.h
+++ b/drivers/misc/mic/host/mic_device.h
@@ -21,6 +21,7 @@
 #ifndef _MIC_DEVICE_H_
 #define _MIC_DEVICE_H_
 
+#include <linux/cdev.h>
 #include <linux/idr.h>
 
 /* The maximum number of MIC devices supported in a single host system. */
@@ -156,6 +157,8 @@ struct mic_irq;
  * @dp_dma_addr: virtio device page DMA address.
  * @shutdown_db: shutdown doorbell.
  * @shutdown_cookie: shutdown cookie.
+ * @cdev: Character device for MIC.
+ * @vdev_list: list of virtio devices.
  */
 struct mic_device {
 	struct mic_mw mmio;
@@ -189,6 +192,8 @@ struct mic_device {
 	dma_addr_t dp_dma_addr;
 	int shutdown_db;
 	struct mic_irq *shutdown_cookie;
+	struct cdev cdev;
+	struct list_head vdev_list;
 };
 
 /**
diff --git a/drivers/misc/mic/host/mic_fops.c b/drivers/misc/mic/host/mic_fops.c
new file mode 100644
index 0000000..661469a
--- /dev/null
+++ b/drivers/misc/mic/host/mic_fops.c
@@ -0,0 +1,221 @@
+/*
+ * Intel MIC Platform Software Stack (MPSS)
+ *
+ * Copyright(c) 2013 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * The full GNU General Public License is included in this distribution in
+ * the file called "COPYING".
+ *
+ * Intel MIC Host driver.
+ *
+ */
+#include <linux/poll.h>
+
+#include <linux/mic_common.h>
+#include "../common/mic_device.h"
+#include "mic_device.h"
+#include "mic_fops.h"
+#include "mic_virtio.h"
+
+int mic_open(struct inode *inode, struct file *f)
+{
+	struct mic_vdev *mvdev;
+	struct mic_device *mdev = container_of(inode->i_cdev,
+		struct mic_device, cdev);
+
+	mvdev = kzalloc(sizeof(*mvdev), GFP_KERNEL);
+	if (!mvdev)
+		return -ENOMEM;
+
+	init_waitqueue_head(&mvdev->waitq);
+	INIT_LIST_HEAD(&mvdev->list);
+	mvdev->mdev = mdev;
+	mvdev->virtio_id = -1;
+
+	f->private_data = mvdev;
+	return 0;
+}
+
+int mic_release(struct inode *inode, struct file *f)
+{
+	struct mic_vdev *mvdev = (struct mic_vdev *)f->private_data;
+
+	if (-1 != mvdev->virtio_id)
+		mic_virtio_del_device(mvdev);
+	f->private_data = NULL;
+	kfree(mvdev);
+	return 0;
+}
+
+long mic_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
+{
+	struct mic_vdev *mvdev = (struct mic_vdev *)f->private_data;
+	void __user *argp = (void __user *)arg;
+	int ret;
+
+	switch (cmd) {
+	case MIC_VIRTIO_ADD_DEVICE:
+	{
+		ret = mic_virtio_add_device(mvdev, argp);
+		if (ret < 0) {
+			dev_err(mic_dev(mvdev),
+				"%s %d errno ret %d\n",
+				__func__, __LINE__, ret);
+			return ret;
+		}
+		break;
+	}
+	case MIC_VIRTIO_COPY_DESC:
+	{
+		struct mic_copy_desc copy;
+
+		ret = mic_vdev_inited(mvdev);
+		if (ret)
+			return ret;
+
+		if (copy_from_user(&copy, argp, sizeof(copy)))
+			return -EFAULT;
+
+		dev_dbg(mic_dev(mvdev),
+			"%s %d === iovcnt 0x%x vr_idx 0x%x update_used %d\n",
+			__func__, __LINE__, copy.iovcnt, copy.vr_idx,
+			copy.update_used);
+
+		ret = mic_virtio_copy_desc(mvdev, &copy);
+		if (ret < 0) {
+			dev_err(mic_dev(mvdev),
+				"%s %d errno ret %d\n",
+				__func__, __LINE__, ret);
+			return ret;
+		}
+		if (copy_to_user(
+			&((struct mic_copy_desc __user *)argp)->out_len,
+			&copy.out_len, sizeof(copy.out_len))) {
+			dev_err(mic_dev(mvdev), "%s %d errno ret %d\n",
+				__func__, __LINE__, -EFAULT);
+			return -EFAULT;
+		}
+		break;
+	}
+	case MIC_VIRTIO_CONFIG_CHANGE:
+	{
+		ret = mic_vdev_inited(mvdev);
+		if (ret)
+			return ret;
+
+		ret = mic_virtio_config_change(mvdev, argp);
+		if (ret < 0) {
+			dev_err(mic_dev(mvdev),
+				"%s %d errno ret %d\n",
+				__func__, __LINE__, ret);
+			return ret;
+		}
+		break;
+	}
+	default:
+		return -ENOIOCTLCMD;
+	};
+	return 0;
+}
+
+/*
+ * We return POLLIN | POLLOUT from poll when new buffers are enqueued, and
+ * not when previously enqueued buffers may be available. This means that
+ * in the card->host (TX) path, when userspace is unblocked by poll it
+ * must drain all available descriptors or it can stall.
+ */
+unsigned int mic_poll(struct file *f, poll_table *wait)
+{
+	struct mic_vdev *mvdev = (struct mic_vdev *)f->private_data;
+	int mask = 0;
+
+	poll_wait(f, &mvdev->waitq, wait);
+
+	if (mic_vdev_inited(mvdev))
+		mask = POLLERR;
+	else if (mvdev->poll_wake) {
+		mvdev->poll_wake = 0;
+		mask = POLLIN | POLLOUT;
+	}
+
+	return mask;
+}
+
+static inline int
+mic_query_offset(struct mic_vdev *mvdev, unsigned long offset,
+	unsigned long *size, unsigned long *pa)
+{
+	struct mic_device *mdev = mvdev->mdev;
+	unsigned long start = MIC_DP_SIZE;
+	int i;
+
+	/*
+	 * MMAP interface is as follows:
+	 * offset				region
+	 * 0x0					virtio device_page
+	 * 0x1000				first vring
+	 * 0x1000 + size of 1st vring		second vring
+	 * ....
+	 */
+	if (!offset) {
+		*pa = virt_to_phys(mdev->dp);
+		*size = MIC_DP_SIZE;
+		return 0;
+	}
+
+	for (i = 0; i < mvdev->dd->num_vq; i++) {
+		struct mic_vringh *mvr = &mvdev->mvr[i];
+		if (offset == start) {
+			*pa = virt_to_phys(mvr->vring.va);
+			*size = mvr->vring.len;
+			return 0;
+		}
+		start += mvr->vring.len;
+	}
+	return -1;
+}
+
+/*
+ * Maps the device page and virtio rings to user space for readonly access.
+ */
+int
+mic_mmap(struct file *f, struct vm_area_struct *vma)
+{
+	struct mic_vdev *mvdev = (struct mic_vdev *)f->private_data;
+	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
+	unsigned long pa, size = vma->vm_end - vma->vm_start, size_rem = size;
+	int i, err;
+
+	err = mic_vdev_inited(mvdev);
+	if (err)
+		return err;
+
+	if (vma->vm_flags & VM_WRITE)
+		return -EACCES;
+
+	while (size_rem) {
+		i = mic_query_offset(mvdev, offset, &size, &pa);
+		if (i < 0)
+			return -EINVAL;
+		err = remap_pfn_range(vma, vma->vm_start + offset,
+			pa >> PAGE_SHIFT, size, vma->vm_page_prot);
+		if (err)
+			return err;
+		dev_dbg(mic_dev(mvdev),
+			"%s %d type %d size 0x%lx off 0x%lx pa 0x%lx vma 0x%lx\n",
+			__func__, __LINE__, mvdev->virtio_id, size, offset,
+			pa, vma->vm_start + offset);
+		size_rem -= size;
+		offset += size;
+	}
+	return 0;
+}
diff --git a/drivers/misc/mic/host/mic_fops.h b/drivers/misc/mic/host/mic_fops.h
new file mode 100644
index 0000000..dc3893d
--- /dev/null
+++ b/drivers/misc/mic/host/mic_fops.h
@@ -0,0 +1,32 @@
+/*
+ * Intel MIC Platform Software Stack (MPSS)
+ *
+ * Copyright(c) 2013 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * The full GNU General Public License is included in this distribution in
+ * the file called "COPYING".
+ *
+ * Intel MIC Host driver.
+ *
+ */
+#ifndef _MIC_FOPS_H_
+#define _MIC_FOPS_H_
+
+int mic_open(struct inode *inode, struct file *filp);
+int mic_release(struct inode *inode, struct file *filp);
+ssize_t mic_read(struct file *filp, char __user *buf,
+			size_t count, loff_t *pos);
+long mic_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
+int mic_mmap(struct file *f, struct vm_area_struct *vma);
+unsigned int mic_poll(struct file *f, poll_table *wait);
+
+#endif
diff --git a/drivers/misc/mic/host/mic_main.c b/drivers/misc/mic/host/mic_main.c
index 2f34a26..7c4f973 100644
--- a/drivers/misc/mic/host/mic_main.c
+++ b/drivers/misc/mic/host/mic_main.c
@@ -22,16 +22,18 @@
  * 1) Enable DMA support.
  * 2) Enable per vring interrupt support.
  */
-#include <linux/fs.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/poll.h>
 
 #include <linux/mic_common.h>
 #include "../common/mic_device.h"
 #include "mic_device.h"
 #include "mic_x100.h"
 #include "mic_smpt.h"
+#include "mic_fops.h"
+#include "mic_virtio.h"
 
 static const char mic_driver_name[] = "mic";
 
@@ -65,6 +67,15 @@ static struct class *g_mic_class;
 /* Base device node number for MIC devices */
 static dev_t g_mic_devno;
 
+static const struct file_operations mic_fops = {
+	.open = mic_open,
+	.release = mic_release,
+	.unlocked_ioctl = mic_ioctl,
+	.poll = mic_poll,
+	.mmap = mic_mmap,
+	.owner = THIS_MODULE,
+};
+
 /* Initialize the device page */
 static int mic_dp_init(struct mic_device *mdev)
 {
@@ -814,6 +825,7 @@ mic_device_init(struct mic_device *mdev, struct pci_dev *pdev)
 	mdev->irq_info.next_avail_src = 0;
 	INIT_WORK(&mdev->reset_trigger_work, mic_reset_trigger_work);
 	INIT_WORK(&mdev->shutdown_work, mic_shutdown_work);
+	INIT_LIST_HEAD(&mdev->vdev_list);
 }
 
 /**
@@ -951,7 +963,19 @@ static int mic_probe(struct pci_dev *pdev,
 	mic_bootparam_init(mdev);
 
 	mic_create_debug_dir(mdev);
+	cdev_init(&mdev->cdev, &mic_fops);
+	mdev->cdev.owner = THIS_MODULE;
+	rc = cdev_add(&mdev->cdev, MKDEV(MAJOR(g_mic_devno), mdev->id), 1);
+	if (rc) {
+		dev_err(&pdev->dev, "cdev_add err id %d rc %d\n", mdev->id, rc);
+		goto cleanup_debug_dir;
+	}
 	return 0;
+cleanup_debug_dir:
+	mic_delete_debug_dir(mdev);
+	mutex_lock(&mdev->mic_mutex);
+	mic_free_irq(mdev, mdev->shutdown_cookie, mdev);
+	mutex_unlock(&mdev->mic_mutex);
 dp_uninit:
 	mic_dp_uninit(mdev);
 sysfs_put:
@@ -996,6 +1020,7 @@ static void mic_remove(struct pci_dev *pdev)
 		return;
 
 	mic_stop(mdev, false);
+	cdev_del(&mdev->cdev);
 	mic_delete_debug_dir(mdev);
 	mutex_lock(&mdev->mic_mutex);
 	mic_free_irq(mdev, mdev->shutdown_cookie, mdev);
diff --git a/drivers/misc/mic/host/mic_virtio.c b/drivers/misc/mic/host/mic_virtio.c
new file mode 100644
index 0000000..1c0b777
--- /dev/null
+++ b/drivers/misc/mic/host/mic_virtio.c
@@ -0,0 +1,704 @@
+/*
+ * Intel MIC Platform Software Stack (MPSS)
+ *
+ * Copyright(c) 2013 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * The full GNU General Public License is included in this distribution in
+ * the file called "COPYING".
+ *
+ * Intel MIC Host driver.
+ *
+ */
+#include <linux/pci.h>
+#include <linux/sched.h>
+#include <linux/uaccess.h>
+
+#include <linux/mic_common.h>
+#include "../common/mic_device.h"
+#include "mic_device.h"
+#include "mic_smpt.h"
+#include "mic_virtio.h"
+
+/*
+ * Initiates the copies across the PCIe bus from card memory to
+ * a user space buffer.
+ */
+static int mic_virtio_copy_to_user(struct mic_vdev *mvdev,
+		void __user *ubuf, size_t len, u64 addr)
+{
+	int err;
+	void __iomem *dbuf = mvdev->mdev->aper.va + addr;
+	/*
+	 * We are copying from IO below an should ideally use something
+	 * like copy_to_user_fromio(..) if it existed.
+	 */
+	if (copy_to_user(ubuf, dbuf, len)) {
+		err = -EFAULT;
+		dev_err(mic_dev(mvdev), "%s %d err %d\n",
+			__func__, __LINE__, err);
+		goto err;
+	}
+	mvdev->in_bytes += len;
+	err = 0;
+err:
+	return err;
+}
+
+/*
+ * Initiates copies across the PCIe bus from a user space
+ * buffer to card memory.
+ */
+static int mic_virtio_copy_from_user(struct mic_vdev *mvdev,
+		void __user *ubuf, size_t len, u64 addr)
+{
+	int err;
+	void __iomem *dbuf = mvdev->mdev->aper.va + addr;
+	/*
+	 * We are copying to IO below and should ideally use something
+	 * like copy_from_user_toio(..) if it existed.
+	 */
+	if (copy_from_user(dbuf, ubuf, len)) {
+		err = -EFAULT;
+		dev_err(mic_dev(mvdev), "%s %d err %d\n",
+			__func__, __LINE__, err);
+		goto err;
+	}
+	mvdev->out_bytes += len;
+	err = 0;
+err:
+	return err;
+}
+
+#define MIC_VRINGH_READ true
+
+/* The function to call to notify the card about added buffers */
+static void mic_notify(struct vringh *vrh)
+{
+	struct mic_vringh *mvrh = container_of(vrh, struct mic_vringh, vrh);
+	struct mic_vdev *mvdev = mvrh->mvdev;
+	s8 db = mvdev->dc->h2c_vdev_db;
+
+	if (db != -1)
+		mvdev->mdev->ops->send_intr(mvdev->mdev, db);
+}
+
+/* Determine the total number of bytes consumed in a VRINGH KIOV */
+static inline u32 mic_vringh_iov_consumed(struct vringh_kiov *iov)
+{
+	int i;
+	u32 total = iov->consumed;
+
+	for (i = 0; i < iov->i; i++)
+		total += iov->iov[i].iov_len;
+	return total;
+}
+
+/*
+ * Traverse the VRINGH KIOV and issue the APIs to trigger the copies.
+ * This API is heavily based on the vringh_iov_xfer(..) implementation
+ * in vringh.c. The reason we cannot reuse vringh_iov_pull_kern(..)
+ * and vringh_iov_push_kern(..) directly is because there is no
+ * way to override the VRINGH xfer(..) routines as of v3.10.
+ */
+static int mic_vringh_copy(struct mic_vdev *mvdev, struct vringh_kiov *iov,
+	void __user *ubuf, size_t len, bool read, size_t *out_len)
+{
+	int ret = 0;
+	size_t partlen, tot_len = 0;
+
+	while (len && iov->i < iov->used) {
+		partlen = min(iov->iov[iov->i].iov_len, len);
+		if (read)
+			ret = mic_virtio_copy_to_user(mvdev,
+				ubuf, partlen,
+				(u64)iov->iov[iov->i].iov_base);
+		else
+			ret = mic_virtio_copy_from_user(mvdev,
+				ubuf, partlen,
+				(u64)iov->iov[iov->i].iov_base);
+		if (ret) {
+			dev_err(mic_dev(mvdev), "%s %d err %d\n",
+				__func__, __LINE__, ret);
+			break;
+		}
+		len -= partlen;
+		ubuf += partlen;
+		tot_len += partlen;
+		iov->consumed += partlen;
+		iov->iov[iov->i].iov_len -= partlen;
+		iov->iov[iov->i].iov_base += partlen;
+		if (!iov->iov[iov->i].iov_len) {
+			/* Fix up old iov element then increment. */
+			iov->iov[iov->i].iov_len = iov->consumed;
+			iov->iov[iov->i].iov_base -= iov->consumed;
+
+			iov->consumed = 0;
+			iov->i++;
+		}
+	}
+	*out_len = tot_len;
+	return ret;
+}
+
+/*
+ * Use the standard VRINGH infrastructure in the kernel to fetch new
+ * descriptors, initiate the copies and update the used ring.
+ */
+static int _mic_virtio_copy(struct mic_vdev *mvdev,
+	struct mic_copy_desc *copy)
+{
+	int ret = 0, iovcnt = copy->iovcnt;
+	struct iovec iov;
+	struct iovec __user *u_iov = copy->iov;
+	void __user *ubuf = NULL;
+	struct mic_vringh *mvr = &mvdev->mvr[copy->vr_idx];
+	struct vringh_kiov *riov = &mvr->riov;
+	struct vringh_kiov *wiov = &mvr->wiov;
+	struct vringh *vrh = &mvr->vrh;
+	u16 *head = &mvr->head;
+	struct mic_vring *vr = &mvr->vring;
+	size_t len = 0, out_len;
+
+	copy->out_len = 0;
+	/* Fetch a new IOVEC if all previous elements have been processed */
+	if (riov->i == riov->used && wiov->i == wiov->used) {
+		ret = vringh_getdesc_kern(vrh, riov, wiov,
+				head, GFP_KERNEL);
+		/* Check if there are available descriptors */
+		if (ret <= 0)
+			return ret;
+	}
+	while (iovcnt) {
+		if (!len) {
+			/* Copy over a new iovec from user space. */
+			ret = copy_from_user(&iov, u_iov, sizeof(*u_iov));
+			if (ret) {
+				ret = -EINVAL;
+				dev_err(mic_dev(mvdev), "%s %d err %d\n",
+					__func__, __LINE__, ret);
+				break;
+			}
+			len = iov.iov_len;
+			ubuf = iov.iov_base;
+		}
+		/* Issue all the read descriptors first */
+		ret = mic_vringh_copy(mvdev, riov, ubuf, len,
+			MIC_VRINGH_READ, &out_len);
+		if (ret) {
+			dev_err(mic_dev(mvdev), "%s %d err %d\n",
+					__func__, __LINE__, ret);
+			break;
+		}
+		len -= out_len;
+		ubuf += out_len;
+		copy->out_len += out_len;
+		/* Issue the write descriptors next */
+		ret = mic_vringh_copy(mvdev, wiov, ubuf, len,
+			!MIC_VRINGH_READ, &out_len);
+		if (ret) {
+			dev_err(mic_dev(mvdev), "%s %d err %d\n",
+					__func__, __LINE__, ret);
+			break;
+		}
+		len -= out_len;
+		ubuf += out_len;
+		copy->out_len += out_len;
+		if (!len) {
+			/* One user space iovec is now completed */
+			iovcnt--;
+			u_iov++;
+		}
+		/* Exit loop if all elements in KIOVs have been processed. */
+		if (riov->i == riov->used && wiov->i == wiov->used)
+			break;
+	}
+	/*
+	 * Update the used ring if a descriptor was available and some data was
+	 * copied in/out and the user asked for a used ring update.
+	 */
+	if (*head != USHRT_MAX && copy->out_len &&
+		copy->update_used) {
+		u32 total = 0;
+
+		/* Determine the total data consumed */
+		total += mic_vringh_iov_consumed(riov);
+		total += mic_vringh_iov_consumed(wiov);
+		vringh_complete_kern(vrh, *head, total);
+		*head = USHRT_MAX;
+		if (vringh_need_notify_kern(vrh) > 0)
+			vringh_notify(vrh);
+		vringh_kiov_cleanup(riov);
+		vringh_kiov_cleanup(wiov);
+		/* Update avail idx for user space */
+		vr->info->avail_idx = vrh->last_avail_idx;
+	}
+	return ret;
+}
+
+static inline int mic_verify_copy_args(struct mic_vdev *mvdev,
+		struct mic_copy_desc *copy)
+{
+	if (copy->vr_idx >= mvdev->dd->num_vq) {
+		dev_err(mic_dev(mvdev), "%s %d err %d\n",
+			__func__, __LINE__, -EINVAL);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+/* Copy a specified number of virtio descriptors in a chain */
+int mic_virtio_copy_desc(struct mic_vdev *mvdev,
+		struct mic_copy_desc *copy)
+{
+	int err;
+	struct mic_vringh *mvr = &mvdev->mvr[copy->vr_idx];
+
+	err = mic_verify_copy_args(mvdev, copy);
+	if (err)
+		return err;
+
+	mutex_lock(&mvr->vr_mutex);
+	if (!mic_vdevup(mvdev)) {
+		err = -ENODEV;
+		dev_err(mic_dev(mvdev), "%s %d err %d\n",
+			__func__, __LINE__, err);
+		goto err;
+	}
+	err = _mic_virtio_copy(mvdev, copy);
+	if (err) {
+		dev_err(mic_dev(mvdev), "%s %d err %d\n",
+			__func__, __LINE__, err);
+	}
+err:
+	mutex_unlock(&mvr->vr_mutex);
+	return err;
+}
+
+static void mic_virtio_init_post(struct mic_vdev *mvdev)
+{
+	struct mic_vqconfig *vqconfig = mic_vq_config(mvdev->dd);
+	int i;
+
+	for (i = 0; i < mvdev->dd->num_vq; i++) {
+		if (!le64_to_cpu(vqconfig[i].used_address)) {
+			dev_warn(mic_dev(mvdev), "used_address zero??\n");
+			continue;
+		}
+		mvdev->mvr[i].vrh.vring.used =
+			mvdev->mdev->aper.va +
+			le64_to_cpu(vqconfig[i].used_address);
+	}
+
+	mvdev->dc->used_address_updated = 0;
+
+	dev_dbg(mic_dev(mvdev), "%s: device type %d LINKUP\n",
+		__func__, mvdev->virtio_id);
+}
+
+static inline void mic_virtio_device_reset(struct mic_vdev *mvdev)
+{
+	int i;
+
+	dev_dbg(mic_dev(mvdev), "%s: status %d device type %d RESET\n",
+		__func__, mvdev->dd->status, mvdev->virtio_id);
+
+	for (i = 0; i < mvdev->dd->num_vq; i++)
+		/*
+		 * Avoid lockdep false positive. The + 1 is for the mic
+		 * mutex which is held in the reset devices code path.
+		 */
+		mutex_lock_nested(&mvdev->mvr[i].vr_mutex, i + 1);
+
+	/* 0 status means "reset" */
+	mvdev->dd->status = 0;
+	mvdev->dc->vdev_reset = 0;
+	mvdev->dc->host_ack = 1;
+
+	for (i = 0; i < mvdev->dd->num_vq; i++) {
+		struct vringh *vrh = &mvdev->mvr[i].vrh;
+		mvdev->mvr[i].vring.info->avail_idx = 0;
+		vrh->completed = 0;
+		vrh->last_avail_idx = 0;
+		vrh->last_used_idx = 0;
+	}
+
+	for (i = 0; i < mvdev->dd->num_vq; i++)
+		mutex_unlock(&mvdev->mvr[i].vr_mutex);
+}
+
+void mic_virtio_reset_devices(struct mic_device *mdev)
+{
+	struct list_head *pos, *tmp;
+	struct mic_vdev *mvdev;
+
+	dev_dbg(mdev->sdev->parent, "%s\n",  __func__);
+
+	WARN_ON(!mutex_is_locked(&mdev->mic_mutex));
+	list_for_each_safe(pos, tmp, &mdev->vdev_list) {
+		mvdev = list_entry(pos, struct mic_vdev, list);
+		mic_virtio_device_reset(mvdev);
+		mvdev->poll_wake = 1;
+		wake_up(&mvdev->waitq);
+	}
+}
+
+void mic_bh_handler(struct work_struct *work)
+{
+	struct mic_vdev *mvdev = container_of(work, struct mic_vdev,
+			virtio_bh_work);
+
+	if (mvdev->dc->used_address_updated)
+		mic_virtio_init_post(mvdev);
+
+	if (mvdev->dc->vdev_reset)
+		mic_virtio_device_reset(mvdev);
+
+	mvdev->poll_wake = 1;
+	wake_up(&mvdev->waitq);
+}
+
+static irqreturn_t mic_virtio_intr_handler(int irq, void *data)
+{
+
+	struct mic_vdev *mvdev = data;
+	struct mic_device *mdev = mvdev->mdev;
+
+	mdev->ops->ack_interrupt(mdev);
+	schedule_work(&mvdev->virtio_bh_work);
+	return IRQ_HANDLED;
+}
+
+int mic_virtio_config_change(struct mic_vdev *mvdev,
+			void __user *argp)
+{
+	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(wake);
+	int ret = 0, retry = 100, i;
+	struct mic_bootparam *bootparam = mvdev->mdev->dp;
+	s8 db = bootparam->h2c_config_db;
+
+	mutex_lock(&mvdev->mdev->mic_mutex);
+	for (i = 0; i < mvdev->dd->num_vq; i++)
+		mutex_lock_nested(&mvdev->mvr[i].vr_mutex, i + 1);
+
+	if (db == -1 || mvdev->dd->type == -1) {
+		ret = -EIO;
+		goto exit;
+	}
+
+	if (copy_from_user(mic_vq_configspace(mvdev->dd),
+				argp, mvdev->dd->config_len)) {
+		dev_err(mic_dev(mvdev), "%s %d err %d\n",
+			__func__, __LINE__, -EFAULT);
+		ret = -EFAULT;
+		goto exit;
+	}
+	mvdev->dc->config_change = MIC_VIRTIO_PARAM_CONFIG_CHANGED;
+	mvdev->mdev->ops->send_intr(mvdev->mdev, db);
+
+	for (i = retry; i--;) {
+		ret = wait_event_timeout(wake,
+			mvdev->dc->guest_ack, msecs_to_jiffies(100));
+		if (ret)
+			break;
+	}
+
+	dev_dbg(mic_dev(mvdev),
+		"%s %d retry: %d\n", __func__, __LINE__, retry);
+	mvdev->dc->config_change = 0;
+	mvdev->dc->guest_ack = 0;
+exit:
+	for (i = 0; i < mvdev->dd->num_vq; i++)
+		mutex_unlock(&mvdev->mvr[i].vr_mutex);
+	mutex_unlock(&mvdev->mdev->mic_mutex);
+	return ret;
+}
+
+static int mic_copy_dp_entry(struct mic_vdev *mvdev,
+					void __user *argp,
+					__u8 *type,
+					struct mic_device_desc **devpage)
+{
+	struct mic_device *mdev = mvdev->mdev;
+	struct mic_device_desc dd, *dd_config, *devp;
+	struct mic_vqconfig *vqconfig;
+	int ret = 0, i;
+	bool slot_found = false;
+
+	if (copy_from_user(&dd, argp, sizeof(dd))) {
+		dev_err(mic_dev(mvdev), "%s %d err %d\n",
+			__func__, __LINE__, -EFAULT);
+		return -EFAULT;
+	}
+
+	if (mic_aligned_desc_size(&dd) > MIC_MAX_DESC_BLK_SIZE
+		|| dd.num_vq > MIC_MAX_VRINGS) {
+		dev_err(mic_dev(mvdev), "%s %d err %d\n",
+			__func__, __LINE__, -EINVAL);
+		return -EINVAL;
+	}
+
+	dd_config = kmalloc(mic_desc_size(&dd), GFP_KERNEL);
+	if (dd_config == NULL) {
+		dev_err(mic_dev(mvdev), "%s %d err %d\n",
+			__func__, __LINE__, -ENOMEM);
+		return -ENOMEM;
+	}
+	if (copy_from_user(dd_config, argp, mic_desc_size(&dd))) {
+		ret = -EFAULT;
+		dev_err(mic_dev(mvdev), "%s %d err %d\n",
+			__func__, __LINE__, ret);
+		goto exit;
+	}
+
+	vqconfig = mic_vq_config(dd_config);
+	for (i = 0; i < dd.num_vq; i++) {
+		if (le16_to_cpu(vqconfig[i].num) > MIC_MAX_VRING_ENTRIES) {
+			ret =  -EINVAL;
+			dev_err(mic_dev(mvdev), "%s %d err %d\n",
+				__func__, __LINE__, ret);
+			goto exit;
+		}
+	}
+
+	/* Find the first free device page entry */
+	for (i = mic_aligned_size(struct mic_bootparam);
+		i < MIC_DP_SIZE - mic_total_desc_size(dd_config);
+		i += mic_total_desc_size(devp)) {
+		devp = mdev->dp + i;
+		if (devp->type == 0 || devp->type == -1) {
+			slot_found = true;
+			break;
+		}
+	}
+	if (!slot_found) {
+		ret =  -EINVAL;
+		dev_err(mic_dev(mvdev), "%s %d err %d\n",
+			__func__, __LINE__, ret);
+		goto exit;
+	}
+	/*
+	 * Save off the type before doing the memcpy. Type will be set in the
+	 * end after completing all initialization for the new device.
+	 */
+	*type = dd_config->type;
+	dd_config->type = 0;
+	memcpy(devp, dd_config, mic_desc_size(dd_config));
+
+	*devpage = devp;
+exit:
+	kfree(dd_config);
+	return ret;
+}
+
+static void mic_init_device_ctrl(struct mic_vdev *mvdev,
+				struct mic_device_desc *devpage)
+{
+	struct mic_device_ctrl *dc;
+
+	dc = mvdev->dc = (void *)devpage + mic_aligned_desc_size(devpage);
+
+	dc->config_change = 0;
+	dc->guest_ack = 0;
+	dc->vdev_reset = 0;
+	dc->host_ack = 0;
+	dc->used_address_updated = 0;
+	dc->c2h_vdev_db = -1;
+	dc->h2c_vdev_db = -1;
+}
+
+int mic_virtio_add_device(struct mic_vdev *mvdev,
+			void __user *argp)
+{
+	struct mic_device *mdev = mvdev->mdev;
+	struct mic_device_desc *dd;
+	struct mic_vqconfig *vqconfig;
+	int vr_size, i, j, ret;
+	u8 type;
+	s8 db;
+	char irqname[10];
+	struct mic_bootparam *bootparam = mdev->dp;
+	u16 num;
+
+	mutex_lock(&mdev->mic_mutex);
+
+	ret = mic_copy_dp_entry(mvdev, argp, &type, &dd);
+	if (ret) {
+		mutex_unlock(&mdev->mic_mutex);
+		return ret;
+	}
+
+	mic_init_device_ctrl(mvdev, dd);
+
+	mvdev->dd = dd;
+	mvdev->virtio_id = type;
+	vqconfig = mic_vq_config(dd);
+	INIT_WORK(&mvdev->virtio_bh_work, mic_bh_handler);
+
+	for (i = 0; i < dd->num_vq; i++) {
+		struct mic_vringh *mvr = &mvdev->mvr[i];
+		struct mic_vring *vr = &mvdev->mvr[i].vring;
+		num = le16_to_cpu(vqconfig[i].num);
+		mutex_init(&mvr->vr_mutex);
+		vr_size = PAGE_ALIGN(vring_size(num, MIC_VIRTIO_RING_ALIGN) +
+			sizeof(struct _mic_vring_info));
+		vr->va = (void *)
+			__get_free_pages(GFP_KERNEL | __GFP_ZERO,
+			get_order(vr_size));
+		if (!vr->va) {
+			ret = -ENOMEM;
+			dev_err(mic_dev(mvdev), "%s %d err %d\n",
+				__func__, __LINE__, ret);
+			goto err;
+		}
+		vr->len = vr_size;
+		vr->info = vr->va + vring_size(num, MIC_VIRTIO_RING_ALIGN);
+		vr->info->magic = MIC_MAGIC + mvdev->virtio_id + i;
+		vqconfig[i].address = mic_map_single(mdev,
+			vr->va, vr_size);
+		if (mic_map_error(vqconfig[i].address)) {
+			free_pages((unsigned long)vr->va,
+				get_order(vr_size));
+			ret = -ENOMEM;
+			dev_err(mic_dev(mvdev), "%s %d err %d\n",
+				__func__, __LINE__, ret);
+			goto err;
+		}
+		vqconfig[i].address = cpu_to_le64(vqconfig[i].address);
+
+		vring_init(&vr->vr, num,
+			vr->va, MIC_VIRTIO_RING_ALIGN);
+		ret = vringh_init_kern(&mvr->vrh,
+			*(u32 *)mic_vq_features(mvdev->dd), num, false,
+			vr->vr.desc, vr->vr.avail, vr->vr.used);
+		if (ret) {
+			dev_err(mic_dev(mvdev), "%s %d err %d\n",
+				__func__, __LINE__, ret);
+			goto err;
+		}
+		vringh_kiov_init(&mvr->riov, NULL, 0);
+		vringh_kiov_init(&mvr->wiov, NULL, 0);
+		mvr->head = USHRT_MAX;
+		mvr->mvdev = mvdev;
+		mvr->vrh.notify = mic_notify;
+		dev_dbg(mdev->sdev->parent,
+			"%s %d index %d va %p info %p vr_size 0x%x\n",
+			__func__, __LINE__, i, vr->va, vr->info, vr_size);
+	}
+
+	snprintf(irqname, sizeof(irqname),
+		"mic%dvirtio%d", mdev->id, mvdev->virtio_id);
+	mvdev->virtio_db = mic_next_db(mdev);
+	mvdev->virtio_cookie = mic_request_irq(mdev, mic_virtio_intr_handler,
+			irqname, mvdev, mvdev->virtio_db, MIC_INTR_DB);
+	if (IS_ERR(mvdev->virtio_cookie)) {
+		ret = PTR_ERR(mvdev->virtio_cookie);
+		dev_dbg(mdev->sdev->parent, "request irq failed\n");
+		goto err;
+	}
+
+	mvdev->dc->c2h_vdev_db = mvdev->virtio_db;
+
+	list_add_tail(&mvdev->list, &mdev->vdev_list);
+	/*
+	 * Order the type update with previous stores. This write barrier
+	 * is paired with the corresponding read barrier before the uncached
+	 * system memory read of the type, on the card while scanning the
+	 * device page.
+	 */
+	smp_wmb();
+	dd->type = type;
+
+	dev_dbg(mdev->sdev->parent, "Added virtio device id %d\n", dd->type);
+
+	db = bootparam->h2c_config_db;
+	if (db != -1)
+		mdev->ops->send_intr(mdev, db);
+	mutex_unlock(&mdev->mic_mutex);
+	return 0;
+err:
+	vqconfig = mic_vq_config(dd);
+	for (j = 0; j < i; j++) {
+		struct mic_vringh *mvr = &mvdev->mvr[j];
+		mic_unmap_single(mdev, le64_to_cpu(vqconfig[j].address),
+				mvr->vring.len);
+		free_pages((unsigned long)mvr->vring.va,
+			get_order(mvr->vring.len));
+	}
+	mutex_unlock(&mdev->mic_mutex);
+	return ret;
+}
+
+void mic_virtio_del_device(struct mic_vdev *mvdev)
+{
+	struct list_head *pos, *tmp;
+	struct mic_vdev *tmp_mvdev;
+	struct mic_device *mdev = mvdev->mdev;
+	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(wake);
+	int i, ret, retry = 100;
+	struct mic_vqconfig *vqconfig;
+	struct mic_bootparam *bootparam = mdev->dp;
+	s8 db;
+
+	mutex_lock(&mdev->mic_mutex);
+	db = bootparam->h2c_config_db;
+	if (db == -1)
+		goto skip_hot_remove;
+	dev_dbg(mdev->sdev->parent,
+		"Requesting hot remove id %d\n", mvdev->virtio_id);
+	mvdev->dc->config_change = MIC_VIRTIO_PARAM_DEV_REMOVE;
+	mdev->ops->send_intr(mdev, db);
+	for (i = retry; i--;) {
+		ret = wait_event_timeout(wake,
+			mvdev->dc->guest_ack, msecs_to_jiffies(100));
+		if (ret)
+			break;
+	}
+	dev_dbg(mdev->sdev->parent,
+		"Device id %d config_change %d guest_ack %d\n",
+		mvdev->virtio_id, mvdev->dc->config_change,
+		mvdev->dc->guest_ack);
+	mvdev->dc->config_change = 0;
+	mvdev->dc->guest_ack = 0;
+skip_hot_remove:
+	mic_free_irq(mdev, mvdev->virtio_cookie, mvdev);
+	flush_work(&mvdev->virtio_bh_work);
+	vqconfig = mic_vq_config(mvdev->dd);
+	for (i = 0; i < mvdev->dd->num_vq; i++) {
+		struct mic_vringh *mvr = &mvdev->mvr[i];
+		vringh_kiov_cleanup(&mvr->riov);
+		vringh_kiov_cleanup(&mvr->wiov);
+		mic_unmap_single(mdev, le64_to_cpu(vqconfig[i].address),
+				mvr->vring.len);
+		free_pages((unsigned long)mvr->vring.va,
+			get_order(mvr->vring.len));
+	}
+
+	list_for_each_safe(pos, tmp, &mdev->vdev_list) {
+		tmp_mvdev = list_entry(pos, struct mic_vdev, list);
+		if (tmp_mvdev == mvdev) {
+			list_del(pos);
+			dev_dbg(mdev->sdev->parent,
+				"Removing virtio device id %d\n",
+				mvdev->virtio_id);
+			break;
+		}
+	}
+	/*
+	 * Order the type update with previous stores. This write barrier
+	 * is paired with the corresponding read barrier before the uncached
+	 * system memory read of the type, on the card while scanning the
+	 * device page.
+	 */
+	smp_wmb();
+	mvdev->dd->type = -1;
+	mutex_unlock(&mdev->mic_mutex);
+}
diff --git a/drivers/misc/mic/host/mic_virtio.h b/drivers/misc/mic/host/mic_virtio.h
new file mode 100644
index 0000000..184f3c8
--- /dev/null
+++ b/drivers/misc/mic/host/mic_virtio.h
@@ -0,0 +1,138 @@
+/*
+ * Intel MIC Platform Software Stack (MPSS)
+ *
+ * Copyright(c) 2013 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * The full GNU General Public License is included in this distribution in
+ * the file called "COPYING".
+ *
+ * Intel MIC Host driver.
+ *
+ */
+#ifndef MIC_VIRTIO_H
+#define MIC_VIRTIO_H
+
+#include <linux/virtio_config.h>
+#include <linux/mic_ioctl.h>
+
+/*
+ * Note on endianness.
+ * 1. Host can be both BE or LE
+ * 2. Guest/card is LE. Host uses le_to_cpu to access desc/avail
+ *    rings and ioreadXX/iowriteXX to access used ring.
+ * 3. Device page exposed by host to guest contains LE values. Guest
+ *    accesses these using ioreadXX/iowriteXX etc. This way in general we
+ *    obey the virtio spec according to which guest works with native
+ *    endianness and host is aware of guest endianness and does all
+ *    required endianness conversion.
+ * 4. Data provided from user space to guest (in ADD_DEVICE and
+ *    CONFIG_CHANGE ioctl's) is not interpreted by the driver and should be
+ *    in guest endianness.
+ */
+
+/**
+ * struct mic_vringh - Virtio ring host information.
+ *
+ * @vring: The MIC vring used for setting up user space mappings.
+ * @vrh: The host VRINGH used for accessing the card vrings.
+ * @riov: The VRINGH read kernel IOV.
+ * @wiov: The VRINGH write kernel IOV.
+ * @head: The VRINGH head index address passed to vringh_getdesc_kern(..).
+ * @vr_mutex: Mutex for synchronizing access to the VRING.
+ * @mvdev: Back pointer to MIC virtio device for vringh_notify(..).
+ */
+struct mic_vringh {
+	struct mic_vring vring;
+	struct vringh vrh;
+	struct vringh_kiov riov;
+	struct vringh_kiov wiov;
+	u16 head;
+	struct mutex vr_mutex;
+	struct mic_vdev *mvdev;
+};
+
+/**
+ * struct mic_vdev - Host information for a card Virtio device.
+ *
+ * @virtio_id - Virtio device id.
+ * @waitq - Waitqueue to allow ring3 apps to poll.
+ * @mdev - Back pointer to host MIC device.
+ * @poll_wake - Used for waking up threads blocked in poll.
+ * @out_bytes - Debug stats for number of bytes copied from host to card.
+ * @in_bytes - Debug stats for number of bytes copied from card to host.
+ * @mvr - Store per VRING data structures.
+ * @virtio_bh_work - Work struct used to schedule virtio bottom half handling.
+ * @dd - Virtio device descriptor.
+ * @dc - Virtio device control fields.
+ * @list - List of Virtio devices.
+ * @virtio_db - The doorbell used by the card to interrupt the host.
+ * @virtio_cookie - The cookie returned while requesting interrupts.
+ */
+struct mic_vdev {
+	int virtio_id;
+	wait_queue_head_t waitq;
+	struct mic_device *mdev;
+	int poll_wake;
+	unsigned long out_bytes;
+	unsigned long in_bytes;
+	struct mic_vringh mvr[MIC_MAX_VRINGS];
+	struct work_struct virtio_bh_work;
+	struct mic_device_desc *dd;
+	struct mic_device_ctrl *dc;
+	struct list_head list;
+	int virtio_db;
+	struct mic_irq *virtio_cookie;
+};
+
+void mic_virtio_uninit(struct mic_device *mdev);
+int mic_virtio_add_device(struct mic_vdev *mvdev,
+			void __user *argp);
+void mic_virtio_del_device(struct mic_vdev *mvdev);
+int mic_virtio_config_change(struct mic_vdev *mvdev,
+			void __user *argp);
+int mic_virtio_copy_desc(struct mic_vdev *mvdev,
+	struct mic_copy_desc *request);
+void mic_virtio_reset_devices(struct mic_device *mdev);
+void mic_bh_handler(struct work_struct *work);
+
+/* Helper API to obtain the MIC PCIe device */
+static inline struct device *mic_dev(struct mic_vdev *mvdev)
+{
+	return mvdev->mdev->sdev->parent;
+}
+
+/* Helper API to check if a virtio device is initialized */
+static inline int mic_vdev_inited(struct mic_vdev *mvdev)
+{
+	/* Device has not been created yet */
+	if (!mvdev->dd || !mvdev->dd->type) {
+		dev_err(mic_dev(mvdev), "%s %d err %d\n",
+			__func__, __LINE__, -EINVAL);
+		return -EINVAL;
+	}
+
+	/* Device has been removed/deleted */
+	if (mvdev->dd->type == -1) {
+		dev_err(mic_dev(mvdev), "%s %d err %d\n",
+			__func__, __LINE__, -ENODEV);
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+/* Helper API to check if a virtio device is running */
+static inline bool mic_vdevup(struct mic_vdev *mvdev)
+{
+	return !!mvdev->dd->status;
+}
+#endif
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index e3f7b37..c73dbd0 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -241,6 +241,7 @@ header-y += mei.h
 header-y += mempolicy.h
 header-y += meye.h
 header-y += mic_common.h
+header-y += mic_ioctl.h
 header-y += mii.h
 header-y += minix_fs.h
 header-y += mman.h
diff --git a/include/uapi/linux/mic_common.h b/include/uapi/linux/mic_common.h
index a9091e5..364ac75 100644
--- a/include/uapi/linux/mic_common.h
+++ b/include/uapi/linux/mic_common.h
@@ -21,7 +21,60 @@
 #ifndef __MIC_COMMON_H_
 #define __MIC_COMMON_H_
 
-#include <linux/types.h>
+#include <linux/virtio_ring.h>
+
+#ifndef __KERNEL__
+#define ALIGN(a, x)	(((a) + (x) - 1) & ~((x) - 1))
+#define __aligned(x)	__attribute__ ((aligned(x)))
+#endif
+
+#define mic_aligned_size(x) ALIGN(sizeof(x), 8)
+
+/**
+ * struct mic_device_desc: Virtio device information shared between the
+ * virtio driver and userspace backend
+ *
+ * @type: Device type: console/network/disk etc.  Type 0/-1 terminates.
+ * @num_vq: Number of virtqueues.
+ * @feature_len: Number of bytes of feature bits.  Multiply by 2: one for
+   host features and one for guest acknowledgements.
+ * @config_len: Number of bytes of the config array after virtqueues.
+ * @status: A status byte, written by the Guest.
+ * @config: Start of the following variable length config.
+ */
+struct mic_device_desc {
+	__s8 type;
+	__u8 num_vq;
+	__u8 feature_len;
+	__u8 config_len;
+	__u8 status;
+	__u64 config[0];
+} __aligned(8);
+
+/**
+ * struct mic_device_ctrl: Per virtio device information in the device page
+ * used internally by the host and card side drivers.
+ *
+ * @vdev: Used for storing MIC vdev information by the guest.
+ * @config_change: Set to 1 by host when a config change is requested.
+ * @vdev_reset: Set to 1 by guest to indicate virtio device has been reset.
+ * @guest_ack: Set to 1 by guest to ack a command.
+ * @host_ack: Set to 1 by host to ack a command.
+ * @used_address_updated: Set to 1 by guest when the used address should be
+ * updated.
+ * @c2h_vdev_db: The doorbell number to be used by guest. Set by host.
+ * @h2c_vdev_db: The doorbell number to be used by host. Set by guest.
+ */
+struct mic_device_ctrl {
+	__u64 vdev;
+	__u8 config_change;
+	__u8 vdev_reset;
+	__u8 guest_ack;
+	__u8 host_ack;
+	__u8 used_address_updated;
+	__s8 c2h_vdev_db;
+	__s8 h2c_vdev_db;
+} __aligned(8);
 
 /**
  * struct mic_bootparam: Virtio device independent information in device page
@@ -42,6 +95,117 @@ struct mic_bootparam {
 	__u8 shutdown_card;
 } __aligned(8);
 
+/**
+ * struct mic_device_page: High level representation of the device page
+ *
+ * @bootparam: The bootparam structure is used for sharing information and
+ * status updates between MIC host and card drivers.
+ * @desc: Array of MIC virtio device descriptors.
+ */
+struct mic_device_page {
+	struct mic_bootparam bootparam;
+	struct mic_device_desc desc[0];
+};
+/**
+ * struct mic_vqconfig: This is how we expect the device configuration field
+ * for a virtqueue to be laid out in config space.
+ *
+ * @address: Guest/MIC physical address of the virtio ring
+ * (avail and desc rings)
+ * @used_address: Guest/MIC physical address of the used ring
+ * @num: The number of entries in the virtio_ring
+ */
+struct mic_vqconfig {
+	__u64 address;
+	__u64 used_address;
+	__u16 num;
+} __aligned(8);
+
+/*
+ * The alignment to use between consumer and producer parts of vring.
+ * This is pagesize for historical reasons.
+ */
+#define MIC_VIRTIO_RING_ALIGN		4096
+
+#define MIC_MAX_VRINGS			4
+#define MIC_VRING_ENTRIES		128
+
+/*
+ * Max vring entries (power of 2) to ensure desc and avail rings
+ * fit in a single page
+ */
+#define MIC_MAX_VRING_ENTRIES		128
+
+/**
+ * Max size of the desc block in bytes: includes:
+ *	- struct mic_device_desc
+ *	- struct mic_vqconfig (num_vq of these)
+ *	- host and guest features
+ *	- virtio device config space
+ */
+#define MIC_MAX_DESC_BLK_SIZE		256
+
+/**
+ * struct _mic_vring_info - Host vring info exposed to userspace backend
+ * for the avail index and magic for the card.
+ *
+ * @avail_idx: host avail idx
+ * @magic: A magic debug cookie.
+ */
+struct _mic_vring_info {
+	__u16 avail_idx;
+	int magic;
+};
+
+/**
+ * struct mic_vring - Vring information.
+ *
+ * @vr: The virtio ring.
+ * @info: Host vring information exposed to the userspace backend for the
+ * avail index and magic for the card.
+ * @va: The va for the buffer allocated for vr and info.
+ * @len: The length of the buffer required for allocating vr and info.
+ */
+struct mic_vring {
+	struct vring vr;
+	struct _mic_vring_info *info;
+	void *va;
+	int len;
+};
+
+#define mic_aligned_desc_size(d) ALIGN(mic_desc_size(d), 8)
+
+#ifndef INTEL_MIC_CARD
+static inline unsigned mic_desc_size(const struct mic_device_desc *desc)
+{
+	return mic_aligned_size(*desc)
+		+ desc->num_vq * mic_aligned_size(struct mic_vqconfig)
+		+ desc->feature_len * 2
+		+ desc->config_len;
+}
+
+static inline struct mic_vqconfig *
+mic_vq_config(const struct mic_device_desc *desc)
+{
+	return (struct mic_vqconfig *)(desc + 1);
+}
+
+static inline __u8 *mic_vq_features(const struct mic_device_desc *desc)
+{
+	return (__u8 *)(mic_vq_config(desc) + desc->num_vq);
+}
+
+static inline __u8 *mic_vq_configspace(const struct mic_device_desc *desc)
+{
+	return mic_vq_features(desc) + desc->feature_len * 2;
+}
+static inline unsigned mic_total_desc_size(struct mic_device_desc *desc)
+{
+	return mic_aligned_desc_size(desc) +
+		mic_aligned_size(struct mic_device_ctrl);
+}
+#endif
+
 /* Device page size */
 #define MIC_DP_SIZE 4096
 
diff --git a/include/uapi/linux/mic_ioctl.h b/include/uapi/linux/mic_ioctl.h
new file mode 100644
index 0000000..0e6cbf3
--- /dev/null
+++ b/include/uapi/linux/mic_ioctl.h
@@ -0,0 +1,74 @@
+/*
+ * Intel MIC Platform Software Stack (MPSS)
+ *
+ * Copyright(c) 2013 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * The full GNU General Public License is included in this distribution in
+ * the file called "COPYING".
+ *
+ * Intel MIC Host driver.
+ *
+ */
+#ifndef _MIC_IOCTL_H_
+#define _MIC_IOCTL_H_
+
+/*
+ * mic_copy - MIC virtio descriptor copy.
+ *
+ * @iov: An array of IOVEC structures containing user space buffers.
+ * @iovcnt: Number of IOVEC structures in iov.
+ * @vr_idx: The vring index.
+ * @update_used: A non zero value results in used index being updated.
+ * @out_len: The aggregate of the total length written to or read from
+ *	the virtio device.
+ */
+struct mic_copy_desc {
+#ifdef __KERNEL__
+	struct iovec __user *iov;
+#else
+	struct iovec *iov;
+#endif
+	int iovcnt;
+	__u8 vr_idx;
+	__u8 update_used;
+	__u32 out_len;
+};
+
+/*
+ * Add a new virtio device
+ * The (struct mic_device_desc *) pointer points to a device page entry
+ *	for the virtio device consisting of:
+ *	- struct mic_device_desc
+ *	- struct mic_vqconfig (num_vq of these)
+ *	- host and guest features
+ *	- virtio device config space
+ * The total size referenced by the pointer should equal the size returned
+ * by desc_size() in mic_common.h
+ */
+#define MIC_VIRTIO_ADD_DEVICE _IOWR('s', 1, struct mic_device_desc *)
+
+/*
+ * Copy the number of entries in the iovec and update the used index
+ * if requested by the user.
+ */
+#define MIC_VIRTIO_COPY_DESC	_IOWR('s', 2, struct mic_copy_desc *)
+
+/*
+ * Notify virtio device of a config change
+ * The (__u8 *) pointer points to config space values for the device
+ * as they should be written into the device page. The total size
+ * referenced by the pointer should equal the config_len field of struct
+ * mic_device_desc.
+ */
+#define MIC_VIRTIO_CONFIG_CHANGE _IOWR('s', 5, __u8 *)
+
+#endif
-- 
1.8.2.1

