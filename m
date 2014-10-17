Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446AbaJQJ2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 05:28:19 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:37022
	"EHLO mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaJQJ2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 05:28:16 -0400
Date: Fri, 17 Oct 2014 11:28:14 +0200
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Aditya Kali <adityakali@google.com>
Cc: tj@kernel.org, lizefan@huawei.com, serge.hallyn@ubuntu.com,
        luto@amacapital.net, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        mingo@redhat.com, containers@lists.linux-foundation.org
Subject: Re: [PATCHv1 6/8] cgroup: restrict cgroup operations within task's
 cgroupns
Message-ID: <20141017092814.GA8848@mail.hallyn.com>
References: <adityakali-cgroupns>
 <1413235430-22944-1-git-send-email-adityakali@google.com>
 <1413235430-22944-7-git-send-email-adityakali@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413235430-22944-7-git-send-email-adityakali@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Aditya Kali (adityakali@google.com):
> Restrict following operations within the calling tasks:
> * cgroup_mkdir & cgroup_rmdir
> * cgroup_attach_task
> * writes to cgroup files outside of task's cgroupns-root
> 
> Also, read of /proc/<pid>/cgroup file is now restricted only
> to tasks under same cgroupns-root. If a task tries to look
> at cgroup of another task outside of its cgroupns-root, then
> it won't be able to see anything for the default hierarchy.
> This is same as if the cgroups are not mounted.
> 
> Signed-off-by: Aditya Kali <adityakali@google.com>

So this is a bit different from some other namespaces - if I
have an open fd to a file, then setns into a mntns where that
file is not addressable, I can still use the file.

I guess not allowing attach to a cgroup outside our ns is a
good failsafe as we'll otherwise risk falling off a cliff in
some code, but I'm not sure the cgroup_file_write/mkdir/rmdir
restrictions are needed.  (And really I can fchdir to a
directory not in my ns, so the cgroup-attach restriction is
any more justified).

Still I'm not strictly opposed ot this, so

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

just wanted to point this out.

> ---
>  kernel/cgroup.c | 34 +++++++++++++++++++++++++++++++++-
>  1 file changed, 33 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index f8099b4..2fc0dfa 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -2318,6 +2318,12 @@ static int cgroup_attach_task(struct cgroup *dst_cgrp,
>  	struct task_struct *task;
>  	int ret;
>  
> +	/* Only allow changing cgroups accessible within task's cgroup
> +	 * namespace. i.e. 'dst_cgrp' should be a descendant of task's
> +	 * cgroupns->root_cgrp. */
> +	if (!cgroup_is_descendant(dst_cgrp, task_cgroupns_root(leader)))
> +		return -EPERM;
> +
>  	/* look up all src csets */
>  	down_read(&css_set_rwsem);
>  	rcu_read_lock();
> @@ -2882,6 +2888,10 @@ static ssize_t cgroup_file_write(struct kernfs_open_file *of, char *buf,
>  	struct cgroup_subsys_state *css;
>  	int ret;
>  
> +	/* Reject writes to cgroup files outside of task's cgroupns-root. */
> +	if (!cgroup_is_descendant(cgrp, task_cgroupns_root(current)))
> +		return -EINVAL;
> +
>  	if (cft->write)
>  		return cft->write(of, buf, nbytes, off);
>  
> @@ -4560,6 +4570,13 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
>  	parent = cgroup_kn_lock_live(parent_kn);
>  	if (!parent)
>  		return -ENODEV;
> +
> +	/* Allow mkdir only within process's cgroup namespace root. */
> +	if (!cgroup_is_descendant(parent, task_cgroupns_root(current))) {
> +		ret = -EPERM;
> +		goto out_unlock;
> +	}
> +
>  	root = parent->root;
>  
>  	/* allocate the cgroup and its ID, 0 is reserved for the root */
> @@ -4822,6 +4839,13 @@ static int cgroup_rmdir(struct kernfs_node *kn)
>  	if (!cgrp)
>  		return 0;
>  
> +	/* Allow rmdir only within process's cgroup namespace root.
> +	 * The process can't delete its own root anyways. */
> +	if (!cgroup_is_descendant(cgrp, task_cgroupns_root(current))) {
> +		cgroup_kn_unlock(kn);
> +		return -EPERM;
> +	}
> +
>  	ret = cgroup_destroy_locked(cgrp);
>  
>  	cgroup_kn_unlock(kn);
> @@ -5051,6 +5075,15 @@ int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
>  		if (root == &cgrp_dfl_root && !cgrp_dfl_root_visible)
>  			continue;
>  
> +		cgrp = task_cgroup_from_root(tsk, root);
> +
> +		/* The cgroup path on default hierarchy is shown only if it
> +		 * falls under current task's cgroupns-root.
> +		 */
> +		if (root == &cgrp_dfl_root &&
> +		    !cgroup_is_descendant(cgrp, task_cgroupns_root(current)))
> +			continue;
> +
>  		seq_printf(m, "%d:", root->hierarchy_id);
>  		for_each_subsys(ss, ssid)
>  			if (root->subsys_mask & (1 << ssid))
> @@ -5059,7 +5092,6 @@ int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
>  			seq_printf(m, "%sname=%s", count ? "," : "",
>  				   root->name);
>  		seq_putc(m, ':');
> -		cgrp = task_cgroup_from_root(tsk, root);
>  		path = cgroup_path(cgrp, buf, PATH_MAX);
>  		if (!path) {
>  			retval = -ENAMETOOLONG;
> -- 
> 2.1.0.rc2.206.gedb03e5
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
