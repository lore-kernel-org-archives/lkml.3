Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996Ab3BEWHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:07:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47809 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756849Ab3BEWHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:07:38 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alexander Graf <agraf@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 01/93] virtio-blk: Don't free ida when disk is in use
Date: Tue,  5 Feb 2013 20:05:50 -0200
Message-Id: <1360102042-10732-2-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Graf <agraf@suse.de>

commit f4953fe6c4aeada2d5cafd78aa97587a46d2d8f9 upstream.

When a file system is mounted on a virtio-blk disk, we then remove it
and then reattach it, the reattached disk gets the same disk name and
ids as the hot removed one.

This leads to very nasty effects - mostly rendering the newly attached
device completely unusable.

Trying what happens when I do the same thing with a USB device, I saw
that the sd node simply doesn't get free'd when a device gets forcefully
removed.

Imitate the same behavior for vd devices. This way broken vd devices
simply are never free'd and newly attached ones keep working just fine.

Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/block/virtio_blk.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 774c31d..98bb43f 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -573,6 +573,7 @@ static void __devexit virtblk_remove(struct virtio_device *vdev)
 {
 	struct virtio_blk *vblk = vdev->priv;
 	int index = vblk->index;
+	int refc;
 
 	/* Prevent config work handler from accessing the device. */
 	mutex_lock(&vblk->config_lock);
@@ -587,11 +588,15 @@ static void __devexit virtblk_remove(struct virtio_device *vdev)
 
 	flush_work(&vblk->config_work);
 
+	refc = atomic_read(&disk_to_dev(vblk->disk)->kobj.kref.refcount);
 	put_disk(vblk->disk);
 	mempool_destroy(vblk->pool);
 	vdev->config->del_vqs(vdev);
 	kfree(vblk);
-	ida_simple_remove(&vd_index_ida, index);
+
+	/* Only free device id if we don't have any users */
+	if (refc == 1)
+		ida_simple_remove(&vd_index_ida, index);
 }
 
 #ifdef CONFIG_PM
-- 
1.7.9.5

