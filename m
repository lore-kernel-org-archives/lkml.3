Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995Ab3BBQUv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 11:20:51 -0500
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:36182 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757582Ab3BBQUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 11:20:48 -0500
Date: Sat, 2 Feb 2013 16:20:52 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Aristeu Rozanski <aris@redhat.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH v5 9/9] devcg: propagate local changes down the
 hierarchy
Message-ID: <20130202162052.GB11284@mail.hallyn.com>
References: <20130130171101.060853036@napanee.usersys.redhat.com>
 <20130130171102.390708521@napanee.usersys.redhat.com>
 <20130131043839.GA14726@mail.hallyn.com>
 <20130201190958.GP17632@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130201190958.GP17632@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Aristeu Rozanski (aris@redhat.com):
> +/**
> + * propagate_exception - propagates a new exception to the children
> + * @devcg_root: device cgroup that added a new exception
> + *
> + * returns: 0 in case of success, != 0 in case of error
> + */
> +static int propagate_exception(struct dev_cgroup *devcg_root)
> +{
> +	struct cgroup *root = devcg_root->css.cgroup;
> +	struct dev_cgroup *devcg, *parent, *tmp;
> +	int rc = 0;
> +	LIST_HEAD(pending);
> +
> +	get_online_devcg(root, &pending);
> +
> +	list_for_each_entry_safe(devcg, tmp, &pending, propagate_pending) {
> +		parent = cgroup_to_devcgroup(devcg->css.cgroup->parent);
> +
> +		dev_exception_clean(&devcg->exceptions);
> +		if (devcg->behavior == parent->behavior) {
> +			rc = dev_exceptions_copy(&devcg->exceptions, &parent->exceptions);

Let's say parent A and child B both have DEFAULT_DENY, with a set of let's
say 5 whitelist exceptions.  Now the parent adds two more whitelist
exceptions.  As you say, we don't propagate those.

Now the parent removes one of it's whitelist exceptions.
devcgroup_update_access() calls dev_exception_rm() followed by
propagate_exception(), which comes here and copies the parent's
whitelist - including the two new whitelist rules - to the
child.

-serge
