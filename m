Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383Ab3IZTX4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 15:23:56 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:62734 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306Ab3IZTXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 15:23:50 -0400
From: Grant Grundler <grundler@chromium.org>
To: Chris Ball <cjb@laptop.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Grant Grundler <grundler@chromium.org>
Subject: [PATCH 7/7] mmc: core: mmc_start_req is a misnomer -> mmc_process_areq
Date: Thu, 26 Sep 2013 12:23:00 -0700
Message-Id: <1380223380-22451-8-git-send-email-grundler@chromium.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1380223380-22451-1-git-send-email-grundler@chromium.org>
References: <1380223380-22451-1-git-send-email-grundler@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mmc_start_req() only handles *asynchronous* requests and is easily
confused with mmc_start_request and __mmc_start_req() (both of which
only handle synchronous requests). Renaming should hopefully make
it clearer this function is used to harvest completions and start
new requests.

Signed-off-by: Grant Grundler <grundler@chromium.org>
---
 drivers/mmc/card/block.c    |  8 ++++----
 drivers/mmc/card/mmc_test.c |  4 ++--
 drivers/mmc/core/core.c     | 23 +++++++++++------------
 include/linux/mmc/core.h    |  2 +-
 4 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 1a3163f..91a5dae 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -1805,7 +1805,7 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
 			areq = &mq->mqrq_cur->mmc_active;
 		} else
 			areq = NULL;
-		areq = mmc_start_req(card->host, areq, (int *) &status);
+		areq = mmc_process_areq(card->host, areq, (int *) &status);
 		if (!areq) {
 			if (status == MMC_BLK_NEW_REQUEST)
 				mq->flags |= MMC_QUEUE_NEW_REQUEST;
@@ -1902,7 +1902,7 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
 				if (!mq_rq->packed->retries)
 					goto cmd_abort;
 				mmc_blk_packed_hdr_wrq_prep(mq_rq, card, mq);
-				mmc_start_req(card->host,
+				mmc_process_areq(card->host,
 					      &mq_rq->mmc_active, NULL);
 			} else {
 
@@ -1912,7 +1912,7 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
 				 */
 				mmc_blk_rw_rq_prep(mq_rq, card,
 						disable_multi, mq);
-				mmc_start_req(card->host,
+				mmc_process_areq(card->host,
 						&mq_rq->mmc_active, NULL);
 			}
 		}
@@ -1944,7 +1944,7 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
 				mmc_blk_revert_packed_req(mq, mq->mqrq_cur);
 
 			mmc_blk_rw_rq_prep(mq->mqrq_cur, card, 0, mq);
-			mmc_start_req(card->host,
+			mmc_process_areq(card->host,
 				      &mq->mqrq_cur->mmc_active, NULL);
 		}
 	}
diff --git a/drivers/mmc/card/mmc_test.c b/drivers/mmc/card/mmc_test.c
index 0c0fc52..c1e2e09 100644
--- a/drivers/mmc/card/mmc_test.c
+++ b/drivers/mmc/card/mmc_test.c
@@ -811,7 +811,7 @@ static int mmc_test_nonblock_transfer(struct mmc_test_card *test,
 	for (i = 0; i < count; i++) {
 		mmc_test_prepare_mrq(test, cur_areq->mrq, sg, sg_len, dev_addr,
 				     blocks, blksz, write);
-		done_areq = mmc_start_req(test->card->host, cur_areq, &ret);
+		done_areq = mmc_process_areq(test->card->host, cur_areq, &ret);
 
 		if (ret || (!done_areq && i > 0))
 			goto err;
@@ -830,7 +830,7 @@ static int mmc_test_nonblock_transfer(struct mmc_test_card *test,
 		dev_addr += blocks;
 	}
 
-	done_areq = mmc_start_req(test->card->host, NULL, &ret);
+	done_areq = mmc_process_areq(test->card->host, NULL, &ret);
 
 	return ret;
 err:
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index e5a9599..e824ad9 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -475,7 +475,7 @@ static void mmc_wait_for_req_done(struct mmc_host *host,
  *	@is_first_req: true if there is no previous started request
  *                     that may run in parellel to this call, otherwise false
  *
- *	mmc_pre_req() is called in prior to mmc_start_req() to let
+ *	mmc_pre_req() is called in prior to mmc_process_req() to let
  *	host prepare for the new request. Preparation of a request may be
  *	performed while another request is running on the host.
  */
@@ -509,22 +509,21 @@ static void mmc_post_req(struct mmc_host *host, struct mmc_request *mrq,
 }
 
 /**
- *	mmc_start_req - start a non-blocking request
+ *	mmc_process_areq - start a non-blocking IO and handle completions
  *	@host: MMC host to start command
  *	@areq: async request to start
- *	@error: out parameter returns 0 for success, otherwise non zero
+ *	@error: out parameter returns 0 (success) or non-zero (failure)
+ *		 of completed IO (not the IO we tried to start).
  *
- *	Start a new MMC custom command request for a host.
- *	If there is on ongoing async request wait for completion
- *	of that request and start the new one and return.
+ *	If a host has an in-flight async request, wait for completion
+ *	of that request, then start the new MMC custom command request.
  *	Does not wait for the new request to complete.
  *
- *      Returns the completed request, NULL in case of none completed.
- *	Wait for the an ongoing request (previoulsy started) to complete and
- *	return the completed request. If there is no ongoing request, NULL
- *	is returned without waiting. NULL is not an error condition.
+ *	Returns the pointer to the completed request; NULL in case of
+ *	none completed or no in-flight request.  NULL is not an error
+ *	condition.
  */
-struct mmc_async_req *mmc_start_req(struct mmc_host *host,
+struct mmc_async_req *mmc_process_areq(struct mmc_host *host,
 				    struct mmc_async_req *areq, int *error)
 {
 	int saved_err = 0;
@@ -591,7 +590,7 @@ set_error:
 
 	return saved_areq;
 }
-EXPORT_SYMBOL(mmc_start_req);
+EXPORT_SYMBOL(mmc_process_areq);
 
 /**
  *	mmc_wait_for_req - start a request and wait for completion
diff --git a/include/linux/mmc/core.h b/include/linux/mmc/core.h
index a00fc49..773cabb 100644
--- a/include/linux/mmc/core.h
+++ b/include/linux/mmc/core.h
@@ -142,7 +142,7 @@ struct mmc_async_req;
 
 extern int mmc_stop_bkops(struct mmc_card *);
 extern int mmc_read_bkops_status(struct mmc_card *);
-extern struct mmc_async_req *mmc_start_req(struct mmc_host *,
+extern struct mmc_async_req *mmc_process_areq(struct mmc_host *,
 					   struct mmc_async_req *, int *);
 extern int mmc_interrupt_hpi(struct mmc_card *);
 extern void mmc_wait_for_req(struct mmc_host *, struct mmc_request *);
-- 
1.8.4

