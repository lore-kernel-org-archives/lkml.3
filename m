Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab3ISRVN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 13:21:13 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:61468 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab3ISRVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 13:21:11 -0400
From: Grant Grundler <grundler@chromium.org>
To: Chris Ball <cjb@laptop.org>, Seungwon Jeon <tgih.jun@samsung.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Grant Grundler <grundler@chromium.org>
Subject: [PATCH] mmc: core: remove issue_fn indirect function call
Date: Thu, 19 Sep 2013 10:20:14 -0700
Message-Id: <1379611214-1089-1-git-send-email-grundler@chromium.org>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct mmc_queue defines issue_fn as an indirect function call.
issue_fn field only gets set to mmc_blk_issue_rq and only gets
invoked immediately after calling blk_fetch_request().
Don't bother with indirect function call - it's pointless and just
obfuscates the code.

Signed-off-by: Grant Grundler <grundler@chromium.org>
---
 drivers/mmc/card/block.c | 1 -
 drivers/mmc/card/queue.c | 2 +-
 drivers/mmc/card/queue.h | 1 -
 3 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 1a3163f..b2cdd10 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -2072,7 +2072,6 @@ static struct mmc_blk_data *mmc_blk_alloc_req(struct mmc_card *card,
 	if (ret)
 		goto err_putdisk;
 
-	md->queue.issue_fn = mmc_blk_issue_rq;
 	md->queue.data = md;
 
 	md->disk->major	= MMC_BLOCK_MAJOR;
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index fa9632e..6f9adc5 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -67,7 +67,7 @@ static int mmc_queue_thread(void *d)
 		if (req || mq->mqrq_prev->req) {
 			set_current_state(TASK_RUNNING);
 			cmd_flags = req ? req->cmd_flags : 0;
-			mq->issue_fn(mq, req);
+			mmc_blk_issue_rq(mq, req);
 			if (mq->flags & MMC_QUEUE_NEW_REQUEST) {
 				mq->flags &= ~MMC_QUEUE_NEW_REQUEST;
 				continue; /* fetch again */
diff --git a/drivers/mmc/card/queue.h b/drivers/mmc/card/queue.h
index 5752d50..35380015 100644
--- a/drivers/mmc/card/queue.h
+++ b/drivers/mmc/card/queue.h
@@ -51,7 +51,6 @@ struct mmc_queue {
 #define MMC_QUEUE_SUSPENDED	(1 << 0)
 #define MMC_QUEUE_NEW_REQUEST	(1 << 1)
 
-	int			(*issue_fn)(struct mmc_queue *, struct request *);
 	void			*data;
 	struct request_queue	*queue;
 	struct mmc_queue_req	mqrq[2];
-- 
1.8.4

