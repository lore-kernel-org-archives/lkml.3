Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588AbaGJVwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:52:13 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:50319 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491AbaGJVwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:52:01 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH 17/83] hsa/radeon: Handle deactivation of queues using interrupts
Date: Fri, 11 Jul 2014 00:50:17 +0300
Message-Id: <1405029027-6085-16-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies the scheduler code to use interrupts to handle the
deactivation of queues. We prefer to use interrupts because the
deactivation could take a long time since we need to wait for the
wavefront to finish executing before deactivating the queue.

There is an array of waitqueues, each cell is represents queues for a
specific pipe. When a queue should be deactivated, it is inserted to the
wait queue. The event that triggers the waitqueue is a dequeue-complete
interrupt that arrives through the isr function of the scheduler.

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/cik_regs.h             |  1 +
 drivers/gpu/hsa/radeon/kfd_sched_cik_static.c | 45 +++++++++++++++++++++------
 2 files changed, 37 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/hsa/radeon/cik_regs.h b/drivers/gpu/hsa/radeon/cik_regs.h
index ef1d7ab..9c3ce97 100644
--- a/drivers/gpu/hsa/radeon/cik_regs.h
+++ b/drivers/gpu/hsa/radeon/cik_regs.h
@@ -166,6 +166,7 @@
 
 #define CP_HQD_DEQUEUE_REQUEST				0xC974
 #define	DEQUEUE_REQUEST_DRAIN				1
+#define		DEQUEUE_INT					(1U << 8)
 
 #define CP_HQD_SEMA_CMD					0xC97Cu
 #define CP_HQD_MSG_TYPE					0xC980u
diff --git a/drivers/gpu/hsa/radeon/kfd_sched_cik_static.c b/drivers/gpu/hsa/radeon/kfd_sched_cik_static.c
index f86f958..5d42e88 100644
--- a/drivers/gpu/hsa/radeon/kfd_sched_cik_static.c
+++ b/drivers/gpu/hsa/radeon/kfd_sched_cik_static.c
@@ -139,6 +139,13 @@ struct cik_static_private {
 	 /* Queue q on pipe p is at bit QUEUES_PER_PIPE * p + q. */
 	unsigned long free_queues[DIV_ROUND_UP(CIK_MAX_PIPES * CIK_QUEUES_PER_PIPE, BITS_PER_LONG)];
 
+	/*
+	 * Dequeue waits for waves to finish so it could take a long time. We
+	 * defer through an interrupt. dequeue_wait is woken when a dequeue-
+	 * complete interrupt comes for that pipe.
+	 */
+	wait_queue_head_t dequeue_wait[CIK_MAX_PIPES];
+
 	kfd_mem_obj hpd_mem;	/* Single allocation for HPDs for all KFD pipes. */
 	kfd_mem_obj mqd_mem;	/* Single allocation for all MQDs for all KFD
 				 * pipes. This is actually struct cik_mqd_padded. */
@@ -411,6 +418,9 @@ static int cik_static_create(struct kfd_dev *dev, struct kfd_scheduler **schedul
 
 	priv->free_vmid_mask = dev->shared_resources.compute_vmid_bitmap;
 
+	for (i = 0; i < priv->num_pipes; i++)
+		init_waitqueue_head(&priv->dequeue_wait[i]);
+
 	/*
 	 * Allocate memory for the HPDs. This is hardware-owned per-pipe data.
 	 * The driver never accesses this memory after zeroing it. It doesn't even have
@@ -712,15 +722,18 @@ static void activate_queue(struct cik_static_private *priv, struct cik_static_qu
 	unlock_srbm_index(priv);
 }
 
-static void drain_hqd(struct cik_static_private *priv)
+static bool queue_inactive(struct cik_static_private *priv, struct cik_static_queue *queue)
 {
-	WRITE_REG(priv->dev, CP_HQD_DEQUEUE_REQUEST, DEQUEUE_REQUEST_DRAIN);
-}
+	bool inactive;
 
-static void wait_hqd_inactive(struct cik_static_private *priv)
-{
-	while (READ_REG(priv->dev, CP_HQD_ACTIVE) != 0)
-		cpu_relax();
+	lock_srbm_index(priv);
+	queue_select(priv, queue->queue);
+
+	inactive = (READ_REG(priv->dev, CP_HQD_ACTIVE) == 0);
+
+	unlock_srbm_index(priv);
+
+	return inactive;
 }
 
 static void deactivate_queue(struct cik_static_private *priv, struct cik_static_queue *queue)
@@ -728,10 +741,12 @@ static void deactivate_queue(struct cik_static_private *priv, struct cik_static_
 	lock_srbm_index(priv);
 	queue_select(priv, queue->queue);
 
-	drain_hqd(priv);
-	wait_hqd_inactive(priv);
+	WRITE_REG(priv->dev, CP_HQD_DEQUEUE_REQUEST, DEQUEUE_REQUEST_DRAIN | DEQUEUE_INT);
 
 	unlock_srbm_index(priv);
+
+	wait_event(priv->dequeue_wait[queue->queue/CIK_QUEUES_PER_PIPE],
+		   queue_inactive(priv, queue));
 }
 
 #define BIT_MASK_64(high, low) (((1ULL << (high)) - 1) & ~((1ULL << (low)) - 1))
@@ -791,6 +806,14 @@ cik_static_destroy_queue(struct kfd_scheduler *scheduler, struct kfd_scheduler_q
 	release_hqd(priv, hwq->queue);
 }
 
+static void
+dequeue_int_received(struct cik_static_private *priv, uint32_t pipe_id)
+{
+	/* The waiting threads will check CP_HQD_ACTIVE to see whether their
+	 * queue completed. */
+	wake_up_all(&priv->dequeue_wait[pipe_id]);
+}
+
 /* Figure out the KFD compute pipe ID for an interrupt ring entry.
  * Returns true if it's a KFD compute pipe, false otherwise. */
 static bool int_compute_pipe(const struct cik_static_private *priv,
@@ -829,6 +852,10 @@ cik_static_interrupt_isr(struct kfd_scheduler *scheduler, const void *ih_ring_en
 		 ihre->source_id, ihre->data, pipe_id, ihre->vmid, ihre->pasid);
 
 	switch (source_id) {
+	case CIK_INTSRC_DEQUEUE_COMPLETE:
+		dequeue_int_received(priv, pipe_id);
+		return false; /* Already handled. */
+
 	default:
 		return false; /* Not interested. */
 	}
-- 
1.9.1

