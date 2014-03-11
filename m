Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbaCKFCH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 01:02:07 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:34290 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752609AbaCKFCC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 01:02:02 -0400
X-IronPort-AV: E=Sophos;i="4.97,629,1389715200"; 
   d="scan'208";a="9676441"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, peterz@infradead.org, mingo@kernel.org,
        tglx@linutronix.de, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Robin Holt <holt@sgi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 02/15] kernel/sys: Replace opened code implementation with NICE_TO_RLIMIT macro.
Date: Tue, 11 Mar 2014 12:59:17 +0800
Message-Id: <cd5521508aff739398ac1ac098c61d9d86bc5cbc.1394513466.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1394513466.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1394513466.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 12:58:42,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 12:58:52,
	Serialize complete at 2014/03/11 12:58:52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

Convert 20 - task_nice(p) to NICE_TO_RLIMIT(task_nice(p)).

Reduce the indent the switch case labels while there.

git diff -w shows 3 lines changed and a /* fall-through */ comment added

  $ git diff -w -U0 kernel/sys.c
  @@ -253 +253 @@ SYSCALL_DEFINE2(getpriority, int, which, int, who)
  -                               niceval = 20 - task_nice(p);
  +                       niceval = NICE_TO_RLIMIT(task_nice(p));
  @@ -264 +264 @@ SYSCALL_DEFINE2(getpriority, int, which, int, who)
  -                               niceval = 20 - task_nice(p);
  +                       niceval = NICE_TO_RLIMIT(task_nice(p));
  @@ -280 +280 @@ SYSCALL_DEFINE2(getpriority, int, which, int, who)
  -                                       niceval = 20 - task_nice(p);
  +                               niceval = NICE_TO_RLIMIT(task_nice(p));
  @@ -1558 +1558 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
  -
  +               /* fall-through */

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
cc: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Robin Holt <holt@sgi.com>
cc: Oleg Nesterov <oleg@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/sys.c | 206 +++++++++++++++++++++++++++++------------------------------
 1 file changed, 103 insertions(+), 103 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index adaeab6..b03aba3 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -182,39 +182,39 @@ SYSCALL_DEFINE3(setpriority, int, which, int, who, int, niceval)
 	rcu_read_lock();
 	read_lock(&tasklist_lock);
 	switch (which) {
-		case PRIO_PROCESS:
-			if (who)
-				p = find_task_by_vpid(who);
-			else
-				p = current;
-			if (p)
-				error = set_one_prio(p, niceval, error);
-			break;
-		case PRIO_PGRP:
-			if (who)
-				pgrp = find_vpid(who);
-			else
-				pgrp = task_pgrp(current);
-			do_each_pid_thread(pgrp, PIDTYPE_PGID, p) {
+	case PRIO_PROCESS:
+		if (who)
+			p = find_task_by_vpid(who);
+		else
+			p = current;
+		if (p)
+			error = set_one_prio(p, niceval, error);
+		break;
+	case PRIO_PGRP:
+		if (who)
+			pgrp = find_vpid(who);
+		else
+			pgrp = task_pgrp(current);
+		do_each_pid_thread(pgrp, PIDTYPE_PGID, p) {
+			error = set_one_prio(p, niceval, error);
+		} while_each_pid_thread(pgrp, PIDTYPE_PGID, p);
+		break;
+	case PRIO_USER:
+		uid = make_kuid(cred->user_ns, who);
+		user = cred->user;
+		if (!who)
+			uid = cred->uid;
+		else if (!uid_eq(uid, cred->uid) &&
+			 !(user = find_user(uid)))
+			goto out_unlock;	/* No processes for this user */
+
+		do_each_thread(g, p) {
+			if (uid_eq(task_uid(p), uid))
 				error = set_one_prio(p, niceval, error);
-			} while_each_pid_thread(pgrp, PIDTYPE_PGID, p);
-			break;
-		case PRIO_USER:
-			uid = make_kuid(cred->user_ns, who);
-			user = cred->user;
-			if (!who)
-				uid = cred->uid;
-			else if (!uid_eq(uid, cred->uid) &&
-				 !(user = find_user(uid)))
-				goto out_unlock;	/* No processes for this user */
-
-			do_each_thread(g, p) {
-				if (uid_eq(task_uid(p), uid))
-					error = set_one_prio(p, niceval, error);
-			} while_each_thread(g, p);
-			if (!uid_eq(uid, cred->uid))
-				free_uid(user);		/* For find_user() */
-			break;
+		} while_each_thread(g, p);
+		if (!uid_eq(uid, cred->uid))
+			free_uid(user);		/* For find_user() */
+		break;
 	}
 out_unlock:
 	read_unlock(&tasklist_lock);
@@ -244,47 +244,47 @@ SYSCALL_DEFINE2(getpriority, int, which, int, who)
 	rcu_read_lock();
 	read_lock(&tasklist_lock);
 	switch (which) {
-		case PRIO_PROCESS:
-			if (who)
-				p = find_task_by_vpid(who);
-			else
-				p = current;
-			if (p) {
-				niceval = 20 - task_nice(p);
+	case PRIO_PROCESS:
+		if (who)
+			p = find_task_by_vpid(who);
+		else
+			p = current;
+		if (p) {
+			niceval = NICE_TO_RLIMIT(task_nice(p));
+			if (niceval > retval)
+				retval = niceval;
+		}
+		break;
+	case PRIO_PGRP:
+		if (who)
+			pgrp = find_vpid(who);
+		else
+			pgrp = task_pgrp(current);
+		do_each_pid_thread(pgrp, PIDTYPE_PGID, p) {
+			niceval = NICE_TO_RLIMIT(task_nice(p));
+			if (niceval > retval)
+				retval = niceval;
+		} while_each_pid_thread(pgrp, PIDTYPE_PGID, p);
+		break;
+	case PRIO_USER:
+		uid = make_kuid(cred->user_ns, who);
+		user = cred->user;
+		if (!who)
+			uid = cred->uid;
+		else if (!uid_eq(uid, cred->uid) &&
+			 !(user = find_user(uid)))
+			goto out_unlock;	/* No processes for this user */
+
+		do_each_thread(g, p) {
+			if (uid_eq(task_uid(p), uid)) {
+				niceval = NICE_TO_RLIMIT(task_nice(p));
 				if (niceval > retval)
 					retval = niceval;
 			}
-			break;
-		case PRIO_PGRP:
-			if (who)
-				pgrp = find_vpid(who);
-			else
-				pgrp = task_pgrp(current);
-			do_each_pid_thread(pgrp, PIDTYPE_PGID, p) {
-				niceval = 20 - task_nice(p);
-				if (niceval > retval)
-					retval = niceval;
-			} while_each_pid_thread(pgrp, PIDTYPE_PGID, p);
-			break;
-		case PRIO_USER:
-			uid = make_kuid(cred->user_ns, who);
-			user = cred->user;
-			if (!who)
-				uid = cred->uid;
-			else if (!uid_eq(uid, cred->uid) &&
-				 !(user = find_user(uid)))
-				goto out_unlock;	/* No processes for this user */
-
-			do_each_thread(g, p) {
-				if (uid_eq(task_uid(p), uid)) {
-					niceval = 20 - task_nice(p);
-					if (niceval > retval)
-						retval = niceval;
-				}
-			} while_each_thread(g, p);
-			if (!uid_eq(uid, cred->uid))
-				free_uid(user);		/* for find_user() */
-			break;
+		} while_each_thread(g, p);
+		if (!uid_eq(uid, cred->uid))
+			free_uid(user);		/* for find_user() */
+		break;
 	}
 out_unlock:
 	read_unlock(&tasklist_lock);
@@ -1541,41 +1541,41 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
 		return;
 
 	switch (who) {
-		case RUSAGE_BOTH:
-		case RUSAGE_CHILDREN:
-			utime = p->signal->cutime;
-			stime = p->signal->cstime;
-			r->ru_nvcsw = p->signal->cnvcsw;
-			r->ru_nivcsw = p->signal->cnivcsw;
-			r->ru_minflt = p->signal->cmin_flt;
-			r->ru_majflt = p->signal->cmaj_flt;
-			r->ru_inblock = p->signal->cinblock;
-			r->ru_oublock = p->signal->coublock;
-			maxrss = p->signal->cmaxrss;
-
-			if (who == RUSAGE_CHILDREN)
-				break;
-
-		case RUSAGE_SELF:
-			thread_group_cputime_adjusted(p, &tgutime, &tgstime);
-			utime += tgutime;
-			stime += tgstime;
-			r->ru_nvcsw += p->signal->nvcsw;
-			r->ru_nivcsw += p->signal->nivcsw;
-			r->ru_minflt += p->signal->min_flt;
-			r->ru_majflt += p->signal->maj_flt;
-			r->ru_inblock += p->signal->inblock;
-			r->ru_oublock += p->signal->oublock;
-			if (maxrss < p->signal->maxrss)
-				maxrss = p->signal->maxrss;
-			t = p;
-			do {
-				accumulate_thread_rusage(t, r);
-			} while_each_thread(p, t);
+	case RUSAGE_BOTH:
+	case RUSAGE_CHILDREN:
+		utime = p->signal->cutime;
+		stime = p->signal->cstime;
+		r->ru_nvcsw = p->signal->cnvcsw;
+		r->ru_nivcsw = p->signal->cnivcsw;
+		r->ru_minflt = p->signal->cmin_flt;
+		r->ru_majflt = p->signal->cmaj_flt;
+		r->ru_inblock = p->signal->cinblock;
+		r->ru_oublock = p->signal->coublock;
+		maxrss = p->signal->cmaxrss;
+
+		if (who == RUSAGE_CHILDREN)
 			break;
+		/* fall-through */
+	case RUSAGE_SELF:
+		thread_group_cputime_adjusted(p, &tgutime, &tgstime);
+		utime += tgutime;
+		stime += tgstime;
+		r->ru_nvcsw += p->signal->nvcsw;
+		r->ru_nivcsw += p->signal->nivcsw;
+		r->ru_minflt += p->signal->min_flt;
+		r->ru_majflt += p->signal->maj_flt;
+		r->ru_inblock += p->signal->inblock;
+		r->ru_oublock += p->signal->oublock;
+		if (maxrss < p->signal->maxrss)
+			maxrss = p->signal->maxrss;
+		t = p;
+		do {
+			accumulate_thread_rusage(t, r);
+		} while_each_thread(p, t);
+		break;
 
-		default:
-			BUG();
+	default:
+		BUG();
 	}
 	unlock_task_sighand(p, &flags);
 
-- 
1.8.2.1

