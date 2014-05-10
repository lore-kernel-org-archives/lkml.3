Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566AbaEJRCs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 13:02:48 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:36797 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757055AbaEJRCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 13:02:46 -0400
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 5/5] blk-mq: bitmap tag: fix wait batch for allocation
Date: Sun, 11 May 2014 01:01:52 +0800
Message-Id: <1399741312-10453-6-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399741312-10453-1-git-send-email-tom.leiming@gmail.com>
References: <1399741312-10453-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One interesting point of bitmap tag allocation is that
it may wait for at least BT_WAIT_BATCH times tag free
for a blocked allocation. Obviously, it may hang allocation
if the depth is smaller than BT_WAIT_BATCH.

This patch simply sets the wait count as 1 if depth is
smaller than BT_WAIT_BATCH to avoid the problem.

Maybe better idea is that it should be set as one ratio
of depth(1/8 or others), but it may need more tests for
verification.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 block/blk-mq-tag.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 6532aea..8e3a22d 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -135,6 +135,16 @@ static struct bt_wait_state *bt_wait_ptr(struct blk_mq_bitmap_tags *bt,
 	return bs;
 }
 
+static void bs_reset_wait_cnt(struct blk_mq_bitmap_tags *bt,
+		struct bt_wait_state *bs)
+{
+	int cnt;
+
+	cnt = bt->depth < BT_WAIT_BATCH ? 1 : BT_WAIT_BATCH;
+
+	atomic_set(&bs->wait_cnt, cnt);
+}
+
 static int bt_get(struct blk_mq_bitmap_tags *bt, struct blk_mq_hw_ctx *hctx,
 		  unsigned int *last_tag, gfp_t gfp)
 {
@@ -160,7 +170,7 @@ static int bt_get(struct blk_mq_bitmap_tags *bt, struct blk_mq_hw_ctx *hctx,
 			break;
 
 		if (was_empty)
-			atomic_set(&bs->wait_cnt, BT_WAIT_BATCH);
+			bs_reset_wait_cnt(bt, bs);
 
 		io_schedule();
 	} while (1);
@@ -243,7 +253,7 @@ static void bt_clear_tag(struct blk_mq_bitmap_tags *bt, unsigned int tag)
 
 	bs = bt_wake_ptr(bt);
 	if (bs && atomic_dec_and_test(&bs->wait_cnt)) {
-		atomic_set(&bs->wait_cnt, BT_WAIT_BATCH);
+		bs_reset_wait_cnt(bt, bs);
 		bt_index_inc(&bt->wake_index);
 		wake_up(&bs->wait);
 	}
-- 
1.7.9.5

