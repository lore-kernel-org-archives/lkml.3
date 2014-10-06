Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbaJFPHo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 11:07:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111AbaJFPHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 11:07:39 -0400
Date: Mon, 6 Oct 2014 18:11:01 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org,
        Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: [PATCH v2 06/15] virtio-blk: drop config_mutex
Message-ID: <1412608214-31944-7-git-send-email-mst@redhat.com>
References: <1412608214-31944-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412608214-31944-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

config_mutex served two purposes: prevent multiple concurrent config
change handlers, and synchronize access to config_enable flag.

Since commit dbf2576e37da0fcc7aacbfbb9fd5d3de7888a3c1
    workqueue: make all workqueues non-reentrant
all workqueues are non-reentrant, and config_enable
is now gone.

Get rid of the unnecessary lock.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>
---
 drivers/block/virtio_blk.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 91272f1a..89ba8d6 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -41,9 +41,6 @@ struct virtio_blk
 	/* Process context for config space updates */
 	struct work_struct config_work;
 
-	/* Lock for config space updates */
-	struct mutex config_lock;
-
 	/* What host tells us, plus 2 for header & tailer. */
 	unsigned int sg_elems;
 
@@ -344,8 +341,6 @@ static void virtblk_config_changed_work(struct work_struct *work)
 	char *envp[] = { "RESIZE=1", NULL };
 	u64 capacity, size;
 
-	mutex_lock(&vblk->config_lock);
-
 	/* Host must always specify the capacity. */
 	virtio_cread(vdev, struct virtio_blk_config, capacity, &capacity);
 
@@ -369,8 +364,6 @@ static void virtblk_config_changed_work(struct work_struct *work)
 	set_capacity(vblk->disk, capacity);
 	revalidate_disk(vblk->disk);
 	kobject_uevent_env(&disk_to_dev(vblk->disk)->kobj, KOBJ_CHANGE, envp);
-
-	mutex_unlock(&vblk->config_lock);
 }
 
 static void virtblk_config_changed(struct virtio_device *vdev)
@@ -601,7 +594,6 @@ static int virtblk_probe(struct virtio_device *vdev)
 
 	vblk->vdev = vdev;
 	vblk->sg_elems = sg_elems;
-	mutex_init(&vblk->config_lock);
 
 	INIT_WORK(&vblk->config_work, virtblk_config_changed_work);
 
-- 
MST

