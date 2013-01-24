Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab3AXWNl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 17:13:41 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:60255 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597Ab3AXWNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 17:13:33 -0500
Date: Thu, 24 Jan 2013 14:13:27 -0800
From: Tejun Heo <tj@kernel.org>
To: aris@redhat.com
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH v2 3/4] device_cgroup: make may_access() stronger
Message-ID: <20130124221327.GX2373@mtj.dyndns.org>
References: <20130124194957.198022148@napanee.usersys.redhat.com>
 <20130124194957.663514303@napanee.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130124194957.663514303@napanee.usersys.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jan 24, 2013 at 02:50:00PM -0500, aris@redhat.com wrote:
> In order to revalidate local exceptions for the hierarchy change propagation,
> make may_access() stronger.

It would be nice to explain what "stronger" actually means.

> --- github.orig/security/device_cgroup.c	2013-01-24 10:40:46.384253615 -0500
> +++ github/security/device_cgroup.c	2013-01-24 10:41:07.513567697 -0500
> @@ -353,13 +353,15 @@ 	return 0;
>   *		won't have more privileges than its parent or to
>   *		verify if a certain access is allowed.
>   * @dev_cgroup: dev cgroup to be tested against
> + * @behavior: behavior of the exception

Should come after @refex?

>   * @refex: new exception
>   */
> -static int may_access(struct dev_cgroup *dev_cgroup,
> -		      struct dev_exception_item *refex)
> +static bool may_access(struct dev_cgroup *dev_cgroup,
> +		       struct dev_exception_item *refex,
> +		       enum devcg_behavior behavior)
>  {
>  	struct dev_exception_item *ex;
> -	bool match = false;
> +	int match = false;
>  
>  	rcu_lockdep_assert(rcu_read_lock_held() ||
>  			   lockdep_is_held(&devcgroup_mutex),
> @@ -380,18 +382,28 @@ 		if (ex->minor != ~0 && ex->minor != re
>  		break;
>  	}
>  
> -	/*
> -	 * In two cases we'll consider this new exception valid:
> -	 * - the dev cgroup has its default policy to allow + exception list:
> -	 *   the new exception should *not* match any of the exceptions
> -	 *   (behavior == DEVCG_DEFAULT_ALLOW, !match)
> -	 * - the dev cgroup has its default policy to deny + exception list:
> -	 *   the new exception *should* match the exceptions
> -	 *   (behavior == DEVCG_DEFAULT_DENY, match)
> -	 */
> -	if ((dev_cgroup->behavior == DEVCG_DEFAULT_DENY) == match)
> -		return 1;
> -	return 0;
> +	if (dev_cgroup->behavior == DEVCG_DEFAULT_ALLOW) {
> +		if (behavior == DEVCG_DEFAULT_ALLOW) {
> +			/* the exception will deny access to certain devices */
> +			return true;
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
> +	} else {
> +		/* only behavior == DEVCG_DEFAULT_DENY allowed here */
> +		if (match)
> +			/* parent has an exception that matches the proposed */
> +			return true;
> +		else
> +			return false;

It would be nice if there were a separate patch to decompress the
logic separate from adding new logic.

Thanks.

-- 
tejun
