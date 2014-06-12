Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092AbaFLPEk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 11:04:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756073AbaFLPEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 11:04:34 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Ming Lei <tom.leiming@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] blk-mq: bitmap tag: fix race on blk_mq_bitmap_tags::wake_cnt
Date: Thu, 12 Jun 2014 17:05:37 +0200
Message-Id: <6ff04ade7e2ae10b19e3f5ce8f9966e83e0bdcec.1402582256.git.agordeev@redhat.com>
In-Reply-To: <cover.1402582256.git.agordeev@redhat.com>
References: <cover.1402582256.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This piece of code in bt_clear_tag() function is racy:

	bs = bt_wake_ptr(bt);
	if (bs && atomic_dec_and_test(&bs->wait_cnt)) {
		atomic_set(&bs->wait_cnt, bt->wake_cnt);
 		wake_up(&bs->wait);
	}

Since nothing prevents bt_wake_ptr() from returning the very
same 'bs' address on multiple CPUs, the following scenario is
possible:

    CPU1                                CPU2
    ----                                ----

0.  bs = bt_wake_ptr(bt);               bs = bt_wake_ptr(bt);
1.  atomic_dec_and_test(&bs->wait_cnt)
2.                                      atomic_dec_and_test(&bs->wait_cnt)
3.  atomic_set(&bs->wait_cnt, bt->wake_cnt);

If the decrement in [1] yields zero then for some amount of time
the decrement in [2] results in a negative/overflow value, which
is not expected. The follow-up assignment in [3] overwrites the
invalid value with the batch value (and likely prevents the issue
from being severe) which is still incorrect and should be a lesser.

Cc: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 block/blk-mq-tag.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index efe9419..5579fae 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -320,6 +320,7 @@ static void bt_clear_tag(struct blk_mq_bitmap_tags *bt, unsigned int tag)
 {
 	const int index = TAG_TO_INDEX(bt, tag);
 	struct bt_wait_state *bs;
+	int wait_cnt;
 
 	/*
 	 * The unlock memory barrier need to order access to req in free
@@ -328,10 +329,19 @@ static void bt_clear_tag(struct blk_mq_bitmap_tags *bt, unsigned int tag)
 	clear_bit_unlock(TAG_TO_BIT(bt, tag), &bt->map[index].word);
 
 	bs = bt_wake_ptr(bt);
-	if (bs && atomic_dec_and_test(&bs->wait_cnt)) {
-		atomic_set(&bs->wait_cnt, bt->wake_cnt);
+	if (!bs)
+		return;
+
+	wait_cnt = atomic_dec_return(&bs->wait_cnt);
+	if (wait_cnt == 0) {
+wake:
+		atomic_add(bt->wake_cnt, &bs->wait_cnt);
 		bt_index_atomic_inc(&bt->wake_index);
 		wake_up(&bs->wait);
+	} else if (wait_cnt < 0) {
+		wait_cnt = atomic_inc_return(&bs->wait_cnt);
+		if (!wait_cnt)
+			goto wake;
 	}
 }
 
-- 
1.7.7.6

