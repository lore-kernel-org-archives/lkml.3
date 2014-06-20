Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966846AbaFTKr2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 06:47:28 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:51742 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S966748AbaFTKrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 06:47:13 -0400
Message-Id: <20140620104711.567194570@goodmis.org>
User-Agent: quilt/0.63-1
Date: Fri, 20 Jun 2014 06:45:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [for-next][PATCH v2 3/3] tracing: syscall_regfunc() should not skip kernel threads
References: <20140620104518.722157733@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0003-tracing-syscall_regfunc-should-not-skip-kernel-threa.patch
X-RR-Connecting-IP: 107.14.168.142:25
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
2.0.0


