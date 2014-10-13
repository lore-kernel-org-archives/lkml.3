Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbaJMHsE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 03:48:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753818AbaJMHrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 03:47:55 -0400
Date: Mon, 13 Oct 2014 10:51:09 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, linux-scsi@vger.kernel.org,
        linux-s390@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        Amit Shah <amit.shah@redhat.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v4 17/25] virtio_blk: enable VQs early on restore
Message-ID: <1413114332-626-18-git-send-email-mst-v4@redhat.com>
References: <1413114332-626-1-git-send-email-mst-v4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413114332-626-1-git-send-email-mst-v4@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virtio spec requires drivers to set DRIVER_OK before using VQs.
This is set automatically after restore returns, virtio block violated
this rule on restore by restarting queues, which might in theory
cause the VQ to be used directly within restore.

To fix, call virtio_device_ready before using starting queues.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/block/virtio_blk.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 46b04bf..1c95af5 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -804,10 +804,13 @@ static int virtblk_restore(struct virtio_device *vdev)
 	int ret;
 
 	ret = init_vq(vdev->priv);
-	if (!ret)
-		blk_mq_start_stopped_hw_queues(vblk->disk->queue, true);
+	if (ret)
+		return ret;
+
+	virtio_device_ready(vdev);
 
-	return ret;
+	blk_mq_start_stopped_hw_queues(vblk->disk->queue, true);
+	return 0;
 }
 #endif
 
-- 
MST


