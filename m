Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168Ab3LWWbP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 17:31:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12658 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757627Ab3LWWbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 17:31:13 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, Eric Paris <eparis@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>, stable@vger.kernel.org
Subject: [PATCH 2/5] audit: convert PPIDs to the inital PID namespace.
Date: Mon, 23 Dec 2013 17:27:36 -0500
Message-Id: <b607363a286c315801a0027401a2df9017a5c419.1387834776.git.rgb@redhat.com>
In-Reply-To: <cover.1377032086.git.rgb@redhat.com>
References: <cover.1377032086.git.rgb@redhat.com>
In-Reply-To: <cover.1387834776.git.rgb@redhat.com>
References: <cover.1387834776.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sys_getppid() returns the parent pid of the current process in its own pid
namespace.  Since audit filters are based in the init pid namespace, a process
could avoid a filter or trigger an unintended one by being in an alternate pid
namespace or log meaningless information.

Switch to task_ppid_nr() for PPIDs to anchor all audit filters in the
init_pid_ns.

(informed by ebiederman's 6c621b7e)
Cc: stable@vger.kernel.org
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/audit.c   |    4 ++--
 kernel/auditsc.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 1b13b82..900f5d6 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1839,10 +1839,10 @@ void audit_log_task_info(struct audit_buffer *ab, struct task_struct *tsk)
 	spin_unlock_irq(&tsk->sighand->siglock);
 
 	audit_log_format(ab,
-			 " ppid=%ld pid=%d auid=%u uid=%u gid=%u"
+			 " ppid=%d pid=%d auid=%u uid=%u gid=%u"
 			 " euid=%u suid=%u fsuid=%u"
 			 " egid=%u sgid=%u fsgid=%u tty=%s ses=%u",
-			 sys_getppid(),
+			 task_ppid_nr(tsk),
 			 tsk->pid,
 			 from_kuid(&init_user_ns, audit_get_loginuid(tsk)),
 			 from_kuid(&init_user_ns, cred->uid),
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 10176cd..d396c8b 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -459,7 +459,7 @@ static int audit_filter_rules(struct task_struct *tsk,
 		case AUDIT_PPID:
 			if (ctx) {
 				if (!ctx->ppid)
-					ctx->ppid = sys_getppid();
+					ctx->ppid = task_ppid_nr(tsk);
 				result = audit_comparator(ctx->ppid, f->op, f->val);
 			}
 			break;
-- 
1.7.1

