Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbaJFPL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 11:11:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085AbaJFPHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 11:07:32 -0400
Date: Mon, 6 Oct 2014 18:10:58 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v2 05/15] virtio_blk: drop config_enable
Message-ID: <1412608214-31944-6-git-send-email-mst@redhat.com>
References: <1412608214-31944-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412608214-31944-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that virtio core ensures config changes don't
arrive during probing, drop config_enable flag
in virtio blk.
On removal, flush is now sufficient to guarantee that
no change work is queued.

This help simplify the driver, and will allow
setting DRIVER_OK earlier without losing config
change notifications.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/block/virtio_blk.c | 23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 0a58140..91272f1a 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -44,9 +44,6 @@ struct virtio_blk
 	/* Lock for config space updates */
 	struct mutex config_lock;
 
-	/* enable config space updates */
-	bool config_enable;
-
 	/* What host tells us, plus 2 for header & tailer. */
 	unsigned int sg_elems;
 
@@ -348,8 +345,6 @@ static void virtblk_config_changed_work(struct work_struct *work)
 	u64 capacity, size;
 
 	mutex_lock(&vblk->config_lock);
-	if (!vblk->config_enable)
-		goto done;
 
 	/* Host must always specify the capacity. */
 	virtio_cread(vdev, struct virtio_blk_config, capacity, &capacity);
@@ -374,7 +369,7 @@ static void virtblk_config_changed_work(struct work_struct *work)
 	set_capacity(vblk->disk, capacity);
 	revalidate_disk(vblk->disk);
 	kobject_uevent_env(&disk_to_dev(vblk->disk)->kobj, KOBJ_CHANGE, envp);
-done:
+
 	mutex_unlock(&vblk->config_lock);
 }
 
@@ -609,7 +604,6 @@ static int virtblk_probe(struct virtio_device *vdev)
 	mutex_init(&vblk->config_lock);
 
 	INIT_WORK(&vblk->config_work, virtblk_config_changed_work);
-	vblk->config_enable = true;
 
 	err = init_vq(vblk);
 	if (err)
@@ -771,10 +765,8 @@ static void virtblk_remove(struct virtio_device *vdev)
 	int index = vblk->index;
 	int refc;
 
-	/* Prevent config work handler from accessing the device. */
-	mutex_lock(&vblk->config_lock);
-	vblk->config_enable = false;
-	mutex_unlock(&vblk->config_lock);
+	/* Make sure no work handler is accessing the device. */
+	flush_work(&vblk->config_work);
 
 	del_gendisk(vblk->disk);
 	blk_cleanup_queue(vblk->disk->queue);
@@ -784,8 +776,6 @@ static void virtblk_remove(struct virtio_device *vdev)
 	/* Stop all the virtqueues. */
 	vdev->config->reset(vdev);
 
-	flush_work(&vblk->config_work);
-
 	refc = atomic_read(&disk_to_dev(vblk->disk)->kobj.kref.refcount);
 	put_disk(vblk->disk);
 	vdev->config->del_vqs(vdev);
@@ -805,11 +795,7 @@ static int virtblk_freeze(struct virtio_device *vdev)
 	/* Ensure we don't receive any more interrupts */
 	vdev->config->reset(vdev);
 
-	/* Prevent config work handler from accessing the device. */
-	mutex_lock(&vblk->config_lock);
-	vblk->config_enable = false;
-	mutex_unlock(&vblk->config_lock);
-
+	/* Make sure no work handler is accessing the device. */
 	flush_work(&vblk->config_work);
 
 	blk_mq_stop_hw_queues(vblk->disk->queue);
@@ -823,7 +809,6 @@ static int virtblk_restore(struct virtio_device *vdev)
 	struct virtio_blk *vblk = vdev->priv;
 	int ret;
 
-	vblk->config_enable = true;
 	ret = init_vq(vdev->priv);
 	if (!ret)
 		blk_mq_start_stopped_hw_queues(vblk->disk->queue, true);
-- 
MST

