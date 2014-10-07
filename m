Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbaJGOoN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 10:44:13 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:37258 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbaJGOoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 10:44:10 -0400
Message-ID: <5433FC36.30806@kernel.dk>
Date: Tue, 07 Oct 2014 08:44:06 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Bart Van Assche <bvanassche@acm.org>
CC: Christoph Hellwig <hch@lst.de>, Robert Elliott <Elliott@hp.com>,
        Ming Lei <ming.lei@canonical.com>, Sagi Grimberg <sagig@mellanox.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] blk-mq: Avoid that I/O hangs in bt_get()
References: <54328A97.3030201@acm.org> <5432D414.4060408@kernel.dk> <5432E524.90407@kernel.dk> <5433A85E.2070207@acm.org>
In-Reply-To: <5433A85E.2070207@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2014 02:46 AM, Bart Van Assche wrote:
> On 10/06/14 20:53, Jens Axboe wrote:
>> On 10/06/2014 11:40 AM, Jens Axboe wrote:
>>> I've been able to reproduce this this morning, and your patch does seem
>>> to fix it. The inc/add logic is making my head spin a bit. And we now
>>> end up banging a lot more on the waitqueue lock through
>>> prepare_to_wait(), so there's a substantial performance regression to go
>>> with the change.
>>>
>>> I'll fiddle with this a bit and see if we can't retain existing
>>> performance properties under tag contention, while still fixing the hang.
>>
>> So I think your patch fixes the issue because it just keeps decrementing
>> the wait counts, hence waking up a lot more than it should. This is also
>> why I see a huge increase in wait queue spinlock time.
>>
>> Does this work for you? I think the issue is plainly that we end up
>> setting the batch counts too high. But tell me more about the number of
>> queues, the depth (total or per queue?), and the fio job you are running.
> 
> Hello Jens,
> 
> Thanks for looking into this. I can't reproduce the I/O lockup after 
> having reverted my patch and after having applied your patch. In the 
> test I ran fio was started with the following command-line options:
>  
> fio --bs=512 --ioengine=libaio --rw=randread --buffered=0 --numjobs=12 
> --iodepth=128 --iodepth_batch=64 --iodepth_batch_complete=64 --thread 
> --norandommap --loops=2147483648 --runtime=3600 --group_reporting 
> --gtod_reduce=1 --name=/dev/sdo --filename=/dev/sdo --invalidate=1
> 
> This job was run on a system with 12 CPU threads and against a SCSI 
> initiator driver for which the number of hardware contexts had been set 
> to 6. Queue depth per hardware queue was set to 127:
> $ cat /sys/class/scsi_host/host10/can_queue
> 127
> 
> This is what fio reports about the average queue depth:
> 
> IOdepths: 1=0.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=100.0%
>   submit: 0=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=100.0%, >=64=0.0%
> complete: 0=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=100.0%, >=64=0.0%

Great, so that makes sense to me. I'll get the patch applied and marked
for stable. I'll mark it as fixes commit 4bb659b156996.

> 
> While we are at it, how about the patch below ? That patch shouldn't
> change any functionality but should make bt_clear_tag() slightly easier
> to read.

Agree, that looks cleaner and is more readable.

-- 
Jens Axboe

