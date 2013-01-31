Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047Ab3AaETf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 23:19:35 -0500
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:58538 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223Ab3AaETc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 23:19:32 -0500
Date: Thu, 31 Jan 2013 04:19:32 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: aris@redhat.com
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH v4 9/9] devcg: propagate local changes down the
 hierarchy
Message-ID: <20130131041932.GB14576@mail.hallyn.com>
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
> +/**
> + * propagate_behavior - propagates a change in the behavior down in hierarchy
> + * @devcg_root: device cgroup that changed behavior
> + *
> + * returns: 0 in case of success, != 0 in case of error
> + *
> + * This is one of the two key functions for hierarchy implementation.
> + * All cgroup's children recursively will have the behavior changed and
> + * exceptions copied from the parent then its local behavior and exceptions
> + * re-evaluated and applied if they're still allowed.  Refer to
> + * Documentation/cgroups/devices.txt for more details.
> + */
> +static int propagate_behavior(struct dev_cgroup *devcg_root)
> +{
> +	struct cgroup *root = devcg_root->css.cgroup;
> +	struct dev_cgroup *parent, *devcg, *tmp;
> +	int rc = 0;
> +	LIST_HEAD(pending);
> +
> +	get_online_devcg(root, &pending);
> +
> +	list_for_each_entry_safe(devcg, tmp, &pending, propagate_pending) {
> +		parent = cgroup_to_devcgroup(devcg->css.cgroup->parent);
> +
> +		/* first copy parent's state */
> +		devcg->behavior = parent->behavior;
> +		dev_exception_clean(&devcg->exceptions);
> +		rc = dev_exceptions_copy(&devcg->exceptions, &parent->exceptions);
> +		if (rc) {
> +			devcg->behavior = DEVCG_DEFAULT_DENY;
> +			break;
> +		}
> +
> +		if (devcg->local.behavior == DEVCG_DEFAULT_DENY &&
> +		    devcg->behavior == DEVCG_DEFAULT_ALLOW) {
> +			devcg->behavior = DEVCG_DEFAULT_DENY;
> +		}

I think you might need another special case here.  If A and it's
child B are both ALLOW, and A switches to DENY, then if I read this
right B will be switched to DENY, but its local->exceptions will
not be cleared.  They won't be immediately applied, so at first it's
ok.  But if B then adds an exception, what happens?  It'll call
revalidate_exceptions on the full old list plus new exception.  If
any exceptions aren't allowed by the parent then it won't be applied,
but it's possible that it is allowed in the parent but (its sense
now being inverted from blacklist to whitelist) not intended to be
allowed in the child.  But there will be nothing to stop it.

So do you need

	if (devcg->local.behavior == DEVCG_DEFAULT_ALLOW &&
		devcg->behavior == DEVCG_DEFAULT_DENY) {
		dev_exception_clean(&devcg->local.exceptions);
	}

here?

> +		if (devcg->local.behavior == devcg->behavior)
> +			rc = revalidate_exceptions(devcg);
> +		if (rc)
> +			break;
> +		list_del_init(&devcg->propagate_pending);
> +	}
> +
> +	return rc;
> +}
