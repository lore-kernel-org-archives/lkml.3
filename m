Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758411AbaDVUif (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:38:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36661 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758198AbaDVUYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:24:51 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Richard Guy Briggs <rgb@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 089/133] audit: convert PPIDs to the inital PID namespace.
Date: Tue, 22 Apr 2014 13:13:47 -0700
Message-Id: <1398197671-12786-90-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398197671-12786-1-git-send-email-kamal@canonical.com>
References: <1398197671-12786-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Guy Briggs <rgb@redhat.com>

commit c92cdeb45eea38515e82187f48c2e4f435fb4e25 upstream.

sys_getppid() returns the parent pid of the current process in its own pid
namespace.  Since audit filters are based in the init pid namespace, a process
could avoid a filter or trigger an unintended one by being in an alternate pid
namespace or log meaningless information.

Switch to task_ppid_nr() for PPIDs to anchor all audit filters in the
init_pid_ns.

(informed by ebiederman's 6c621b7e)
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/auditsc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index a371f85..ba198b1 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -615,7 +615,7 @@ static int audit_filter_rules(struct task_struct *tsk,
 		case AUDIT_PPID:
 			if (ctx) {
 				if (!ctx->ppid)
-					ctx->ppid = sys_getppid();
+					ctx->ppid = task_ppid_nr(tsk);
 				result = audit_comparator(ctx->ppid, f->op, f->val);
 			}
 			break;
@@ -1150,10 +1150,10 @@ void audit_log_task_info(struct audit_buffer *ab, struct task_struct *tsk)
 
 
 	audit_log_format(ab,
-			 " ppid=%ld pid=%d auid=%u uid=%u gid=%u"
+			 " ppid=%d pid=%d auid=%u uid=%u gid=%u"
 			 " euid=%u suid=%u fsuid=%u"
 			 " egid=%u sgid=%u fsgid=%u ses=%u tty=%s",
-			 sys_getppid(),
+			 task_ppid_nr(tsk),
 			 tsk->pid,
 			 from_kuid(&init_user_ns, tsk->loginuid),
 			 from_kuid(&init_user_ns, cred->uid),
-- 
1.9.1

