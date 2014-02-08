Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703AbaBHVGf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 16:06:35 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:45014 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbaBHVGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 16:06:34 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>,
        Oleg Nesterov <oleg@redhat.com>, Steve Grubb <sgrubb@redhat.com>,
        Eric Paris <eparis@redhat.com>
Subject: [PATCH v3] audit: Turn off TIF_SYSCALL_AUDIT when there are no rules
Date: Sat,  8 Feb 2014 13:06:27 -0800
Message-Id: <ee359482b77f8f633014ec300bc5a4b93f8961e8.1391893528.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This toggles TIF_SYSCALL_AUDIT as needed when rules change instead
of leaving it set whenever rules might be set in the future.  This
reduces syscall latency from >60ns to closer to 40ns on my laptop.

This code is a little bit tricky.  It's not safe to turn
TIF_SYSCALL_AUDIT off during a syscall that is being audited.  So,
with this change, the only thing that ever turns TIF_SYSCALL_AUDIT
off after a process has been created is __audit_syscall_exit.

This has the somewhat odd side-effect that, unless there's a
'task,never' rule, every task's first syscall will use the slow
path.  This should be more or less unnoticable (what's another
20-40ns at task creation time between friends?).

There is a user-visible effect of this change: if there are no audit
rules, then events like AVC denials will not result in a syscall
audit record being written.  I'm happy to accept this minor loss in
debuggability in exchange for a massive speedup of all system calls
on default distribution configurations.

A better solution would be to ditch the syscall entry hook entirely
and use the syscall_get_xyz calls as needed to fill in the context.
This could be done on top of this patch, but it would be more code.

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Steve Grubb <sgrubb@redhat.com>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---

Changes from v2 (actually v2.1):
 - Use for_each_process_thread instead of do_each_thread :)
 - Turn off TIF_SYSCALL_AUDIT lazily, thus hopefully avoiding all of
   the nasty cases that Oleg noticed.

Changes from v1:
 - For new tasks, set flags in a new audit_sync_flags callback instead of
   in audit_alloc (thanks, Oleg).
 - Rework locking.
 - Use irqsave/irqrestore to avoid having to think about who else might have
   taken spinlocks.

 include/linux/audit.h |  8 ++++++--
 kernel/auditfilter.c  |  4 ++--
 kernel/auditsc.c      | 57 +++++++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 63 insertions(+), 6 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index aa865a9..ab00ffb 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -298,7 +298,8 @@ static inline void audit_mmap_fd(int fd, int flags)
 		__audit_mmap_fd(fd, flags);
 }
 
-extern int audit_n_rules;
+extern void audit_inc_n_rules(void);
+extern void audit_dec_n_rules(void);
 extern int audit_signals;
 #else /* CONFIG_AUDITSYSCALL */
 static inline int audit_alloc(struct task_struct *task)
@@ -404,7 +405,10 @@ static inline void audit_mmap_fd(int fd, int flags)
 { }
 static inline void audit_ptrace(struct task_struct *t)
 { }
-#define audit_n_rules 0
+static inline void audit_inc_n_rules(void)
+{ }
+static inline void audit_dec_n_rules(void)
+{ }
 #define audit_signals 0
 #endif /* CONFIG_AUDITSYSCALL */
 
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 14a78cc..4c7054b 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -903,7 +903,7 @@ static inline int audit_add_rule(struct audit_entry *entry)
 	}
 #ifdef CONFIG_AUDITSYSCALL
 	if (!dont_count)
-		audit_n_rules++;
+		audit_inc_n_rules();
 
 	if (!audit_match_signal(entry))
 		audit_signals++;
@@ -955,7 +955,7 @@ static inline int audit_del_rule(struct audit_entry *entry)
 
 #ifdef CONFIG_AUDITSYSCALL
 	if (!dont_count)
-		audit_n_rules--;
+		audit_dec_n_rules();
 
 	if (!audit_match_signal(entry))
 		audit_signals--;
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 7aef2f4..d76947c 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -80,7 +80,7 @@
 #define MAX_EXECVE_AUDIT_LEN 7500
 
 /* number of audit rules */
-int audit_n_rules;
+static int audit_n_rules;
 
 /* determines whether we collect data for signals sent */
 int audit_signals;
@@ -911,6 +911,39 @@ static inline struct audit_context *audit_alloc_context(enum audit_state state)
 	return context;
 }
 
+void audit_inc_n_rules()
+{
+	struct task_struct *p, *t;
+
+	read_lock(&tasklist_lock);
+	audit_n_rules++;
+	smp_wmb();
+	if (audit_n_rules == 1) {
+		/*
+		 * We now have a rule; we need to hook syscall entry.
+		 */
+		for_each_process_thread(p, t) {
+			if (t->audit_context)
+				set_tsk_thread_flag(t, TIF_SYSCALL_AUDIT);
+		}
+	}
+	read_unlock(&tasklist_lock);
+}
+
+void audit_dec_n_rules()
+{
+	read_lock(&tasklist_lock);
+	--audit_n_rules;
+	BUG_ON(audit_n_rules < 0);
+
+	/*
+	 * If audit_n_rules == 0, then __audit_syscall_exit will clear
+	 * TIF_SYSCALL_AUDIT.
+	 */
+
+	read_unlock(&tasklist_lock);
+}
+
 /**
  * audit_alloc - allocate an audit context block for a task
  * @tsk: task
@@ -938,11 +971,12 @@ int audit_alloc(struct task_struct *tsk)
 	if (!(context = audit_alloc_context(state))) {
 		kfree(key);
 		audit_log_lost("out of memory in audit_alloc");
+		clear_tsk_thread_flag(tsk, TIF_SYSCALL_AUDIT);
 		return -ENOMEM;
 	}
 	context->filterkey = key;
 
-	tsk->audit_context  = context;
+	tsk->audit_context = context;
 	set_tsk_thread_flag(tsk, TIF_SYSCALL_AUDIT);
 	return 0;
 }
@@ -1528,6 +1562,25 @@ void __audit_syscall_exit(int success, long return_code)
 		context->filterkey = NULL;
 	}
 	tsk->audit_context = context;
+
+	if (ACCESS_ONCE(audit_n_rules) == 0) {
+		/*
+		 * Either this is the very first syscall by this process or
+		 * audit_dec_n_rules recently set audit_n_rules to zero.
+		 */
+		smp_rmb();
+
+		/* audit_inc_n_rules could increment audit_n_rules here... */
+
+		clear_tsk_thread_flag(tsk, TIF_SYSCALL_AUDIT);
+
+		smp_rmb();
+
+		if (ACCESS_ONCE(audit_n_rules) != 0) {
+			/* ... if so, set TIF_SYSCALL_AUDIT again. */
+			set_tsk_thread_flag(tsk, TIF_SYSCALL_AUDIT);
+		}
+	}
 }
 
 static inline void handle_one(const struct inode *inode)
-- 
1.8.5.3

