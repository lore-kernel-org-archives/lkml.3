Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758474Ab3D3DRh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 23:17:37 -0400
Received: from mail-qe0-f46.google.com ([209.85.128.46]:37723 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757226Ab3D3DRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 23:17:31 -0400
From: kosaki.motohiro@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Olivier Langlois <olivier@trillion01.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Miller <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        a.p.zijlstra@chello.nl, paulus@samba.org, acme@ghostprotocols.net
Subject: [PATCH 01/10] events: Protect access via task_subsys_state_check()
Date: Mon, 29 Apr 2013 23:17:09 -0400
Message-Id: <1367291838-5490-2-git-send-email-kosaki.motohiro@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1367291838-5490-1-git-send-email-kosaki.motohiro@gmail.com>
References: <1367291838-5490-1-git-send-email-kosaki.motohiro@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

The following RCU splat indicates lack of RCU protection:

[  953.267649] ===============================
[  953.267652] [ INFO: suspicious RCU usage. ]
[  953.267657] 3.9.0-0.rc6.git2.4.fc19.ppc64p7 #1 Not tainted
[  953.267661] -------------------------------
[  953.267664] include/linux/cgroup.h:534 suspicious rcu_dereference_check() usage!
[  953.267669]
[  953.267669] other info that might help us debug this:
[  953.267669]
[  953.267675]
[  953.267675] rcu_scheduler_active = 1, debug_locks = 0
[  953.267680] 1 lock held by glxgears/1289:
[  953.267683]  #0:  (&sig->cred_guard_mutex){+.+.+.}, at: [<c00000000027f884>] .prepare_bprm_creds+0x34/0xa0
[  953.267700]
[  953.267700] stack backtrace:
[  953.267704] Call Trace:
[  953.267709] [c0000001f0d1b6e0] [c000000000016e30] .show_stack+0x130/0x200 (unreliable)
[  953.267717] [c0000001f0d1b7b0] [c0000000001267f8] .lockdep_rcu_suspicious+0x138/0x180
[  953.267724] [c0000001f0d1b840] [c0000000001d43a4] .perf_event_comm+0x4c4/0x690
[  953.267731] [c0000001f0d1b950] [c00000000027f6e4] .set_task_comm+0x84/0x1f0
[  953.267737] [c0000001f0d1b9f0] [c000000000280414] .setup_new_exec+0x94/0x220
[  953.267744] [c0000001f0d1ba70] [c0000000002f665c] .load_elf_binary+0x58c/0x19b0
...

This commit therefore adds the required RCU read-side critical
section to perf_event_comm().

Reported-by: Adam Jackson <ajax@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: a.p.zijlstra@chello.nl
Cc: paulus@samba.org
Cc: acme@ghostprotocols.net
Link: http://lkml.kernel.org/r/20130419190124.GA8638@linux.vnet.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Gustavo Luiz Duarte <gusld@br.ibm.com>
---
 kernel/events/core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 4d3124b..9fcb094 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4596,6 +4596,7 @@ void perf_event_comm(struct task_struct *task)
 	struct perf_event_context *ctx;
 	int ctxn;
 
+	rcu_read_lock();
 	for_each_task_context_nr(ctxn) {
 		ctx = task->perf_event_ctxp[ctxn];
 		if (!ctx)
@@ -4603,6 +4604,7 @@ void perf_event_comm(struct task_struct *task)
 
 		perf_event_enable_on_exec(ctx);
 	}
+	rcu_read_unlock();
 
 	if (!atomic_read(&nr_comm_events))
 		return;
-- 
1.7.1

