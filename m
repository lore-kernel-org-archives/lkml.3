Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933662AbaFQP6z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 11:58:55 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:58642 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933221AbaFQP54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 11:57:56 -0400
Date: Tue, 17 Jun 2014 11:57:52 -0400
From: Tejun Heo <tj@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        acme@ghostprotocols.net, paulus@samba.org,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: perf/workqueue: lockdep warning on process exit
Message-ID: <20140617155752.GD31819@htj.dyndns.org>
References: <539EFE3A.7020700@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <539EFE3A.7020700@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jun 16, 2014 at 10:24:58AM -0400, Sasha Levin wrote:
> [  430.429005] ======================================================
> [  430.429005] [ INFO: possible circular locking dependency detected ]
> [  430.429005] 3.15.0-next-20140613-sasha-00026-g6dd125d-dirty #654 Not tainted
> [  430.429005] -------------------------------------------------------
> [  430.429005] trinity-c578/9725 is trying to acquire lock:
> [  430.429005] (&(&pool->lock)->rlock){-.-...}, at: __queue_work (kernel/workqueue.c:1346)
> [  430.429005]
> [  430.429005] but task is already holding lock:
> [  430.429005] (&ctx->lock){-.....}, at: perf_event_exit_task (kernel/events/core.c:7471 kernel/events/core.c:7533)
> [  430.439509]
> [  430.439509] which lock already depends on the new lock.
> [  430.439509]
> [  430.439509]
> [  430.439509] the existing dependency chain (in reverse order) is:
> [  430.439509]
> -> #3 (&ctx->lock){-.....}:
...
> -> #2 (&rq->lock){-.-.-.}:
...
> -> #1 (&p->pi_lock){-.-.-.}:
...
> -> #0 (&(&pool->lock)->rlock){-.-...}:
...
> [  430.450111] other info that might help us debug this:
> [  430.450111]
> [  430.450111] Chain exists of:
> &(&pool->lock)->rlock --> &rq->lock --> &ctx->lock
> 
> [  430.450111]  Possible unsafe locking scenario:
> [  430.450111]
> [  430.450111]        CPU0                    CPU1
> [  430.450111]        ----                    ----
> [  430.450111]   lock(&ctx->lock);
> [  430.450111]                                lock(&rq->lock);
> [  430.450111]                                lock(&ctx->lock);
> [  430.450111]   lock(&(&pool->lock)->rlock);
> [  430.450111]
> [  430.450111]  *** DEADLOCK ***
> [  430.450111]
> [  430.450111] 1 lock held by trinity-c578/9725:
> [  430.450111] #0: (&ctx->lock){-.....}, at: perf_event_exit_task (kernel/events/core.c:7471 kernel/events/core.c:7533)
> [  430.450111]
> [  430.450111] stack backtrace:
> [  430.450111] CPU: 6 PID: 9725 Comm: trinity-c578 Not tainted 3.15.0-next-20140613-sasha-00026-g6dd125d-dirty #654
> [  430.450111]  ffffffffadb45840 ffff880101787848 ffffffffaa511b1c 0000000000000003
> [  430.450111]  ffffffffadb8a4c0 ffff880101787898 ffffffffaa5044e2 0000000000000001
> [  430.450111]  ffff880101787928 ffff880101787898 ffff8800aed98cf8 ffff8800aed98000
> [  430.450111] Call Trace:
> [  430.450111] dump_stack (lib/dump_stack.c:52)
> [  430.450111] print_circular_bug (kernel/locking/lockdep.c:1216)
> [  430.450111] __lock_acquire (kernel/locking/lockdep.c:1840 kernel/locking/lockdep.c:1945 kernel/locking/lockdep.c:2131 kernel/locking/lockdep.c:3182)
> [  430.450111] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
> [  430.450111] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
> [  430.450111] __queue_work (kernel/workqueue.c:1346)
> [  430.450111] queue_work_on (kernel/workqueue.c:1424)
> [  430.450111] free_object (lib/debugobjects.c:209)
> [  430.450111] __debug_check_no_obj_freed (lib/debugobjects.c:715)
> [  430.450111] debug_check_no_obj_freed (lib/debugobjects.c:727)
> [  430.450111] kmem_cache_free (mm/slub.c:2683 mm/slub.c:2711)
> [  430.450111] free_task (kernel/fork.c:221)
> [  430.450111] __put_task_struct (kernel/fork.c:250)
> [  430.450111] put_ctx (include/linux/sched.h:1855 kernel/events/core.c:898)
> [  430.450111] perf_event_exit_task (kernel/events/core.c:907 kernel/events/core.c:7478 kernel/events/core.c:7533)
> [  430.450111] do_exit (kernel/exit.c:766)

So, perf_event_exit_task() ends up freeing perf_events under
perf_event_context->lock which may nest inside rq lock.  With
SLAB_DEBUG_OBJECTS enabled, sl?b calls into debugobjects which in turn
call into workqueue for its internal management.  This leads to
possible deadlock as workqueue is now being invoked under a lock which
nests under rq lock.

This is a really low level feature invoking high level debugging
facility leading to possible deadlocks.  I don't know why it showed up
now and there may be better ways but the default thing to do seems to
be turning off SLAB_DEBUG_OBJECTS for perf_events.

Thanks.

-- 
tejun
