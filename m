Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571AbaLIP67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 10:58:59 -0500
Received: from xavier.telenet-ops.be ([195.130.132.52]:36196 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757525AbaLIP66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 10:58:58 -0500
Message-ID: <54871C41.5040500@acm.org>
Date: Tue, 09 Dec 2014 16:58:57 +0100
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: Christoph Hellwig <hch@lst.de>, Robert Elliott <elliott@hp.com>,
        Ming Lei <ming.lei@canonical.com>,
        Alexander Gordeev <agordeev@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/6] blk-mq: Avoid that I/O hangs in bt_get()
References: <54871BD0.8020305@acm.org>
In-Reply-To: <54871BD0.8020305@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid that if there are fewer hardware queues than CPU threads that
bt_get() can hang. The symptoms of the hang were as follows:
* All tags allocated for a particular hardware queue.
* (nr_tags) pending commands for that hardware queue.
* No pending commands for the software queues associated with that
  hardware queue.

The call stack that corresponds to the hang is as follows:

io_schedule+0x9c/0x130
bt_get+0xef/0x180
blk_mq_get_tag+0x9f/0xd0
__blk_mq_alloc_request+0x16/0x1f0
blk_mq_map_request+0x123/0x130
blk_mq_make_request+0x69/0x280
generic_make_request+0xc0/0x110
submit_bio+0x64/0x130
do_blockdev_direct_IO+0x1dc8/0x2da0
__blockdev_direct_IO+0x47/0x50
blkdev_direct_IO+0x49/0x50
generic_file_read_iter+0x546/0x610
blkdev_read_iter+0x32/0x40
aio_run_iocb+0x1f8/0x400
do_io_submit+0x121/0x490
SyS_io_submit+0xb/0x10
system_call_fastpath+0x12/0x17

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Robert Elliott <elliott@hp.com>
Cc: Ming Lei <ming.lei@canonical.com>
Cc: Alexander Gordeev <agordeev@redhat.com>
Cc: <stable@vger.kernel.org> # v3.13+
---
 block/blk-mq-tag.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 70d9f9e..795996e 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -256,6 +256,12 @@ static int bt_get(struct blk_mq_alloc_data *data,
 		if (tag != -1)
 			break;
 
+		blk_mq_run_hw_queue(hctx, false);
+
+		tag = __bt_get(hctx, bt, last_tag);
+		if (tag != -1)
+			break;
+
 		blk_mq_put_ctx(data->ctx);
 
 		io_schedule();
-- 
2.1.2

