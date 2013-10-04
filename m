Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab3JDNjK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 09:39:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753531Ab3JDNjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 09:39:09 -0400
Date: Fri, 4 Oct 2013 09:38:50 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Akira Hayakawa <ruby.wktk@gmail.com>
cc: dm-devel@redhat.com, devel@driverdev.osuosl.org, thornber@redhat.com,
        snitzer@redhat.com, gregkh@linuxfoundation.org, david@fromorbit.com,
        linux-kernel@vger.kernel.org, dan.carpenter@oracle.com,
        joe@perches.com, akpm@linux-foundation.org, m.chehab@samsung.com,
        ejt@redhat.com, agk@redhat.com, cesarb@cesarb.net, tj@kernel.org
Subject: Re: [dm-devel] dm-writeboost testing
In-Reply-To: <524E27DD.2050809@gmail.com>
Message-ID: <alpine.LRH.2.02.1310040923320.8473@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1310021125150.19199@file01.intranet.prod.int.rdu2.redhat.com> <524E27DD.2050809@gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 4 Oct 2013, Akira Hayakawa wrote:

> Hi, Mikulas,
> 
> I am sorry to say that
> I don't have such machines to reproduce the problem.
> 
> But agree with that I am dealing with workqueue subsystem
> in a little bit weird way.
> I should clean them up.
> 
> For example,
> free_cache() routine below is
> a deconstructor of the cache metadata
> including all the workqueues.
> 
> void free_cache(struct wb_cache *cache)
> {
>         cache->on_terminate = true;
> 
>         /* Kill in-kernel daemons */
>         cancel_work_sync(&cache->sync_work);
>         cancel_work_sync(&cache->recorder_work);
>         cancel_work_sync(&cache->modulator_work);
> 
>         cancel_work_sync(&cache->flush_work);
>         destroy_workqueue(cache->flush_wq);
> 
>         cancel_work_sync(&cache->barrier_deadline_work);
> 
>         cancel_work_sync(&cache->migrate_work);
>         destroy_workqueue(cache->migrate_wq);
>         free_migration_buffer(cache);
> 
>         /* Destroy in-core structures */
>         free_ht(cache);
>         free_segment_header_array(cache);
> 
>         free_rambuf_pool(cache);
> }
> 
> cancel_work_sync() before destroy_workqueue()
> can probably be removed because destroy_workqueue() first
> flush all the works.
> 
> Although I prepares independent workqueue
> for each flush_work and migrate_work
> other four works are queued into the system_wq
> through schedule_work() routine.
> This asymmetricity is not welcome for
> architecture-portable code.
> Dependencies to the subsystem should be minimized.
> In detail, workqueue subsystem is really changing
> about its concurrency support so
> trusting only the single threaded workqueue
> will be a good idea for stability.

The problem is that you are using workqueues the wrong way. You submit a 
work item to a workqueue and the work item is active until the device is 
unloaded.

If you submit a work item to a workqueue, it is required that the work 
item finishes in finite time. Otherwise, it may stall stall other tasks. 
The deadlock when I terminate Xserver is caused by this - the nvidia 
driver tries to flush system workqueue and it waits for all work items to 
terminate - but your work items don't terminate.

If you need a thread that runs for a long time, you should use 
kthread_create, not workqueues (see this 
http://people.redhat.com/~mpatocka/patches/kernel/dm-crypt-paralelizace/old-3/dm-crypt-encryption-threads.patch 
or this 
http://people.redhat.com/~mpatocka/patches/kernel/dm-crypt-paralelizace/old-3/dm-crypt-offload-writes-to-thread.patch 
as an example how to use kthreads).

Mikulas

> To begin with,
> these works are never out of queue
> until the deconstructor is called
> but they are repeating running and sleeping.
> Queuing these kind of works to system_wq
> may be unsupported.
> 
> So,
> my strategy is to clean them up in a way that
> 1. all daemons are having their own workqueue
> 2. never use cancel_work_sync() but only calls destroy_workqueue()
>    in the deconstructor free_cache() and error handling in resume_cache().
> 
> Could you please run the same test again
> after I fixed these points
> to see whether it is still reproducible?
> 
> 
> > On 3.11.3 on PA-RISC without preemption, the device unloads (although it 
> > takes many seconds and vmstat shows that the machine is idle during this 
> > time)
> This behavior is benign but probably should be improved.
> In said free_cache() it first turns `on_terminate` flag to true
> to notify all the daemons that we are shutting down.
> Since the `update_interval` and `sync_interval` are 60 seconds by default
> we must wait for them to finish for a while.
> 
> Akira
> 
