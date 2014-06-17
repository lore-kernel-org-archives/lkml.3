Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964887AbaFQUgm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 16:36:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933275AbaFQUgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 16:36:41 -0400
Date: Tue, 17 Jun 2014 22:37:23 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH v2 3/3] blk-mq: bitmap tag: fix races in bt_get() function
Message-ID: <20140617203722.GA5731@dhcp-26-207.brq.redhat.com>
References: <cover.1402582256.git.agordeev@redhat.com>
 <20140617103531.GA13924@infradead.org>
 <53A040CF.2000105@kernel.dk>
 <20140617173956.GB361@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140617173956.GB361@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This update fixes few issues in bt_get() function:

- list_empty(&wait.task_list) check is not protected;

- was_empty check is always true which results in *every* thread
  entering the loop resets bt_wait_state::wait_cnt counter rather
  than every bt->wake_cnt'th thread;

- 'bt_wait_state::wait_cnt' counter update is redundant, since
  it also gets reset in bt_clear_tag() function;

Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 block/blk-mq-tag.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 08fc671..c1b9242 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -248,18 +248,12 @@ static int bt_get(struct blk_mq_alloc_data *data,
 
 	bs = bt_wait_ptr(bt, hctx);
 	do {
-		bool was_empty;
-
-		was_empty = list_empty(&wait.task_list);
 		prepare_to_wait(&bs->wait, &wait, TASK_UNINTERRUPTIBLE);
 
 		tag = __bt_get(hctx, bt, last_tag);
 		if (tag != -1)
 			break;
 
-		if (was_empty)
-			atomic_set(&bs->wait_cnt, bt->wake_cnt);
-
 		blk_mq_put_ctx(data->ctx);
 
 		io_schedule();
@@ -519,10 +513,13 @@ static int bt_alloc(struct blk_mq_bitmap_tags *bt, unsigned int depth,
 		return -ENOMEM;
 	}
 
-	for (i = 0; i < BT_WAIT_QUEUES; i++)
+	bt_update_count(bt, depth);
+
+	for (i = 0; i < BT_WAIT_QUEUES; i++) {
 		init_waitqueue_head(&bt->bs[i].wait);
+		atomic_set(&bt->bs[i].wait_cnt, bt->wake_cnt);
+	}
 
-	bt_update_count(bt, depth);
 	return 0;
 }
 
-- 
1.7.7.6

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
