Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948AbaEJRCQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 13:02:16 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:51025 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728AbaEJRCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 13:02:14 -0400
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 1/5] blk-mq: bitmap tag: use clear_bit_unlock in bt_clear_tag()
Date: Sun, 11 May 2014 01:01:48 +0800
Message-Id: <1399741312-10453-2-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399741312-10453-1-git-send-email-tom.leiming@gmail.com>
References: <1399741312-10453-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The unlock memory barrier need to order access to req in free
path and clearing tag bit, otherwise either request free path
may see a allocated request, or initialized request in allocate
path might be modified by the ongoing free path.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 block/blk-mq-tag.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 8dc933b..b8b968d 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -235,7 +235,11 @@ static void bt_clear_tag(struct blk_mq_bitmap_tags *bt, unsigned int tag)
 	const int index = TAG_TO_INDEX(tag);
 	struct bt_wait_state *bs;
 
-	clear_bit(TAG_TO_BIT(tag), &bt->map[index].word);
+	/*
+	 * The unlock memory barrier need to order access to req in free
+	 * path and clearing tag bit
+	 */
+	clear_bit_unlock(TAG_TO_BIT(tag), &bt->map[index].word);
 
 	bs = bt_wake_ptr(bt);
 	if (bs && atomic_dec_and_test(&bs->wait_cnt)) {
-- 
1.7.9.5

