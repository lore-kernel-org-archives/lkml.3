Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760272Ab3D2TNp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:13:45 -0400
Received: from 212.199.104.198.static.012.net.il ([212.199.104.198]:60329 "EHLO
	lx-merez.qi.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758608Ab3D2TNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:13:42 -0400
From: Maya Erez <merez@codeaurora.org>
To: linux-mmc@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Maya Erez <merez@codeaurora.org>,
        Lee Susman <lsusman@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v6] mmc: block: Add write packing control
Date: Mon, 29 Apr 2013 22:10:13 +0300
Message-Id: <1367262811-18105-1-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <n>
References: <n>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The write packing control will ensure that read requests latency is
not increased due to long write packed commands.

The trigger for enabling the write packing is calculated by the relation
between the number of potential packed write requests and the mean
value of all previous potential values:
If the current potential is greater than the mean potential then
the heuristic is that the following workload will contain many write
requests, therefore we lower the packed trigger. In the opposite case
we want to increase the trigger in order to get less packing events.
The trigger for disabling the write packing is fetching a read request.

Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Lee Susman <lsusman@codeaurora.org>
---
Our experiments showed that the write packing can increase the worst case read latency.
Since the read latency is critical for user experience we added a write packing control
mechanism that disables the write packing in case of read requests.
This will ensure that read requests latency is not increased due to long write packed commands.

The trigger for enabling the write packing is managing to pack several write requests.
The number of potential packed requests that will trigger the packing can be configured via sysfs.
The trigger for disabling the write packing is a fetch of a read request.

Changes in v6:
    - Dynamic calculation of the trigger for enabling te write packing (instead of a hardcoded value)

Changes in v5:
    - Revert v4 changes
    - fix the device attribute removal in case of failure of device_create_file

Changes in v4:
    - Move MMC specific attributes to mmc sub-directory

Changes in v3:
    - Fix the settings of num_of_potential_packed_wr_reqs

Changes in v2:
    - Move the attribute for setting the packing enabling trigger to the block device
    - Add documentation of the new attribute
---
 drivers/mmc/card/block.c |  131 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/mmc/card/queue.c |    8 +++
 drivers/mmc/card/queue.h |    3 +
 include/linux/mmc/host.h |    1 +
 4 files changed, 143 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index e12a03c..e0ed0b4 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -64,6 +64,13 @@ MODULE_ALIAS("mmc:block");
 				  (rq_data_dir(req) == WRITE))
 #define PACKED_CMD_VER	0x01
 #define PACKED_CMD_WR	0x02
+#define PACKED_TRIGGER_MAX_ELEMENTS	5000
+#define PCKD_TRGR_INIT_MEAN_POTEN	17
+#define PCKD_TRGR_POTEN_LOWER_BOUND	5
+#define PCKD_TRGR_URGENT_PENALTY	2
+#define PCKD_TRGR_LOWER_BOUND		5
+#define PCKD_TRGR_PRECISION_MULTIPLIER	100
+
 
 static DEFINE_MUTEX(block_mutex);
 
@@ -1405,6 +1412,122 @@ static inline u8 mmc_calc_packed_hdr_segs(struct request_queue *q,
 	return nr_segs;
 }
 
+static int get_packed_trigger(int potential, struct mmc_card *card,
+			      struct request *req, int curr_trigger)
+{
+	static int num_mean_elements = 1;
+	static unsigned long mean_potential = PCKD_TRGR_INIT_MEAN_POTEN;
+	unsigned int trigger = curr_trigger;
+	unsigned int pckd_trgr_upper_bound = card->ext_csd.max_packed_writes;
+
+	/* scale down the upper bound to 75% */
+	pckd_trgr_upper_bound = (pckd_trgr_upper_bound * 3) / 4;
+
+	/*
+	 * since the most common calls for this function are with small
+	 * potential write values and since we don't want these calls to affect
+	 * the packed trigger, set a lower bound and ignore calls with
+	 * potential lower than that bound
+	 */
+	if (potential <= PCKD_TRGR_POTEN_LOWER_BOUND)
+		return trigger;
+
+	/*
+	 * this is to prevent integer overflow in the following calculation:
+	 * once every PACKED_TRIGGER_MAX_ELEMENTS reset the algorithm
+	 */
+	if (num_mean_elements > PACKED_TRIGGER_MAX_ELEMENTS) {
+		num_mean_elements = 1;
+		mean_potential = PCKD_TRGR_INIT_MEAN_POTEN;
+	}
+
+	/*
+	 * get next mean value based on previous mean value and current
+	 * potential packed writes. Calculation is as follows:
+	 * mean_pot[i+1] =
+	 *	((mean_pot[i] * num_mean_elem) + potential)/(num_mean_elem + 1)
+	 */
+	mean_potential *= num_mean_elements;
+	/*
+	 * add num_mean_elements so that the division of two integers doesn't
+	 * lower mean_potential too much
+	 */
+	if (potential > mean_potential)
+		mean_potential += num_mean_elements;
+	mean_potential += potential;
+	/* this is for gaining more precision when dividing two integers */
+	mean_potential *= PCKD_TRGR_PRECISION_MULTIPLIER;
+	/* this completes the mean calculation */
+	mean_potential /= ++num_mean_elements;
+	mean_potential /= PCKD_TRGR_PRECISION_MULTIPLIER;
+
+	/*
+	 * if current potential packed writes is greater than the mean potential
+	 * then the heuristic is that the following workload will contain many
+	 * write requests, therefore we lower the packed trigger. In the
+	 * opposite case we want to increase the trigger in order to get less
+	 * packing events.
+	 */
+	if (potential >= mean_potential)
+		trigger = (trigger <= PCKD_TRGR_LOWER_BOUND) ?
+				PCKD_TRGR_LOWER_BOUND : trigger - 1;
+	else
+		trigger = (trigger >= pckd_trgr_upper_bound) ?
+				pckd_trgr_upper_bound : trigger + 1;
+
+	return trigger;
+}
+
+static void mmc_blk_write_packing_control(struct mmc_queue *mq,
+					  struct request *req)
+{
+	struct mmc_host *host = mq->card->host;
+	int data_dir;
+
+	if (!(host->caps2 & MMC_CAP2_PACKED_WR))
+		return;
+
+	/*
+	 * In case the packing control is not supported by the host, it should
+	 * not have an effect on the write packing. Therefore we have to enable
+	 * the write packing
+	 */
+	if (!(host->caps2 & MMC_CAP2_PACKED_WR_CONTROL)) {
+		mq->wr_packing_enabled = true;
+		return;
+	}
+
+	if (!req || (req && (req->cmd_flags & REQ_FLUSH))) {
+		if (mq->num_of_potential_packed_wr_reqs >
+				mq->num_wr_reqs_to_start_packing)
+			mq->wr_packing_enabled = true;
+		mq->num_wr_reqs_to_start_packing =
+			get_packed_trigger(mq->num_of_potential_packed_wr_reqs,
+					   mq->card, req,
+					   mq->num_wr_reqs_to_start_packing);
+		mq->num_of_potential_packed_wr_reqs = 0;
+		return;
+	}
+
+	data_dir = rq_data_dir(req);
+
+	if (data_dir == READ) {
+		mq->num_of_potential_packed_wr_reqs = 0;
+		mq->wr_packing_enabled = false;
+		mq->num_wr_reqs_to_start_packing =
+			get_packed_trigger(mq->num_of_potential_packed_wr_reqs,
+					   mq->card, req,
+					   mq->num_wr_reqs_to_start_packing);
+		return;
+	} else if (data_dir == WRITE) {
+		mq->num_of_potential_packed_wr_reqs++;
+	}
+
+	if (mq->num_of_potential_packed_wr_reqs >
+			mq->num_wr_reqs_to_start_packing)
+		mq->wr_packing_enabled = true;
+}
+
 static u8 mmc_blk_prep_packed_list(struct mmc_queue *mq, struct request *req)
 {
 	struct request_queue *q = mq->queue;
@@ -1422,6 +1545,9 @@ static u8 mmc_blk_prep_packed_list(struct mmc_queue *mq, struct request *req)
 	if (!(md->flags & MMC_BLK_PACKED_CMD))
 		goto no_packed;
 
+	if (!mq->wr_packing_enabled)
+		goto no_packed;
+
 	if ((rq_data_dir(cur) == WRITE) &&
 	    mmc_host_packed_wr(card->host))
 		max_packed_rw = card->ext_csd.max_packed_writes;
@@ -1490,6 +1616,8 @@ static u8 mmc_blk_prep_packed_list(struct mmc_queue *mq, struct request *req)
 		if (phys_segments > max_phys_segs)
 			break;
 
+		if (rq_data_dir(next) == WRITE)
+			mq->num_of_potential_packed_wr_reqs++;
 		list_add_tail(&next->queuelist, &mqrq->packed->list);
 		cur = next;
 		reqs++;
@@ -1908,6 +2036,9 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 	}
 
 	mq->flags &= ~MMC_QUEUE_NEW_REQUEST;
+
+	mmc_blk_write_packing_control(mq, req);
+
 	if (req && req->cmd_flags & REQ_DISCARD) {
 		/* complete ongoing async transfer before issuing discard */
 		if (card->host->areq)
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index 9447a0e..b876d92 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -23,6 +23,13 @@
 #define MMC_QUEUE_BOUNCESZ	65536
 
 /*
+ * Based on benchmark tests the default num of requests to trigger the write
+ * packing was determined, to keep the read latency as low as possible and
+ * manage to keep the high write throughput.
+ */
+#define DEFAULT_NUM_REQS_TO_START_PACK 17
+
+/*
  * Prepare a MMC request. This just filters out odd stuff.
  */
 static int mmc_prep_request(struct request_queue *q, struct request *req)
@@ -206,6 +213,7 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card,
 	mq->mqrq_cur = mqrq_cur;
 	mq->mqrq_prev = mqrq_prev;
 	mq->queue->queuedata = mq;
+	mq->num_wr_reqs_to_start_packing = DEFAULT_NUM_REQS_TO_START_PACK;
 
 	blk_queue_prep_rq(mq->queue, mmc_prep_request);
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, mq->queue);
diff --git a/drivers/mmc/card/queue.h b/drivers/mmc/card/queue.h
index 5752d50..864d81d 100644
--- a/drivers/mmc/card/queue.h
+++ b/drivers/mmc/card/queue.h
@@ -57,6 +57,9 @@ struct mmc_queue {
 	struct mmc_queue_req	mqrq[2];
 	struct mmc_queue_req	*mqrq_cur;
 	struct mmc_queue_req	*mqrq_prev;
+	bool			wr_packing_enabled;
+	int			num_of_potential_packed_wr_reqs;
+	int			num_wr_reqs_to_start_packing;
 };
 
 extern int mmc_init_queue(struct mmc_queue *, struct mmc_card *, spinlock_t *,
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index e326ae2..b1e4ec9 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -281,6 +281,7 @@ struct mmc_host {
 #define MMC_CAP2_PACKED_CMD	(MMC_CAP2_PACKED_RD | \
 				 MMC_CAP2_PACKED_WR)
 #define MMC_CAP2_NO_PRESCAN_POWERUP (1 << 14)	/* Don't power up before scan */
+#define MMC_CAP2_PACKED_WR_CONTROL (1 << 15) /* Allow write packing control */
 
 	mmc_pm_flag_t		pm_caps;	/* supported pm features */
 
-- 
1.7.3.3
-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
