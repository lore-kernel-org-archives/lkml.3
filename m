Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab3GIMrr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 08:47:47 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:18234 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752690Ab3GIMrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 08:47:45 -0400
From: Oskar Andero <oskar.andero@sonymobile.com>
To: <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>
CC: Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>,
        Ulf Hansson <ulf.hansson@stericsson.com>,
        Lars Svensson <lars1.svensson@sonymobile.com>,
        Oskar Andero <oskar.andero@sonymobile.com>
Subject: [PATCH] MMC: Detect execution mode errors after r/w command
Date: Tue, 9 Jul 2013 14:47:31 +0200
Message-ID: <1373374051-28438-1-git-send-email-oskar.andero@sonymobile.com>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Svensson <lars1.svensson@sonymobile.com>

Some error bits in the status field of R1/R1b response are only set
by the device in response to the command following the failing
command. The status is only read and checked after a r/w command if
an error is detected during the initial command or the following data
transfer. In some situations this causes errors passing undetected.

The solution is to read the status and check for these errors after
each r/w operation.

Signed-off-by: Lars Svensson <lars1.svensson@sonymobile.com>
Signed-off-by: Oskar Andero <oskar.andero@sonymobile.com>
Cc: linux-mmc@vger.kernel.org
---
 drivers/mmc/card/block.c | 105 +++++++++++++++++++++++++----------------------
 1 file changed, 57 insertions(+), 48 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index dd27b07..b2664d7 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -754,10 +754,9 @@ static int mmc_blk_cmd_error(struct request *req, const char *name, int error,
  * Initial r/w and stop cmd error recovery.
  * We don't know whether the card received the r/w cmd or not, so try to
  * restore things back to a sane state.  Essentially, we do this as follows:
- * - Obtain card status.  If the first attempt to obtain card status fails,
- *   the status word will reflect the failed status cmd, not the failed
- *   r/w cmd.  If we fail to obtain card status, it suggests we can no
- *   longer communicate with the card.
+ * - Check card status. If the status_valid argument is false, the first attempt
+ *   to obtain card status failed and the status argument will not reflect the
+ *   failed r/w cmd.
  * - Check the card state.  If the card received the cmd but there was a
  *   transient problem with the response, it might still be in a data transfer
  *   mode.  Try to send it a stop command.  If this fails, we can't recover.
@@ -769,38 +768,15 @@ static int mmc_blk_cmd_error(struct request *req, const char *name, int error,
  * Otherwise we don't understand what happened, so abort.
  */
 static int mmc_blk_cmd_recovery(struct mmc_card *card, struct request *req,
-	struct mmc_blk_request *brq, int *ecc_err)
+	struct mmc_blk_request *brq, int *ecc_err, u32 status,
+	bool status_valid)
 {
-	bool prev_cmd_status_valid = true;
-	u32 status, stop_status = 0;
-	int err, retry;
+	u32 stop_status = 0;
+	int err;
 
 	if (mmc_card_removed(card))
 		return ERR_NOMEDIUM;
 
-	/*
-	 * Try to get card status which indicates both the card state
-	 * and why there was no response.  If the first attempt fails,
-	 * we can't be sure the returned status is for the r/w command.
-	 */
-	for (retry = 2; retry >= 0; retry--) {
-		err = get_card_status(card, &status, 0);
-		if (!err)
-			break;
-
-		prev_cmd_status_valid = false;
-		pr_err("%s: error %d sending status command, %sing\n",
-		       req->rq_disk->disk_name, err, retry ? "retry" : "abort");
-	}
-
-	/* We couldn't get a response from the card.  Give up. */
-	if (err) {
-		/* Check if the card is removed */
-		if (mmc_detect_card_removed(card->host))
-			return ERR_NOMEDIUM;
-		return ERR_ABORT;
-	}
-
 	/* Flag ECC errors */
 	if ((status & R1_CARD_ECC_FAILED) ||
 	    (brq->stop.resp[0] & R1_CARD_ECC_FAILED) ||
@@ -831,12 +807,12 @@ static int mmc_blk_cmd_recovery(struct mmc_card *card, struct request *req,
 	/* Check for set block count errors */
 	if (brq->sbc.error)
 		return mmc_blk_cmd_error(req, "SET_BLOCK_COUNT", brq->sbc.error,
-				prev_cmd_status_valid, status);
+				status_valid, status);
 
 	/* Check for r/w command errors */
 	if (brq->cmd.error)
 		return mmc_blk_cmd_error(req, "r/w cmd", brq->cmd.error,
-				prev_cmd_status_valid, status);
+				status_valid, status);
 
 	/* Data errors */
 	if (!brq->stop.error)
@@ -1062,6 +1038,12 @@ static inline void mmc_apply_rel_rw(struct mmc_blk_request *brq,
 	 R1_CC_ERROR |		/* Card controller error */		\
 	 R1_ERROR)		/* General/unknown error */
 
+#define EXE_ERRORS							\
+	(R1_OUT_OF_RANGE |	/* Command argument out of range */	\
+	 R1_ADDRESS_ERROR |	/* Misaligned address */		\
+	 R1_WP_VIOLATION |	/* Tried to write to protected block */	\
+	 R1_ERROR)		/* General/unknown error */
+
 static int mmc_blk_err_check(struct mmc_card *card,
 			     struct mmc_async_req *areq)
 {
@@ -1069,7 +1051,33 @@ static int mmc_blk_err_check(struct mmc_card *card,
 						    mmc_active);
 	struct mmc_blk_request *brq = &mq_mrq->brq;
 	struct request *req = mq_mrq->req;
-	int ecc_err = 0;
+	int retries, err, ecc_err = 0;
+	u32 status = 0;
+	bool status_valid = true;
+
+	/*
+	 * Try to get card status which indicates the card state after
+	 * command execution. If the first attempt fails, we can't be
+	 * sure the returned status is for the r/w command.
+	 */
+	for (retries = 2; retries >= 0; retries--) {
+		err = get_card_status(card, &status, 0);
+		if (!err)
+			break;
+
+		status_valid = false;
+		pr_err("%s: error %d sending status command, %sing\n",
+		       req->rq_disk->disk_name, err,
+		       retries ? "retry" : "abort");
+	}
+
+	/* We couldn't get a response from the card.  Give up. */
+	if (err) {
+		/* Check if the card is removed */
+		if (mmc_detect_card_removed(card->host))
+			return MMC_BLK_NOMEDIUM;
+		return MMC_BLK_ABORT;
+	}
 
 	/*
 	 * sbc.error indicates a problem with the set block count
@@ -1083,7 +1091,8 @@ static int mmc_blk_err_check(struct mmc_card *card,
 	 */
 	if (brq->sbc.error || brq->cmd.error || brq->stop.error ||
 	    brq->data.error) {
-		switch (mmc_blk_cmd_recovery(card, req, brq, &ecc_err)) {
+		switch (mmc_blk_cmd_recovery(card, req, brq, &ecc_err, status,
+		    status_valid)) {
 		case ERR_RETRY:
 			return MMC_BLK_RETRY;
 		case ERR_ABORT:
@@ -1098,11 +1107,12 @@ static int mmc_blk_err_check(struct mmc_card *card,
 	/*
 	 * Check for errors relating to the execution of the
 	 * initial command - such as address errors.  No data
-	 * has been transferred.
+	 * has been transferred. Also check for errors during
+	 * command execution. In this case execution was aborted.
 	 */
-	if (brq->cmd.resp[0] & CMD_ERRORS) {
-		pr_err("%s: r/w command failed, status = %#x\n",
-		       req->rq_disk->disk_name, brq->cmd.resp[0]);
+	if (brq->cmd.resp[0] & CMD_ERRORS || status & EXE_ERRORS) {
+		pr_err("%s: r/w command failed, cmd status = %#x, status = %#x\n",
+		       req->rq_disk->disk_name, brq->cmd.resp[0], status);
 		return MMC_BLK_ABORT;
 	}
 
@@ -1112,11 +1122,16 @@ static int mmc_blk_err_check(struct mmc_card *card,
 	 * program mode, which we have to wait for it to complete.
 	 */
 	if (!mmc_host_is_spi(card->host) && rq_data_dir(req) != READ) {
-		u32 status;
 		unsigned long timeout;
 
 		timeout = jiffies + msecs_to_jiffies(MMC_BLK_TIMEOUT_MS);
-		do {
+		/*
+		 * Some cards mishandle the status bits,
+		 * so make sure to check both the busy
+		 * indication and the card state.
+		 */
+		while (!(status & R1_READY_FOR_DATA) ||
+				(R1_CURRENT_STATE(status) == R1_STATE_PRG)) {
 			int err = get_card_status(card, &status, 5);
 			if (err) {
 				pr_err("%s: error %d requesting status\n",
@@ -1134,13 +1149,7 @@ static int mmc_blk_err_check(struct mmc_card *card,
 
 				return MMC_BLK_CMD_ERR;
 			}
-			/*
-			 * Some cards mishandle the status bits,
-			 * so make sure to check both the busy
-			 * indication and the card state.
-			 */
-		} while (!(status & R1_READY_FOR_DATA) ||
-			 (R1_CURRENT_STATE(status) == R1_STATE_PRG));
+		}
 	}
 
 	if (brq->data.error) {
-- 
1.8.1.5

