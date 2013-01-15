Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933753Ab3AOWxD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:53:03 -0500
Received: from mail.kernel.org ([198.145.19.201]:47103 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932834Ab3AOWw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:52:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Josh Durgin <josh.durgin@dreamhost.com>,
        Alex Elder <elder@inktank.com>
Subject: [ 138/171] rbd: send header version when notifying
Date: Tue, 15 Jan 2013 14:45:03 -0800
Message-Id: <20130115224323.304819696@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Josh Durgin <josh.durgin@dreamhost.com>

Previously the original header version was sent. Now, we update it
when the header changes.

Signed-off-by: Josh Durgin <josh.durgin@dreamhost.com>
Reviewed-by: Alex Elder <elder@inktank.com>
(cherry picked from commit a71b891bc7d77a070e723c8c53d1dd73cf931555)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/rbd.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -1195,7 +1195,7 @@ static int rbd_req_sync_notify_ack(struc
 	if (ret < 0)
 		return ret;
 
-	ops[0].watch.ver = cpu_to_le64(dev->header.obj_version);
+	ops[0].watch.ver = cpu_to_le64(ver);
 	ops[0].watch.cookie = notify_id;
 	ops[0].watch.flag = 0;
 
@@ -1215,6 +1215,7 @@ static int rbd_req_sync_notify_ack(struc
 static void rbd_watch_cb(u64 ver, u64 notify_id, u8 opcode, void *data)
 {
 	struct rbd_device *dev = (struct rbd_device *)data;
+	u64 hver;
 	int rc;
 
 	if (!dev)
@@ -1224,12 +1225,13 @@ static void rbd_watch_cb(u64 ver, u64 no
 		notify_id, (int)opcode);
 	mutex_lock_nested(&ctl_mutex, SINGLE_DEPTH_NESTING);
 	rc = __rbd_update_snaps(dev);
+	hver = dev->header.obj_version;
 	mutex_unlock(&ctl_mutex);
 	if (rc)
 		pr_warning(RBD_DRV_NAME "%d got notification but failed to "
 			   " update snaps: %d\n", dev->major, rc);
 
-	rbd_req_sync_notify_ack(dev, ver, notify_id, dev->obj_md_name);
+	rbd_req_sync_notify_ack(dev, hver, notify_id, dev->obj_md_name);
 }
 
 /*
@@ -1740,6 +1742,7 @@ static int __rbd_update_snaps(struct rbd
 	kfree(rbd_dev->header.snap_names);
 	kfree(rbd_dev->header.snap_sizes);
 
+	rbd_dev->header.obj_version = h.obj_version;
 	rbd_dev->header.image_size = h.image_size;
 	rbd_dev->header.total_snaps = h.total_snaps;
 	rbd_dev->header.snapc = h.snapc;


