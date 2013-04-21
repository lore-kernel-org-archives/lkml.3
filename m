Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab3DUMvU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 08:51:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40721 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab3DUMvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 08:51:18 -0400
Date: Sun, 21 Apr 2013 05:51:01 -0700
From: "tip-bot for Paul E. McKenney" <tipbot@zytor.com>
Message-ID: <tip-c79aa0d96548aee50570209eb2d45c8f4ac49230@git.kernel.org>
Cc: gusld@br.ibm.com, linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
        hpa@zytor.com, mingo@kernel.org, tglx@linutronix.de, ajax@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, gusld@br.ibm.com, tglx@linutronix.de,
        ajax@redhat.com
In-Reply-To: <20130419190124.GA8638@linux.vnet.ibm.com>
References: <20130419190124.GA8638@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] events:
  Protect access via task_subsys_state_check()
Git-Commit-ID: c79aa0d96548aee50570209eb2d45c8f4ac49230
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sun, 21 Apr 2013 05:51:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c79aa0d96548aee50570209eb2d45c8f4ac49230
Gitweb:     http://git.kernel.org/tip/c79aa0d96548aee50570209eb2d45c8f4ac49230
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Fri, 19 Apr 2013 12:01:24 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 21 Apr 2013 11:21:39 +0200

events: Protect access via task_subsys_state_check()

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
 kernel/events/core.c | 2 ++
 1 file changed, 2 insertions(+)

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
