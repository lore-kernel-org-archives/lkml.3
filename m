Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbaDXKLq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 06:11:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46646 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113AbaDXIx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:53:57 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Richard Guy Briggs <rgb@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 084/182] audit: convert PPIDs to the inital PID namespace.
Date: Thu, 24 Apr 2014 09:50:09 +0100
Message-Id: <1398329507-5911-85-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/audit.c   | 4 ++--
 kernel/auditsc.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 6def25f..aea9a19 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1613,10 +1613,10 @@ void audit_log_task_info(struct audit_buffer *ab, struct task_struct *tsk)
 	spin_unlock_irq(&tsk->sighand->siglock);
 
 	audit_log_format(ab,
-			 " ppid=%ld pid=%d auid=%u uid=%u gid=%u"
+			 " ppid=%d pid=%d auid=%u uid=%u gid=%u"
 			 " euid=%u suid=%u fsuid=%u"
 			 " egid=%u sgid=%u fsgid=%u ses=%u tty=%s",
-			 sys_getppid(),
+			 task_ppid_nr(tsk),
 			 tsk->pid,
 			 from_kuid(&init_user_ns, audit_get_loginuid(tsk)),
 			 from_kuid(&init_user_ns, cred->uid),
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 9845cb3..3b79a47 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -472,7 +472,7 @@ static int audit_filter_rules(struct task_struct *tsk,
 		case AUDIT_PPID:
 			if (ctx) {
 				if (!ctx->ppid)
-					ctx->ppid = sys_getppid();
+					ctx->ppid = task_ppid_nr(tsk);
 				result = audit_comparator(ctx->ppid, f->op, f->val);
 			}
 			break;
-- 
1.9.1

