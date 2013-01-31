Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286Ab3AaEik (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 23:38:40 -0500
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:50190 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab3AaEij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 23:38:39 -0500
Date: Thu, 31 Jan 2013 04:38:39 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: aris@redhat.com
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH v4 9/9] devcg: propagate local changes down the
 hierarchy
Message-ID: <20130131043839.GA14726@mail.hallyn.com>
References: <20130130171101.060853036@napanee.usersys.redhat.com>
 <20130130171102.390708521@napanee.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130130171102.390708521@napanee.usersys.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting aris@redhat.com (aris@redhat.com):
...
> New exceptions allowing additional access to devices won't be propagated, but
> it'll be possible to add an exception to access all of part of the newly
> allowed device(s).

Is that intended to apply only to only in the DEFAULT_DENY case?  If so
that should be made clear.  If not,

...

> @@ -515,11 +673,13 @@ 	memset(&ex, 0, sizeof(ex));
>  							 &parent->exceptions);
>  			devcgroup->behavior = DEVCG_DEFAULT_ALLOW;
>  			devcgroup->local.behavior = DEVCG_DEFAULT_ALLOW;
> +			rc = propagate_behavior(devcgroup);
>  			break;
>  		case DEVCG_DENY:
>  			dev_exception_clean_all(devcgroup);
>  			devcgroup->behavior = DEVCG_DEFAULT_DENY;
>  			devcgroup->local.behavior = DEVCG_DEFAULT_DENY;
> +			rc = propagate_behavior(devcgroup);
>  			break;
>  		default:
>  			rc = -EINVAL;
> @@ -610,9 +770,14 @@ 		case '\0':
>  		 */
>  		if (devcgroup->behavior == DEVCG_DEFAULT_ALLOW) {
>  			dev_exception_rm(devcgroup, &ex);
> -			return 0;
> +			rc = propagate_exception(devcgroup);

Let's say the default in both parent A and child B is ALLOW, and both
have a blacklist entry for "b 8:* rwm".  Now I

	echo "b 8:* rwm" > A/devices.allow

removing the blacklist entry.  Here you are propagating that to the
child B, which I would argue is actually propagating a new allow to
a child.  Which you said you wouldn't do.

> +			return rc;
>  		}
> -		return dev_exception_add(devcgroup, &ex);
> +		rc = dev_exception_add(devcgroup, &ex);
> +		if (!rc)
> +			/* if a local behavior wasn't explicitely choosen, pick it */
> +			devcgroup->local.behavior = devcgroup->behavior;
> +		break;
>  	case DEVCG_DENY:
>  		/*
>  		 * If the default policy is to deny by default, try to remove
> @@ -621,13 +786,22 @@ 			return 0;
>  		 */
>  		if (devcgroup->behavior == DEVCG_DEFAULT_DENY) {
>  			dev_exception_rm(devcgroup, &ex);
> -			return 0;
> +			rc = propagate_exception(devcgroup);
> +			return rc;
>  		}
> -		return dev_exception_add(devcgroup, &ex);
> +		rc = dev_exception_add(devcgroup, &ex);
> +		if (rc)
> +			return rc;
> +		/* we only propagate new restrictions */
> +		rc = propagate_exception(devcgroup);
> +		if (!rc)
> +			/* if a local behavior wasn't explicitely choosen, pick it */
> +			devcgroup->local.behavior = devcgroup->behavior;
> +		break;

