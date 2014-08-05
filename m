Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbaHEFOn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 01:14:43 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41829 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbaHEFOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 01:14:42 -0400
Date: Tue, 5 Aug 2014 06:14:39 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: NeilBrown <neilb@suse.de>, linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: Is lockref_get_not_zero() really correct in dget_parent()
Message-ID: <20140805051439.GQ18016@ZenIV.linux.org.uk>
References: <20140805131758.3afa6b0b@notabene.brown>
 <CA+55aFxDQ8fE16uKPfjU-nBnvfjWHz3ib5mo1BDn2=JKXVQQmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxDQ8fE16uKPfjU-nBnvfjWHz3ib5mo1BDn2=JKXVQQmQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 09:07:32PM -0700, Linus Torvalds wrote:

> So renaming it to "lockref_get_active()", and changing the "not zero"
> test to check for "positive" and change the rtype of "count" to be
> signed, all sound like good things to me.

Fine by me.  I can do that, unless somebody else beats me to that.

> But I don't actually think it's an active bug, it's just an "active
> horribly ugly and subtly working code". I guess in theory if you can
> get lots of CPU's triggering the race at the same time, the magic
> negative number could become zero and positive, but at that point I
> don't think we're really talking reality any more.
> 
> Can somebody pick holes in that? Does somebody want to send in the
> cleanup patch?

FWIW, dget_parent() has been a bloody annoyance - most of the callers used
to be racy and looking through the current set...  Take a look at e.g.
fs/btrfs/tree-log.c:check_parent_dirs_for_sync().  In the loop there we
do
                if (!parent || !parent->d_inode || sb != parent->d_inode->i_sb)
                        break;

                if (IS_ROOT(parent))
                        break;

                parent = dget_parent(parent);
                dput(old_parent);
                old_parent = parent;
                inode = parent->d_inode;
and it's so bogus it's not even funny.  What the hell is that code trying to
check?  And while we are at it, can we race with renames there?

>From my reading of that code, most of it ought to have been under
rcu_read_lock() and sod all that playing with refcounts.  Other
btrfs users are not much nicer (who says, for instance, that result of
check_parent_dirs_for_sync() will remain valid?)

ecryptfs lock_parent(): AFAICS, all callers could do ecryptfs_dentry_to_lower()
on dentry->d_parent instead of doing ecryptfs_dentry_to_lower(dentry) and
then doing dget_parent() - the covering layer dentries have ->d_parent
stabilized by ->i_mutex on said parents and we really, really don't want to
run into the case when tree topologies go out of sync.  I.e. we want to grab
->i_mutex on lower(parent), then check that it's equal to parent(lower) and,
if it's at all possible that some joker has played with rename(2) on underlying
layer mounted somewhere else, drop everything we'd taken and bugger off.

XFS xfs_filestream_get_parent() is clearly bogus -
        parent = dget_parent(dentry);
        if (!parent)
                goto out_dput;
When does dget_parent() return NULL?

And that's just from a quick grep.  The point is, dget_parent() is not a nice
API - historically it's been abused more often than not and we keep playing
whack-a-mole with it.  Sigh...

Speaking of bogosities, apparently nobody has noticed that automagical
turning BSD process accounting off upon r/o remounts of the filesystem
hosting the log got broken several years ago.  Suppose we find an opened
log when remounting.  OK, it gets closed, which means filp_close(...).
Which means that actual closing that sucker will happen just before we
return to userland.  Return with -EBUSY, since the filesystem still has
a file opened for write when we get around to checking that...

I have kinda-sorta fixes for that (basically, restoring the situation we
used to have before delayed fput() and being damn careful about avoiding
deadlocks), but I would really love to just rip that idiocy out.  IOW,
just let it fail with -EBUSY in such cases, same as for any other write-opened
file on that fs.

That, BTW, is the most painful part of the acct series, so being able to
drop it would be very nice.  Comments?
