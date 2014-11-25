Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbaKYQnI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 11:43:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbaKYQnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 11:43:03 -0500
Date: Tue, 25 Nov 2014 18:42:46 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, cornelia.huck@de.ibm.com,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v4 19/42] virtio_blk: fix race at module removal
Message-ID: <1416933600-21398-20-git-send-email-mst@redhat.com>
References: <1416933600-21398-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416933600-21398-1-git-send-email-mst@redhat.com>
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

