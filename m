Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617AbaIZQor (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 12:44:47 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47142 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448AbaIZQop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 12:44:45 -0400
Date: Fri, 26 Sep 2014 17:44:42 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mikhail Efremov <sem@altlinux.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] vfs: Don't exchange "short" filenames unconditionally.
Message-ID: <20140926164442.GA26897@ZenIV.linux.org.uk>
References: <1411582473-29184-1-git-send-email-sem@altlinux.org>
 <20140924185521.GC7996@ZenIV.linux.org.uk>
 <CA+55aFzTs5R_TzwdsBRAkw+mGLWF0XT9_sGeb_+ETUy-gJsY_w@mail.gmail.com>
 <20140924201813.GI7996@ZenIV.linux.org.uk>
 <20140925044601.GL7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140925044601.GL7996@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 05:46:01AM +0100, Al Viro wrote:
> On Wed, Sep 24, 2014 at 09:18:13PM +0100, Al Viro wrote:
> > On Wed, Sep 24, 2014 at 12:20:38PM -0700, Linus Torvalds wrote:
> > > On Wed, Sep 24, 2014 at 11:55 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > > >
> > > > Yecchhhh...  Applied, but it's very ugly.  Oh, well - regression is
> > > > regression, and I don't see a cleaner fix at the moment.  If I don't
> > > > manage to come up with anything prettier, to Linus it goes in tonight
> > > > pull request ;-/
> > > 
> > > Please don't. That thing is too ugly to exist. It also looks
> > > completely and utterly buggy. There's no way I'm taking it. If
> > > switch-names is suddenly conditional, what the f*ck happens to the
> > > name hash which is unconditionally done with a swap() right
> > > afterwards.
> > 
> > The sucker's unhashed after that...  And yes, I agree that it's fucking
> > ugly.  Still looking for saner ways to do that...
> 
> I really wonder if it's possible to get d_rehash() hitting the victim of
> (non-exchange) __d_move().  _Then_ this patch (as well as the historical
> behaviour it restores, all way back to 2.5, if not 2.3) would, indeed,
> be buggy.
> 
> I'd probably better sleep on that and finish YACrawlingTFS tomorrow morning
> - it's nearly 1am here and I've got only 5 hours of sleep left until it's time
> to get the kids up for school ;-/

FWIW, the longer I'm looking at that, the more it seems that __d_move() and
__d_materialise_dentry() ought to be merged.  The thing is, both callers of
the latter are followed by the same sequence:
                        write_sequnlock(&rename_lock);
			_d_rehash(anon);
			spin_unlock(&anon->d_lock);
(in one case - verbatim, in another - with goto thrown in before _d_rehash()).
Now, there's no good reason for doing that write_sequnlock() first; both
_d_rehash() and spin_unlock() are fast enough to make contention on
rename_lock a non-issue.  And if we pull those before write_sequnlock() and
into __d_materialise_dentry(dentry, anon), we get rid not only of code
duplication, but of the "it returns with anon->d_lock held" caution as well,
*and* __d_materialise_dentry() becomes very similar to __d_move().

	Note that __d_move(x, y) depends on !IS_ROOT(y), while
__d_materialise_dentry(x, y) assumes (and is obviously guaranteed by
callers) IS_ROOT(y).  IOW, even leaving aside the "is it an exchange" argument
fed to __d_move(), we could distinguish between these guys by IS_ROOT(y)
alone.  And there's a fuckload of duplication between them even now, let alone
after pulling the rehash in.

And d_splice_alias() definitely ought to be merged with d_materialise_unique().
Making it accept hashed dentries had been a mistake - there are _very_ few
places where that happens.  One in d_add_ci() is my mistake (and essentially
a dead code - case-insensitive XFS doesn't get hashed negative dentries,
so this codepath in d_add_ci() never triggers), the one in gfs2_create_inode()
is trivially avoided - it should be "fail with EISDIR if that inode is a
directory, do d_instantiate() otherwise" and one in __gfs2_lookup() can only
be reached for a hashed dentry from gfs2_atomic_open(), which has no business
calling gfs2_lookup() if dentry it got from caller is hashed.  And that's
it - only 3 callsites where we could call d_splice_alias() for hashed dentry.

With those taken care of, we really have no reason not to fold
d_materialise_unique() into d_splice_alias() - just teach the latter to
do __d_unalias() in case when existing directory alias is not IS_ROOT.
d_splice_alias() fails with EIO in that case, mostly since on a local fs
that can only happen due to fs corruption.  No reason not to do __d_unalias()
instead.

What's more, d_add_unique() and d_instantiate_unique() are also very
dubious.  The use of the latter in proc_ns_get_dentry() is complete BS,
since there the dentry passed to it is an IS_ROOT() one we'd just obtained
from d_alloc_pseudo(), so the loop over aliases in __d_instantiate_unique()
has no chance whatsoever to find anything it would like - none of them
could possibly have the same ->d_parent value.  IOW, that call is plain
and simple pessimization of d_instantiate().  Which leaves us with exactly
one caller - d_add_unique().  Which itself has exactly one caller.  This:
        dentry = opendata->dentry;
        if (dentry->d_inode == NULL) {
                /* FIXME: Is this d_drop() ever needed? */
                d_drop(dentry);
                dentry = d_add_unique(dentry, igrab(state->inode));
                if (dentry == NULL) {
                        dentry = opendata->dentry;
                } else if (dentry != ctx->dentry) {
                        dput(ctx->dentry);
                        ctx->dentry = dget(dentry); 
                }
First of all, *is* this d_drop() needed, indeed?  Can that dentry be
already hashed?  FWIW, in case it has been hashed we can't expect any aliases
to satisfy d_instantiate_unique() - for that we would need to have a really
weird state just before d_drop(); positive and negative dentries with the
same parent and the same name, which obviously shouldn't happen.  So in
case when dentry has been hashed when we got there (if that's possible at
all), we might as well just call d_instatiate() and be done with that.
And when it's not hashed...  What's wrong with just using d_materialise_unique()
there?  I'm not familiar enough with the guts of NFS4 (and I've had more than
enough of digging through the really nasty callchains during the last few
days), so some comments from NFS folks would be very welcome...

AFAICS, we have a good chance to fold that bunch of suckers into one
primitive.  Moreover, the same primitive ought to be used through all
->lookup() instances, even on non-exportable filesystems where we are
still using d_add().  The thing is, d_splice_alias() will only hit the
fastpath on those, which does the same thing d_add() does.  That's
the only reason why d_add() is valid there in the first place.  And
checking for that fastpath is cheap - we need to check that inode is
non-NULL anyway (to decide whether we need to take ->i_lock) and we
need to take ->i_lock and at least fetch ->i_alias.next in case when
inode isn't NULL.  The only thing remaining to decide that d_splice_alias()
can take the fastpath is checking that inode isn't a directory one.

That basically leaves d_add() to be used only when something is populating
a synthetic tree.  And even there I'm not sure it makes sense to keep it
a separate primitive - inodes in those remaining callers tend to be
brand-new, which would send d_splice_alias() on the fastpath simply because
->i_alias will be empty.  So in theory we might get away with *all* that
stuff merged into one primitive: d_add/d_splice_alias/d_materialise_unique/
d_add_unique to be used when we want hashed result.  FWIW, all those guys
had started as forked-off variants of d_add(), so we would just be folding
them all back...

As an aside, I really *hate* the way lustre crowd has spewed out the wonders
like ll_d_hlist_empty() and its ilk.  The whole thing is a major eye-bleeder
as it is, but this "If you want to grep for something, you'll just have to
grep for our pointless wrapper separately.  Give us respect, bitch - we are
reeeal special!" kind of attitude is extremely annoying.  Could we please
take all that shite out?  Not drivers/staging/lustre, tempting as it might be,
just those wrappers?
