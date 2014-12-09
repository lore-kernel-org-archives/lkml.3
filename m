Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523AbaLIP6k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 10:58:40 -0500
Received: from xavier.telenet-ops.be ([195.130.132.52]:36196 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756816AbaLIP6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 10:58:39 -0500
Message-ID: <54871C2B.8070605@acm.org>
Date: Tue, 09 Dec 2014 16:58:35 +0100
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: Christoph Hellwig <hch@lst.de>, Robert Elliott <elliott@hp.com>,
        Ming Lei <ming.lei@canonical.com>,
        Alexander Gordeev <agordeev@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/6] blk-mq: Fix a race between bt_clear_tag() and bt_get()
References: <54871BD0.8020305@acm.org>
In-Reply-To: <54871BD0.8020305@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What we need is the following two guarantees:
* Any thread that observes the effect of the test_and_set_bit() by
  __bt_get_word() also observes the preceding addition of 'current'
  to the appropriate wait list. This is guaranteed by the semantics
  of the spin_unlock() operation performed by prepare_and_wait().
  Hence the conversion of test_and_set_bit_lock() into
  test_and_set_bit().
* The wait lists are examined by bt_clear() after the tag bit has
  been cleared. clear_bit_unlock() guarantees that any thread that
  observes that the bit has been cleared also observes the store
  operations preceding clear_bit_unlock(). However,
  clear_bit_unlock() does not prevent that the wait lists are examined
  before that the tag bit is cleared. Hence the addition of a memory
  barrier between clear_bit() and the wait list examination.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Robert Elliott <elliott@hp.com>
Cc: Ming Lei <ming.lei@canonical.com>
Cc: Alexander Gordeev <agordeev@redhat.com>
Cc: <stable@vger.kernel.org> # v3.13+
---
 block/blk-mq-tag.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 5a3db28..70d9f9e 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -158,7 +158,7 @@ restart:
 			return -1;
 		}
 		last_tag = tag + 1;
-	} while (test_and_set_bit_lock(tag, &bm->word));
+	} while (test_and_set_bit(tag, &bm->word));
 
 	return tag;
 }
@@ -342,11 +342,10 @@ static void bt_clear_tag(struct blk_mq_bitmap_tags *bt, unsigned int tag)
 	struct bt_wait_state *bs;
 	int wait_cnt;
 
-	/*
-	 * The unlock memory barrier need to order access to req in free
-	 * path and clearing tag bit
-	 */
-	clear_bit_unlock(TAG_TO_BIT(bt, tag), &bt->map[index].word);
+	clear_bit(TAG_TO_BIT(bt, tag), &bt->map[index].word);
+
+	/* Ensure that the wait list checks occur after clear_bit(). */
+	smp_mb();
 
 	bs = bt_wake_ptr(bt);
 	if (!bs)
-- 
2.1.2

