Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974AbaBCRxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 12:53:30 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:48609 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbaBCRx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 12:53:29 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>,
        Oleg Nesterov <oleg@redhat.com>, Steve Grubb <sgrubb@redhat.com>,
        Eric Paris <eparis@redhat.com>
Subject: [PATCH] audit: Only use the syscall slowpath when syscall audit rules exist
Date: Mon,  3 Feb 2014 09:53:23 -0800
Message-Id: <a8356e46aed7213128e84a888170391adb6afe30.1391449825.git.luto@amacapital.net>
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

This is not the best-tested patch in the world.  Someone who actually
knows how to use syscall auditing should probably give it a spin.  It
fixes an IMO huge performance issue, though.

 include/linux/audit.h |  9 +++++--
 kernel/auditfilter.c  |  4 ++--
 kernel/auditsc.c      | 65 ++++++++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 71 insertions(+), 7 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index a406419..534ba85 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -298,7 +298,9 @@ static inline void audit_mmap_fd(int fd, int flags)
 		__audit_mmap_fd(fd, flags);
 }
 
-extern int audit_n_rules;
+extern void audit_inc_n_rules(void);
+extern void audit_dec_n_rules(void);
+
 extern int audit_signals;
 #else /* CONFIG_AUDITSYSCALL */
 static inline int audit_alloc(struct task_struct *task)
@@ -404,7 +406,10 @@ static inline void audit_mmap_fd(int fd, int flags)
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
index 90594c9..363d0bb 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -79,8 +79,15 @@
 /* no execve audit message should be longer than this (userspace limits) */
 #define MAX_EXECVE_AUDIT_LEN 7500
 
-/* number of audit rules */
-int audit_n_rules;
+/*
+ * number of audit rules
+ *
+ * n_rules_lock protects audit_n_rules.  It also prevents audit_alloc from
+ * racing against changes to audit_n_rules: to change someone else's
+ * audit_context or TIF_SYSCALL_AUDIT, you need write_lock(&n_rules_lock).
+ */
+static DEFINE_RWLOCK(n_rules_lock);
+static int audit_n_rules;
 
 /* determines whether we collect data for signals sent */
 int audit_signals;
@@ -911,6 +918,47 @@ static inline struct audit_context *audit_alloc_context(enum audit_state state)
 	return context;
 }
 
+void audit_inc_n_rules()
+{
+	struct task_struct *p, *g;
+
+	write_lock(&n_rules_lock);
+
+	if (audit_n_rules++ != 0)
+		goto out;  /* The overall state isn't changing. */
+
+	read_lock(&tasklist_lock);
+	do_each_thread(g, p) {
+		if (p->audit_context)
+			set_tsk_thread_flag(p, TIF_SYSCALL_AUDIT);
+	} while_each_thread(g, p);
+	read_unlock(&tasklist_lock);
+
+out:
+	write_unlock(&n_rules_lock);
+}
+
+void audit_dec_n_rules()
+{
+	struct task_struct *p, *g;
+
+	write_lock(&n_rules_lock);
+	--audit_n_rules;
+	BUG_ON(audit_n_rules < 0);
+
+	if (audit_n_rules != 0)
+		goto out;  /* The overall state isn't changing. */
+
+	read_lock(&tasklist_lock);
+	do_each_thread(g, p) {
+		clear_tsk_thread_flag(p, TIF_SYSCALL_AUDIT);
+	} while_each_thread(g, p);
+	read_unlock(&tasklist_lock);
+
+out:
+	write_unlock(&n_rules_lock);
+}
+
 /**
  * audit_alloc - allocate an audit context block for a task
  * @tsk: task
@@ -931,6 +979,11 @@ int audit_alloc(struct task_struct *tsk)
 
 	state = audit_filter_task(tsk, &key);
 	if (state == AUDIT_DISABLED) {
+		/*
+		 * There is no relevant race against inc/dec_n_rules
+		 * here -- inc won't set TIF_SYSCALL_AUDIT, and, if dec
+		 * clears it redundantly, there's no harm done.
+		 */
 		clear_tsk_thread_flag(tsk, TIF_SYSCALL_AUDIT);
 		return 0;
 	}
@@ -942,8 +995,14 @@ int audit_alloc(struct task_struct *tsk)
 	}
 	context->filterkey = key;
 
+	read_lock(&n_rules_lock);
 	tsk->audit_context  = context;
-	set_tsk_thread_flag(tsk, TIF_SYSCALL_AUDIT);
+	if (audit_n_rules)
+		set_tsk_thread_flag(tsk, TIF_SYSCALL_AUDIT);
+	else
+		clear_tsk_thread_flag(tsk, TIF_SYSCALL_AUDIT);
+	read_unlock(&n_rules_lock);
+
 	return 0;
 }
 
-- 
1.8.5.3

