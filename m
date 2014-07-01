Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964880AbaGAQVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 12:21:33 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:53110 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757088AbaGAQQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 12:16:54 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 06/20] drbd: implement csums-after-crash-only
Date: Tue,  1 Jul 2014 18:16:36 +0200
Message-Id: <1404231410-29852-7-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404231410-29852-1-git-send-email-philipp.reisner@linbit.com>
References: <1404231410-29852-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

Checksum based resync trades CPU cycles for network bandwidth,
in situations where we expect much of the to-be-resynced blocks
to be actually identical on both sides already.

In a "network hickup" scenario, it won't help:
all to-be-resynced blocks will typically be different.

The use case is for the resync of *potentially* different blocks
after crash recovery -- the crash recovery had marked larger areas
(those covered by the activity log) as need-to-be-resynced,
just in case. Most of those blocks will be identical.

This option makes it possible to configure checksum based resync,
but only actually use it for the first resync after primary crash.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |  2 ++
 drivers/block/drbd/drbd_receiver.c |  2 ++
 drivers/block/drbd/drbd_worker.c   | 24 ++++++++++++++++++++----
 include/linux/drbd_genl.h          |  3 +++
 include/linux/drbd_limits.h        |  1 +
 5 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index abf5aef..fe6595a 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -738,6 +738,8 @@ struct drbd_device {
 	struct rb_root read_requests;
 	struct rb_root write_requests;
 
+	/* use checksums for *this* resync */
+	bool use_csums;
 	/* blocks to resync in this run [unit BM_BLOCK_SIZE] */
 	unsigned long rs_total;
 	/* number of resync blocks that failed in this run */
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 5626c5b..d326af6 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -2555,6 +2555,8 @@ static int receive_DataRequest(struct drbd_connection *connection, struct packet
 			peer_req->w.cb = w_e_end_csum_rs_req;
 			/* used in the sector offset progress display */
 			device->bm_resync_fo = BM_SECT_TO_BIT(sector);
+			/* remember to report stats in drbd_resync_finished */
+			device->use_csums = true;
 		} else if (pi->cmd == P_OV_REPLY) {
 			/* track progress, we may need to throttle */
 			atomic_add(size >> 9, &device->rs_sect_in);
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 2ff5fd4..6532a69 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -698,8 +698,8 @@ next_sector:
 		/* adjust very last sectors, in case we are oddly sized */
 		if (sector + (size>>9) > capacity)
 			size = (capacity-sector)<<9;
-		if (connection->agreed_pro_version >= 89 &&
-		    connection->csums_tfm) {
+
+		if (device->use_csums) {
 			switch (read_for_csum(peer_device, sector, size)) {
 			case -EIO: /* Disk failure */
 				put_ldev(device);
@@ -913,7 +913,7 @@ int drbd_resync_finished(struct drbd_device *device)
 		if (os.conn == C_SYNC_TARGET || os.conn == C_PAUSED_SYNC_T)
 			khelper_cmd = "after-resync-target";
 
-		if (first_peer_device(device)->connection->csums_tfm && device->rs_total) {
+		if (device->use_csums && device->rs_total) {
 			const unsigned long s = device->rs_same_csum;
 			const unsigned long t = device->rs_total;
 			const int ratio =
@@ -1622,6 +1622,18 @@ static void do_start_resync(struct drbd_device *device)
 	clear_bit(AHEAD_TO_SYNC_SOURCE, &device->flags);
 }
 
+static bool use_checksum_based_resync(struct drbd_connection *connection, struct drbd_device *device)
+{
+	bool csums_after_crash_only;
+	rcu_read_lock();
+	csums_after_crash_only = rcu_dereference(connection->net_conf)->csums_after_crash_only;
+	rcu_read_unlock();
+	return connection->agreed_pro_version >= 89 &&		/* supported? */
+		connection->csums_tfm &&			/* configured? */
+		(csums_after_crash_only == 0			/* use for each resync? */
+		 || test_bit(CRASHED_PRIMARY, &device->flags));	/* or only after Primary crash? */
+}
+
 /**
  * drbd_start_resync() - Start the resync process
  * @device:	DRBD device.
@@ -1756,8 +1768,12 @@ void drbd_start_resync(struct drbd_device *device, enum drbd_conns side)
 		     drbd_conn_str(ns.conn),
 		     (unsigned long) device->rs_total << (BM_BLOCK_SHIFT-10),
 		     (unsigned long) device->rs_total);
-		if (side == C_SYNC_TARGET)
+		if (side == C_SYNC_TARGET) {
 			device->bm_resync_fo = 0;
+			device->use_csums = use_checksum_based_resync(connection, device);
+		} else {
+			device->use_csums = 0;
+		}
 
 		/* Since protocol 96, we must serialize drbd_gen_and_send_sync_uuid
 		 * with w_send_oos, or the sync target will get confused as to
diff --git a/include/linux/drbd_genl.h b/include/linux/drbd_genl.h
index 4193f5f..71fc924 100644
--- a/include/linux/drbd_genl.h
+++ b/include/linux/drbd_genl.h
@@ -171,6 +171,9 @@ GENL_struct(DRBD_NLA_NET_CONF, 5, net_conf,
 	__flg_field(28, DRBD_GENLA_F_MANDATORY | DRBD_F_INVARIANT,	tentative)
 	__flg_field_def(29,	DRBD_GENLA_F_MANDATORY,	use_rle, DRBD_USE_RLE_DEF)
 	/* 9: __u32_field_def(30,	DRBD_GENLA_F_MANDATORY,	fencing_policy, DRBD_FENCING_DEF) */
+	/* 9: __str_field_def(31,     DRBD_GENLA_F_MANDATORY, name, SHARED_SECRET_MAX) */
+	/* 9: __u32_field(32,         DRBD_F_REQUIRED | DRBD_F_INVARIANT,     peer_node_id) */
+	__flg_field_def(33, 0 /* OPTIONAL */,	csums_after_crash_only, DRBD_CSUMS_AFTER_CRASH_ONLY_DEF)
 )
 
 GENL_struct(DRBD_NLA_SET_ROLE_PARMS, 6, set_role_parms,
diff --git a/include/linux/drbd_limits.h b/include/linux/drbd_limits.h
index 17e50bb..9d2df1d 100644
--- a/include/linux/drbd_limits.h
+++ b/include/linux/drbd_limits.h
@@ -214,6 +214,7 @@
 #define DRBD_ALLOW_TWO_PRIMARIES_DEF	0
 #define DRBD_ALWAYS_ASBP_DEF	0
 #define DRBD_USE_RLE_DEF	1
+#define DRBD_CSUMS_AFTER_CRASH_ONLY_DEF 0
 
 #define DRBD_AL_STRIPES_MIN     1
 #define DRBD_AL_STRIPES_MAX     1024
-- 
1.9.1

