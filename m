Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbaAOCpJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 21:45:09 -0500
Received: from ozlabs.org ([203.10.76.45]:51149 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086AbaAOCmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 21:42:17 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Cc: Heinz Graalfs <graalfs@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 5/6] virtio: fail adding buffer on broken queues.
Date: Wed, 15 Jan 2014 13:06:10 +1030
Message-Id: <1389753371-26469-5-git-send-email-rusty@rustcorp.com.au>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389753371-26469-1-git-send-email-rusty@rustcorp.com.au>
References: <1389753371-26469-1-git-send-email-rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heinz points out that adding buffers to a broken virtqueue (which
should "never happen") still works.  Failing allows drivers to detect
and complain about broken devices.

Now drivers are robust, we can add this extra check.

Reported-by: Heinz Graalfs <graalfs@linux.vnet.ibm.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/virtio/virtio_ring.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 28b5338fff71..b74033dca384 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -203,6 +203,11 @@ static inline int virtqueue_add(struct virtqueue *_vq,
 
 	BUG_ON(data == NULL);
 
+	if (unlikely(vq->broken)) {
+		END_USE(vq);
+		return -EIO;
+	}
+
 #ifdef DEBUG
 	{
 		ktime_t now = ktime_get();
@@ -309,7 +314,7 @@ add_head:
  * Caller must ensure we don't call this with other virtqueue operations
  * at the same time (except where noted).
  *
- * Returns zero or a negative error (ie. ENOSPC, ENOMEM).
+ * Returns zero or a negative error (ie. ENOSPC, ENOMEM, EIO).
  */
 int virtqueue_add_sgs(struct virtqueue *_vq,
 		      struct scatterlist *sgs[],
@@ -347,7 +352,7 @@ EXPORT_SYMBOL_GPL(virtqueue_add_sgs);
  * Caller must ensure we don't call this with other virtqueue operations
  * at the same time (except where noted).
  *
- * Returns zero or a negative error (ie. ENOSPC, ENOMEM).
+ * Returns zero or a negative error (ie. ENOSPC, ENOMEM, EIO).
  */
 int virtqueue_add_outbuf(struct virtqueue *vq,
 			 struct scatterlist sg[], unsigned int num,
@@ -369,7 +374,7 @@ EXPORT_SYMBOL_GPL(virtqueue_add_outbuf);
  * Caller must ensure we don't call this with other virtqueue operations
  * at the same time (except where noted).
  *
- * Returns zero or a negative error (ie. ENOSPC, ENOMEM).
+ * Returns zero or a negative error (ie. ENOSPC, ENOMEM, EIO).
  */
 int virtqueue_add_inbuf(struct virtqueue *vq,
 			struct scatterlist sg[], unsigned int num,
-- 
1.8.3.2

