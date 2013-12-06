Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759804Ab3LFV4m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 16:56:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32943 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758831Ab3LFVyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:54:22 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        KOBAYASHI Yoshitake <yoshitake.kobayashi@toshiba.co.jp>,
        Chris Ball <cjb@laptop.org>
Subject: [PATCH 3.4 26/32] mmc: block: fix a bug of error handling in MMC driver
Date: Fri,  6 Dec 2013 13:52:36 -0800
Message-Id: <20131206214959.214783026@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214956.830407026@linuxfoundation.org>
References: <20131206214956.830407026@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/mmc/card/block.c |   47 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 44 insertions(+), 3 deletions(-)

--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -701,7 +701,7 @@ static int mmc_blk_cmd_error(struct requ
  * Otherwise we don't understand what happened, so abort.
  */
 static int mmc_blk_cmd_recovery(struct mmc_card *card, struct request *req,
-	struct mmc_blk_request *brq, int *ecc_err)
+	struct mmc_blk_request *brq, int *ecc_err, int *gen_err)
 {
 	bool prev_cmd_status_valid = true;
 	u32 status, stop_status = 0;
@@ -739,6 +739,16 @@ static int mmc_blk_cmd_recovery(struct m
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
@@ -758,6 +768,13 @@ static int mmc_blk_cmd_recovery(struct m
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
@@ -1007,7 +1024,7 @@ static int mmc_blk_err_check(struct mmc_
 						    mmc_active);
 	struct mmc_blk_request *brq = &mq_mrq->brq;
 	struct request *req = mq_mrq->req;
-	int ecc_err = 0;
+	int ecc_err = 0, gen_err = 0;
 
 	/*
 	 * sbc.error indicates a problem with the set block count
@@ -1021,7 +1038,7 @@ static int mmc_blk_err_check(struct mmc_
 	 */
 	if (brq->sbc.error || brq->cmd.error || brq->stop.error ||
 	    brq->data.error) {
-		switch (mmc_blk_cmd_recovery(card, req, brq, &ecc_err)) {
+		switch (mmc_blk_cmd_recovery(card, req, brq, &ecc_err, &gen_err)) {
 		case ERR_RETRY:
 			return MMC_BLK_RETRY;
 		case ERR_ABORT:
@@ -1051,6 +1068,15 @@ static int mmc_blk_err_check(struct mmc_
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
@@ -1058,6 +1084,14 @@ static int mmc_blk_err_check(struct mmc_
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
+
 			/*
 			 * Some cards mishandle the status bits,
 			 * so make sure to check both the busy
@@ -1067,6 +1101,13 @@ static int mmc_blk_err_check(struct mmc_
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


