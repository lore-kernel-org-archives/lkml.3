Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab3LND1c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 22:27:32 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:46888 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab3LND0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 22:26:49 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 096/115] ion: clean up ioctls
Date: Fri, 13 Dec 2013 19:26:16 -0800
Message-Id: <1386991595-6251-4-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386991595-6251-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
 <1386991595-6251-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

Convert the ion ioctls to use _IOW instead of _IOWR where
appropriate, and factor out the copy_from_user and copy_to_user
based on the _IOC_DIR bits.  For the existing incorrect ioctls,
add a function to wrap _IOC_DIR to return the corrected value.

Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c | 110 ++++++++++++++++++++------------------
 1 file changed, 59 insertions(+), 51 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 57698e6..fc77aa6 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -1157,41 +1157,65 @@ static int ion_sync_for_device(struct ion_client *client, int fd)
 	return 0;
 }
 
+/* fix up the cases where the ioctl direction bits are incorrect */
+static unsigned int ion_ioctl_dir(unsigned int cmd)
+{
+	switch (cmd) {
+	case ION_IOC_SYNC:
+	case ION_IOC_FREE:
+	case ION_IOC_CUSTOM:
+		return _IOC_WRITE;
+	default:
+		return _IOC_DIR(cmd);
+	}
+}
+
 static long ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct ion_client *client = filp->private_data;
+	struct ion_device *dev = client->dev;
+	struct ion_handle *cleanup_handle = NULL;
+	int ret = 0;
+	unsigned int dir;
+
+	union {
+		struct ion_fd_data fd;
+		struct ion_allocation_data allocation;
+		struct ion_handle_data handle;
+		struct ion_custom_data custom;
+	} data;
+
+	dir = ion_ioctl_dir(cmd);
+
+	if (_IOC_SIZE(cmd) > sizeof(data))
+		return -EINVAL;
+
+	if (dir & _IOC_WRITE)
+		if (copy_from_user(&data, (void __user *)arg, _IOC_SIZE(cmd)))
+			return -EFAULT;
 
 	switch (cmd) {
 	case ION_IOC_ALLOC:
 	{
-		struct ion_allocation_data data;
 		struct ion_handle *handle;
 
-		if (copy_from_user(&data, (void __user *)arg, sizeof(data)))
-			return -EFAULT;
-		handle = ion_alloc(client, data.len, data.align,
-					     data.heap_id_mask, data.flags);
-
+		handle = ion_alloc(client, data.allocation.len,
+						data.allocation.align,
+						data.allocation.heap_id_mask,
+						data.allocation.flags);
 		if (IS_ERR(handle))
 			return PTR_ERR(handle);
 
-		data.handle = handle->id;
+		data.allocation.handle = handle->id;
 
-		if (copy_to_user((void __user *)arg, &data, sizeof(data))) {
-			ion_free(client, handle);
-			return -EFAULT;
-		}
+		cleanup_handle = handle;
 		break;
 	}
 	case ION_IOC_FREE:
 	{
-		struct ion_handle_data data;
 		struct ion_handle *handle;
 
-		if (copy_from_user(&data, (void __user *)arg,
-				   sizeof(struct ion_handle_data)))
-			return -EFAULT;
-		handle = ion_handle_get_by_id(client, data.handle);
+		handle = ion_handle_get_by_id(client, data.handle.handle);
 		if (IS_ERR(handle))
 			return PTR_ERR(handle);
 		ion_free(client, handle);
@@ -1201,68 +1225,52 @@ static long ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	case ION_IOC_SHARE:
 	case ION_IOC_MAP:
 	{
-		struct ion_fd_data data;
 		struct ion_handle *handle;
 
-		if (copy_from_user(&data, (void __user *)arg, sizeof(data)))
-			return -EFAULT;
-		handle = ion_handle_get_by_id(client, data.handle);
+		handle = ion_handle_get_by_id(client, data.handle.handle);
 		if (IS_ERR(handle))
 			return PTR_ERR(handle);
-		data.fd = ion_share_dma_buf_fd(client, handle);
+		data.fd.fd = ion_share_dma_buf_fd(client, handle);
 		ion_handle_put(handle);
-		if (copy_to_user((void __user *)arg, &data, sizeof(data)))
-			return -EFAULT;
-		if (data.fd < 0)
-			return data.fd;
+		if (data.fd.fd < 0)
+			ret = data.fd.fd;
 		break;
 	}
 	case ION_IOC_IMPORT:
 	{
-		struct ion_fd_data data;
 		struct ion_handle *handle;
-		int ret = 0;
-		if (copy_from_user(&data, (void __user *)arg,
-				   sizeof(struct ion_fd_data)))
-			return -EFAULT;
-		handle = ion_import_dma_buf(client, data.fd);
+		handle = ion_import_dma_buf(client, data.fd.fd);
 		if (IS_ERR(handle))
 			ret = PTR_ERR(handle);
 		else
-			data.handle = handle->id;
-
-		if (copy_to_user((void __user *)arg, &data,
-				 sizeof(struct ion_fd_data)))
-			return -EFAULT;
-		if (ret < 0)
-			return ret;
+			data.handle.handle = handle->id;
 		break;
 	}
 	case ION_IOC_SYNC:
 	{
-		struct ion_fd_data data;
-		if (copy_from_user(&data, (void __user *)arg,
-				   sizeof(struct ion_fd_data)))
-			return -EFAULT;
-		ion_sync_for_device(client, data.fd);
+		ret = ion_sync_for_device(client, data.fd.fd);
 		break;
 	}
 	case ION_IOC_CUSTOM:
 	{
-		struct ion_device *dev = client->dev;
-		struct ion_custom_data data;
-
 		if (!dev->custom_ioctl)
 			return -ENOTTY;
-		if (copy_from_user(&data, (void __user *)arg,
-				sizeof(struct ion_custom_data)))
-			return -EFAULT;
-		return dev->custom_ioctl(client, data.cmd, data.arg);
+		ret = dev->custom_ioctl(client, data.custom.cmd,
+						data.custom.arg);
+		break;
 	}
 	default:
 		return -ENOTTY;
 	}
-	return 0;
+
+	if (dir & _IOC_READ) {
+		if (copy_to_user((void __user *)arg, &data, _IOC_SIZE(cmd))) {
+			if (cleanup_handle)
+				ion_free(client, cleanup_handle);
+			return -EFAULT;
+		}
+	}
+	return ret;
 }
 
 static int ion_release(struct inode *inode, struct file *file)
-- 
1.8.3.2

