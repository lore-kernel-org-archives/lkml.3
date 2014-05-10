Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009AbaEJRC0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 13:02:26 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:33513 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728AbaEJRCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 13:02:22 -0400
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 2/5] blk-mq: bitmap tag: remove barrier in bt_clear_tag()
Date: Sun, 11 May 2014 01:01:49 +0800
Message-Id: <1399741312-10453-3-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399741312-10453-1-git-send-email-tom.leiming@gmail.com>
References: <1399741312-10453-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The barrier isn't necessary because both atomic_dec_and_test()
and wake_up() implicate one barrier.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 block/blk-mq-tag.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index b8b968d..777aad7 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -243,7 +243,6 @@ static void bt_clear_tag(struct blk_mq_bitmap_tags *bt, unsigned int tag)
 
 	bs = bt_wake_ptr(bt);
 	if (bs && atomic_dec_and_test(&bs->wait_cnt)) {
-		smp_mb__after_clear_bit();
 		atomic_set(&bs->wait_cnt, BT_WAIT_BATCH);
 		bt_index_inc(&bt->wake_index);
 		wake_up(&bs->wait);
-- 
1.7.9.5

