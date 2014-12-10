Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758472AbaLJXfJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 18:35:09 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:46839 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758376AbaLJXfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 18:35:03 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: mingo@redhat.com, peterz@infradead.org
Cc: tglx@linutronix.de, hpa@zytor.com, konrad.wilk@oracle.com,
        david.vrabel@citrix.com, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, luto@amacapital.net, JBeulich@suse.com,
        jgross@suse.com, bpoirier@suse.de, x86@kernel.org,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@suse.com>, Borislav Petkov <bp@suse.de>
Subject: [PATCH v2 1/2] sched: add cond_resched_irq()
Date: Wed, 10 Dec 2014 15:34:46 -0800
Message-Id: <1418254487-9988-2-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1418254487-9988-1-git-send-email-mcgrof@do-not-panic.com>
References: <1418254487-9988-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

Under special circumstances we may want to force
voluntary preemption even for CONFIG_PREEMPT=n
with interrupts disabled. This adds helpers to
let us do that.

Cc: Borislav Petkov <bp@suse.de>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Jan Beulich <JBeulich@suse.com>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 include/linux/sched.h |  7 +++++++
 kernel/sched/core.c   | 10 ++++++++++
 2 files changed, 17 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5e344bb..92da927 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2759,6 +2759,13 @@ static inline int signal_pending_state(long state, struct task_struct *p)
  */
 extern int _cond_resched(void);
 
+/*
+ * Voluntarily preempting the kernel even for CONFIG_PREEMPT=n kernels
+ * on very special circumstances. This is to be used with interrupts
+ * disabled.
+ */
+extern int cond_resched_irq(void);
+
 #define cond_resched() ({			\
 	__might_sleep(__FILE__, __LINE__, 0);	\
 	_cond_resched();			\
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 89e7283..573edb1 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4239,6 +4239,16 @@ int __sched _cond_resched(void)
 }
 EXPORT_SYMBOL(_cond_resched);
 
+int __sched cond_resched_irq(void)
+{
+	if (should_resched()) {
+		preempt_schedule_irq();
+		return 1;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cond_resched_irq);
+
 /*
  * __cond_resched_lock() - if a reschedule is pending, drop the given lock,
  * call schedule, and on return reacquire the lock.
-- 
2.1.1

