Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463AbaICUdw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 16:33:52 -0400
Received: from 6.77.broadband6.iol.cz ([88.101.77.6]:41604 "EHLO
	dhcp-27-160.brq.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756394AbaICUdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 16:33:50 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] blk-mq: Cleanup blk_mq_tag_busy() and blk_mq_tag_idle()
Date: Wed,  3 Sep 2014 22:33:05 +0200
Message-Id: <1860c570e5efa8ece323a7ba20f3597bd5e99d25.1409775956.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1409775956.git.agordeev@redhat.com>
References: <cover.1409775956.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blk-mq-tag.c |  4 +---
 block/blk-mq-tag.h | 17 ++++++++---------
 2 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index c1b9242..4953b64 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -58,13 +58,11 @@ static inline void bt_index_atomic_inc(atomic_t *index)
 /*
  * If a previously inactive queue goes active, bump the active user count.
  */
-bool __blk_mq_tag_busy(struct blk_mq_hw_ctx *hctx)
+void __blk_mq_tag_busy(struct blk_mq_hw_ctx *hctx)
 {
 	if (!test_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state) &&
 	    !test_and_set_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
 		atomic_inc(&hctx->tags->active_queues);
-
-	return true;
 }
 
 /*
diff --git a/block/blk-mq-tag.h b/block/blk-mq-tag.h
index 6206ed1..795ec3f 100644
--- a/block/blk-mq-tag.h
+++ b/block/blk-mq-tag.h
@@ -66,23 +66,22 @@ enum {
 	BLK_MQ_TAG_MAX		= BLK_MQ_TAG_FAIL - 1,
 };
 
-extern bool __blk_mq_tag_busy(struct blk_mq_hw_ctx *);
+extern void __blk_mq_tag_busy(struct blk_mq_hw_ctx *);
 extern void __blk_mq_tag_idle(struct blk_mq_hw_ctx *);
 
 static inline bool blk_mq_tag_busy(struct blk_mq_hw_ctx *hctx)
 {
-	if (!(hctx->flags & BLK_MQ_F_TAG_SHARED))
-		return false;
-
-	return __blk_mq_tag_busy(hctx);
+	if (hctx->flags & BLK_MQ_F_TAG_SHARED) {
+		__blk_mq_tag_busy(hctx);
+		return true;
+	}
+	return false;
 }
 
 static inline void blk_mq_tag_idle(struct blk_mq_hw_ctx *hctx)
 {
-	if (!(hctx->flags & BLK_MQ_F_TAG_SHARED))
-		return;
-
-	__blk_mq_tag_idle(hctx);
+	if (hctx->flags & BLK_MQ_F_TAG_SHARED)
+		__blk_mq_tag_idle(hctx);
 }
 
 #endif
-- 
1.9.3

