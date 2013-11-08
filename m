Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab3KHHTW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 02:19:22 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:47735 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752913Ab3KHHTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 02:19:21 -0500
From: Thomas Hellstrom <thellstrom@vmware.com>
To: dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org
Cc: Thomas Hellstrom <thellstrom@vmware.com>
Subject: [PATCH RFC] dma-buf/fs Add get_[file|dma_buf]_unless_doomed
Date: Thu,  7 Nov 2013 23:18:54 -0800
Message-Id: <1383895134-4535-1-git-send-email-thellstrom@vmware.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this context, a "doomed" object is an object whose refcount has reached
zero, but that has not yet been freed.

To avoid mutual refcounting vmwgfx need to have a non-refcounted pointer to
a dma-buf in a lookup structure. The pointer is removed in the dma-buf
destructor. To allow lookup-structure private locks we need
get_dma_buf_unless_doomed(). This common refcounting scenario is described
with examples in detail in the kref documentaion.
The solution with local locks is under kref_get_unless_zero().
See also kobject_get_unless_zero() and its commit message.
Since dma-bufs are using the attached file for refcounting,
get_dma_buf_unless_doomed maps directly to a get_file_unless_doomed.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
---
 include/linux/dma-buf.h |   16 ++++++++++++++++
 include/linux/fs.h      |   15 +++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index dfac5ed..6e58144 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -162,6 +162,22 @@ static inline void get_dma_buf(struct dma_buf *dmabuf)
 	get_file(dmabuf->file);
 }
 
+/**
+ * get_dma_buf_unless_doomed - convenience wrapper for get_file_unless_doomed
+ *
+ * @dmabuf:	[in]	pointer to dma_buf
+ *
+ * Obtain a dma-buf reference from a lookup structure that doesn't refcount
+ * the dma-buf, but synchronizes with its release method to make sure it has
+ * not been freed yet. See for example kref_get_unless_zero documentation.
+ * Returns true if refcounting succeeds, false otherwise.
+ */
+static inline bool __must_check
+get_dma_buf_unless_doomed(struct dma_buf *dmabuf)
+{
+	return get_file_unless_doomed(dmabuf->file);
+}
+
 struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
 							struct device *dev);
 void dma_buf_detach(struct dma_buf *dmabuf,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3f40547..a96c333 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -824,6 +824,21 @@ static inline struct file *get_file(struct file *f)
 	atomic_long_inc(&f->f_count);
 	return f;
 }
+
+/**
+ * get_file_unless_doomed - convenience wrapper for get_file_unless_doomed
+ * @file:	[in]	pointer to file
+ *
+ * Obtain a file reference from a lookup structure that doesn't refcount
+ * the file, but synchronizes with its release method to make sure it has
+ * not been freed yet. See for example kref_get_unless_zero documentation.
+ * Returns true if refcounting succeeds, false otherwise.
+ */
+static inline bool __must_check get_file_unless_doomed(struct file *f)
+{
+	return atomic_long_inc_not_zero(&f->f_count) != 0L;
+}
+
 #define fput_atomic(x)	atomic_long_add_unless(&(x)->f_count, -1, 1)
 #define file_count(x)	atomic_long_read(&(x)->f_count)
 
-- 
1.7.10.4
