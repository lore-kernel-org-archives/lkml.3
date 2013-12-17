Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab3LQSaI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:30:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:32780 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810Ab3LQSPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:15:07 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michael Marineau <michael.marineau@coreos.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 061/103] 9p: send uevent after adding/removing mount_tag attribute
Date: Tue, 17 Dec 2013 18:12:50 +0000
Message-Id: <1387304012-23805-62-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
References: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.28 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Marineau <michael.marineau@coreos.com>

commit e0d6cb9cd3a3ac8a3b8e5b22b83c4f8619786f22 upstream.

This driver adds an attribute to the existing virtio device so a CHANGE
event is required in order udev rules to make use of it. The ADD event
happens before this driver is probed and unlike a more typical driver
like a block device there isn't a higher level device to watch for.

Signed-off-by: Michael Marineau <michael.marineau@coreos.com>
Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/9p/trans_virtio.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index 2a16765..6c3d561 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -546,6 +546,10 @@ static int p9_virtio_probe(struct virtio_device *vdev)
 	mutex_lock(&virtio_9p_lock);
 	list_add_tail(&chan->chan_list, &virtio_chan_list);
 	mutex_unlock(&virtio_9p_lock);
+
+	/* Let udev rules use the new mount_tag attribute. */
+	kobject_uevent(&(vdev->dev.kobj), KOBJ_CHANGE);
+
 	return 0;
 
 out_free_tag:
@@ -623,6 +627,7 @@ static void p9_virtio_remove(struct virtio_device *vdev)
 	list_del(&chan->chan_list);
 	mutex_unlock(&virtio_9p_lock);
 	sysfs_remove_file(&(vdev->dev.kobj), &dev_attr_mount_tag.attr);
+	kobject_uevent(&(vdev->dev.kobj), KOBJ_CHANGE);
 	kfree(chan->tag);
 	kfree(chan->vc_wq);
 	kfree(chan);
-- 
1.8.3.2

