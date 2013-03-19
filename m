Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933481Ab3CSRVO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 13:21:14 -0400
Received: from mail09.linbit.com ([212.69.161.110]:44616 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933264Ab3CSRRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 13:17:04 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, drbd-dev@lists.linbit.com,
        lars.ellenberg@linbit.com
Subject: [PATCH 05/18] drbd: mechanically rename la_size to la_size_sect
Date: Tue, 19 Mar 2013 18:16:46 +0100
Message-Id: <1363713419-17803-6-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363713419-17803-1-git-send-email-philipp.reisner@linbit.com>
References: <1363713419-17803-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

Make it obvious that this value is in units of 512 Byte sectors.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_main.c     |    6 +++---
 drivers/block/drbd/drbd_nl.c       |   16 ++++++++--------
 drivers/block/drbd/drbd_receiver.c |    2 +-
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index b9bfb10..d8bbb41 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2839,7 +2839,7 @@ void conn_md_sync(struct drbd_tconn *tconn)
 
 /* aligned 4kByte */
 struct meta_data_on_disk {
-	u64 la_size;           /* last agreed size. */
+	u64 la_size_sect;      /* last agreed size. */
 	u64 uuid[UI_SIZE];   /* UUIDs. */
 	u64 device_uuid;
 	u64 reserved_u64_1;
@@ -2890,7 +2890,7 @@ void drbd_md_sync(struct drbd_conf *mdev)
 
 	memset(buffer, 0, sizeof(*buffer));
 
-	buffer->la_size = cpu_to_be64(drbd_get_capacity(mdev->this_bdev));
+	buffer->la_size_sect = cpu_to_be64(drbd_get_capacity(mdev->this_bdev));
 	for (i = UI_CURRENT; i < UI_SIZE; i++)
 		buffer->uuid[i] = cpu_to_be64(mdev->ldev->md.uuid[i]);
 	buffer->flags = cpu_to_be32(mdev->ldev->md.flags);
@@ -3052,7 +3052,7 @@ int drbd_md_read(struct drbd_conf *mdev, struct drbd_backing_dev *bdev)
 
 	rv = NO_ERROR;
 
-	bdev->md.la_size_sect = be64_to_cpu(buffer->la_size);
+	bdev->md.la_size_sect = be64_to_cpu(buffer->la_size_sect);
 	for (i = UI_CURRENT; i < UI_SIZE; i++)
 		bdev->md.uuid[i] = be64_to_cpu(buffer->uuid[i]);
 	bdev->md.flags = be32_to_cpu(buffer->flags);
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 5621df8..d5211b0 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -819,7 +819,7 @@ void drbd_resume_io(struct drbd_conf *mdev)
 enum determine_dev_size drbd_determine_dev_size(struct drbd_conf *mdev, enum dds_flags flags) __must_hold(local)
 {
 	sector_t prev_first_sect, prev_size; /* previous meta location */
-	sector_t la_size, u_size;
+	sector_t la_size_sect, u_size;
 	sector_t size;
 	char ppb[10];
 
@@ -842,7 +842,7 @@ enum determine_dev_size drbd_determine_dev_size(struct drbd_conf *mdev, enum dds
 
 	prev_first_sect = drbd_md_first_sector(mdev->ldev);
 	prev_size = mdev->ldev->md.md_size_sect;
-	la_size = mdev->ldev->md.la_size_sect;
+	la_size_sect = mdev->ldev->md.la_size_sect;
 
 	/* TODO: should only be some assert here, not (re)init... */
 	drbd_md_set_sector_offsets(mdev, mdev->ldev);
@@ -878,7 +878,7 @@ enum determine_dev_size drbd_determine_dev_size(struct drbd_conf *mdev, enum dds
 	if (rv == dev_size_error)
 		goto out;
 
-	la_size_changed = (la_size != mdev->ldev->md.la_size_sect);
+	la_size_changed = (la_size_sect != mdev->ldev->md.la_size_sect);
 
 	md_moved = prev_first_sect != drbd_md_first_sector(mdev->ldev)
 		|| prev_size	   != mdev->ldev->md.md_size_sect;
@@ -900,9 +900,9 @@ enum determine_dev_size drbd_determine_dev_size(struct drbd_conf *mdev, enum dds
 		drbd_md_mark_dirty(mdev);
 	}
 
-	if (size > la_size)
+	if (size > la_size_sect)
 		rv = grew;
-	if (size < la_size)
+	if (size < la_size_sect)
 		rv = shrunk;
 out:
 	lc_unlock(mdev->act_log);
@@ -917,7 +917,7 @@ drbd_new_dev_size(struct drbd_conf *mdev, struct drbd_backing_dev *bdev,
 		  sector_t u_size, int assume_peer_has_space)
 {
 	sector_t p_size = mdev->p_size;   /* partner's disk size. */
-	sector_t la_size = bdev->md.la_size_sect; /* last agreed size. */
+	sector_t la_size_sect = bdev->md.la_size_sect; /* last agreed size. */
 	sector_t m_size; /* my size */
 	sector_t size = 0;
 
@@ -931,8 +931,8 @@ drbd_new_dev_size(struct drbd_conf *mdev, struct drbd_backing_dev *bdev,
 	if (p_size && m_size) {
 		size = min_t(sector_t, p_size, m_size);
 	} else {
-		if (la_size) {
-			size = la_size;
+		if (la_size_sect) {
+			size = la_size_sect;
 			if (m_size && m_size < size)
 				size = m_size;
 			if (p_size && p_size < size)
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index a9eccfc..8172a2c 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -3992,7 +3992,7 @@ static int receive_state(struct drbd_tconn *tconn, struct packet_info *pi)
 
 	clear_bit(DISCARD_MY_DATA, &mdev->flags);
 
-	drbd_md_sync(mdev); /* update connected indicator, la_size, ... */
+	drbd_md_sync(mdev); /* update connected indicator, la_size_sect, ... */
 
 	return 0;
 }
-- 
1.7.9.5

