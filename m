Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873Ab3FYOvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 10:51:09 -0400
Received: from mail09.linbit.com ([212.69.161.110]:50609 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab3FYOuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 10:50:15 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 6/6] drbd: Allow online change of al-stripes and al-stripe-size
Date: Tue, 25 Jun 2013 16:50:08 +0200
Message-Id: <1372171808-30515-7-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1372171808-30515-1-git-send-email-philipp.reisner@linbit.com>
References: <1372171808-30515-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow to change the AL layout with an resize operation. For that
the reisze command gets two new fields: al_stripes and al_stripe_size.

In order to make the operation crash save:
1) Lock out all IO and MD-IO
2) Write the super block with MDF_PRIMARY_IND clear
3) write the bitmap to the new location (all zeros, since
   we allow only while connected)
4) Initialize the new AL-area
5) Write the super block with the restored MDF_PRIMARY_IND.
6) Unfreeze all IO

Since the AL-layout has no influence on the protocol, this operation
needs to be beforemed on both sides of a resource (if intended).

Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
---
 drivers/block/drbd/drbd_actlog.c   |   21 ++++++
 drivers/block/drbd/drbd_int.h      |    7 +-
 drivers/block/drbd/drbd_main.c     |   57 ++++++++-------
 drivers/block/drbd/drbd_nl.c       |  137 +++++++++++++++++++++++++++++-------
 drivers/block/drbd/drbd_receiver.c |    2 +-
 include/linux/drbd.h               |    6 +-
 include/linux/drbd_genl.h          |    2 +
 include/linux/drbd_limits.h        |    9 +++
 8 files changed, 188 insertions(+), 53 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index 6608076..28c73ca 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -659,6 +659,27 @@ void drbd_al_shrink(struct drbd_conf *mdev)
 	wake_up(&mdev->al_wait);
 }
 
+int drbd_initialize_al(struct drbd_conf *mdev, void *buffer)
+{
+	struct al_transaction_on_disk *al = buffer;
+	struct drbd_md *md = &mdev->ldev->md;
+	sector_t al_base = md->md_offset + md->al_offset;
+	int al_size_4k = md->al_stripes * md->al_stripe_size_4k;
+	int i;
+
+	memset(al, 0, 4096);
+	al->magic = cpu_to_be32(DRBD_AL_MAGIC);
+	al->transaction_type = cpu_to_be16(AL_TR_INITIALIZED);
+	al->crc32c = cpu_to_be32(crc32c(0, al, 4096));
+
+	for (i = 0; i < al_size_4k; i++) {
+		int err = drbd_md_sync_page_io(mdev, mdev->ldev, al_base + i * 8, WRITE);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
 static int w_update_odbm(struct drbd_work *w, int unused)
 {
 	struct update_odbm_work *udw = container_of(w, struct update_odbm_work, w);
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 4519d63..2d7f608 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1133,6 +1133,7 @@ extern void drbd_mdev_cleanup(struct drbd_conf *mdev);
 void drbd_print_uuids(struct drbd_conf *mdev, const char *text);
 
 extern void conn_md_sync(struct drbd_tconn *tconn);
+extern void drbd_md_write(struct drbd_conf *mdev, void *buffer);
 extern void drbd_md_sync(struct drbd_conf *mdev);
 extern int  drbd_md_read(struct drbd_conf *mdev, struct drbd_backing_dev *bdev);
 extern void drbd_uuid_set(struct drbd_conf *mdev, int idx, u64 val) __must_hold(local);
@@ -1468,12 +1469,15 @@ extern void drbd_resume_io(struct drbd_conf *mdev);
 extern char *ppsize(char *buf, unsigned long long size);
 extern sector_t drbd_new_dev_size(struct drbd_conf *, struct drbd_backing_dev *, sector_t, int);
 enum determine_dev_size {
+	DS_ERROR_SHRINK = -3,
+	DS_ERROR_SPACE_MD = -2,
 	DS_ERROR = -1,
 	DS_UNCHANGED = 0,
 	DS_SHRUNK = 1,
 	DS_GREW = 2
 };
-extern enum determine_dev_size drbd_determine_dev_size(struct drbd_conf *, enum dds_flags) __must_hold(local);
+extern enum determine_dev_size
+drbd_determine_dev_size(struct drbd_conf *, enum dds_flags, struct resize_parms *) __must_hold(local);
 extern void resync_after_online_grow(struct drbd_conf *);
 extern void drbd_reconsider_max_bio_size(struct drbd_conf *mdev);
 extern enum drbd_state_rv drbd_set_role(struct drbd_conf *mdev,
@@ -1639,6 +1643,7 @@ extern int __drbd_set_out_of_sync(struct drbd_conf *mdev, sector_t sector,
 #define drbd_set_out_of_sync(mdev, sector, size) \
 	__drbd_set_out_of_sync(mdev, sector, size, __FILE__, __LINE__)
 extern void drbd_al_shrink(struct drbd_conf *mdev);
+extern int drbd_initialize_al(struct drbd_conf *, void *);
 
 /* drbd_nl.c */
 /* state info broadcast */
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 49040a3..55635ed 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2879,34 +2879,14 @@ struct meta_data_on_disk {
 	u8 reserved_u8[4096 - (7*8 + 10*4)];
 } __packed;
 
-/**
- * drbd_md_sync() - Writes the meta data super block if the MD_DIRTY flag bit is set
- * @mdev:	DRBD device.
- */
-void drbd_md_sync(struct drbd_conf *mdev)
+
+
+void drbd_md_write(struct drbd_conf *mdev, void *b)
 {
-	struct meta_data_on_disk *buffer;
+	struct meta_data_on_disk *buffer = b;
 	sector_t sector;
 	int i;
 
-	/* Don't accidentally change the DRBD meta data layout. */
-	BUILD_BUG_ON(UI_SIZE != 4);
-	BUILD_BUG_ON(sizeof(struct meta_data_on_disk) != 4096);
-
-	del_timer(&mdev->md_sync_timer);
-	/* timer may be rearmed by drbd_md_mark_dirty() now. */
-	if (!test_and_clear_bit(MD_DIRTY, &mdev->flags))
-		return;
-
-	/* We use here D_FAILED and not D_ATTACHING because we try to write
-	 * metadata even if we detach due to a disk failure! */
-	if (!get_ldev_if_state(mdev, D_FAILED))
-		return;
-
-	buffer = drbd_md_get_buffer(mdev);
-	if (!buffer)
-		goto out;
-
 	memset(buffer, 0, sizeof(*buffer));
 
 	buffer->la_size_sect = cpu_to_be64(drbd_get_capacity(mdev->this_bdev));
@@ -2935,6 +2915,35 @@ void drbd_md_sync(struct drbd_conf *mdev)
 		dev_err(DEV, "meta data update failed!\n");
 		drbd_chk_io_error(mdev, 1, DRBD_META_IO_ERROR);
 	}
+}
+
+/**
+ * drbd_md_sync() - Writes the meta data super block if the MD_DIRTY flag bit is set
+ * @mdev:	DRBD device.
+ */
+void drbd_md_sync(struct drbd_conf *mdev)
+{
+	struct meta_data_on_disk *buffer;
+
+	/* Don't accidentally change the DRBD meta data layout. */
+	BUILD_BUG_ON(UI_SIZE != 4);
+	BUILD_BUG_ON(sizeof(struct meta_data_on_disk) != 4096);
+
+	del_timer(&mdev->md_sync_timer);
+	/* timer may be rearmed by drbd_md_mark_dirty() now. */
+	if (!test_and_clear_bit(MD_DIRTY, &mdev->flags))
+		return;
+
+	/* We use here D_FAILED and not D_ATTACHING because we try to write
+	 * metadata even if we detach due to a disk failure! */
+	if (!get_ldev_if_state(mdev, D_FAILED))
+		return;
+
+	buffer = drbd_md_get_buffer(mdev);
+	if (!buffer)
+		goto out;
+
+	drbd_md_write(mdev, buffer);
 
 	/* Update mdev->ldev->md.la_size_sect,
 	 * since we updated it on metadata. */
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 45d1275..8cc1e64 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -827,12 +827,17 @@ void drbd_resume_io(struct drbd_conf *mdev)
  * Returns 0 on success, negative return values indicate errors.
  * You should call drbd_md_sync() after calling this function.
  */
-enum determine_dev_size drbd_determine_dev_size(struct drbd_conf *mdev, enum dds_flags flags) __must_hold(local)
+enum determine_dev_size
+drbd_determine_dev_size(struct drbd_conf *mdev, enum dds_flags flags, struct resize_parms *rs) __must_hold(local)
 {
 	sector_t prev_first_sect, prev_size; /* previous meta location */
 	sector_t la_size_sect, u_size;
+	struct drbd_md *md = &mdev->ldev->md;
+	u32 prev_al_stripe_size_4k;
+	u32 prev_al_stripes;
 	sector_t size;
 	char ppb[10];
+	void *buffer;
 
 	int md_moved, la_size_changed;
 	enum determine_dev_size rv = DS_UNCHANGED;
@@ -847,6 +852,11 @@ enum determine_dev_size drbd_determine_dev_size(struct drbd_conf *mdev, enum dds
 	 * still lock the act_log to not trigger ASSERTs there.
 	 */
 	drbd_suspend_io(mdev);
+	buffer = drbd_md_get_buffer(mdev); /* Lock meta-data IO */
+	if (!buffer) {
+		drbd_resume_io(mdev);
+		return DS_ERROR;
+	}
 
 	/* no wait necessary anymore, actually we could assert that */
 	wait_event(mdev->al_wait, lc_try_lock(mdev->act_log));
@@ -855,7 +865,17 @@ enum determine_dev_size drbd_determine_dev_size(struct drbd_conf *mdev, enum dds
 	prev_size = mdev->ldev->md.md_size_sect;
 	la_size_sect = mdev->ldev->md.la_size_sect;
 
-	/* TODO: should only be some assert here, not (re)init... */
+	if (rs) {
+		/* rs is non NULL if we should change the AL layout only */
+
+		prev_al_stripes = md->al_stripes;
+		prev_al_stripe_size_4k = md->al_stripe_size_4k;
+
+		md->al_stripes = rs->al_stripes;
+		md->al_stripe_size_4k = rs->al_stripe_size / 4;
+		md->al_size_4k = (u64)rs->al_stripes * rs->al_stripe_size / 4;
+	}
+
 	drbd_md_set_sector_offsets(mdev, mdev->ldev);
 
 	rcu_read_lock();
@@ -863,6 +883,21 @@ enum determine_dev_size drbd_determine_dev_size(struct drbd_conf *mdev, enum dds
 	rcu_read_unlock();
 	size = drbd_new_dev_size(mdev, mdev->ldev, u_size, flags & DDSF_FORCED);
 
+	if (size < la_size_sect) {
+		if (rs && u_size == 0) {
+			/* Remove "rs &&" later. This check should always be active, but
+			   right now the receiver expects the permissive behavior */
+			dev_warn(DEV, "Implicit shrink not allowed. "
+				 "Use --size=%llus for explicit shrink.\n",
+				 (unsigned long long)size);
+			rv = DS_ERROR_SHRINK;
+		}
+		if (u_size > size)
+			rv = DS_ERROR_SPACE_MD;
+		if (rv != DS_UNCHANGED)
+			goto err_out;
+	}
+
 	if (drbd_get_capacity(mdev->this_bdev) != size ||
 	    drbd_bm_capacity(mdev) != size) {
 		int err;
@@ -886,38 +921,57 @@ enum determine_dev_size drbd_determine_dev_size(struct drbd_conf *mdev, enum dds
 		dev_info(DEV, "size = %s (%llu KB)\n", ppsize(ppb, size>>1),
 		     (unsigned long long)size>>1);
 	}
-	if (rv == DS_ERROR)
-		goto out;
+	if (rv <= DS_ERROR)
+		goto err_out;
 
 	la_size_changed = (la_size_sect != mdev->ldev->md.la_size_sect);
 
 	md_moved = prev_first_sect != drbd_md_first_sector(mdev->ldev)
 		|| prev_size	   != mdev->ldev->md.md_size_sect;
 
-	if (la_size_changed || md_moved) {
-		int err;
+	if (la_size_changed || md_moved || rs) {
+		u32 prev_flags;
 
 		drbd_al_shrink(mdev); /* All extents inactive. */
+
+		prev_flags = md->flags;
+		md->flags &= ~MDF_PRIMARY_IND;
+		drbd_md_write(mdev, buffer);
+
 		dev_info(DEV, "Writing the whole bitmap, %s\n",
 			 la_size_changed && md_moved ? "size changed and md moved" :
 			 la_size_changed ? "size changed" : "md moved");
 		/* next line implicitly does drbd_suspend_io()+drbd_resume_io() */
-		err = drbd_bitmap_io(mdev, md_moved ? &drbd_bm_write_all : &drbd_bm_write,
-				     "size changed", BM_LOCKED_MASK);
-		if (err) {
-			rv = DS_ERROR;
-			goto out;
-		}
-		drbd_md_mark_dirty(mdev);
+		drbd_bitmap_io(mdev, md_moved ? &drbd_bm_write_all : &drbd_bm_write,
+			       "size changed", BM_LOCKED_MASK);
+		drbd_initialize_al(mdev, buffer);
+
+		md->flags = prev_flags;
+		drbd_md_write(mdev, buffer);
+
+		if (rs)
+			dev_info(DEV, "Changed AL layout to al-stripes = %d, al-stripe-size-kB = %d\n",
+				 md->al_stripes, md->al_stripe_size_4k * 4);
 	}
 
 	if (size > la_size_sect)
 		rv = DS_GREW;
 	if (size < la_size_sect)
 		rv = DS_SHRUNK;
-out:
+
+	if (0) {
+	err_out:
+		if (rs) {
+			md->al_stripes = prev_al_stripes;
+			md->al_stripe_size_4k = prev_al_stripe_size_4k;
+			md->al_size_4k = (u64)prev_al_stripes * prev_al_stripe_size_4k;
+
+			drbd_md_set_sector_offsets(mdev, mdev->ldev);
+		}
+	}
 	lc_unlock(mdev->act_log);
 	wake_up(&mdev->al_wait);
+	drbd_md_put_buffer(mdev);
 	drbd_resume_io(mdev);
 
 	return rv;
@@ -1618,8 +1672,8 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	    !drbd_md_test_flag(mdev->ldev, MDF_CONNECTED_IND))
 		set_bit(USE_DEGR_WFC_T, &mdev->flags);
 
-	dd = drbd_determine_dev_size(mdev, 0);
-	if (dd == DS_ERROR) {
+	dd = drbd_determine_dev_size(mdev, 0, NULL);
+	if (dd <= DS_ERROR) {
 		retcode = ERR_NOMEM_BITMAP;
 		goto force_diskless_dec;
 	} else if (dd == DS_GREW)
@@ -2316,6 +2370,7 @@ int drbd_adm_resize(struct sk_buff *skb, struct genl_info *info)
 	struct drbd_conf *mdev;
 	enum drbd_ret_code retcode;
 	enum determine_dev_size dd;
+	bool change_al_layout = false;
 	enum dds_flags ddsf;
 	sector_t u_size;
 	int err;
@@ -2326,31 +2381,33 @@ int drbd_adm_resize(struct sk_buff *skb, struct genl_info *info)
 	if (retcode != NO_ERROR)
 		goto fail;
 
+	mdev = adm_ctx.mdev;
+	if (!get_ldev(mdev)) {
+		retcode = ERR_NO_DISK;
+		goto fail;
+	}
+
 	memset(&rs, 0, sizeof(struct resize_parms));
+	rs.al_stripes = mdev->ldev->md.al_stripes;
+	rs.al_stripe_size = mdev->ldev->md.al_stripe_size_4k * 4;
 	if (info->attrs[DRBD_NLA_RESIZE_PARMS]) {
 		err = resize_parms_from_attrs(&rs, info);
 		if (err) {
 			retcode = ERR_MANDATORY_TAG;
 			drbd_msg_put_info(from_attrs_err_to_txt(err));
-			goto fail;
+			goto fail_ldev;
 		}
 	}
 
-	mdev = adm_ctx.mdev;
 	if (mdev->state.conn > C_CONNECTED) {
 		retcode = ERR_RESIZE_RESYNC;
-		goto fail;
+		goto fail_ldev;
 	}
 
 	if (mdev->state.role == R_SECONDARY &&
 	    mdev->state.peer == R_SECONDARY) {
 		retcode = ERR_NO_PRIMARY;
-		goto fail;
-	}
-
-	if (!get_ldev(mdev)) {
-		retcode = ERR_NO_DISK;
-		goto fail;
+		goto fail_ldev;
 	}
 
 	if (rs.no_resync && mdev->tconn->agreed_pro_version < 93) {
@@ -2369,6 +2426,28 @@ int drbd_adm_resize(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
+	if (mdev->ldev->md.al_stripes != rs.al_stripes ||
+	    mdev->ldev->md.al_stripe_size_4k != rs.al_stripe_size / 4) {
+		u32 al_size_k = rs.al_stripes * rs.al_stripe_size;
+
+		if (al_size_k > (16 * 1024 * 1024)) {
+			retcode = ERR_MD_LAYOUT_TOO_BIG;
+			goto fail_ldev;
+		}
+
+		if (al_size_k < MD_32kB_SECT/2) {
+			retcode = ERR_MD_LAYOUT_TOO_SMALL;
+			goto fail_ldev;
+		}
+
+		if (mdev->state.conn != C_CONNECTED) {
+			retcode = ERR_MD_LAYOUT_CONNECTED;
+			goto fail_ldev;
+		}
+
+		change_al_layout = true;
+	}
+
 	if (mdev->ldev->known_size != drbd_get_capacity(mdev->ldev->backing_bdev))
 		mdev->ldev->known_size = drbd_get_capacity(mdev->ldev->backing_bdev);
 
@@ -2384,12 +2463,18 @@ int drbd_adm_resize(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	ddsf = (rs.resize_force ? DDSF_FORCED : 0) | (rs.no_resync ? DDSF_NO_RESYNC : 0);
-	dd = drbd_determine_dev_size(mdev, ddsf);
+	dd = drbd_determine_dev_size(mdev, ddsf, change_al_layout ? &rs : NULL);
 	drbd_md_sync(mdev);
 	put_ldev(mdev);
 	if (dd == DS_ERROR) {
 		retcode = ERR_NOMEM_BITMAP;
 		goto fail;
+	} else if (dd == DS_ERROR_SPACE_MD) {
+		retcode = ERR_MD_LAYOUT_NO_FIT;
+		goto fail;
+	} else if (dd == DS_ERROR_SHRINK) {
+		retcode = ERR_IMPLICIT_SHRINK;
+		goto fail;
 	}
 
 	if (mdev->state.conn == C_CONNECTED) {
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 26852b8..cc29cd3 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -3617,7 +3617,7 @@ static int receive_sizes(struct drbd_tconn *tconn, struct packet_info *pi)
 
 	ddsf = be16_to_cpu(p->dds_flags);
 	if (get_ldev(mdev)) {
-		dd = drbd_determine_dev_size(mdev, ddsf);
+		dd = drbd_determine_dev_size(mdev, ddsf, NULL);
 		put_ldev(mdev);
 		if (dd == DS_ERROR)
 			return -EIO;
diff --git a/include/linux/drbd.h b/include/linux/drbd.h
index 1b4d4ee..de7d74a 100644
--- a/include/linux/drbd.h
+++ b/include/linux/drbd.h
@@ -177,7 +177,11 @@ enum drbd_ret_code {
 	ERR_NEED_APV_100	= 163,
 	ERR_NEED_ALLOW_TWO_PRI  = 164,
 	ERR_MD_UNCLEAN          = 165,
-
+	ERR_MD_LAYOUT_CONNECTED = 166,
+	ERR_MD_LAYOUT_TOO_BIG   = 167,
+	ERR_MD_LAYOUT_TOO_SMALL = 168,
+	ERR_MD_LAYOUT_NO_FIT    = 169,
+	ERR_IMPLICIT_SHRINK     = 170,
 	/* insert new ones above this line */
 	AFTER_LAST_ERR_CODE
 };
diff --git a/include/linux/drbd_genl.h b/include/linux/drbd_genl.h
index d0d8fac..e8c4457 100644
--- a/include/linux/drbd_genl.h
+++ b/include/linux/drbd_genl.h
@@ -181,6 +181,8 @@ GENL_struct(DRBD_NLA_RESIZE_PARMS, 7, resize_parms,
 	__u64_field(1, DRBD_GENLA_F_MANDATORY,	resize_size)
 	__flg_field(2, DRBD_GENLA_F_MANDATORY,	resize_force)
 	__flg_field(3, DRBD_GENLA_F_MANDATORY,	no_resync)
+	__u32_field_def(4, 0 /* OPTIONAL */, al_stripes, DRBD_AL_STRIPES_DEF)
+	__u32_field_def(5, 0 /* OPTIONAL */, al_stripe_size, DRBD_AL_STRIPE_SIZE_DEF)
 )
 
 GENL_struct(DRBD_NLA_STATE_INFO, 8, state_info,
diff --git a/include/linux/drbd_limits.h b/include/linux/drbd_limits.h
index 1fedf2b..17e50bb 100644
--- a/include/linux/drbd_limits.h
+++ b/include/linux/drbd_limits.h
@@ -215,4 +215,13 @@
 #define DRBD_ALWAYS_ASBP_DEF	0
 #define DRBD_USE_RLE_DEF	1
 
+#define DRBD_AL_STRIPES_MIN     1
+#define DRBD_AL_STRIPES_MAX     1024
+#define DRBD_AL_STRIPES_DEF     1
+#define DRBD_AL_STRIPES_SCALE   '1'
+
+#define DRBD_AL_STRIPE_SIZE_MIN   4
+#define DRBD_AL_STRIPE_SIZE_MAX   16777216
+#define DRBD_AL_STRIPE_SIZE_DEF   32
+#define DRBD_AL_STRIPE_SIZE_SCALE 'k' /* kilobytes */
 #endif
-- 
1.7.9.5

