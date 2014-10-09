Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292AbaJINsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 09:48:21 -0400
Received: from service87.mimecast.com ([91.220.42.44]:60779 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755937AbaJINsM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 09:48:12 -0400
Message-ID: <54369231.7060107@arm.com>
Date: Thu, 09 Oct 2014 14:48:33 +0100
From: Juri Lelli <juri.lelli@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Daniel Wagner <daniel.wagner@bmw-carit.de>,
        "juri.lelli@gmail.com" <juri.lelli@gmail.com>
CC: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] sched: Do not try to replenish from a non deadline tasks
References: <1411565056-15577-1-git-send-email-daniel.wagner@bmw-carit.de>
In-Reply-To: <1411565056-15577-1-git-send-email-daniel.wagner@bmw-carit.de>
X-OriginalArrivalTime: 09 Oct 2014 13:47:52.0003 (UTC) FILETIME=[9ED8A930:01CFE3C7]
X-MC-Unique: 114100914480243601
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On 24/09/14 14:24, Daniel Wagner wrote:
> When a PI mutex is shared between an deadline task and normal task we
> might end up trying to replenish from the normal task. In this case neither
> dl_runtime, dl_period or dl_deadline are set. replenish_dl_entity() can't do
> anything useful.
> 
> The following log is created by
> 
> [root@test-kvm ~]# echo 1 > /proc/sys/kernel/ftrace_dump_on_oops
> [root@test-kvm ~]# trace-cmd start -e sched -e syscalls:*_futex
> 
> I also added an additional trace point to de/enqueue_dl_entity which
> prints the PID of dl_se and pi_se.
> 
> PID 1534 runs as SCHED_OTHER and PID 1535 runs under SCHED_DEADLINE.
> 
> [  654.000276] pthread_-1535    0.... 4435294us : sys_futex(uaddr: 6010a0, op: 86, val: 1, utime: 0, uaddr2: 0, val3: 5ff)
> [  654.000276] pthread_-1535    0d... 4435295us : sched_pi_setprio: comm=pthread_test pid=1535 oldprio=-1 newprio=-1
> [  654.000276] pthread_-1535    0d... 4435295us : sched_dequeue_dl_entity: comm=pthread_test pid=1535 flags=0
> [  654.000276] pthread_-1535    0d... 4435295us : sched_enqueue_dl_entity: comm=pthread_test pid=1535 pi_comm=pthread_test pi_pid=1535 flags=0
> [  654.000276] pthread_-1535    0dN.. 4435295us : sched_pi_setprio: comm=pthread_test pid=1534 oldprio=120 newprio=-1
> [  654.000276] pthread_-1535    0dN.. 4435296us : sched_dequeue_dl_entity: comm=pthread_test pid=1535 flags=0
> [  654.000276] pthread_-1535    0dN.. 4435296us : sched_stat_wait: comm=ksoftirqd/0 pid=3 delay=5043 [ns]
> [  654.000276] pthread_-1535    0d... 4435296us : sched_switch: prev_comm=pthread_test prev_pid=1535 prev_prio=-1 prev_state=S ==> next_comm=ksoftirqd/0 next_pid=3 next_prio=120
> [  654.000276] ksoftirq-3       0d... 4435297us : sched_stat_runtime: comm=ksoftirqd/0 pid=3 runtime=926 [ns] vruntime=2618803465 [ns]
> [  654.000276] ksoftirq-3       0d... 4435297us : sched_stat_wait: comm=sshd pid=1536 delay=5969 [ns]
> [  654.000276] ksoftirq-3       0d... 4435297us : sched_switch: prev_comm=ksoftirqd/0 prev_pid=3 prev_prio=120 prev_state=S ==> next_comm=sshd next_pid=1536 next_prio=120
> [  654.000276]     sshd-1536    0d.h. 4435345us : sched_enqueue_dl_entity: comm=pthread_test pid=1534 pi_comm=pthread_test pi_pid=1535 flags=1
> [  654.000276]     sshd-1536    0dNh. 4435346us : sched_wakeup: comm=pthread_test pid=1534 prio=-1 success=1 target_cpu=000
> [  654.000276]     sshd-1536    0dN.. 4435501us : sched_stat_sleep: comm=ksoftirqd/0 pid=3 delay=48519 [ns]
> [  654.000276]     sshd-1536    0dN.. 4435501us : sched_wakeup: comm=ksoftirqd/0 pid=3 prio=120 success=1 target_cpu=000
> [  654.000276]     sshd-1536    0dN.. 4435502us : sched_stat_runtime: comm=sshd pid=1536 runtime=48519 [ns] vruntime=9541100 [ns]
> [  654.000276]     sshd-1536    0d... 4435502us : sched_switch: prev_comm=sshd prev_pid=1536 prev_prio=120 prev_state=R ==> next_comm=pthread_test next_pid=1534 next_prio=-1
> [  654.000276] pthread_-1534    0.... 4435503us : sys_futex(uaddr: 6010a0, op: 87, val: 0, utime: 0, uaddr2: 6010a0, val3: 5fe)
> [  654.000276] pthread_-1534    0d... 4435504us : sched_enqueue_dl_entity: comm=pthread_test pid=1535 pi_comm=pthread_test pi_pid=1535 flags=1
> [  654.000276] pthread_-1534    0d... 4435504us : sched_wakeup: comm=pthread_test pid=1535 prio=-1 success=1 target_cpu=000
> [  654.000276] pthread_-1534    0d... 4435504us : sched_pi_setprio: comm=pthread_test pid=1534 oldprio=-1 newprio=120
> [  654.000276] pthread_-1534    0d... 4435504us : sched_dequeue_dl_entity: comm=pthread_test pid=1534 flags=0
> [  654.000276] pthread_-1534    0d... 4435505us : sched_enqueue_dl_entity: comm=pthread_test pid=1534 pi_comm=pthread_test pi_pid=1534 flags=8
> [  654.000276] ---------------------------------
> [  654.000276] Modules linked in:
> [  654.000276] CPU: 0 PID: 1534 Comm: pthread_test Not tainted 3.17.0-rc5+ #49
> [  654.000276] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [  654.000276] task: ffff88007a1f7380 ti: ffff88007d2b8000 task.ti: ffff88007d2b8000
> [  654.000276] RIP: 0010:[<ffffffff810653f2>]  [<ffffffff810653f2>] enqueue_task_dl+0x2b2/0x330
> [  654.000276] RSP: 0018:ffff88007d2bbd08  EFLAGS: 00010046
> [  654.000276] RAX: 0000000000000000 RBX: ffff88007a1f7380 RCX: 0000000000000000
> [  654.000276] RDX: 0000000000000000 RSI: 0000000000000046 RDI: ffff88007d006c00
> [  654.000276] RBP: ffff88007d2bbd38 R08: 0000000000000000 R09: ffff88007a3d3fa4
> [  654.000276] R10: 0000009837497dad R11: 000000000000000d R12: ffff88007a1f7568
> [  654.000276] R13: 0000000000000008 R14: ffff88007a1f7568 R15: ffff88007a1f7568
> [  654.000276] FS:  00007f48db1bc740(0000) GS:ffffffff81e26000(0000) knlGS:0000000000000000
> [  654.000276] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  654.000276] CR2: 00007f1b9095f330 CR3: 0000000076d0a000 CR4: 00000000000006f0
> [  654.000276] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  654.000276] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  654.000276] Stack:
> [  654.000276]  ffff88007a1f7380 ffff88007a1f7380 0000000000026e10 ffffffff81e46520
> [  654.000276]  ffff88007c8e5820 ffff88007a1f7568 ffff88007d2bbd70 ffffffff81065578
> [  654.000276]  ffffffff81e46520 ffff88007a1f7380 ffff88007a1f7568 ffffffff81a0d800
> [  654.000276] Call Trace:
> [  654.000276]  [<ffffffff81065578>] update_curr_dl+0x108/0x230
> [  654.000276]  [<ffffffff81065859>] dequeue_task_dl+0x19/0x70
> [  654.000276]  [<ffffffff8105c605>] dequeue_task+0x55/0x80
> [  654.000276]  [<ffffffff8105f849>] rt_mutex_setprio+0x109/0x2c0
> [  654.000276]  [<ffffffff8106b5fb>] __rt_mutex_adjust_prio+0x1b/0x40
> [  654.000276]  [<ffffffff8183d058>] rt_mutex_unlock+0x68/0x90
> [  654.000276]  [<ffffffff81092aa4>] do_futex+0x594/0x950
> [  654.000276]  [<ffffffff81092ecc>] SyS_futex+0x6c/0x150
> [  654.000276]  [<ffffffff8100edd1>] ? syscall_trace_enter+0x211/0x220
> [  654.000276]  [<ffffffff8183e606>] tracesys+0xdc/0xe1
> [  654.000276] Code: 00 00 00 00 00 00 48 89 83 20 02 00 00 eb 9b be 1a 01 00 00 48 c7 c7 cb 4c bd 81 e8 69 a9 fd ff 48 8b 93 e8 01 00 00 eb bd 0f 0b <0f> 0b 48 c7 c7 78 c4 bc 81 31 c0 c6 05 61 5a eb 00 01 e8 47 ca
> [  654.000276] RIP  [<ffffffff810653f2>] enqueue_task_dl+0x2b2/0x330
> [  654.000276]  RSP <ffff88007d2bbd08>
> [  654.000276] ---[ end trace aed7e30a2c9541d9 ]---
> 
> Signed-off-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Juri Lelli <juri.lelli@gmail.com>
> ---
>  kernel/sched/deadline.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index 2799441..4b3a80f 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -630,7 +630,7 @@ static void update_curr_dl(struct rq *rq)
>  		__dequeue_task_dl(rq, curr, 0);
>  		if (likely(start_dl_timer(dl_se, curr->dl.dl_boosted)))
>  			dl_se->dl_throttled = 1;
> -		else
> +		else if (curr->dl.dl_runtime > 0)
>  			enqueue_task_dl(rq, curr, ENQUEUE_REPLENISH);
>  
>  		if (!is_leftmost(curr, &rq->dl))
> 

I'd have a slightly different solution for this, can you give it a try?

Thanks,

- Juri

>From 4b7bdeb706d8636beda2a11946289d76ee7e30cd Mon Sep 17 00:00:00 2001
From: Juri Lelli <juri.lelli@arm.com>
Date: Wed, 8 Oct 2014 14:06:16 +0100
Subject: [PATCH 1/2] sched/deadline: don't replenish from a !SCHED_DEADLINE
 entity

Signed-off-by: Juri Lelli <juri.lelli@arm.com>
---
 kernel/sched/deadline.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 2799441..e89c27b 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -847,8 +847,19 @@ static void enqueue_task_dl(struct rq *rq, struct task_struct *p, int flags)
 	 * smaller than our one... OTW we keep our runtime and
 	 * deadline.
 	 */
-	if (pi_task && p->dl.dl_boosted && dl_prio(pi_task->normal_prio))
+	if (pi_task && p->dl.dl_boosted && dl_prio(pi_task->normal_prio)) {
 		pi_se = &pi_task->dl;
+	} else if (!dl_prio(p->normal_prio)) {
+		/*
+		 * Special case in which we have a !SCHED_DEADLINE task
+		 * that is going to be deboosted, but exceedes its
+		 * runtime while doing so. No point in replenishing
+		 * it, as it's going to return back to its original
+		 * scheduling class after this.
+		 */
+		BUG_ON(!p->dl.dl_boosted || flags != ENQUEUE_REPLENISH);
+		return;
+	}
 
 	/*
 	 * If p is throttled, we do nothing. In fact, if it exhausted
-- 
2.1.0

