Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab3DSTBf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 15:01:35 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:53962 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041Ab3DSTBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 15:01:34 -0400
Date: Fri, 19 Apr 2013 12:01:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net
Cc: linux-kernel@vger.kernel.org, ajax@redhat.com, gusld@br.ibm.com
Subject: [PATCH] events: Protect access via task_subsys_state_check()
Message-ID: <20130419190124.GA8638@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041919-7182-0000-0000-000006515B2C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
[  953.267751] [c0000001f0d1bbc0] [c00000000027e724] .search_binary_handler+0x254/0x680
[  953.267758] [c0000001f0d1bca0] [c0000000002800dc] .do_execve_common.isra.17+0x76c/0x860
[  953.267764] [c0000001f0d1bd90] [c000000000280698] .SyS_execve+0x58/0x90
[  953.267771] [c0000001f0d1be30] [c000000000009e60] syscall_exit+0x0/0x98

This commit therefore adds the required RCU read-side critical section to
perf_event_comm().

Reported-by: Adam Jackson <ajax@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Tested-by: Gustavo Luiz Duarte <gusld@br.ibm.com>

diff --git a/kernel/events/core.c b/kernel/events/core.c
index b0cd865..8db9551 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4593,6 +4593,7 @@ void perf_event_comm(struct task_struct *task)
 	struct perf_event_context *ctx;
 	int ctxn;
 
+	rcu_read_lock();
 	for_each_task_context_nr(ctxn) {
 		ctx = task->perf_event_ctxp[ctxn];
 		if (!ctx)
@@ -4600,6 +4601,7 @@ void perf_event_comm(struct task_struct *task)
 
 		perf_event_enable_on_exec(ctx);
 	}
+	rcu_read_unlock();
 
 	if (!atomic_read(&nr_comm_events))
 		return;

