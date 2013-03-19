Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933423Ab3CSRUB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 13:20:01 -0400
Received: from mail09.linbit.com ([212.69.161.110]:44658 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933316Ab3CSRRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 13:17:05 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, drbd-dev@lists.linbit.com,
        lars.ellenberg@linbit.com
Subject: [PATCH 10/18] drbd: prepare to queue write requests on a submit worker
Date: Tue, 19 Mar 2013 18:16:51 +0100
Message-Id: <1363713419-17803-11-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363713419-17803-1-git-send-email-philipp.reisner@linbit.com>
References: <1363713419-17803-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h  |   13 +++++++++++++
 drivers/block/drbd/drbd_main.c |   25 ++++++++++++++++++++++++-
 drivers/block/drbd/drbd_nl.c   |    1 +
 drivers/block/drbd/drbd_req.c  |   29 +++++++++++++++++++++++++++++
 4 files changed, 67 insertions(+), 1 deletion(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 453fccf..a6b71b6 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -894,6 +894,14 @@ struct drbd_tconn {			/* is a resource from the config file */
 	} send;
 };
 
+struct submit_worker {
+	struct workqueue_struct *wq;
+	struct work_struct worker;
+
+	spinlock_t lock;
+	struct list_head writes;
+};
+
 struct drbd_conf {
 	struct drbd_tconn *tconn;
 	int vnr;			/* volume number within the connection */
@@ -1034,6 +1042,10 @@ struct drbd_conf {
 	atomic_t ap_in_flight; /* App sectors in flight (waiting for ack) */
 	unsigned int peer_max_bio_size;
 	unsigned int local_max_bio_size;
+
+	/* any requests that would block in drbd_make_request()
+	 * are deferred to this single-threaded work queue */
+	struct submit_worker submit;
 };
 
 static inline struct drbd_conf *minor_to_mdev(unsigned int minor)
@@ -1440,6 +1452,7 @@ extern void conn_free_crypto(struct drbd_tconn *tconn);
 extern int proc_details;
 
 /* drbd_req */
+extern void do_submit(struct work_struct *ws);
 extern void __drbd_make_request(struct drbd_conf *, struct bio *, unsigned long);
 extern void drbd_make_request(struct request_queue *q, struct bio *bio);
 extern int drbd_read_remote(struct drbd_conf *mdev, struct drbd_request *req);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 3d212b9..c84226e 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -45,7 +45,7 @@
 #include <linux/reboot.h>
 #include <linux/notifier.h>
 #include <linux/kthread.h>
-
+#include <linux/workqueue.h>
 #define __KERNEL_SYSCALLS__
 #include <linux/unistd.h>
 #include <linux/vmalloc.h>
@@ -2300,6 +2300,7 @@ static void drbd_cleanup(void)
 	idr_for_each_entry(&minors, mdev, i) {
 		idr_remove(&minors, mdev_to_minor(mdev));
 		idr_remove(&mdev->tconn->volumes, mdev->vnr);
+		destroy_workqueue(mdev->submit.wq);
 		del_gendisk(mdev->vdisk);
 		/* synchronize_rcu(); No other threads running at this point */
 		kref_put(&mdev->kref, &drbd_minor_destroy);
@@ -2589,6 +2590,21 @@ void conn_destroy(struct kref *kref)
 	kfree(tconn);
 }
 
+int init_submitter(struct drbd_conf *mdev)
+{
+	/* opencoded create_singlethread_workqueue(),
+	 * to be able to say "drbd%d", ..., minor */
+	mdev->submit.wq = alloc_workqueue("drbd%u_submit",
+			WQ_UNBOUND | WQ_MEM_RECLAIM, 1, mdev->minor);
+	if (!mdev->submit.wq)
+		return -ENOMEM;
+
+	INIT_WORK(&mdev->submit.worker, do_submit);
+	spin_lock_init(&mdev->submit.lock);
+	INIT_LIST_HEAD(&mdev->submit.writes);
+	return 0;
+}
+
 enum drbd_ret_code conn_new_minor(struct drbd_tconn *tconn, unsigned int minor, int vnr)
 {
 	struct drbd_conf *mdev;
@@ -2679,6 +2695,13 @@ enum drbd_ret_code conn_new_minor(struct drbd_tconn *tconn, unsigned int minor,
 		drbd_msg_put_info("requested volume exists already");
 		goto out_idr_remove_vol;
 	}
+
+	if (init_submitter(mdev)) {
+		err = ERR_NOMEM;
+		drbd_msg_put_info("unable to create submit workqueue");
+		goto out_idr_remove_vol;
+	}
+
 	add_disk(disk);
 	kref_init(&mdev->kref); /* one ref for both idrs and the the add_disk */
 
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 974ea47..bcf900b 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -3173,6 +3173,7 @@ static enum drbd_ret_code adm_delete_minor(struct drbd_conf *mdev)
 				    CS_VERBOSE + CS_WAIT_COMPLETE);
 		idr_remove(&mdev->tconn->volumes, mdev->vnr);
 		idr_remove(&minors, mdev_to_minor(mdev));
+		destroy_workqueue(mdev->submit.wq);
 		del_gendisk(mdev->vdisk);
 		synchronize_rcu();
 		kref_put(&mdev->kref, &drbd_minor_destroy);
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 96d5968..4af709e 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -1160,6 +1160,35 @@ void __drbd_make_request(struct drbd_conf *mdev, struct bio *bio, unsigned long
 	drbd_send_and_submit(mdev, req);
 }
 
+void __drbd_make_request_from_worker(struct drbd_conf *mdev, struct drbd_request *req)
+{
+	const int rw = bio_rw(req->master_bio);
+
+	if (rw == WRITE && req->private_bio && req->i.size
+	&& !test_bit(AL_SUSPENDED, &mdev->flags)) {
+		drbd_al_begin_io(mdev, &req->i, false);
+		req->rq_state |= RQ_IN_ACT_LOG;
+	}
+	drbd_send_and_submit(mdev, req);
+}
+
+
+void do_submit(struct work_struct *ws)
+{
+	struct drbd_conf *mdev = container_of(ws, struct drbd_conf, submit.worker);
+	LIST_HEAD(writes);
+	struct drbd_request *req, *tmp;
+
+	spin_lock(&mdev->submit.lock);
+	list_splice_init(&mdev->submit.writes, &writes);
+	spin_unlock(&mdev->submit.lock);
+
+	list_for_each_entry_safe(req, tmp, &writes, tl_requests) {
+		list_del_init(&req->tl_requests);
+		__drbd_make_request_from_worker(mdev, req);
+	}
+}
+
 void drbd_make_request(struct request_queue *q, struct bio *bio)
 {
 	struct drbd_conf *mdev = (struct drbd_conf *) q->queuedata;
-- 
1.7.9.5

