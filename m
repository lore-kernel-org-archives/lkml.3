Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254AbaBKU1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:27:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39929 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbaBKTGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:06:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ray Jui <rjui@broadcom.com>, Seungwon Jeon <tgih.jun@samsung.com>,
        Chris Ball <cjb@laptop.org>
Subject: [PATCH 3.12 019/107] mmc: fix host release issue after discard operation
Date: Tue, 11 Feb 2014 11:04:45 -0800
Message-Id: <20140211184748.750442245@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184748.191276235@linuxfoundation.org>
References: <20140211184748.191276235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/card/block.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -1959,6 +1959,7 @@ static int mmc_blk_issue_rq(struct mmc_q
 	struct mmc_card *card = md->queue.card;
 	struct mmc_host *host = card->host;
 	unsigned long flags;
+	unsigned int cmd_flags = req ? req->cmd_flags : 0;
 
 	if (req && !mq->mqrq_prev->req)
 		/* claim host only for the first request */
@@ -1974,7 +1975,7 @@ static int mmc_blk_issue_rq(struct mmc_q
 	}
 
 	mq->flags &= ~MMC_QUEUE_NEW_REQUEST;
-	if (req && req->cmd_flags & REQ_DISCARD) {
+	if (cmd_flags & REQ_DISCARD) {
 		/* complete ongoing async transfer before issuing discard */
 		if (card->host->areq)
 			mmc_blk_issue_rw_rq(mq, NULL);
@@ -1983,7 +1984,7 @@ static int mmc_blk_issue_rq(struct mmc_q
 			ret = mmc_blk_issue_secdiscard_rq(mq, req);
 		else
 			ret = mmc_blk_issue_discard_rq(mq, req);
-	} else if (req && req->cmd_flags & REQ_FLUSH) {
+	} else if (cmd_flags & REQ_FLUSH) {
 		/* complete ongoing async transfer before issuing flush */
 		if (card->host->areq)
 			mmc_blk_issue_rw_rq(mq, NULL);
@@ -1999,7 +2000,7 @@ static int mmc_blk_issue_rq(struct mmc_q
 
 out:
 	if ((!req && !(mq->flags & MMC_QUEUE_NEW_REQUEST)) ||
-	     (req && (req->cmd_flags & MMC_REQ_SPECIAL_MASK)))
+	     (cmd_flags & MMC_REQ_SPECIAL_MASK))
 		/*
 		 * Release host when there are no more requests
 		 * and after special request(discard, flush) is done.


