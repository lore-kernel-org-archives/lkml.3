Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbbALSJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:09:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57818 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909AbbALSGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:06:52 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@lst.de>,
        Robert Elliott <elliott@hp.com>, Ming Lei <ming.lei@canonical.com>,
        Alexander Gordeev <agordeev@redhat.com>, Jens Axboe <axboe@fb.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 103/216] blk-mq: Fix a race between bt_clear_tag() and bt_get()
Date: Mon, 12 Jan 2015 18:03:40 +0000
Message-Id: <1421085933-32536-104-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

commit c38d185d4af12e8be63ca4b6745d99449c450f12 upstream.

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
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 block/blk-mq-tag.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index a1bc33974fc4..1caaa7c4605d 100644
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
2.1.4

