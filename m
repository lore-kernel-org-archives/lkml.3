Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751232Ab3HKEyP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 00:54:15 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:60572 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab3HKEyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 00:54:12 -0400
From: Michael Marineau <michael.marineau@coreos.com>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Michael Marineau <michael.marineau@coreos.com>,
        v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] 9p: send uevent after adding/removing mount_tag attribute
Date: Sun, 11 Aug 2013 00:53:45 -0400
Message-Id: <1376196825-19793-1-git-send-email-michael.marineau@coreos.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver adds an attribute to the existing virtio device so a CHANGE
event is required in order udev rules to make use of it. The ADD event
happens before this driver is probed and unlike a more typical driver
like a block device there isn't a higher level device to watch for.

Signed-off-by: Michael Marineau <michael.marineau@coreos.com>
---
 net/9p/trans_virtio.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index e1c26b1..990afab 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -577,6 +577,10 @@ static int p9_virtio_probe(struct virtio_device *vdev)
 	mutex_lock(&virtio_9p_lock);
 	list_add_tail(&chan->chan_list, &virtio_chan_list);
 	mutex_unlock(&virtio_9p_lock);
+
+	/* Let udev rules use the new mount_tag attribute. */
+	kobject_uevent(&(vdev->dev.kobj), KOBJ_CHANGE);
+
 	return 0;
 
 out_free_tag:
@@ -654,6 +658,7 @@ static void p9_virtio_remove(struct virtio_device *vdev)
 	list_del(&chan->chan_list);
 	mutex_unlock(&virtio_9p_lock);
 	sysfs_remove_file(&(vdev->dev.kobj), &dev_attr_mount_tag.attr);
+	kobject_uevent(&(vdev->dev.kobj), KOBJ_CHANGE);
 	kfree(chan->tag);
 	kfree(chan->vc_wq);
 	kfree(chan);
-- 
1.8.1.5

