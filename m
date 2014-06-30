Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258AbaF3QBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:01:34 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:50031 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035AbaF3PxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:53:12 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 06/18] drbd: allow write-ordering policy to be bumped up again
Date: Mon, 30 Jun 2014 17:52:55 +0200
Message-Id: <1404143587-24344-7-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404143587-24344-1-git-send-email-philipp.reisner@linbit.com>
References: <1404143587-24344-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

Previously, once you disabled flushes as a means of enforcing
write-ordering, you'd need to detach/re-attach to enable them again.

Allow drbdsetup disk-options to re-enable previously disabled
write-ordering policy options at runtime.

While at it fix RCU in drbd_bump_write_ordering()
max_allowed_wo() uses rcu_dereference, therefore it must
be called within rcu_read_lock()/rcu_read_unlock()

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_nl.c       | 10 +++++++++-
 drivers/block/drbd/drbd_receiver.c |  6 ++++--
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 0bf8a60..66065e6 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1294,6 +1294,13 @@ static unsigned int drbd_al_extents_max(struct drbd_backing_dev *bdev)
 	return (al_size_4k - 1) * AL_CONTEXT_PER_TRANSACTION;
 }
 
+static bool write_ordering_changed(struct disk_conf *a, struct disk_conf *b)
+{
+	return	a->disk_barrier != b->disk_barrier ||
+		a->disk_flushes != b->disk_flushes ||
+		a->disk_drain != b->disk_drain;
+}
+
 int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 {
 	struct drbd_config_context adm_ctx;
@@ -1400,7 +1407,8 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 	else
 		set_bit(MD_NO_FUA, &device->flags);
 
-	drbd_bump_write_ordering(device->resource, NULL, WO_bdev_flush);
+	if (write_ordering_changed(old_disk_conf, new_disk_conf))
+		drbd_bump_write_ordering(device->resource, NULL, WO_bdev_flush);
 
 	drbd_md_sync(device);
 
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index bb1434d..8d8a6b7 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1290,7 +1290,8 @@ void drbd_bump_write_ordering(struct drbd_resource *resource, struct drbd_backin
 	};
 
 	pwo = resource->write_ordering;
-	wo = min(pwo, wo);
+	if (wo != WO_bdev_flush)
+		wo = min(pwo, wo);
 	rcu_read_lock();
 	idr_for_each_entry(&resource->devices, device, vnr) {
 		if (get_ldev(device)) {
@@ -1300,11 +1301,12 @@ void drbd_bump_write_ordering(struct drbd_resource *resource, struct drbd_backin
 			put_ldev(device);
 		}
 	}
-	rcu_read_unlock();
 
 	if (bdev)
 		wo = max_allowed_wo(bdev, wo);
 
+	rcu_read_unlock();
+
 	resource->write_ordering = wo;
 	if (pwo != resource->write_ordering || wo == WO_bdev_flush)
 		drbd_info(resource, "Method to ensure write ordering: %s\n", write_ordering_str[resource->write_ordering]);
-- 
1.9.1

