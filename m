Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780AbaJPQN2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 12:13:28 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:49825
	"EHLO mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbaJPQN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 12:13:26 -0400
Date: Thu, 16 Oct 2014 18:13:24 +0200
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Aditya Kali <adityakali@google.com>
Cc: tj@kernel.org, lizefan@huawei.com, serge.hallyn@ubuntu.com,
        luto@amacapital.net, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        mingo@redhat.com, containers@lists.linux-foundation.org
Subject: Re: [PATCHv1 3/8] cgroup: add function to get task's cgroup on
 default hierarchy
Message-ID: <20141016161324.GC1392@mail.hallyn.com>
References: <adityakali-cgroupns>
 <1413235430-22944-1-git-send-email-adityakali@google.com>
 <1413235430-22944-4-git-send-email-adityakali@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413235430-22944-4-git-send-email-adityakali@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Aditya Kali (adityakali@google.com):
> get_task_cgroup() returns the (reference counted) cgroup of the
> given task on the default hierarchy.
> 
> Signed-off-by: Aditya Kali <adityakali@google.com>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> ---
>  include/linux/cgroup.h |  1 +
>  kernel/cgroup.c        | 25 +++++++++++++++++++++++++
>  2 files changed, 26 insertions(+)
> 
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 1d51968..80ed6e0 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -579,6 +579,7 @@ static inline void pr_cont_cgroup_path(struct cgroup *cgrp)
>  }
>  
>  char *task_cgroup_path(struct task_struct *task, char *buf, size_t buflen);
> +struct cgroup *get_task_cgroup(struct task_struct *task);
>  
>  int cgroup_add_dfl_cftypes(struct cgroup_subsys *ss, struct cftype *cfts);
>  int cgroup_add_legacy_cftypes(struct cgroup_subsys *ss, struct cftype *cfts);
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index cab7dc4..56d507b 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1916,6 +1916,31 @@ char *task_cgroup_path(struct task_struct *task, char *buf, size_t buflen)
>  }
>  EXPORT_SYMBOL_GPL(task_cgroup_path);
>  
> +/*
> + * get_task_cgroup - returns the cgroup of the task in the default cgroup
> + * hierarchy.
> + *
> + * @task: target task
> + * This function returns the @task's cgroup on the default cgroup hierarchy. The
> + * returned cgroup has its reference incremented (by calling cgroup_get()). So
> + * the caller must cgroup_put() the obtained reference once it is done with it.
> + */
> +struct cgroup *get_task_cgroup(struct task_struct *task)
> +{
> +	struct cgroup *cgrp;
> +
> +	mutex_lock(&cgroup_mutex);
> +	down_read(&css_set_rwsem);
> +
> +	cgrp = task_cgroup_from_root(task, &cgrp_dfl_root);
> +	cgroup_get(cgrp);
> +
> +	up_read(&css_set_rwsem);
> +	mutex_unlock(&cgroup_mutex);
> +	return cgrp;
> +}
> +EXPORT_SYMBOL_GPL(get_task_cgroup);
> +
>  /* used to track tasks and other necessary states during migration */
>  struct cgroup_taskset {
>  	/* the src and dst cset list running through cset->mg_node */
> -- 
> 2.1.0.rc2.206.gedb03e5
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
