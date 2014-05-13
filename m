Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017AbaEMM5G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 08:57:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932547AbaEMM5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 08:57:04 -0400
Date: Tue, 13 May 2014 08:56:52 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        hannes@cmpxchg.org, Serge Hallyn <serge.hallyn@ubuntu.com>
Subject: Re: [PATCH 13/14] device_cgroup: use css_has_online_children()
 instead of has_children()
Message-ID: <20140513125652.GJ29214@redhat.com>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
 <1399671091-23867-14-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399671091-23867-14-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 05:31:30PM -0400, Tejun Heo wrote:
> devcgroup_update_access() wants to know whether there are child
> cgroups which are online and visible to userland and has_children()
> may return false positive.  Replace it with css_has_online_children().
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Aristeu Rozanski <aris@redhat.com>
> Cc: Serge Hallyn <serge.hallyn@ubuntu.com>
> ---
>  security/device_cgroup.c | 19 ++-----------------
>  1 file changed, 2 insertions(+), 17 deletions(-)
> 
> diff --git a/security/device_cgroup.c b/security/device_cgroup.c
> index 75b4b18..22de334 100644
> --- a/security/device_cgroup.c
> +++ b/security/device_cgroup.c
> @@ -475,21 +475,6 @@ static int propagate_exception(struct dev_cgroup *devcg_root,
>  	return rc;
>  }
>  
> -static inline bool has_children(struct dev_cgroup *devcgroup)
> -{
> -	bool ret;
> -
> -	/*
> -	 * FIXME: There may be lingering offline csses and this function
> -	 * may return %true when there isn't any userland-visible child
> -	 * which is incorrect for our purposes.
> -	 */
> -	rcu_read_lock();
> -	ret = css_next_child(NULL, &devcgroup->css);
> -	rcu_read_unlock();
> -	return ret;
> -}
> -
>  /*
>   * Modify the exception list using allow/deny rules.
>   * CAP_SYS_ADMIN is needed for this.  It's at least separate from CAP_MKNOD
> @@ -522,7 +507,7 @@ static int devcgroup_update_access(struct dev_cgroup *devcgroup,
>  	case 'a':
>  		switch (filetype) {
>  		case DEVCG_ALLOW:
> -			if (has_children(devcgroup))
> +			if (css_has_online_children(&devcgroup->css))
>  				return -EINVAL;
>  
>  			if (!may_allow_all(parent))
> @@ -538,7 +523,7 @@ static int devcgroup_update_access(struct dev_cgroup *devcgroup,
>  				return rc;
>  			break;
>  		case DEVCG_DENY:
> -			if (has_children(devcgroup))
> +			if (css_has_online_children(&devcgroup->css))
>  				return -EINVAL;
>  
>  			dev_exception_clean(devcgroup);

Acked-by: Aristeu Rozanski <aris@redhat.com>

-- 
Aristeu

