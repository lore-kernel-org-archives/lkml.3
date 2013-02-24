Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759488Ab3BXWTE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 17:19:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759408Ab3BXWTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 17:19:00 -0500
Date: Mon, 25 Feb 2013 00:19:08 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Asias He <asias@redhat.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH dontapply 2/2] tools/virtio: update for the new virtio API
Message-ID: <4b450869f9d1ea6ef40fb832292acc103d878f17.1361743821.git.mst@redhat.com>
References: <cover.1361743821.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1361743821.git.mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 tools/virtio/linux/virtio.h | 45 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 38 insertions(+), 7 deletions(-)

diff --git a/tools/virtio/linux/virtio.h b/tools/virtio/linux/virtio.h
index 390c4cb..0426a75 100644
--- a/tools/virtio/linux/virtio.h
+++ b/tools/virtio/linux/virtio.h
@@ -11,6 +11,13 @@
 #include <linux/types.h>
 #include <errno.h>
 
+# ifndef likely
+#  define likely(x)	(__builtin_expect(!!(x), 1))
+# endif
+# ifndef unlikely
+#  define unlikely(x)	(__builtin_expect(!!(x), 0))
+# endif
+
 typedef unsigned long long dma_addr_t;
 
 struct scatterlist {
@@ -43,6 +50,10 @@ static inline void sg_mark_end(struct scatterlist *sg)
 	sg->page_link |= 0x02;
 	sg->page_link &= ~0x01;
 }
+static inline void sg_unmark_end(struct scatterlist *sg)
+{
+	sg->page_link &= ~0x02;
+}
 static inline void sg_init_table(struct scatterlist *sgl, unsigned int nents)
 {
 	memset(sgl, 0, sizeof(*sgl) * nents);
@@ -79,6 +90,26 @@ static inline void sg_init_one(struct scatterlist *sg, const void *buf, unsigned
 	sg_init_table(sg, 1);
 	sg_set_buf(sg, buf, buflen);
 }
+/*
+ * We overload the LSB of the page pointer to indicate whether it's
+ * a valid sg entry, or whether it points to the start of a new scatterlist.
+ * Those low bits are there for everyone! (thanks mason :-)
+ */
+#define sg_is_chain(sg)		((sg)->page_link & 0x01)
+#define sg_is_last(sg)		((sg)->page_link & 0x02)
+#define sg_chain_ptr(sg)	\
+	((struct scatterlist *) ((sg)->page_link & ~0x03))
+static inline struct scatterlist *sg_next(struct scatterlist *sg)
+{
+	if (sg_is_last(sg))
+		return NULL;
+
+	sg++;
+	if (unlikely(sg_is_chain(sg)))
+		sg = sg_chain_ptr(sg);
+
+	return sg;
+}
 
 typedef __u16 u16;
 
@@ -109,13 +140,6 @@ static inline void kfree(void *p)
 
 #define uninitialized_var(x) x = x
 
-# ifndef likely
-#  define likely(x)	(__builtin_expect(!!(x), 1))
-# endif
-# ifndef unlikely
-#  define unlikely(x)	(__builtin_expect(!!(x), 0))
-# endif
-
 #define pr_err(format, ...) fprintf (stderr, format, ## __VA_ARGS__)
 #ifdef DEBUG
 #define pr_debug(format, ...) fprintf (stderr, format, ## __VA_ARGS__)
@@ -200,6 +224,13 @@ int virtqueue_add_buf(struct virtqueue *vq,
 		      void *data,
 		      gfp_t gfp);
 
+int virtqueue_add_sgs(struct virtqueue *vq,
+		      struct scatterlist *sgs[],
+		      unsigned int out_sgs,
+		      unsigned int in_sgs,
+		      void *data,
+		      gfp_t gfp);
+
 void virtqueue_kick(struct virtqueue *vq);
 
 void *virtqueue_get_buf(struct virtqueue *vq, unsigned int *len);
-- 
MST
