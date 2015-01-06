Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536AbbAFOD5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 09:03:57 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:21919 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692AbbAFODz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 09:03:55 -0500
To: peterz@infradead.org
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched/fair: Fix RCU stall upon ENOMEM atsched_create_group().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201412252210.GCC30204.SOMVFFOtQJFLOH@I-love.SAKURA.ne.jp>
	<20150106103533.GO29390@twins.programming.kicks-ass.net>
In-Reply-To: <20150106103533.GO29390@twins.programming.kicks-ass.net>
Message-Id: <201501062303.AHB00565.HJLtQVFOMSOOFF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 6 Jan 2015 23:03:18 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Thu, Dec 25, 2014 at 10:10:45PM +0900, Tetsuo Handa wrote:
> > >From 052595ab1a1d1c5668d9de61395c9cc17694597e Mon Sep 17 00:00:00 2001
> > From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> > Date: Thu, 25 Dec 2014 15:51:21 +0900
> > Subject: [PATCH] sched/fair: Fix RCU stall upon ENOMEM at sched_create_group().
> > 
> > When alloc_fair_sched_group() in sched_create_group() failed,
> > free_sched_group() is called, and free_fair_sched_group() is called by
> > free_sched_group(). Since destroy_cfs_bandwidth() is called by
> > free_fair_sched_group() without calling init_cfs_bandwidth(),
> > RCU stall occurs at hrtimer_cancel().
> > 
> 
> Thanks
> 

Oops, I didn't notice this member depends on CONFIG_CFS_BANDWIDTH=y.

   kernel/sched/fair.c: In function 'free_fair_sched_group':
>> kernel/sched/fair.c:7945:11: error: 'struct cfs_bandwidth' has no member named 'throttled_cfs_rq'
     if (cfs_b->throttled_cfs_rq.next)
              ^

Here is updated patch.
----------
>From e812151aad03fb225211093987b575e690814fd3 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Tue, 6 Jan 2015 22:52:16 +0900
Subject: [PATCH] sched/fair: Fix RCU stall upon ENOMEM at sched_create_group().

When alloc_fair_sched_group() in sched_create_group() failed,
free_sched_group() is called, and free_fair_sched_group() is called by
free_sched_group(). Since destroy_cfs_bandwidth() is called by
free_fair_sched_group() without calling init_cfs_bandwidth(),
RCU stall occurs at hrtimer_cancel().

  INFO: rcu_sched self-detected stall on CPU { 1}  (t=60000 jiffies g=13074 c=13073 q=0)
  Task dump for CPU 1:
  (fprintd)       R  running task        0  6249      1 0x00000088
   ffffffff81c47d40 ffff88007fc43d78 ffffffff81094988 0000000000000001
   ffffffff81c47d40 ffff88007fc43d98 ffffffff81097acd ffff88007fc43dd8
   0000000000000002 ffff88007fc43dc8 ffffffff810c3a80 ffff88007fc4d840
  Call Trace:
   <IRQ>  [<ffffffff81094988>] sched_show_task+0xa8/0x110
   [<ffffffff81097acd>] dump_cpu_task+0x3d/0x50
   [<ffffffff810c3a80>] rcu_dump_cpu_stacks+0x90/0xd0
   [<ffffffff810c7751>] rcu_check_callbacks+0x491/0x700
   [<ffffffff810cbf2b>] update_process_times+0x4b/0x80
   [<ffffffff810db046>] tick_sched_handle.isra.20+0x36/0x50
   [<ffffffff810db0a2>] tick_sched_timer+0x42/0x70
   [<ffffffff810ccb19>] __run_hrtimer+0x69/0x1a0
   [<ffffffff810db060>] ? tick_sched_handle.isra.20+0x50/0x50
   [<ffffffff810ccedf>] hrtimer_interrupt+0xef/0x230
   [<ffffffff810452cb>] local_apic_timer_interrupt+0x3b/0x70
   [<ffffffff8164a465>] smp_apic_timer_interrupt+0x45/0x60
   [<ffffffff816485bd>] apic_timer_interrupt+0x6d/0x80
   <EOI>  [<ffffffff810cc588>] ? lock_hrtimer_base.isra.23+0x18/0x50
   [<ffffffff81193cf1>] ? __kmalloc+0x211/0x230
   [<ffffffff810cc9d2>] hrtimer_try_to_cancel+0x22/0xd0
   [<ffffffff81193cf1>] ? __kmalloc+0x211/0x230
   [<ffffffff810ccaa2>] hrtimer_cancel+0x22/0x30
   [<ffffffff810a3cb5>] free_fair_sched_group+0x25/0xd0
   [<ffffffff8108df46>] free_sched_group+0x16/0x40
   [<ffffffff810971bb>] sched_create_group+0x4b/0x80
   [<ffffffff810aa383>] sched_autogroup_create_attach+0x43/0x1c0
   [<ffffffff8107dc9c>] sys_setsid+0x7c/0x110
   [<ffffffff81647729>] system_call_fastpath+0x12/0x17

Check whether init_cfs_bandwidth() was called before calling
destroy_cfs_bandwidth(). Use #ifdef because tg_cfs_bandwidth() returns
NULL and destroy_cfs_bandwidth() is a no-op if CONFIG_CFS_BANDWIDTH=n.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 kernel/sched/fair.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index df2cdf7..017fe22 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7938,8 +7938,14 @@ static void task_move_group_fair(struct task_struct *p, int queued)
 void free_fair_sched_group(struct task_group *tg)
 {
 	int i;
+#ifdef CONFIG_CFS_BANDWIDTH
+	struct cfs_bandwidth *cfs_b;
 
-	destroy_cfs_bandwidth(tg_cfs_bandwidth(tg));
+	/* Check whether init_cfs_bandwidth() was called. */
+	cfs_b = tg_cfs_bandwidth(tg);
+	if (cfs_b->throttled_cfs_rq.next)
+		destroy_cfs_bandwidth(cfs_b);
+#endif
 
 	for_each_possible_cpu(i) {
 		if (tg->cfs_rq)
-- 
1.8.3.1
