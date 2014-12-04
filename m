Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbaLDMJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 07:09:21 -0500
Received: from mga01.intel.com ([192.55.52.88]:45984 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837AbaLDMJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 07:09:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,515,1413270000"; 
   d="scan'208";a="642305473"
From: jun.zhang@intel.com
To: mingo@redhat.com, peterz@infradead.org, gregkh@linuxfoundation.org,
        hillf.zj@alibaba-inc.com, vincent.guittot@linaro.org
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        zhang jun <jun.zhang@intel.com>,
        Chuansheng Liu <chuansheng.liu@intel.com>,
        Changcheng Liu <changcheng.liu@intel.com>
Subject: [PATCH v2] sched/fair: fix find_idlest_cpu return -1
Date: Thu,  4 Dec 2014 19:43:55 +0800
Message-Id: <1417693435-18247-1-git-send-email-jun.zhang@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: zhang jun <jun.zhang@intel.com>

in function select_task_rq_fair, when find_idlest_cpu return -1 and sd->child == NULL
select_task_rq_fair return -1, system panic.

[ 0.738326] BUG: unable to handle kernel paging request at ffff8800997ea928
[ 0.746138] IP: [<ffffffff810b15d3>] wake_up_new_task+0x43/0x1b0
[ 0.752886] PGD 25df067 PUD 0
[ 0.756321] Oops: 0000 1 PREEMPT SMP
[ 0.760743] Modules linked in:
[ 0.764179] CPU: 0 PID: 6 Comm: kworker/u8:0 Not tainted 3.14.19-quilt-b27ac761 #2
[ 0.772651] Hardware name: Intel Corporation CHERRYVIEW B1 PLATFORM/Cherry Trail CR, BIOS CHTTRVP1.X64.0003.R08.1411110453 11/11/2014
[ 0.786084] Workqueue: khelper __call_usermodehelper
[ 0.791649] task: ffff88007955a150 ti: ffff88007955c000 task.ti: ffff88007955c000
[ 0.800021] RIP: 0010:[<ffffffff810b15d3>] [<ffffffff810b15d3>] wake_up_new_task+0x43/0x1b0
[ 0.809478] RSP: 0000:ffff88007955dd58 EFLAGS: 00010092
[ 0.815422] RAX: 00000000ffffffff RBX: 0000000000000001 RCX: 0000000000000020
[ 0.823404] RDX: 00000000ffffffff RSI: 0000000000000020 RDI: 0000000000000020
[ 0.831386] RBP: ffff88007955dd80 R08: ffff880079604b58 R09: 00000000ffffffff
[ 0.839368] R10: 0000000000000004 R11: eae0000000000000 R12: ffff8800797ea650
[ 0.847350] R13: 0000000000004000 R14: ffff8800797ead52 R15: 0000000000000206
[ 0.855335] FS: 0000000000000000(0000) GS:ffff88007aa00000(0000) knlGS:0000000000000000
[ 0.864387] CS: 0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 0.870817] CR2: ffff8800997ea928 CR3: 000000000220b000 CR4: 00000000001007f0
[ 0.878796] Stack:
[ 0.881046] 0000000000000001 ffff8800797ea650 0000000000004000 0000000000000000
[ 0.889363] 000000000000003c ffff88007955ddf0 ffffffff8107ddfd ffffffff810b6a95
[ 0.897680] 0000000000000000 ffff8800796beb00 ffff880000000000 ffffffff81000000
[ 0.905998] Call Trace:
[ 0.908752] [<ffffffff8107ddfd>] do_fork+0x12d/0x3b0
[ 0.914416] [<ffffffff810b6a95>] ? set_next_entity+0x95/0xb0
[ 0.920856] [<ffffffff8107e0a6>] kernel_thread+0x26/0x30
[ 0.926903] [<ffffffff8109703e>] __call_usermodehelper+0x2e/0x90
[ 0.933730] [<ffffffff8109ad31>] process_one_work+0x171/0x490
[ 0.940264] [<ffffffff8109ba4b>] worker_thread+0x11b/0x3a0
[ 0.946508] [<ffffffff8109b930>] ? manage_workers.isra.27+0x2b0/0x2b0
[ 0.953821] [<ffffffff810a1802>] kthread+0xd2/0xf0
[ 0.959289] [<ffffffff810a1730>] ? kthread_create_on_node+0x170/0x170
[ 0.966602] [<ffffffff81af81ac>] ret_from_fork+0x7c/0xb0
[ 0.972652] [<ffffffff810a1730>] ? kthread_create_on_node+0x170/0x170
[ 0.979956] Code: 49 89 fc 4c 89 f7 53 e8 bc 5c a4 00 49 8b 54 24 08 31 c9 49 89 c7 49 8b 44 24 60 4c 89 e7 8b 72 18 ba 08 00 00 00 ff 50 40 89 c2 <49> 0f a3 94 24 e0 02 00 00 19 c9 85 c9 0f 84 34 01 00 00 48 8b
[ 1.001809] RIP [<ffffffff810b15d3>] wake_up_new_task+0x43/0x1b0
[ 1.008641] RSP <ffff88007955dd58>
[ 1.012544] CR2: ffff8800997ea928
[ 1.016279] --[ end trace 9737aaa337a5ca10 ]--

Signed-off-by: zhang jun <jun.zhang@intel.com>
Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: Changcheng Liu <changcheng.liu@intel.com>
Signed-off-by: zhang jun <jun.zhang@intel.com>
---
 kernel/sched/fair.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9b4c4f3..9d18887 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4151,7 +4151,7 @@ static int
 find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
 {
 	unsigned long load, min_load = ULONG_MAX;
-	int idlest = -1;
+	int idlest = this_cpu;
 	int i;
 
 	/* Traverse only the allowed CPUs */
@@ -4284,7 +4284,7 @@ select_task_rq_fair(struct task_struct *p, int prev_cpu, int sd_flag, int wake_f
 		}
 
 		new_cpu = find_idlest_cpu(group, p, cpu);
-		if (new_cpu == -1 || new_cpu == cpu) {
+		if (new_cpu == cpu) {
 			/* Now try balancing at a lower domain level of cpu */
 			sd = sd->child;
 			continue;
-- 
1.7.9.5

