Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810Ab3A3Te1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 14:34:27 -0500
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:34633 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281Ab3A3TeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 14:34:25 -0500
Date: Wed, 30 Jan 2013 19:34:25 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: aris@redhat.com
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH v4 1/9] device_cgroup: prepare exception list handling
 functions for two lists
Message-ID: <20130130193425.GB8825@mail.hallyn.com>
References: <20130130171101.060853036@napanee.usersys.redhat.com>
 <20130130171101.263587090@napanee.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130130171101.263587090@napanee.usersys.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting aris@redhat.com (aris@redhat.com):
> In the following patches, device_cgroup structure will have two sets of
> behavior and exceptions list (actual one, another with the local settings)
> so rework the functions to use exception list, not a device_cgroup.
> 
> Acked-by: Tejun Heo <tj@kernel.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Serge Hallyn <serge.hallyn@canonical.com>

Sorry - just to keep it all nicely in one thread,

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> Signed-off-by: Aristeu Rozanski <aris@redhat.com>
> 
> ---
>  security/device_cgroup.c |   18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> --- github.orig/security/device_cgroup.c	2013-01-29 11:48:50.603298122 -0500
> +++ github/security/device_cgroup.c	2013-01-29 11:49:14.739657516 -0500
> @@ -104,7 +104,7 @@ free_and_exit:
>  /*
>   * called under devcgroup_mutex
>   */
> -static int dev_exception_add(struct dev_cgroup *dev_cgroup,
> +static int dev_exception_add(struct list_head *exceptions,
>  			     struct dev_exception_item *ex)
>  {
>  	struct dev_exception_item *excopy, *walk;
> @@ -115,7 +115,7 @@ static int dev_exception_add(struct dev_
>  	if (!excopy)
>  		return -ENOMEM;
>  
> -	list_for_each_entry(walk, &dev_cgroup->exceptions, list) {
> +	list_for_each_entry(walk, exceptions, list) {
>  		if (walk->type != ex->type)
>  			continue;
>  		if (walk->major != ex->major)
> @@ -129,21 +129,21 @@ static int dev_exception_add(struct dev_
>  	}
>  
>  	if (excopy != NULL)
> -		list_add_tail_rcu(&excopy->list, &dev_cgroup->exceptions);
> +		list_add_tail_rcu(&excopy->list, exceptions);
>  	return 0;
>  }
>  
>  /*
>   * called under devcgroup_mutex
>   */
> -static void dev_exception_rm(struct dev_cgroup *dev_cgroup,
> +static void dev_exception_rm(struct list_head *exceptions,
>  			     struct dev_exception_item *ex)
>  {
>  	struct dev_exception_item *walk, *tmp;
>  
>  	lockdep_assert_held(&devcgroup_mutex);
>  
> -	list_for_each_entry_safe(walk, tmp, &dev_cgroup->exceptions, list) {
> +	list_for_each_entry_safe(walk, tmp, exceptions, list) {
>  		if (walk->type != ex->type)
>  			continue;
>  		if (walk->major != ex->major)
> @@ -514,10 +514,10 @@ 		case '\0':
>  		 * don't want to break compatibility
>  		 */
>  		if (devcgroup->behavior == DEVCG_DEFAULT_ALLOW) {
> -			dev_exception_rm(devcgroup, &ex);
> +			dev_exception_rm(&devcgroup->exceptions, &ex);
>  			return 0;
>  		}
> -		return dev_exception_add(devcgroup, &ex);
> +		return dev_exception_add(&devcgroup->exceptions, &ex);
>  	case DEVCG_DENY:
>  		/*
>  		 * If the default policy is to deny by default, try to remove
> @@ -525,10 +525,10 @@ 			return 0;
>  		 * don't want to break compatibility
>  		 */
>  		if (devcgroup->behavior == DEVCG_DEFAULT_DENY) {
> -			dev_exception_rm(devcgroup, &ex);
> +			dev_exception_rm(&devcgroup->exceptions, &ex);
>  			return 0;
>  		}
> -		return dev_exception_add(devcgroup, &ex);
> +		return dev_exception_add(&devcgroup->exceptions, &ex);
>  	default:
>  		return -EINVAL;
>  	}
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
