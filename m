Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937Ab3FSPPt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 11:15:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756706Ab3FSPPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 11:15:48 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        "Dmitry V. Levin" <ldv@altlinux.org>, Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH] ptrace: make PTRACE_DETACH work on non-stopped tracees.
Date: Wed, 19 Jun 2013 17:15:36 +0200
Message-Id: <1371654936-31742-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before this change debuggers needed to jump through hoops
if they want to detach from a running tracee.

Typically they just try PTRACE_DETACH, and if it fails
with ESRCH, they make tracee enter a ptrace-stop.
Before introduction of PTRACE_INTERRUPT, the only way to do that
was to send a signal (which raced with real signals),
then repeatedly call waitpid looking for (this particular)
signal to be delivered, and finally call PTRACE_DETACH.

With PTRACE_INTERRUPT it is somewhat less ugly,
and not racy wrt signals.

This does not make much sense, especially that kernel code
for detach operation already supports implicit,
asynchronous detach which happens if tracer process exits.

This change simply removes the requirement that tracee is
in ptrace-stop for PTRACE_DETACH to work.

This is a user-visible behavior change.
Do we really have to introduce a separate
PTRACE_NOT_STUPID_DETACH? I hope not.

If this behavior existed from the start, strace
would not need a large, ugly chunk of code it currently has
to handle this quirk.

CCing Jan to hear his comments from gdb side.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
CC: Jan Kratochvil <jan.kratochvil@redhat.com>
CC: Dmitry V. Levin <ldv@altlinux.org>
CC: Oleg Nesterov <oleg@redhat.com>
---
 kernel/ptrace.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index fc07650..2e294bf 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -56,9 +56,7 @@ void __ptrace_link(struct task_struct *child, struct task_struct *new_parent)
  * state.
  *
  * Unlinking can happen via two paths - explicit PTRACE_DETACH or ptracer
- * exiting.  For PTRACE_DETACH, unless the ptracee has been killed between
- * ptrace_check_attach() and here, it's guaranteed to be in TASK_TRACED.
- * If the ptracer is exiting, the ptracee can be in any state.
+ * exiting.  The ptracee is not necessarily ptrace-stopped.
  *
  * After detach, the ptracee should be in a state which conforms to the
  * group stop.  If the group is stopped or in the process of stopping, the
@@ -1062,7 +1060,8 @@ SYSCALL_DEFINE4(ptrace, long, request, long, pid, unsigned long, addr,
 	}
 
 	ret = ptrace_check_attach(child, request == PTRACE_KILL ||
-				  request == PTRACE_INTERRUPT);
+				  request == PTRACE_INTERRUPT ||
+				  request == PTRACE_DETACH);
 	if (ret < 0)
 		goto out_put_task_struct;
 
@@ -1207,7 +1206,8 @@ asmlinkage long compat_sys_ptrace(compat_long_t request, compat_long_t pid,
 	}
 
 	ret = ptrace_check_attach(child, request == PTRACE_KILL ||
-				  request == PTRACE_INTERRUPT);
+				  request == PTRACE_INTERRUPT ||
+				  request == PTRACE_DETACH);
 	if (!ret) {
 		ret = compat_arch_ptrace(child, request, addr, data);
 		if (ret || request != PTRACE_DETACH)
-- 
1.8.1.4

