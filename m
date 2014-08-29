Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbaH2KlZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 06:41:25 -0400
Received: from relay.parallels.com ([195.214.232.42]:42214 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbaH2KlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 06:41:23 -0400
Message-ID: <540058CB.2030704@parallels.com>
Date: Fri, 29 Aug 2014 14:41:15 +0400
From: Maxim Patlasov <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Zach Brown <zab@zabbo.net>
CC: Ming Lei <ming.lei@canonical.com>, Benjamin LaHaise <bcrl@kvack.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Kent Overstreet <kmo@daterainc.com>,
        open list:
	AIO <linux-aio@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>, ;
Illegal-Object: Syntax error in CC: address found on vger.kernel.org:
	CC:	;
			^-missing semicolon to end mail group, extraneous tokens in mailbox, missing end of mailbox
Subject: Re: [PATCH v1 5/9] block: loop: convert to blk-mq
In-Reply-To: 20140827175605.GE12827@lenny.home.zabbo.net
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.22.200]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/28/14, Zach Brown<zab@zabbo.net>  wrote:

> On Wed, Aug 27, 2014 at 09:19:36PM +0400, Maxim Patlasov wrote:
>> On 08/27/2014 08:29 PM, Benjamin LaHaise wrote:
>>> On Wed, Aug 27, 2014 at 08:08:59PM +0400, Maxim Patlasov wrote:
>>> ...
>>>> 1) /dev/loop0 of 3.17.0-rc1 with Ming's patches applied -- 11K iops
>>>> 2) the same as above, but call loop_queue_work() directly from
>>>> loop_queue_rq() -- 270K iops
>>>> 3) /dev/nullb0 of 3.17.0-rc1 -- 380K iops
>>>>
>>>> Taking into account so big difference (11K vs. 270K), would it be
>>>> worthy
>>>> to implement pure non-blocking version of aio_kernel_submit() returning
>>>> error if blocking needed? Then loop driver (or any other in-kernel
>>>> user)
>>>> might firstly try that non-blocking submit as fast-path, and, only if
>>>> it's failed, fall back to queueing.
>>> What filesystem is the backing file for loop0 on?  O_DIRECT access as
>>> Ming's patches use should be non-blocking, and if not, that's something
>>> to fix.
>> I used loop0 directly on top of null_blk driver (because my goal was to
>> measure the overhead of processing requests in a separate thread).
> The relative overhead while doing nothing else.  While zooming way down
> in to micro benchmarks is fun and all, testing on an fs on brd might be
> more representitive and so more compelling.

The measurements on an fs on brd are even more outrageous (the same fio 
script I posted a few messages above):

1) Baseline. no loopback device involved.

fio on /dev/ram0:                           467K iops
fio on ext4 over /dev/ram0:                 378K iops

2) Loopback device from 3.17.0-rc1 with Ming's patches (v1) applied:

fio on /dev/loop0 over /dev/ram0:            10K iops
fio on ext4 over /dev/loop0 over /dev/ram0:   9K iops

3) the same as above, but avoid extra context switch (call 
loop_queue_work() directly from loop_queue_rq()):

fio on /dev/loop0 over /dev/ram0:           267K iops
fio on ext4 over /dev/loop0 over /dev/ram0: 223K iops

The problem is not about huge relative overhead while doing nothing 
else. It's rather about introducing extra latency (~100 microseconds on 
commodity h/w I used) which might be noticeable on modern SSDs (and h/w 
RAIDs with caching).

Thanks,
Maxim
