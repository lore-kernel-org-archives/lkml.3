Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab3BDPDN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 10:03:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754255Ab3BDPDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 10:03:12 -0500
Date: Mon, 4 Feb 2013 10:03:07 -0500
From: Aristeu Rozanski <aris@redhat.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH v5 9/9] devcg: propagate local changes down the hierarchy
Message-ID: <20130204150307.GQ17632@redhat.com>
References: <20130130171101.060853036@napanee.usersys.redhat.com>
 <20130130171102.390708521@napanee.usersys.redhat.com>
 <20130131043839.GA14726@mail.hallyn.com>
 <20130201190958.GP17632@redhat.com>
 <20130202161341.GA11284@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130202161341.GA11284@mail.hallyn.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02, 2013 at 04:13:41PM +0000, Serge E. Hallyn wrote:
> Quoting Aristeu Rozanski (aris@redhat.com):
> > +static int propagate_behavior(struct dev_cgroup *devcg_root)
> > +{
> > +	struct cgroup *root = devcg_root->css.cgroup;
> > +	struct dev_cgroup *parent, *devcg, *tmp;
> > +	int rc = 0;
> > +	LIST_HEAD(pending);
> > +
> > +	get_online_devcg(root, &pending);
> > +
> > +	list_for_each_entry_safe(devcg, tmp, &pending, propagate_pending) {
> > +		parent = cgroup_to_devcgroup(devcg->css.cgroup->parent);
> > +
> > +		/* first copy parent's state */
> > +		devcg->behavior = parent->behavior;
> > +		dev_exception_clean(&devcg->exceptions);
> > +		rc = dev_exceptions_copy(&devcg->exceptions, &parent->exceptions);
> 
> You may not want to do this if parent->behavior == DENY and
> devcg->local.behavior == ALLOW.  You'll end up with matches
> in may_access() in the child, where you assume that if
> devcg->behavior != ALLOW it is DENY.
> 
> Now maybe that *was* your intent, but if so then I think you're
> better off explicitly changing the child to DENY below.  (See my
> related question below)

hm, could go either way. if the local behavior is allowed and it's
different, clearing the local list should be enough.

but yes, you're right, the way it is now is wrong.

> > +		if (devcg->local.behavior == devcg->behavior) {
> > +			rc = revalidate_exceptions(devcg);
> > +		} else {
> > +			dev_exception_clean(&devcg->local.exceptions);
> > +			/*
> > +			 * if the local behavior couldn't be applied,
> > +			 * reset it
> > +			 */
> > +			devcg->local.behavior = DEVCG_DEFAULT_NONE;
> 
> So the only way this will happen is if the parent and child were
> originally both ALLOW, and the parent switches to DENY.

hm, no. it could also happen if it was deny/deny. if a new exception is
written in the child (consider that the parent just had a new exception
written) it'll change automatically local.behavior to
DEVCG_DEFAULT_DENY.

> Now in general I'd discourage starting containers in ALLOW mode
> at all, but I think if someone does so, then changes the host to
> DENY, the container should not be blindly switched to having no
> access.  Now as I say the way you have the code it will actually
> behave a bit like a DENY...
> 
> Really I don't know what the right thing to do is.  The best I can
> come up with is a big fat syslog warning, and keep the child as
> ALLOW with exactly its original set of exceptions.

hm, if you do that you're breaking the hierarchy and this patchset is
useless :)

> What you're doing iiuc is switching them to DENY behavior (but refusing
> future exception additions) with a copy of the parent's rules.

hm, no. I think you misunderstood "local.behavior = DEVCG_DEFAULT_NONE".
This means "there's no local preference for behavior". local.* are just
the local preferences that need to be revalidated everytime something is
propagated. Or did you mean something else?

-- 
Aristeu

