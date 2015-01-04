Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbbADPZa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 10:25:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35002 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630AbbADPZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 10:25:29 -0500
Date: Sun, 4 Jan 2015 17:25:18 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH] virtio: make del_vqs idempotent
Message-ID: <1420385102-6637-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Our code calls del_vqs multiple times, assuming
it's idempotent.

commit 3ec7a77bb3089bb01032fdbd958eb5c29da58b49
    virtio_pci: free up vq->priv
broke this assumption, by adding kfree there,
so multiple calls cause double free.

Fix it up.

Fixes: 3ec7a77bb3089bb01032fdbd958eb5c29da58b49
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio_pci_common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
index 08d0b04..557cbcb 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -282,6 +282,7 @@ void vp_del_vqs(struct virtio_device *vdev)
 
 	vp_free_vectors(vdev);
 	kfree(vp_dev->vqs);
+	vp_dev->vqs = NULL;
 }
 
 static int vp_try_to_find_vqs(struct virtio_device *vdev, unsigned nvqs,
-- 
MST
