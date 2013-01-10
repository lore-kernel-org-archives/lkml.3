Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab3AJUPw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 15:15:52 -0500
Received: from 212.199.104.198.static.012.net.il ([212.199.104.198]:36879 "EHLO
	lx-merez.qi.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752193Ab3AJUPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 15:15:50 -0500
From: Maya Erez <merez@codeaurora.org>
To: linux-mmc@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Maya Erez <merez@codeaurora.org>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v5 1/3] mmc: core: Add support for idle time BKOPS
Date: Thu, 10 Jan 2013 22:15:19 +0200
Message-Id: <1357848921-9596-2-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <n>
References: <n>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Devices have various maintenance operations need to perform internally.
In order to reduce latencies during time critical operations like read
and write, it is better to execute maintenance operations in other
times - when the host is not being serviced. Such operations are called
Background operations (BKOPS).
The device notifies the status of the BKOPS need by updating BKOPS_STATUS
(EXT_CSD byte [246]).

According to the standard a host that supports BKOPS shall check the
status periodically and start background operations as needed, so that
the device has enough time for its maintenance operations.

This patch adds support for this periodic check of the BKOPS status.
Since foreground operations are of higher priority than background
operations the host will check the need for BKOPS when it is idle,
and in case of an incoming request the BKOPS operation will be
interrupted.

When the mmcqd thread is idle, a delayed work is created to check the
need for BKOPS. The time to start the delayed work can be set by the host
controller. If this time is not set, a default time is used.
If the card raised an exception with need for urgent BKOPS (level 2/3)
a flag will be set to indicate MMC to start the BKOPS activity when it
becomes idle.

Since running the BKOPS too often can impact the eMMC endurance, the card
need for BKOPS is not checked every time MMC is idle (despite of cases of
exception raised). In order to estimate when is the best time to check
for BKOPS need the host will take into account the card capacity and
percentages of changed sectors in the card. A future enhancement can be to
check the card need for BKOPS only in case of random activity.

Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 Documentation/mmc/mmc-dev-attrs.txt |    9 ++
 drivers/mmc/card/block.c            |   96 +++++++++++++++++++++-
 drivers/mmc/card/queue.c            |    2 +
 drivers/mmc/core/core.c             |  155 +++++++++++++++++++++++++++--------
 drivers/mmc/core/mmc.c              |   17 ++++
 include/linux/mmc/card.h            |   47 ++++++++++-
 include/linux/mmc/core.h            |    2 +
 7 files changed, 291 insertions(+), 37 deletions(-)

diff --git a/Documentation/mmc/mmc-dev-attrs.txt b/Documentation/mmc/mmc-dev-attrs.txt
index 0d98fac..8d33b80 100644
--- a/Documentation/mmc/mmc-dev-attrs.txt
+++ b/Documentation/mmc/mmc-dev-attrs.txt
@@ -8,6 +8,15 @@ The following attributes are read/write.
 
 	force_ro		Enforce read-only access even if write protect switch is off.
 
+	bkops_check_threshold	This attribute is used to determine whether
+	the status bit that indicates the need for BKOPS should be checked.
+	The value should be given in percentages of the card size.
+	This value is used to calculate the minimum number of sectors that
+	needs to be changed in the device (written or discarded) in order to
+	require the status-bit of BKOPS to be checked.
+	The value can modified via sysfs by writing the required value to:
+	/sys/block/<block_dev_name>/bkops_check_threshold
+
 SD and MMC Device Attributes
 ============================
 
diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 21056b9..a4d4b7e 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -108,6 +108,7 @@ struct mmc_blk_data {
 	unsigned int	part_curr;
 	struct device_attribute force_ro;
 	struct device_attribute power_ro_lock;
+	struct device_attribute bkops_check_threshold;
 	int	area_type;
 };
 
@@ -268,6 +269,65 @@ out:
 	return ret;
 }
 
+static ssize_t
+bkops_check_threshold_show(struct device *dev,
+				  struct device_attribute *attr, char *buf)
+{
+	struct mmc_blk_data *md = mmc_blk_get(dev_to_disk(dev));
+	struct mmc_card *card = md->queue.card;
+	int ret;
+
+	if (!card)
+		ret = -EINVAL;
+	else
+	    ret = snprintf(buf, PAGE_SIZE, "%d\n",
+		card->bkops_info.size_percentage_to_queue_delayed_work);
+
+	mmc_blk_put(md);
+	return ret;
+}
+
+static ssize_t
+bkops_check_threshold_store(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t count)
+{
+	int value;
+	struct mmc_blk_data *md = mmc_blk_get(dev_to_disk(dev));
+	struct mmc_card *card = md->queue.card;
+	unsigned int card_size;
+	int ret = count;
+
+	if (!card) {
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	sscanf(buf, "%d", &value);
+	if ((value <= 0) || (value >= 100)) {
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	card_size = (unsigned int)get_capacity(md->disk);
+	if (card_size <= 0) {
+		ret = -EINVAL;
+		goto exit;
+	}
+	card->bkops_info.size_percentage_to_queue_delayed_work = value;
+	card->bkops_info.min_sectors_to_queue_delayed_work =
+		(card_size * value) / 100;
+
+	pr_debug("%s: size_percentage = %d, min_sectors = %d",
+			mmc_hostname(card->host),
+			card->bkops_info.size_percentage_to_queue_delayed_work,
+			card->bkops_info.min_sectors_to_queue_delayed_work);
+
+exit:
+	mmc_blk_put(md);
+	return count;
+}
+
 static int mmc_blk_open(struct block_device *bdev, fmode_t mode)
 {
 	struct mmc_blk_data *md = mmc_blk_get(bdev->bd_disk);
@@ -892,6 +952,9 @@ static int mmc_blk_issue_discard_rq(struct mmc_queue *mq, struct request *req)
 	from = blk_rq_pos(req);
 	nr = blk_rq_sectors(req);
 
+	if (card->ext_csd.bkops_en)
+		card->bkops_info.sectors_changed += blk_rq_sectors(req);
+
 	if (mmc_can_discard(card))
 		arg = MMC_DISCARD_ARG;
 	else if (mmc_can_trim(card))
@@ -1347,6 +1410,10 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
 	if (!rqc && !mq->mqrq_prev->req)
 		return 0;
 
+	if ((rqc) && (card->ext_csd.bkops_en) && 
+		(rq_data_dir(rqc) == WRITE))			
+		card->bkops_info.sectors_changed += blk_rq_sectors(rqc);
+
 	do {
 		if (rqc) {
 			/*
@@ -1473,9 +1540,12 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 	struct mmc_blk_data *md = mq->data;
 	struct mmc_card *card = md->queue.card;
 
-	if (req && !mq->mqrq_prev->req)
+	if (req && !mq->mqrq_prev->req) {
 		/* claim host only for the first request */
 		mmc_claim_host(card->host);
+		if (card->ext_csd.bkops_en)
+			mmc_stop_bkops(card);
+	}
 
 	ret = mmc_blk_part_switch(card, md);
 	if (ret) {
@@ -1505,9 +1575,12 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 	}
 
 out:
-	if (!req)
+	if (!req) {
+		if (mmc_card_need_bkops(card))
+			mmc_start_bkops(card, false);
 		/* release host only when there are no more requests */
 		mmc_release_host(card->host);
+	}
 	return ret;
 }
 
@@ -1526,6 +1599,8 @@ static struct mmc_blk_data *mmc_blk_alloc_req(struct mmc_card *card,
 {
 	struct mmc_blk_data *md;
 	int devidx, ret;
+	unsigned int percentage =
+		BKOPS_SIZE_PERCENTAGE_TO_QUEUE_DELAYED_WORK;
 
 	devidx = find_first_zero_bit(dev_use, max_devices);
 	if (devidx >= max_devices)
@@ -1609,6 +1684,10 @@ static struct mmc_blk_data *mmc_blk_alloc_req(struct mmc_card *card,
 
 	set_capacity(md->disk, size);
 
+	card->bkops_info.size_percentage_to_queue_delayed_work = percentage;
+	card->bkops_info.min_sectors_to_queue_delayed_work =
+		((unsigned int)size * percentage) / 100;
+
 	if (mmc_host_cmd23(card->host)) {
 		if (mmc_card_mmc(card) ||
 		    (mmc_card_sd(card) &&
@@ -1785,8 +1864,21 @@ static int mmc_add_disk(struct mmc_blk_data *md)
 		if (ret)
 			goto power_ro_lock_fail;
 	}
+
+	md->bkops_check_threshold.show = bkops_check_threshold_show;
+	md->bkops_check_threshold.store = bkops_check_threshold_store;
+	sysfs_attr_init(&md->bkops_check_threshold.attr);
+	md->bkops_check_threshold.attr.name = "bkops_check_threshold";
+	md->bkops_check_threshold.attr.mode = S_IRUGO | S_IWUSR;
+	ret = device_create_file(disk_to_dev(md->disk),
+				 &md->bkops_check_threshold);
+	if (ret)
+		goto bkops_check_threshold_fails;
+
 	return ret;
 
+bkops_check_threshold_fails:
+	device_remove_file(disk_to_dev(md->disk), &md->power_ro_lock);
 power_ro_lock_fail:
 	device_remove_file(disk_to_dev(md->disk), &md->force_ro);
 force_ro_fail:
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index fadf52e..9d0c96a 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -51,6 +51,7 @@ static int mmc_queue_thread(void *d)
 {
 	struct mmc_queue *mq = d;
 	struct request_queue *q = mq->queue;
+	struct mmc_card *card = mq->card;
 
 	current->flags |= PF_MEMALLOC;
 
@@ -83,6 +84,7 @@ static int mmc_queue_thread(void *d)
 				set_current_state(TASK_RUNNING);
 				break;
 			}
+			mmc_start_delayed_bkops(card);
 			up(&mq->thread_sem);
 			schedule();
 			down(&mq->thread_sem);
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index aaed768..c8cb98e 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -256,9 +256,39 @@ mmc_start_request(struct mmc_host *host, struct mmc_request *mrq)
 }
 
 /**
+ * mmc_start_delayed_bkops() - Start a delayed work to check for
+ *      the need of non urgent BKOPS
+ *
+ * @card: MMC card to start BKOPS on
+ */
+void mmc_start_delayed_bkops(struct mmc_card *card)
+{
+	if (!card || !card->ext_csd.bkops_en || mmc_card_doing_bkops(card))
+		return;
+
+	if (card->bkops_info.sectors_changed <
+	    card->bkops_info.min_sectors_to_queue_delayed_work)
+		return;
+
+	pr_debug("%s: %s: queueing delayed_bkops_work\n",
+		 mmc_hostname(card->host), __func__);
+
+	/*
+	 * cancel_delayed_bkops_work will prevent a race condition between
+	 * fetching a request by the mmcqd and the delayed work, in case
+	 * it was removed from the queue work but not started yet
+	 */
+	card->bkops_info.cancel_delayed_work = false;
+	queue_delayed_work(system_nrt_wq, &card->bkops_info.dw,
+			   msecs_to_jiffies(
+				   card->bkops_info.delay_ms));
+}
+EXPORT_SYMBOL(mmc_start_delayed_bkops);
+
+/**
  *	mmc_start_bkops - start BKOPS for supported cards
  *	@card: MMC card to start BKOPS
- *	@form_exception: A flag to indicate if this function was
+ *	@from_exception: A flag to indicate if this function was
  *			 called due to an exception raised by the card
  *
  *	Start background operations whenever requested.
@@ -268,57 +298,100 @@ mmc_start_request(struct mmc_host *host, struct mmc_request *mrq)
 void mmc_start_bkops(struct mmc_card *card, bool from_exception)
 {
 	int err;
-	int timeout;
-	bool use_busy_signal;
 
 	BUG_ON(!card);
-
-	if (!card->ext_csd.bkops_en || mmc_card_doing_bkops(card))
+	if (!card->ext_csd.bkops_en)
 		return;
 
-	err = mmc_read_bkops_status(card);
-	if (err) {
-		pr_err("%s: Failed to read bkops status: %d\n",
-		       mmc_hostname(card->host), err);
-		return;
+	mmc_claim_host(card->host);
+
+	if ((card->bkops_info.cancel_delayed_work) && !from_exception) {
+		pr_debug("%s: %s: cancel_delayed_work was set, exit\n",
+			 mmc_hostname(card->host), __func__);
+		card->bkops_info.cancel_delayed_work = false;
+		goto out;
 	}
 
-	if (!card->ext_csd.raw_bkops_status)
-		return;
+	if (mmc_card_doing_bkops(card)) {
+		pr_debug("%s: %s: already doing bkops, exit\n",
+			 mmc_hostname(card->host), __func__);
+		goto out;
+	}
 
-	if (card->ext_csd.raw_bkops_status < EXT_CSD_BKOPS_LEVEL_2 &&
-	    from_exception)
-		return;
+	if (from_exception && mmc_card_need_bkops(card))
+		goto out;
 
-	mmc_claim_host(card->host);
-	if (card->ext_csd.raw_bkops_status >= EXT_CSD_BKOPS_LEVEL_2) {
-		timeout = MMC_BKOPS_MAX_TIMEOUT;
-		use_busy_signal = true;
-	} else {
-		timeout = 0;
-		use_busy_signal = false;
+	/*
+	 * If the need BKOPS flag is set, there is no need to check if BKOPS
+	 * is needed since we already know that it does
+	 */
+	if (!mmc_card_need_bkops(card)) {
+		err = mmc_read_bkops_status(card);
+		if (err) {
+			pr_err("%s: %s: Failed to read bkops status: %d\n",
+			       mmc_hostname(card->host), __func__, err);
+			goto out;
+		}
+
+		if (!card->ext_csd.raw_bkops_status)
+			goto out;
+
+		pr_info("%s: %s: raw_bkops_status=0x%x, from_exception=%d\n",
+			mmc_hostname(card->host), __func__,
+			card->ext_csd.raw_bkops_status,
+			from_exception);
+	}
+
+	/*
+	 * If the function was called due to exception, BKOPS will be performed
+	 * after handling the last pending request
+	 */
+	if (from_exception) {
+		pr_debug("%s: %s: Level %d from exception, exit",
+			 mmc_hostname(card->host), __func__,
+			 card->ext_csd.raw_bkops_status);
+		mmc_card_set_need_bkops(card);
+		goto out;
 	}
+	pr_info("%s: %s: Starting bkops\n", mmc_hostname(card->host), __func__);
 
 	err = __mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
-			EXT_CSD_BKOPS_START, 1, timeout, use_busy_signal);
+			EXT_CSD_BKOPS_START, 1, 0, false);
 	if (err) {
 		pr_warn("%s: Error %d starting bkops\n",
 			mmc_hostname(card->host), err);
 		goto out;
 	}
+	mmc_card_clr_need_bkops(card);
+	mmc_card_set_doing_bkops(card);
+	card->bkops_info.sectors_changed = 0;
 
-	/*
-	 * For urgent bkops status (LEVEL_2 and more)
-	 * bkops executed synchronously, otherwise
-	 * the operation is in progress
-	 */
-	if (!use_busy_signal)
-		mmc_card_set_doing_bkops(card);
 out:
 	mmc_release_host(card->host);
 }
 EXPORT_SYMBOL(mmc_start_bkops);
 
+/**
+ * mmc_start_idle_time_bkops() - check if a non urgent BKOPS is
+ * needed
+ * @work:	The idle time BKOPS work
+ */
+void mmc_start_idle_time_bkops(struct work_struct *work)
+{
+	struct mmc_card *card = container_of(work, struct mmc_card,
+			bkops_info.dw.work);
+
+	/*
+	 * Prevent a race condition between mmc_stop_bkops and the delayed
+	 * BKOPS work in case the delayed work is executed on another CPU
+	 */
+	if (card->bkops_info.cancel_delayed_work)
+		return;
+
+	mmc_start_bkops(card, false);
+}
+EXPORT_SYMBOL(mmc_start_idle_time_bkops);
+
 static void mmc_wait_done(struct mmc_request *mrq)
 {
 	complete(&mrq->completion);
@@ -578,13 +651,26 @@ EXPORT_SYMBOL(mmc_wait_for_cmd);
  *	Send HPI command to stop ongoing background operations to
  *	allow rapid servicing of foreground operations, e.g. read/
  *	writes. Wait until the card comes out of the programming state
- *	to avoid errors in servicing read/write requests.
+ *      to avoid errors in servicing read/write requests.
+ *
+ *      The function should be called with host claimed.
  */
 int mmc_stop_bkops(struct mmc_card *card)
 {
 	int err = 0;
 
 	BUG_ON(!card);
+
+	/*
+	 * Notify the delayed work to be cancelled, in case it was already
+	 * removed from the queue, but was not started yet
+	 */
+	card->bkops_info.cancel_delayed_work = true;
+	if (delayed_work_pending(&card->bkops_info.dw))
+		cancel_delayed_work_sync(&card->bkops_info.dw);
+	if (!mmc_card_doing_bkops(card))
+		goto out;
+
 	err = mmc_interrupt_hpi(card);
 
 	/*
@@ -596,6 +682,7 @@ int mmc_stop_bkops(struct mmc_card *card)
 		err = 0;
 	}
 
+out:
 	return err;
 }
 EXPORT_SYMBOL(mmc_stop_bkops);
@@ -2536,15 +2623,15 @@ int mmc_pm_notify(struct notifier_block *notify_block,
 	switch (mode) {
 	case PM_HIBERNATION_PREPARE:
 	case PM_SUSPEND_PREPARE:
-		if (host->card && mmc_card_mmc(host->card) &&
-		    mmc_card_doing_bkops(host->card)) {
+		if (host->card && mmc_card_mmc(host->card)) {
+			mmc_claim_host(host);
 			err = mmc_stop_bkops(host->card);
+			mmc_release_host(host);
 			if (err) {
 				pr_err("%s: didn't stop bkops\n",
 					mmc_hostname(host));
 				return err;
 			}
-			mmc_card_clr_doing_bkops(host->card);
 		}
 
 		spin_lock_irqsave(&host->lock, flags);
diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index e6e3911..2f25488 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -1546,6 +1546,23 @@ int mmc_attach_mmc(struct mmc_host *host)
 	if (err)
 		goto err;
 
+	if (host->card->ext_csd.bkops_en) {
+		INIT_DELAYED_WORK(&host->card->bkops_info.dw,
+				  mmc_start_idle_time_bkops);
+
+		/*
+		 * The host controller can set the time to start the BKOPS in
+		 * order to prevent a race condition before starting BKOPS
+		 * and going into suspend.
+		 * If the host controller didn't set this time,
+		 * a default value is used.
+		 */
+		host->card->bkops_info.delay_ms = MMC_IDLE_BKOPS_TIME_MS;
+		if (host->card->bkops_info.host_delay_ms)
+			host->card->bkops_info.delay_ms =
+				host->card->bkops_info.host_delay_ms;
+	}
+
 	mmc_release_host(host);
 	err = mmc_add_card(host->card);
 	mmc_claim_host(host);
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index 5c69315..1676506 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -210,6 +210,46 @@ struct mmc_part {
 #define MMC_BLK_DATA_AREA_RPMB	(1<<3)
 };
 
+/**
+ * struct mmc_bkops_info - BKOPS data
+ * @dw:	Idle time bkops delayed work
+ * @host_delay_ms:	The host controller time to start bkops
+ * @delay_ms:	The time to start the BKOPS
+ *        delayed work once MMC thread is idle
+ * @min_sectors_to_queue_delayed_work: the changed
+ *        number of sectors that should issue check for BKOPS
+ *        need
+ * @size_percentage_to_queue_delayed_work: the changed
+ *        percentage of sectors that should issue check for
+ *        BKOPS need
+ * @cancel_delayed_work: A flag to indicate if the delayed work
+ *        should be cancelled
+ * @sectors_changed:  number of  sectors written or
+ *       discard since the last idle BKOPS were scheduled
+ */
+struct mmc_bkops_info {
+	struct delayed_work	dw;
+	unsigned int		host_delay_ms;
+	unsigned int		delay_ms;
+	unsigned int		min_sectors_to_queue_delayed_work;
+	unsigned int		size_percentage_to_queue_delayed_work;
+/*
+ * A default time for checking the need for non urgent BKOPS once mmcqd
+ * is idle.
+ */
+#define MMC_IDLE_BKOPS_TIME_MS 200
+	bool			cancel_delayed_work;
+	unsigned int		sectors_changed;
+/*
+ * Since canceling the delayed work might have significant effect on the
+ * performance of small requests we won't queue the delayed work every time
+ * mmcqd thread is idle.
+ * The delayed work for idle BKOPS will be scheduled only after a significant
+ * amount of write or discard data.
+ */
+#define BKOPS_SIZE_PERCENTAGE_TO_QUEUE_DELAYED_WORK 1 /* 1% */
+};
+
 /*
  * MMC device
  */
@@ -233,6 +273,7 @@ struct mmc_card {
 #define MMC_CARD_REMOVED	(1<<7)		/* card has been removed */
 #define MMC_STATE_HIGHSPEED_200	(1<<8)		/* card is in HS200 mode */
 #define MMC_STATE_DOING_BKOPS	(1<<10)		/* card is doing BKOPS */
+#define MMC_STATE_NEED_BKOPS	(1<<11)		/* card needs to do BKOPS */
 	unsigned int		quirks; 	/* card quirks */
 #define MMC_QUIRK_LENIENT_FN0	(1<<0)		/* allow SDIO FN0 writes outside of the VS CCCR range */
 #define MMC_QUIRK_BLKSZ_FOR_BYTE_MODE (1<<1)	/* use func->cur_blksize */
@@ -278,6 +319,8 @@ struct mmc_card {
 	struct dentry		*debugfs_root;
 	struct mmc_part	part[MMC_NUM_PHY_PARTITION]; /* physical partitions */
 	unsigned int    nr_parts;
+
+	struct mmc_bkops_info	bkops_info;
 };
 
 /*
@@ -395,6 +438,7 @@ static inline void __maybe_unused remove_quirk(struct mmc_card *card, int data)
 #define mmc_card_ext_capacity(c) ((c)->state & MMC_CARD_SDXC)
 #define mmc_card_removed(c)	((c) && ((c)->state & MMC_CARD_REMOVED))
 #define mmc_card_doing_bkops(c)	((c)->state & MMC_STATE_DOING_BKOPS)
+#define mmc_card_need_bkops(c)	((c)->state & MMC_STATE_NEED_BKOPS)
 
 #define mmc_card_set_present(c)	((c)->state |= MMC_STATE_PRESENT)
 #define mmc_card_set_readonly(c) ((c)->state |= MMC_STATE_READONLY)
@@ -408,7 +452,8 @@ static inline void __maybe_unused remove_quirk(struct mmc_card *card, int data)
 #define mmc_card_set_removed(c) ((c)->state |= MMC_CARD_REMOVED)
 #define mmc_card_set_doing_bkops(c)	((c)->state |= MMC_STATE_DOING_BKOPS)
 #define mmc_card_clr_doing_bkops(c)	((c)->state &= ~MMC_STATE_DOING_BKOPS)
-
+#define mmc_card_set_need_bkops(c)	((c)->state |= MMC_STATE_NEED_BKOPS)
+#define mmc_card_clr_need_bkops(c)	((c)->state &= ~MMC_STATE_NEED_BKOPS)
 /*
  * Quirk add/remove for MMC products.
  */
diff --git a/include/linux/mmc/core.h b/include/linux/mmc/core.h
index 5bf7c22..c6426c6 100644
--- a/include/linux/mmc/core.h
+++ b/include/linux/mmc/core.h
@@ -145,6 +145,8 @@ extern int mmc_app_cmd(struct mmc_host *, struct mmc_card *);
 extern int mmc_wait_for_app_cmd(struct mmc_host *, struct mmc_card *,
 	struct mmc_command *, int);
 extern void mmc_start_bkops(struct mmc_card *card, bool from_exception);
+extern void mmc_start_delayed_bkops(struct mmc_card *card);
+extern void mmc_start_idle_time_bkops(struct work_struct *work);
 extern int __mmc_switch(struct mmc_card *, u8, u8, u8, unsigned int, bool);
 extern int mmc_switch(struct mmc_card *, u8, u8, u8, unsigned int);
 
-- 
1.7.3.3
-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
