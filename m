Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933552Ab3CSRSa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 13:18:30 -0400
Received: from mail09.linbit.com ([212.69.161.110]:44616 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933347Ab3CSRRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 13:17:06 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, drbd-dev@lists.linbit.com,
        lars.ellenberg@linbit.com
Subject: [PATCH 15/18] drbd: consolidate as many updates as possible into one AL transaction
Date: Tue, 19 Mar 2013 18:16:56 +0100
Message-Id: <1363713419-17803-16-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363713419-17803-1-git-send-email-philipp.reisner@linbit.com>
References: <1363713419-17803-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

Depending on current IO depth, try to consolidate as many updates
as possible into one activity log transaction.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_actlog.c |   49 ++++++++++++++++++++++++++
 drivers/block/drbd/drbd_int.h    |    2 ++
 drivers/block/drbd/drbd_req.c    |   70 ++++++++++++++++++++++++++++++--------
 3 files changed, 107 insertions(+), 14 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index ff03f90..6afe173 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -359,6 +359,55 @@ void drbd_al_begin_io(struct drbd_conf *mdev, struct drbd_interval *i, bool dele
 		drbd_al_begin_io_commit(mdev, delegate);
 }
 
+int drbd_al_begin_io_nonblock(struct drbd_conf *mdev, struct drbd_interval *i)
+{
+	struct lru_cache *al = mdev->act_log;
+	/* for bios crossing activity log extent boundaries,
+	 * we may need to activate two extents in one go */
+	unsigned first = i->sector >> (AL_EXTENT_SHIFT-9);
+	unsigned last = i->size == 0 ? first : (i->sector + (i->size >> 9) - 1) >> (AL_EXTENT_SHIFT-9);
+	unsigned nr_al_extents;
+	unsigned available_update_slots;
+	unsigned enr;
+
+	D_ASSERT(first <= last);
+
+	nr_al_extents = 1 + last - first; /* worst case: all touched extends are cold. */
+	available_update_slots = min(al->nr_elements - al->used,
+				al->max_pending_changes - al->pending_changes);
+
+	/* We want all necessary updates for a given request within the same transaction
+	 * We could first check how many updates are *actually* needed,
+	 * and use that instead of the worst-case nr_al_extents */
+	if (available_update_slots < nr_al_extents)
+		return -EWOULDBLOCK;
+
+	/* Is resync active in this area? */
+	for (enr = first; enr <= last; enr++) {
+		struct lc_element *tmp;
+		tmp = lc_find(mdev->resync, enr/AL_EXT_PER_BM_SECT);
+		if (unlikely(tmp != NULL)) {
+			struct bm_extent  *bm_ext = lc_entry(tmp, struct bm_extent, lce);
+			if (test_bit(BME_NO_WRITES, &bm_ext->flags)) {
+				if (!test_and_set_bit(BME_PRIORITY, &bm_ext->flags));
+					return -EBUSY;
+				return -EWOULDBLOCK;
+			}
+		}
+	}
+
+	/* Checkout the refcounts.
+	 * Given that we checked for available elements and update slots above,
+	 * this has to be successful. */
+	for (enr = first; enr <= last; enr++) {
+		struct lc_element *al_ext;
+		al_ext = lc_get_cumulative(mdev->act_log, enr);
+		if (!al_ext)
+			dev_info(DEV, "LOGIC BUG for enr=%u\n", enr);
+	}
+	return 0;
+}
+
 void drbd_al_complete_io(struct drbd_conf *mdev, struct drbd_interval *i)
 {
 	/* for bios crossing activity log extent boundaries,
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index b7b52dd..f943aac 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1611,6 +1611,8 @@ extern const char *drbd_conn_str(enum drbd_conns s);
 extern const char *drbd_role_str(enum drbd_role s);
 
 /* drbd_actlog.c */
+extern int drbd_al_begin_io_nonblock(struct drbd_conf *mdev, struct drbd_interval *i);
+extern void drbd_al_begin_io_commit(struct drbd_conf *mdev, bool delegate);
 extern bool drbd_al_begin_io_fastpath(struct drbd_conf *mdev, struct drbd_interval *i);
 extern void drbd_al_begin_io(struct drbd_conf *mdev, struct drbd_interval *i, bool delegate);
 extern void drbd_al_complete_io(struct drbd_conf *mdev, struct drbd_interval *i);
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 43bc1d0..b923d41 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -1164,32 +1164,74 @@ void __drbd_make_request(struct drbd_conf *mdev, struct bio *bio, unsigned long
 	drbd_send_and_submit(mdev, req);
 }
 
-void __drbd_make_request_from_worker(struct drbd_conf *mdev, struct drbd_request *req)
+static void submit_fast_path(struct drbd_conf *mdev, struct list_head *incoming)
 {
-	const int rw = bio_rw(req->master_bio);
+	struct drbd_request *req, *tmp;
+	list_for_each_entry_safe(req, tmp, incoming, tl_requests) {
+		const int rw = bio_data_dir(req->master_bio);
 
-	if (rw == WRITE && req->private_bio && req->i.size
-	&& !test_bit(AL_SUSPENDED, &mdev->flags)) {
-		drbd_al_begin_io(mdev, &req->i, false);
-		req->rq_state |= RQ_IN_ACT_LOG;
+		if (rw == WRITE /* rw != WRITE should not even end up here! */
+		&& req->private_bio && req->i.size
+		&& !test_bit(AL_SUSPENDED, &mdev->flags)) {
+			if (!drbd_al_begin_io_fastpath(mdev, &req->i))
+				continue;
+
+			req->rq_state |= RQ_IN_ACT_LOG;
+		}
+
+		list_del_init(&req->tl_requests);
+		drbd_send_and_submit(mdev, req);
 	}
-	drbd_send_and_submit(mdev, req);
 }
 
+static bool prepare_al_transaction_nonblock(struct drbd_conf *mdev,
+					    struct list_head *incoming,
+					    struct list_head *pending)
+{
+	struct drbd_request *req, *tmp;
+	int wake = 0;
+	int err;
+
+	spin_lock_irq(&mdev->al_lock);
+	list_for_each_entry_safe(req, tmp, incoming, tl_requests) {
+		err = drbd_al_begin_io_nonblock(mdev, &req->i);
+		if (err == -EBUSY)
+			wake = 1;
+		if (err)
+			continue;
+		req->rq_state |= RQ_IN_ACT_LOG;
+		list_move_tail(&req->tl_requests, pending);
+	}
+	spin_unlock_irq(&mdev->al_lock);
+	if (wake)
+		wake_up(&mdev->al_wait);
+
+	return !list_empty(pending);
+}
 
 void do_submit(struct work_struct *ws)
 {
 	struct drbd_conf *mdev = container_of(ws, struct drbd_conf, submit.worker);
-	LIST_HEAD(writes);
+	LIST_HEAD(incoming);
+	LIST_HEAD(pending);
 	struct drbd_request *req, *tmp;
 
-	spin_lock(&mdev->submit.lock);
-	list_splice_init(&mdev->submit.writes, &writes);
-	spin_unlock(&mdev->submit.lock);
+	for (;;) {
+		spin_lock(&mdev->submit.lock);
+		list_splice_tail_init(&mdev->submit.writes, &incoming);
+		spin_unlock(&mdev->submit.lock);
 
-	list_for_each_entry_safe(req, tmp, &writes, tl_requests) {
-		list_del_init(&req->tl_requests);
-		__drbd_make_request_from_worker(mdev, req);
+		submit_fast_path(mdev, &incoming);
+		if (list_empty(&incoming))
+			break;
+
+		wait_event(mdev->al_wait, prepare_al_transaction_nonblock(mdev, &incoming, &pending));
+		drbd_al_begin_io_commit(mdev, false);
+
+		list_for_each_entry_safe(req, tmp, &pending, tl_requests) {
+			list_del_init(&req->tl_requests);
+			drbd_send_and_submit(mdev, req);
+		}
 	}
 }
 
-- 
1.7.9.5

