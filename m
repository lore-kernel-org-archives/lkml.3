Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962AbaGHTVh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:21:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54292 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755740AbaGHTIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:42 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Johannes Weiner" <hannes@cmpxchg.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Tang Chen" <tangchen@cn.fujitsu.com>,
        "Yasuaki Ishimatsu" <isimatu.yasuaki@jp.fujitsu.com>,
        "Gu Zheng" <guz.fnst@cn.fujitsu.com>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.918602925@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 063/125] mm: vmscan: clear kswapd's special reclaim
 powers before exiting
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Weiner <hannes@cmpxchg.org>

commit 71abdc15adf8c702a1dd535f8e30df50758848d2 upstream.

When kswapd exits, it can end up taking locks that were previously held
by allocating tasks while they waited for reclaim.  Lockdep currently
warns about this:

On Wed, May 28, 2014 at 06:06:34PM +0800, Gu Zheng wrote:
>  inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-R} usage.
>  kswapd2/1151 [HC0[0]:SC0[0]:HE1:SE1] takes:
>   (&sig->group_rwsem){+++++?}, at: exit_signals+0x24/0x130
>  {RECLAIM_FS-ON-W} state was registered at:
>     mark_held_locks+0xb9/0x140
>     lockdep_trace_alloc+0x7a/0xe0
>     kmem_cache_alloc_trace+0x37/0x240
>     flex_array_alloc+0x99/0x1a0
>     cgroup_attach_task+0x63/0x430
>     attach_task_by_pid+0x210/0x280
>     cgroup_procs_write+0x16/0x20
>     cgroup_file_write+0x120/0x2c0
>     vfs_write+0xc0/0x1f0
>     SyS_write+0x4c/0xa0
>     tracesys+0xdd/0xe2
>  irq event stamp: 49
>  hardirqs last  enabled at (49):  _raw_spin_unlock_irqrestore+0x36/0x70
>  hardirqs last disabled at (48):  _raw_spin_lock_irqsave+0x2b/0xa0
>  softirqs last  enabled at (0):  copy_process.part.24+0x627/0x15f0
>  softirqs last disabled at (0):            (null)
>
>  other info that might help us debug this:
>   Possible unsafe locking scenario:
>
>         CPU0
>         ----
>    lock(&sig->group_rwsem);
>    <Interrupt>
>      lock(&sig->group_rwsem);
>
>   *** DEADLOCK ***
>
>  no locks held by kswapd2/1151.
>
>  stack backtrace:
>  CPU: 30 PID: 1151 Comm: kswapd2 Not tainted 3.10.39+ #4
>  Call Trace:
>    dump_stack+0x19/0x1b
>    print_usage_bug+0x1f7/0x208
>    mark_lock+0x21d/0x2a0
>    __lock_acquire+0x52a/0xb60
>    lock_acquire+0xa2/0x140
>    down_read+0x51/0xa0
>    exit_signals+0x24/0x130
>    do_exit+0xb5/0xa50
>    kthread+0xdb/0x100
>    ret_from_fork+0x7c/0xb0

This is because the kswapd thread is still marked as a reclaimer at the
time of exit.  But because it is exiting, nobody is actually waiting on
it to make reclaim progress anymore, and it's nothing but a regular
thread at this point.  Be tidy and strip it of all its powers
(PF_MEMALLOC, PF_SWAPWRITE, PF_KSWAPD, and the lockdep reclaim state)
before returning from the thread function.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/vmscan.c | 3 +++
 1 file changed, 3 insertions(+)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3016,7 +3016,10 @@ static int kswapd(void *p)
 		}
 	}
 
+	tsk->flags &= ~(PF_MEMALLOC | PF_SWAPWRITE | PF_KSWAPD);
 	current->reclaim_state = NULL;
+	lockdep_clear_current_reclaim_state();
+
 	return 0;
 }
 

