Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbaC2PPV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 11:15:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbaC2PPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 11:15:18 -0400
Date: Sat, 29 Mar 2014 11:15:03 -0400
From: Dave Jones <davej@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: perf lockdep trace.
Message-ID: <20140329151503.GA14249@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Back home, and back to breaking things..

 ======================================================
 [ INFO: possible circular locking dependency detected ]
 3.14.0-rc8+ #153 Not tainted
 -------------------------------------------------------
 trinity-c3/2014 is trying to acquire lock:
  (&rq->lock){-.-.-.}, at: [<ffffffff9a0bf75c>] unregister_fair_sched_group+0x5c/0xd0
 
but task is already holding lock:
  (&ctx->lock){-.....}, at: [<ffffffff9a173fe9>] perf_event_exit_task+0x109/0x260
 
which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #1 (&ctx->lock){-.....}:
        [<ffffffff9a0d1951>] lock_acquire+0x91/0x1c0
        [<ffffffff9a7b3bf0>] _raw_spin_lock+0x40/0x80
        [<ffffffff9a16f8fc>] __perf_event_task_sched_out+0x11c/0x3c0
        [<ffffffff9a0a7b93>] perf_event_task_sched_out+0xb3/0xc0
        [<ffffffff9a7ae2d4>] __schedule+0x1e4/0x9c0
        [<ffffffff9a7af01e>] schedule_user+0x2e/0xa0
        [<ffffffff9a7b4da4>] retint_careful+0x12/0x2e
 
-> #0 (&rq->lock){-.-.-.}:
        [<ffffffff9a0d0dee>] __lock_acquire+0x181e/0x1bd0
        [<ffffffff9a0d1951>] lock_acquire+0x91/0x1c0
        [<ffffffff9a7b3dfb>] _raw_spin_lock_irqsave+0x4b/0x90
        [<ffffffff9a0bf75c>] unregister_fair_sched_group+0x5c/0xd0
        [<ffffffff9a0b3cfa>] sched_offline_group+0x3a/0xe0
        [<ffffffff9a0c6cc7>] sched_autogroup_exit+0x47/0x60
        [<ffffffff9a06b6a9>] __put_task_struct+0xb9/0x130
        [<ffffffff9a169c45>] put_ctx+0x55/0x60
        [<ffffffff9a17400e>] perf_event_exit_task+0x12e/0x260
        [<ffffffff9a07022d>] do_exit+0x33d/0xd40
        [<ffffffff9a07207c>] do_group_exit+0x4c/0xc0
        [<ffffffff9a072104>] SyS_exit_group+0x14/0x20
        [<ffffffff9a7bda64>] tracesys+0xdd/0xe2
 
other info that might help us debug this:

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(&ctx->lock);
                                lock(&rq->lock);
                                lock(&ctx->lock);
   lock(&rq->lock);
 
 *** DEADLOCK ***

 1 lock held by trinity-c3/2014:
  #0:  (&ctx->lock){-.....}, at: [<ffffffff9a173fe9>] perf_event_exit_task+0x109/0x260
 
stack backtrace:
 CPU: 3 PID: 2014 Comm: trinity-c3 Not tainted 3.14.0-rc8+ #153
  ffffffff9b5efc70 00000000128a256a ffff88009ce09c08 ffffffff9a7a8da2
  ffffffff9b5efc70 ffff88009ce09c48 ffffffff9a7a4e66 ffff88009ce09ca0
  ffff88023ec94180 0000000000000000 ffff88023ec94148 ffff88023ec94180
 Call Trace:
  [<ffffffff9a7a8da2>] dump_stack+0x4e/0x7a
  [<ffffffff9a7a4e66>] print_circular_bug+0x201/0x20f
  [<ffffffff9a0d0dee>] __lock_acquire+0x181e/0x1bd0
  [<ffffffff9a7a7119>] ? cmpxchg_double_slab.isra.57+0xdb/0x116
  [<ffffffff9a0d1951>] lock_acquire+0x91/0x1c0
  [<ffffffff9a0bf75c>] ? unregister_fair_sched_group+0x5c/0xd0
  [<ffffffff9a7b3dfb>] _raw_spin_lock_irqsave+0x4b/0x90
  [<ffffffff9a0bf75c>] ? unregister_fair_sched_group+0x5c/0xd0
  [<ffffffff9a0bf75c>] unregister_fair_sched_group+0x5c/0xd0
  [<ffffffff9a0b3cfa>] sched_offline_group+0x3a/0xe0
  [<ffffffff9a0c6cc7>] sched_autogroup_exit+0x47/0x60
  [<ffffffff9a06b6a9>] __put_task_struct+0xb9/0x130
  [<ffffffff9a169c45>] put_ctx+0x55/0x60
  [<ffffffff9a17400e>] perf_event_exit_task+0x12e/0x260
  [<ffffffff9a7b8e0b>] ? preempt_count_sub+0x6b/0xf0
  [<ffffffff9a07022d>] do_exit+0x33d/0xd40
  [<ffffffff9a07207c>] do_group_exit+0x4c/0xc0
  [<ffffffff9a072104>] SyS_exit_group+0x14/0x20
  [<ffffffff9a7bda64>] tracesys+0xdd/0xe2

