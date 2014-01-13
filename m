Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbaAMQES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:04:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53421 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171AbaAMQDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:03:55 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Josh Durgin <josh.durgin@inktank.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 128/208] rbd: fix use-after free of rbd_dev->disk
Date: Mon, 13 Jan 2014 15:59:29 +0000
Message-Id: <1389628849-1614-129-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Durgin <josh.durgin@inktank.com>

commit 9875201e10496612080e7d164acc8f625c18725c upstream.

Removing a device deallocates the disk, unschedules the watch, and
finally cleans up the rbd_dev structure. rbd_dev_refresh(), called
from the watch callback, updates the disk size and rbd_dev
structure. With no locking between them, rbd_dev_refresh() may use the
device or rbd_dev after they've been freed.

To fix this, check whether RBD_DEV_FLAG_REMOVING is set before
updating the disk size in rbd_dev_refresh(). In order to prevent a
race where rbd_dev_refresh() is already revalidating the disk when
rbd_remove() is called, move the call to rbd_bus_del_dev() after the
watch is unregistered and all notifies are complete. It's safe to
defer deleting this structure because no new requests can be submitted
once the RBD_DEV_FLAG_REMOVING is set, since the device cannot be
opened.

Fixes: http://tracker.ceph.com/issues/5636
Signed-off-by: Josh Durgin <josh.durgin@inktank.com>
Reviewed-by: Alex Elder <elder@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/block/rbd.c | 40 +++++++++++++++++++++++++++++++++-------
 1 file changed, 33 insertions(+), 7 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index d88a27d..0f5307f 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -3325,6 +3325,31 @@ static void rbd_exists_validate(struct rbd_device *rbd_dev)
 		clear_bit(RBD_DEV_FLAG_EXISTS, &rbd_dev->flags);
 }
 
+static void rbd_dev_update_size(struct rbd_device *rbd_dev)
+{
+	sector_t size;
+	bool removing;
+
+	/*
+	 * Don't hold the lock while doing disk operations,
+	 * or lock ordering will conflict with the bdev mutex via:
+	 * rbd_add() -> blkdev_get() -> rbd_open()
+	 */
+	spin_lock_irq(&rbd_dev->lock);
+	removing = test_bit(RBD_DEV_FLAG_REMOVING, &rbd_dev->flags);
+	spin_unlock_irq(&rbd_dev->lock);
+	/*
+	 * If the device is being removed, rbd_dev->disk has
+	 * been destroyed, so don't try to update its size
+	 */
+	if (!removing) {
+		size = (sector_t)rbd_dev->mapping.size / SECTOR_SIZE;
+		dout("setting size to %llu sectors", (unsigned long long)size);
+		set_capacity(rbd_dev->disk, size);
+		revalidate_disk(rbd_dev->disk);
+	}
+}
+
 static int rbd_dev_refresh(struct rbd_device *rbd_dev)
 {
 	u64 mapping_size;
@@ -3344,12 +3369,7 @@ static int rbd_dev_refresh(struct rbd_device *rbd_dev)
 	up_write(&rbd_dev->header_rwsem);
 
 	if (mapping_size != rbd_dev->mapping.size) {
-		sector_t size;
-
-		size = (sector_t)rbd_dev->mapping.size / SECTOR_SIZE;
-		dout("setting size to %llu sectors", (unsigned long long)size);
-		set_capacity(rbd_dev->disk, size);
-		revalidate_disk(rbd_dev->disk);
+		rbd_dev_update_size(rbd_dev);
 	}
 
 	return ret;
@@ -5160,7 +5180,6 @@ static ssize_t rbd_remove(struct bus_type *bus,
 	if (ret < 0 || already)
 		return ret;
 
-	rbd_bus_del_dev(rbd_dev);
 	ret = rbd_dev_header_watch_sync(rbd_dev, false);
 	if (ret)
 		rbd_warn(rbd_dev, "failed to cancel watch event (%d)\n", ret);
@@ -5171,6 +5190,13 @@ static ssize_t rbd_remove(struct bus_type *bus,
 	 */
 	dout("%s: flushing notifies", __func__);
 	ceph_osdc_flush_notifies(&rbd_dev->rbd_client->client->osdc);
+	/*
+	 * Don't free anything from rbd_dev->disk until after all
+	 * notifies are completely processed. Otherwise
+	 * rbd_bus_del_dev() will race with rbd_watch_cb(), resulting
+	 * in a potential use after free of rbd_dev->disk or rbd_dev.
+	 */
+	rbd_bus_del_dev(rbd_dev);
 	rbd_dev_image_release(rbd_dev);
 	module_put(THIS_MODULE);
 
-- 
1.8.3.2

