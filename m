Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966104Ab3DQLjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 07:39:13 -0400
Received: from 212.199.104.198.static.012.net.il ([212.199.104.198]:26224 "EHLO
	lx-merez.qi.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965956Ab3DQLjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 07:39:11 -0400
From: Maya Erez <merez@codeaurora.org>
To: linux-mmc@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Maya Erez <merez@codeaurora.org>,
        Yaniv Gardi <ygardi@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] mmc: card: Adding support for sanitize in eMMC 4.5
Date: Wed, 17 Apr 2013 14:38:47 +0300
Message-Id: <1366198740-9651-1-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <n>
References: <n>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sanitize support is added as a user-app ioctl call, and
was removed from the block-device request, since its purpose is
to be invoked not via File-System but by a user.
This feature deletes the unmap memory region of the eMMC card,
by writing to a specific register in the EXT_CSD.
unmap region is the memory region that was previously deleted
(by erase, trim or discard operation).
In order to avoid timeout when sanitizing large-scale cards,
the timeout for sanitize operation is 240 seconds.

Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/mmc/card/block.c |   68 +++++++++++++++++++++++++++++++--------------
 drivers/mmc/card/queue.c |    2 +-
 drivers/mmc/core/core.c  |   21 ++++++++++++++
 include/linux/mmc/core.h |    2 +
 include/linux/mmc/host.h |    1 +
 5 files changed, 72 insertions(+), 22 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index e12a03c..1f043ee 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -58,6 +58,8 @@ MODULE_ALIAS("mmc:block");
 #define INAND_CMD38_ARG_SECTRIM1 0x81
 #define INAND_CMD38_ARG_SECTRIM2 0x88
 #define MMC_BLK_TIMEOUT_MS  (10 * 60 * 1000)        /* 10 minute timeout */
+#define MMC_SANITIZE_REQ_TIMEOUT 240000
+#define MMC_EXTRACT_INDEX_FROM_ARG(x) ((x & 0x00FF0000) >> 16)
 
 #define mmc_req_rel_wr(req)	(((req->cmd_flags & REQ_FUA) || \
 				  (req->cmd_flags & REQ_META)) && \
@@ -409,6 +411,35 @@ static int ioctl_rpmb_card_status_poll(struct mmc_card *card, u32 *status,
 	return err;
 }
 
+static int ioctl_do_sanitize(struct mmc_card *card)
+{
+	int err;
+
+	if (!(mmc_can_sanitize(card) &&
+	      (card->host->caps2 & MMC_CAP2_SANITIZE))) {
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
+					EXT_CSD_SANITIZE_START, 1,
+					MMC_SANITIZE_REQ_TIMEOUT);
+
+	if (err)
+		pr_err("%s: %s - EXT_CSD_SANITIZE_START failed. err=%d\n",
+		       mmc_hostname(card->host), __func__, err);
+
+	pr_debug("%s: %s - SANITIZE COMPLETED\n", mmc_hostname(card->host),
+					     __func__);
+out:
+	return err;
+}
+
 static int mmc_blk_ioctl_cmd(struct block_device *bdev,
 	struct mmc_ioc_cmd __user *ic_ptr)
 {
@@ -511,6 +542,16 @@ static int mmc_blk_ioctl_cmd(struct block_device *bdev,
 			goto cmd_rel_host;
 	}
 
+	if (MMC_EXTRACT_INDEX_FROM_ARG(cmd.arg) == EXT_CSD_SANITIZE_START) {
+		err = ioctl_do_sanitize(card);
+
+		if (err)
+			pr_err("%s: ioctl_do_sanitize() failed. err = %d",
+			       __func__, err);
+
+		goto cmd_rel_host;
+	}
+
 	mmc_wait_for_req(card->host, &mrq);
 
 	if (cmd.error) {
@@ -940,10 +981,10 @@ static int mmc_blk_issue_secdiscard_rq(struct mmc_queue *mq,
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
@@ -951,23 +992,11 @@ static int mmc_blk_issue_secdiscard_rq(struct mmc_queue *mq,
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
@@ -1003,9 +1032,6 @@ retry:
 			goto out;
 	}
 
-	if (mmc_can_sanitize(card))
-		err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
-				 EXT_CSD_SANITIZE_START, 1, 0);
 out_retry:
 	if (err && !mmc_blk_reset(md, card->host, type))
 		goto retry;
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index 9447a0e..fa9632e 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -173,7 +173,7 @@ static void mmc_queue_setup_discard(struct request_queue *q,
 	/* granularity must not be greater than max. discard */
 	if (card->pref_erase > max_discard)
 		q->limits.discard_granularity = 0;
-	if (mmc_can_secure_erase_trim(card) || mmc_can_sanitize(card))
+	if (mmc_can_secure_erase_trim(card))
 		queue_flag_set_unlocked(QUEUE_FLAG_SECDISCARD, q);
 }
 
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 37c5dad..dea9381 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -402,6 +402,27 @@ static int mmc_wait_for_data_req_done(struct mmc_host *host,
 			context_info->is_done_rcv = false;
 			context_info->is_new_req = false;
 			cmd = mrq->cmd;
+
+			/*
+			 * If host has timed out waiting for the sanitize
+			 * to complete, card might be still in programming state
+			 * so let's try to bring the card out of programming
+			 * state.
+			 */
+			if (cmd->sanitize_busy && cmd->error == -ETIMEDOUT) {
+				if (!mmc_interrupt_hpi(host->card)) {
+					pr_warning("%s: %s: Interrupted "
+						   "sanitize\n",
+						   mmc_hostname(host),
+						   __func__);
+					cmd->error = 0;
+					break;
+				} else {
+					pr_err("%s: %s: Failed to interrupt "
+					       "sanitize\n",
+					       mmc_hostname(host), __func__);
+				}
+			}
 			if (!cmd->error || !cmd->retries ||
 			    mmc_card_removed(host->card)) {
 				err = host->areq->err_check(host->card,
diff --git a/include/linux/mmc/core.h b/include/linux/mmc/core.h
index 39613b9..bd06ff5 100644
--- a/include/linux/mmc/core.h
+++ b/include/linux/mmc/core.h
@@ -96,6 +96,8 @@ struct mmc_command {
  */
 
 	unsigned int		cmd_timeout_ms;	/* in milliseconds */
+	/* Set this flag only for blocking sanitize request */
+	bool			sanitize_busy;
 
 	struct mmc_data		*data;		/* data segment associated with cmd */
 	struct mmc_request	*mrq;		/* associated request */
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index e326ae2..00c10be 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -281,6 +281,7 @@ struct mmc_host {
 #define MMC_CAP2_PACKED_CMD	(MMC_CAP2_PACKED_RD | \
 				 MMC_CAP2_PACKED_WR)
 #define MMC_CAP2_NO_PRESCAN_POWERUP (1 << 14)	/* Don't power up before scan */
+#define MMC_CAP2_SANITIZE	(1 << 15)		/* Support Sanitize */
 
 	mmc_pm_flag_t		pm_caps;	/* supported pm features */
 
-- 
1.7.3.3
-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation

