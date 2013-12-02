Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201Ab3LBUlU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:41:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38798 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273Ab3LBTOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:14:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Marineau <michael.marineau@coreos.com>,
        Eric Van Hensbergen <ericvh@gmail.com>
Subject: [PATCH 3.10 126/173] 9p: send uevent after adding/removing mount_tag attribute
Date: Mon,  2 Dec 2013 11:11:49 -0800
Message-Id: <20131202191158.003613691@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Marineau <michael.marineau@coreos.com>

commit e0d6cb9cd3a3ac8a3b8e5b22b83c4f8619786f22 upstream.

This driver adds an attribute to the existing virtio device so a CHANGE
event is required in order udev rules to make use of it. The ADD event
happens before this driver is probed and unlike a more typical driver
like a block device there isn't a higher level device to watch for.

Signed-off-by: Michael Marineau <michael.marineau@coreos.com>
Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/9p/trans_virtio.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -577,6 +577,10 @@ static int p9_virtio_probe(struct virtio
 	mutex_lock(&virtio_9p_lock);
 	list_add_tail(&chan->chan_list, &virtio_chan_list);
 	mutex_unlock(&virtio_9p_lock);
+
+	/* Let udev rules use the new mount_tag attribute. */
+	kobject_uevent(&(vdev->dev.kobj), KOBJ_CHANGE);
+
 	return 0;
 
 out_free_tag:
@@ -654,6 +658,7 @@ static void p9_virtio_remove(struct virt
 	list_del(&chan->chan_list);
 	mutex_unlock(&virtio_9p_lock);
 	sysfs_remove_file(&(vdev->dev.kobj), &dev_attr_mount_tag.attr);
+	kobject_uevent(&(vdev->dev.kobj), KOBJ_CHANGE);
 	kfree(chan->tag);
 	kfree(chan->vc_wq);
 	kfree(chan);


