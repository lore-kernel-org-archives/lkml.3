Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbaBMDh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 22:37:28 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:3687 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751469AbaBMDh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 22:37:27 -0500
X-IronPort-AV: E=Sophos;i="4.95,836,1384272000"; 
   d="scan'208";a="9518008"
Message-ID: <52FC3C83.8020303@cn.fujitsu.com>
Date: Thu, 13 Feb 2014 11:31:15 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: jjherne@linux.vnet.ibm.com
CC: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: Subject: Warning in workqueue.c
References: <52F4F01C.1070800@linux.vnet.ibm.com> <20140207165113.GD3304@htj.dyndns.org> <52F51E10.8050208@linux.vnet.ibm.com> <20140207193604.GA8833@htj.dyndns.org> <52F8F0FB.3080206@linux.vnet.ibm.com> <20140210231742.GK25350@mtj.dyndns.org> <52FB90C6.4010701@linux.vnet.ibm.com>
In-Reply-To: <52FB90C6.4010701@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/13 11:26:47,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/13 11:35:10,
	Serialize complete at 2014/02/13 11:35:10
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2014 11:18 PM, Jason J. Herne wrote:
> On 02/10/2014 06:17 PM, Tejun Heo wrote:
>> Hello,
>>
>> On Mon, Feb 10, 2014 at 10:32:11AM -0500, Jason J. Herne wrote:
>>> [  950.778485] XXX: worker->flags=0x1 pool->flags=0x0 cpu=6
>>> pool->cpu=2 rescue_wq=          (null)
>>> [  950.778488] XXX: last_unbind=-7 last_rebind=0
>>> last_rebound_clear=0 nr_exected_after_rebound_clear=0
>>> [  950.778492] XXX: cpus_allowed=2
>>> [  950.778495] XXX: cpus_allowed_after_rebinding=2
>>
>> So, everything looks kosher from workqueue side.  Weird.  cpus_allowed
>> is properly set and everything.  The worker just isn't running on the
>> cpu it's supposed to be on.  Can you please try the following?
> 
> 
> Thanks for the fast responses. Here is the output from the last patch:
> 
> 
> [34437.173991] WARNING: at kernel/workqueue.c:2156
> [34437.173993] Modules linked in: ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack xt_CHECKSUM iptable_mangle bridge stp llc ip6table_filter ip6_tables ebtable_nat ebtables iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi qeth_l2 tape_3590 tape tape_class vhost_net tun vhost macvtap macvlan lcs dasd_eckd_mod dasd_mod qeth ccwgroup zfcp scsi_transport_fc scsi_tgt qdio dm_multipath [last unloaded: kvm]
> [34437.174030] CPU: 2 PID: 12 Comm: kworker/1:0 Not tainted 3.14.0-rc1 #1
> [34437.174034] task: 00000000f7c9e4c0 ti: 00000000f7cbc000 task.ti: 00000000f7cbc000
> [34437.174046] Krnl PSW : 0404c00180000000 000000000015b406 (process_one_work+0x61a/0x640)
> [34437.174051]            R:0 T:1 IO:0 EX:0 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 EA:3
> Krnl GPRS: 000000007c325b00 0000000000bc2a52 00000000f7f52780 0000000000000001
> [34437.174057]            0000000000000000 0000000000000002 0000000000000001 0000000000bc2a4e
> [34437.174061]            0000000000000000 0000000084a13500 0000000084a0f000 0000000084a0f018
> [34437.174065]            00000000f7f52780 0000000000735d18 00000000f7cbfdd0 00000000f7cbfd58
> [34437.174085] Krnl Code: 000000000015b3fa: 92013000        mvi    0(%r3),1
>            000000000015b3fe: a7f4ff31        brc    15,15b260
>           #000000000015b402: a7f40001        brc    15,15b404
>           >000000000015b406: 92011000        mvi    0(%r1),1
>            000000000015b40a: a7f4fe84        brc    15,15b112
>            000000000015b40e: 41102018        la    %r1,24(%r2)
>            000000000015b412: e31020180020    cg    %r1,24(%r2)
>            000000000015b418: a784ff59        brc    8,15b2ca
> [34437.174115] Call Trace:
> [34437.174118] ([<000000000015b0e0>] process_one_work+0x2f4/0x640)
> [34437.174122]  [<000000000015ba0e>] worker_thread+0x19a/0x3c0
> [34437.174126]  [<0000000000164842>] kthread+0x10e/0x128
> [34437.174132]  [<0000000000728e56>] kernel_thread_starter+0x6/0xc
> [34437.174136]  [<0000000000728e50>] kernel_thread_starter+0x0/0xc
> [34437.174138] Last Breaking-Event-Address:
> [34437.174141]  [<000000000015b402>] process_one_work+0x616/0x640
> [34437.174144] ---[ end trace 52d8ee96597a2415 ]---
> [34437.174148] XXX: worker->flags=0x1 pool->flags=0x0 cpu=2 pool->cpu=1(1) rescue_wq=          (null)
> [34437.174152] XXX: last_unbind=-34 last_rebind=0 last_rebound_clear=0 nr_exected_after_rebound_clear=0
> [34437.174156] XXX: cpus_allowed=1
> [34437.174158] XXX: cpus_allowed_after_rebinding=1
> [34437.174161] BUG: scheduling while atomic: kworker/1:0/12/0x00000002
> [34437.174164] Modules linked in: ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack xt_CHECKSUM iptable_mangle bridge stp llc ip6table_filter ip6_tables ebtable_nat ebtables iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi qeth_l2 tape_3590 tape tape_class vhost_net tun vhost macvtap macvlan lcs dasd_eckd_mod dasd_mod qeth ccwgroup zfcp scsi_transport_fc scsi_tgt qdio dm_multipath [last unloaded: kvm]
> [34437.174194] CPU: 2 PID: 12 Comm: kworker/1:0 Tainted: G        W 3.14.0-rc1 #1
> [34437.174197]        00000000f7cbfb80 00000000f7cbfb90 0000000000000002 0000000000000000
>        00000000f7cbfc20 00000000f7cbfb98 00000000f7cbfb98 0000000000115f6a
>        0000000000000003 0000000000c4da00 000000000000000a 000000000000000a
>        00000000f7cbfbe0 00000000f7cbfb80 0000000000000000 0000000000000000
>        0000000000000000 0000000000115f6a 00000000f7cbfb80 00000000f7cbfbd0
> [34437.174273] Call Trace:
> [34437.174279] ([<0000000000115e5c>] show_trace+0x100/0x148)
> [34437.174282]  [<0000000000115f18>] show_stack+0x74/0xf4
> [34437.174288]  [<0000000000720a9c>] dump_stack+0x88/0xb8
> [34437.174291]  [<000000000071aa40>] __schedule_bug+0x78/0x90
> [34437.174295]  [<00000000007237e4>] __schedule+0xb8c/0xbac
> [34437.174299]  [<000000000015b21e>] process_one_work+0x432/0x640
> [34437.174302]  [<000000000015ba0e>] worker_thread+0x19a/0x3c0
> [34437.174306]  [<0000000000164842>] kthread+0x10e/0x128
> [34437.174309]  [<0000000000728e56>] kernel_thread_starter+0x6/0xc
> [34437.174313]  [<0000000000728e50>] kernel_thread_starter+0x0/0xc
> [34437.174317] XXX: after schedule(), cpu=2

Could you use the following patch for test if Tejun doesn't give you a new one.

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index b010eac..cdd7a10 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -825,6 +825,7 @@ void wq_worker_waking_up(struct task_struct *task, int cpu)
 {
 	struct worker *worker = kthread_data(task);
 
+	worker->wake_up = jiffies;
 	if (!(worker->flags & WORKER_NOT_RUNNING)) {
 		WARN_ON_ONCE(worker->pool->cpu != cpu);
 		atomic_inc(&worker->pool->nr_running);
@@ -851,6 +852,7 @@ struct task_struct *wq_worker_sleeping(struct task_struct *task, int cpu)
 	struct worker *worker = kthread_data(task), *to_wakeup = NULL;
 	struct worker_pool *pool;
 
+	worker->sleep = jiffies;
 	/*
 	 * Rescuers, which may not have all the fields set up like normal
 	 * workers, also reach here, let's not access anything before
@@ -2134,6 +2136,7 @@ __acquires(&pool->lock)
 	bool cpu_intensive = pwq->wq->flags & WQ_CPU_INTENSIVE;
 	int work_color;
 	struct worker *collision;
+	int worker_bug = 0;
 #ifdef CONFIG_LOCKDEP
 	/*
 	 * It is permissible to free the struct work_struct from
@@ -2151,9 +2154,31 @@ __acquires(&pool->lock)
 	 * necessary to avoid spurious warnings from rescuers servicing the
 	 * unbound or a disassociated pool.
 	 */
-	WARN_ON_ONCE(!(worker->flags & WORKER_UNBOUND) &&
-		     !(pool->flags & POOL_DISASSOCIATED) &&
-		     raw_smp_processor_id() != pool->cpu);
+	if (WARN_ON_ONCE(!(worker->flags & WORKER_UNBOUND) &&
+			 !(pool->flags & POOL_DISASSOCIATED) &&
+			 raw_smp_processor_id() != pool->cpu)) {
+		static char buf[PAGE_SIZE];
+		unsigned long now = jiffies;
+
+		worker_bug = 1;
+		pr_warning("XXX: worker->flags=0x%x pool->flags=0x%x cpu=%d pool->cpu=%d(%d) rescue_wq=%p\n",
+			   worker->flags, pool->flags, raw_smp_processor_id(),
+			   pool->cpu, cpu_online(pool->cpu), worker->rescue_wq);
+		pr_warning("XXX: last_unbind=%ld last_rebind=%ld last_rebound_clear=%ld nr_exected_after_rebound_clear=%d\n",
+			   worker->last_unbind ? worker->last_unbind - now : 999,
+			   worker->last_rebind ? worker->last_rebind - now : 999,
+			   worker->last_rebound_clear ? worker->last_rebound_clear - now : 999,
+			   worker->nr_executed_after_rebound_clear);
+		pr_warning("XXX: sleep=%ld wakeup=%ld\n",
+			   worker->sleep ? worker->sleep - now : 999,
+			   worker->wake_up ? worker->wake_up - now : 999);
+
+		cpulist_scnprintf(buf, sizeof(buf), &current->cpus_allowed);
+		pr_warning("XXX: cpus_allowed=%s\n", buf);
+
+		cpulist_scnprintf(buf, sizeof(buf), &worker->cpus_allowed_after_rebinding);
+		pr_warning("XXX: cpus_allowed_after_rebinding=%s\n", buf);
+	}
 
 	/*
 	 * A single work shouldn't be executed concurrently by
@@ -2199,8 +2224,15 @@ __acquires(&pool->lock)
 	 */
 	set_work_pool_and_clear_pending(work, pool->id);
 
+	worker->nr_executed_after_rebound_clear++;
+
 	spin_unlock_irq(&pool->lock);
 
+	if (worker_bug) {
+		schedule();
+
+		pr_warning("XXX: after schedule(), cpu=%d\n", raw_smp_processor_id());
+	}
 	lock_map_acquire_read(&pwq->wq->lockdep_map);
 	lock_map_acquire(&lockdep_map);
 	trace_workqueue_execute_start(work);
@@ -2298,6 +2330,7 @@ woke_up:
 	}
 
 	worker_leave_idle(worker);
+	worker->wake_up = jiffies;
 recheck:
 	/* no more worker necessary? */
 	if (!need_more_worker(pool))
@@ -2321,6 +2354,10 @@ recheck:
 	 * management if applicable and concurrency management is restored
 	 * after being rebound.  See rebind_workers() for details.
 	 */
+	if (worker->flags & WORKER_REBOUND) {
+		worker->last_rebound_clear = jiffies;
+		worker->nr_executed_after_rebound_clear = 0;
+	}
 	worker_clr_flags(worker, WORKER_PREP | WORKER_REBOUND);
 
 	do {
@@ -2341,6 +2378,7 @@ recheck:
 
 	worker_set_flags(worker, WORKER_PREP, false);
 sleep:
+	worker->sleep = jiffies;
 	if (unlikely(need_to_manage_workers(pool)) && manage_workers(worker))
 		goto recheck;
 
@@ -4576,8 +4614,10 @@ static void wq_unbind_fn(struct work_struct *work)
 		 * before the last CPU down must be on the cpu.  After
 		 * this, they may become diasporas.
 		 */
-		for_each_pool_worker(worker, wi, pool)
+		for_each_pool_worker(worker, wi, pool) {
 			worker->flags |= WORKER_UNBOUND;
+			worker->last_unbind = jiffies;
+		}
 
 		pool->flags |= POOL_DISASSOCIATED;
 
@@ -4633,9 +4673,13 @@ static void rebind_workers(struct worker_pool *pool)
 	 * of all workers first and then clear UNBOUND.  As we're called
 	 * from CPU_ONLINE, the following shouldn't fail.
 	 */
-	for_each_pool_worker(worker, wi, pool)
+	for_each_pool_worker(worker, wi, pool) {
 		WARN_ON_ONCE(set_cpus_allowed_ptr(worker->task,
 						  pool->attrs->cpumask) < 0);
+		worker->last_rebind = jiffies;
+		cpumask_copy(&worker->cpus_allowed_after_rebinding,
+			     &worker->task->cpus_allowed);
+	}
 
 	spin_lock_irq(&pool->lock);
 
diff --git a/kernel/workqueue_internal.h b/kernel/workqueue_internal.h
index 7e2204d..db17e2c 100644
--- a/kernel/workqueue_internal.h
+++ b/kernel/workqueue_internal.h
@@ -50,6 +50,13 @@ struct worker {
 
 	/* used only by rescuers to point to the target workqueue */
 	struct workqueue_struct	*rescue_wq;	/* I: the workqueue to rescue */
+	unsigned long		last_unbind;
+	unsigned long		last_rebind;
+	unsigned long		sleep;
+	unsigned long		wake_up;
+	unsigned long		last_rebound_clear;
+	int			nr_executed_after_rebound_clear;
+	cpumask_t		cpus_allowed_after_rebinding;
 };
 
 /**

