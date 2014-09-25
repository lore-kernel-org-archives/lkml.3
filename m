Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbaIYQU6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 12:20:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45655 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585AbaIYQU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 12:20:57 -0400
From: Petr Mladek <pmladek@suse.cz>
To: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.cz>
Subject: [PATCH] virtio_balloon: Convert "vballon" kthread into a workqueue
Date: Thu, 25 Sep 2014 18:20:41 +0200
Message-Id: <1411662041-10986-1-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Workqueues have clean and rich API for all basic operations. The code is usually
easier and better readable. It can be easily tuned for the given purpose.

In many cases, it allows to avoid an extra kernel thread. It helps to stop the
growing number of them.  Also there will be less thread-specific hacks all over
the kernel code.

It forces making the task selfcontained. There is no longer an unclear infinite
loop. This helps to avoid problems with suspend. Also it will be very helpful
for kGraft (kernel live patching).

The conversion is pretty straightforward. The main change is that there is not
longer an "infinite" loop in the balloon() handler. Instead, another work item
has to be scheduled from fill_balloon() and leak_balloon() when they do not
do all requested changes in a single call.

I think that performance is not the most critical thing in this case. Anyway,
I tried to create the workqueue two ways:

    1st create_freezable_workqueue("vballoon_wq");
    2nd alloc_workqueue("vballoon_wq", WQ_FREEZABLE | WQ_MEM_RECLAIM, 0);

And then I tried to modify 10 times the size of a virtual host by ballooning
between 20GB and 2GB. I got the following times:

    -----------------------------------------------------
    |         | kthread     | 1st wq      | 2nd wq      |
    -----------------------------------------------------
    | time[s] | 5066.230331 | 5460.384923 | 5136.32219  |
    |         | 3755.667734 | 4032.29428  | 4078.839087 |
    |         | 4984.925544 | 5436.706062 | 4836.647582 |
    |         | 3817.742365 | 4046.590685 | 3969.484997 |
    |         | 5010.186757 | 5454.577506 | 4850.400675 |
    |         | 3881.12031m | 3987.210037 | 3885.71425  |
    |         | 4898.941678 | 5436.10978  | 5105.62308  |
    |         | 3837.999066 | 4008.397516 | 4038.372574 |
    |         | 5016.169314 | 5441.707981 | 5009.568925 |
    |         | 4105.874425 | 4056.70582  | 3836.104856 |
    -----------------------------------------------------
    | Avg.    | 4499.304135 | 4736.068459 | 4474.707822 |
    | Diff[%] |             | 5.26        | -0.55       |
    -----------------------------------------------------

The 2nd way to create the workqueue has about the same results as kthread.
This is why it is used in the patch.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 drivers/virtio/virtio_balloon.c | 96 ++++++++++++++++++++---------------------
 1 file changed, 48 insertions(+), 48 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 25ebe8eecdb7..a17f89ed3872 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -22,8 +22,7 @@
 #include <linux/virtio.h>
 #include <linux/virtio_balloon.h>
 #include <linux/swap.h>
-#include <linux/kthread.h>
-#include <linux/freezer.h>
+#include <linux/workqueue.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/module.h>
@@ -42,11 +41,9 @@ struct virtio_balloon
 	struct virtio_device *vdev;
 	struct virtqueue *inflate_vq, *deflate_vq, *stats_vq;
 
-	/* Where the ballooning thread waits for config to change. */
-	wait_queue_head_t config_change;
-
-	/* The thread servicing the balloon. */
-	struct task_struct *thread;
+	/* The workqueue servicing the balloon. */
+	struct workqueue_struct *wq;
+	struct work_struct wq_work;
 
 	/* Waiting for host to ack the pages we released. */
 	wait_queue_head_t acked;
@@ -125,12 +122,15 @@ static void set_page_pfns(u32 pfns[], struct page *page)
 		pfns[i] = page_to_balloon_pfn(page) + i;
 }
 
-static void fill_balloon(struct virtio_balloon *vb, size_t num)
+static void fill_balloon(struct virtio_balloon *vb, size_t diff)
 {
 	struct balloon_dev_info *vb_dev_info = vb->vb_dev_info;
+	size_t num;
+	bool done;
 
 	/* We can only do one array worth at a time. */
-	num = min(num, ARRAY_SIZE(vb->pfns));
+	num = min(diff, ARRAY_SIZE(vb->pfns));
+	done = (num == diff) ? true : false;
 
 	mutex_lock(&vb->balloon_lock);
 	for (vb->num_pfns = 0; vb->num_pfns < num;
@@ -143,6 +143,7 @@ static void fill_balloon(struct virtio_balloon *vb, size_t num)
 					     VIRTIO_BALLOON_PAGES_PER_PAGE);
 			/* Sleep for at least 1/5 of a second before retry. */
 			msleep(200);
+			done = false;
 			break;
 		}
 		set_page_pfns(vb->pfns + vb->num_pfns, page);
@@ -154,6 +155,9 @@ static void fill_balloon(struct virtio_balloon *vb, size_t num)
 	if (vb->num_pfns != 0)
 		tell_host(vb, vb->inflate_vq);
 	mutex_unlock(&vb->balloon_lock);
+
+	if (!done)
+		queue_work(vb->wq, &vb->wq_work);
 }
 
 static void release_pages_by_pfn(const u32 pfns[], unsigned int num)
@@ -168,20 +172,25 @@ static void release_pages_by_pfn(const u32 pfns[], unsigned int num)
 	}
 }
 
-static void leak_balloon(struct virtio_balloon *vb, size_t num)
+static void leak_balloon(struct virtio_balloon *vb, size_t diff)
 {
 	struct page *page;
 	struct balloon_dev_info *vb_dev_info = vb->vb_dev_info;
+	size_t num;
+	bool done;
 
 	/* We can only do one array worth at a time. */
-	num = min(num, ARRAY_SIZE(vb->pfns));
+	num = min(diff, ARRAY_SIZE(vb->pfns));
+	done = (num == diff) ? true : false;
 
 	mutex_lock(&vb->balloon_lock);
 	for (vb->num_pfns = 0; vb->num_pfns < num;
 	     vb->num_pfns += VIRTIO_BALLOON_PAGES_PER_PAGE) {
 		page = balloon_page_dequeue(vb_dev_info);
-		if (!page)
+		if (!page) {
+			done = false;
 			break;
+		}
 		set_page_pfns(vb->pfns + vb->num_pfns, page);
 		vb->num_pages -= VIRTIO_BALLOON_PAGES_PER_PAGE;
 	}
@@ -195,6 +204,9 @@ static void leak_balloon(struct virtio_balloon *vb, size_t num)
 		tell_host(vb, vb->deflate_vq);
 	mutex_unlock(&vb->balloon_lock);
 	release_pages_by_pfn(vb->pfns, vb->num_pfns);
+
+	if (!done)
+		queue_work(vb->wq, &vb->wq_work);
 }
 
 static inline void update_stat(struct virtio_balloon *vb, int idx,
@@ -234,14 +246,14 @@ static void update_balloon_stats(struct virtio_balloon *vb)
  * with a single buffer.  From that point forward, all conversations consist of
  * a hypervisor request (a call to this function) which directs us to refill
  * the virtqueue with a fresh stats buffer.  Since stats collection can sleep,
- * we notify our kthread which does the actual work via stats_handle_request().
+ * we queue a work that will do the actual work via stats_handle_request().
  */
 static void stats_request(struct virtqueue *vq)
 {
 	struct virtio_balloon *vb = vq->vdev->priv;
 
 	vb->need_stats_update = 1;
-	wake_up(&vb->config_change);
+	queue_work(vb->wq, &vb->wq_work);
 }
 
 static void stats_handle_request(struct virtio_balloon *vb)
@@ -265,7 +277,7 @@ static void virtballoon_changed(struct virtio_device *vdev)
 {
 	struct virtio_balloon *vb = vdev->priv;
 
-	wake_up(&vb->config_change);
+	queue_work(vb->wq, &vb->wq_work);
 }
 
 static inline s64 towards_target(struct virtio_balloon *vb)
@@ -287,35 +299,22 @@ static void update_balloon_size(struct virtio_balloon *vb)
 		      &actual);
 }
 
-static int balloon(void *_vballoon)
+static void balloon(struct work_struct *work)
 {
-	struct virtio_balloon *vb = _vballoon;
-
-	set_freezable();
-	while (!kthread_should_stop()) {
-		s64 diff;
-
-		try_to_freeze();
-		wait_event_interruptible(vb->config_change,
-					 (diff = towards_target(vb)) != 0
-					 || vb->need_stats_update
-					 || kthread_should_stop()
-					 || freezing(current));
-		if (vb->need_stats_update)
-			stats_handle_request(vb);
-		if (diff > 0)
-			fill_balloon(vb, diff);
-		else if (diff < 0)
-			leak_balloon(vb, -diff);
-		update_balloon_size(vb);
+	struct virtio_balloon *vb;
+	s64 diff;
 
-		/*
-		 * For large balloon changes, we could spend a lot of time
-		 * and always have work to do.  Be nice if preempt disabled.
-		 */
-		cond_resched();
-	}
-	return 0;
+	vb = container_of(work, struct virtio_balloon, wq_work);
+	diff = towards_target(vb);
+
+	if (vb->need_stats_update)
+		stats_handle_request(vb);
+
+	if (diff > 0)
+		fill_balloon(vb, diff);
+	else if (diff < 0)
+		leak_balloon(vb, -diff);
+	update_balloon_size(vb);
 }
 
 static int init_vqs(struct virtio_balloon *vb)
@@ -441,7 +440,6 @@ static int virtballoon_probe(struct virtio_device *vdev)
 
 	vb->num_pages = 0;
 	mutex_init(&vb->balloon_lock);
-	init_waitqueue_head(&vb->config_change);
 	init_waitqueue_head(&vb->acked);
 	vb->vdev = vdev;
 	vb->need_stats_update = 0;
@@ -471,11 +469,13 @@ static int virtballoon_probe(struct virtio_device *vdev)
 	if (err)
 		goto out_free_vb_mapping;
 
-	vb->thread = kthread_run(balloon, vb, "vballoon");
-	if (IS_ERR(vb->thread)) {
-		err = PTR_ERR(vb->thread);
+	vb->wq = alloc_workqueue("vballoon_wq",
+				 WQ_FREEZABLE | WQ_MEM_RECLAIM, 0);
+	if (!vb->wq) {
+		err = -ENOMEM;
 		goto out_del_vqs;
 	}
+	INIT_WORK(&vb->wq_work, balloon);
 
 	return 0;
 
@@ -508,7 +508,7 @@ static void virtballoon_remove(struct virtio_device *vdev)
 {
 	struct virtio_balloon *vb = vdev->priv;
 
-	kthread_stop(vb->thread);
+	destroy_workqueue(vb->wq);
 	remove_common(vb);
 	balloon_mapping_free(vb->vb_dev_info->mapping);
 	balloon_devinfo_free(vb->vb_dev_info);
@@ -521,7 +521,7 @@ static int virtballoon_freeze(struct virtio_device *vdev)
 	struct virtio_balloon *vb = vdev->priv;
 
 	/*
-	 * The kthread is already frozen by the PM core before this
+	 * The workqueue is already frozen by the PM core before this
 	 * function is called.
 	 */
 
-- 
1.8.4

