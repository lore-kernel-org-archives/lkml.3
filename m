Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab3CAAnt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 19:43:49 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:32791 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522Ab3CAAnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 19:43:43 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Erik Gilling <konkers@android.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Rob Clark <robclark@gmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>, dri-devel@lists.freedesktop.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 02/30] staging: sw_sync: Add cpu based sync driver
Date: Thu, 28 Feb 2013 16:42:58 -0800
Message-Id: <1362098606-26469-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
References: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erik Gilling <konkers@android.com>

Adds a base sync driver that uses the cpu for serialization.

Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Erik Gilling <konkers@android.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Rob Clark <robclark@gmail.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: dri-devel@lists.freedesktop.org
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: Erik Gilling <konkers@android.com>
[jstultz: Add commit message, whitespace fixes and move to
staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/Kconfig   |   18 +++
 drivers/staging/android/Makefile  |    1 +
 drivers/staging/android/sw_sync.c |  224 +++++++++++++++++++++++++++++++++++++
 drivers/staging/android/sw_sync.h |   58 ++++++++++
 4 files changed, 301 insertions(+)
 create mode 100644 drivers/staging/android/sw_sync.c
 create mode 100644 drivers/staging/android/sw_sync.h

diff --git a/drivers/staging/android/Kconfig b/drivers/staging/android/Kconfig
index c95aede..cc406cc 100644
--- a/drivers/staging/android/Kconfig
+++ b/drivers/staging/android/Kconfig
@@ -81,6 +81,24 @@ config SYNC
 	  drivers.  Sync implementations can take advantage of hardware
 	  synchronization built into devices like GPUs.
 
+config SW_SYNC
+	bool "Software synchronization objects"
+	default n
+	depends on SYNC
+	help
+	  A sync object driver that uses a 32bit counter to coordinate
+	  syncrhronization.  Useful when there is no hardware primitive backing
+	  the synchronization.
+
+config SW_SYNC_USER
+	bool "Userspace API for SW_SYNC"
+	default n
+	depends on SW_SYNC
+	help
+	  Provides a user space API to the sw sync object.
+	  *WARNING* improper use of this can result in deadlocking kernel
+	  drivers from userspace.
+
 endif # if ANDROID
 
 endmenu
diff --git a/drivers/staging/android/Makefile b/drivers/staging/android/Makefile
index 22c656c..c136299 100644
--- a/drivers/staging/android/Makefile
+++ b/drivers/staging/android/Makefile
@@ -8,3 +8,4 @@ obj-$(CONFIG_ANDROID_TIMED_GPIO)	+= timed_gpio.o
 obj-$(CONFIG_ANDROID_LOW_MEMORY_KILLER)	+= lowmemorykiller.o
 obj-$(CONFIG_ANDROID_INTF_ALARM_DEV)	+= alarm-dev.o
 obj-$(CONFIG_SYNC)			+= sync.o
+obj-$(CONFIG_SW_SYNC)			+= sw_sync.o
diff --git a/drivers/staging/android/sw_sync.c b/drivers/staging/android/sw_sync.c
new file mode 100644
index 0000000..c27004c
--- /dev/null
+++ b/drivers/staging/android/sw_sync.c
@@ -0,0 +1,224 @@
+/*
+ * drivers/base/sw_sync.c
+ *
+ * Copyright (C) 2012 Google, Inc.
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
+#include <linux/kernel.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/syscalls.h>
+#include <linux/uaccess.h>
+
+#include "sw_sync.h"
+
+static int sw_sync_cmp(u32 a, u32 b)
+{
+	if (a == b)
+		return 0;
+
+	return ((s32)a - (s32)b) < 0 ? -1 : 1;
+}
+
+struct sync_pt *sw_sync_pt_create(struct sw_sync_timeline *obj, u32 value)
+{
+	struct sw_sync_pt *pt;
+
+	pt = (struct sw_sync_pt *)
+		sync_pt_create(&obj->obj, sizeof(struct sw_sync_pt));
+
+	pt->value = value;
+
+	return (struct sync_pt *)pt;
+}
+
+static struct sync_pt *sw_sync_pt_dup(struct sync_pt *sync_pt)
+{
+	struct sw_sync_pt *pt = (struct sw_sync_pt *) sync_pt;
+	struct sw_sync_timeline *obj =
+		(struct sw_sync_timeline *)sync_pt->parent;
+
+	return (struct sync_pt *) sw_sync_pt_create(obj, pt->value);
+}
+
+static int sw_sync_pt_has_signaled(struct sync_pt *sync_pt)
+{
+	struct sw_sync_pt *pt = (struct sw_sync_pt *)sync_pt;
+	struct sw_sync_timeline *obj =
+		(struct sw_sync_timeline *)sync_pt->parent;
+
+	return sw_sync_cmp(obj->value, pt->value) >= 0;
+}
+
+static int sw_sync_pt_compare(struct sync_pt *a, struct sync_pt *b)
+{
+	struct sw_sync_pt *pt_a = (struct sw_sync_pt *)a;
+	struct sw_sync_pt *pt_b = (struct sw_sync_pt *)b;
+
+	return sw_sync_cmp(pt_a->value, pt_b->value);
+}
+
+struct sync_timeline_ops sw_sync_timeline_ops = {
+	.driver_name = "sw_sync",
+	.dup = sw_sync_pt_dup,
+	.has_signaled = sw_sync_pt_has_signaled,
+	.compare = sw_sync_pt_compare,
+};
+
+
+struct sw_sync_timeline *sw_sync_timeline_create(const char *name)
+{
+	struct sw_sync_timeline *obj = (struct sw_sync_timeline *)
+		sync_timeline_create(&sw_sync_timeline_ops,
+				     sizeof(struct sw_sync_timeline),
+				     name);
+
+	return obj;
+}
+
+void sw_sync_timeline_inc(struct sw_sync_timeline *obj, u32 inc)
+{
+	obj->value += inc;
+
+	sync_timeline_signal(&obj->obj);
+}
+
+
+#ifdef CONFIG_SW_SYNC_USER
+/* *WARNING*
+ *
+ * improper use of this can result in deadlocking kernel drivers from userspace.
+ */
+
+/* opening sw_sync create a new sync obj */
+int sw_sync_open(struct inode *inode, struct file *file)
+{
+	struct sw_sync_timeline *obj;
+	char task_comm[TASK_COMM_LEN];
+
+	get_task_comm(task_comm, current);
+
+	obj = sw_sync_timeline_create(task_comm);
+	if (obj == NULL)
+		return -ENOMEM;
+
+	file->private_data = obj;
+
+	return 0;
+}
+
+int sw_sync_release(struct inode *inode, struct file *file)
+{
+	struct sw_sync_timeline *obj = file->private_data;
+	sync_timeline_destroy(&obj->obj);
+	return 0;
+}
+
+long sw_sync_ioctl_create_fence(struct sw_sync_timeline *obj, unsigned long arg)
+{
+	int fd = get_unused_fd();
+	int err;
+	struct sync_pt *pt;
+	struct sync_fence *fence;
+	struct sw_sync_create_fence_data data;
+
+	if (copy_from_user(&data, (void __user *)arg, sizeof(data)))
+		return -EFAULT;
+
+	pt = sw_sync_pt_create(obj, data.value);
+	if (pt == NULL) {
+		err = -ENOMEM;
+		goto err;
+	}
+
+	data.name[sizeof(data.name) - 1] = '\0';
+	fence = sync_fence_create(data.name, pt);
+	if (fence == NULL) {
+		sync_pt_free(pt);
+		err = -ENOMEM;
+		goto err;
+	}
+
+	data.fence = fd;
+	if (copy_to_user((void __user *)arg, &data, sizeof(data))) {
+		sync_fence_put(fence);
+		err = -EFAULT;
+		goto err;
+	}
+
+	sync_fence_install(fence, fd);
+
+	return 0;
+
+err:
+	put_unused_fd(fd);
+	return err;
+}
+
+long sw_sync_ioctl_inc(struct sw_sync_timeline *obj, unsigned long arg)
+{
+	u32 value;
+
+	if (copy_from_user(&value, (void __user *)arg, sizeof(value)))
+		return -EFAULT;
+
+	sw_sync_timeline_inc(obj, value);
+
+	return 0;
+}
+
+long sw_sync_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct sw_sync_timeline *obj = file->private_data;
+
+	switch (cmd) {
+	case SW_SYNC_IOC_CREATE_FENCE:
+		return sw_sync_ioctl_create_fence(obj, arg);
+
+	case SW_SYNC_IOC_INC:
+		return sw_sync_ioctl_inc(obj, arg);
+
+	default:
+		return -ENOTTY;
+	}
+}
+
+static const struct file_operations sw_sync_fops = {
+	.owner = THIS_MODULE,
+	.open = sw_sync_open,
+	.release = sw_sync_release,
+	.unlocked_ioctl = sw_sync_ioctl,
+};
+
+static struct miscdevice sw_sync_dev = {
+	.minor	= MISC_DYNAMIC_MINOR,
+	.name	= "sw_sync",
+	.fops	= &sw_sync_fops,
+};
+
+int __init sw_sync_device_init(void)
+{
+	return misc_register(&sw_sync_dev);
+}
+
+void __exit sw_sync_device_remove(void)
+{
+	misc_deregister(&sw_sync_dev);
+}
+
+module_init(sw_sync_device_init);
+module_exit(sw_sync_device_remove);
+
+#endif /* CONFIG_SW_SYNC_USER */
diff --git a/drivers/staging/android/sw_sync.h b/drivers/staging/android/sw_sync.h
new file mode 100644
index 0000000..585040b
--- /dev/null
+++ b/drivers/staging/android/sw_sync.h
@@ -0,0 +1,58 @@
+/*
+ * include/linux/sw_sync.h
+ *
+ * Copyright (C) 2012 Google, Inc.
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
+#ifndef _LINUX_SW_SYNC_H
+#define _LINUX_SW_SYNC_H
+
+#include <linux/types.h>
+
+#ifdef __KERNEL__
+
+#include "sync.h"
+
+struct sw_sync_timeline {
+	struct	sync_timeline	obj;
+
+	u32			value;
+};
+
+struct sw_sync_pt {
+	struct sync_pt		pt;
+
+	u32			value;
+};
+
+struct sw_sync_timeline *sw_sync_timeline_create(const char *name);
+void sw_sync_timeline_inc(struct sw_sync_timeline *obj, u32 inc);
+
+struct sync_pt *sw_sync_pt_create(struct sw_sync_timeline *obj, u32 value);
+
+#endif /* __KERNEL __ */
+
+struct sw_sync_create_fence_data {
+	__u32	value;
+	char	name[32];
+	__s32	fence; /* fd of new fence */
+};
+
+#define SW_SYNC_IOC_MAGIC	'W'
+
+#define SW_SYNC_IOC_CREATE_FENCE	_IOWR(SW_SYNC_IOC_MAGIC, 0,\
+		struct sw_sync_create_fence_data)
+#define SW_SYNC_IOC_INC			_IOW(SW_SYNC_IOC_MAGIC, 1, __u32)
+
+
+#endif /* _LINUX_SW_SYNC_H */
-- 
1.7.10.4

