Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650AbaFFMUe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 08:20:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60937 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaFFMUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 08:20:32 -0400
Date: Fri, 6 Jun 2014 05:19:15 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-e041e328c4b41e1db79bfe5ba9992c2ed771ad19@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, acme@kernel.org,
        davej@redhat.com, viro@zeniv.linux.org.uk, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, davej@redhat.com,
        acme@kernel.org, viro@zeniv.linux.org.uk, tglx@linutronix.de
In-Reply-To: <20140521153219.GH5226@laptop.programming.kicks-ass.net>
References: <20140521153219.GH5226@laptop.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Fix perf_event_comm() vs. exec() assumption
Git-Commit-ID: e041e328c4b41e1db79bfe5ba9992c2ed771ad19
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

Commit-ID:  e041e328c4b41e1db79bfe5ba9992c2ed771ad19
Gitweb:     http://git.kernel.org/tip/e041e328c4b41e1db79bfe5ba9992c2ed771ad19
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 21 May 2014 17:32:19 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 6 Jun 2014 07:54:02 +0200

perf: Fix perf_event_comm() vs. exec() assumption

perf_event_comm() assumes that set_task_comm() is only called on
exec(), and in particular that its only called on current.

Neither are true, as Dave reported a WARN triggered by set_task_comm()
being called on !current.

Separate the exec() hook from the comm hook.

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Link: http://lkml.kernel.org/r/20140521153219.GH5226@laptop.programming.kicks-ass.net
[ Build fix. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 fs/exec.c                  |  1 +
 include/linux/perf_event.h |  4 +++-
 kernel/events/core.c       | 28 ++++++++++++++++------------
 3 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 238b7aa..a038a41 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1110,6 +1110,7 @@ void setup_new_exec(struct linux_binprm * bprm)
 	else
 		set_dumpable(current->mm, suid_dumpable);
 
+	perf_event_exec();
 	set_task_comm(current, kbasename(bprm->filename));
 
 	/* Set the new mm task size. We have to do that late because it may
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 3ef6ea1..9b5cd19 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -695,6 +695,7 @@ extern struct perf_guest_info_callbacks *perf_guest_cbs;
 extern int perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *callbacks);
 extern int perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *callbacks);
 
+extern void perf_event_exec(void);
 extern void perf_event_comm(struct task_struct *tsk);
 extern void perf_event_fork(struct task_struct *tsk);
 
@@ -772,7 +773,7 @@ extern void perf_event_enable(struct perf_event *event);
 extern void perf_event_disable(struct perf_event *event);
 extern int __perf_event_disable(void *info);
 extern void perf_event_task_tick(void);
-#else
+#else /* !CONFIG_PERF_EVENTS: */
 static inline void
 perf_event_task_sched_in(struct task_struct *prev,
 			 struct task_struct *task)			{ }
@@ -802,6 +803,7 @@ static inline int perf_unregister_guest_info_callbacks
 (struct perf_guest_info_callbacks *callbacks)				{ return 0; }
 
 static inline void perf_event_mmap(struct vm_area_struct *vma)		{ }
+static inline void perf_event_exec(void)				{ }
 static inline void perf_event_comm(struct task_struct *tsk)		{ }
 static inline void perf_event_fork(struct task_struct *tsk)		{ }
 static inline void perf_event_init(void)				{ }
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 440eefc..647698f 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2970,6 +2970,22 @@ out:
 	local_irq_restore(flags);
 }
 
+void perf_event_exec(void)
+{
+	struct perf_event_context *ctx;
+	int ctxn;
+
+	rcu_read_lock();
+	for_each_task_context_nr(ctxn) {
+		ctx = current->perf_event_ctxp[ctxn];
+		if (!ctx)
+			continue;
+
+		perf_event_enable_on_exec(ctx);
+	}
+	rcu_read_unlock();
+}
+
 /*
  * Cross CPU call to read the hardware event
  */
@@ -5057,18 +5073,6 @@ static void perf_event_comm_event(struct perf_comm_event *comm_event)
 void perf_event_comm(struct task_struct *task)
 {
 	struct perf_comm_event comm_event;
-	struct perf_event_context *ctx;
-	int ctxn;
-
-	rcu_read_lock();
-	for_each_task_context_nr(ctxn) {
-		ctx = task->perf_event_ctxp[ctxn];
-		if (!ctx)
-			continue;
-
-		perf_event_enable_on_exec(ctx);
-	}
-	rcu_read_unlock();
 
 	if (!atomic_read(&nr_comm_events))
 		return;
