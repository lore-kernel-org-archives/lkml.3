Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbaK0McM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 07:32:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755385AbaK0McJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 07:32:09 -0500
Date: Thu, 27 Nov 2014 14:31:50 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, cornelia.huck@de.ibm.com,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v5 21/45] virtio_blk: fix race at module removal
Message-ID: <1417091078-24611-22-git-send-email-mst@redhat.com>
References: <1417091078-24611-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417091078-24611-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a device appears while module is being removed,
driver will get a callback after we've given up
on the major number.

In theory this means this major number can get reused
by something else, resulting in a conflict.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/block/virtio_blk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 055f3df..1f8b111 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -884,8 +884,8 @@ out_destroy_workqueue:
 
 static void __exit fini(void)
 {
-	unregister_blkdev(major, "virtblk");
 	unregister_virtio_driver(&virtio_blk);
+	unregister_blkdev(major, "virtblk");
 	destroy_workqueue(virtblk_wq);
 }
 module_init(init);
-- 
MST

