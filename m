Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788AbbANIfz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:35:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57871 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317AbbANH1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:27:25 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@lst.de>,
        Robert Elliott <elliott@hp.com>, Ming Lei <ming.lei@canonical.com>,
        Alexander Gordeev <agordeev@redhat.com>, Jens Axboe <axboe@fb.com>
Subject: [PATCH 3.18 049/150] blk-mq: Fix a race between bt_clear_tag() and bt_get()
Date: Tue, 13 Jan 2015 23:22:00 -0800
Message-Id: <20150114072058.100442357@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/blk-mq-tag.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

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
@@ -342,11 +342,10 @@ static void bt_clear_tag(struct blk_mq_b
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


