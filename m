Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894Ab3AXW3o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 17:29:44 -0500
Received: from mail-qe0-f52.google.com ([209.85.128.52]:61945 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705Ab3AXW3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 17:29:36 -0500
Date: Thu, 24 Jan 2013 14:29:30 -0800
From: Tejun Heo <tj@kernel.org>
To: aris@redhat.com
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH v2 4/4] device_cgroup: propagate local changes down the
 hierarchy
Message-ID: <20130124222930.GY2373@mtj.dyndns.org>
References: <20130124194957.198022148@napanee.usersys.redhat.com>
 <20130124194957.842303201@napanee.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130124194957.842303201@napanee.usersys.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Aristeu.

On Thu, Jan 24, 2013 at 02:50:01PM -0500, aris@redhat.com wrote:
> This patch makes all changes propagate down in hierarchy respecting when
> possible local configurations.
> 
> Behavior changes will clean up exceptions in all the children except when the
> parent changes the behavior from allow to deny and the child's behavior was
> already deny, in which case the local exceptions will be reused. The inverse
> is not possible: you can't have a parent with behavior deny and a child with
> behavior accept.
> 
> New exceptions allowing additional access to devices won't be propagated, but
> it'll be possible to add an exception to access all of part of the newly
                                                      ^
                                                      or
> allowed device(s).
> 
> New exceptions disallowing access to devices will be propagated down and the
> local group's exceptions will be revalidated for the new situation.
> Example:
>       A
>      / \
>         B
> 
>     group        behavior          exceptions
>     A            allow             "b 8:* rwm", "c 116:1 rw"
>     B            deny              "c 1:3 rwm", "c 116:2 rwm", "b 3:* rwm"
> 
> If a new exception is added to group A:
> 	# echo "c 116:* r" > A/devices.deny
> it'll propagate down and after revalidating B's local exceptions, the exception
> "c 116:2 rwm" will be removed.
> 
> In case parent behavior or exceptions change and local settings are not
> allowed anymore, they'll be deleted.

Can you please put the above in Documentation/cgroups/devices.txt?  It
would also be nice to explain it briefly in the source file and point
to the documentation file for details.

> +static int dev_exception_copy(struct list_head *dest,
> +			      struct dev_exception_item *ex)
> +{
> +	struct dev_exception_item *new;
> +
> +	new = kmemdup(ex, sizeof(*ex), GFP_KERNEL);
> +	if (!new)
> +		return -ENOMEM;
> +	list_add_tail_rcu(&new->list, dest);
> +	return 0;
> +}

Hmmm... why are these being RCUfy'd?  Can you please explain / comment
the access rules?  Which parts are protected by RCU often becomes
muddy over time.

And I hope changes (including on/offlining) other than implementing
the actual propagation came as separate patches.

> +/**
> + * devcg_for_each_child - traverse online children of a device cgroup
> + * @child_cs: loop cursor pointing to the current child
> + * @pos_cgrp: used for iteration
> + * @parent_cs: target device cgroup to walk children of
> + *
> + * Walk @child_cs through the online children of @parent_cs.  Must be used
> + * with RCU read locked.
> + */

For the online test to be reliable, it should be called under
devcgroup_mutex, no?

> +#define devcg_for_each_child(pos_cgrp, root)				\
> +	cgroup_for_each_child((pos_cgrp), (root))			\
> +		if (is_devcg_online(cgroup_to_devcgroup((pos_cgrp))))
> +

Comment on what devcgroup_online() is doing would be awesome here.

> +static int devcgroup_online(struct cgroup *cgroup)
> +{
> +	struct dev_cgroup *dev_cgroup, *parent_dev_cgroup = NULL;
> +	int ret = 0;
> +
> +	dev_cgroup = cgroup_to_devcgroup(cgroup);
> +	if (cgroup->parent)
> +		parent_dev_cgroup = cgroup_to_devcgroup(cgroup->parent);
> +
> +	if (parent_dev_cgroup == NULL)
> +		dev_cgroup->behavior = DEVCG_DEFAULT_ALLOW;

Shouldn't this happen under devcgroup_mutex?  How else is this gonna
be synchronized?

> +	else {
> +		mutex_lock(&devcgroup_mutex);
> +		ret = dev_exceptions_copy(&dev_cgroup->exceptions,
> +					  &parent_dev_cgroup->exceptions);
> +		if (!ret)
> +			dev_cgroup->behavior = parent_dev_cgroup->behavior;
> +		mutex_unlock(&devcgroup_mutex);
> +	}
> +
> +	return ret;
> +}
> +
> +static void devcgroup_offline(struct cgroup *cgroup)
> +{
> +	struct dev_cgroup *dev_cgroup = cgroup_to_devcgroup(cgroup);
> +	dev_cgroup->behavior = DEVCG_DEFAULT_NONE;

Ditto.

> +static int propagate_behavior(struct dev_cgroup *devcg)
> +{
> +	struct cgroup *root = devcg->css.cgroup, *pos, *saved = NULL,
> +			*prev = NULL, *ptr;
> +	struct dev_cgroup *parent;
> +	int rc = 0;
> +
> +	while (1) {
> +		rcu_read_lock();
> +		pos = NULL;
> +		devcg_for_each_child(ptr, root) {
> +			if (saved && prev != saved) {
> +				prev = pos;
> +				continue;
> +			}
> +			pos = ptr;
> +			break;
> +		}

Is this descendant walk?  Why not use
cgroup_for_each_descendant_pre/post()?  Is it because RCU can't be
released while walking?  If so, the whole thing is happening under the
mutex, so you can,

	rcu_read_lock();
	cgroup_for_each_descendant_post(pos,...)
		if (online)
			list_add_tail(pos->propagate_list, &to_be_processed);
	rcu_read_unlock();

	list_for_each_entry_safe(pos, ...) {
		propagate(pos);
		list_del_init(pos);
	}

Also, if you implemented your own descendant walk, it would have been
nice if you explained why it was necessary and how it worked.

Thanks.

-- 
tejun
