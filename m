Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919Ab3AXVOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:14:24 -0500
Received: from mail.kernel.org ([198.145.19.201]:39989 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030193Ab3AXVNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:13:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alexander Graf <agraf@suse.de>, Rusty Russell <rusty@rustcorp.com.au>
Subject: [ 09/46] virtio-blk: Dont free ida when disk is in use
Date: Thu, 24 Jan 2013 13:12:47 -0800
Message-Id: <20130124211139.223231133@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130124211135.862755794@linuxfoundation.org>
References: <20130124211135.862755794@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/virtio_blk.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -889,6 +889,7 @@ static void __devexit virtblk_remove(str
 {
 	struct virtio_blk *vblk = vdev->priv;
 	int index = vblk->index;
+	int refc;
 
 	/* Prevent config work handler from accessing the device. */
 	mutex_lock(&vblk->config_lock);
@@ -903,11 +904,15 @@ static void __devexit virtblk_remove(str
 
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


