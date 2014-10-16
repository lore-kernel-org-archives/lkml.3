Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbaJPQOZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 12:14:25 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:49850
	"EHLO mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbaJPQOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 12:14:23 -0400
Date: Thu, 16 Oct 2014 18:14:21 +0200
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Aditya Kali <adityakali@google.com>
Cc: tj@kernel.org, lizefan@huawei.com, serge.hallyn@ubuntu.com,
        luto@amacapital.net, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        mingo@redhat.com, containers@lists.linux-foundation.org
Subject: Re: [PATCHv1 4/8] cgroup: export cgroup_get() and cgroup_put()
Message-ID: <20141016161421.GD1392@mail.hallyn.com>
References: <adityakali-cgroupns>
 <1413235430-22944-1-git-send-email-adityakali@google.com>
 <1413235430-22944-5-git-send-email-adityakali@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413235430-22944-5-git-send-email-adityakali@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Aditya Kali (adityakali@google.com):
> move cgroup_get() and cgroup_put() into cgroup.h so that
> they can be called from other places.
> 
> Signed-off-by: Aditya Kali <adityakali@google.com>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> ---
>  include/linux/cgroup.h | 22 ++++++++++++++++++++++
>  kernel/cgroup.c        | 22 ----------------------
>  2 files changed, 22 insertions(+), 22 deletions(-)
> 
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 80ed6e0..4a0eb2d 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -521,6 +521,28 @@ static inline bool cgroup_on_dfl(const struct cgroup *cgrp)
>  	return cgrp->root == &cgrp_dfl_root;
>  }
>  
> +/* convenient tests for these bits */
> +static inline bool cgroup_is_dead(const struct cgroup *cgrp)
> +{
> +	return !(cgrp->self.flags & CSS_ONLINE);
> +}
> +
> +static inline void cgroup_get(struct cgroup *cgrp)
> +{
> +	WARN_ON_ONCE(cgroup_is_dead(cgrp));
> +	css_get(&cgrp->self);
> +}
> +
> +static inline bool cgroup_tryget(struct cgroup *cgrp)
> +{
> +	return css_tryget(&cgrp->self);
> +}
> +
> +static inline void cgroup_put(struct cgroup *cgrp)
> +{
> +	css_put(&cgrp->self);
> +}
> +
>  /* no synchronization, the result can only be used as a hint */
>  static inline bool cgroup_has_tasks(struct cgroup *cgrp)
>  {
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 56d507b..2b3e9f9 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -284,12 +284,6 @@ static struct cgroup_subsys_state *cgroup_e_css(struct cgroup *cgrp,
>  	return cgroup_css(cgrp, ss);
>  }
>  
> -/* convenient tests for these bits */
> -static inline bool cgroup_is_dead(const struct cgroup *cgrp)
> -{
> -	return !(cgrp->self.flags & CSS_ONLINE);
> -}
> -
>  struct cgroup_subsys_state *of_css(struct kernfs_open_file *of)
>  {
>  	struct cgroup *cgrp = of->kn->parent->priv;
> @@ -1002,22 +996,6 @@ static umode_t cgroup_file_mode(const struct cftype *cft)
>  	return mode;
>  }
>  
> -static void cgroup_get(struct cgroup *cgrp)
> -{
> -	WARN_ON_ONCE(cgroup_is_dead(cgrp));
> -	css_get(&cgrp->self);
> -}
> -
> -static bool cgroup_tryget(struct cgroup *cgrp)
> -{
> -	return css_tryget(&cgrp->self);
> -}
> -
> -static void cgroup_put(struct cgroup *cgrp)
> -{
> -	css_put(&cgrp->self);
> -}
> -
>  /**
>   * cgroup_refresh_child_subsys_mask - update child_subsys_mask
>   * @cgrp: the target cgroup
> -- 
> 2.1.0.rc2.206.gedb03e5
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
