Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759100Ab3CYX4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 19:56:42 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:37083 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753848Ab3CYX4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 19:56:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhUZALPjUFF5LOOq/2dsb2JhbABDhW64cYUSAQMBgQkXdIIfAQEFOhwjEAgDDgoJJQ8FJQMhE4gTsl2QCRWNaCAeXQeDQAOWZoluhxeDHig
Date: Tue, 26 Mar 2013 10:56:14 +1100
From: Dave Chinner <david@fromorbit.com>
To: Greg Thelen <gthelen@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: dcache: cond_resched in shrink_dentry_list
Message-ID: <20130325235614.GI6369@dastard>
References: <1364232151-23242-1-git-send-email-gthelen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364232151-23242-1-git-send-email-gthelen@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25, 2013 at 10:22:31AM -0700, Greg Thelen wrote:
> Call cond_resched() from shrink_dentry_list() to preserve
> shrink_dcache_parent() interactivity.
> 
> void shrink_dcache_parent(struct dentry * parent)
> {
> 	while ((found = select_parent(parent, &dispose)) != 0)
> 		shrink_dentry_list(&dispose);
> }
> 
> select_parent() populates the dispose list with dentries which
> shrink_dentry_list() then deletes.  select_parent() carefully uses
> need_resched() to avoid doing too much work at once.  But neither
> shrink_dcache_parent() nor its called functions call cond_resched().
> So once need_resched() is set select_parent() will return single
> dentry dispose list which is then deleted by shrink_dentry_list().
> This is inefficient when there are a lot of dentry to process.  This
> can cause softlockup and hurts interactivity on non preemptable
> kernels.

Hi Greg,

I can see how this coul dcause problems, but isn't the problem then
that shrink_dcache_parent()/select_parent() itself is mishandling
the need for rescheduling rather than being a problem with
the shrink_dentry_list() implementation?  i.e. select_parent() is
aborting batching based on a need for rescheduling, but then not
doing that itself and assuming that someone else will do the
reschedule for it?

Perhaps this is a better approach:

-	while ((found = select_parent(parent, &dispose)) != 0)
+	while ((found = select_parent(parent, &dispose)) != 0) {
                shrink_dentry_list(&dispose);
+		cond_resched();
+	}

With this, select_parent() stops batching when a resched is needed,
we dispose of the list as a single batch and only then resched if it
was needed before we go and grab the next batch. That should fix the
"small batch" problem without the potential for changing the
shrink_dentry_list() behaviour adversely for other users....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
