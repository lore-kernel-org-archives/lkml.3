Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667Ab3BSQXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 11:23:32 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:20163 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758401Ab3BSQXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 11:23:30 -0500
X-IronPort-AV: E=Sophos;i="4.84,696,1355126400"; 
   d="scan'208";a="25801052"
From: Yaniv Gardi <ygardi@codeaurora.org>
To: linux-mmc@vger.kernel.org, vgoyal@redhat.com, tj@kernel.org,
        linux-kernel@vger.kernel.org, jaxboe@fusionio.com,
        akpm@linux-foundation.org
Cc: linux-arm-msm@vger.kernel.org, Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v9 2/2] mmc: card: Adding support for sanitize in eMMC 4.5
Date: Tue, 19 Feb 2013 18:22:17 +0200
Message-Id: <1361290937-7427-3-git-send-email-ygardi@codeaurora.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1361290937-7427-1-git-send-email-ygardi@codeaurora.org>
References: <1361290937-7427-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This feature deletes the unmap memory region of the eMMC card,
by writing to a specific register in the EXT_CSD.
unmap region is the memory region that was previously deleted
(by erase, trim or discard operation).
In order to avoid timeout when sanitizing large-scale cards,
the timeout for sanitize operation is 240 seconds.

Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/mmc/card/block.c |   75 ++++++++++++++++++++++++++++++++-------------
 drivers/mmc/card/queue.c |   10 +++++-
 include/linux/mmc/host.h |    1 +
 3 files changed, 63 insertions(+), 23 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 21056b9..f532489 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -58,6 +58,7 @@ MODULE_ALIAS("mmc:block");
 #define INAND_CMD38_ARG_SECTRIM1 0x81
 #define INAND_CMD38_ARG_SECTRIM2 0x88
 #define MMC_BLK_TIMEOUT_MS  (10 * 60 * 1000)        /* 10 minute timeout */
+#define MMC_SANITIZE_REQ_TIMEOUT 240000
 
 static DEFINE_MUTEX(block_mutex);
 
@@ -925,10 +926,10 @@ static int mmc_blk_issue_secdiscard_rq(struct mmc_queue *mq,
 {
 	struct mmc_blk_data *md = mq->data;
 	struct mmc_card *card = md->queue.card;
-	unsigned int from, nr, arg, trim_arg, erase_arg;
+	unsigned int from, nr, arg;
 	int err = 0, type = MMC_BLK_SECDISCARD;
 
-	if (!(mmc_can_secure_erase_trim(card) || mmc_can_sanitize(card))) {
+	if (!(mmc_can_secure_erase_trim(card))) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
@@ -936,23 +937,11 @@ static int mmc_blk_issue_secdiscard_rq(struct mmc_queue *mq,
 	from = blk_rq_pos(req);
 	nr = blk_rq_sectors(req);
 
-	/* The sanitize operation is supported at v4.5 only */
-	if (mmc_can_sanitize(card)) {
-		erase_arg = MMC_ERASE_ARG;
-		trim_arg = MMC_TRIM_ARG;
-	} else {
-		erase_arg = MMC_SECURE_ERASE_ARG;
-		trim_arg = MMC_SECURE_TRIM1_ARG;
-	}
+	if (mmc_can_trim(card) && !mmc_erase_group_aligned(card, from, nr))
+		arg = MMC_SECURE_TRIM1_ARG;
+	else
+		arg = MMC_SECURE_ERASE_ARG;
 
-	if (mmc_erase_group_aligned(card, from, nr))
-		arg = erase_arg;
-	else if (mmc_can_trim(card))
-		arg = trim_arg;
-	else {
-		err = -EINVAL;
-		goto out;
-	}
 retry:
 	if (card->quirks & MMC_QUIRK_INAND_CMD38) {
 		err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
@@ -988,9 +977,6 @@ retry:
 			goto out;
 	}
 
-	if (mmc_can_sanitize(card))
-		err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
-				 EXT_CSD_SANITIZE_START, 1, 0);
 out_retry:
 	if (err && !mmc_blk_reset(md, card->host, type))
 		goto retry;
@@ -1002,6 +988,46 @@ out:
 	return err ? 0 : 1;
 }
 
+static int mmc_blk_issue_sanitize_rq(struct mmc_queue *mq,
+				      struct request *req)
+{
+	struct mmc_blk_data *md = mq->data;
+	struct mmc_card *card = md->queue.card;
+	int err = 0;
+
+	BUG_ON(!card);
+	BUG_ON(!card->host);
+
+	if (!(mmc_can_sanitize(card) &&
+	     (card->host->caps2 & MMC_CAP2_SANITIZE))) {
+			pr_warn("%s: %s - SANITIZE is not supported\n",
+				mmc_hostname(card->host), __func__);
+			err = -EOPNOTSUPP;
+			goto out;
+	}
+
+	pr_debug("%s: %s - SANITIZE IN PROGRESS...\n",
+		mmc_hostname(card->host), __func__);
+
+	err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
+			 EXT_CSD_SANITIZE_START, 1, MMC_SANITIZE_REQ_TIMEOUT);
+
+	if (err)
+		pr_err("%s: %s - mmc_switch() with SANITIZE failed. err=%d\n",
+		       mmc_hostname(card->host), __func__, err);
+
+	pr_debug("%s: %s - SANITIZE COMPLETED\n", mmc_hostname(card->host),
+					     __func__);
+
+out:
+	spin_lock_irq(&md->lock);
+	__blk_end_request(req, err, blk_rq_bytes(req));
+	spin_unlock_irq(&md->lock);
+
+	return err ? 0 : 1;
+}
+
+
 static int mmc_blk_issue_flush(struct mmc_queue *mq, struct request *req)
 {
 	struct mmc_blk_data *md = mq->data;
@@ -1486,7 +1512,12 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 		goto out;
 	}
 
-	if (req && req->cmd_flags & REQ_DISCARD) {
+	if (req && req->cmd_flags & REQ_SANITIZE) {
+		/* complete ongoing async transfer before issuing sanitize */
+		if (card->host && card->host->areq)
+			mmc_blk_issue_rw_rq(mq, NULL);
+		ret = mmc_blk_issue_sanitize_rq(mq, req);
+	} else if (req && req->cmd_flags & REQ_DISCARD) {
 		/* complete ongoing async transfer before issuing discard */
 		if (card->host->areq)
 			mmc_blk_issue_rw_rq(mq, NULL);
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index fadf52e..32c5bf1 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -148,10 +148,15 @@ static void mmc_queue_setup_discard(struct request_queue *q,
 	/* granularity must not be greater than max. discard */
 	if (card->pref_erase > max_discard)
 		q->limits.discard_granularity = 0;
-	if (mmc_can_secure_erase_trim(card) || mmc_can_sanitize(card))
+	if (mmc_can_secure_erase_trim(card))
 		queue_flag_set_unlocked(QUEUE_FLAG_SECDISCARD, q);
 }
 
+static void mmc_queue_setup_sanitize(struct request_queue *q)
+{
+	queue_flag_set_unlocked(QUEUE_FLAG_SANITIZE, q);
+}
+
 /**
  * mmc_init_queue - initialise a queue structure.
  * @mq: mmc queue
@@ -187,6 +192,9 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card,
 	if (mmc_can_erase(card))
 		mmc_queue_setup_discard(mq->queue, card);
 
+	if ((mmc_can_sanitize(card) && (host->caps2 & MMC_CAP2_SANITIZE)))
+		mmc_queue_setup_sanitize(mq->queue);
+
 #ifdef CONFIG_MMC_BLOCK_BOUNCE
 	if (host->max_segs == 1) {
 		unsigned int bouncesz;
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 61a10c1..045e9f7 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -258,6 +258,7 @@ struct mmc_host {
 #define MMC_CAP2_HC_ERASE_SZ	(1 << 9)	/* High-capacity erase size */
 #define MMC_CAP2_CD_ACTIVE_HIGH	(1 << 10)	/* Card-detect signal active high */
 #define MMC_CAP2_RO_ACTIVE_HIGH	(1 << 11)	/* Write-protect signal active high */
+#define MMC_CAP2_SANITIZE	(1 << 12)		/* Support Sanitize */
 
 	mmc_pm_flag_t		pm_caps;	/* supported pm features */
 
-- 
1.7.6
-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum
