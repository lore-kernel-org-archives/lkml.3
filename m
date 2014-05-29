Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464AbaE2QXN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 12:23:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57798 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbaE2QXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 12:23:11 -0400
Date: Thu, 29 May 2014 17:23:07 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: fs/dcache.c - BUG: soft lockup - CPU#5 stuck for 22s!
 [systemd-udevd:1667]
Message-ID: <20140529162307.GL18016@ZenIV.linux.org.uk>
References: <20140528141937.GZ18016@ZenIV.linux.org.uk>
 <20140528183954.GA18016@ZenIV.linux.org.uk>
 <20140529031149.GE18016@ZenIV.linux.org.uk>
 <20140529035233.GF18016@ZenIV.linux.org.uk>
 <20140529053444.GI18016@ZenIV.linux.org.uk>
 <20140529105107.GB1938@lahna.fi.intel.com>
 <20140529110439.GA2006@lahna.fi.intel.com>
 <20140529133036.GJ18016@ZenIV.linux.org.uk>
 <CA+55aFzYjRrvSaF=wGimrgtEqR7GHbu1ku1qn1wQs5wgQrCZdg@mail.gmail.com>
 <20140529154454.GK18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140529154454.GK18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 04:44:54PM +0100, Al Viro wrote:
> On Thu, May 29, 2014 at 08:10:57AM -0700, Linus Torvalds wrote:
> > If so, though, that brings up two questions:
> > 
> >  (a) do we really want to be that aggressive? Can we ever traverse
> > _past_ the point we're actually trying to shrink in
> > shrink_dcache_parent()?
> 
> Caller of shrink_dcache_parent() would better hold a reference to the
> argument, or it might get freed right under us ;-)  So no, we can't
> go past that point - the subtree root will stay busy.
> 
> The reason we want to be aggressive there is to avoid excessive iterations -
> think what happens e.g. if we have a chain of N dentries, with nothing pinning
> them (i.e. the last one has refcount 0, the first - 2, everything else - 1).
> Simply doing dput() would result in O(N^2) vs. O(N)...
> 
> >  (b) why does the "dput()" (or rather, the dentry_kill()) locking
> > logic have to retain the old trylock case rather than share the parent
> > locking logic?
> > 
> > I'm assuming the answer to (b) is that we can't afford to drop the
> > dentry lock in dentry_kill(), but I'd like that answer to the "Why" to
> > be documented somewhere.
> 
> We actually might be able to do it that way (rechecking ->d_count after
> lock_parent()), but I would really prefer to leave that until after -final.
> I want to get profiling data from that first - dput() is a much hotter path
> than shrink_dcache_parent() and friends...

FWIW, I've just done more or less edible splitup of stuff past #for-linus -
see #experimental-dentry_kill for that.  Again, I really want to get
profiling data to see if that hurts dput() - it takes ->d_lock on parent
before the trylock on ->i_lock and in case of ->d_lock on parent being
held by somebody else it bangs on rename_lock.lock cacheline.  I'd expect
that to be non-issue on any loads, but we need something stronger than
my gut feelings...

BTW, lock_parent() might be better off if in contended case it would not
bother with rename_lock and did something like this:
again:
	spin_unlock(&dentry->d_lock);
	rcu_read_lock();
	parent = ACCESS_ONCE(dentry->d_parent);
	if (parent != dentry)
		spin_lock(&parent->d_lock);
	spin_lock(&dentry->d_lock);
	if (likely(dentry->d_parent == parent)) {
		rcu_read_unlock();
		return parent;
	}
	if (parent)
		spin_unlock(&parent->d_lock);
	rcu_read_unlock();
	goto again;

It's almost certainly not worth bothering with right now, but if dput()
starts using lock_parent(), it might be worth investigating...
