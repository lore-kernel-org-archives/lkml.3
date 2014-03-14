Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbaCNRb1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 13:31:27 -0400
Received: from imap.thunk.org ([74.207.234.97]:41477 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755950AbaCNRbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 13:31:25 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, fes@google.com
Subject: [PATCH] virtio-blk: make the queue depth configurable
Date: Fri, 14 Mar 2014 13:31:03 -0400
Message-Id: <1394818263-29947-1-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.9.0
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current virtio block sets a queue depth of 64.  With a
sufficiently fast device, using a queue depth of 256 can double the
IOPS which can be sustained.  So make the queue depth something which
can be set at module load time or via a kernel boot-time parameter.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtio-dev@lists.oasis-open.org
Cc: virtualization@lists.linux-foundation.org
Cc: fes@google.com
---
 drivers/block/virtio_blk.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 6a680d4..0c9e57f 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -481,6 +481,9 @@ static struct blk_mq_ops virtio_mq_ops = {
 	.free_hctx	= blk_mq_free_single_hw_queue,
 };
 
+static int queue_depth = 64;
+module_param(queue_depth, int, 444);
+
 static struct blk_mq_reg virtio_mq_reg = {
 	.ops		= &virtio_mq_ops,
 	.nr_hw_queues	= 1,
@@ -551,6 +554,7 @@ static int virtblk_probe(struct virtio_device *vdev)
 		goto out_free_vq;
 	}
 
+	virtio_mq_reg.queue_depth = queue_depth;
 	virtio_mq_reg.cmd_size =
 		sizeof(struct virtblk_req) +
 		sizeof(struct scatterlist) * sg_elems;
-- 
1.9.0

