Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab3DNK40 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 06:56:26 -0400
Received: from 212.199.104.198.static.012.net.il ([212.199.104.198]:12094 "EHLO
	lx-merez.qi.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751870Ab3DNK4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 06:56:23 -0400
X-Greylist: delayed 328 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Apr 2013 06:56:22 EDT
From: Maya Erez <merez@codeaurora.org>
To: linux-mmc@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Maya Erez <merez@codeaurora.org>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v6] mmc: core: Add support for idle time BKOPS
Date: Sun, 14 Apr 2013 13:50:24 +0300
Message-Id: <1365936642-6939-1-git-send-email-merez@codeaurora.org>
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
operations the host will check the need for BKOPS when it is idle
(in runtime suspend), and in case of an incoming request the BKOPS
operation will be interrupted.

If the card raised an exception with need for urgent BKOPS (level 2/3)
a flag will be set to indicate MMC to start the BKOPS activity when it
becomes idle.

Since running the BKOPS too often can impact the eMMC endurance, the card
need for BKOPS is not checked on every runtime suspend. In order to estimate
when is the best time to check for BKOPS need the host will take into
account the card capacity and percentages of changed sectors in the card.
A future enhancement can be to check the card need for BKOPS only in case
of random activity.

Signed-off-by: Maya Erez <merez@codeaurora.org>
---
This patch depends on the following patches:
[PATCH V2 1/2] mmc: core: Add bus_ops fro runtime pm callbacks
[PATCH V2 2/2] mmc: block: Enable runtime pm for mmc blkdevice
---
diff --git a/Documentation/mmc/mmc-dev-attrs.txt b/Documentation/mmc/mmc-dev-attrs.txt
index 189bab0..8257aa6 100644
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
index 536331a..ef42117 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -116,6 +116,7 @@ struct mmc_blk_data {
 	unsigned int	part_curr;
 	struct device_attribute force_ro;
 	struct device_attribute power_ro_lock;
+	struct device_attribute bkops_check_threshold;
 	int	area_type;
 };
 
@@ -287,6 +288,65 @@ out:
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
+		card->bkops_info.size_percentage_to_start_bkops);
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
+	card->bkops_info.size_percentage_to_start_bkops = value;
+	card->bkops_info.min_sectors_to_start_bkops =
+		(card_size * value) / 100;
+
+	pr_debug("%s: size_percentage = %d, min_sectors = %d",
+			mmc_hostname(card->host),
+			card->bkops_info.size_percentage_to_start_bkops,
+			card->bkops_info.min_sectors_to_start_bkops);
+
+exit:
+	mmc_blk_put(md);
+	return count;
+}
+
 static int mmc_blk_open(struct block_device *bdev, fmode_t mode)
 {
 	struct mmc_blk_data *md = mmc_blk_get(bdev->bd_disk);
@@ -914,6 +974,9 @@ static int mmc_blk_issue_discard_rq(struct mmc_queue *mq, struct request *req)
 	from = blk_rq_pos(req);
 	nr = blk_rq_sectors(req);
 
+	if (card->ext_csd.bkops_en)
+		card->bkops_info.sectors_changed += blk_rq_sectors(req);
+
 	if (mmc_can_discard(card))
 		arg = MMC_DISCARD_ARG;
 	else if (mmc_can_trim(card))
@@ -1721,8 +1784,12 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
 	if (!rqc && !mq->mqrq_prev->req)
 		return 0;
 
-	if (rqc)
+	if (rqc) {
+		if ((card->ext_csd.bkops_en) && (rq_data_dir(rqc) == WRITE))
+			card->bkops_info.sectors_changed += blk_rq_sectors(rqc);
+
 		reqs = mmc_blk_prep_packed_list(mq, rqc);
+	}
 
 	do {
 		if (rqc) {
@@ -1905,6 +1972,8 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 		pm_runtime_get_sync(&card->dev);
 		/* claim host only for the first request */
 		mmc_claim_host(card->host);
+		if (card->ext_csd.bkops_en)
+			mmc_stop_bkops(card);
 	}
 
 	ret = mmc_blk_part_switch(card, md);
@@ -1943,6 +2012,8 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 out:
 	if ((!req && !(mq->flags & MMC_QUEUE_NEW_REQUEST)) ||
 	     (req && (req->cmd_flags & MMC_REQ_SPECIAL_MASK))) {
+		if (mmc_card_need_bkops(card))
+			mmc_start_bkops(card, false);
 		/*
 		 * Release host when there are no more requests
 		 * and after special request(discard, flush) is done.
@@ -1972,6 +2043,7 @@ static struct mmc_blk_data *mmc_blk_alloc_req(struct mmc_card *card,
 {
 	struct mmc_blk_data *md;
 	int devidx, ret;
+	unsigned int percentage = SIZE_PERCENTAGE_TO_START_BKOPS;
 
 	devidx = find_first_zero_bit(dev_use, max_devices);
 	if (devidx >= max_devices)
@@ -2055,6 +2127,10 @@ static struct mmc_blk_data *mmc_blk_alloc_req(struct mmc_card *card,
 
 	set_capacity(md->disk, size);
 
+	card->bkops_info.size_percentage_to_start_bkops = percentage;
+	card->bkops_info.min_sectors_to_start_bkops =
+		((unsigned int)size * percentage) / 100;
+
 	if (mmc_host_cmd23(card->host)) {
 		if (mmc_card_mmc(card) ||
 		    (mmc_card_sd(card) &&
@@ -2241,8 +2317,21 @@ static int mmc_add_disk(struct mmc_blk_data *md)
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
index 9447a0e..a9526b8 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -49,6 +49,7 @@ static int mmc_queue_thread(void *d)
 {
 	struct mmc_queue *mq = d;
 	struct request_queue *q = mq->queue;
+	struct mmc_card *card = mq->card;
 
 	current->flags |= PF_MEMALLOC;
 
diff --git a/drivers/mmc/core/bus.c b/drivers/mmc/core/bus.c
index d9e8c2b..a6c2e1d 100644
--- a/drivers/mmc/core/bus.c
+++ b/drivers/mmc/core/bus.c
@@ -129,8 +129,15 @@ static int mmc_bus_suspend(struct device *dev)
 	struct mmc_card *card = mmc_dev_to_card(dev);
 	int ret = 0;
 
+	mmc_claim_host(card->host);
+	ret = mmc_stop_bkops(card);
+	mmc_release_host(card->host);
+	if (ret)
+		goto exit;
+
 	if (dev->driver && drv->suspend)
 		ret = drv->suspend(card);
+exit:
 	return ret;
 }
 
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 7b435a3..976c78b 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -258,67 +258,105 @@ mmc_start_request(struct mmc_host *host, struct mmc_request *mrq)
 /**
  *	mmc_start_bkops - start BKOPS for supported cards
  *	@card: MMC card to start BKOPS
- *	@form_exception: A flag to indicate if this function was
+ *	@from_exception: A flag to indicate if this function was
  *			 called due to an exception raised by the card
  *
  *	Start background operations whenever requested.
  *	When the urgent BKOPS bit is set in a R1 command response
  *	then background operations should be started immediately.
 */
+
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
+	/* In case of idle_time bkops we might be in race with suspend. */
+	if (!mmc_try_claim_host(card->host))
 		return;
+
+	if (mmc_card_doing_bkops(card)) {
+		pr_debug("%s: %s: already doing bkops, exit\n",
+			 mmc_hostname(card->host), __func__);
+		goto out;
 	}
 
-	if (!card->ext_csd.raw_bkops_status)
-		return;
+	if (from_exception && mmc_card_need_bkops(card))
+		goto out;
 
-	if (card->ext_csd.raw_bkops_status < EXT_CSD_BKOPS_LEVEL_2 &&
-	    from_exception)
-		return;
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
 
-	mmc_claim_host(card->host);
-	if (card->ext_csd.raw_bkops_status >= EXT_CSD_BKOPS_LEVEL_2) {
-		timeout = MMC_BKOPS_MAX_TIMEOUT;
-		use_busy_signal = true;
-	} else {
-		timeout = 0;
-		use_busy_signal = false;
+		if (!card->ext_csd.raw_bkops_status)
+			goto out;
+
+		pr_info("%s: %s: raw_bkops_status=0x%x, from_exception=%d\n",
+			mmc_hostname(card->host), __func__,
+			card->ext_csd.raw_bkops_status,
+			from_exception);
 	}
 
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
+	}
+	pr_info("%s: %s: Starting bkops\n", mmc_hostname(card->host), __func__);
+
 	err = __mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
-			EXT_CSD_BKOPS_START, 1, timeout, use_busy_signal);
+			EXT_CSD_BKOPS_START, 1, 0, false);
 	if (err) {
-		pr_warn("%s: Error %d starting bkops\n",
-			mmc_hostname(card->host), err);
+		pr_warn("%s: %s: Error %d when starting bkops\n",
+			mmc_hostname(card->host), __func__, err);
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
+ * mmc_start_idle_time_bkops() - Check the need of non urgent
+ * BKOPS
+ *
+ * @card: MMC card to start BKOPS on
+ */
+void mmc_start_idle_time_bkops(struct mmc_card *card)
+{
+	if (!card || !card->ext_csd.bkops_en || mmc_card_doing_bkops(card))
+		return;
+
+	if (card->bkops_info.sectors_changed <
+	    card->bkops_info.min_sectors_to_start_bkops)
+		return;
+
+	mmc_start_bkops(card, false);
+
+}
+EXPORT_SYMBOL(mmc_start_idle_time_bkops);
+
 /*
  * mmc_wait_data_done() - done callback for data request
  * @mrq: done data request
@@ -676,13 +714,19 @@ EXPORT_SYMBOL(mmc_wait_for_cmd);
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
+	if (!mmc_card_doing_bkops(card))
+		goto out;
+
 	err = mmc_interrupt_hpi(card);
 
 	/*
@@ -694,6 +738,7 @@ int mmc_stop_bkops(struct mmc_card *card)
 		err = 0;
 	}
 
+out:
 	return err;
 }
 EXPORT_SYMBOL(mmc_stop_bkops);
@@ -2631,14 +2676,8 @@ int mmc_suspend_host(struct mmc_host *host)
 
 	mmc_bus_get(host);
 	if (host->bus_ops && !host->bus_dead) {
-		if (host->bus_ops->suspend) {
-			if (mmc_card_doing_bkops(host->card)) {
-				err = mmc_stop_bkops(host->card);
-				if (err)
-					goto out;
-			}
+		if (host->bus_ops->suspend)
 			err = host->bus_ops->suspend(host);
-		}
 
 		if (err == -ENOSYS || !host->bus_ops->resume) {
 			/*
@@ -2725,17 +2764,6 @@ int mmc_pm_notify(struct notifier_block *notify_block,
 	switch (mode) {
 	case PM_HIBERNATION_PREPARE:
 	case PM_SUSPEND_PREPARE:
-		if (host->card && mmc_card_mmc(host->card) &&
-		    mmc_card_doing_bkops(host->card)) {
-			err = mmc_stop_bkops(host->card);
-			if (err) {
-				pr_err("%s: didn't stop bkops\n",
-					mmc_hostname(host));
-				return err;
-			}
-			mmc_card_clr_doing_bkops(host->card);
-		}
-
 		spin_lock_irqsave(&host->lock, flags);
 		host->rescan_disable = 1;
 		spin_unlock_irqrestore(&host->lock, flags);
diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index d584f7c..8e96776 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -1490,6 +1490,24 @@ static int mmc_awake(struct mmc_host *host)
 	return err;
 }
 
+static int mmc_runtime_suspend(struct mmc_host *host)
+{
+	mmc_start_idle_time_bkops(host->card);
+
+	return 0;
+}
+
+static int mmc_runtime_resume(struct mmc_host *host)
+{
+	int err;
+
+	mmc_claim_host(host);
+	err = mmc_stop_bkops(host->card);
+	mmc_release_host(host);
+
+	return err;
+}
+
 static const struct mmc_bus_ops mmc_ops = {
 	.awake = mmc_awake,
 	.sleep = mmc_sleep,
@@ -1497,6 +1515,8 @@ static const struct mmc_bus_ops mmc_ops = {
 	.detect = mmc_detect,
 	.suspend = NULL,
 	.resume = NULL,
+	.runtime_suspend = mmc_runtime_suspend,
+	.runtime_resume = mmc_runtime_resume,
 	.power_restore = mmc_power_restore,
 	.alive = mmc_alive,
 };
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index f31725b..28097fd 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -226,6 +226,30 @@ struct mmc_part {
 #define MMC_BLK_DATA_AREA_RPMB	(1<<3)
 };
 
+/**
+ * struct mmc_bkops_info - BKOPS data
+ * @min_sectors_to_start_bkops: the changed
+ *        number of sectors that should issue check for BKOPS
+ *        need
+ * @size_percentage_to_start_bkops: the changed
+ *        percentage of sectors that should issue check for
+ *        BKOPS need
+ * @sectors_changed:  number of  sectors written or
+ *       discard since the last idle BKOPS were scheduled
+ */
+struct mmc_bkops_info {
+	unsigned int		min_sectors_to_start_bkops;
+	unsigned int		size_percentage_to_start_bkops;
+
+/*
+ * Since canceling the delayed work might have significant effect on the
+ * performance of small requests we won't start bkops on every runtime suspend,
+ * but only after a significant amount of write or discard data.
+ */
+#define SIZE_PERCENTAGE_TO_START_BKOPS 1 /* 1% */
+	unsigned int		sectors_changed;
+};
+
 /*
  * MMC device
  */
@@ -249,6 +273,7 @@ struct mmc_card {
 #define MMC_CARD_REMOVED	(1<<7)		/* card has been removed */
 #define MMC_STATE_HIGHSPEED_200	(1<<8)		/* card is in HS200 mode */
 #define MMC_STATE_DOING_BKOPS	(1<<10)		/* card is doing BKOPS */
+#define MMC_STATE_NEED_BKOPS	(1<<11)		/* card needs to do BKOPS */
 	unsigned int		quirks; 	/* card quirks */
 #define MMC_QUIRK_LENIENT_FN0	(1<<0)		/* allow SDIO FN0 writes outside of the VS CCCR range */
 #define MMC_QUIRK_BLKSZ_FOR_BYTE_MODE (1<<1)	/* use func->cur_blksize */
@@ -294,6 +319,8 @@ struct mmc_card {
 	struct dentry		*debugfs_root;
 	struct mmc_part	part[MMC_NUM_PHY_PARTITION]; /* physical partitions */
 	unsigned int    nr_parts;
+
+	struct mmc_bkops_info	bkops_info;
 };
 
 /*
@@ -416,6 +443,7 @@ static inline void __maybe_unused remove_quirk(struct mmc_card *card, int data)
 #define mmc_card_ext_capacity(c) ((c)->state & MMC_CARD_SDXC)
 #define mmc_card_removed(c)	((c) && ((c)->state & MMC_CARD_REMOVED))
 #define mmc_card_doing_bkops(c)	((c)->state & MMC_STATE_DOING_BKOPS)
+#define mmc_card_need_bkops(c)	((c)->state & MMC_STATE_NEED_BKOPS)
 
 #define mmc_card_set_present(c)	((c)->state |= MMC_STATE_PRESENT)
 #define mmc_card_set_readonly(c) ((c)->state |= MMC_STATE_READONLY)
@@ -429,7 +457,8 @@ static inline void __maybe_unused remove_quirk(struct mmc_card *card, int data)
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
index 39613b9..bfd91c7 100644
--- a/include/linux/mmc/core.h
+++ b/include/linux/mmc/core.h
@@ -149,6 +149,7 @@ extern int mmc_app_cmd(struct mmc_host *, struct mmc_card *);
 extern int mmc_wait_for_app_cmd(struct mmc_host *, struct mmc_card *,
 	struct mmc_command *, int);
 extern void mmc_start_bkops(struct mmc_card *card, bool from_exception);
+extern void mmc_start_idle_time_bkops(struct mmc_card *card);
 extern int __mmc_switch(struct mmc_card *, u8, u8, u8, unsigned int, bool);
 extern int mmc_switch(struct mmc_card *, u8, u8, u8, unsigned int);
 extern int mmc_send_ext_csd(struct mmc_card *card, u8 *ext_csd);
-- 
1.7.6
-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation

