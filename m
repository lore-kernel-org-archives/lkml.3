Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab3KSWnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 17:43:17 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51242 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886Ab3KSWnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 17:43:16 -0500
Message-ID: <528BE967.9070506@kernel.dk>
Date: Tue, 19 Nov 2013 15:42:47 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [Regression x2, 3.13-git] virtio block mq hang, iostat busted
 on virtio devices
References: <20131119080218.GJ11434@dastard> <20131119201531.GA4094@kernel.dk> <20131119212042.GB4094@kernel.dk> <20131119213429.GQ11434@dastard> <528BDB97.8090608@kernel.dk>
In-Reply-To: <528BDB97.8090608@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2013 02:43 PM, Jens Axboe wrote:
> On 11/19/2013 02:34 PM, Dave Chinner wrote:
>> On Tue, Nov 19, 2013 at 02:20:42PM -0700, Jens Axboe wrote:
>>> On Tue, Nov 19 2013, Jens Axboe wrote:
>>>> On Tue, Nov 19 2013, Dave Chinner wrote:
>>>>> Hi Jens,
>>>>>
>>>>> I was just running xfstests on a 3.13 kernel that has had the block
>>>>> layer changed merged into it. generic/269 on XFS is hanging on a 2
>>>>> CPU VM using virtio,cache=none for the block devices under test,
>>>>> with many (130+) threads stuck below submit_bio() like this:
>>>>>
>>>>>  Call Trace:
>>>>>   [<ffffffff81adb1c9>] schedule+0x29/0x70
>>>>>   [<ffffffff817833ee>] percpu_ida_alloc+0x16e/0x330
>>>>>   [<ffffffff81759bef>] blk_mq_wait_for_tags+0x1f/0x40
>>>>>   [<ffffffff81758bee>] blk_mq_alloc_request_pinned+0x4e/0xf0
>>>>>   [<ffffffff8175931b>] blk_mq_make_request+0x3bb/0x4a0
>>>>>   [<ffffffff8174d2b2>] generic_make_request+0xc2/0x110
>>>>>   [<ffffffff8174e40c>] submit_bio+0x6c/0x120
>>>>>
>>>>> reads and writes are hung, both data (direct and buffered) and
>>>>> metadata.
>>>>>
>>>>> Some IOs are sitting in io_schedule, waiting for IO completion (both
>>>>> buffered and direct IO, both reads and writes) so it looks like IO
>>>>> completion has stalled in some manner, too.
>>>>
>>>> Can I get a recipe to reproduce this? I haven't had any luck so far.
>>>
>>> OK, I reproduced it. Looks weird, basically all 64 commands are in
>>> flight, but haven't completed. So the next one that comes in just sits
>>> there forever. I can't find any sysfs debug entries for virtio, would be
>>> nice to inspect its queue as well...
>>
>> Does it have anything to do with the fact that the request queue
>> depth is 128 entries and the tag pool only has 66 tags in it? i.e:
>>
>> /sys/block/vdb/queue/nr_requests
>> 128
>>
>> /sys/block/vdb/mq/0/tags
>> nr_tags=66, reserved_tags=2, batch_move=16, max_cache=32
>> nr_free=0, nr_reserved=1
>>   cpu00: nr_free=0
>>   cpu01: nr_free=0
>>
>> Seems to imply that if we queue up more than 66 IOs without
>> dispatching them, we'll run out of tags. And without another IO
>> coming through, the "none" scheduler that virtio uses will never
>> get a trigger to push out the currently queued IO?
> 
> No, the nr_requests isn't actually relevant in the blk-mq context, the
> driver sets its own depth. For the above, it's 64 normal commands, and 2
> reserved. The reserved would be for a flush, for instance. If someone
> attempts to queue more than the allocated number of requests, it'll stop
> the blk-mq queue and kick things into gear on the virtio side. Then when
> requests complete, we start the queue again.
> 
> If you look at virtio_queue_rq(), that handles a single request. This
> request is already tagged at this point. If we can't add it to the ring,
> we simply stop the queue and kick off whatever pending we might have. We
> return BLK_MQ_RQ_QUEUE_BUSY to blk-mq, which tells that to back off on
> sending us more. When we get the virtblk_done() callback from virtio, we
> end the requests on the blk-mq side and restart the queue.

I added some debug code to see if we had anything pending on the blk-mq
side, and it's all empty. It really just looks like we are missing
completions on the virtio side. Very odd.

-- 
Jens Axboe

