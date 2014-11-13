Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933655AbaKMSEk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 13:04:40 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:49563 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932866AbaKMSEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 13:04:38 -0500
Date: Thu, 13 Nov 2014 10:04:34 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Aaron Tomlin <atomlin@redhat.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] proc: task_state: move the main seq_printf() outside
	of rcu_read_lock()
Message-ID: <20141113180433.GK4460@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141107201424.GA22209@redhat.com>
 <20141107201451.GA22243@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141107201451.GA22243@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14111318-0013-0000-0000-0000063B4791
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 09:14:51PM +0100, Oleg Nesterov wrote:
> task_state() does seq_printf() under rcu_read_lock(), but this is only
> needed for task_tgid_nr_ns() and task_numa_group_id(). We can calculate
> tgid/ngid and drop rcu lock.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  fs/proc/array.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/proc/array.c b/fs/proc/array.c
> index 7c8d9ae..800e30f 100644
> --- a/fs/proc/array.c
> +++ b/fs/proc/array.c
> @@ -158,7 +158,7 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
>  	struct group_info *group_info;
>  	int g;
>  	const struct cred *cred;
> -	pid_t ppid, tpid;
> +	pid_t ppid, tpid, tgid, ngid;
>  	unsigned int max_fds = 0;
> 
>  	rcu_read_lock();
> @@ -170,12 +170,16 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
>  		if (tracer)
>  			tpid = task_pid_nr_ns(tracer, ns);
>  	}
> +
> +	tgid = task_tgid_nr_ns(p, ns);
> +	ngid = task_numa_group_id(p);
>  	cred = get_task_cred(p);
> 
>  	task_lock(p);
>  	if (p->files)
>  		max_fds = files_fdtable(p->files)->max_fds;
>  	task_unlock(p);
> +	rcu_read_unlock();
> 
>  	seq_printf(m,
>  		"State:\t%s\n"
> @@ -188,10 +192,7 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
>  		"Gid:\t%d\t%d\t%d\t%d\n"
>  		"FDSize:\t%d\nGroups:\t",
>  		get_task_state(p),
> -		task_tgid_nr_ns(p, ns),
> -		task_numa_group_id(p),
> -		pid_nr_ns(pid, ns),
> -		ppid, tpid,
> +		tgid, ngid, pid_nr_ns(pid, ns), ppid, tpid,
>  		from_kuid_munged(user_ns, cred->uid),
>  		from_kuid_munged(user_ns, cred->euid),
>  		from_kuid_munged(user_ns, cred->suid),
> @@ -201,7 +202,6 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
>  		from_kgid_munged(user_ns, cred->sgid),
>  		from_kgid_munged(user_ns, cred->fsgid),
>  		max_fds);
> -	rcu_read_unlock();
> 
>  	group_info = cred->group_info;
>  	for (g = 0; g < group_info->ngroups; g++)
> -- 
> 1.5.5.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

