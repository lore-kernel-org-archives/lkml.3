Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144AbaJLLpD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 07:45:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105AbaJLLo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 07:44:57 -0400
Date: Sun, 12 Oct 2014 14:48:12 +0300
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
Subject: [PATCH v3 20/25] virtio_net: enable VQs early on restore
Message-ID: <1413114332-626-21-git-send-email-mst@redhat.com>
References: <1413114332-626-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413114332-626-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virtio spec requires drivers to set DRIVER_OK before using VQs.
This is set automatically after restore returns, virtio net violated this
rule by using receive VQs within restore.

To fix, call virtio_enable_vqs_early before using VQs.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>
---
 drivers/net/virtio_net.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 3551417..6b6e136 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1912,6 +1912,8 @@ static int virtnet_restore(struct virtio_device *vdev)
 	if (err)
 		return err;
 
+	virtio_enable_vqs_early(vdev);
+
 	if (netif_running(vi->dev)) {
 		for (i = 0; i < vi->curr_queue_pairs; i++)
 			if (!try_fill_recv(&vi->rq[i], GFP_KERNEL))
-- 
MST

