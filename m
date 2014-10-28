Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449AbaJ1LLp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:11:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51269 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756180AbaJ1LLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:11:42 -0400
Date: Tue, 28 Oct 2014 04:10:15 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-1029a2b52c09e479fd7b07275812ad97868c0fb0@git.kernel.org>
Cc: ionut.m.alexa@gmail.com, mhocko@suse.cz, hpa@zytor.com, jbaron@akamai.com,
        tglx@linutronix.de, rusty@rustcorp.com.au,
        torvalds@linux-foundation.org, rostedt@goodmis.org,
        mschmidt@redhat.com, linux-kernel@vger.kernel.org, axel.lin@ingics.com,
        davej@redhat.com, alex.elder@linaro.org, riel@redhat.com,
        guillaume@morinfr.org, oleg@redhat.com, paulmck@linux.vnet.ibm.com,
        dborkman@redhat.com, mingo@kernel.org, akpm@linux-foundation.org,
        peterz@infradead.org
Reply-To: axel.lin@ingics.com, alex.elder@linaro.org, riel@redhat.com,
        davej@redhat.com, paulmck@linux.vnet.ibm.com, guillaume@morinfr.org,
        oleg@redhat.com, peterz@infradead.org, mingo@kernel.org,
        akpm@linux-foundation.org, dborkman@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, jbaron@akamai.com, mhocko@suse.cz,
        ionut.m.alexa@gmail.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, mschmidt@redhat.com, rusty@rustcorp.com.au,
        torvalds@linux-foundation.org
In-Reply-To: <20140924082242.186408915@infradead.org>
References: <20140924082242.186408915@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched, exit: Deal with nested sleeps
Git-Commit-ID: 1029a2b52c09e479fd7b07275812ad97868c0fb0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1029a2b52c09e479fd7b07275812ad97868c0fb0
Gitweb:     http://git.kernel.org/tip/1029a2b52c09e479fd7b07275812ad97868c0fb0
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 24 Sep 2014 10:18:49 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 10:55:30 +0100

sched, exit: Deal with nested sleeps

do_wait() is a big wait loop, but we set TASK_RUNNING too late; we end
up calling potential sleeps before we reset it.

Not strictly a bug since we're guaranteed to exit the loop and not
call schedule(); put in annotations to quiet might_sleep().

 WARNING: CPU: 0 PID: 1 at ../kernel/sched/core.c:7123 __might_sleep+0x7e/0x90()
 do not call blocking ops when !TASK_RUNNING; state=1 set at [<ffffffff8109a788>] do_wait+0x88/0x270

 Call Trace:
  [<ffffffff81694991>] dump_stack+0x4e/0x7a
  [<ffffffff8109877c>] warn_slowpath_common+0x8c/0xc0
  [<ffffffff8109886c>] warn_slowpath_fmt+0x4c/0x50
  [<ffffffff810bca6e>] __might_sleep+0x7e/0x90
  [<ffffffff811a1c15>] might_fault+0x55/0xb0
  [<ffffffff8109a3fb>] wait_consider_task+0x90b/0xc10
  [<ffffffff8109a804>] do_wait+0x104/0x270
  [<ffffffff8109b837>] SyS_wait4+0x77/0x100
  [<ffffffff8169d692>] system_call_fastpath+0x16/0x1b

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: tglx@linutronix.de
Cc: umgwanakikbuti@gmail.com
Cc: ilya.dryomov@inktank.com
Cc: Alex Elder <alex.elder@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Axel Lin <axel.lin@ingics.com>
Cc: Daniel Borkmann <dborkman@redhat.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Guillaume Morin <guillaume@morinfr.org>
Cc: Ionut Alexa <ionut.m.alexa@gmail.com>
Cc: Jason Baron <jbaron@akamai.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Michal Schmidt <mschmidt@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/20140924082242.186408915@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/kernel.h | 2 ++
 kernel/exit.c          | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 3d770f55..5068a0d 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -175,10 +175,12 @@ extern int _cond_resched(void);
  */
 # define might_sleep() \
 	do { __might_sleep(__FILE__, __LINE__, 0); might_resched(); } while (0)
+# define sched_annotate_sleep()	__set_current_state(TASK_RUNNING)
 #else
   static inline void __might_sleep(const char *file, int line,
 				   int preempt_offset) { }
 # define might_sleep() do { might_resched(); } while (0)
+# define sched_annotate_sleep() do { } while (0)
 #endif
 
 #define might_sleep_if(cond) do { if (cond) might_sleep(); } while (0)
diff --git a/kernel/exit.c b/kernel/exit.c
index 5d30019..232c4bc 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -997,6 +997,8 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 
 		get_task_struct(p);
 		read_unlock(&tasklist_lock);
+		sched_annotate_sleep();
+
 		if ((exit_code & 0x7f) == 0) {
 			why = CLD_EXITED;
 			status = exit_code >> 8;
@@ -1079,6 +1081,7 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 	 * thread can reap it because we its state == DEAD/TRACE.
 	 */
 	read_unlock(&tasklist_lock);
+	sched_annotate_sleep();
 
 	retval = wo->wo_rusage
 		? getrusage(p, RUSAGE_BOTH, wo->wo_rusage) : 0;
@@ -1210,6 +1213,7 @@ unlock_sig:
 	pid = task_pid_vnr(p);
 	why = ptrace ? CLD_TRAPPED : CLD_STOPPED;
 	read_unlock(&tasklist_lock);
+	sched_annotate_sleep();
 
 	if (unlikely(wo->wo_flags & WNOWAIT))
 		return wait_noreap_copyout(wo, p, pid, uid, why, exit_code);
@@ -1272,6 +1276,7 @@ static int wait_task_continued(struct wait_opts *wo, struct task_struct *p)
 	pid = task_pid_vnr(p);
 	get_task_struct(p);
 	read_unlock(&tasklist_lock);
+	sched_annotate_sleep();
 
 	if (!wo->wo_info) {
 		retval = wo->wo_rusage
