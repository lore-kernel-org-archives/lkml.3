Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbaJFSxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 14:53:30 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:48903 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbaJFSx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 14:53:29 -0400
Message-ID: <5432E524.90407@kernel.dk>
Date: Mon, 06 Oct 2014 12:53:24 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Bart Van Assche <bvanassche@acm.org>
CC: Christoph Hellwig <hch@lst.de>, Robert Elliott <Elliott@hp.com>,
        Ming Lei <ming.lei@canonical.com>, Sagi Grimberg <sagig@mellanox.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] blk-mq: Avoid that I/O hangs in bt_get()
References: <54328A97.3030201@acm.org> <5432D414.4060408@kernel.dk>
In-Reply-To: <5432D414.4060408@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------060108000002090405050001"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060108000002090405050001
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 10/06/2014 11:40 AM, Jens Axboe wrote:
> On 10/06/2014 06:27 AM, Bart Van Assche wrote:
>> Ensure that bt_clear_tag() increments bs->wait_cnt if one or more
>> threads are waiting for a tag. Remove a superfluous
>> waitqueue_active() call from blk_mq_tag_wakeup_all(). This patch
>> avoids that bt_get() hangs as follows if the number of hardware
>> contexts is below the number of CPU threads:
>>
>> INFO: task fio:6739 blocked for more than 120 seconds.
>>       Not tainted 3.17.0-rc7+ #1
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> fio             D ffff88085fcd2740     0  6739   6688 0x00000000
>>  ffff8807fb96f830 0000000000000086 ffff8808350eb000 ffff8807fb96ffd8
>>  0000000000012740 0000000000012740 ffff88085b885000 ffff8808350eb000
>>  ffff88085fcd2fe0 ffff8807fb96f920 ffff88080061ddc8 ffffe8ffffcc4600
>> Call Trace:
>>  [<ffffffff8142f52d>] io_schedule+0x9d/0x130
>>  [<ffffffff812016bf>] bt_get+0xef/0x180
>>  [<ffffffff8107f440>] ? prepare_to_wait_event+0x110/0x110
>>  [<ffffffff81201a0f>] blk_mq_get_tag+0x9f/0xd0
>>  [<ffffffff811fdedb>] __blk_mq_alloc_request+0x1b/0x200
>>  [<ffffffff811ff3bc>] blk_mq_map_request+0x15c/0x1b0
>>  [<ffffffff8120079e>] blk_mq_make_request+0x6e/0x270
>>  [<ffffffff8110a99f>] ? mempool_alloc+0x4f/0x130
>>  [<ffffffff811f3af0>] generic_make_request+0xc0/0x110
>>  [<ffffffff811f3bab>] submit_bio+0x6b/0x140
>>  [<ffffffff81110e4b>] ? set_page_dirty_lock+0x2b/0x40
>>  [<ffffffff811eea57>] ? bio_set_pages_dirty+0x47/0x60
>>  [<ffffffff811907d0>] do_blockdev_direct_IO+0x2080/0x3220
>>  [<ffffffff8118bac0>] ? I_BDEV+0x10/0x10
>>  [<ffffffff811919bc>] __blockdev_direct_IO+0x4c/0x50
>>  [<ffffffff8118bac0>] ? I_BDEV+0x10/0x10
>>  [<ffffffff8118c1de>] blkdev_direct_IO+0x4e/0x50
>>  [<ffffffff8118bac0>] ? I_BDEV+0x10/0x10
>>  [<ffffffff81109a13>] generic_file_read_iter+0x513/0x5e0
>>  [<ffffffff8119d8a7>] ? kiocb_free+0x37/0x40
>>  [<ffffffff8118c660>] ? ioctl_by_bdev+0x40/0x40
>>  [<ffffffff8118c697>] blkdev_read_iter+0x37/0x40
>>  [<ffffffff8119e6b4>] aio_run_iocb+0x1e4/0x3c0
>>  [<ffffffff8114dfa6>] ? kmem_cache_alloc+0xd6/0x3d0
>>  [<ffffffff8114e045>] ? kmem_cache_alloc+0x175/0x3d0
>>  [<ffffffff8119f5cc>] do_io_submit+0x11c/0x490
>>  [<ffffffff8119f950>] SyS_io_submit+0x10/0x20
>>  [<ffffffff81432fd2>] system_call_fastpath+0x16/0x1b
>>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: Ming Lei <ming.lei@canonical.com>
>> Cc: Robert Elliott <Elliott@hp.com>
>> Cc: <stable@vger.kernel.org>
>> ---
>>  block/blk-mq-tag.c | 31 +++++++++++++++----------------
>>  1 file changed, 15 insertions(+), 16 deletions(-)
>>
>> diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
>> index b5088f0..08d3b1c 100644
>> --- a/block/blk-mq-tag.c
>> +++ b/block/blk-mq-tag.c
>> @@ -80,8 +80,7 @@ static void blk_mq_tag_wakeup_all(struct blk_mq_tags *tags)
>>  	for (i = 0; i < BT_WAIT_QUEUES; i++) {
>>  		struct bt_wait_state *bs = &bt->bs[wake_index];
>>  
>> -		if (waitqueue_active(&bs->wait))
>> -			wake_up(&bs->wait);
>> +		wake_up(&bs->wait);
>>  
>>  		wake_index = bt_index_inc(wake_index);
>>  	}
>> @@ -346,20 +345,20 @@ static void bt_clear_tag(struct blk_mq_bitmap_tags *bt, unsigned int tag)
>>  	 */
>>  	clear_bit_unlock(TAG_TO_BIT(bt, tag), &bt->map[index].word);
>>  
>> -	bs = bt_wake_ptr(bt);
>> -	if (!bs)
>> -		return;
>> -
>> -	wait_cnt = atomic_dec_return(&bs->wait_cnt);
>> -	if (wait_cnt == 0) {
>> -wake:
>> -		atomic_add(bt->wake_cnt, &bs->wait_cnt);
>> -		bt_index_atomic_inc(&bt->wake_index);
>> -		wake_up(&bs->wait);
>> -	} else if (wait_cnt < 0) {
>> -		wait_cnt = atomic_inc_return(&bs->wait_cnt);
>> -		if (!wait_cnt)
>> -			goto wake;
>> +	for (;;) {
>> +		bs = bt_wake_ptr(bt);
>> +		if (!bs)
>> +			return;
>> +
>> +		wait_cnt = atomic_dec_return(&bs->wait_cnt);
>> +		if (unlikely(wait_cnt < 0))
>> +			wait_cnt = atomic_inc_return(&bs->wait_cnt);
>> +		if (wait_cnt == 0) {
>> +			atomic_add(bt->wake_cnt, &bs->wait_cnt);
>> +			bt_index_atomic_inc(&bt->wake_index);
>> +			wake_up(&bs->wait);
>> +			return;
>> +		}
>>  	}
>>  }
> 
> I've been able to reproduce this this morning, and your patch does seem
> to fix it. The inc/add logic is making my head spin a bit. And we now
> end up banging a lot more on the waitqueue lock through
> prepare_to_wait(), so there's a substantial performance regression to go
> with the change.
> 
> I'll fiddle with this a bit and see if we can't retain existing
> performance properties under tag contention, while still fixing the hang.

So I think your patch fixes the issue because it just keeps decrementing
the wait counts, hence waking up a lot more than it should. This is also
why I see a huge increase in wait queue spinlock time.

Does this work for you? I think the issue is plainly that we end up
setting the batch counts too high. But tell me more about the number of
queues, the depth (total or per queue?), and the fio job you are running.

-- 
Jens Axboe


--------------060108000002090405050001
Content-Type: text/x-patch;
 name="blk-mq-tag-wake-depth.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="blk-mq-tag-wake-depth.patch"

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index c1b9242..74a4168 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -463,8 +463,8 @@ static void bt_update_count(struct blk_mq_bitmap_tags *bt,
 	}
 
 	bt->wake_cnt = BT_WAIT_BATCH;
-	if (bt->wake_cnt > depth / 4)
-		bt->wake_cnt = max(1U, depth / 4);
+	if (bt->wake_cnt > depth / BT_WAIT_QUEUES)
+		bt->wake_cnt = max(1U, depth / BT_WAIT_QUEUES);
 
 	bt->depth = depth;
 }

--------------060108000002090405050001--
