Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab3JXWNm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 18:13:42 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:3551 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754553Ab3JXWNl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 18:13:41 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
From: "Ray Jui" <rjui@broadcom.com>
To: "Chris Ball" <cjb@laptop.org>, "Seungwon Jeon" <tgih.jun@samsung.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] mmc: fix host release issue after discard operation
Thread-Topic: [PATCH] mmc: fix host release issue after discard
 operation
Thread-Index: Ac7RBfyzY93ANZCAT8mBR0aq+1TZbA==
Date: Thu, 24 Oct 2013 22:13:33 +0000
Message-ID: <1C995FCD38EDD646A035D3E5892E8C7C04C189A8@SJEXCHMB13.corp.ad.broadcom.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.16.203.100]
MIME-Version: 1.0
X-WSS-ID: 7E77440E4RS1233588-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Under function mmc_blk_issue_rq, after an MMC discard operation,
the MMC request data structure may be freed in memory. Later in
the same function, the check of req->cmd_flags & MMC_REQ_SPECIAL_MASK
is dangerous and invalid. It causes the MMC host not being released
when it should

This patch fixes the issue by marking the special request down before
the discard/flush operation

Reported by: Harold (SoonYeal) Yang <haroldsy@broadcom.com>
Signed-off-by: Ray Jui <rjui@broadcom.com>
---
 drivers/mmc/card/block.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 1a3163f..9e8e970 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -1954,7 +1954,7 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
 
 static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 {
-	int ret;
+	int ret, req_is_special = 0;
 	struct mmc_blk_data *md = mq->data;
 	struct mmc_card *card = md->queue.card;
 	struct mmc_host *host = card->host;
@@ -1973,6 +1973,10 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 		goto out;
 	}
 
+	/* mark special request here since req may be freed later */
+	if (req && (req->cmd_flags & MMC_REQ_SPECIAL_MASK))
+		req_is_special = 1;
+
 	mq->flags &= ~MMC_QUEUE_NEW_REQUEST;
 	if (req && req->cmd_flags & REQ_DISCARD) {
 		/* complete ongoing async transfer before issuing discard */
@@ -1999,7 +2003,7 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 
 out:
 	if ((!req && !(mq->flags & MMC_QUEUE_NEW_REQUEST)) ||
-	     (req && (req->cmd_flags & MMC_REQ_SPECIAL_MASK)))
+	     req_is_special)
 		/*
 		 * Release host when there are no more requests
 		 * and after special request(discard, flush) is done.
-- 
1.7.9.5

