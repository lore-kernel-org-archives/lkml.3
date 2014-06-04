Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbaFDXW7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:22:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40371 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479AbaFDXW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3.14 189/228] dm thin: add timeout to stop out-of-data-space mode holding IO forever
Date: Wed,  4 Jun 2014 16:23:38 -0700
Message-Id: <20140604232354.096959601@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Thornber <ejt@redhat.com>

commit 85ad643b7e7e52d37620fb272a9fd577a8095647 upstream.

If the pool runs out of data space, dm-thin can be configured to
either error IOs that would trigger provisioning, or hold those IOs
until the pool is resized.  Unfortunately, holding IOs until the pool is
resized can result in a cascade of tasks hitting the hung_task_timeout,
which may render the system unavailable.

Add a fixed timeout so IOs can only be held for a maximum of 60 seconds.
If LVM is going to resize a thin-pool that is out of data space it needs
to be prompt about it.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-thin.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -25,6 +25,7 @@
 #define MAPPING_POOL_SIZE 1024
 #define PRISON_CELLS 1024
 #define COMMIT_PERIOD HZ
+#define NO_SPACE_TIMEOUT (HZ * 60)
 
 DECLARE_DM_KCOPYD_THROTTLE_WITH_MODULE_PARM(snapshot_copy_throttle,
 		"A percentage of time allocated for copy on write");
@@ -173,6 +174,7 @@ struct pool {
 	struct workqueue_struct *wq;
 	struct work_struct worker;
 	struct delayed_work waker;
+	struct delayed_work no_space_timeout;
 
 	unsigned long last_commit_jiffies;
 	unsigned ref_count;
@@ -1449,6 +1451,20 @@ static void do_waker(struct work_struct
 	queue_delayed_work(pool->wq, &pool->waker, COMMIT_PERIOD);
 }
 
+/*
+ * We're holding onto IO to allow userland time to react.  After the
+ * timeout either the pool will have been resized (and thus back in
+ * PM_WRITE mode), or we degrade to PM_READ_ONLY and start erroring IO.
+ */
+static void do_no_space_timeout(struct work_struct *ws)
+{
+	struct pool *pool = container_of(to_delayed_work(ws), struct pool,
+					 no_space_timeout);
+
+	if (get_pool_mode(pool) == PM_OUT_OF_DATA_SPACE && !pool->pf.error_if_no_space)
+		set_pool_mode(pool, PM_READ_ONLY);
+}
+
 /*----------------------------------------------------------------*/
 
 struct noflush_work {
@@ -1574,6 +1590,9 @@ static void set_pool_mode(struct pool *p
 		pool->process_discard = process_discard;
 		pool->process_prepared_mapping = process_prepared_mapping;
 		pool->process_prepared_discard = process_prepared_discard_passdown;
+
+		if (!pool->pf.error_if_no_space)
+			queue_delayed_work(pool->wq, &pool->no_space_timeout, NO_SPACE_TIMEOUT);
 		break;
 
 	case PM_WRITE:
@@ -1956,6 +1975,7 @@ static struct pool *pool_create(struct m
 
 	INIT_WORK(&pool->worker, do_worker);
 	INIT_DELAYED_WORK(&pool->waker, do_waker);
+	INIT_DELAYED_WORK(&pool->no_space_timeout, do_no_space_timeout);
 	spin_lock_init(&pool->lock);
 	bio_list_init(&pool->deferred_bios);
 	bio_list_init(&pool->deferred_flush_bios);
@@ -2519,6 +2539,7 @@ static void pool_postsuspend(struct dm_t
 	struct pool *pool = pt->pool;
 
 	cancel_delayed_work(&pool->waker);
+	cancel_delayed_work(&pool->no_space_timeout);
 	flush_workqueue(pool->wq);
 	(void) commit(pool);
 }


