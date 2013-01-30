Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab3A3UaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 15:30:08 -0500
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:44657 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab3A3UaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 15:30:06 -0500
Date: Wed, 30 Jan 2013 20:30:06 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: aris@redhat.com
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH v4 5/9] devcg: prepare may_access() for hierarchy
 support
Message-ID: <20130130203006.GC8507@mail.hallyn.com>
References: <20130130171101.060853036@napanee.usersys.redhat.com>
 <20130130171101.812377398@napanee.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130130171101.812377398@napanee.usersys.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting aris@redhat.com (aris@redhat.com):
> Currently may_access() is only able to verify if an exception is valid for the
> current cgroup, which has the same behavior. With hierarchy, it'll be also used
> to verify if a cgroup local exception is valid towards its cgroup parent, which
> might have different behavior.
> 
> v2:
> - updated patch description
> - rebased on top of a new patch to expand the may_access() logic to make it
>   more clear
> - fixed argument description order in may_access()
> 
> Acked-by: Tejun Heo <tj@kernel.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Serge Hallyn <serge.hallyn@canonical.com>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> Signed-off-by: Aristeu Rozanski <aris@redhat.com>
> 
> ---
>  security/device_cgroup.c |   38 ++++++++++++++++++++++++--------------
>  1 file changed, 24 insertions(+), 14 deletions(-)
> 
> --- github.orig/security/device_cgroup.c	2013-01-30 08:58:02.000000000 -0500
> +++ github/security/device_cgroup.c	2013-01-30 09:00:09.435351867 -0500
> @@ -354,9 +354,11 @@ 	return 0;
>   *		verify if a certain access is allowed.
>   * @dev_cgroup: dev cgroup to be tested against
>   * @refex: new exception
> + * @behavior: behavior of the exception
>   */
>  static bool may_access(struct dev_cgroup *dev_cgroup,
> -		       struct dev_exception_item *refex)
> +		       struct dev_exception_item *refex,
> +		       enum devcg_behavior behavior)
>  {
>  	struct dev_exception_item *ex;
>  	bool match = false;
> @@ -380,19 +382,27 @@ 		if (ex->minor != ~0 && ex->minor != re
>  		break;
>  	}
>  
> -	/*
> -	 * In two cases we'll consider this new exception valid:
> -	 * - the dev cgroup has its default policy to deny + exception list:
> -	 *   the new exception *should* match the exceptions
> -	 * - the dev cgroup has its default policy to allow + exception list:
> -	 *   the new exception should *not* match any of the exceptions
> -	 */
> -	if (dev_cgroup->behavior == DEVCG_DEFAULT_DENY) {
> -		if (match)
> +	if (dev_cgroup->behavior == DEVCG_DEFAULT_ALLOW) {
> +		if (behavior == DEVCG_DEFAULT_ALLOW) {
> +			/* the exception will deny access to certain devices */
>  			return true;
> +		} else {
> +			/* the exception will allow access to certain devices */
> +			if (match)
> +				/*
> +				 * a new exception allowing access shouldn't
> +				 * match an parent's exception
> +				 */
> +				return false;
> +			return true;
> +		}
>  	} else {
> -		if (!match)
> +		/* only behavior == DEVCG_DEFAULT_DENY allowed here */
> +		if (match)
> +			/* parent has an exception that matches the proposed */
>  			return true;
> +		else
> +			return false;
>  	}
>  	return false;
>  }
> @@ -411,7 +421,7 @@ static int parent_has_perm(struct dev_cg
>  	if (!pcg)
>  		return 1;
>  	parent = cgroup_to_devcgroup(pcg);
> -	return may_access(parent, ex);
> +	return may_access(parent, ex, childcg->behavior);
>  }
>  
>  /**
> @@ -445,7 +455,7 @@ static int devcgroup_update_access(struc
>  {
>  	const char *b;
>  	char temp[12];		/* 11 + 1 characters needed for a u32 */
> -	int count, rc;
> +	int count, rc = 0;

This here points out that (unrelated to yor set) devcgroup_update_access()
really needs a cleanup.

>  	struct dev_exception_item ex;
>  	struct cgroup *p = devcgroup->css.cgroup;
>  	struct dev_cgroup *parent = NULL;
> @@ -663,7 +673,7 @@ 	memset(&ex, 0, sizeof(ex));
>  
>  	rcu_read_lock();
>  	dev_cgroup = task_devcgroup(current);
> -	rc = may_access(dev_cgroup, &ex);
> +	rc = may_access(dev_cgroup, &ex, dev_cgroup->behavior);
>  	rcu_read_unlock();
>  
>  	if (!rc)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
