Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916Ab3A3Umm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 15:42:42 -0500
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:39141 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab3A3Umk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 15:42:40 -0500
Date: Wed, 30 Jan 2013 20:42:40 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: aris@redhat.com
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH v4 7/9] devcg: split single exception copy from
 dev_exceptions_copy()
Message-ID: <20130130204240.GE8507@mail.hallyn.com>
References: <20130130171101.060853036@napanee.usersys.redhat.com>
 <20130130171102.108794435@napanee.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130130171102.108794435@napanee.usersys.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting aris@redhat.com (aris@redhat.com):
> This patch is in preparation for hierarchy support
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
>  security/device_cgroup.c |   18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
> 
> --- github.orig/security/device_cgroup.c	2013-01-29 11:49:16.076677425 -0500
> +++ github/security/device_cgroup.c	2013-01-29 11:49:16.374681863 -0500
> @@ -89,20 +89,30 @@ static int devcgroup_can_attach(struct c
>  	return 0;
>  }
>  
> +static int dev_exception_copy(struct list_head *dest,
> +			      struct dev_exception_item *ex)
> +{
> +	struct dev_exception_item *new;
> +
> +	new = kmemdup(ex, sizeof(*ex), GFP_KERNEL);
> +	if (!new)
> +		return -ENOMEM;
> +	list_add_tail(&new->list, dest);
> +	return 0;
> +}
> +
>  /*
>   * called under devcgroup_mutex
>   */
>  static int dev_exceptions_copy(struct list_head *dest, struct list_head *orig)
>  {
> -	struct dev_exception_item *ex, *tmp, *new;
> +	struct dev_exception_item *ex, *tmp;
>  
>  	lockdep_assert_held(&devcgroup_mutex);
>  
>  	list_for_each_entry(ex, orig, list) {
> -		new = kmemdup(ex, sizeof(*ex), GFP_KERNEL);
> -		if (!new)
> +		if (dev_exception_copy(dest, ex))
>  			goto free_and_exit;
> -		list_add_tail(&new->list, dest);
>  	}
>  
>  	return 0;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
