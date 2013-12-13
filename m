Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab3LMW0h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:26:37 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:43306 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab3LMW0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:26:34 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 018/115] gpu: ion: Add explicit sync ioctl
Date: Fri, 13 Dec 2013 14:23:52 -0800
Message-Id: <1386973529-4884-19-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rebecca Schultz Zavin <rebecca@android.com>

This is deprecated in favor of using the dma_buf api which will
automatically sync a buffer to memory when it is mapped to a device.
However, that functionality is not ready, so this patch adds the
ability to sync a buffer explicitly.

Signed-off-by: Rebecca Schultz Zavin <rebecca@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c | 38 ++++++++++++++++++++++++++++++++++++--
 drivers/staging/android/ion/ion.h | 12 +++++++++++-
 2 files changed, 47 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index bc9e922..d4e4c68 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -684,8 +684,7 @@ static struct sg_table *ion_map_dma_buf(struct dma_buf_attachment *attachment,
 	struct dma_buf *dmabuf = attachment->dmabuf;
 	struct ion_buffer *buffer = dmabuf->priv;
 
-	if (buffer->flags & ION_FLAG_CACHED)
-		ion_buffer_sync_for_device(buffer, attachment->dev, direction);
+	ion_buffer_sync_for_device(buffer, attachment->dev, direction);
 	return buffer->sg_table;
 }
 
@@ -721,6 +720,10 @@ static void ion_buffer_sync_for_device(struct ion_buffer *buffer,
 
 	pr_debug("%s: syncing for device %s\n", __func__,
 		 dev ? dev_name(dev) : "null");
+
+	if (!(buffer->flags & ION_FLAG_CACHED))
+		return;
+
 	mutex_lock(&buffer->lock);
 	for_each_sg(buffer->sg_table->sgl, sg, buffer->sg_table->nents, i) {
 		if (!test_bit(i, buffer->dirty))
@@ -958,6 +961,28 @@ end:
 	return handle;
 }
 
+static int ion_sync_for_device(struct ion_client *client, int fd)
+{
+	struct dma_buf *dmabuf;
+	struct ion_buffer *buffer;
+
+	dmabuf = dma_buf_get(fd);
+	if (IS_ERR_OR_NULL(dmabuf))
+		return PTR_ERR(dmabuf);
+
+	/* if this memory came from ion */
+	if (dmabuf->ops != &dma_buf_ops) {
+		pr_err("%s: can not sync dmabuf from another exporter\n",
+		       __func__);
+		dma_buf_put(dmabuf);
+		return -EINVAL;
+	}
+	buffer = dmabuf->priv;
+	ion_buffer_sync_for_device(buffer, NULL, DMA_BIDIRECTIONAL);
+	dma_buf_put(dmabuf);
+	return 0;
+}
+
 static long ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct ion_client *client = filp->private_data;
@@ -1022,6 +1047,15 @@ static long ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			return -EFAULT;
 		break;
 	}
+	case ION_IOC_SYNC:
+	{
+		struct ion_fd_data data;
+		if (copy_from_user(&data, (void __user *)arg,
+				   sizeof(struct ion_fd_data)))
+			return -EFAULT;
+		ion_sync_for_device(client, data.fd);
+		break;
+	}
 	case ION_IOC_CUSTOM:
 	{
 		struct ion_device *dev = client->dev;
diff --git a/drivers/staging/android/ion/ion.h b/drivers/staging/android/ion/ion.h
index 88b9a2f..83baa38 100644
--- a/drivers/staging/android/ion/ion.h
+++ b/drivers/staging/android/ion/ion.h
@@ -328,7 +328,17 @@ struct ion_custom_data {
  * descriptor obtained from ION_IOC_SHARE and returns the struct with the handle
  * filed set to the corresponding opaque handle.
  */
-#define ION_IOC_IMPORT		_IOWR(ION_IOC_MAGIC, 5, int)
+#define ION_IOC_IMPORT		_IOWR(ION_IOC_MAGIC, 5, struct ion_fd_data)
+
+/**
+ * DOC: ION_IOC_SYNC - syncs a shared file descriptors to memory
+ *
+ * Deprecated in favor of using the dma_buf api's correctly (syncing
+ * will happend automatically when the buffer is mapped to a device).
+ * If necessary should be used after touching a cached buffer from the cpu,
+ * this will make the buffer in memory coherent.
+ */
+#define ION_IOC_SYNC		_IOWR(ION_IOC_MAGIC, 7, struct ion_fd_data)
 
 /**
  * DOC: ION_IOC_CUSTOM - call architecture specific ion ioctl
-- 
1.8.3.2

