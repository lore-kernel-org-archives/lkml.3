Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146AbaCKBTY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 21:19:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60141 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbaCKBTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 21:19:23 -0400
X-IronPort-AV: E=Sophos;i="4.97,627,1389715200"; 
   d="scan'208";a="9675106"
Message-ID: <531E6416.6020106@cn.fujitsu.com>
Date: Tue, 11 Mar 2014 09:17:10 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        peterz@infradead.org, mingo@redhat.com
Subject: Re: [PATCH] kernel/sys: Replace hardcoding of 20 with MAX_NICE +
 1
References: <8ae8a3aefb157e9e7d1b62a4c136289e74783eaf.1394022835.git.yangds.fnst@cn.fujitsu.com>  <1d7cbeaa53561339ddf3b987fce6a7302d7405a3.1394022835.git.yangds.fnst@cn.fujitsu.com> <1394490222.21085.16.camel@joe-AO722>
In-Reply-To: <1394490222.21085.16.camel@joe-AO722>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 09:16:19,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 09:16:36,
	Serialize complete at 2014/03/11 09:16:36
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On 03/11/2014 06:23 AM, Joe Perches wrote:
> Convert the use of 20 to NICE_MAX + 1.

What about adding a macro in prio.h to convert nice value [19,-20] to 
rlimit
style value [1,40]?

It seems that it will be used in several places.

- Dongsheng
>
> Reduce the indent the switch case labels while there.
>
> git diff -w shows 3 lines changed and a /* fall-through */ comment added
>
>    $ git diff -w -U0 kernel/sys.c
>    @@ -253 +253 @@ SYSCALL_DEFINE2(getpriority, int, which, int, who)
>    -                               niceval = 20 - task_nice(p);
>    +                       niceval = MAX_NICE - task_nice(p) + 1;
>    @@ -264 +264 @@ SYSCALL_DEFINE2(getpriority, int, which, int, who)
>    -                               niceval = 20 - task_nice(p);
>    +                       niceval = MAX_NICE - task_nice(p) + 1;
>    @@ -280 +280 @@ SYSCALL_DEFINE2(getpriority, int, which, int, who)
>    -                                       niceval = 20 - task_nice(p);
>    +                               niceval = MAX_NICE - task_nice(p) + 1;
>    @@ -1558 +1558 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
>    -
>    +               /* fall-through */
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>   kernel/sys.c | 206 +++++++++++++++++++++++++++++------------------------------
>   1 file changed, 103 insertions(+), 103 deletions(-)
>
> diff --git a/kernel/sys.c b/kernel/sys.c
> index fba0f29..0bd5fe9 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -182,39 +182,39 @@ SYSCALL_DEFINE3(setpriority, int, which, int, who, int, niceval)
>   	rcu_read_lock();
>   	read_lock(&tasklist_lock);
>   	switch (which) {
> -		case PRIO_PROCESS:
> -			if (who)
> -				p = find_task_by_vpid(who);
> -			else
> -				p = current;
> -			if (p)
> -				error = set_one_prio(p, niceval, error);
> -			break;
> -		case PRIO_PGRP:
> -			if (who)
> -				pgrp = find_vpid(who);
> -			else
> -				pgrp = task_pgrp(current);
> -			do_each_pid_thread(pgrp, PIDTYPE_PGID, p) {
> +	case PRIO_PROCESS:
> +		if (who)
> +			p = find_task_by_vpid(who);
> +		else
> +			p = current;
> +		if (p)
> +			error = set_one_prio(p, niceval, error);
> +		break;
> +	case PRIO_PGRP:
> +		if (who)
> +			pgrp = find_vpid(who);
> +		else
> +			pgrp = task_pgrp(current);
> +		do_each_pid_thread(pgrp, PIDTYPE_PGID, p) {
> +			error = set_one_prio(p, niceval, error);
> +		} while_each_pid_thread(pgrp, PIDTYPE_PGID, p);
> +		break;
> +	case PRIO_USER:
> +		uid = make_kuid(cred->user_ns, who);
> +		user = cred->user;
> +		if (!who)
> +			uid = cred->uid;
> +		else if (!uid_eq(uid, cred->uid) &&
> +			 !(user = find_user(uid)))
> +			goto out_unlock;	/* No processes for this user */
> +
> +		do_each_thread(g, p) {
> +			if (uid_eq(task_uid(p), uid))
>   				error = set_one_prio(p, niceval, error);
> -			} while_each_pid_thread(pgrp, PIDTYPE_PGID, p);
> -			break;
> -		case PRIO_USER:
> -			uid = make_kuid(cred->user_ns, who);
> -			user = cred->user;
> -			if (!who)
> -				uid = cred->uid;
> -			else if (!uid_eq(uid, cred->uid) &&
> -				 !(user = find_user(uid)))
> -				goto out_unlock;	/* No processes for this user */
> -
> -			do_each_thread(g, p) {
> -				if (uid_eq(task_uid(p), uid))
> -					error = set_one_prio(p, niceval, error);
> -			} while_each_thread(g, p);
> -			if (!uid_eq(uid, cred->uid))
> -				free_uid(user);		/* For find_user() */
> -			break;
> +		} while_each_thread(g, p);
> +		if (!uid_eq(uid, cred->uid))
> +			free_uid(user);		/* For find_user() */
> +		break;
>   	}
>   out_unlock:
>   	read_unlock(&tasklist_lock);
> @@ -244,47 +244,47 @@ SYSCALL_DEFINE2(getpriority, int, which, int, who)
>   	rcu_read_lock();
>   	read_lock(&tasklist_lock);
>   	switch (which) {
> -		case PRIO_PROCESS:
> -			if (who)
> -				p = find_task_by_vpid(who);
> -			else
> -				p = current;
> -			if (p) {
> -				niceval = 20 - task_nice(p);
> +	case PRIO_PROCESS:
> +		if (who)
> +			p = find_task_by_vpid(who);
> +		else
> +			p = current;
> +		if (p) {
> +			niceval = MAX_NICE - task_nice(p) + 1;
> +			if (niceval > retval)
> +				retval = niceval;
> +		}
> +		break;
> +	case PRIO_PGRP:
> +		if (who)
> +			pgrp = find_vpid(who);
> +		else
> +			pgrp = task_pgrp(current);
> +		do_each_pid_thread(pgrp, PIDTYPE_PGID, p) {
> +			niceval = MAX_NICE - task_nice(p) + 1;
> +			if (niceval > retval)
> +				retval = niceval;
> +		} while_each_pid_thread(pgrp, PIDTYPE_PGID, p);
> +		break;
> +	case PRIO_USER:
> +		uid = make_kuid(cred->user_ns, who);
> +		user = cred->user;
> +		if (!who)
> +			uid = cred->uid;
> +		else if (!uid_eq(uid, cred->uid) &&
> +			 !(user = find_user(uid)))
> +			goto out_unlock;	/* No processes for this user */
> +
> +		do_each_thread(g, p) {
> +			if (uid_eq(task_uid(p), uid)) {
> +				niceval = MAX_NICE - task_nice(p) + 1;
>   				if (niceval > retval)
>   					retval = niceval;
>   			}
> -			break;
> -		case PRIO_PGRP:
> -			if (who)
> -				pgrp = find_vpid(who);
> -			else
> -				pgrp = task_pgrp(current);
> -			do_each_pid_thread(pgrp, PIDTYPE_PGID, p) {
> -				niceval = 20 - task_nice(p);
> -				if (niceval > retval)
> -					retval = niceval;
> -			} while_each_pid_thread(pgrp, PIDTYPE_PGID, p);
> -			break;
> -		case PRIO_USER:
> -			uid = make_kuid(cred->user_ns, who);
> -			user = cred->user;
> -			if (!who)
> -				uid = cred->uid;
> -			else if (!uid_eq(uid, cred->uid) &&
> -				 !(user = find_user(uid)))
> -				goto out_unlock;	/* No processes for this user */
> -
> -			do_each_thread(g, p) {
> -				if (uid_eq(task_uid(p), uid)) {
> -					niceval = 20 - task_nice(p);
> -					if (niceval > retval)
> -						retval = niceval;
> -				}
> -			} while_each_thread(g, p);
> -			if (!uid_eq(uid, cred->uid))
> -				free_uid(user);		/* for find_user() */
> -			break;
> +		} while_each_thread(g, p);
> +		if (!uid_eq(uid, cred->uid))
> +			free_uid(user);		/* for find_user() */
> +		break;
>   	}
>   out_unlock:
>   	read_unlock(&tasklist_lock);
> @@ -1541,41 +1541,41 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
>   		return;
>   
>   	switch (who) {
> -		case RUSAGE_BOTH:
> -		case RUSAGE_CHILDREN:
> -			utime = p->signal->cutime;
> -			stime = p->signal->cstime;
> -			r->ru_nvcsw = p->signal->cnvcsw;
> -			r->ru_nivcsw = p->signal->cnivcsw;
> -			r->ru_minflt = p->signal->cmin_flt;
> -			r->ru_majflt = p->signal->cmaj_flt;
> -			r->ru_inblock = p->signal->cinblock;
> -			r->ru_oublock = p->signal->coublock;
> -			maxrss = p->signal->cmaxrss;
> -
> -			if (who == RUSAGE_CHILDREN)
> -				break;
> -
> -		case RUSAGE_SELF:
> -			thread_group_cputime_adjusted(p, &tgutime, &tgstime);
> -			utime += tgutime;
> -			stime += tgstime;
> -			r->ru_nvcsw += p->signal->nvcsw;
> -			r->ru_nivcsw += p->signal->nivcsw;
> -			r->ru_minflt += p->signal->min_flt;
> -			r->ru_majflt += p->signal->maj_flt;
> -			r->ru_inblock += p->signal->inblock;
> -			r->ru_oublock += p->signal->oublock;
> -			if (maxrss < p->signal->maxrss)
> -				maxrss = p->signal->maxrss;
> -			t = p;
> -			do {
> -				accumulate_thread_rusage(t, r);
> -			} while_each_thread(p, t);
> +	case RUSAGE_BOTH:
> +	case RUSAGE_CHILDREN:
> +		utime = p->signal->cutime;
> +		stime = p->signal->cstime;
> +		r->ru_nvcsw = p->signal->cnvcsw;
> +		r->ru_nivcsw = p->signal->cnivcsw;
> +		r->ru_minflt = p->signal->cmin_flt;
> +		r->ru_majflt = p->signal->cmaj_flt;
> +		r->ru_inblock = p->signal->cinblock;
> +		r->ru_oublock = p->signal->coublock;
> +		maxrss = p->signal->cmaxrss;
> +
> +		if (who == RUSAGE_CHILDREN)
>   			break;
> +		/* fall-through */
> +	case RUSAGE_SELF:
> +		thread_group_cputime_adjusted(p, &tgutime, &tgstime);
> +		utime += tgutime;
> +		stime += tgstime;
> +		r->ru_nvcsw += p->signal->nvcsw;
> +		r->ru_nivcsw += p->signal->nivcsw;
> +		r->ru_minflt += p->signal->min_flt;
> +		r->ru_majflt += p->signal->maj_flt;
> +		r->ru_inblock += p->signal->inblock;
> +		r->ru_oublock += p->signal->oublock;
> +		if (maxrss < p->signal->maxrss)
> +			maxrss = p->signal->maxrss;
> +		t = p;
> +		do {
> +			accumulate_thread_rusage(t, r);
> +		} while_each_thread(p, t);
> +		break;
>   
> -		default:
> -			BUG();
> +	default:
> +		BUG();
>   	}
>   	unlock_task_sighand(p, &flags);
>   
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

