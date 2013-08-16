Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab3HPF2z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 01:28:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141Ab3HPF2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 01:28:05 -0400
From: Jason Wang <jasowang@redhat.com>
To: mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>
Subject: [PATCH 3/6] vhost: switch to use vhost_add_used_n()
Date: Fri, 16 Aug 2013 13:16:27 +0800
Message-Id: <1376630190-5912-4-git-send-email-jasowang@redhat.com>
In-Reply-To: <1376630190-5912-1-git-send-email-jasowang@redhat.com>
References: <1376630190-5912-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let vhost_add_used() to use vhost_add_used_n() to reduce the code duplication.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vhost.c |   43 ++-----------------------------------------
 1 files changed, 2 insertions(+), 41 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index e58cf00..c479452 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1332,48 +1332,9 @@ EXPORT_SYMBOL_GPL(vhost_discard_vq_desc);
  * want to notify the guest, using eventfd. */
 int vhost_add_used(struct vhost_virtqueue *vq, unsigned int head, int len)
 {
-	struct vring_used_elem __user *used;
+	struct vring_used_elem heads = { head, len };
 
-	/* The virtqueue contains a ring of used buffers.  Get a pointer to the
-	 * next entry in that used ring. */
-	used = &vq->used->ring[vq->last_used_idx % vq->num];
-	if (__put_user(head, &used->id)) {
-		vq_err(vq, "Failed to write used id");
-		return -EFAULT;
-	}
-	if (__put_user(len, &used->len)) {
-		vq_err(vq, "Failed to write used len");
-		return -EFAULT;
-	}
-	/* Make sure buffer is written before we update index. */
-	smp_wmb();
-	if (__put_user(vq->last_used_idx + 1, &vq->used->idx)) {
-		vq_err(vq, "Failed to increment used idx");
-		return -EFAULT;
-	}
-	if (unlikely(vq->log_used)) {
-		/* Make sure data is seen before log. */
-		smp_wmb();
-		/* Log used ring entry write. */
-		log_write(vq->log_base,
-			  vq->log_addr +
-			   ((void __user *)used - (void __user *)vq->used),
-			  sizeof *used);
-		/* Log used index update. */
-		log_write(vq->log_base,
-			  vq->log_addr + offsetof(struct vring_used, idx),
-			  sizeof vq->used->idx);
-		if (vq->log_ctx)
-			eventfd_signal(vq->log_ctx, 1);
-	}
-	vq->last_used_idx++;
-	/* If the driver never bothers to signal in a very long while,
-	 * used index might wrap around. If that happens, invalidate
-	 * signalled_used index we stored. TODO: make sure driver
-	 * signals at least once in 2^16 and remove this. */
-	if (unlikely(vq->last_used_idx == vq->signalled_used))
-		vq->signalled_used_valid = false;
-	return 0;
+	return vhost_add_used_n(vq, &heads, 1);
 }
 EXPORT_SYMBOL_GPL(vhost_add_used);
 
-- 
1.7.1

