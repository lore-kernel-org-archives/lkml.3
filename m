Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbaBMJk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 04:40:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2745 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbaBMJkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 04:40:23 -0500
Date: Thu, 13 Feb 2014 11:45:11 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
Cc: kvm@vger.kernel.org, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH net v2] vhost: fix a theoretical race in device cleanup
Message-ID: <1392284540-2031-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vhost_zerocopy_callback accesses VQ right after it drops a ubuf
reference.  In theory, this could race with device removal which waits
on the ubuf kref, and crash on use after free.

Do all accesses within rcu read side critical section, and synchronize
on release.

Since callbacks are always invoked from bh, synchronize_rcu_bh seems
enough and will help release complete a bit faster.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

This is was previously posted as part of patch
series, but it's an independent fix really.
Theoretical race so not needed for stable I think.

changes from v1:
	fixed typo in commit log

 drivers/vhost/net.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index b12176f..f1be80d 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -308,6 +308,8 @@ static void vhost_zerocopy_callback(struct ubuf_info *ubuf, bool success)
 	struct vhost_virtqueue *vq = ubufs->vq;
 	int cnt;
 
+	rcu_read_lock_bh();
+
 	/* set len to mark this desc buffers done DMA */
 	vq->heads[ubuf->desc].len = success ?
 		VHOST_DMA_DONE_LEN : VHOST_DMA_FAILED_LEN;
@@ -322,6 +324,8 @@ static void vhost_zerocopy_callback(struct ubuf_info *ubuf, bool success)
 	 */
 	if (cnt <= 1 || !(cnt % 16))
 		vhost_poll_queue(&vq->poll);
+
+	rcu_read_unlock_bh();
 }
 
 /* Expects to be always run from workqueue - which acts as
@@ -804,6 +808,8 @@ static int vhost_net_release(struct inode *inode, struct file *f)
 		fput(tx_sock->file);
 	if (rx_sock)
 		fput(rx_sock->file);
+	/* Make sure no callbacks are outstanding */
+	synchronize_rcu_bh();
 	/* We do an extra flush before freeing memory,
 	 * since jobs can re-queue themselves. */
 	vhost_net_flush(n);
-- 
MST
