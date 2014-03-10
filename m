Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbaCJWXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 18:23:48 -0400
Received: from smtprelay0048.hostedemail.com ([216.40.44.48]:55436 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752553AbaCJWXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 18:23:47 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:2:41:69:355:379:541:800:960:966:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1535:1593:1594:1605:1730:1747:1777:1792:1801:2196:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3865:3866:3867:3868:4041:4050:4119:4321:4385:4605:5007:6117:7652:7875:9592:10004:10848:11026:11232:11658:11914:12043:12291:12296:12438:12517:12519:12555:12683,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: rice68_20a0207c03d41
X-Filterd-Recvd-Size: 8730
Message-ID: <1394490222.21085.16.camel@joe-AO722>
Subject: [PATCH] kernel/sys: Replace hardcoding of 20 with MAX_NICE + 1
From: Joe Perches <joe@perches.com>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        peterz@infradead.org, mingo@redhat.com
Date: Mon, 10 Mar 2014 15:23:42 -0700
In-Reply-To: <1d7cbeaa53561339ddf3b987fce6a7302d7405a3.1394022835.git.yangds.fnst@cn.fujitsu.com>
References: <8ae8a3aefb157e9e7d1b62a4c136289e74783eaf.1394022835.git.yangds.fnst@cn.fujitsu.com>
	 <1d7cbeaa53561339ddf3b987fce6a7302d7405a3.1394022835.git.yangds.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the use of 20 to NICE_MAX + 1.

Reduce the indent the switch case labels while there.

git diff -w shows 3 lines changed and a /* fall-through */ comment added

  $ git diff -w -U0 kernel/sys.c
  @@ -253 +253 @@ SYSCALL_DEFINE2(getpriority, int, which, int, who)
  -                               niceval = 20 - task_nice(p);
  +                       niceval = MAX_NICE - task_nice(p) + 1;
  @@ -264 +264 @@ SYSCALL_DEFINE2(getpriority, int, which, int, who)
  -                               niceval = 20 - task_nice(p);
  +                       niceval = MAX_NICE - task_nice(p) + 1;
  @@ -280 +280 @@ SYSCALL_DEFINE2(getpriority, int, which, int, who)
  -                                       niceval = 20 - task_nice(p);
  +                               niceval = MAX_NICE - task_nice(p) + 1;
  @@ -1558 +1558 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
  -
  +               /* fall-through */

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/sys.c | 206 +++++++++++++++++++++++++++++------------------------------
 1 file changed, 103 insertions(+), 103 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index fba0f29..0bd5fe9 100644
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
+			niceval = MAX_NICE - task_nice(p) + 1;
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
+			niceval = MAX_NICE - task_nice(p) + 1;
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
+				niceval = MAX_NICE - task_nice(p) + 1;
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
 


