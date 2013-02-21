Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736Ab3BUTLa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 14:11:30 -0500
Received: from mail4.sde.cz ([85.93.125.197]:46473 "EHLO zimbra.sde"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752309Ab3BUTL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 14:11:29 -0500
X-Greylist: delayed 519 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Feb 2013 14:11:29 EST
From: Milos Vyletel <milos.vyletel@sde.cz>
To: linux-kernel@vger.kernel.org
Cc: virtualization@lists.linux-foundation.org, mst@redhat.com,
        rusty@rustcorp.com.au, Milos Vyletel <milos.vyletel@sde.cz>
Subject: [PATCH] virtio-blk: emit udev event when device is resized
Date: Thu, 21 Feb 2013 14:02:28 -0500
Message-Id: <1361473348-7660-1-git-send-email-milos.vyletel@sde.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When virtio-blk device is resized from host (using block_resize from QEMU) emit
KOBJ_CHANGE uevent to notify guest about such change. This allows user to have
custom udev rules which would take whatever action if such event occurs. As a
proof of concept I've created simple udev rule that automatically resize
filesystem on virtio-blk device.

ACTION=="change", KERNEL=="vd*", \
        ENV{RESIZE}=="1", \
        ENV{ID_FS_TYPE}=="ext[3-4]", \
        RUN+="/sbin/resize2fs /dev/%k"
ACTION=="change", KERNEL=="vd*", \
        ENV{RESIZE}=="1", \
        ENV{ID_FS_TYPE}=="LVM2_member", \
        RUN+="/sbin/pvresize /dev/%k"

Signed-off-by: Milos Vyletel <milos.vyletel@sde.cz>
---
 drivers/block/virtio_blk.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 8ad21a2..5990382 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -539,6 +539,8 @@ static void virtblk_config_changed_work(struct work_struct *work)
 	struct virtio_device *vdev = vblk->vdev;
 	struct request_queue *q = vblk->disk->queue;
 	char cap_str_2[10], cap_str_10[10];
+	char event[] = "RESIZE=1";
+	char *envp[] = { event, NULL };
 	u64 capacity, size;
 
 	mutex_lock(&vblk->config_lock);
@@ -568,6 +570,7 @@ static void virtblk_config_changed_work(struct work_struct *work)
 
 	set_capacity(vblk->disk, capacity);
 	revalidate_disk(vblk->disk);
+	kobject_uevent_env(&disk_to_dev(vblk->disk)->kobj, KOBJ_CHANGE, envp);
 done:
 	mutex_unlock(&vblk->config_lock);
 }
-- 
1.7.1

