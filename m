Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933312Ab3CSRT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 13:19:59 -0400
Received: from mail09.linbit.com ([212.69.161.110]:44656 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933322Ab3CSRRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 13:17:05 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, drbd-dev@lists.linbit.com,
        lars.ellenberg@linbit.com
Subject: [PATCH 09/18] drbd: split __drbd_make_request in before and after drbd_al_begin_io
Date: Tue, 19 Mar 2013 18:16:50 +0100
Message-Id: <1363713419-17803-10-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363713419-17803-1-git-send-email-philipp.reisner@linbit.com>
References: <1363713419-17803-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

This is in preparation to be able to defer requests that need to wait
for an activity log transaction to a submitter workqueue.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_req.c |   40 ++++++++++++++++++++++++++++++----------
 1 file changed, 30 insertions(+), 10 deletions(-)

diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 7d1ff1a..96d5968 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -34,14 +34,14 @@
 static bool drbd_may_do_local_read(struct drbd_conf *mdev, sector_t sector, int size);
 
 /* Update disk stats at start of I/O request */
-static void _drbd_start_io_acct(struct drbd_conf *mdev, struct drbd_request *req, struct bio *bio)
+static void _drbd_start_io_acct(struct drbd_conf *mdev, struct drbd_request *req)
 {
-	const int rw = bio_data_dir(bio);
+	const int rw = bio_data_dir(req->master_bio);
 	int cpu;
 	cpu = part_stat_lock();
 	part_round_stats(cpu, &mdev->vdisk->part0);
 	part_stat_inc(cpu, &mdev->vdisk->part0, ios[rw]);
-	part_stat_add(cpu, &mdev->vdisk->part0, sectors[rw], bio_sectors(bio));
+	part_stat_add(cpu, &mdev->vdisk->part0, sectors[rw], req->i.size >> 9);
 	(void) cpu; /* The macro invocations above want the cpu argument, I do not like
 		       the compiler warning about cpu only assigned but never used... */
 	part_inc_in_flight(&mdev->vdisk->part0, rw);
@@ -1020,12 +1020,16 @@ drbd_submit_req_private_bio(struct drbd_request *req)
 		bio_endio(bio, -EIO);
 }
 
-void __drbd_make_request(struct drbd_conf *mdev, struct bio *bio, unsigned long start_time)
+/* returns the new drbd_request pointer, if the caller is expected to
+ * drbd_send_and_submit() it (to save latency), or NULL if we queued the
+ * request on the submitter thread.
+ * Returns ERR_PTR(-ENOMEM) if we cannot allocate a drbd_request.
+ */
+struct drbd_request *
+drbd_request_prepare(struct drbd_conf *mdev, struct bio *bio, unsigned long start_time)
 {
-	const int rw = bio_rw(bio);
-	struct bio_and_error m = { NULL, };
+	const int rw = bio_data_dir(bio);
 	struct drbd_request *req;
-	bool no_remote = false;
 
 	/* allocate outside of all locks; */
 	req = drbd_req_new(mdev, bio);
@@ -1035,7 +1039,7 @@ void __drbd_make_request(struct drbd_conf *mdev, struct bio *bio, unsigned long
 		 * if user cannot handle io errors, that's not our business. */
 		dev_err(DEV, "could not kmalloc() req\n");
 		bio_endio(bio, -ENOMEM);
-		return;
+		return ERR_PTR(-ENOMEM);
 	}
 	req->start_time = start_time;
 
@@ -1057,6 +1061,15 @@ void __drbd_make_request(struct drbd_conf *mdev, struct bio *bio, unsigned long
 		drbd_al_begin_io(mdev, &req->i, true);
 	}
 
+	return req;
+}
+
+static void drbd_send_and_submit(struct drbd_conf *mdev, struct drbd_request *req)
+{
+	const int rw = bio_rw(req->master_bio);
+	struct bio_and_error m = { NULL, };
+	bool no_remote = false;
+
 	spin_lock_irq(&mdev->tconn->req_lock);
 	if (rw == WRITE) {
 		/* This may temporarily give up the req_lock,
@@ -1079,7 +1092,7 @@ void __drbd_make_request(struct drbd_conf *mdev, struct bio *bio, unsigned long
 	}
 
 	/* Update disk stats */
-	_drbd_start_io_acct(mdev, req, bio);
+	_drbd_start_io_acct(mdev, req);
 
 	/* We fail READ/READA early, if we can not serve it.
 	 * We must do this before req is registered on any lists.
@@ -1137,7 +1150,14 @@ out:
 
 	if (m.bio)
 		complete_master_bio(mdev, &m);
-	return;
+}
+
+void __drbd_make_request(struct drbd_conf *mdev, struct bio *bio, unsigned long start_time)
+{
+	struct drbd_request *req = drbd_request_prepare(mdev, bio, start_time);
+	if (IS_ERR_OR_NULL(req))
+		return;
+	drbd_send_and_submit(mdev, req);
 }
 
 void drbd_make_request(struct request_queue *q, struct bio *bio)
-- 
1.7.9.5

