Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241AbaLHR7T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 12:59:19 -0500
Received: from sf1.bxl.stone.is ([87.238.167.36]:46980 "EHLO sf1.bxl.stone.is"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755000AbaLHR7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 12:59:17 -0500
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
Message-ID: <5485E6EC.3030501@acm.org>
Date: Mon, 08 Dec 2014 18:59:08 +0100
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: Christoph Hellwig <hch@lst.de>, Robert Elliott <Elliott@hp.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] blk-mq: Avoid that I/O hangs in bt_get()
References: <54328A97.3030201@acm.org> <5432D414.4060408@kernel.dk> <5432E524.90407@kernel.dk> <5433A85E.2070207@acm.org> <545B7A6D.8040208@acm.org> <5485BBD2.4040103@acm.org> <5485D6B0.3060901@kernel.dk>
In-Reply-To: <5485D6B0.3060901@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Filter-ID: s0sct1PQhAABKnZB5plbIYrcAt68paBzxGNV4bZScc8DDDH9IcRzs4ldqK5vEMwbuZt+PpRPW1h0
 yigPev+a+0IH1r+MXIsiQIovLy1C/Q9kR+vd8RcnMtIipX97qEvSTHVzM6LFZfR2MCqK4xRbWTJy
 0TnZwXPOV+X+NrCvBfi3wL2Y4F0412ezGCyTUPanO2cvvJsPGAKsAtoK+MVPygs0dgixl+GnJcx/
 9FDUoOnUlSqy5KMBlrW1d9fHnkNjCAVXc6LZSdPTNOfw38s0s1FfEoXm0/FPF8PR0w363lmHqMEy
 dAx7LKTGBzBGt6dfyGUvT6k9PPf/BbHQFSmtD2vvcf/z1qxv6F6PVXsOSYkvCsd+5e7BEVONeGno
 7KkTy4RDa/CXWzeXNjWtT5qz4VSqeZhBqz8nR05j/2nHmzoDYjOnyexsJ2zOx1IDltOC67dyYJUv
 zBvt/v8maDfvp7qWaJB7Vag9M+StoOcFIS85DB1NnhVJVBYBFJ7Rf6wEDMWDwTd37F6kUiTf/gb0
 MKsA/k03B9kvx4+nrbrM1yp0Wiri3vMVSxza3+BtngT9Rta7pp1tbckhtJIUkl4lhlIxef5Osv7g
 WWQW3tnvs02Ay+i2XM7H4FgTQ34SsZEoGplHcpVCCoX989hgB8R+yFp9/qpHX/a9a7RQwySlNdia
 E5tc/GqyB3xXEI9+04dYTRaB0dlb9inm85LMKG/w6gNTXSMrSFHHlIYXUvutwWg=
X-Report-Abuse-To: spam@sf1.bxl.stone.is
X-Filter-Fingerprint: IFrWXGses7OKB5S5G8/dJR8Z5VD7FZiiT9tK6RAzQuhA3cTUQ1R++keuE7RDJ8Kg3RbMLUalw1oC
 mj99/u+PoqoVy8a3lsStJtAvpObFX0Wok1JBYnOLzfRIhlEHQynLUpndEJ0YoaLytXXo8BMTaX2p
 Mk7LBarWD9Fj4R3eIu5cOy/3Wm9qfF/CZNvP/2Kowv61T+KDYyYtREgszdyFwv8IxCB3p/oCKvxr
 eyISh3JGb7OS5oVgiO+kDxZrVPLz3MmEGC2PrUKqLq5WmHK+Nw==
X-Originating-IP: 87.238.167.34
X-SpamExperts-Domain: stone.is
X-SpamExperts-Username: 87.238.167.34
Authentication-Results: bxl.stone.is; auth=pass smtp.auth=87.238.167.34
X-SpamExperts-Outgoing-Class: ham
X-SpamExperts-Outgoing-Evidence: Combined (0.04)
X-Recommended-Action: accept
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/14 17:49, Jens Axboe wrote:
> On 12/08/2014 07:55 AM, Bart Van Assche wrote:
>> diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
>> index 67ab88b..e88af88 100644
>> --- a/block/blk-mq-tag.c
>> +++ b/block/blk-mq-tag.c
>> @@ -256,6 +256,8 @@ static int bt_get(struct blk_mq_alloc_data *data,
>>               break;
>>           }
>>
>> +        blk_mq_run_hw_queue(hctx, false);
>> +
>>           blk_mq_put_ctx(data->ctx);
>>
>>           io_schedule();
> 
> Ah yes, that could be an issue for some cases, we do need to run the 
> queue there. For a tag map shared across hardware queues, we might need 
> to run more than just the current queue, however. For now we can safely 
> assume that we allocate fairly, so it should not be an issue.
> 
> It might be worth experimenting with doing a __bt_get() after the queue 
> run before going to sleep, in case the queue run found completions as well.

Unless anyone objects I will start testing the following patch:

[PATCH] blk-mq: Fix bt_get() hang

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
---
 block/blk-mq-tag.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index c22491e..14ab120 100644
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

