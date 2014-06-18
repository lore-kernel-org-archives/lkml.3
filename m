Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179AbaFRPVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:21:20 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:58632 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbaFRPVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:21:17 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, kmo@daterainc.com, nab@linux-iscsi.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/6] blk-mq: make blk_mq_stop_hw_queue() reliably block queue processing
Date: Wed, 18 Jun 2014 11:21:07 -0400
Message-Id: <1403104872-22236-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1403104872-22236-1-git-send-email-tj@kernel.org>
References: <1403104872-22236-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk_mq_stop_hw_queue() has the following two issues.

* BLK_MQ_S_STOPPED should be set before canceling the work items;
  otherwise, a new instance may proceed beyond STOPPED checking
  inbetween.

* cancel_delayed_work() doesn't do anything to work instance already
  executing.  Use cancel_delayed_work_sync() to ensure that the
  currently in-flight one is finished.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 block/blk-mq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index e11f5f8..4787c3d 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -862,9 +862,9 @@ EXPORT_SYMBOL(blk_mq_run_queues);
 
 void blk_mq_stop_hw_queue(struct blk_mq_hw_ctx *hctx)
 {
-	cancel_delayed_work(&hctx->run_work);
-	cancel_delayed_work(&hctx->delay_work);
 	set_bit(BLK_MQ_S_STOPPED, &hctx->state);
+	cancel_delayed_work_sync(&hctx->run_work);
+	cancel_delayed_work_sync(&hctx->delay_work);
 }
 EXPORT_SYMBOL(blk_mq_stop_hw_queue);
 
-- 
1.9.3

