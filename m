Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab3CAAnx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 19:43:53 -0500
Received: from mail-da0-f44.google.com ([209.85.210.44]:47652 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808Ab3CAAnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 19:43:50 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Erik Gilling <konkers@android.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Rob Clark <robclark@gmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>, dri-devel@lists.freedesktop.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 06/30] staging: sync: Add ioctl to get fence data
Date: Thu, 28 Feb 2013 16:43:02 -0800
Message-Id: <1362098606-26469-7-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
References: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erik Gilling <konkers@android.com>

Add ioctl to get fence data

Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Erik Gilling <konkers@android.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Rob Clark <robclark@gmail.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: dri-devel@lists.freedesktop.org
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: Erik Gilling <konkers@android.com>
[jstultz: Commit message tweaks]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/sync.c |   81 ++++++++++++++++++++++++++++++++++++++++
 drivers/staging/android/sync.h |   57 ++++++++++++++++++++++++++++
 2 files changed, 138 insertions(+)

diff --git a/drivers/staging/android/sync.c b/drivers/staging/android/sync.c
index 4ab55a3..f84caad 100644
--- a/drivers/staging/android/sync.c
+++ b/drivers/staging/android/sync.c
@@ -551,6 +551,84 @@ err_put_fd:
 	return err;
 }
 
+static int sync_fill_pt_info(struct sync_pt *pt, void *data, int size)
+{
+	struct sync_pt_info *info = data;
+	int ret;
+
+	if (size < sizeof(struct sync_pt_info))
+		return -ENOMEM;
+
+	info->len = sizeof(struct sync_pt_info);
+
+	if (pt->parent->ops->fill_driver_data) {
+		ret = pt->parent->ops->fill_driver_data(pt, info->driver_data,
+							size - sizeof(*info));
+		if (ret < 0)
+			return ret;
+
+		info->len += ret;
+	}
+
+	strlcpy(info->obj_name, pt->parent->name, sizeof(info->obj_name));
+	strlcpy(info->driver_name, pt->parent->ops->driver_name,
+		sizeof(info->driver_name));
+	info->status = pt->status;
+	info->timestamp_ns = ktime_to_ns(pt->timestamp);
+
+	return info->len;
+}
+
+static long sync_fence_ioctl_fence_info(struct sync_fence *fence,
+					unsigned long arg)
+{
+	struct sync_fence_info_data *data;
+	struct list_head *pos;
+	__u32 size;
+	__u32 len = 0;
+	int ret;
+
+	if (copy_from_user(&size, (void __user *)arg, sizeof(size)))
+		return -EFAULT;
+
+	if (size < sizeof(struct sync_fence_info_data))
+		return -EINVAL;
+
+	if (size > 4096)
+		size = 4096;
+
+	data = kzalloc(size, GFP_KERNEL);
+	if (data == NULL)
+		return -ENOMEM;
+
+	strlcpy(data->name, fence->name, sizeof(data->name));
+	data->status = fence->status;
+	len = sizeof(struct sync_fence_info_data);
+
+	list_for_each(pos, &fence->pt_list_head) {
+		struct sync_pt *pt =
+			container_of(pos, struct sync_pt, pt_list);
+
+		ret = sync_fill_pt_info(pt, (u8 *)data + len, size - len);
+
+		if (ret < 0)
+			goto out;
+
+		len += ret;
+	}
+
+	data->len = len;
+
+	if (copy_to_user((void __user *)arg, data, len))
+		ret = -EFAULT;
+	else
+		ret = 0;
+
+out:
+	kfree(data);
+
+	return ret;
+}
 
 static long sync_fence_ioctl(struct file *file, unsigned int cmd,
 			     unsigned long arg)
@@ -563,6 +641,9 @@ static long sync_fence_ioctl(struct file *file, unsigned int cmd,
 	case SYNC_IOC_MERGE:
 		return sync_fence_ioctl_merge(fence, arg);
 
+	case SYNC_IOC_FENCE_INFO:
+		return sync_fence_ioctl_fence_info(fence, arg);
+
 	default:
 		return -ENOTTY;
 	}
diff --git a/drivers/staging/android/sync.h b/drivers/staging/android/sync.h
index d64271b..4f19938 100644
--- a/drivers/staging/android/sync.h
+++ b/drivers/staging/android/sync.h
@@ -43,6 +43,10 @@ struct sync_fence;
  *			  should not print a newline
  * @print_pt:		print aditional debug information about sync_pt.
  *			  should not print a newline
+ * @fill_driver_data:	write implmentation specific driver data to data.
+ *			  should return an error if there is not enough room
+ *			  as specified by size.  This information is returned
+ *			  to userspace by SYNC_IOC_FENCE_INFO.
  */
 struct sync_timeline_ops {
 	const char *driver_name;
@@ -68,6 +72,9 @@ struct sync_timeline_ops {
 
 	/* optional */
 	void (*print_pt)(struct seq_file *s, struct sync_pt *sync_pt);
+
+	/* optional */
+	int (*fill_driver_data)(struct sync_pt *syncpt, void *data, int size);
 };
 
 /**
@@ -312,6 +319,42 @@ struct sync_merge_data {
 	__s32	fence; /* fd on newly created fence */
 };
 
+/**
+ * struct sync_pt_info - detailed sync_pt information
+ * @len:		length of sync_pt_info including any driver_data
+ * @obj_name:		name of parent sync_timeline
+ * @driver_name:	name of driver implmenting the parent
+ * @status:		status of the sync_pt 0:active 1:signaled <0:error
+ * @timestamp_ns:	timestamp of status change in nanoseconds
+ * @driver_data:	any driver dependant data
+ */
+struct sync_pt_info {
+	__u32	len;
+	char	obj_name[32];
+	char	driver_name[32];
+	__s32	status;
+	__u64	timestamp_ns;
+
+	__u8	driver_data[0];
+};
+
+/**
+ * struct sync_fence_info_data - data returned from fence info ioctl
+ * @len:	ioctl caller writes the size of the buffer its passing in.
+ *		ioctl returns length of sync_fence_data reutnred to userspace
+ *		including pt_info.
+ * @name:	name of fence
+ * @status:	status of fence. 1: signaled 0:active <0:error
+ * @pt_info:	a sync_pt_info struct for every sync_pt in the fence
+ */
+struct sync_fence_info_data {
+	__u32	len;
+	char	name[32];
+	__s32	status;
+
+	__u8	pt_info[0];
+};
+
 #define SYNC_IOC_MAGIC		'>'
 
 /**
@@ -330,4 +373,18 @@ struct sync_merge_data {
  */
 #define SYNC_IOC_MERGE		_IOWR(SYNC_IOC_MAGIC, 1, struct sync_merge_data)
 
+/**
+ * DOC: SYNC_IOC_FENCE_INFO - get detailed information on a fence
+ *
+ * Takes a struct sync_fence_info_data with extra space allocated for pt_info.
+ * Caller should write the size of the buffer into len.  On return, len is
+ * updated to reflect the total size of the sync_fence_info_data including
+ * pt_info.
+ *
+ * pt_info is a buffer containing sync_pt_infos for every sync_pt in the fence.
+ * To itterate over the sync_pt_infos, use the sync_pt_info.len field.
+ */
+#define SYNC_IOC_FENCE_INFO	_IOWR(SYNC_IOC_MAGIC, 2,\
+	struct sync_fence_info_data)
+
 #endif /* _LINUX_SYNC_H */
-- 
1.7.10.4

