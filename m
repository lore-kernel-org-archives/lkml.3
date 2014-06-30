Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986AbaF3PUl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 11:20:41 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:41233 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbaF3PUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:20:39 -0400
Message-ID: <53B18053.2030805@kernel.dk>
Date: Mon, 30 Jun 2014 09:20:51 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Bart Van Assche <bvanassche@fusionio.com>, Robert Elliott <Elliott@hp.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Mason <clm@fb.com>
Subject: Re: scsi-mq V2
References: <1403715121-1201-1-git-send-email-hch@lst.de> <53ABA6A4.8090400@kernel.dk>
In-Reply-To: <53ABA6A4.8090400@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2014 10:50 PM, Jens Axboe wrote:
> On 2014-06-25 10:51, Christoph Hellwig wrote:
>> This is the second post of the scsi-mq series.
>>
>> At this point the code is ready for merging and use by developers and
>> early
>> adopters.  The core blk-mq code isn't that suitable for slow devices
>> yet, mostly due to the lack of an I/O scheduler, but Jens is working
>> on it.
>> Similarly there is no dm-multipath support for drivers using blk-mq yet,
>> but I'm working on it.  It should also be noted that the code doesn't
>> actually support multiple hardware queues or fine grained tuning of the
>> blk-mq parameters yet.  All these could be added fairly easily as soon
>> as low-level drivers want to make use of them.
>>
>> The amount of chances to the existing code are fairly small, and mostly
>> speedups or cleanups that also apply to the old path as well.  Because
>> of this I also haven't bothered to put it under a config option, just
>> like the blk-mq core.
>>
>> The usage of blk-mq dramatically decreases CPU usage under all
>> workloads going
>> down from 100% CPU usage that the old setup can hit easily to usually
>> less
>> than 20% for maxing out storage subsystems with 512byte reads and writes,
>> and it allows to easily archive millions of IOPS.  Bart and Robert have
>> helped with some very detailed measurements that they might be able to
>> send
>> in reply to this, although these usually involve significantly
>> reworked low
>> level drivers to avoid other bottle necks.
>>
>> One major objection to previous iterations of this code was the simple
>> replacement of the host_lock with atomic counters for the host and busy
>> counters.  The host_lock avoidance on it's own already improves
>> performance,
>> and with the patch to avoid maintaining the per-target busy counter
>> unless
>> needed we now replace a lock round trip on the host_lock with just a
>> single
>> atomic increment in the submission path, and a single atomic decrement in
>> completion path, which should provide benefits even for the oddest RISC
>> architecture.  Longer term I'd still love to get rid of these entirely
>> and use the counters in blk-mq, but due to the difference in how they
>> are maintained this doesn't seem feasible as long as we still need to
>> support the legacy request code path.
>>
>> Changes from V1:
>>   - rebased on top of the core-for-3.17 branch, most notable the
>>     scsi logging changes
>>   - fixed handling of cmd_list to prevent crashes for some heavy
>>     workloads
>>   - fixed incorrect handling of !target->can_queue
>>   - avoid scheduling a workqueue on I/O completions when no queues
>>     are congested
>>
>> In addition to the patches in this thread there also is a git
>> available at:
>>
>>     git://git.infradead.org/users/hch/scsi.git scsi-mq.2
> 
> You can add my acked/reviewed-by to the series.

Ran stress testing from Friday to now, 65h of beating up on it and no
problems observed. 47TB read and 20TB written for a total of 17.7
billion of IOs issued and completed. Latencies look good. I officially
declare this code for bug free.

Bug-free-by: Jens Axboe <axboe@fb.com>

Now lets get this queued up for inclusion, pretty please.

-- 
Jens Axboe

