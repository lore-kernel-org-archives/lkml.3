Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126AbaD1Bba (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:31:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42897 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752583AbaD1B3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:21 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Richard Guy Briggs" <rgb@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Mon, 28 Apr 2014 02:11:22 +0100
Message-ID: <lsq.1398647482.952226570@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 57/94] audit: convert PPIDs to the inital PID namespace.
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: sys_getppid() is used by audit_exit() but not
 audit_log_task_info()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -473,7 +473,7 @@ static int audit_filter_rules(struct tas
 		case AUDIT_PPID:
 			if (ctx) {
 				if (!ctx->ppid)
-					ctx->ppid = sys_getppid();
+					ctx->ppid = task_ppid_nr(tsk);
 				result = audit_comparator(ctx->ppid, f->op, f->val);
 			}
 			break;
@@ -1335,7 +1335,7 @@ static void audit_log_exit(struct audit_
 	/* tsk == current */
 	context->pid = tsk->pid;
 	if (!context->ppid)
-		context->ppid = sys_getppid();
+		context->ppid = task_ppid_nr(tsk);
 	cred = current_cred();
 	context->uid   = cred->uid;
 	context->gid   = cred->gid;

