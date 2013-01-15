Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933850Ab3AOX0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:26:09 -0500
Received: from mail.kernel.org ([198.145.19.201]:47010 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933727Ab3AOWwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:52:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Josh Durgin <josh.durgin@dreamhost.com>,
        Alex Elder <elder@inktank.com>
Subject: [ 135/171] rbd: expose the correct size of the device in sysfs
Date: Tue, 15 Jan 2013 14:45:00 -0800
Message-Id: <20130115224323.084985943@linuxfoundation.org>
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

If an image was mapped to a snapshot, the size of the head version
would be shown. Protect capacity with header_rwsem, since it may
change.

Signed-off-by: Josh Durgin <josh.durgin@dreamhost.com>
Reviewed-by: Alex Elder <elder@inktank.com>
(cherry picked from commit a51aa0c042fa39946dd017d5f91a073300a71577)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/rbd.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -1720,6 +1720,8 @@ static int __rbd_update_snaps(struct rbd
 	if (ret < 0)
 		return ret;
 
+	down_write(&rbd_dev->header_rwsem);
+
 	/* resized? */
 	if (rbd_dev->snap_id == CEPH_NOSNAP) {
 		sector_t size = (sector_t) h.image_size / SECTOR_SIZE;
@@ -1728,8 +1730,6 @@ static int __rbd_update_snaps(struct rbd
 		set_capacity(rbd_dev->disk, size);
 	}
 
-	down_write(&rbd_dev->header_rwsem);
-
 	snap_seq = rbd_dev->header.snapc->seq;
 	if (rbd_dev->header.total_snaps &&
 	    rbd_dev->header.snapc->snaps[0] == snap_seq)
@@ -1844,8 +1844,13 @@ static ssize_t rbd_size_show(struct devi
 			     struct device_attribute *attr, char *buf)
 {
 	struct rbd_device *rbd_dev = dev_to_rbd_dev(dev);
+	sector_t size;
+
+	down_read(&rbd_dev->header_rwsem);
+	size = get_capacity(rbd_dev->disk);
+	up_read(&rbd_dev->header_rwsem);
 
-	return sprintf(buf, "%llu\n", (unsigned long long)rbd_dev->header.image_size);
+	return sprintf(buf, "%llu\n", (unsigned long long) size * SECTOR_SIZE);
 }
 
 static ssize_t rbd_major_show(struct device *dev,


