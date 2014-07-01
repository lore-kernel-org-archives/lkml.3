Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218AbaGAQW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 12:22:27 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:53064 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756563AbaGAQQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 12:16:53 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 04/20] drbd: fix bogus resync stats in /proc/drbd
Date: Tue,  1 Jul 2014 18:16:34 +0200
Message-Id: <1404231410-29852-5-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404231410-29852-1-git-send-email-philipp.reisner@linbit.com>
References: <1404231410-29852-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

We intentionally do not serialize /proc/drbd access with
internal state changes or statistic updates.

Because of that, cat /proc/drbd  may race with resync just being
finished, still see the sync state, and find information about
number of blocks still to go, but then find the total number
of blocks within this resync has just been reset to 0
when accessing it.

This now produces bogus numbers in the resync speed estimates.

Fix by accessing all relevant data only once,
and fixing it up if "still to go" happens to be more than "total".

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h  |  48 -------------------
 drivers/block/drbd/drbd_proc.c | 103 ++++++++++++++++++++++++++++++-----------
 2 files changed, 75 insertions(+), 76 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index e306a22..abf5aef 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1982,54 +1982,6 @@ static inline int _get_ldev_if_state(struct drbd_device *device, enum drbd_disk_
 extern int _get_ldev_if_state(struct drbd_device *device, enum drbd_disk_state mins);
 #endif
 
-/* you must have an "get_ldev" reference */
-static inline void drbd_get_syncer_progress(struct drbd_device *device,
-		unsigned long *bits_left, unsigned int *per_mil_done)
-{
-	/* this is to break it at compile time when we change that, in case we
-	 * want to support more than (1<<32) bits on a 32bit arch. */
-	typecheck(unsigned long, device->rs_total);
-
-	/* note: both rs_total and rs_left are in bits, i.e. in
-	 * units of BM_BLOCK_SIZE.
-	 * for the percentage, we don't care. */
-
-	if (device->state.conn == C_VERIFY_S || device->state.conn == C_VERIFY_T)
-		*bits_left = device->ov_left;
-	else
-		*bits_left = drbd_bm_total_weight(device) - device->rs_failed;
-	/* >> 10 to prevent overflow,
-	 * +1 to prevent division by zero */
-	if (*bits_left > device->rs_total) {
-		/* doh. maybe a logic bug somewhere.
-		 * may also be just a race condition
-		 * between this and a disconnect during sync.
-		 * for now, just prevent in-kernel buffer overflow.
-		 */
-		smp_rmb();
-		drbd_warn(device, "cs:%s rs_left=%lu > rs_total=%lu (rs_failed %lu)\n",
-				drbd_conn_str(device->state.conn),
-				*bits_left, device->rs_total, device->rs_failed);
-		*per_mil_done = 0;
-	} else {
-		/* Make sure the division happens in long context.
-		 * We allow up to one petabyte storage right now,
-		 * at a granularity of 4k per bit that is 2**38 bits.
-		 * After shift right and multiplication by 1000,
-		 * this should still fit easily into a 32bit long,
-		 * so we don't need a 64bit division on 32bit arch.
-		 * Note: currently we don't support such large bitmaps on 32bit
-		 * arch anyways, but no harm done to be prepared for it here.
-		 */
-		unsigned int shift = device->rs_total > UINT_MAX ? 16 : 10;
-		unsigned long left = *bits_left >> shift;
-		unsigned long total = 1UL + (device->rs_total >> shift);
-		unsigned long tmp = 1000UL - left * 1000UL/total;
-		*per_mil_done = tmp;
-	}
-}
-
-
 /* this throttles on-the-fly application requests
  * according to max_buffers settings;
  * maybe re-implement using semaphores? */
diff --git a/drivers/block/drbd/drbd_proc.c b/drivers/block/drbd/drbd_proc.c
index 886f6be..9059d7b 100644
--- a/drivers/block/drbd/drbd_proc.c
+++ b/drivers/block/drbd/drbd_proc.c
@@ -60,20 +60,65 @@ static void seq_printf_with_thousands_grouping(struct seq_file *seq, long v)
 		seq_printf(seq, "%ld", v);
 }
 
+static void drbd_get_syncer_progress(struct drbd_device *device,
+		union drbd_dev_state state, unsigned long *rs_total,
+		unsigned long *bits_left, unsigned int *per_mil_done)
+{
+	/* this is to break it at compile time when we change that, in case we
+	 * want to support more than (1<<32) bits on a 32bit arch. */
+	typecheck(unsigned long, device->rs_total);
+	*rs_total = device->rs_total;
+
+	/* note: both rs_total and rs_left are in bits, i.e. in
+	 * units of BM_BLOCK_SIZE.
+	 * for the percentage, we don't care. */
+
+	if (state.conn == C_VERIFY_S || state.conn == C_VERIFY_T)
+		*bits_left = device->ov_left;
+	else
+		*bits_left = drbd_bm_total_weight(device) - device->rs_failed;
+	/* >> 10 to prevent overflow,
+	 * +1 to prevent division by zero */
+	if (*bits_left > *rs_total) {
+		/* D'oh. Maybe a logic bug somewhere.  More likely just a race
+		 * between state change and reset of rs_total.
+		 */
+		*bits_left = *rs_total;
+		*per_mil_done = *rs_total ? 0 : 1000;
+	} else {
+		/* Make sure the division happens in long context.
+		 * We allow up to one petabyte storage right now,
+		 * at a granularity of 4k per bit that is 2**38 bits.
+		 * After shift right and multiplication by 1000,
+		 * this should still fit easily into a 32bit long,
+		 * so we don't need a 64bit division on 32bit arch.
+		 * Note: currently we don't support such large bitmaps on 32bit
+		 * arch anyways, but no harm done to be prepared for it here.
+		 */
+		unsigned int shift = *rs_total > UINT_MAX ? 16 : 10;
+		unsigned long left = *bits_left >> shift;
+		unsigned long total = 1UL + (*rs_total >> shift);
+		unsigned long tmp = 1000UL - left * 1000UL/total;
+		*per_mil_done = tmp;
+	}
+}
+
+
 /*lge
  * progress bars shamelessly adapted from driver/md/md.c
  * output looks like
  *	[=====>..............] 33.5% (23456/123456)
  *	finish: 2:20:20 speed: 6,345 (6,456) K/sec
  */
-static void drbd_syncer_progress(struct drbd_device *device, struct seq_file *seq)
+static void drbd_syncer_progress(struct drbd_device *device, struct seq_file *seq,
+		union drbd_dev_state state)
 {
-	unsigned long db, dt, dbdt, rt, rs_left;
+	unsigned long db, dt, dbdt, rt, rs_total, rs_left;
 	unsigned int res;
 	int i, x, y;
 	int stalled = 0;
 
-	drbd_get_syncer_progress(device, &rs_left, &res);
+	drbd_get_syncer_progress(device, state, &rs_total, &rs_left, &res);
 
 	x = res/50;
 	y = 20-x;
@@ -85,21 +130,21 @@ static void drbd_syncer_progress(struct drbd_device *device, struct seq_file *se
 		seq_printf(seq, ".");
 	seq_printf(seq, "] ");
 
-	if (device->state.conn == C_VERIFY_S || device->state.conn == C_VERIFY_T)
+	if (state.conn == C_VERIFY_S || state.conn == C_VERIFY_T)
 		seq_printf(seq, "verified:");
 	else
 		seq_printf(seq, "sync'ed:");
 	seq_printf(seq, "%3u.%u%% ", res / 10, res % 10);
 
 	/* if more than a few GB, display in MB */
-	if (device->rs_total > (4UL << (30 - BM_BLOCK_SHIFT)))
+	if (rs_total > (4UL << (30 - BM_BLOCK_SHIFT)))
 		seq_printf(seq, "(%lu/%lu)M",
 			    (unsigned long) Bit2KB(rs_left >> 10),
-			    (unsigned long) Bit2KB(device->rs_total >> 10));
+			    (unsigned long) Bit2KB(rs_total >> 10));
 	else
 		seq_printf(seq, "(%lu/%lu)K\n\t",
 			    (unsigned long) Bit2KB(rs_left),
-			    (unsigned long) Bit2KB(device->rs_total));
+			    (unsigned long) Bit2KB(rs_total));
 
 	/* see drivers/md/md.c
 	 * We do not want to overflow, so the order of operands and
@@ -150,13 +195,13 @@ static void drbd_syncer_progress(struct drbd_device *device, struct seq_file *se
 	dt = (jiffies - device->rs_start - device->rs_paused) / HZ;
 	if (dt == 0)
 		dt = 1;
-	db = device->rs_total - rs_left;
+	db = rs_total - rs_left;
 	dbdt = Bit2KB(db/dt);
 	seq_printf_with_thousands_grouping(seq, dbdt);
 	seq_printf(seq, ")");
 
-	if (device->state.conn == C_SYNC_TARGET ||
-	    device->state.conn == C_VERIFY_S) {
+	if (state.conn == C_SYNC_TARGET ||
+	    state.conn == C_VERIFY_S) {
 		seq_printf(seq, " want: ");
 		seq_printf_with_thousands_grouping(seq, device->c_sync_rate);
 	}
@@ -168,8 +213,8 @@ static void drbd_syncer_progress(struct drbd_device *device, struct seq_file *se
 		unsigned long bm_bits = drbd_bm_bits(device);
 		unsigned long bit_pos;
 		unsigned long long stop_sector = 0;
-		if (device->state.conn == C_VERIFY_S ||
-		    device->state.conn == C_VERIFY_T) {
+		if (state.conn == C_VERIFY_S ||
+		    state.conn == C_VERIFY_T) {
 			bit_pos = bm_bits - device->ov_left;
 			if (verify_can_do_stop_sector(device))
 				stop_sector = device->ov_stop_sector;
@@ -194,6 +239,7 @@ static int drbd_seq_show(struct seq_file *seq, void *v)
 	const char *sn;
 	struct drbd_device *device;
 	struct net_conf *nc;
+	union drbd_dev_state state;
 	char wp;
 
 	static char write_ordering_chars[] = {
@@ -231,11 +277,12 @@ static int drbd_seq_show(struct seq_file *seq, void *v)
 			seq_printf(seq, "\n");
 		prev_i = i;
 
-		sn = drbd_conn_str(device->state.conn);
+		state = device->state;
+		sn = drbd_conn_str(state.conn);
 
-		if (device->state.conn == C_STANDALONE &&
-		    device->state.disk == D_DISKLESS &&
-		    device->state.role == R_SECONDARY) {
+		if (state.conn == C_STANDALONE &&
+		    state.disk == D_DISKLESS &&
+		    state.role == R_SECONDARY) {
 			seq_printf(seq, "%2d: cs:Unconfigured\n", i);
 		} else {
 			/* reset device->congestion_reason */
@@ -248,15 +295,15 @@ static int drbd_seq_show(struct seq_file *seq, void *v)
 			   "    ns:%u nr:%u dw:%u dr:%u al:%u bm:%u "
 			   "lo:%d pe:%d ua:%d ap:%d ep:%d wo:%c",
 			   i, sn,
-			   drbd_role_str(device->state.role),
-			   drbd_role_str(device->state.peer),
-			   drbd_disk_str(device->state.disk),
-			   drbd_disk_str(device->state.pdsk),
+			   drbd_role_str(state.role),
+			   drbd_role_str(state.peer),
+			   drbd_disk_str(state.disk),
+			   drbd_disk_str(state.pdsk),
 			   wp,
 			   drbd_suspended(device) ? 's' : 'r',
-			   device->state.aftr_isp ? 'a' : '-',
-			   device->state.peer_isp ? 'p' : '-',
-			   device->state.user_isp ? 'u' : '-',
+			   state.aftr_isp ? 'a' : '-',
+			   state.peer_isp ? 'p' : '-',
+			   state.user_isp ? 'u' : '-',
 			   device->congestion_reason ?: '-',
 			   test_bit(AL_SUSPENDED, &device->flags) ? 's' : '-',
 			   device->send_cnt/2,
@@ -277,11 +324,11 @@ static int drbd_seq_show(struct seq_file *seq, void *v)
 				   Bit2KB((unsigned long long)
 					   drbd_bm_total_weight(device)));
 		}
-		if (device->state.conn == C_SYNC_SOURCE ||
-		    device->state.conn == C_SYNC_TARGET ||
-		    device->state.conn == C_VERIFY_S ||
-		    device->state.conn == C_VERIFY_T)
-			drbd_syncer_progress(device, seq);
+		if (state.conn == C_SYNC_SOURCE ||
+		    state.conn == C_SYNC_TARGET ||
+		    state.conn == C_VERIFY_S ||
+		    state.conn == C_VERIFY_T)
+			drbd_syncer_progress(device, seq, state);
 
 		if (proc_details >= 1 && get_ldev_if_state(device, D_FAILED)) {
 			lc_seq_printf_stats(seq, device->resync);
-- 
1.9.1

