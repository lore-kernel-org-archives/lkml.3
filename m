Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596Ab3LSNMj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 08:12:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44367 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab3LSLzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:55:19 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: KOBAYASHI Yoshitake <yoshitake.kobayashi@toshiba.co.jp>,
        Chris Ball <cjb@laptop.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 003/208] mmc: block: fix a bug of error handling in MMC driver
Date: Thu, 19 Dec 2013 11:51:41 +0000
Message-Id: <1387454106-19326-4-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: KOBAYASHI Yoshitake <yoshitake.kobayashi@toshiba.co.jp>

commit c8760069627ad3b0dbbea170f0c4c58b16e18d3d upstream.

Current MMC driver doesn't handle generic error (bit19 of device
status) in write sequence. As a result, write data gets lost when
generic error occurs. For example, a generic error when updating a
filesystem management information causes a loss of write data and
corrupts the filesystem. In the worst case, the system will never
boot.

This patch includes the following functionality:
  1. To enable error checking for the response of CMD12 and CMD13
     in write command sequence
  2. To retry write sequence when a generic error occurs

Messages are added for v2 to show what occurs.

Signed-off-by: KOBAYASHI Yoshitake <yoshitake.kobayashi@toshiba.co.jp>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/mmc/card/block.c | 45 ++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 42 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index f4a0bea..1a3163f 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -812,7 +812,7 @@ static int mmc_blk_cmd_error(struct request *req, const char *name, int error,
  * Otherwise we don't understand what happened, so abort.
  */
 static int mmc_blk_cmd_recovery(struct mmc_card *card, struct request *req,
-	struct mmc_blk_request *brq, int *ecc_err)
+	struct mmc_blk_request *brq, int *ecc_err, int *gen_err)
 {
 	bool prev_cmd_status_valid = true;
 	u32 status, stop_status = 0;
@@ -850,6 +850,16 @@ static int mmc_blk_cmd_recovery(struct mmc_card *card, struct request *req,
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
@@ -869,6 +879,13 @@ static int mmc_blk_cmd_recovery(struct mmc_card *card, struct request *req,
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
@@ -1097,7 +1114,7 @@ static int mmc_blk_err_check(struct mmc_card *card,
 						    mmc_active);
 	struct mmc_blk_request *brq = &mq_mrq->brq;
 	struct request *req = mq_mrq->req;
-	int ecc_err = 0;
+	int ecc_err = 0, gen_err = 0;
 
 	/*
 	 * sbc.error indicates a problem with the set block count
@@ -1111,7 +1128,7 @@ static int mmc_blk_err_check(struct mmc_card *card,
 	 */
 	if (brq->sbc.error || brq->cmd.error || brq->stop.error ||
 	    brq->data.error) {
-		switch (mmc_blk_cmd_recovery(card, req, brq, &ecc_err)) {
+		switch (mmc_blk_cmd_recovery(card, req, brq, &ecc_err, &gen_err)) {
 		case ERR_RETRY:
 			return MMC_BLK_RETRY;
 		case ERR_ABORT:
@@ -1143,6 +1160,14 @@ static int mmc_blk_err_check(struct mmc_card *card,
 		u32 status;
 		unsigned long timeout;
 
+		/* Check stop command response */
+		if (brq->stop.resp[0] & R1_ERROR) {
+			pr_err("%s: %s: general error sending stop command, stop cmd response %#x\n",
+			       req->rq_disk->disk_name, __func__,
+			       brq->stop.resp[0]);
+			gen_err = 1;
+		}
+
 		timeout = jiffies + msecs_to_jiffies(MMC_BLK_TIMEOUT_MS);
 		do {
 			int err = get_card_status(card, &status, 5);
@@ -1152,6 +1177,13 @@ static int mmc_blk_err_check(struct mmc_card *card,
 				return MMC_BLK_CMD_ERR;
 			}
 
+			if (status & R1_ERROR) {
+				pr_err("%s: %s: general error sending status command, card status %#x\n",
+				       req->rq_disk->disk_name, __func__,
+				       status);
+				gen_err = 1;
+			}
+
 			/* Timeout if the device never becomes ready for data
 			 * and never leaves the program state.
 			 */
@@ -1171,6 +1203,13 @@ static int mmc_blk_err_check(struct mmc_card *card,
 			 (R1_CURRENT_STATE(status) == R1_STATE_PRG));
 	}
 
+	/* if general error occurs, retry the write operation. */
+	if (gen_err) {
+		pr_warn("%s: retrying write for general error\n",
+				req->rq_disk->disk_name);
+		return MMC_BLK_RETRY;
+	}
+
 	if (brq->data.error) {
 		pr_err("%s: error %d transferring data, sector %u, nr %u, cmd response %#x, card status %#x\n",
 		       req->rq_disk->disk_name, brq->data.error,
-- 
1.8.3.2

