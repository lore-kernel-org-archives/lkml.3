Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab3GAI0G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 04:26:06 -0400
Received: from imx9.toshiba.co.jp ([202.33.96.51]:39059 "EHLO
	imx9.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab3GAI0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 04:26:04 -0400
X-Greylist: delayed 1381 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Jul 2013 04:26:04 EDT
Content-Transfer-Encoding: 7bit
From: KOBAYASHI Yoshitake <yoshitake.kobayashi@toshiba.co.jp>
To: cjb@laptop.org, gregkh@linuxfoundation.org, linux-mmc@vger.kernel.org,
        stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        KOBAYASHI Yoshitake <yoshitake.kobayashi@toshiba.co.jp>
Subject: [PATCH 3.4-stable] mmc: block: fix a bug of error handling in MMC driver
Date: Mon,  1 Jul 2013 16:56:25 +0900
Message-Id: <1372665385-8993-1-git-send-email-yoshitake.kobayashi@toshiba.co.jp>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1368165727-32125-1-git-send-email-yoshitake.kobayashi@toshiba.co.jp>
References: <1368165727-32125-1-git-send-email-yoshitake.kobayashi@toshiba.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Backport for 3.4-stable for the following patch:
     https://lkml.org/lkml/2013/5/10/20

This patch fixes a bug of error handling in Linux MMC driver.

Current MMC driver doesn't handle generic error (bit19 of device
status) in write sequence. As a result, write data gets lost when
generic error occurs. For example, a generic error when updating a
filesystem management information causes a loss of write data and
corrupts the filesystem. In the worst case, the system will never
boot.

This patch includes the following functionality:
  1. To enable error checking for the response of CMD12 and CMD13
     in write command sequence
  2. To retry write sequence when a generic error occures

This patch was also posted to 3.4.46-LTSI.
  https://patchwork.kernel.org/patch/2726801/

Signed-off-by: KOBAYASHI Yoshitake <yoshitake.kobayashi@toshiba.co.jp>
---
 drivers/mmc/card/block.c |   46 +++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 833ff16..e77053f 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -701,7 +701,7 @@ static int mmc_blk_cmd_error(struct request *req, const char *name, int error,
  * Otherwise we don't understand what happened, so abort.
  */
 static int mmc_blk_cmd_recovery(struct mmc_card *card, struct request *req,
-	struct mmc_blk_request *brq, int *ecc_err)
+	struct mmc_blk_request *brq, int *ecc_err, int *gen_err)
 {
 	bool prev_cmd_status_valid = true;
 	u32 status, stop_status = 0;
@@ -739,6 +739,16 @@ static int mmc_blk_cmd_recovery(struct mmc_card *card, struct request *req,
 	    (brq->cmd.resp[0] & R1_CARD_ECC_FAILED))
 		*ecc_err = 1;
 
+	/* Flag General errors */
+	if (!mmc_host_is_spi(card->host) && rq_data_dir(req) != READ)
+		if ((status & R1_ERROR) ||
+			(brq->stop.resp[0] & R1_ERROR)) {
+			pr_err("%s: %s: general error sending stop or status command, stop cmd response %#x, card status %#x\n",
+			       req->rq_disk->disk_name, __func__,
+			       brq->stop.resp[0], status);
+			*gen_err = 1;
+		}
+
 	/*
 	 * Check the current card state.  If it is in some data transfer
 	 * mode, tell it to stop (and hopefully transition back to TRAN.)
@@ -758,6 +768,13 @@ static int mmc_blk_cmd_recovery(struct mmc_card *card, struct request *req,
 			return ERR_ABORT;
 		if (stop_status & R1_CARD_ECC_FAILED)
 			*ecc_err = 1;
+		if (!mmc_host_is_spi(card->host) && rq_data_dir(req) != READ)
+			if (stop_status & R1_ERROR) {
+				pr_err("%s: %s: general error sending stop command, stop cmd response %#x\n",
+				       req->rq_disk->disk_name, __func__,
+				       stop_status);
+				*gen_err = 1;
+			}
 	}
 
 	/* Check for set block count errors */
@@ -1007,7 +1024,7 @@ static int mmc_blk_err_check(struct mmc_card *card,
 						    mmc_active);
 	struct mmc_blk_request *brq = &mq_mrq->brq;
 	struct request *req = mq_mrq->req;
-	int ecc_err = 0;
+	int ecc_err = 0, gen_err = 0;
 
 	/*
 	 * sbc.error indicates a problem with the set block count
@@ -1021,7 +1038,7 @@ static int mmc_blk_err_check(struct mmc_card *card,
 	 */
 	if (brq->sbc.error || brq->cmd.error || brq->stop.error ||
 	    brq->data.error) {
-		switch (mmc_blk_cmd_recovery(card, req, brq, &ecc_err)) {
+		switch (mmc_blk_cmd_recovery(card, req, brq, &ecc_err, &gen_err)) {
 		case ERR_RETRY:
 			return MMC_BLK_RETRY;
 		case ERR_ABORT:
@@ -1051,6 +1068,15 @@ static int mmc_blk_err_check(struct mmc_card *card,
 	 */
 	if (!mmc_host_is_spi(card->host) && rq_data_dir(req) != READ) {
 		u32 status;
+
+		/* Check stop command response */
+		if (brq->stop.resp[0] & R1_ERROR) {
+			pr_err("%s: %s: general error sending stop command, stop cmd response %#x\n",
+			       req->rq_disk->disk_name, __func__,
+			       brq->stop.resp[0]);
+			gen_err = 1;
+		}
+
 		do {
 			int err = get_card_status(card, &status, 5);
 			if (err) {
@@ -1058,6 +1084,13 @@ static int mmc_blk_err_check(struct mmc_card *card,
 				       req->rq_disk->disk_name, err);
 				return MMC_BLK_CMD_ERR;
 			}
+
+			if (status & R1_ERROR) {
+				pr_err("%s: %s: general error sending status command, card status %#x\n",
+				       req->rq_disk->disk_name, __func__,
+				       status);
+				gen_err = 1;
+			}
 			/*
 			 * Some cards mishandle the status bits,
 			 * so make sure to check both the busy
@@ -1067,6 +1100,13 @@ static int mmc_blk_err_check(struct mmc_card *card,
 			 (R1_CURRENT_STATE(status) == R1_STATE_PRG));
 	}
 
+	/* if general error occurs, retry the write operation. */
+	if (gen_err) {
+		pr_warning("%s: retrying write for general error\n",
+				req->rq_disk->disk_name);
+		return MMC_BLK_RETRY;
+	}
+
 	if (brq->data.error) {
 		pr_err("%s: error %d transferring data, sector %u, nr %u, cmd response %#x, card status %#x\n",
 		       req->rq_disk->disk_name, brq->data.error,
-- 
1.7.0.4


