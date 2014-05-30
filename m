Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbaE3Gt1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 02:49:27 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60324 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbaE3GtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 02:49:25 -0400
Date: Fri, 30 May 2014 07:49:22 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: fs/dcache.c - BUG: soft lockup - CPU#5 stuck for 22s!
 [systemd-udevd:1667]
Message-ID: <20140530064922.GQ18016@ZenIV.linux.org.uk>
References: <20140529133036.GJ18016@ZenIV.linux.org.uk>
 <CA+55aFzYjRrvSaF=wGimrgtEqR7GHbu1ku1qn1wQs5wgQrCZdg@mail.gmail.com>
 <20140529154454.GK18016@ZenIV.linux.org.uk>
 <20140529162307.GL18016@ZenIV.linux.org.uk>
 <CA+55aFyRDJpm2Wfg9jvXCsKYgt36=6A_++bX+Q=C4MvQRbqh_A@mail.gmail.com>
 <20140529165351.GM18016@ZenIV.linux.org.uk>
 <20140529185201.GN18016@ZenIV.linux.org.uk>
 <CA+55aFwNv2-9=uXxzYH9UpN_x209Cv_BBu-9j2prSh2xVmmsAg@mail.gmail.com>
 <20140530045059.GP18016@ZenIV.linux.org.uk>
 <CA+55aFxGYDX6PTcMjYO3bsXTj+M0yF76Xtf_BCPmU+DrZ9hfzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxGYDX6PTcMjYO3bsXTj+M0yF76Xtf_BCPmU+DrZ9hfzQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 10:00:49PM -0700, Linus Torvalds wrote:

> Yeah, I think that would be good. Except I think you should create a
> "dentry_is_dead()" helper function that then has that "if you hold the
> dentry or parent lock, this is safe" comment, because for lockref in
> general you do need to have the lock in the lockref itself. The fact
> that dentries have more locking is very much dentry-specific.

With how many callers?  There literally are only two places where we look
at that bit; one of them very tempting to convert to ->d_lockref.count != 0,
since reactions to positive and negative are very similar.  We also have
that bogus BUG_ON() you've mentioned (that one simply should die) and only
one place where we check it for being negative - autofs4_lookup_active().
And that one is better dealt with by taking removal from their active
list from ->d_release() to ->d_prune() (if not turning their ->d_release()
into ->d_prune() wholesale) and making ->d_prune() called for hashed and
unhashed alike (the only instance *already* checks for d_unhashed() and does
nothing in that case; no need to check that in fs/dcache.c).  With that done,
the check will be gone - all it does is filtering out the ones that are
already on the way out, but still hadn't reached ->d_release()).

IOW, it's not a widely used functionality and it's really not something
that should be ever needed outside of fs/dcache.c.  And in fs/dcache.c
we have one call site, so I'm not sure if even mentioning __lockref_not_dead()
would make much sense - (int)child->d_lockref.count < 0 might be better,
along with a comment about ->d_parent->d_lock serializing it against
lockref_mark_dead() in __dentry_kill() just as well as ->d_lock would...

Note that the only reason why autofs is playing those games is that they
keep references to dentries that do not contribute to refcount, rip them
out when dentry is killed and do that in the wrong method, which opens the
window when ->d_lock is already dropped and ->d_release() is inevitable
but yet to be called.  Solution: rip those references out before dropping
->d_lock, which is what ->d_prune() gives us.  To be fair, that code
predates ->d_prune() by several years (Jul 2008 and Oct 2011, resp.)

And "vfs: call d_op->d_prune() before unhashing dentry" has added very
odd checks for !d_unhashed(), despite ceph ->d_prune() being an explicit
no-op in other cases...

While we are at it, what the devil is d_prune_aliases() doing?  OK, we
grab ->d_lock and see that refcount is 0.  Then we call ->d_prune(),
bump refcount to 1, forcibly unhash the sucker, drop ->d_lock and ->i_lock
and call dput().  Which seems to be far too convoluted...  AFAICS, what we
want to do is
                spin_lock(&dentry->d_lock);
                if (!dentry->d_lockref.count) {
			parent = lock_parent(dentry);
			if (likely(!dentry->d_lockref.count)) {
				__dentry_kill(dentry);
				goto restart;
			}
			if (parent)
				spin_unlock(&parent->d_lock);
		}
		spin_unlock(&dentry->d_lock);
(which means that pulling ->i_lock trylock into __dentry_kill() is
probably not a good plan, more's the pity...)  And there goes this second
call site of ->d_prune() - after that it would be called exactly in one place,
right after __dentry_kill() has done lockref_mark_dead().  The whole reason
for calling it there was that forcible unhash used to force dput() to kill
the sucker has a side effect of messing ceph ->d_prune()...
