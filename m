Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445AbaJOMbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 08:31:47 -0400
Received: from relay.parallels.com ([195.214.232.42]:55692 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbaJOMbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 08:31:45 -0400
Message-ID: <1413376300.24793.55.camel@tkhai>
Subject: [PATCH RFC] sched: Revert delayed_put_task_struct() and fix use
 after free
From: Kirill Tkhai <ktkhai@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Kirill Tkhai <tkhai@yandex.ru>
Date: Wed, 15 Oct 2014 16:31:40 +0400
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This WARN_ON_ONCE() placed into __schedule() triggers warning:

@@ -2852,6 +2852,7 @@ static void __sched __schedule(void)

 	if (likely(prev != next)) {
 		rq->nr_switches++;
+		WARN_ON_ONCE(atomic_read(&prev->usage) == 1);
 		rq->curr = next;
 		++*switch_count;

	WARNING: CPU: 2 PID: 6497 at kernel/sched/core.c:2855 __schedule+0x656/0x8a0()
	Modules linked in:
	CPU: 2 PID: 6497 Comm: cat Not tainted 3.17.0+ #3
	Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
	 0000000000000009 ffff88022f50bdd8 ffffffff81518c78 0000000000000004
	 0000000000000000 ffff88022f50be18 ffffffff8104b1ac ffff88022f50be18
	 ffff880239912b40 ffff88022e5720d0 0000000000000002 0000000000000000
	Call Trace:
	 [<ffffffff81518c78>] dump_stack+0x4f/0x7c
	 [<ffffffff8104b1ac>] warn_slowpath_common+0x7c/0xa0
	 [<ffffffff8104b275>] warn_slowpath_null+0x15/0x20
	 [<ffffffff8151bad6>] __schedule+0x656/0x8a0
	 [<ffffffff8151bd44>] schedule+0x24/0x70
	 [<ffffffff8104c7aa>] do_exit+0x72a/0xb40
	 [<ffffffff81071b31>] ? get_parent_ip+0x11/0x50
	 [<ffffffff8104da6a>] do_group_exit+0x3a/0xa0
	 [<ffffffff8104dadf>] SyS_exit_group+0xf/0x10
	 [<ffffffff8151fe92>] system_call_fastpath+0x12/0x17
	---[ end trace d07155396c4faa0c ]---

This means the final put_task_struct() happens against RCU rules.
Regarding to scheduler this may be a reason of use-after-free.

    task_numa_compare()                    schedule()
        rcu_read_lock()                        ...
        cur = ACCESS_ONCE(dst_rq->curr)        ...
            ...                                rq->curr = next;
            ...                                    context_switch()
            ...                                        finish_task_switch()
            ...                                            put_task_struct()
            ...                                                __put_task_struct()
            ...                                                    free_task_struct()
            task_numa_assign()                                     ...
                get_task_struct()                                  ...

If other subsystems have a similar link to task, then the problem is also possible
there.

Delayed put_task_struct() was introduced in 8c7904a00b06:
"task: RCU protect task->usage" at "Fri Mar 31 02:31:37 2006".

It looks like it was safe to use that way, but now it's not. Something has changed
(preempt RCU?). Welcome to the analysis!

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
---
 include/linux/sched.h |    3 ++-
 kernel/exit.c         |    8 ++++----
 kernel/fork.c         |    1 -
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5e344bb..6bfc041 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1854,11 +1854,12 @@ extern void free_task(struct task_struct *tsk);
 #define get_task_struct(tsk) do { atomic_inc(&(tsk)->usage); } while(0)
 
 extern void __put_task_struct(struct task_struct *t);
+extern void __put_task_struct_cb(struct rcu_head *rhp);
 
 static inline void put_task_struct(struct task_struct *t)
 {
 	if (atomic_dec_and_test(&t->usage))
-		__put_task_struct(t);
+		call_rcu(&t->rcu, __put_task_struct_cb);
 }
 
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
diff --git a/kernel/exit.c b/kernel/exit.c
index 5d30019..326eae7 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -159,15 +159,15 @@ static void __exit_signal(struct task_struct *tsk)
 	}
 }
 
-static void delayed_put_task_struct(struct rcu_head *rhp)
+void __put_task_struct_cb(struct rcu_head *rhp)
 {
 	struct task_struct *tsk = container_of(rhp, struct task_struct, rcu);
 
 	perf_event_delayed_put(tsk);
 	trace_sched_process_free(tsk);
-	put_task_struct(tsk);
+	__put_task_struct(tsk);
 }
-
+EXPORT_SYMBOL_GPL(__put_task_struct_cb);
 
 void release_task(struct task_struct *p)
 {
@@ -207,7 +207,7 @@ void release_task(struct task_struct *p)
 
 	write_unlock_irq(&tasklist_lock);
 	release_thread(p);
-	call_rcu(&p->rcu, delayed_put_task_struct);
+	put_task_struct(p);
 
 	p = leader;
 	if (unlikely(zap_leader))
diff --git a/kernel/fork.c b/kernel/fork.c
index 9b7d746..4d3ac3c 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -249,7 +249,6 @@ void __put_task_struct(struct task_struct *tsk)
 	if (!profile_handoff_task(tsk))
 		free_task(tsk);
 }
-EXPORT_SYMBOL_GPL(__put_task_struct);
 
 void __init __weak arch_task_cache_init(void) { }
 



