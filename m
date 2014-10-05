Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058AbaJEQEL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 12:04:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38673 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018AbaJEQD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 12:03:59 -0400
Date: Sun, 5 Oct 2014 19:07:27 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 13/16] virtio_blk: enable VQs early
Message-ID: <1412525038-15871-14-git-send-email-mst@redhat.com>
References: <1412525038-15871-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412525038-15871-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virtio spec requires drivers to set DRIVER_OK before using VQs.
This is set automatically after probe returns, virtio block violated this
rule by calling add_disk, which causes the VQ to be used directly within
probe.

To fix, call virtio_early_enable_vqs before using VQs.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/block/virtio_blk.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 13c384b..e59ae859 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -719,6 +719,8 @@ static int virtblk_probe(struct virtio_device *vdev)
 	if (!err && opt_io_size)
 		blk_queue_io_opt(q, blk_size * opt_io_size);
 
+	virtio_early_enable_vqs(vdev);
+
 	add_disk(vblk->disk);
 	err = device_create_file(disk_to_dev(vblk->disk), &dev_attr_serial);
 	if (err)
-- 
MST

