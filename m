Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab3LMWgx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:36:53 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:49109 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954Ab3LMW1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:27:42 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Johan Mossberg <johan.mossberg@stericsson.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 060/115] gpu: ion: Add support for sharing buffers with dma buf kernel handles
Date: Fri, 13 Dec 2013 14:24:34 -0800
Message-Id: <1386973529-4884-61-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Mossberg <johan.mossberg@stericsson.com>

Currently ion can only share buffers with dma buf fd's. Fd's can not be
used inside the kernel as they are process specific so support for
sharing buffers with dma buf kernel handles is needed to support kernel
only use cases. An example use case could be a GPU driver using ion
that wants to share its output buffers with a 3d party display
controller driver supporting dma buf.

Signed-off-by: Johan Mossberg <johan.mossberg@stericsson.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c | 26 ++++++++++++++++++++------
 drivers/staging/android/ion/ion.h | 12 ++++++++++--
 2 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 054e672..ba65bef 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -949,19 +949,19 @@ struct dma_buf_ops dma_buf_ops = {
 	.kunmap = ion_dma_buf_kunmap,
 };
 
-int ion_share_dma_buf(struct ion_client *client, struct ion_handle *handle)
+struct dma_buf *ion_share_dma_buf(struct ion_client *client,
+						struct ion_handle *handle)
 {
 	struct ion_buffer *buffer;
 	struct dma_buf *dmabuf;
 	bool valid_handle;
-	int fd;
 
 	mutex_lock(&client->lock);
 	valid_handle = ion_handle_validate(client, handle);
 	mutex_unlock(&client->lock);
 	if (!valid_handle) {
 		WARN(1, "%s: invalid handle passed to share.\n", __func__);
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 	}
 
 	buffer = handle->buffer;
@@ -969,15 +969,29 @@ int ion_share_dma_buf(struct ion_client *client, struct ion_handle *handle)
 	dmabuf = dma_buf_export(buffer, &dma_buf_ops, buffer->size, O_RDWR);
 	if (IS_ERR(dmabuf)) {
 		ion_buffer_put(buffer);
-		return PTR_ERR(dmabuf);
+		return dmabuf;
 	}
+
+	return dmabuf;
+}
+EXPORT_SYMBOL(ion_share_dma_buf);
+
+int ion_share_dma_buf_fd(struct ion_client *client, struct ion_handle *handle)
+{
+	struct dma_buf *dmabuf;
+	int fd;
+
+	dmabuf = ion_share_dma_buf(client, handle);
+	if (IS_ERR(dmabuf))
+		return PTR_ERR(dmabuf);
+
 	fd = dma_buf_fd(dmabuf, O_CLOEXEC);
 	if (fd < 0)
 		dma_buf_put(dmabuf);
 
 	return fd;
 }
-EXPORT_SYMBOL(ion_share_dma_buf);
+EXPORT_SYMBOL(ion_share_dma_buf_fd);
 
 struct ion_handle *ion_import_dma_buf(struct ion_client *client, int fd)
 {
@@ -1086,7 +1100,7 @@ static long ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 
 		if (copy_from_user(&data, (void __user *)arg, sizeof(data)))
 			return -EFAULT;
-		data.fd = ion_share_dma_buf(client, data.handle);
+		data.fd = ion_share_dma_buf_fd(client, data.handle);
 		if (copy_to_user((void __user *)arg, &data, sizeof(data)))
 			return -EFAULT;
 		if (data.fd < 0)
diff --git a/drivers/staging/android/ion/ion.h b/drivers/staging/android/ion/ion.h
index 0f67014f..976123b 100644
--- a/drivers/staging/android/ion/ion.h
+++ b/drivers/staging/android/ion/ion.h
@@ -212,11 +212,19 @@ void *ion_map_kernel(struct ion_client *client, struct ion_handle *handle);
 void ion_unmap_kernel(struct ion_client *client, struct ion_handle *handle);
 
 /**
- * ion_share_dma_buf() - given an ion client, create a dma-buf fd
+ * ion_share_dma_buf() - share buffer as dma-buf
  * @client:	the client
  * @handle:	the handle
  */
-int ion_share_dma_buf(struct ion_client *client, struct ion_handle *handle);
+struct dma_buf *ion_share_dma_buf(struct ion_client *client,
+						struct ion_handle *handle);
+
+/**
+ * ion_share_dma_buf_fd() - given an ion client, create a dma-buf fd
+ * @client:	the client
+ * @handle:	the handle
+ */
+int ion_share_dma_buf_fd(struct ion_client *client, struct ion_handle *handle);
 
 /**
  * ion_import_dma_buf() - given an dma-buf fd from the ion exporter get handle
-- 
1.8.3.2

