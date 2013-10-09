Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab3JICob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 22:44:31 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:33039 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab3JICo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 22:44:29 -0400
Message-ID: <5254C305.5000005@gmail.com>
Date: Wed, 09 Oct 2013 11:44:21 +0900
From: Akira Hayakawa <ruby.wktk@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: mpatocka@redhat.com
CC: dm-devel@redhat.com, devel@driverdev.osuosl.org, thornber@redhat.com,
        snitzer@redhat.com, cesarb@cesarb.net, gregkh@linuxfoundation.org,
        david@fromorbit.com, linux-kernel@vger.kernel.org, tj@kernel.org,
        agk@redhat.com, joe@perches.com, akpm@linux-foundation.org,
        ejt@redhat.com, dan.carpenter@oracle.com, m.chehab@samsung.com,
        ruby.wktk@gmail.com
Subject: Re: [dm-devel] A review of dm-writeboost
References: <alpine.LRH.2.02.1310031719340.24440@file01.intranet.prod.int.rdu2.redhat.com> <52515BD6.5000701@gmail.com> <alpine.LRH.2.02.1310071327390.19115@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.1310071327390.19115@file01.intranet.prod.int.rdu2.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikulas,

> Waking up every 100ms in flush_proc is not good because it wastes CPU time 
> and energy if the driver is idle.
Yes, 100ms is too short. I will change it to 1sec then.
We can wait for 1 sec in termination.

> The problem is that if you fill up the whole cache device in less time 
> than 1 second. Then, you are waiting for 1 second until the migration 
> process notices that it has some work to do. That waiting is pointless and 
> degrades performance - the new write requests received by your driver sit 
> in queue_current_buffer, waiting for data to be migrated. And the 
> migration process sits in 
> schedule_timeout_interruptible(msecs_to_jiffies(1000)), waiting for the 
> end of the timeout. Your driver does absolutely nothing in this moment.
> 
> For this reason, you should wake the migration process as soon as 
> it is needed.
I see the reason. I agree.

Migration is not restlessly executed in writeboost.
The cache device is full and needs migration to make room for new writes
is "urgent" situation.
Setting reserving_segment_id to non-zero can tell
migration daemon that the migration is urgent.

There is also a non-urgent migration
when the backing store is loaded lower than threshold.
Restlessly migrating to the backing store may affect the
whole system. For example, it may defer the read request
to the backing store.
So, migrating only in idle time can be a good strategy.

> Pointless modulator_proc
> ------------------------
> 
> This thread does no work, it just turns cache->allow_migrate on and off. 
> Thus, the thread is useless, you can just remove it. In the place where 
> you read cache->allow_migrate (in migrate_proc) you could just do the work 
> that used to be performed in modulator_proc.
Sure, it turns the flag on and off, and this daemon is needful.
This daemon calculates the load of the backing store then
moving this code to migrate_proc and do the same thing
every loop is too CPU consuming.
Make a decision every second seems to be reasonable.

However, some system doesn't want to delay migration at all
because the backing store has a large write back cache
and wants it filled for its optimization
(e.g. reordering) to be effective.
In this case, setting both enable_migration_modulator 
and allow_migrate to 0 will do.

Also, note that related to migration
nr_max_batched_migration can determine how many segments
can be migrated at a time.

Back to the urgent migration,
the problem can be solved easily.
How about inserting waking up the migration daemon
just after reserving_segment_id to non-zero.
It is similar to waking up flush daemon when it queues a flush job.

void wait_for_migration(struct wb_cache *cache, u64 id)
{
        struct segment_header *seg = get_segment_header_by_id(cache, id);

        /*
         * Set reserving_segment_id to non zero
         * to force the migartion daemon
         * to complete migarate of this segment
         * immediately.
         */
        cache->reserving_segment_id = id;
        // HERE
        wait_for_completion(&seg->migrate_done);
        cache->reserving_segment_id = 0;
}

> flush_proc is woken up correctly. But the other threads aren't. 
> migrate_proc, modulator_proc, recorder_proc, sync_proc all do polling.
For other daemons,
modulator: turns on and off according to the load of the backing store every second (default ON)
recorder: update the super block record every T seconds (default T=60)
sync: make all the transient data persistent every T seconds (default T=60)

They are just looping themselves.

Maybe, recorder and sync should be turned off for default.
- Recorder daemon is just for fast rebooting. The record section contains
  the last_migrated_segment_id which is used in recover_cache()
  to decrease the segments to recover.
- Sync daemon is for SLA in enterprise. Some user want to
  make the storage system persistent every given period.
  This is needless intrinsically. So, turning it off by default is appropriate.

Akira
