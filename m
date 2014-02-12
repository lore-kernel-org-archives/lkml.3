Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098AbaBLQdK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 11:33:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953AbaBLQdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 11:33:08 -0500
Date: Wed, 12 Feb 2014 18:38:00 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        davem@davemloft.net, qinchuanyu@huawei.com, kvm@vger.kernel.org
Subject: [PATCH net 2/3] vhost: fix ref cnt checking deadlock
Message-ID: <1392222846-26699-3-git-send-email-mst@redhat.com>
References: <1392222846-26699-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392222846-26699-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vhost checked the counter within the refcnt before decrementing.  It
really wanted to know that there aren't too many references, as a way to
batch freeing resources a bit more efficiently.

This works well but it we now access the
ref counter twice so there's a race:
all users might see a high count and decide
to defer freeing resources.
In the end no one initiates freeing resources
until the last reference is gone (which is on VM shotdown
so might happen after a looooong time).

Let's do what we should have done straight away:
add a kref API to return the kref value atomically,
and use that to avoid the deadlock.

Reported-by: Qin Chuanyu <qinchuanyu@huawei.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/net.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 831eb4f..7eaf2de 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -140,9 +140,9 @@ vhost_net_ubuf_alloc(struct vhost_virtqueue *vq, bool zcopy)
 	return ubufs;
 }
 
-static void vhost_net_ubuf_put(struct vhost_net_ubuf_ref *ubufs)
+static int vhost_net_ubuf_put(struct vhost_net_ubuf_ref *ubufs)
 {
-	kref_put(&ubufs->kref, vhost_net_zerocopy_done_signal);
+	return kref_sub_return(&ubufs->kref, 1, vhost_net_zerocopy_done_signal);
 }
 
 static void vhost_net_ubuf_put_and_wait(struct vhost_net_ubuf_ref *ubufs)
@@ -306,22 +306,21 @@ static void vhost_zerocopy_callback(struct ubuf_info *ubuf, bool success)
 {
 	struct vhost_net_ubuf_ref *ubufs = ubuf->ctx;
 	struct vhost_virtqueue *vq = ubufs->vq;
-	int cnt = atomic_read(&ubufs->kref.refcount);
+	int cnt;
 
 	/* set len to mark this desc buffers done DMA */
 	vq->heads[ubuf->desc].len = success ?
 		VHOST_DMA_DONE_LEN : VHOST_DMA_FAILED_LEN;
-	vhost_net_ubuf_put(ubufs);
+	cnt = vhost_net_ubuf_put(ubufs);
 
 	/*
 	 * Trigger polling thread if guest stopped submitting new buffers:
-	 * in this case, the refcount after decrement will eventually reach 1
-	 * so here it is 2.
+	 * in this case, the refcount after decrement will eventually reach 1.
 	 * We also trigger polling periodically after each 16 packets
 	 * (the value 16 here is more or less arbitrary, it's tuned to trigger
 	 * less than 10% of times).
 	 */
-	if (cnt <= 2 || !(cnt % 16))
+	if (cnt <= 1 || !(cnt % 16))
 		vhost_poll_queue(&vq->poll);
 }
 
-- 
MST
