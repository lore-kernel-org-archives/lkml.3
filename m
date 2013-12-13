Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab3LMWab (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:30:31 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:39444 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191Ab3LMW2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:28:20 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 085/115] ion: hold reference to handle after ion_uhandle_get
Date: Fri, 13 Dec 2013 14:24:59 -0800
Message-Id: <1386973529-4884-86-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

commit 1262ab1846cf76f7549c66ef709120dbfbe6d49f (ion: replace
userspace handle cookies with idr) broke the locking in ion.
The ION_IOC_FREE and ION_IOC_MAP ioctls were relying on
ion_handle_validate to detect the case where a call raced
with another ION_IOC_FREE which may have freed the struct
ion_handle.

Rename ion_uhandle_get to ion_handle_get_by_id, and have it
take the client lock and return with an extra reference to
the handle.  Make each caller put its reference once it
is done with the handle.

Also modify users of ion_handle_validate to continue to hold
the client lock after calling ion_handle_validate until
they are done with the handle, and warn if ion_handle_validate
is called without the client lock held.

Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c | 56 ++++++++++++++++++++++++++++-----------
 1 file changed, 41 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index d97117f..cf9fc78 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -383,7 +383,14 @@ static void ion_handle_get(struct ion_handle *handle)
 
 static int ion_handle_put(struct ion_handle *handle)
 {
-	return kref_put(&handle->ref, ion_handle_destroy);
+	struct ion_client *client = handle->client;
+	int ret;
+
+	mutex_lock(&client->lock);
+	ret = kref_put(&handle->ref, ion_handle_destroy);
+	mutex_unlock(&client->lock);
+
+	return ret;
 }
 
 static struct ion_handle *ion_handle_lookup(struct ion_client *client,
@@ -403,14 +410,24 @@ static struct ion_handle *ion_handle_lookup(struct ion_client *client,
 	return ERR_PTR(-EINVAL);
 }
 
-static struct ion_handle *ion_uhandle_get(struct ion_client *client, int id)
+static struct ion_handle *ion_handle_get_by_id(struct ion_client *client,
+						int id)
 {
-	return idr_find(&client->idr, id);
+	struct ion_handle *handle;
+
+	mutex_lock(&client->lock);
+	handle = idr_find(&client->idr, id);
+	if (handle)
+		ion_handle_get(handle);
+	mutex_unlock(&client->lock);
+
+	return handle ? handle : ERR_PTR(-EINVAL);
 }
 
 static bool ion_handle_validate(struct ion_client *client, struct ion_handle *handle)
 {
-	return (ion_uhandle_get(client, handle->id) == handle);
+	WARN_ON(!mutex_is_locked(&client->lock));
+	return (idr_find(&client->idr, handle->id) == handle);
 }
 
 static int ion_handle_add(struct ion_client *client, struct ion_handle *handle)
@@ -503,11 +520,11 @@ struct ion_handle *ion_alloc(struct ion_client *client, size_t len,
 
 	mutex_lock(&client->lock);
 	ret = ion_handle_add(client, handle);
+	mutex_unlock(&client->lock);
 	if (ret) {
 		ion_handle_put(handle);
 		handle = ERR_PTR(ret);
 	}
-	mutex_unlock(&client->lock);
 
 	return handle;
 }
@@ -527,8 +544,8 @@ void ion_free(struct ion_client *client, struct ion_handle *handle)
 		mutex_unlock(&client->lock);
 		return;
 	}
-	ion_handle_put(handle);
 	mutex_unlock(&client->lock);
+	ion_handle_put(handle);
 }
 EXPORT_SYMBOL(ion_free);
 
@@ -1021,14 +1038,15 @@ struct dma_buf *ion_share_dma_buf(struct ion_client *client,
 
 	mutex_lock(&client->lock);
 	valid_handle = ion_handle_validate(client, handle);
-	mutex_unlock(&client->lock);
 	if (!valid_handle) {
 		WARN(1, "%s: invalid handle passed to share.\n", __func__);
+		mutex_unlock(&client->lock);
 		return ERR_PTR(-EINVAL);
 	}
-
 	buffer = handle->buffer;
 	ion_buffer_get(buffer);
+	mutex_unlock(&client->lock);
+
 	dmabuf = dma_buf_export(buffer, &dma_buf_ops, buffer->size, O_RDWR);
 	if (IS_ERR(dmabuf)) {
 		ion_buffer_put(buffer);
@@ -1081,18 +1099,24 @@ struct ion_handle *ion_import_dma_buf(struct ion_client *client, int fd)
 	handle = ion_handle_lookup(client, buffer);
 	if (!IS_ERR(handle)) {
 		ion_handle_get(handle);
+		mutex_unlock(&client->lock);
 		goto end;
 	}
+	mutex_unlock(&client->lock);
+
 	handle = ion_handle_create(client, buffer);
 	if (IS_ERR(handle))
 		goto end;
+
+	mutex_lock(&client->lock);
 	ret = ion_handle_add(client, handle);
+	mutex_unlock(&client->lock);
 	if (ret) {
 		ion_handle_put(handle);
 		handle = ERR_PTR(ret);
 	}
+
 end:
-	mutex_unlock(&client->lock);
 	dma_buf_put(dmabuf);
 	return handle;
 }
@@ -1156,12 +1180,11 @@ static long ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		if (copy_from_user(&data, (void __user *)arg,
 				   sizeof(struct ion_handle_data)))
 			return -EFAULT;
-		mutex_lock(&client->lock);
-		handle = ion_uhandle_get(client, data.handle);
-		mutex_unlock(&client->lock);
-		if (!handle)
-			return -EINVAL;
+		handle = ion_handle_get_by_id(client, data.handle);
+		if (IS_ERR(handle))
+			return PTR_ERR(handle);
 		ion_free(client, handle);
+		ion_handle_put(handle);
 		break;
 	}
 	case ION_IOC_SHARE:
@@ -1172,8 +1195,11 @@ static long ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 
 		if (copy_from_user(&data, (void __user *)arg, sizeof(data)))
 			return -EFAULT;
-		handle = ion_uhandle_get(client, data.handle);
+		handle = ion_handle_get_by_id(client, data.handle);
+		if (IS_ERR(handle))
+			return PTR_ERR(handle);
 		data.fd = ion_share_dma_buf_fd(client, handle);
+		ion_handle_put(handle);
 		if (copy_to_user((void __user *)arg, &data, sizeof(data)))
 			return -EFAULT;
 		if (data.fd < 0)
-- 
1.8.3.2

