Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124AbaFSBnE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 21:43:04 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:29909 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756953AbaFSBl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 21:41:59 -0400
Message-Id: <20140619014158.273347256@goodmis.org>
User-Agent: quilt/0.63-1
Date: Wed, 18 Jun 2014 21:40:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [for-next][PATCH 3/3] tracing: syscall_regfunc() should not skip kernel threads
References: <20140619014036.116976241@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0003-tracing-syscall_regfunc-should-not-skip-kernel-threa.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

syscall_regfunc() ignores the kernel threads because "it has no effect",
see cc3b13c1 "Don't trace kernel thread syscalls" which added this check.

However, this means that a user-space task spawned by call_usermodehelper()
will run without TIF_SYSCALL_TRACEPOINT if sys_tracepoint_refcount != 0.

Remove this check. The unnecessary report from ret_from_fork path mentioned
by cc3b13c1 is no longer possible, see See commit fb45550d76bb5 "make sure
that kernel_thread() callbacks call do_exit() themselves".

A kernel_thread() callback can only return and take the int_ret_from_sys_call
path after do_execve() succeeds, otherwise the kernel will crash. But in this
case it is no longer a kernel thread and thus is needs TIF_SYSCALL_TRACEPOINT.

Link: http://lkml.kernel.org/p/20140413185938.GD20668@redhat.com

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/tracepoint.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 9cf12640de5a..3490407dc7b7 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -497,9 +497,7 @@ void syscall_regfunc(void)
 	if (!sys_tracepoint_refcount) {
 		read_lock(&tasklist_lock);
 		for_each_process_thread(p, t) {
-			/* Skip kernel threads. */
-			if (!(t->flags & PF_KTHREAD))
-				set_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);
+			set_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);
 		}
 		read_unlock(&tasklist_lock);
 	}
-- 
2.0.0.rc2


