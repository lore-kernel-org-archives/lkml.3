Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab3JGSHM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 14:07:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18049 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212Ab3JGSHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 14:07:06 -0400
Date: Mon, 7 Oct 2013 14:03:22 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Akira Hayakawa <ruby.wktk@gmail.com>
cc: dm-devel@redhat.com, devel@driverdev.osuosl.org, thornber@redhat.com,
        snitzer@redhat.com, gregkh@linuxfoundation.org, david@fromorbit.com,
        linux-kernel@vger.kernel.org, dan.carpenter@oracle.com,
        joe@perches.com, akpm@linux-foundation.org, m.chehab@samsung.com,
        ejt@redhat.com, agk@redhat.com, cesarb@cesarb.net, tj@kernel.org
Subject: Re: A review of dm-writeboost
In-Reply-To: <52515BD6.5000701@gmail.com>
Message-ID: <alpine.LRH.2.02.1310071327390.19115@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1310031719340.24440@file01.intranet.prod.int.rdu2.redhat.com> <52515BD6.5000701@gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 6 Oct 2013, Akira Hayakawa wrote:

> Mikulas,
> 
> Thank you for your reviewing.
> 
> I will reply to polling issue first.
> For the rest, I will reply later.
> 
> > Polling for state
> > -----------------
> > 
> > Some of the kernel threads that you spawn poll for data in one-second 
> > interval - see migrate_proc, modulator_proc, recorder_proc, sync_proc.
> > 
> > flush_proc correctly contains wait_event, but there is still some 100ms 
> > polling timeout in flush_proc that shouldn't be there.
> > 
> > If you set the polling interval too low, it wastes CPU cycle and it wastes 
> > energy due to CPU wake-ups. If you set the polling interval too high, it 
> > causes artifical delays. For example, current middle-class SSDs can do 
> > writes at a rate 500MB/s. Now, think that the user uses 400MB partition 
> > for the cache - the partition is filled up in 0.8s and the kernel waits 
> > for additional 0.2s doing absolutely nothing, until your polling code 
> > wakes up and notices that it should start flusing the cache.
> > 
> > So - the polling code introduces artifical delays that can cause 
> > performance degradation. You may think about lowering the polling interval 
> > to lessen the performance impact, but if you lower the polling interval, 
> > it increases CPU and power consumption when the driver is idle. Either 
> > way, it is wrong. Just don't use polling.
> 
> You dislike the fact that looping thread sleeping
> can delay to the newly coming jobs.
> 
> I am afraid your understanding
> on the sleeping of flush daemon is wrong.
> Please see queue_flushing() it wakes up the daemon
> if the queue is empty.
> 
> spin_lock_irqsave(&cache->flush_queue_lock, flags);
> empty = list_empty(&cache->flush_queue);        
> list_add_tail(&job->flush_queue, &cache->flush_queue);
> spin_unlock_irqrestore(&cache->flush_queue_lock, flags);
> if (empty)
>         wake_up_interruptible(&cache->flush_wait_queue);
> 
> Even if this waking up lines are removed
> the flush daemon wakes up by its self
> 100ms at worst after the first 1MB written.

flush_proc is woken up correctly. But the other threads aren't. 
migrate_proc, modulator_proc, recorder_proc, sync_proc all do polling.

Waking up every 100ms in flush_proc is not good because it wastes CPU time 
and energy if the driver is idle.


BTW. You should use wait_event_interruptible_lock_irq instead of 
wait_event_interruptible and wait_event_interruptible_lock_irq_timeout 
instead of wait_event_interruptible_timeout. The functions with "lock_irq" 
automatically drop and re-acquire the spinlock, so that the condition is 
tested while the lock is held - so that there are no asynchronous accesses 
to !list_empty(&cache->flush_queue).


> > Don't do this. You can do polling in a piece of code that is executed 
> > infrequently, such as driver unload, but general functionality must not 
> > depend on polling.
> 100ms is the time the user must wait in termination as your claim.
>
> However, I think this is a good time to
> explain why I didn't choose to use workqueue.
> 
> Keeping it a polling thread that consumes what in queue
> instead of replacing it with workqueue
> has these reasons:
> 
> 1. CPU overhead is lower
>    queue_work overhead everytime flush job is to queue
>    is crucial for writeboost. queue_work is too CPU-consuming
>    as far as I looked at the code.
>    I have measured the theoretical maximum 4KB randwrite throughput  
>    of writeboost using fio benchmark. It was 1.5GB/sec
>    with fast enough cache device.
>    I don't think this extraordinary score can not be achieved with
>    other caching softwares.
>    In this benchmark, the flush daemon didn't sleep at all
>    because the writes are ceaseless.
>    Using workqueue will not only lose throughput
>    but also wastes CPU cycles both regularly is the fact I dislike.
> 2. Ease of Error Handling
>    Keeping it a single thread looping and self-managing the queue
>    makes it easy to handle error.
>    If we choose to use workqueue, we need a mechanism to
>    * notify the occurrence of a error to other work items
>    * play-back the work items in the same order since waiting until the
>      system recovers for long time is prohibited with workqueue
>      as we discussed in the previous posts.
>      Segments must be flushed and then migrated in sequential
>      order along its id.
>    Leaving the control of the queue which should be in desired order
>    to the workqueue subsystem is dangerous in this case.

You don't have to use workqueues if you don't like them. You can use 
kernel threads and wait_event/wake_up instead. Workqueues are simpler to 
use in some circumstances (for example, you can submit the same work item 
multiple times) but it's up to you if you want that simplicity or not.

But you shouldn't do looping and waiting for events in migrate_proc.

> For migrate_proc,
> I see no reason this daemon polling is bad
> although it actually sleeps in leisure time.
> In using writeboost, we can obviously assume that
> the sequential write throughput of cache device is much higher
> than the random write throughput of the backing store
> so migrate daemon is unlikely to sleep
> since there are many dirty segments to migrate
> is the ordinary situation.

The problem is that if you fill up the whole cache device in less time 
than 1 second. Then, you are waiting for 1 second until the migration 
process notices that it has some work to do. That waiting is pointless and 
degrades performance - the new write requests received by your driver sit 
in queue_current_buffer, waiting for data to be migrated. And the 
migration process sits in 
schedule_timeout_interruptible(msecs_to_jiffies(1000)), waiting for the 
end of the timeout. Your driver does absolutely nothing in this moment.

For this reason, you should wake the migration process as soon as 
it is needed.

> Furthermore, since migration daemon is more one block
> off from the user (upper layer) than flush daemon
> the one second sleeping problem gets weaker or diluted.
> If you still dislike the delay of this daemon
> I think of forcefully waking up the daemon if it is sleeping
> like flush daemon.
> 
> One last thing.
> The power consumption in idle time is the only shortcoming
> of polling.

The other shortcoming is performance degradation. If you decrease polling 
time, you improve performance, but increase power consumption. If you 
increase polling time, you avoid performance degradation, but you increase 
power consumption.

Either decreasing or increasing the polling time is wrong.

> But who cares the power consumption of 
> waking up once a second and checking a queue is empty?
> 
> Akira

Mikulas
