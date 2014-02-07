Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932391AbaBGLu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:50:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41919 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932346AbaBGLuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:50:21 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ray Jui <rjui@broadcom.com>, Chris Ball <cjb@laptop.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 111/233] mmc: fix host release issue after discard operation
Date: Fri,  7 Feb 2014 11:45:30 +0000
Message-Id: <1391773652-25214-112-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ray Jui <rjui@broadcom.com>

commit f662ae48ae67dfd42739e65750274fe8de46240a upstream.

Under function mmc_blk_issue_rq, after an MMC discard operation,
the MMC request data structure may be freed in memory. Later in
the same function, the check of req->cmd_flags & MMC_REQ_SPECIAL_MASK
is dangerous and invalid. It causes the MMC host not to be released
when it should.

This patch fixes the issue by marking the special request down before
the discard/flush operation.

Reported by: Harold (SoonYeal) Yang <haroldsy@broadcom.com>
Signed-off-by: Ray Jui <rjui@broadcom.com>
Reviewed-by: Seungwon Jeon <tgih.jun@samsung.com>
Acked-by: Seungwon Jeon <tgih.jun@samsung.com>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/mmc/card/block.c | 7 ++++---
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
1.8.3.2

