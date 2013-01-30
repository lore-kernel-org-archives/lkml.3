Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab3A3Tot (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 14:44:49 -0500
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:35664 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab3A3Tor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 14:44:47 -0500
Date: Wed, 30 Jan 2013 19:44:48 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: aris@redhat.com
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH v4 2/9] devcg: reorder device exception functions
Message-ID: <20130130194448.GA10238@mail.hallyn.com>
References: <20130130171101.060853036@napanee.usersys.redhat.com>
 <20130130171101.406627645@napanee.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130130171101.406627645@napanee.usersys.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting aris@redhat.com (aris@redhat.com):
> In preparation for the next patch, reorder dev_exception_add() and
> dev_exception_rm().
> 
> This patch doesn't introduce any functional changes.
> 
> Acked-by: Tejun Heo <tj@kernel.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Serge Hallyn <serge.hallyn@canonical.com>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> Signed-off-by: Aristeu Rozanski <aris@redhat.com>
> 
> ---
>  security/device_cgroup.c |   44 ++++++++++++++++++++++----------------------
>  1 file changed, 22 insertions(+), 22 deletions(-)
> 
> --- github.orig/security/device_cgroup.c	2013-01-29 11:49:14.739657516 -0500
> +++ github/security/device_cgroup.c	2013-01-29 11:49:14.987661210 -0500
> @@ -104,18 +104,14 @@ free_and_exit:
>  /*
>   * called under devcgroup_mutex
>   */
> -static int dev_exception_add(struct list_head *exceptions,
> +static void dev_exception_rm(struct list_head *exceptions,
>  			     struct dev_exception_item *ex)
>  {
> -	struct dev_exception_item *excopy, *walk;
> +	struct dev_exception_item *walk, *tmp;
>  
>  	lockdep_assert_held(&devcgroup_mutex);
>  
> -	excopy = kmemdup(ex, sizeof(*ex), GFP_KERNEL);
> -	if (!excopy)
> -		return -ENOMEM;
> -
> -	list_for_each_entry(walk, exceptions, list) {
> +	list_for_each_entry_safe(walk, tmp, exceptions, list) {
>  		if (walk->type != ex->type)
>  			continue;
>  		if (walk->major != ex->major)
> @@ -123,27 +119,29 @@ static int dev_exception_add(struct list
>  		if (walk->minor != ex->minor)
>  			continue;
>  
> -		walk->access |= ex->access;
> -		kfree(excopy);
> -		excopy = NULL;
> +		walk->access &= ~ex->access;
> +		if (!walk->access) {
> +			list_del_rcu(&walk->list);
> +			kfree_rcu(walk, rcu);
> +		}
>  	}
> -
> -	if (excopy != NULL)
> -		list_add_tail_rcu(&excopy->list, exceptions);
> -	return 0;
>  }
>  
>  /*
>   * called under devcgroup_mutex
>   */
> -static void dev_exception_rm(struct list_head *exceptions,
> +static int dev_exception_add(struct list_head *exceptions,
>  			     struct dev_exception_item *ex)
>  {
> -	struct dev_exception_item *walk, *tmp;
> +	struct dev_exception_item *excopy, *walk;
>  
>  	lockdep_assert_held(&devcgroup_mutex);
>  
> -	list_for_each_entry_safe(walk, tmp, exceptions, list) {
> +	excopy = kmemdup(ex, sizeof(*ex), GFP_KERNEL);
> +	if (!excopy)
> +		return -ENOMEM;
> +
> +	list_for_each_entry(walk, exceptions, list) {
>  		if (walk->type != ex->type)
>  			continue;
>  		if (walk->major != ex->major)
> @@ -151,12 +149,14 @@ static void dev_exception_rm(struct list
>  		if (walk->minor != ex->minor)
>  			continue;
>  
> -		walk->access &= ~ex->access;
> -		if (!walk->access) {
> -			list_del_rcu(&walk->list);
> -			kfree_rcu(walk, rcu);
> -		}
> +		walk->access |= ex->access;
> +		kfree(excopy);
> +		excopy = NULL;
>  	}
> +
> +	if (excopy != NULL)
> +		list_add_tail_rcu(&excopy->list, exceptions);
> +	return 0;
>  }
>  
>  static void __dev_exception_clean(struct dev_cgroup *dev_cgroup)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
