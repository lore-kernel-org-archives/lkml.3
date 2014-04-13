Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbaDMS7S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 14:59:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755280AbaDMS7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 14:59:16 -0400
Date: Sun, 13 Apr 2014 20:59:18 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH v2 2/3] tracing: change syscall_*regfunc() to check
	PF_KTHREAD and use for_each_process_thread()
Message-ID: <20140413185918.GC20668@redhat.com>
References: <1397059882-23063-3-git-send-email-fweisbec@gmail.com> <360091921.1294.1397060915052.JavaMail.zimbra@efficios.com> <20140409124249.4081e665@gandalf.local.home> <20140409170505.GA27638@redhat.com> <20140409170542.GB27638@redhat.com> <20140410090643.46ca2226@gandalf.local.home> <20140410133435.GB12228@redhat.com> <20140411112259.79f0a0ba@gandalf.local.home> <20140411155845.GA30199@redhat.com> <20140413185828.GA20668@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140413185828.GA20668@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Remove _irqsafe from syscall_regfunc/syscall_unregfunc,
   read_lock(tasklist) doesn't need to disable irqs.

2. Change this code to avoid the deprecated do_each_thread()
   and use for_each_process_thread() (stolen from the patch
   from Frederic).

3. Change syscall_regfunc() to check PF_KTHREAD to skip
   the kernel threads, ->mm != NULL is the common mistake.

   Note: probably this check should be simply removed, needs
   another patch.

[fweisbec@gmail.com: s/do_each_thread/for_each_process_thread/]
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/tracepoint.c |   24 +++++++++++-------------
 1 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 031cc56..d907b7b 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -742,33 +742,31 @@ static int sys_tracepoint_refcount;
 
 void syscall_regfunc(void)
 {
-	unsigned long flags;
-	struct task_struct *g, *t;
+	struct task_struct *p, *t;
 
 	if (!sys_tracepoint_refcount) {
-		read_lock_irqsave(&tasklist_lock, flags);
-		do_each_thread(g, t) {
+		read_lock(&tasklist_lock);
+		for_each_process_thread(p, t) {
 			/* Skip kernel threads. */
-			if (t->mm)
+			if (!(t->flags & PF_KTHREAD))
 				set_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);
-		} while_each_thread(g, t);
-		read_unlock_irqrestore(&tasklist_lock, flags);
+		}
+		read_unlock(&tasklist_lock);
 	}
 	sys_tracepoint_refcount++;
 }
 
 void syscall_unregfunc(void)
 {
-	unsigned long flags;
-	struct task_struct *g, *t;
+	struct task_struct *p, *t;
 
 	sys_tracepoint_refcount--;
 	if (!sys_tracepoint_refcount) {
-		read_lock_irqsave(&tasklist_lock, flags);
-		do_each_thread(g, t) {
+		read_lock(&tasklist_lock);
+		for_each_process_thread(p, t) {
 			clear_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);
-		} while_each_thread(g, t);
-		read_unlock_irqrestore(&tasklist_lock, flags);
+		}
+		read_unlock(&tasklist_lock);
 	}
 }
 #endif
-- 
1.5.5.1


