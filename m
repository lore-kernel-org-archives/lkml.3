Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731AbaFYLIE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 07:08:04 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:41123 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756247AbaFYLHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 07:07:17 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: tj@kernel.org, rostedt@goodmis.org, mingo@redhat.com,
        akpm@linux-foundation.org, andi@firstfloor.org,
        paulmck@linux.vnet.ibm.com, pavel@ucw.cz, jirislaby@gmail.com,
        Vojtech Pavlik <vojtech@suse.cz>, Michael Matz <matz@suse.de>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH -repost 21/21] kgr: x86: optimize handling of CPU-bound tasks
Date: Wed, 25 Jun 2014 13:07:15 +0200
Message-Id: <1403694435-3180-21-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403694435-3180-1-git-send-email-jslaby@suse.cz>
References: <1403694435-3180-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

Processes which are running in userspace at the time of patching can
be immediately marked as "migrated" to the new universe, as they are
provably outside the kernel and would have their 'in_progress' flag
cleared upon (eventual) kernel entry anyway.

This eliminates the need to send a SIGSTOP/SIGCONT signal (or perform
any kind of alternative handling that would force the tasks to go
through the kernel) to such tasks. This allows the tasks to run
completely undisturbed by the patching.

We do this by looking at the task's stack trace. This is suboptimal
and perhaps ugly solution but we have not find any other easy way
without interrupting the task's computation. I.e. we are aware of IPIs
and looking at stored regs for example. If anyone can come up with an
idea how to dig out the process' state (whether running in user space
or not) from task_struct or such, please draw faster and shoot this
one dead.

js: remove unneeded headers
js: cleanup

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/include/asm/kgraft.h | 30 ++++++++++++++++++++++++++++++
 kernel/kgraft.c               |  3 +++
 2 files changed, 33 insertions(+)

diff --git a/arch/x86/include/asm/kgraft.h b/arch/x86/include/asm/kgraft.h
index 6fc57a85d12c..3b13738f3665 100644
--- a/arch/x86/include/asm/kgraft.h
+++ b/arch/x86/include/asm/kgraft.h
@@ -22,10 +22,40 @@
 #endif
 
 #include <asm/ptrace.h>
+#include <linux/stacktrace.h>
 
 static inline void kgr_set_regs_ip(struct pt_regs *regs, unsigned long ip)
 {
 	regs->ip = ip;
 }
 
+#ifdef CONFIG_STACKTRACE
+/*
+ * Tasks which are running in userspace after the patching has been started
+ * can immediately be marked as migrated to the new universe.
+ *
+ * If this function returns non-zero (i.e. also when error happens), the task
+ * needs to be migrated using kgraft lazy mechanism.
+ */
+static inline bool kgr_needs_lazy_migration(struct task_struct *p)
+{
+	unsigned long s[3];
+	struct stack_trace t = {
+		.nr_entries = 0,
+		.skip = 0,
+		.max_entries = 3,
+		.entries = s,
+	};
+
+	save_stack_trace_tsk(p, &t);
+
+	return t.nr_entries > 2;
+}
+#else
+static inline bool kgr_needs_lazy_migration(struct task_struct *p)
+{
+	return true;
+}
+#endif
+
 #endif
diff --git a/kernel/kgraft.c b/kernel/kgraft.c
index 90ef7fba6d0a..151e00648ffc 100644
--- a/kernel/kgraft.c
+++ b/kernel/kgraft.c
@@ -150,6 +150,9 @@ static void kgr_handle_processes(void)
 			 */
 			wake_up_process(p);
 		}
+		/* mark tasks wandering in userspace as already migrated */
+		if (!kgr_needs_lazy_migration(p))
+			kgr_task_safe(p);
 	}
 	read_unlock(&tasklist_lock);
 }
-- 
2.0.0

