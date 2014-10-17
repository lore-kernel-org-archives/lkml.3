Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791AbaJQJw3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 05:52:29 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:37381
	"EHLO mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbaJQJwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 05:52:25 -0400
Date: Fri, 17 Oct 2014 11:52:20 +0200
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Aditya Kali <adityakali@google.com>
Cc: tj@kernel.org, lizefan@huawei.com, serge.hallyn@ubuntu.com,
        luto@amacapital.net, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        mingo@redhat.com, containers@lists.linux-foundation.org,
        jnagal@google.com
Subject: Re: [PATCHv1 7/8] cgroup: cgroup namespace setns support
Message-ID: <20141017095220.GB8848@mail.hallyn.com>
References: <adityakali-cgroupns>
 <1413235430-22944-1-git-send-email-adityakali@google.com>
 <1413235430-22944-8-git-send-email-adityakali@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413235430-22944-8-git-send-email-adityakali@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Aditya Kali (adityakali@google.com):
> setns on a cgroup namespace is allowed only if
> * task has CAP_SYS_ADMIN in its current user-namespace and
>   over the user-namespace associated with target cgroupns.
> * task's current cgroup is descendent of the target cgroupns-root
>   cgroup.
> * target cgroupns-root is same as or deeper than task's current
>   cgroupns-root. This is so that the task cannot escape out of its
>   cgroupns-root. This also ensures that setns() only makes the task
>   get restricted to a deeper cgroup hierarchy.
> 
> Signed-off-by: Aditya Kali <adityakali@google.com>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

Below you allow setns to your own cgroupns.  I think that's fine,
but since you're not doing an explicit cgroup change anyway should
you just return 0 at top in that case to save some cpu time?

> ---
>  kernel/cgroup_namespace.c | 44 ++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 42 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/cgroup_namespace.c b/kernel/cgroup_namespace.c
> index c16604f..c612946 100644
> --- a/kernel/cgroup_namespace.c
> +++ b/kernel/cgroup_namespace.c
> @@ -80,8 +80,48 @@ err_out:
>  
>  static int cgroupns_install(struct nsproxy *nsproxy, void *ns)
>  {
> -	pr_info("setns not supported for cgroup namespace");
> -	return -EINVAL;
> +	struct cgroup_namespace *cgroup_ns = ns;
> +	struct task_struct *task = current;
> +	struct cgroup *cgrp = NULL;
> +	int err = 0;
> +
> +	if (!ns_capable(current_user_ns(), CAP_SYS_ADMIN) ||
> +	    !ns_capable(cgroup_ns->user_ns, CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	/* Prevent cgroup changes for this task. */
> +	threadgroup_lock(task);
> +
> +	cgrp = get_task_cgroup(task);
> +
> +	err = -EINVAL;
> +	if (!cgroup_on_dfl(cgrp))
> +		goto out_unlock;
> +
> +	/* Allow switch only if the task's current cgroup is descendant of the
> +	 * target cgroup_ns->root_cgrp.
> +	 */
> +	if (!cgroup_is_descendant(cgrp, cgroup_ns->root_cgrp))
> +		goto out_unlock;
> +
> +	/* Only allow setns to a cgroupns root-ed deeper than task's current
> +	 * cgroupns-root. This will make sure that tasks cannot escape their
> +	 * cgroupns by attaching to parent cgroupns.
> +	 */
> +	if (!cgroup_is_descendant(cgroup_ns->root_cgrp,
> +				  task_cgroupns_root(task)))
> +		goto out_unlock;
> +
> +	err = 0;
> +	get_cgroup_ns(cgroup_ns);
> +	put_cgroup_ns(nsproxy->cgroup_ns);
> +	nsproxy->cgroup_ns = cgroup_ns;
> +
> +out_unlock:
> +	threadgroup_unlock(current);
> +	if (cgrp)
> +		cgroup_put(cgrp);
> +	return err;
>  }
>  
>  static void *cgroupns_get(struct task_struct *task)
> -- 
> 2.1.0.rc2.206.gedb03e5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
