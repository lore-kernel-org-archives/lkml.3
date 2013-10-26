Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab3JZSEK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 14:04:10 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:1238 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717Ab3JZSEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 14:04:09 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
From: "Ray Jui" <rjui@broadcom.com>
To: "Seungwon Jeon" <tgih.jun@samsung.com>, "Chris Ball" <cjb@laptop.org>
cc: linux-kernel@vger.kernel.org, "Ray Jui" <rjui@broadcom.com>
Subject: [PATCH v2] mmc: fix host release issue after discard operation
Date: Sat, 26 Oct 2013 11:03:44 -0700
Message-ID: <1382810624-17659-1-git-send-email-rjui@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
X-WSS-ID: 7E72DB8C4RS1815598-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Under function mmc_blk_issue_rq, after an MMC discard operation,
the MMC request data structure may be freed in memory. Later in
the same function, the check of req->cmd_flags & MMC_REQ_SPECIAL_MASK
is dangerous and invalid. It causes the MMC host not to be released
when it should

This patch fixes the issue by marking the special request down before
the discard/flush operation

Reported by: Harold (SoonYeal) Yang <haroldsy@broadcom.com>
Signed-off-by: Ray Jui <rjui@broadcom.com>
Reviewed-by: Seungwon Jeon <tgih.jun@samsung.com>
---
 drivers/mmc/card/block.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 1a3163f..4e8212c 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -1959,6 +1959,7 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 	struct mmc_card *card = md->queue.card;
 	struct mmc_host *host = card->host;
 	unsigned long flags;
+	unsigned int cmd_flags = req ? req->cmd_flags : 0;
 
 	if (req && !mq->mqrq_prev->req)
 		/* claim host only for the first request */
@@ -1974,7 +1975,7 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 	}
 
 	mq->flags &= ~MMC_QUEUE_NEW_REQUEST;
-	if (req && req->cmd_flags & REQ_DISCARD) {
+	if (cmd_flags & REQ_DISCARD) {
 		/* complete ongoing async transfer before issuing discard */
 		if (card->host->areq)
 			mmc_blk_issue_rw_rq(mq, NULL);
@@ -1983,7 +1984,7 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 			ret = mmc_blk_issue_secdiscard_rq(mq, req);
 		else
 			ret = mmc_blk_issue_discard_rq(mq, req);
-	} else if (req && req->cmd_flags & REQ_FLUSH) {
+	} else if (cmd_flags & REQ_FLUSH) {
 		/* complete ongoing async transfer before issuing flush */
 		if (card->host->areq)
 			mmc_blk_issue_rw_rq(mq, NULL);
@@ -1999,7 +2000,7 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 
 out:
 	if ((!req && !(mq->flags & MMC_QUEUE_NEW_REQUEST)) ||
-	     (req && (req->cmd_flags & MMC_REQ_SPECIAL_MASK)))
+	     (cmd_flags & MMC_REQ_SPECIAL_MASK))
 		/*
 		 * Release host when there are no more requests
 		 * and after special request(discard, flush) is done.
-- 
1.7.9.5


