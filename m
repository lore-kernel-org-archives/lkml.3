Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544Ab3BXMY1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 07:24:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47566 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab3BXMYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 07:24:25 -0500
Date: Sun, 24 Feb 2013 04:22:57 -0800
From: tip-bot for Frederic Weisbecker <tipbot@zytor.com>
Message-ID: <tip-7f6575f1fb963d5231afbceecd3feadb6ab58cd3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, zhong@linux.vnet.ibm.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de, khilman@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, zhong@linux.vnet.ibm.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de, khilman@linaro.org
In-Reply-To: <1361636925-22288-3-git-send-email-fweisbec@gmail.com>
References: <1361636925-22288-3-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] cputime: Use local_clock()
  for full dynticks cputime accounting
Git-Commit-ID: 7f6575f1fb963d5231afbceecd3feadb6ab58cd3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sun, 24 Feb 2013 04:23:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7f6575f1fb963d5231afbceecd3feadb6ab58cd3
Gitweb:     http://git.kernel.org/tip/7f6575f1fb963d5231afbceecd3feadb6ab58cd3
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Sat, 23 Feb 2013 17:28:45 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 24 Feb 2013 12:57:16 +0100

cputime: Use local_clock() for full dynticks cputime accounting

Running the full dynticks cputime accounting with preemptible
kernel debugging trigger the following warning:

	[    4.488303] BUG: using smp_processor_id() in preemptible [00000000] code: init/1
	[    4.490971] caller is native_sched_clock+0x22/0x80
	[    4.493663] Pid: 1, comm: init Not tainted 3.8.0+ #13
	[    4.496376] Call Trace:
	[    4.498996]  [<ffffffff813410eb>] debug_smp_processor_id+0xdb/0xf0
	[    4.501716]  [<ffffffff8101e642>] native_sched_clock+0x22/0x80
	[    4.504434]  [<ffffffff8101db99>] sched_clock+0x9/0x10
	[    4.507185]  [<ffffffff81096ccd>] fetch_task_cputime+0xad/0x120
	[    4.509916]  [<ffffffff81096dd5>] task_cputime+0x35/0x60
	[    4.512622]  [<ffffffff810f146e>] acct_update_integrals+0x1e/0x40
	[    4.515372]  [<ffffffff8117d2cf>] do_execve_common+0x4ff/0x5c0
	[    4.518117]  [<ffffffff8117cf14>] ? do_execve_common+0x144/0x5c0
	[    4.520844]  [<ffffffff81867a10>] ? rest_init+0x160/0x160
	[    4.523554]  [<ffffffff8117d457>] do_execve+0x37/0x40
	[    4.526276]  [<ffffffff810021a3>] run_init_process+0x23/0x30
	[    4.528953]  [<ffffffff81867aac>] kernel_init+0x9c/0xf0
	[    4.531608]  [<ffffffff8188356c>] ret_from_fork+0x7c/0xb0

We use sched_clock() to perform and fixup the cputime
accounting. However we are calling it with preemption enabled
from the read side, which trigger the bug above.

To fix this up, use local_clock() instead. It takes care of
preemption and also provide a more reliable clock source. This
is welcome for this kind of statistic that is widely relied on
in userspace.

Reported-by: Thomas Gleixner <tglx@linutronix.de>
Reported-by: Ingo Molnar <mingo@kernel.org>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Kevin Hilman <khilman@linaro.org>
Link: http://lkml.kernel.org/r/1361636925-22288-3-git-send-email-fweisbec@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/cputime.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 9857329..ed12cbb 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -604,7 +604,7 @@ static unsigned long long vtime_delta(struct task_struct *tsk)
 {
 	unsigned long long clock;
 
-	clock = sched_clock();
+	clock = local_clock();
 	if (clock < tsk->vtime_snap)
 		return 0;
 
