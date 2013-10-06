Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab3JFMr1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 08:47:27 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:34550 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab3JFMrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 08:47:25 -0400
Message-ID: <52515BD6.5000701@gmail.com>
Date: Sun, 06 Oct 2013 21:47:18 +0900
From: Akira Hayakawa <ruby.wktk@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: mpatocka@redhat.com
CC: dm-devel@redhat.com, devel@driverdev.osuosl.org, thornber@redhat.com,
        snitzer@redhat.com, gregkh@linuxfoundation.org, david@fromorbit.com,
        linux-kernel@vger.kernel.org, dan.carpenter@oracle.com,
        joe@perches.com, akpm@linux-foundation.org, m.chehab@samsung.com,
        ejt@redhat.com, agk@redhat.com, cesarb@cesarb.net, tj@kernel.org,
        ruby.wktk@gmail.com
Subject: Re: A review of dm-writeboost
References: <alpine.LRH.2.02.1310031719340.24440@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.1310031719340.24440@file01.intranet.prod.int.rdu2.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikulas,

Thank you for your reviewing.

I will reply to polling issue first.
For the rest, I will reply later.

> Polling for state
> -----------------
> 
> Some of the kernel threads that you spawn poll for data in one-second 
> interval - see migrate_proc, modulator_proc, recorder_proc, sync_proc.
> 
> flush_proc correctly contains wait_event, but there is still some 100ms 
> polling timeout in flush_proc that shouldn't be there.
> 
> If you set the polling interval too low, it wastes CPU cycle and it wastes 
> energy due to CPU wake-ups. If you set the polling interval too high, it 
> causes artifical delays. For example, current middle-class SSDs can do 
> writes at a rate 500MB/s. Now, think that the user uses 400MB partition 
> for the cache - the partition is filled up in 0.8s and the kernel waits 
> for additional 0.2s doing absolutely nothing, until your polling code 
> wakes up and notices that it should start flusing the cache.
> 
> So - the polling code introduces artifical delays that can cause 
> performance degradation. You may think about lowering the polling interval 
> to lessen the performance impact, but if you lower the polling interval, 
> it increases CPU and power consumption when the driver is idle. Either 
> way, it is wrong. Just don't use polling.

You dislike the fact that looping thread sleeping
can delay to the newly coming jobs.

I am afraid your understanding
on the sleeping of flush daemon is wrong.
Please see queue_flushing() it wakes up the daemon
if the queue is empty.

spin_lock_irqsave(&cache->flush_queue_lock, flags);
empty = list_empty(&cache->flush_queue);        
list_add_tail(&job->flush_queue, &cache->flush_queue);
spin_unlock_irqrestore(&cache->flush_queue_lock, flags);
if (empty)
        wake_up_interruptible(&cache->flush_wait_queue);

Even if this waking up lines are removed
the flush daemon wakes up by its self
100ms at worst after the first 1MB written.

> Don't do this. You can do polling in a piece of code that is executed 
> infrequently, such as driver unload, but general functionality must not 
> depend on polling.
100ms is the time the user must wait in termination as your claim.

However, I think this is a good time to
explain why I didn't choose to use workqueue.

Keeping it a polling thread that consumes what in queue
instead of replacing it with workqueue
has these reasons:

1. CPU overhead is lower
   queue_work overhead everytime flush job is to queue
   is crucial for writeboost. queue_work is too CPU-consuming
   as far as I looked at the code.
   I have measured the theoretical maximum 4KB randwrite throughput  
   of writeboost using fio benchmark. It was 1.5GB/sec
   with fast enough cache device.
   I don't think this extraordinary score can not be achieved with
   other caching softwares.
   In this benchmark, the flush daemon didn't sleep at all
   because the writes are ceaseless.
   Using workqueue will not only lose throughput
   but also wastes CPU cycles both regularly is the fact I dislike.
2. Ease of Error Handling
   Keeping it a single thread looping and self-managing the queue
   makes it easy to handle error.
   If we choose to use workqueue, we need a mechanism to
   * notify the occurrence of a error to other work items
   * play-back the work items in the same order since waiting until the
     system recovers for long time is prohibited with workqueue
     as we discussed in the previous posts.
     Segments must be flushed and then migrated in sequential
     order along its id.
   Leaving the control of the queue which should be in desired order
   to the workqueue subsystem is dangerous in this case.

For migrate_proc,
I see no reason this daemon polling is bad
although it actually sleeps in leisure time.
In using writeboost, we can obviously assume that
the sequential write throughput of cache device is much higher
than the random write throughput of the backing store
so migrate daemon is unlikely to sleep
since there are many dirty segments to migrate
is the ordinary situation.
Furthermore, since migration daemon is more one block
off from the user (upper layer) than flush daemon
the one second sleeping problem gets weaker or diluted.
If you still dislike the delay of this daemon
I think of forcefully waking up the daemon if it is sleeping
like flush daemon.

> First, you must design some event model - (a bunch of threads polling in 1 
> second interval doesn't seem viable). For example, you can use workqueues 
> correctly this way:
> 
> * You create a workqueue for migration, but you don't submit any work to 
>   it.
> * If you fill the cache device above the watermark, you submit a work item 
>   to the migration workqueue (you can submit the same work item to the 
>   same workqueue multiple times - if the work item is still queued and 
>   hasn't started executing, the second submit is ignored; if the work item 
>   has started executing, the second submit causes that it is executed once
>   more).
> * The work item does a little bit of work, it finds data to be migrated, 
>   submits the bios to do the migration and exits. (you can use dm-kcopyd 
>   to do actual migration, it simplifies your code)
> * If you need more migration, you just submit the work item again.
> 
> If you design it this way, you avoid the polling timers (migration starts 
> as soon as it is needed) and also you avoid the problem with the looping 
> workqueue.
The reason 2 in why I don't choose workqueue
can be reused in designing migration daemon and
I believe keeping it a single thread looping is the best
if we have to care error handling.

dm-kcopyd seems to be a good choice for simplifying the code.
I remember that I discarded this option
for some reason before but I don't remember the reason.
I am thinking of reconsidering this issue and
maybe I can eventually reach to using kcopyd
because the design is changed a lot since that time.

> to lessen the performance impact, but if you lower the polling interval, 
> it increases CPU and power consumption when the driver is idle. Either 
> way, it is wrong. Just don't use polling.
One last thing.
The power consumption in idle time is the only shortcoming
of polling.
But who cares the power consumption of 
waking up once a second and checking a queue is empty?

Akira
