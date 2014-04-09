Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934086AbaDIRGP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 13:06:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28324 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933342AbaDIRGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 13:06:11 -0400
Date: Wed, 9 Apr 2014 19:06:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH RESEND 2/2] tracing: syscall_regfunc() should not skip
	kernel threads
Message-ID: <20140409170616.GC27638@redhat.com>
References: <1397059882-23063-1-git-send-email-fweisbec@gmail.com> <1397059882-23063-3-git-send-email-fweisbec@gmail.com> <360091921.1294.1397060915052.JavaMail.zimbra@efficios.com> <20140409124249.4081e665@gandalf.local.home> <20140409170505.GA27638@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140409170505.GA27638@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

syscall_regfunc() ignores the kernel thread because "it has
no effect", see cc3b13c1 "Don't trace kernel thread syscalls".

However, this means that a user-space task spawned by
call_usermodehelper() won't report the system calls if
kernel_execve() is called when sys_tracepoint_refcount != 0.

Remove this check. Hopefully the unnecessary report from
ret_from_fork path mentioned by cc3b13c1 is fine. In fact
"this is the only case" is not true. Say, kernel_execve()
itself does "int 80" on X86_32. Hopefully fine too.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/tracepoint.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index a16754b..4e1e4ca 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -737,9 +737,7 @@ void syscall_regfunc(void)
 	if (!sys_tracepoint_refcount) {
 		read_lock(&tasklist_lock);
 		do_each_thread(g, t) {
-			/* Skip kernel threads. */
-			if (!(t->flags & PF_KTHREAD))
-				set_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);
+			set_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);
 		} while_each_thread(g, t);
 		read_unlock(&tasklist_lock);
 	}
-- 
1.5.5.1

