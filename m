Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbaBQILX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 03:11:23 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:56884 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbaBQILV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 03:11:21 -0500
Message-ID: <5301C41D.5000009@linux.vnet.ibm.com>
Date: Mon, 17 Feb 2014 16:11:09 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
CC: Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched: fair: NULL ptr deref in check_preempt_wakeup
References: <52FFF7F8.2070801@oracle.com>
In-Reply-To: <52FFF7F8.2070801@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021708-2674-0000-0000-00000CBF2735
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Sasha

On 02/16/2014 07:27 AM, Sasha Levin wrote:
> Hi folks,
> 
> While fuzzing with trinity inside a KVM tools guest running latest -next
> kernel, I've
> stumbled on the following:

I've reproduced the same issue with tip/master, and below patch fixed the
problem on my box along with some rcu stall info disappeared, would you
like to have a try?

BTW, I reproduced it by steps:
1. change current to RT
2. move to a different depth cpu-cgroup
3. change it back to FAIR

Seems like it was caused by that RT has no task_move_group() implemented
which could maintain depth, and that lead to a wrong depth after switched
back to FAIR...

Regards,
Michael Wang



diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 235cfa7..4445e56 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7317,7 +7317,11 @@ static void switched_from_fair(struct rq *rq, struct task_struct *p)
  */
 static void switched_to_fair(struct rq *rq, struct task_struct *p)
 {
-	if (!p->se.on_rq)
+	struct sched_entity *se = &p->se;
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	se->depth = se->parent ? se->parent->depth + 1 : 0;
+#endif
+	if (!se->on_rq)
 		return;
 
 	/*


> 
> [  522.645288] BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000150
> [  522.646271] IP: [<ffffffff81186c6f>] check_preempt_wakeup+0x11f/0x210
> [  522.646976] PGD b0a79067 PUD ae9cf067 PMD 0
> [  522.647494] Oops: 0000 [#1] PREEMPT SMP
> [  522.648000] Dumping ftrace buffer:
> [  522.648380]    (ftrace buffer empty)
> [  522.648775] Modules linked in:
> [  522.649125] CPU: 0 PID: 11735 Comm: trinity-c50 Not tainted
> 3.14.0-rc2-next-20140214-sasha-00008-g95d9d16-dirty #85
> [  522.650021] task: ffff8800c00bb000 ti: ffff88007fdb8000 task.ti:
> ffff88007fdb8000
> [  522.650021] RIP: 0010:[<ffffffff81186c6f>]  [<ffffffff81186c6f>]
> check_preempt_wakeup+0x11f/0x210
> [  522.650021] RSP: 0018:ffff880226e03ba8  EFLAGS: 00010046
> [  522.650021] RAX: 0000000000000000 RBX: ffff880226fd79c0 RCX:
> 0000000000000008
> [  522.650021] RDX: 0000000000000000 RSI: ffff880211313000 RDI:
> 000000000000000c
> [  522.650021] RBP: ffff880226e03be8 R08: 0000000000000000 R09:
> 000000000000b4bb
> [  522.650021] R10: 0000000000000000 R11: 0000000000000000 R12:
> 0000000000000000
> [  522.650021] R13: ffff880211313068 R14: ffff8800c00bb000 R15:
> 0000000000000000
> [  522.650021] FS:  00007f435269f700(0000) GS:ffff880226e00000(0000)
> knlGS:0000000000000000
> [  522.650021] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  522.650021] CR2: 0000000000000150 CR3: 00000000abd2c000 CR4:
> 00000000000006f0
> [  522.650021] DR0: 0000000000995750 DR1: 0000000000000000 DR2:
> 0000000000000000
> [  522.650021] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7:
> 0000000000000600
> [  522.650021] Stack:
> [  522.650021]  ffff880211313000 01ff880226fd79c0 ffff880211313000
> ffff880226fd79c0
> [  522.650021]  ffff880226fd79c0 ffff880211313000 0000000000000000
> ffff880226e00000
> [  522.650021]  ffff880226e03c08 ffffffff8117361d ffff880226fd79c0
> ffff880226fd79c0
> [  522.650021] Call Trace:
> [  522.650021]  <IRQ>
> [  522.650021]  [<ffffffff8117361d>] check_preempt_curr+0x3d/0xb0
> [  522.650021]  [<ffffffff81175d88>] ttwu_do_wakeup+0x18/0x130
> [  522.650021]  [<ffffffff81175ee4>] T.2248+0x44/0x50
> [  522.650021]  [<ffffffff81175f9e>] ttwu_queue+0xae/0xd0
> [  522.650021]  [<ffffffff81180224>] ? try_to_wake_up+0x34/0x2a0
> [  522.650021]  [<ffffffff81180454>] try_to_wake_up+0x264/0x2a0
> [  522.650021]  [<ffffffff811a1672>] ? __lock_acquired+0x2a2/0x2e0
> [  522.650021]  [<ffffffff8118049d>] default_wake_function+0xd/0x10
> [  522.650021]  [<ffffffff811952f8>] autoremove_wake_function+0x18/0x40
> [  522.650021]  [<ffffffff811951b2>] __wake_up_common+0x52/0x90
> [  522.650021]  [<ffffffff8119550d>] ? __wake_up+0x2d/0x70
> [  522.650021]  [<ffffffff81195523>] __wake_up+0x43/0x70
> [  522.650021]  [<ffffffff843119a3>] p9_client_cb+0x43/0x70
> [  522.650021]  [<ffffffff84319d05>] req_done+0x105/0x110
> [  522.650021]  [<ffffffff81cafca6>] vring_interrupt+0x86/0xa0
> [  522.650021]  [<ffffffff811b9a28>] ? handle_irq_event+0x38/0x70
> [  522.650021]  [<ffffffff811b9779>] handle_irq_event_percpu+0x129/0x3a0
> [  522.650021]  [<ffffffff811b9a33>] handle_irq_event+0x43/0x70
> [  522.650021]  [<ffffffff811bd1e8>] handle_edge_irq+0xe8/0x120
> [  522.650021]  [<ffffffff81070a34>] handle_irq+0x164/0x180
> [  522.650021]  [<ffffffff811833c9>] ? vtime_account_system+0x79/0x90
> [  522.650021]  [<ffffffff81183435>] ?
> vtime_common_account_irq_enter+0x55/0x60
> [  522.650021]  [<ffffffff8106f629>] do_IRQ+0x59/0x100
> [  522.650021]  [<ffffffff84395e72>] common_interrupt+0x72/0x72
> [  522.650021]  <EOI>
> [  522.650021]  [<ffffffff812510d5>] ?
> context_tracking_user_exit+0x1a5/0x1c0
> [  522.650021]  [<ffffffff8107cfdd>] syscall_trace_enter+0x2d/0x280
> [  522.650021]  [<ffffffff8439f081>] tracesys+0x7e/0xe2
> [  522.650021] Code: 0f 1f 40 00 ff c8 4d 8b ad 48 01 00 00 39 d0 7f f3
> eb 18 66 0f 1f 84 00 00 00 00 00 4d 8b a4 24 48 01 00 00 4d 8b ad 48 01
> 00 00 <49> 8b bc 24 50 01 00 00 49 3b bd 50 01 00 00 75 e0 48 85 ff 74
> [  522.650021] RIP  [<ffffffff81186c6f>] check_preempt_wakeup+0x11f/0x210
> [  522.650021]  RSP <ffff880226e03ba8>
> [  522.650021] CR2: 0000000000000150
> [  522.650021] ---[ end trace adce75aec8b1b32f ]---
> 
> Since it's pretty inlined, the code points to:
> 
>     check_preempt_wakeup()
>         find_matching_se()
>             find_matching_se()
>                 check_preempt_wakeup()
> 
> 
>     static inline struct cfs_rq *
>     is_same_group(struct sched_entity *se, struct sched_entity *pse)
>     {
>             if (se->cfs_rq == pse->cfs_rq)    <=== HERE
>                     return se->cfs_rq;
>     
>             return NULL;
>     }
> 
> 
> Thanks,
> Sasha
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

