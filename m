Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933336Ab3GPPvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 11:51:39 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41107 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932590Ab3GPPvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 11:51:38 -0400
Date: Tue, 16 Jul 2013 17:50:40 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Ingo Molnar <mingo@redhat.com>, pjt@google.com,
        linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH v2] sched: move h_load calculation to task_h_load
Message-ID: <20130716155040.GO23818@dyad.programming.kicks-ass.net>
References: <20130715105950.GA23818@dyad.programming.kicks-ass.net>
 <1373896159-1278-1-git-send-email-vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373896159-1278-1-git-send-email-vdavydov@parallels.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 05:49:19PM +0400, Vladimir Davydov wrote:
> The bad thing about update_h_load(), which computes hierarchical load
> factor for task groups, is that it is called for each task group in the
> system before every load balancer run, and since rebalance can be
> triggered very often, this function can eat really a lot of cpu time if
> there are many cpu cgroups in the system.
> 
> Although the situation was improved significantly by commit a35b646
> ('sched, cgroup: Reduce rq->lock hold times for large cgroup
> hierarchies'), the problem still can arise under some kinds of loads,
> e.g. when cpus are switching from idle to busy and back very frequently.
> 
> For instance, when I start 1000 of processes that wake up every
> millisecond on my 8 cpus host, 'top' and 'perf top' show:
> 
> Cpu(s): 17.8%us, 24.3%sy,  0.0%ni, 57.9%id,  0.0%wa,  0.0%hi,  0.0%si
> Events: 243K cycles
>   7.57%  [kernel]               [k] __schedule
>   7.08%  [kernel]               [k] timerqueue_add
>   6.13%  libc-2.12.so           [.] usleep
> 
> Then if I create 10000 *idle* cpu cgroups (no processes in them), cpu
> usage increases significantly although the 'wakers' are still executing
> in the root cpu cgroup:
> 
> Cpu(s): 19.1%us, 48.7%sy,  0.0%ni, 31.6%id,  0.0%wa,  0.0%hi,  0.7%si
> Events: 230K cycles
>  24.56%  [kernel]            [k] tg_load_down
>   5.76%  [kernel]            [k] __schedule
> 
> This happens because this particular kind of load triggers 'new idle'
> rebalance very frequently, which requires calling update_h_load(),
> which, in turn, calls tg_load_down() for every *idle* cpu cgroup even
> though it is absolutely useless, because idle cpu cgroups have no tasks
> to pull.
> 
> This patch tries to improve the situation by making h_load calculation
> proceed only when h_load is really necessary. To achieve this, it
> substitutes update_h_load() with update_cfs_rq_h_load(), which computes
> h_load only for a given cfs_rq and all its ascendants, and makes the
> load balancer call this function whenever it considers if a task should
> be pulled, i.e. it moves h_load calculations directly to task_h_load().
> For h_load of the same cfs_rq not to be updated multiple times (in case
> several tasks in the same cgroup are considered during the same balance
> run), the patch keeps the time of the last h_load update for each cfs_rq
> and breaks calculation when it finds h_load to be uptodate.
> 
> The benefit of it is that h_load is computed only for those cfs_rq's,
> which really need it, in particular all idle task groups are skipped.
> Although this, in fact, moves h_load calculation under rq lock, it
> should not affect latency much, because the amount of work done under rq
> lock while trying to pull tasks is limited by sched_nr_migrate.
> 
> After the patch applied with the setup described above (1000 wakers in
> the root cgroup and 10000 idle cgroups), I get:
> 
> Cpu(s): 16.9%us, 24.8%sy,  0.0%ni, 58.4%id,  0.0%wa,  0.0%hi,  0.0%si
> Events: 242K cycles
>   7.57%  [kernel]                  [k] __schedule
>   6.70%  [kernel]                  [k] timerqueue_add
>   5.93%  libc-2.12.so              [.] usleep
> 
> Changes in v2:
>  * use jiffies instead of rq->clock for last_h_load_update.
> 
> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>

Thanks!
