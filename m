Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab3IISGK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 14:06:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53916 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab3IISGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 14:06:09 -0400
Date: Mon, 9 Sep 2013 19:06:04 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Waiman Long <Waiman.Long@hp.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        George Spelvin <linux@horizon.com>, John Stoffel <john@stoffel.org>
Subject: Re: [PATCH v4 1/1] dcache: Translating dentry into pathname without
 taking rename_lock
Message-ID: <20130909180604.GO13318@ZenIV.linux.org.uk>
References: <1378743493-33546-1-git-send-email-Waiman.Long@hp.com>
 <1378743493-33546-2-git-send-email-Waiman.Long@hp.com>
 <20130909172905.GN13318@ZenIV.linux.org.uk>
 <CA+55aFx_pUwHg35Ueb4Ewy8ZrBA_UtFbQqdRzL64_Q7iQ=V-rA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFx_pUwHg35Ueb4Ewy8ZrBA_UtFbQqdRzL64_Q7iQ=V-rA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 10:45:38AM -0700, Linus Torvalds wrote:
> On Mon, Sep 9, 2013 at 10:29 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > I'm not sure I like mixing rcu_read_lock() into that - d_path() and friends
> > can do that themselves just fine (it needs to be taken when seq is even),
> > and e.g. d_walk() doesn't need it at all.  Other than that, I'm OK with
> > this variant.
> 
> Hmm.. I think you need the RCU read lock even when you get the write_seqlock().
> 
> Yes, getting the seqlock for write implies that you get a spinlock and
> in many normal circumstances that basically is equvalent to being
> rcu-locked, but afaik in some configurations that is *not* sufficient
> protection against an RCU grace period on another CPU. You need to do
> a real rcu_read_lock that increments that whole rcu_read_lock_nesting
> level, which a spinlock won't do.
> 
> And while the rename sequence lock protects against _renames_, it does
> not protect against just plain dentries getting free'd under memory
> pressure.

It protects the chain of ->d_parent, so they'd better not get freeds at
all...

> So I think the RCU-readlockness really needs to be independent of the
> sequence lock.

Actually, now that I've tried to convert d_walk() to those guys, I think
I like my proposal for the set of primitives better:

static inline bool seqretry_and_lock(seqlock_t *lock, unsigned *seq):
{
        if ((*seq & 1) || !read_seqretry(lock, *seq))
                return true;
        *seq |= 1;
        write_seqlock(lock);
        return false;
}

static inline void seqretry_done(seqlock_t *lock, unsigned seq)
{
        if (seq & 1)
                write_sequnlock(lock);
}

with the prepend_path() and friends becoming

	rcu_read_lock();
	seq = read_seqbegin(&rename_lock);
again:
	....
	if (!seqretry_and_lock(&rename_lock, seq))
		goto again;	/* now as writer */
	seqretry_done(&rename_lock, seq);
	rcu_read_unlock();

The thing is, d_walk() does essentially

	seq = read_seqbegin(&rename_lock);
again:
	....
	spin_lock(&d->d_lock);
	if (!seqretry_and_lock(&rename_lock, seq)) {
		spin_unlock(&d->d_lock);
		goto again;	/* now as writer */
	}
	/* now we are holding ->d_lock on it and we know
	 * that d has not gone stale until that point.
	 */	
	do stuff with d
	spin_unlock(&d->d_lock);
	seqretry_done(&rename_lock, seq);

OTOH, it's not impossible to handle with Waiman's primitives, just more
massage to do that...
