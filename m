Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641AbaE3IM6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 04:12:58 -0400
Received: from mga03.intel.com ([143.182.124.21]:49909 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753393AbaE3IMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 04:12:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,939,1392192000"; 
   d="scan'208";a="438915349"
Date: Fri, 30 May 2014 11:12:38 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: fs/dcache.c - BUG: soft lockup - CPU#5 stuck for 22s!
 [systemd-udevd:1667]
Message-ID: <20140530081238.GA1957@lahna.fi.intel.com>
References: <20140529053444.GI18016@ZenIV.linux.org.uk>
 <20140529105107.GB1938@lahna.fi.intel.com>
 <20140529110439.GA2006@lahna.fi.intel.com>
 <20140529133036.GJ18016@ZenIV.linux.org.uk>
 <CA+55aFzYjRrvSaF=wGimrgtEqR7GHbu1ku1qn1wQs5wgQrCZdg@mail.gmail.com>
 <20140529154454.GK18016@ZenIV.linux.org.uk>
 <20140529162307.GL18016@ZenIV.linux.org.uk>
 <CA+55aFyRDJpm2Wfg9jvXCsKYgt36=6A_++bX+Q=C4MvQRbqh_A@mail.gmail.com>
 <20140529165351.GM18016@ZenIV.linux.org.uk>
 <20140529185201.GN18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140529185201.GN18016@ZenIV.linux.org.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 07:52:01PM +0100, Al Viro wrote:
> On Thu, May 29, 2014 at 05:53:51PM +0100, Al Viro wrote:
> > On Thu, May 29, 2014 at 09:29:42AM -0700, Linus Torvalds wrote:
> > > On Thu, May 29, 2014 at 9:23 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > > >
> > > > BTW, lock_parent() might be better off if in contended case it would not
> > > > bother with rename_lock and did something like this:
> > > > again:
> > > 
> > > Ack. I think that's much better.
> > 
> > Pushed to #for-linus (with dumb braino fixed - it's if (parent != dentry),
> > not if (parent)).  I'll wait with folding it back into the commit that
> > introduces lock_parent() until we get testing results...
> 
> Grrr...  Sadly, that's not good enough.  Leaking rcu_read_lock() on
> success is trivial, but there's more serious problem: suppose dentries
> involved get moved before we get to locking what we thought was parent.
> We end up taking ->d_lock on two dentries that might be nowhere near each
> other in the tree, with obvious nasty implications.  Would be _very_ hard
> to reproduce ;-/
> 
> AFAICS, the following would be safe, but I'd really appreciate any extra
> eyes on that sucker:
> 
> static inline struct dentry *lock_parent(struct dentry *dentry)
> {
>         struct dentry *parent = dentry->d_parent;
>         if (IS_ROOT(dentry))
>                 return NULL;
>         if (likely(spin_trylock(&parent->d_lock)))
>                 return parent;
>         spin_unlock(&dentry->d_lock);
>         rcu_read_lock();
> again:
>         parent = ACCESS_ONCE(dentry->d_parent);
>         spin_lock(&parent->d_lock);
>         /*
>          * We can't blindly lock dentry until we are sure
>          * that we won't violate the locking order.
>          * While parent->d_lock is not enough to stabilize
> 	 * dentry->d_parent, it *is* enough to stabilize
> 	 * dentry->d_parent == parent.
>          */
>         if (unlikely(parent != dentry->d_parent)) {
>                 spin_unlock(&parent->d_lock);
>                 goto again;
>         }
>         rcu_read_unlock();
>         if (parent != dentry)
>                 spin_lock(&dentry->d_lock);
>         else
>                 parent = NULL;
>         return parent;
> }
> 
> That variant got force-pushed in place of the previous one, again at the
> head of #for-linus.  And I'm definitely not folding it in until it gets
> more review and testing.

Tested your latest #for-linus from here:

https://git.kernel.org/cgit/linux/kernel/git/viro/vfs.git/log/?h=for-linus

and the livelock is gone,

Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Thanks again!
