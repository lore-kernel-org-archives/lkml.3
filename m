Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbaBCTLf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 14:11:35 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:34450 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837AbaBCTLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 14:11:31 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>,
        Oleg Nesterov <oleg@redhat.com>, Steve Grubb <sgrubb@redhat.com>,
        Eric Paris <eparis@redhat.com>
Subject: [PATCH v2.1] audit: Only use the syscall slowpath when syscall audit rules exist
Date: Mon,  3 Feb 2014 11:11:26 -0800
Message-Id: <377a1c5ce05e25b068cf7576d094885c1396c6bc.1391454589.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This toggles TIF_SYSCALL_AUDIT as needed when rules change instead of
leaving it set whenever rules might be set in the future.  This reduces
syscall latency from >60ns to closer to 40ns on my laptop.

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Steve Grubb <sgrubb@redhat.com>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---

This brown paper bag release is brought to you by git commit's -a flag.

Changes from v2: Contains the correct patch

Changes from v1:
 - For new tasks, set flags in a new audit_sync_flags callback instead of
   in audit_alloc (thanks, Oleg).
 - Rework locking.
 - Use irqsave/irqrestore to avoid having to think about who else might have
   taken spinlocks.

 include/linux/audit.h | 11 ++++++++--
 kernel/auditfilter.c  |  4 ++--
 kernel/auditsc.c      | 57 +++++++++++++++++++++++++++++++++++++++++++++------
 kernel/fork.c         |  3 +++
 4 files changed, 65 insertions(+), 10 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index a406419..a81f498 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -298,7 +298,9 @@ static inline void audit_mmap_fd(int fd, int flags)
 		__audit_mmap_fd(fd, flags);
 }
 
-extern int audit_n_rules;
+extern void audit_inc_n_rules(void);
+extern void audit_dec_n_rules(void);
+extern void audit_sync_flags(struct task_struct *tsk);
 extern int audit_signals;
 #else /* CONFIG_AUDITSYSCALL */
 static inline int audit_alloc(struct task_struct *task)
@@ -404,7 +406,12 @@ static inline void audit_mmap_fd(int fd, int flags)
 { }
 static inline void audit_ptrace(struct task_struct *t)
 { }
-#define audit_n_rules 0
+static inline void audit_inc_n_rules(void)
+{ }
+static inline void audit_dec_n_rules(void)
+{ }
+static inline void audit_sync_flags(struct task_struct *tsk)
+{ }
 #define audit_signals 0
 #endif /* CONFIG_AUDITSYSCALL */
 
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 51f3fd4..0ce531d 100644
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
index 90594c9..cd44c88 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -79,8 +79,13 @@
 /* no execve audit message should be longer than this (userspace limits) */
 #define MAX_EXECVE_AUDIT_LEN 7500
 
-/* number of audit rules */
-int audit_n_rules;
+/*
+ * number of audit rules
+ *
+ * To change this, you must hold audit_filter_mutex *and* have a read lock
+ * on tasklist_lock.
+ */
+static int audit_n_rules;
 
 /* determines whether we collect data for signals sent */
 int audit_signals;
@@ -911,6 +916,40 @@ static inline struct audit_context *audit_alloc_context(enum audit_state state)
 	return context;
 }
 
+void audit_inc_n_rules()
+{
+	struct task_struct *p, *g;
+	unsigned long flags;
+
+	read_lock_irqsave(&tasklist_lock, flags);
+	if (audit_n_rules++ == 0) {
+		do_each_thread(g, p) {
+			if (p->audit_context)
+				set_tsk_thread_flag(p, TIF_SYSCALL_AUDIT);
+		} while_each_thread(g, p);
+	}
+	read_unlock_irqrestore(&tasklist_lock, flags);
+}
+
+void audit_dec_n_rules()
+{
+	struct task_struct *p, *g;
+	unsigned long flags;
+
+	read_lock_irqsave(&tasklist_lock, flags);
+
+	--audit_n_rules;
+	BUG_ON(audit_n_rules < 0);
+
+	if (audit_n_rules == 0) {
+		do_each_thread(g, p) {
+			clear_tsk_thread_flag(p, TIF_SYSCALL_AUDIT);
+		} while_each_thread(g, p);
+	}
+
+	read_unlock_irqrestore(&tasklist_lock, flags);
+}
+
 /**
  * audit_alloc - allocate an audit context block for a task
  * @tsk: task
@@ -930,10 +969,8 @@ int audit_alloc(struct task_struct *tsk)
 		return 0; /* Return if not auditing. */
 
 	state = audit_filter_task(tsk, &key);
-	if (state == AUDIT_DISABLED) {
-		clear_tsk_thread_flag(tsk, TIF_SYSCALL_AUDIT);
+	if (state == AUDIT_DISABLED)
 		return 0;
-	}
 
 	if (!(context = audit_alloc_context(state))) {
 		kfree(key);
@@ -943,10 +980,18 @@ int audit_alloc(struct task_struct *tsk)
 	context->filterkey = key;
 
 	tsk->audit_context  = context;
-	set_tsk_thread_flag(tsk, TIF_SYSCALL_AUDIT);
 	return 0;
 }
 
+void audit_sync_flags(struct task_struct *tsk)
+{
+	/* The caller has a write lock on tasklist_lock. */
+	if (audit_n_rules && tsk->audit_context)
+		set_tsk_thread_flag(tsk, TIF_SYSCALL_AUDIT);
+	else
+		clear_tsk_thread_flag(tsk, TIF_SYSCALL_AUDIT);
+}
+
 static inline void audit_free_context(struct audit_context *context)
 {
 	audit_free_names(context);
diff --git a/kernel/fork.c b/kernel/fork.c
index dfa736c..3f28173 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1479,6 +1479,9 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 
 	total_forks++;
 	spin_unlock(&current->sighand->siglock);
+
+	audit_sync_flags(p);
+
 	write_unlock_irq(&tasklist_lock);
 	proc_fork_connector(p);
 	cgroup_post_fork(p);
-- 
1.8.5.3

