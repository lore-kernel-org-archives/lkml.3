Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbaJMHrc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 03:47:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753652AbaJMHr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 03:47:28 -0400
Date: Mon, 13 Oct 2014 10:50:43 +0300
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
Subject: [PATCH v4 12/25] virtio_blk: enable VQs early
Message-ID: <1413114332-626-13-git-send-email-mst-v4@redhat.com>
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
This is set automatically after probe returns, virtio block violated this
rule by calling add_disk, which causes the VQ to be used directly within
probe.

To fix, call virtio_device_ready before using VQs.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>
---
 drivers/block/virtio_blk.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 89ba8d6..46b04bf 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -719,6 +719,8 @@ static int virtblk_probe(struct virtio_device *vdev)
 	if (!err && opt_io_size)
 		blk_queue_io_opt(q, blk_size * opt_io_size);
 
+	virtio_device_ready(vdev);
+
 	add_disk(vblk->disk);
 	err = device_create_file(disk_to_dev(vblk->disk), &dev_attr_serial);
 	if (err)
-- 
MST


