Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966890AbaFTKsF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 06:48:05 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:51742 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S966643AbaFTKrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 06:47:13 -0400
Message-Id: <20140620104711.360115202@goodmis.org>
User-Agent: quilt/0.63-1
Date: Fri, 20 Jun 2014 06:45:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [for-next][PATCH v2 2/3] tracing: Change syscall_*regfunc() to check PF_KTHREAD and use
 for_each_process_thread()
References: <20140620104518.722157733@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0002-tracing-Change-syscall_-regfunc-to-check-PF_KTHREAD-.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

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
Link: http://lkml.kernel.org/p/20140413185918.GC20668@redhat.com

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/tracepoint.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 33cbd8c203f8..9cf12640de5a 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -492,33 +492,31 @@ static int sys_tracepoint_refcount;
 
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
2.0.0


