Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635AbaKTQD0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 11:03:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60939 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757524AbaKTQDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 11:03:24 -0500
From: Petr Mladek <pmladek@suse.cz>
To: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jeff Epler <jepler@unpythonic.net>, Tejun Heo <tj@kernel.org>,
        Jiri Kosina <jkosina@suse.cz>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.cz>
Subject: [PATCH v3] virtio_balloon: Convert "vballoon" kthread into a workqueue
Date: Thu, 20 Nov 2014 17:03:17 +0100
Message-Id: <1416499397-16669-1-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Workqueues have clean and rich API for all basic operations. The code is usually
easier and better readable. It can be easily tuned for the given purpose.

In many cases, it allows to avoid an extra kernel thread. It helps to stop the
growing number of them. Also there will be less thread-specific hacks all over
the kernel code.

It forces making the task selfcontained. There is no longer an unclear infinite
loop. This helps to avoid problems with suspend. Also it will be very helpful
for kGraft (kernel live patching).

The conversion is pretty straightforward. The main change is that there is not
longer an "infinite" loop in the balloon() handler. Instead, another work item
has to be scheduled from fill_balloon() and leak_balloon() when they do not
do all requested changes in a single call.

The initial patch allocated an extra workqueue for this task. Michael S. Tsirkin
suggested using the system freezable workqueue instead. Tejun Heo confirmed that
the system workqueue has a pretty high concurrency level (256) by default.
Therefore we need not be afraid of too long blocking.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
---
Changes in v3:

	+ Use system_freezable_wq instead of an allocated one
	  and move INIT_WORK() higher in virtballoon_probe().

	+ Fix typos in the commit message.

Changes in v2:

	+ More elegant detection of the pending work in fill_balloon() and
	  leak_balloon(). It still needs to keep the original requested number
	  of pages but it does not add any extra boolean variable.

	+ Remove WQ_MEM_RECLAIM workqueue parameter. If I get it correctly,
	  this is possible because the code manipulates memory but it is not
	  used in the memory reclaim path.

	+ initialize the work item before allocation the workqueue

 drivers/virtio/virtio_balloon.c | 87 +++++++++++++++++------------------------
 1 file changed, 35 insertions(+), 52 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index c9703d4d6f67..fb83faf3744c 100644
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
@@ -42,11 +41,8 @@ struct virtio_balloon
 	struct virtio_device *vdev;
 	struct virtqueue *inflate_vq, *deflate_vq, *stats_vq;
 
-	/* Where the ballooning thread waits for config to change. */
-	wait_queue_head_t config_change;
-
-	/* The thread servicing the balloon. */
-	struct task_struct *thread;
+	/* The balloon servicing is delegated to a freezable workqueue. */
+	struct work_struct wq_work;
 
 	/* Waiting for host to ack the pages we released. */
 	wait_queue_head_t acked;
@@ -128,12 +124,13 @@ static void set_page_pfns(u32 pfns[], struct page *page)
 static void fill_balloon(struct virtio_balloon *vb, size_t num)
 {
 	struct balloon_dev_info *vb_dev_info = &vb->vb_dev_info;
+	size_t limit;
 
 	/* We can only do one array worth at a time. */
-	num = min(num, ARRAY_SIZE(vb->pfns));
+	limit = min(num, ARRAY_SIZE(vb->pfns));
 
 	mutex_lock(&vb->balloon_lock);
-	for (vb->num_pfns = 0; vb->num_pfns < num;
+	for (vb->num_pfns = 0; vb->num_pfns < limit;
 	     vb->num_pfns += VIRTIO_BALLOON_PAGES_PER_PAGE) {
 		struct page *page = balloon_page_enqueue(vb_dev_info);
 
@@ -153,6 +150,9 @@ static void fill_balloon(struct virtio_balloon *vb, size_t num)
 	/* Did we get any? */
 	if (vb->num_pfns != 0)
 		tell_host(vb, vb->inflate_vq);
+	/* Do we need to get more? */
+	if (vb->num_pfns < num)
+		queue_work(system_freezable_wq, &vb->wq_work);
 	mutex_unlock(&vb->balloon_lock);
 }
 
@@ -172,12 +172,13 @@ static void leak_balloon(struct virtio_balloon *vb, size_t num)
 {
 	struct page *page;
 	struct balloon_dev_info *vb_dev_info = &vb->vb_dev_info;
+	size_t limit;
 
 	/* We can only do one array worth at a time. */
-	num = min(num, ARRAY_SIZE(vb->pfns));
+	limit = min(num, ARRAY_SIZE(vb->pfns));
 
 	mutex_lock(&vb->balloon_lock);
-	for (vb->num_pfns = 0; vb->num_pfns < num;
+	for (vb->num_pfns = 0; vb->num_pfns < limit;
 	     vb->num_pfns += VIRTIO_BALLOON_PAGES_PER_PAGE) {
 		page = balloon_page_dequeue(vb_dev_info);
 		if (!page)
@@ -193,6 +194,9 @@ static void leak_balloon(struct virtio_balloon *vb, size_t num)
 	 */
 	if (vb->num_pfns != 0)
 		tell_host(vb, vb->deflate_vq);
+	/* Schedule another call if a bigger change is requested */
+	if (vb->num_pfns < num)
+		queue_work(system_freezable_wq, &vb->wq_work);
 	mutex_unlock(&vb->balloon_lock);
 	release_pages_by_pfn(vb->pfns, vb->num_pfns);
 }
@@ -234,14 +238,15 @@ static void update_balloon_stats(struct virtio_balloon *vb)
  * with a single buffer.  From that point forward, all conversations consist of
  * a hypervisor request (a call to this function) which directs us to refill
  * the virtqueue with a fresh stats buffer.  Since stats collection can sleep,
- * we notify our kthread which does the actual work via stats_handle_request().
+ * we delegate the job to a freezable workqueue that will do the actual work via
+ * stats_handle_request().
  */
 static void stats_request(struct virtqueue *vq)
 {
 	struct virtio_balloon *vb = vq->vdev->priv;
 
 	vb->need_stats_update = 1;
-	wake_up(&vb->config_change);
+	queue_work(system_freezable_wq, &vb->wq_work);
 }
 
 static void stats_handle_request(struct virtio_balloon *vb)
@@ -265,7 +270,7 @@ static void virtballoon_changed(struct virtio_device *vdev)
 {
 	struct virtio_balloon *vb = vdev->priv;
 
-	wake_up(&vb->config_change);
+	queue_work(system_freezable_wq, &vb->wq_work);
 }
 
 static inline s64 towards_target(struct virtio_balloon *vb)
@@ -287,35 +292,22 @@ static void update_balloon_size(struct virtio_balloon *vb)
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
@@ -427,9 +419,9 @@ static int virtballoon_probe(struct virtio_device *vdev)
 		goto out;
 	}
 
+	INIT_WORK(&vb->wq_work, balloon);
 	vb->num_pages = 0;
 	mutex_init(&vb->balloon_lock);
-	init_waitqueue_head(&vb->config_change);
 	init_waitqueue_head(&vb->acked);
 	vb->vdev = vdev;
 	vb->need_stats_update = 0;
@@ -443,16 +435,8 @@ static int virtballoon_probe(struct virtio_device *vdev)
 	if (err)
 		goto out_free_vb;
 
-	vb->thread = kthread_run(balloon, vb, "vballoon");
-	if (IS_ERR(vb->thread)) {
-		err = PTR_ERR(vb->thread);
-		goto out_del_vqs;
-	}
-
 	return 0;
 
-out_del_vqs:
-	vdev->config->del_vqs(vdev);
 out_free_vb:
 	kfree(vb);
 out:
@@ -476,7 +460,6 @@ static void virtballoon_remove(struct virtio_device *vdev)
 {
 	struct virtio_balloon *vb = vdev->priv;
 
-	kthread_stop(vb->thread);
 	remove_common(vb);
 	kfree(vb);
 }
@@ -487,7 +470,7 @@ static int virtballoon_freeze(struct virtio_device *vdev)
 	struct virtio_balloon *vb = vdev->priv;
 
 	/*
-	 * The kthread is already frozen by the PM core before this
+	 * The workqueue is already frozen by the PM core before this
 	 * function is called.
 	 */
 
-- 
1.8.5.2

