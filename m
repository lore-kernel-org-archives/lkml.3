Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967855Ab3E3H7F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 03:59:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56628 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S967643Ab3E3H64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 03:58:56 -0400
X-IronPort-AV: E=Sophos;i="4.87,769,1363104000"; 
   d="scan'208";a="7411035"
From: liguang <lig.fnst@cn.fujitsu.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, Dave Jones <davej@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Al Viro <viro@zeniv.linux.org.uk>, liguang <lig.fnst@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] sys: remove unnecesscary parameter of set_one_prio
Date: Thu, 30 May 2013 15:58:03 +0800
Message-Id: <1369900686-5936-1-git-send-email-lig.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.2.5
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/30 15:57:13,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/30 15:57:14,
	Serialize complete at 2013/05/30 15:57:14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
---
 kernel/sys.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index b95d3c7..07c6177 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -151,9 +151,9 @@ static bool set_one_prio_perm(struct task_struct *p)
  * set the priority of a task
  * - the caller must hold the RCU read lock
  */
-static int set_one_prio(struct task_struct *p, int niceval, int error)
+static int set_one_prio(struct task_struct *p, int niceval)
 {
-	int no_nice;
+	int no_nice, error = 0;
 
 	if (!set_one_prio_perm(p)) {
 		error = -EPERM;
@@ -168,8 +168,6 @@ static int set_one_prio(struct task_struct *p, int niceval, int error)
 		error = no_nice;
 		goto out;
 	}
-	if (error == -ESRCH)
-		error = 0;
 	set_user_nice(p, niceval);
 out:
 	return error;
@@ -203,7 +201,7 @@ SYSCALL_DEFINE3(setpriority, int, which, int, who, int, niceval)
 			else
 				p = current;
 			if (p)
-				error = set_one_prio(p, niceval, error);
+				error = set_one_prio(p, niceval);
 			break;
 		case PRIO_PGRP:
 			if (who)
@@ -211,7 +209,7 @@ SYSCALL_DEFINE3(setpriority, int, which, int, who, int, niceval)
 			else
 				pgrp = task_pgrp(current);
 			do_each_pid_thread(pgrp, PIDTYPE_PGID, p) {
-				error = set_one_prio(p, niceval, error);
+				error = set_one_prio(p, niceval);
 			} while_each_pid_thread(pgrp, PIDTYPE_PGID, p);
 			break;
 		case PRIO_USER:
@@ -225,7 +223,7 @@ SYSCALL_DEFINE3(setpriority, int, which, int, who, int, niceval)
 
 			do_each_thread(g, p) {
 				if (uid_eq(task_uid(p), uid))
-					error = set_one_prio(p, niceval, error);
+					error = set_one_prio(p, niceval);
 			} while_each_thread(g, p);
 			if (!uid_eq(uid, cred->uid))
 				free_uid(user);		/* For find_user() */
-- 
1.7.2.5

