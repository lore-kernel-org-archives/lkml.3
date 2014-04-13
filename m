Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbaDMS7j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 14:59:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755470AbaDMS7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 14:59:36 -0400
Date: Sun, 13 Apr 2014 20:59:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH v2 3/3] tracing: syscall_regfunc() should not skip kernel
	threads
Message-ID: <20140413185938.GD20668@redhat.com>
References: <1397059882-23063-3-git-send-email-fweisbec@gmail.com> <360091921.1294.1397060915052.JavaMail.zimbra@efficios.com> <20140409124249.4081e665@gandalf.local.home> <20140409170505.GA27638@redhat.com> <20140409170542.GB27638@redhat.com> <20140410090643.46ca2226@gandalf.local.home> <20140410133435.GB12228@redhat.com> <20140411112259.79f0a0ba@gandalf.local.home> <20140411155845.GA30199@redhat.com> <20140413185828.GA20668@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140413185828.GA20668@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/tracepoint.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index d907b7b..08456ba 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -747,9 +747,7 @@ void syscall_regfunc(void)
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
1.5.5.1


