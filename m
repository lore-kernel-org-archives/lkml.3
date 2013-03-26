Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932880Ab3CZCkj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 22:40:39 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:52126 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758879Ab3CZCki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 22:40:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhUZAHsJUVF5LG6s/2dsb2JhbABDhW64foUSAQMBgQcXdIIfAQEFOhwjEAgDDgoJJQ8FJQMhE4gTsiKQCRWNaCAeXQeDQAOWZoluhxeDHig
Date: Tue, 26 Mar 2013 13:40:32 +1100
From: Dave Chinner <david@fromorbit.com>
To: Greg Thelen <gthelen@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: dcache: cond_resched in shrink_dentry_list
Message-ID: <20130326024032.GJ6369@dastard>
References: <1364232151-23242-1-git-send-email-gthelen@google.com>
 <20130325235614.GI6369@dastard>
 <xr93fvzjgfke.fsf@gthelen.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xr93fvzjgfke.fsf@gthelen.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25, 2013 at 05:39:13PM -0700, Greg Thelen wrote:
> On Mon, Mar 25 2013, Dave Chinner wrote:
> > On Mon, Mar 25, 2013 at 10:22:31AM -0700, Greg Thelen wrote:
> >> Call cond_resched() from shrink_dentry_list() to preserve
> >> shrink_dcache_parent() interactivity.
> >> 
> >> void shrink_dcache_parent(struct dentry * parent)
> >> {
> >> 	while ((found = select_parent(parent, &dispose)) != 0)
> >> 		shrink_dentry_list(&dispose);
> >> }
> >> 
> >> select_parent() populates the dispose list with dentries which
> >> shrink_dentry_list() then deletes.  select_parent() carefully uses
> >> need_resched() to avoid doing too much work at once.  But neither
> >> shrink_dcache_parent() nor its called functions call cond_resched().
> >> So once need_resched() is set select_parent() will return single
> >> dentry dispose list which is then deleted by shrink_dentry_list().
> >> This is inefficient when there are a lot of dentry to process.  This
> >> can cause softlockup and hurts interactivity on non preemptable
> >> kernels.
> >
> > Hi Greg,
> >
> > I can see how this coul dcause problems, but isn't the problem then
> > that shrink_dcache_parent()/select_parent() itself is mishandling
> > the need for rescheduling rather than being a problem with
> > the shrink_dentry_list() implementation?  i.e. select_parent() is
> > aborting batching based on a need for rescheduling, but then not
> > doing that itself and assuming that someone else will do the
> > reschedule for it?
> >
> > Perhaps this is a better approach:
> >
> > -	while ((found = select_parent(parent, &dispose)) != 0)
> > +	while ((found = select_parent(parent, &dispose)) != 0) {
> >                 shrink_dentry_list(&dispose);
> > +		cond_resched();
> > +	}
> >
> > With this, select_parent() stops batching when a resched is needed,
> > we dispose of the list as a single batch and only then resched if it
> > was needed before we go and grab the next batch. That should fix the
> > "small batch" problem without the potential for changing the
> > shrink_dentry_list() behaviour adversely for other users....
> 
> I considered only modifying shrink_dcache_parent() as you show above.
> Either approach fixes the problem I've seen.  My initial approach adds
> cond_resched() deeper into shrink_dentry_list() because I thought that
> there might a secondary benefit: shrink_dentry_list() would be willing
> to give up the processor when working on a huge number of dentry.  This
> could improve interactivity during shrinker and umount.  I don't feel
> strongly on this and would be willing to test and post the
> add-cond_resched-to-shrink_dcache_parent approach.

The shrinker has interactivity problems because of the global
dcache_lru_lock, not because of ithe size of the list passed to
shrink_dentry_list(). The amount of work that shrink_dentry_list()
does here is already bound by the shrinker batch size. Hence in the
absence of the RT folk complaining about significant holdoffs I
don't think there is an interactivity problem through the shrinker
path.

As for the unmount path - shrink_dcache_for_umount_subtree() - that
doesn't use shrink_dentry_list() and so would need it's own internal
calls to cond_resched().  Perhaps it's shrink_dcache_sb() that you
are concerned about?  Either way, And there are lots more similar
issues in the unmount path such as evict_inodes(), so unless you are
going to give every possible path through unmount/remount/bdev
invalidation the same treatment then changing shrink_dentry_list()
won't significantly improve the interactivity of the system
situation in these paths...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
