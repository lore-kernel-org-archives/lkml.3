Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbaE2Ee4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:34:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57588 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756038AbaE2Eep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:34:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH 3.14 007/140] audit: convert PPIDs to the inital PID namespace.
Date: Wed, 28 May 2014 21:32:26 -0700
Message-Id: <20140529043050.502148731@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/audit.c   |    4 ++--
 kernel/auditsc.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1829,10 +1829,10 @@ void audit_log_task_info(struct audit_bu
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
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -459,7 +459,7 @@ static int audit_filter_rules(struct tas
 		case AUDIT_PPID:
 			if (ctx) {
 				if (!ctx->ppid)
-					ctx->ppid = sys_getppid();
+					ctx->ppid = task_ppid_nr(tsk);
 				result = audit_comparator(ctx->ppid, f->op, f->val);
 			}
 			break;


