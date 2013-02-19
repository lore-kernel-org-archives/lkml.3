Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736Ab3BSRjn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 12:39:43 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:47718 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229Ab3BSRjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 12:39:41 -0500
Date: Tue, 19 Feb 2013 09:39:37 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [GIT PULL] workqueue core changes for 3.9-rc1
Message-ID: <20130219173937.GM17414@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

This is pull request for workqueue core changes.  A lot of
reorganization is going on mostly to prepare for worker pools with
custom attributes so that workqueue can replace custom pool
implementations in places including writeback and btrfs and make CPU
assignment in crypto more flexible.

workqueue evolved from purely per-cpu design and implementation, so
there are a lot of assumptions regarding being bound to CPUs and even
unbound workqueues are implemented as an extension of the model -
workqueues running on the special unbound CPU.  Bulk of changes this
round are about promoting worker_pools as the top level abstraction
replacing global_cwq (global cpu workqueue).  At this point, I'm
fairly confident about getting custom worker pools working pretty
soon and ready for the next merge window.

Lai's patches are replacing the convoluted mb() dancing workqueue has
been doing with much simpler mechanism which only depends on
assignment atomicity of long.  For details, please read the commit
message of 0b3dae68ac ("workqueue: simplify is-work-item-queued-here
test").  While the change ends up adding one pointer to struct
delayed_work, the inflation in percentage is less than five percent
and it decouples delayed_work logic a lot more cleaner from usual work
handling, removes the unusual memory barrier dancing, and allows for
further simplification, so I think the trade-off is acceptable.

There will be two more workqueue related pull requests and there are
some shared commits among them.  I'll write further pull requests
assuming this pull request is pulled first.

The above described changes (and some one-off ones) are available in
the following git branch

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.9

for you to fetch changes up to 112202d9098aae2c36436e5178c0cf3ced423c7b:

  workqueue: rename cpu_workqueue to pool_workqueue (2013-02-13 19:29:12 -0800)

----------------------------------------------------------------
Lai Jiangshan (7):
      workqueue: replace WORK_CPU_NONE/LAST with WORK_CPU_END
      workqueue: make work_busy() test WORK_STRUCT_PENDING first
      workqueue: add delayed_work->wq to simplify reentrancy handling
      workqueue: make work->data point to pool after try_to_grab_pending()
      workqueue: simplify is-work-item-queued-here test
      workqueue: make get_work_pool_id() cheaper
      workqueue: pick cwq instead of pool in __queue_work()

Sasha Levin (1):
      workqueue: use new hashtable implementation

Tejun Heo (28):
      workqueue: consider work function when searching for busy work items
      workqueue: fix find_worker_executing_work() brekage from hashtable conversion
      workqueue: set PF_WQ_WORKER on rescuers
      workqueue: rename kernel/workqueue_sched.h to kernel/workqueue_internal.h
      workqueue: move struct worker definition to workqueue_internal.h
      workqueue: implement current_is_async()
      workqueue: unexport work_cpu()
      workqueue: use std_ prefix for the standard per-cpu pools
      workqueue: make GCWQ_DISASSOCIATED a pool flag
      workqueue: make GCWQ_FREEZING a pool flag
      workqueue: introduce WORK_OFFQ_CPU_NONE
      workqueue: add worker_pool->id
      workqueue: record pool ID instead of CPU in work->data when off-queue
      workqueue: move busy_hash from global_cwq to worker_pool
      workqueue: move global_cwq->cpu to worker_pool
      workqueue: move global_cwq->lock to worker_pool
      workqueue: make hotplug processing per-pool
      workqueue: make freezing/thawing per-pool
      workqueue: replace for_each_worker_pool() with for_each_std_worker_pool()
      workqueue: remove worker_pool->gcwq
      workqueue: remove global_cwq
      workqueue: rename nr_running variables
      workqueue: post global_cwq removal cleanups
      workqueue: cosmetic update in try_to_grab_pending()
      workqueue: move nr_running into worker_pool
      workqueue: fix is_chained_work() regression
      workqueue: reimplement is_chained_work() using current_wq_worker()
      workqueue: rename cpu_workqueue to pool_workqueue

 include/linux/async.h            |    1 +
 include/linux/workqueue.h        |   35 +-
 include/trace/events/workqueue.h |   10 +-
 kernel/async.c                   |   14 +
 kernel/sched/core.c              |    2 +-
 kernel/workqueue.c               | 1528 ++++++++++++++++++--------------------
 kernel/workqueue_internal.h      |   65 ++
 kernel/workqueue_sched.h         |    9 -
 8 files changed, 817 insertions(+), 847 deletions(-)
 create mode 100644 kernel/workqueue_internal.h
 delete mode 100644 kernel/workqueue_sched.h

Thanks.

--
tejun
