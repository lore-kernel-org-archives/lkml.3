Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbaAPQ0K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 11:26:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53673 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970AbaAPQYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 11:24:42 -0500
From: Luiz Capitulino <lcapitulino@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, riel@redhat.com, aarcange@redhat.com,
        aquini@redhat.com, mst@redhat.com, rusty@rustcorp.com.au,
        vdavydov@parallels.com, amit.shah@redhat.com, dfediuck@redhat.com,
        agl@us.ibm.com
Subject: [RFC PATCH 3/4] virtio_balloon: add pressure notification via a new virtqueue
Date: Thu, 16 Jan 2014 11:24:04 -0500
Message-Id: <1389889445-3855-4-git-send-email-lcapitulino@redhat.com>
In-Reply-To: <1389889445-3855-1-git-send-email-lcapitulino@redhat.com>
References: <1389889445-3855-1-git-send-email-lcapitulino@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luiz capitulino <lcapitulino@redhat.com>

This commit adds support to a new virtqueue called message virtqueue.

The message virtqueue can be used by guests to notify the host about
important memory-related state changes in the guest. Currently, the
only implemented notification is the "guest is under pressure" one,
which informs the host that the guest is under memory pressure.

This notification can be used to implement automatic memory ballooning
in the host. For example, once learning that the guest is under pressure,
the host could cancel an on-going inflate and/or start a deflate
operation.

Doing this through a virtqueue might seem like overkill, as all
we're doing is to transfer an integer between guest and host. However,
using a virtqueue offers the following advantages:

 1. We can realibly synchronize host and guest. That is, the guest
    will only continue once the host acknowledges the notification.
    This is important, because if the guest gets under pressure while
    inflating the balloon, it has to stop to give the host a chance
    to reset "num_pages" (see next commit)

 2. It's extensible. We may (or may not) want to tell the host
    which pressure level the guest finds itself in (ie. low,
    medium or critical)

The lightweight alternative is to use a configuration space parameter.
For this to work though, the guest would have to wait the for host
to acknowloedge the receipt of a configuration change update. I could
try this if the virtqueue is too overkill.

Finally, the guest learns it's under pressure by registering a
callback with the in-kernel vmpressure API.

FIXMEs:

 - vmpressure API is missing an de-registration routine
 - not completely sure my changes in virtballoon_probe() are correct

Signed-off-by: Luiz capitulino <lcapitulino@redhat.com>
---
 drivers/virtio/virtio_balloon.c     | 93 +++++++++++++++++++++++++++++++++----
 include/uapi/linux/virtio_balloon.h |  1 +
 2 files changed, 84 insertions(+), 10 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 5c4a95b..1c3ee71 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -29,6 +29,9 @@
 #include <linux/module.h>
 #include <linux/balloon_compaction.h>
 
+#include <linux/cgroup.h>
+#include <linux/vmpressure.h>
+
 /*
  * Balloon device works in 4K page units.  So each page is pointed to by
  * multiple balloon pages.  All memory counters in this driver are in balloon
@@ -37,10 +40,12 @@
 #define VIRTIO_BALLOON_PAGES_PER_PAGE (unsigned)(PAGE_SIZE >> VIRTIO_BALLOON_PFN_SHIFT)
 #define VIRTIO_BALLOON_ARRAY_PFNS_MAX 256
 
+#define VIRTIO_BALLOON_MSG_PRESSURE 1
+
 struct virtio_balloon
 {
 	struct virtio_device *vdev;
-	struct virtqueue *inflate_vq, *deflate_vq, *stats_vq;
+	struct virtqueue *inflate_vq, *deflate_vq, *stats_vq, *message_vq;
 
 	/* Where the ballooning thread waits for config to change. */
 	wait_queue_head_t config_change;
@@ -51,6 +56,8 @@ struct virtio_balloon
 	/* Waiting for host to ack the pages we released. */
 	wait_queue_head_t acked;
 
+	wait_queue_head_t message_acked;
+
 	/* Number of balloon pages we've told the Host we're not using. */
 	unsigned int num_pages;
 	/*
@@ -71,6 +78,9 @@ struct virtio_balloon
 	/* Memory statistics */
 	int need_stats_update;
 	struct virtio_balloon_stat stats[VIRTIO_BALLOON_S_NR];
+
+	/* Message virtqueue */
+	atomic_t guest_pressure;
 };
 
 static struct virtio_device_id id_table[] = {
@@ -78,6 +88,41 @@ static struct virtio_device_id id_table[] = {
 	{ 0 },
 };
 
+static inline bool guest_under_pressure(const struct virtio_balloon *vb)
+{
+	return atomic_read(&vb->guest_pressure) == 1;
+}
+
+static void vmpressure_event_handler(void *data, int level)
+{
+	struct virtio_balloon *vb = data;
+
+	atomic_set(&vb->guest_pressure, 1);
+	wake_up(&vb->config_change);
+}
+
+static void tell_host_pressure(struct virtio_balloon *vb)
+{
+	const uint32_t msg = VIRTIO_BALLOON_MSG_PRESSURE;
+	struct scatterlist sg;
+	unsigned int len;
+	int err;
+
+	sg_init_one(&sg, &msg, sizeof(msg));
+
+	err = virtqueue_add_outbuf(vb->message_vq, &sg, 1, vb, GFP_KERNEL);
+	if (err < 0) {
+		printk(KERN_WARNING "virtio-balloon: failed to send host message (%d)\n", err);
+		goto out;
+	}
+	virtqueue_kick(vb->message_vq);
+
+	wait_event(vb->message_acked, virtqueue_get_buf(vb->message_vq, &len));
+
+out:
+	atomic_set(&vb->guest_pressure, 0);
+}
+
 static u32 page_to_balloon_pfn(struct page *page)
 {
 	unsigned long pfn = page_to_pfn(page);
@@ -100,6 +145,13 @@ static void balloon_ack(struct virtqueue *vq)
 	wake_up(&vb->acked);
 }
 
+static void message_ack(struct virtqueue *vq)
+{
+	struct virtio_balloon *vb = vq->vdev->priv;
+
+	wake_up(&vb->message_acked);
+}
+
 static void tell_host(struct virtio_balloon *vb, struct virtqueue *vq)
 {
 	struct scatterlist sg;
@@ -300,6 +352,7 @@ static int balloon(void *_vballoon)
 		try_to_freeze();
 		wait_event_interruptible(vb->config_change,
 					 (diff = towards_target(vb)) != 0
+					 || guest_under_pressure(vb)
 					 || vb->need_stats_update
 					 || kthread_should_stop()
 					 || freezing(current));
@@ -310,31 +363,38 @@ static int balloon(void *_vballoon)
 		else if (diff < 0)
 			leak_balloon(vb, -diff);
 		update_balloon_size(vb);
+
+		if (guest_under_pressure(vb))
+			tell_host_pressure(vb);
+
 	}
 	return 0;
 }
 
 static int init_vqs(struct virtio_balloon *vb)
 {
-	struct virtqueue *vqs[3];
-	vq_callback_t *callbacks[] = { balloon_ack, balloon_ack, stats_request };
-	const char *names[] = { "inflate", "deflate", "stats" };
-	int err, nvqs;
+	struct virtqueue *vqs[4];
+	vq_callback_t *callbacks[] = { balloon_ack, balloon_ack,
+				       stats_request, message_ack };
+	const char *names[] = { "inflate", "deflate", "stats", "pressure" };
+	int err, nvqs, idx;
 
 	/*
 	 * We expect two virtqueues: inflate and deflate, and
-	 * optionally stat.
+	 * optionally stat and message.
 	 */
-	nvqs = virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ) ? 3 : 2;
+	nvqs = 2 + virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ) +
+		virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_MESSAGE_VQ);
 	err = vb->vdev->config->find_vqs(vb->vdev, nvqs, vqs, callbacks, names);
 	if (err)
 		return err;
 
-	vb->inflate_vq = vqs[0];
-	vb->deflate_vq = vqs[1];
+	idx = 0;
+	vb->inflate_vq = vqs[idx++];
+	vb->deflate_vq = vqs[idx++];
 	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
 		struct scatterlist sg;
-		vb->stats_vq = vqs[2];
+		vb->stats_vq = vqs[idx++];
 
 		/*
 		 * Prime this virtqueue with one buffer so the hypervisor can
@@ -346,6 +406,9 @@ static int init_vqs(struct virtio_balloon *vb)
 			BUG();
 		virtqueue_kick(vb->stats_vq);
 	}
+	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_MESSAGE_VQ))
+		vb->message_vq = vqs[idx];
+
 	return 0;
 }
 
@@ -438,9 +501,11 @@ static int virtballoon_probe(struct virtio_device *vdev)
 	vb->num_pages = 0;
 	mutex_init(&vb->balloon_lock);
 	init_waitqueue_head(&vb->config_change);
+	init_waitqueue_head(&vb->message_acked);
 	init_waitqueue_head(&vb->acked);
 	vb->vdev = vdev;
 	vb->need_stats_update = 0;
+	atomic_set(&vb->guest_pressure, 0);
 
 	vb_devinfo = balloon_devinfo_alloc(vb);
 	if (IS_ERR(vb_devinfo)) {
@@ -467,6 +532,12 @@ static int virtballoon_probe(struct virtio_device *vdev)
 	if (err)
 		goto out_free_vb_mapping;
 
+	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_MESSAGE_VQ)) {
+		err = vmpressure_register_kernel_event(NULL, vmpressure_event_handler, vb);
+		if (err)
+			goto out_free_vb_mapping;
+	}
+
 	vb->thread = kthread_run(balloon, vb, "vballoon");
 	if (IS_ERR(vb->thread)) {
 		err = PTR_ERR(vb->thread);
@@ -476,6 +547,7 @@ static int virtballoon_probe(struct virtio_device *vdev)
 	return 0;
 
 out_del_vqs:
+	/* FIXME: add vmpressure_deregister_kernel_event() */
 	vdev->config->del_vqs(vdev);
 out_free_vb_mapping:
 	balloon_mapping_free(vb_mapping);
@@ -543,6 +615,7 @@ static int virtballoon_restore(struct virtio_device *vdev)
 static unsigned int features[] = {
 	VIRTIO_BALLOON_F_MUST_TELL_HOST,
 	VIRTIO_BALLOON_F_STATS_VQ,
+	VIRTIO_BALLOON_F_MESSAGE_VQ,
 };
 
 static struct virtio_driver virtio_balloon_driver = {
diff --git a/include/uapi/linux/virtio_balloon.h b/include/uapi/linux/virtio_balloon.h
index 5e26f61..846e46c 100644
--- a/include/uapi/linux/virtio_balloon.h
+++ b/include/uapi/linux/virtio_balloon.h
@@ -31,6 +31,7 @@
 /* The feature bitmap for virtio balloon */
 #define VIRTIO_BALLOON_F_MUST_TELL_HOST	0 /* Tell before reclaiming pages */
 #define VIRTIO_BALLOON_F_STATS_VQ	1 /* Memory Stats virtqueue */
+#define VIRTIO_BALLOON_F_MESSAGE_VQ	2 /* Message virtqueue */
 
 /* Size of a PFN in the balloon interface. */
 #define VIRTIO_BALLOON_PFN_SHIFT 12
-- 
1.8.1.4

