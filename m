Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab3BCOys (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:54:48 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34054 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752933Ab3BCOyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:54:41 -0500
Message-Id: <20130203144644.330068882@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:46:47 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Alexander Graf <agraf@suse.de>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [ 003/128] virtio-blk: Dont free ida when disk is in use
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/block/virtio_blk.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -546,6 +546,7 @@ static void __devexit virtblk_remove(str
 {
 	struct virtio_blk *vblk = vdev->priv;
 	int index = vblk->index;
+	int refc;
 
 	/* Prevent config work handler from accessing the device. */
 	mutex_lock(&vblk->config_lock);
@@ -560,11 +561,15 @@ static void __devexit virtblk_remove(str
 
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
 
 static const struct virtio_device_id id_table[] = {


