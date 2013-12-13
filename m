Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab3LMW2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:28:19 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:53151 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191Ab3LMW2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:28:13 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rom Lemarchand <romlem@google.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 081/115] ion: add compat_ioctl
Date: Fri, 13 Dec 2013 14:24:55 -0800
Message-Id: <1386973529-4884-82-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rom Lemarchand <romlem@google.com>

Add a compat_ioctl to the ion driver

Signed-off-by: Rom Lemarchand <romlem@google.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/Makefile     |   3 +
 drivers/staging/android/ion/compat_ion.c | 172 +++++++++++++++++++++++++++++++
 drivers/staging/android/ion/compat_ion.h |  30 ++++++
 drivers/staging/android/ion/ion.c        |   2 +
 4 files changed, 207 insertions(+)
 create mode 100644 drivers/staging/android/ion/compat_ion.c
 create mode 100644 drivers/staging/android/ion/compat_ion.h

diff --git a/drivers/staging/android/ion/Makefile b/drivers/staging/android/ion/Makefile
index ce0f1ef..9c95665 100644
--- a/drivers/staging/android/ion/Makefile
+++ b/drivers/staging/android/ion/Makefile
@@ -1,3 +1,6 @@
 obj-$(CONFIG_ION) +=	ion.o ion_heap.o ion_page_pool.o ion_system_heap.o \
 			ion_carveout_heap.o ion_chunk_heap.o ion_cma_heap.o
+ifdef CONFIG_COMPAT
+obj-$(CONFIG_ION) += compat_ion.o
+endif
 obj-$(CONFIG_ION_TEGRA) += tegra/
diff --git a/drivers/staging/android/ion/compat_ion.c b/drivers/staging/android/ion/compat_ion.c
new file mode 100644
index 0000000..83842a6
--- /dev/null
+++ b/drivers/staging/android/ion/compat_ion.c
@@ -0,0 +1,172 @@
+/*
+ * drivers/staging/android/ion/compat_ion.c
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
+#include <linux/compat.h>
+#include <linux/fs.h>
+#include <linux/uaccess.h>
+
+#include "ion.h"
+#include "compat_ion.h"
+
+/* See drivers/staging/android/ion/ion.h for the definition of these structs */
+struct compat_ion_allocation_data {
+	compat_size_t len;
+	compat_size_t align;
+	compat_uint_t heap_id_mask;
+	compat_uint_t flags;
+	compat_int_t handle;
+};
+
+struct compat_ion_custom_data {
+	compat_uint_t cmd;
+	compat_ulong_t arg;
+};
+
+static int compat_get_ion_allocation_data(
+			struct compat_ion_allocation_data __user *data32,
+			struct ion_allocation_data __user *data)
+{
+	compat_size_t s;
+	compat_uint_t u;
+	compat_int_t i;
+	int err;
+
+	err = get_user(s, &data32->len);
+	err |= put_user(s, &data->len);
+	err |= get_user(s, &data32->align);
+	err |= put_user(s, &data->align);
+	err |= get_user(u, &data32->heap_id_mask);
+	err |= put_user(u, &data->heap_id_mask);
+	err |= get_user(u, &data32->flags);
+	err |= put_user(u, &data->flags);
+	err |= get_user(i, &data32->handle);
+	err |= put_user(i, &data->handle);
+
+	return err;
+}
+
+static int compat_put_ion_allocation_data(
+			struct compat_ion_allocation_data __user *data32,
+			struct ion_allocation_data __user *data)
+{
+	compat_size_t s;
+	compat_uint_t u;
+	compat_int_t i;
+	int err;
+
+	err = get_user(s, &data->len);
+	err |= put_user(s, &data32->len);
+	err |= get_user(s, &data->align);
+	err |= put_user(s, &data32->align);
+	err |= get_user(u, &data->heap_id_mask);
+	err |= put_user(u, &data32->heap_id_mask);
+	err |= get_user(u, &data->flags);
+	err |= put_user(u, &data32->flags);
+	err |= get_user(i, &data->handle);
+	err |= put_user(i, &data32->handle);
+
+	return err;
+}
+
+static int compat_get_ion_custom_data(
+			struct compat_ion_custom_data __user *data32,
+			struct ion_custom_data __user *data)
+{
+        compat_uint_t cmd;
+        compat_ulong_t arg;
+	int err;
+
+	err = get_user(cmd, &data32->cmd);
+	err |= put_user(cmd, &data->cmd);
+	err |= get_user(arg, &data32->arg);
+	err |= put_user(arg, &data->arg);
+
+	return err;
+};
+
+long compat_ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	long ret;
+
+	if (!filp->f_op || !filp->f_op->unlocked_ioctl)
+		return -ENOTTY;
+
+	switch (cmd) {
+	case ION_IOC_ALLOC:
+	{
+		struct compat_ion_allocation_data __user *data32;
+		struct ion_allocation_data __user *data;
+		int err;
+
+		data32 = compat_ptr(arg);
+		data = compat_alloc_user_space(sizeof(*data));
+		if (data == NULL)
+			return -EFAULT;
+
+		err = compat_get_ion_allocation_data(data32, data);
+		if (err)
+			return err;
+
+		ret = filp->f_op->unlocked_ioctl(filp, cmd,
+							(unsigned long)data);
+		err = compat_put_ion_allocation_data(data32, data);
+		return ret ? ret : err;
+	}
+	case ION_IOC_FREE:
+	{
+		struct compat_ion_allocation_data __user *data32;
+		struct ion_allocation_data __user *data;
+		int err;
+
+		data32 = compat_ptr(arg);
+		data = compat_alloc_user_space(sizeof(*data));
+		if (data == NULL)
+			return -EFAULT;
+
+		err = compat_get_ion_allocation_data(data32, data);
+		if (err)
+			return err;
+
+		return filp->f_op->unlocked_ioctl(filp, cmd,
+							(unsigned long)data);
+	}
+	case ION_IOC_CUSTOM: {
+		struct compat_ion_custom_data __user *data32;
+		struct ion_custom_data __user *data;
+		int err;
+
+		data32 = compat_ptr(arg);
+		data = compat_alloc_user_space(sizeof(*data));
+		if (data == NULL)
+			return -EFAULT;
+
+		err = compat_get_ion_custom_data(data32, data);
+		if (err)
+			return err;
+
+		return filp->f_op->unlocked_ioctl(filp, cmd,
+							(unsigned long)data);
+	}
+	case ION_IOC_SHARE:
+	case ION_IOC_MAP:
+	case ION_IOC_IMPORT:
+	case ION_IOC_SYNC:
+		return filp->f_op->unlocked_ioctl(filp, cmd,
+						(unsigned long)compat_ptr(arg));
+	default:
+		return -ENOIOCTLCMD;
+	}
+}
diff --git a/drivers/staging/android/ion/compat_ion.h b/drivers/staging/android/ion/compat_ion.h
new file mode 100644
index 0000000..c2ad589
--- /dev/null
+++ b/drivers/staging/android/ion/compat_ion.h
@@ -0,0 +1,30 @@
+/*
+
+ * drivers/staging/android/ion/compat_ion.h
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
+#ifndef _LINUX_COMPAT_ION_H
+#define _LINUX_COMPAT_ION_H
+
+#if IS_ENABLED(CONFIG_COMPAT)
+
+long compat_ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
+
+#else
+
+#define compat_ion_ioctl  NULL
+
+#endif /* CONFIG_COMPAT */
+#endif /* _LINUX_COMPAT_ION_H */
diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 1c40b74..d97117f 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -38,6 +38,7 @@
 
 #include "ion.h"
 #include "ion_priv.h"
+#include "compat_ion.h"
 
 /**
  * struct ion_device - the metadata of the ion device node
@@ -1256,6 +1257,7 @@ static const struct file_operations ion_fops = {
 	.open           = ion_open,
 	.release        = ion_release,
 	.unlocked_ioctl = ion_ioctl,
+	.compat_ioctl   = compat_ion_ioctl,
 };
 
 static size_t ion_debug_heap_total(struct ion_client *client,
-- 
1.8.3.2

