Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507Ab3EJGqF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 02:46:05 -0400
Received: from imx9.toshiba.co.jp ([202.33.96.51]:34941 "EHLO
	imx9.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198Ab3EJGqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 02:46:03 -0400
X-Greylist: delayed 2246 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 May 2013 02:46:03 EDT
Content-Transfer-Encoding: 7bit
From: Yoshitake Kobayashi <yoshitake.kobayashi@toshiba.co.jp>
To: cjb@laptop.org, linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Yoshitake Kobayashi <yoshitake.kobayashi@toshiba.co.jp>
Subject: [PATCH] mmc: block: Fix the error handling of write command response
Date: Fri, 10 May 2013 15:02:07 +0900
Message-Id: <1368165727-32125-1-git-send-email-yoshitake.kobayashi@toshiba.co.jp>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current MMC driver does not recognize the general error (bit19 of device
status) in write command sequence.
So the host might ignore the general error.
This patch adds the code which checks the response of CMD12/CMD13 in write
command sequence and retry the write command sequence if the error is
recognized.

Signed-off-by: Yoshitake Kobayashi <yoshitake.kobayashi@toshiba.co.jp>
---
 drivers/mmc/card/block.c |   26 +++++++++++++++++++++++---
 1 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index e12a03c..44f55d1 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -770,7 +770,7 @@ static int mmc_blk_cmd_error(struct request *req, const char *name, int error,
  * Otherwise we don't understand what happened, so abort.
  */
 static int mmc_blk_cmd_recovery(struct mmc_card *card, struct request *req,
-	struct mmc_blk_request *brq, int *ecc_err)
+	struct mmc_blk_request *brq, int *ecc_err, int *gen_err)
 {
 	bool prev_cmd_status_valid = true;
 	u32 status, stop_status = 0;
@@ -808,6 +808,12 @@ static int mmc_blk_cmd_recovery(struct mmc_card *card, struct request *req,
 	    (brq->cmd.resp[0] & R1_CARD_ECC_FAILED))
 		*ecc_err = 1;
 
+	/* Flag General error */
+	if (!mmc_host_is_spi(card->host) && rq_data_dir(req) != READ)
+		if ((status & R1_ERROR) ||
+		    (brq->stop.resp[0] & R1_ERROR))
+			*gen_err = 1;
+
 	/*
 	 * Check the current card state.  If it is in some data transfer
 	 * mode, tell it to stop (and hopefully transition back to TRAN.)
@@ -827,6 +833,9 @@ static int mmc_blk_cmd_recovery(struct mmc_card *card, struct request *req,
 			return ERR_ABORT;
 		if (stop_status & R1_CARD_ECC_FAILED)
 			*ecc_err = 1;
+		if (!mmc_host_is_spi(card->host) && rq_data_dir(req) != READ)
+			if (stop_status & R1_ERROR)
+				*gen_err = 1;
 	}
 
 	/* Check for set block count errors */
@@ -1070,7 +1079,7 @@ static int mmc_blk_err_check(struct mmc_card *card,
 						    mmc_active);
 	struct mmc_blk_request *brq = &mq_mrq->brq;
 	struct request *req = mq_mrq->req;
-	int ecc_err = 0;
+	int ecc_err = 0, gen_err = 0;
 
 	/*
 	 * sbc.error indicates a problem with the set block count
@@ -1084,7 +1093,7 @@ static int mmc_blk_err_check(struct mmc_card *card,
 	 */
 	if (brq->sbc.error || brq->cmd.error || brq->stop.error ||
 	    brq->data.error) {
-		switch (mmc_blk_cmd_recovery(card, req, brq, &ecc_err)) {
+		switch (mmc_blk_cmd_recovery(card, req, brq, &ecc_err, &gen_err)) {
 		case ERR_RETRY:
 			return MMC_BLK_RETRY;
 		case ERR_ABORT:
@@ -1116,6 +1125,10 @@ static int mmc_blk_err_check(struct mmc_card *card,
 		u32 status;
 		unsigned long timeout;
 
+		/* Check stop command response */
+		if (brq->stop.resp[0] & R1_ERROR)
+			gen_err = 1;
+
 		timeout = jiffies + msecs_to_jiffies(MMC_BLK_TIMEOUT_MS);
 		do {
 			int err = get_card_status(card, &status, 5);
@@ -1125,6 +1138,9 @@ static int mmc_blk_err_check(struct mmc_card *card,
 				return MMC_BLK_CMD_ERR;
 			}
 
+			if (status & R1_ERROR)
+				gen_err = 1;
+
 			/* Timeout if the device never becomes ready for data
 			 * and never leaves the program state.
 			 */
@@ -1144,6 +1160,10 @@ static int mmc_blk_err_check(struct mmc_card *card,
 			 (R1_CURRENT_STATE(status) == R1_STATE_PRG));
 	}
 
+	/* if error occur, retry operation executes */
+	if (gen_err)
+		return MMC_BLK_RETRY;
+
 	if (brq->data.error) {
 		pr_err("%s: error %d transferring data, sector %u, nr %u, cmd response %#x, card status %#x\n",
 		       req->rq_disk->disk_name, brq->data.error,
-- 
1.7.0.4


