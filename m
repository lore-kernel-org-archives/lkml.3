Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab3A3UJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 15:09:23 -0500
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:45790 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703Ab3A3UJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 15:09:19 -0500
Date: Wed, 30 Jan 2013 20:09:20 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: aris@redhat.com
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH v4 4/9] devcg: expand may_access() logic
Message-ID: <20130130200920.GB8507@mail.hallyn.com>
References: <20130130171101.060853036@napanee.usersys.redhat.com>
 <20130130171101.690972553@napanee.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130130171101.690972553@napanee.usersys.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting aris@redhat.com (aris@redhat.com):
> In order to make the next patch more clear, expand may_access() logic.
> 
> v2: may_access() returns bool now
> 
> Acked-by: Tejun Heo <tj@kernel.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Serge Hallyn <serge.hallyn@canonical.com>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> Signed-off-by: Aristeu Rozanski <aris@redhat.com>
> 
> ---
>  security/device_cgroup.c |   21 ++++++++++++---------
>  1 file changed, 12 insertions(+), 9 deletions(-)
> 
> --- github.orig/security/device_cgroup.c	2013-01-30 08:56:29.532063723 -0500
> +++ github/security/device_cgroup.c	2013-01-30 08:58:02.934460404 -0500
> @@ -355,8 +355,8 @@ 	return 0;
>   * @dev_cgroup: dev cgroup to be tested against
>   * @refex: new exception
>   */
> -static int may_access(struct dev_cgroup *dev_cgroup,
> -		      struct dev_exception_item *refex)
> +static bool may_access(struct dev_cgroup *dev_cgroup,
> +		       struct dev_exception_item *refex)
>  {
>  	struct dev_exception_item *ex;
>  	bool match = false;
> @@ -382,16 +382,19 @@ 		if (ex->minor != ~0 && ex->minor != re
>  
>  	/*
>  	 * In two cases we'll consider this new exception valid:
> -	 * - the dev cgroup has its default policy to allow + exception list:
> -	 *   the new exception should *not* match any of the exceptions
> -	 *   (behavior == DEVCG_DEFAULT_ALLOW, !match)
>  	 * - the dev cgroup has its default policy to deny + exception list:
>  	 *   the new exception *should* match the exceptions
> -	 *   (behavior == DEVCG_DEFAULT_DENY, match)
> +	 * - the dev cgroup has its default policy to allow + exception list:
> +	 *   the new exception should *not* match any of the exceptions
>  	 */
> -	if ((dev_cgroup->behavior == DEVCG_DEFAULT_DENY) == match)
> -		return 1;
> -	return 0;
> +	if (dev_cgroup->behavior == DEVCG_DEFAULT_DENY) {
> +		if (match)
> +			return true;
> +	} else {
> +		if (!match)
> +			return true;
> +	}
> +	return false;
>  }
>  
>  /*
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
