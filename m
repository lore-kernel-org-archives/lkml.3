Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003Ab3HTVfz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 17:35:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622Ab3HTVd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 17:33:27 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, Eric Paris <eparis@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        John Johansen <john.johansen@canonical.com>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 04/12] audit: convert PPIDs to the inital PID namespace.
Date: Tue, 20 Aug 2013 17:31:56 -0400
Message-Id: <9e4569641ce4948e2f99fe43f69df30a145e04ac.1377032086.git.rgb@redhat.com>
In-Reply-To: <cover.1377032086.git.rgb@redhat.com>
References: <cover.1377032086.git.rgb@redhat.com>
In-Reply-To: <cover.1377032086.git.rgb@redhat.com>
References: <cover.1377032086.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sys_getppid() returns the parent pid of the current process in its own pid
namespace.  Since audit filters are based in the init pid namespace, a process
could avoid a filter or trigger an unintended one by being in an alternate pid
namespace or log meaningless information.

Switch to task_ppid_nr_init_ns() for PPIDs to anchor all audit filters in the
init_pid_ns.

(informed by ebiederman's 6c621b7e)
Cc: stable@vger.kernel.org
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/audit.c            |    4 ++--
 kernel/auditsc.c          |    2 +-
 security/apparmor/audit.c |    5 +----
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 2476334..75b0989 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1588,10 +1588,10 @@ void audit_log_task_info(struct audit_buffer *ab, struct task_struct *tsk)
 	spin_unlock_irq(&tsk->sighand->siglock);
 
 	audit_log_format(ab,
-			 " ppid=%ld pid=%d auid=%u uid=%u gid=%u"
+			 " ppid=%d pid=%d auid=%u uid=%u gid=%u"
 			 " euid=%u suid=%u fsuid=%u"
 			 " egid=%u sgid=%u fsgid=%u ses=%u tty=%s",
-			 sys_getppid(),
+			 task_ppid_nr_init_ns(tsk),
 			 tsk->pid,
 			 from_kuid(&init_user_ns, audit_get_loginuid(tsk)),
 			 from_kuid(&init_user_ns, cred->uid),
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 8c644c5..74a0748 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -466,7 +466,7 @@ static int audit_filter_rules(struct task_struct *tsk,
 		case AUDIT_PPID:
 			if (ctx) {
 				if (!ctx->ppid)
-					ctx->ppid = sys_getppid();
+					ctx->ppid = task_ppid_nr_init_ns(current);
 				result = audit_comparator(ctx->ppid, f->op, f->val);
 			}
 			break;
diff --git a/security/apparmor/audit.c b/security/apparmor/audit.c
index 031d2d9..497b306 100644
--- a/security/apparmor/audit.c
+++ b/security/apparmor/audit.c
@@ -132,10 +132,7 @@ static void audit_pre(struct audit_buffer *ab, void *ca)
 
 	if (sa->aad->profile) {
 		struct aa_profile *profile = sa->aad->profile;
-		pid_t pid;
-		rcu_read_lock();
-		pid = rcu_dereference(tsk->real_parent)->pid;
-		rcu_read_unlock();
+		pid_t pid = task_ppid_nr_init_ns(tsk);
 		audit_log_format(ab, " parent=%d", pid);
 		if (profile->ns != root_ns) {
 			audit_log_format(ab, " namespace=");
-- 
1.7.1

