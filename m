Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab3KAJYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 05:24:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43427 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753987Ab3KAJYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 05:24:51 -0400
Date: Fri, 1 Nov 2013 09:24:46 +0000
From: Mel Gorman <mgorman@suse.de>
To: Chris Mason <chris.mason@fusionio.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] futex: Remove requirement for lock_page in
 get_futex_key
Message-ID: <20131101092446.GU2400@suse.de>
References: <20131029173814.GH2400@suse.de>
 <20131029184827.10719.27487@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20131029184827.10719.27487@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 02:48:27PM -0400, Chris Mason wrote:
> Quoting Mel Gorman (2013-10-29 13:38:14)
> > Thomas Gleixner and Peter Zijlstra discussed off-list that real-time users
> > currently have a problem with the page lock being contended for unbounded
> > periods of time during futex operations. The three of us discussed the
> > possibiltity that the page lock is unnecessary in this case because we are
> > not concerned with the usual races with reclaim and page cache updates. For
> > anonymous pages, the associated futex object is the mm_struct which does
> > not require the page lock. For inodes, we should be able to check under
> > RCU read lock if the page mapping is still valid to take a reference to
> > the inode.  This just leaves one rare race that requires the page lock
> > in the slow path. This patch does not completely eliminate the page lock
> > but it should reduce contention in the majority of cases.
> > 
> > Patch boots and futextest did not explode but I did no comparison
> > performance tests. Thomas, do you have details of the workload that
> > drove you to examine this problem? Alternatively, can you test it and
> > see does it help you? I added Chris to the To list because he mentioned
> > that some filesystems might already be doing tricks similar to this
> > patch that are worth copying.
> 
> Unfortunately, all the special cases I see in the filesystems either
> have an inode ref or are trylocking the page to safety.
> 

Ok, at the time of the futex call there is an implicit ref due to the
mapping but it can be torn away underneath us at any time. I *think* I
have the right ordering to not make a mistake in this case but more eyes
the better.

> XFS is a special case because they have their own inode cache, but by my
> reading they are still using i_count and free by rcu.
> 

Good, that's what I expected.

> The iput in here is a little tricky:
> 
> > 
> > +               /* Should be impossible but lets be paranoid for now */
> > +               if (WARN_ON(inode->i_mapping != mapping)) {
> > +                       rcu_read_unlock();
> > +                       iput(inode);
> > +                       put_page(page_head);
> > +                       goto again;
> > +               }
> > +
> 
> Once you call iput, you add the potential to call the filesystem unlink
> operation if i_nlink had gone to zero.  This shouldn't be a problem
> since you've dropped the rcu lock, but just for fun I'd move the
> put_page up a line.
> 
> Or, change it to a BUG_ON instead, it really should be impossible.

I'll do that. It'll blow up with the RCU lock still held so the system
is going to have a bad day but we're already in hell at this point.

Thanks Chris

-- 
Mel Gorman
SUSE Labs
