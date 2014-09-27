Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474AbaI0EqD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 00:46:03 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48756 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbaI0EqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 00:46:01 -0400
Date: Sat, 27 Sep 2014 05:45:55 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mikhail Efremov <sem@altlinux.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] vfs: Don't exchange "short" filenames unconditionally.
Message-ID: <20140927044555.GS7996@ZenIV.linux.org.uk>
References: <1411582473-29184-1-git-send-email-sem@altlinux.org>
 <20140924185521.GC7996@ZenIV.linux.org.uk>
 <CA+55aFzTs5R_TzwdsBRAkw+mGLWF0XT9_sGeb_+ETUy-gJsY_w@mail.gmail.com>
 <20140924201813.GI7996@ZenIV.linux.org.uk>
 <20140925044601.GL7996@ZenIV.linux.org.uk>
 <20140926164442.GA26897@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140926164442.GA26897@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 05:44:42PM +0100, Al Viro wrote:

> FWIW, the longer I'm looking at that, the more it seems that __d_move() and
> __d_materialise_dentry() ought to be merged.  The thing is, both callers of
> the latter are followed by the same sequence:
>                         write_sequnlock(&rename_lock);
> 			_d_rehash(anon);
> 			spin_unlock(&anon->d_lock);
> (in one case - verbatim, in another - with goto thrown in before _d_rehash()).
> Now, there's no good reason for doing that write_sequnlock() first; both
> _d_rehash() and spin_unlock() are fast enough to make contention on
> rename_lock a non-issue.  And if we pull those before write_sequnlock() and
> into __d_materialise_dentry(dentry, anon), we get rid not only of code
> duplication, but of the "it returns with anon->d_lock held" caution as well,
> *and* __d_materialise_dentry() becomes very similar to __d_move().
> 
> 	Note that __d_move(x, y) depends on !IS_ROOT(y), while
> __d_materialise_dentry(x, y) assumes (and is obviously guaranteed by
> callers) IS_ROOT(y).  IOW, even leaving aside the "is it an exchange" argument
> fed to __d_move(), we could distinguish between these guys by IS_ROOT(y)
> alone.  And there's a fuckload of duplication between them even now, let alone
> after pulling the rehash in.

It's actually even better.  __d_materialise_dentry() has its arguments in
the wrong order.  Flip them around and it's very nearly an exact copy of
what we do in __d_move() when the first argument is IS_ROOT().  Actually,
that case in __d_move() had been added back in 2002 exactly for the needs
of d_splice_alias().  And it's been unreachable since this Bruce has
switched d_splice_alias() to use of __d_materialise_dentry().  In fact,
both d_splice_alias() and d_materialise_unique() should've been switched
to __d_move() instead.

I've done that massage and removal of __d_materialise_dentry().  The things
look a lot saner now that all dentry moving is done in one place, IMO.  Not to
mention that it trims ~50 lines off fs/dcache.c, driving it down to the 3rd
place in fs/*.c ;-)

Anyway, I've put the branch with fixes + that stuff in vfs.git#for-linus;
I have *NOT* put the "keep names on overwriting rename" horror in there,
but I believe that we will need something of that sort.

Linus, it's a real userland regression.  Yes, it affects only shitty scripts,
and they had never been reliable for long names anyway, but we have broken
real-world userland code by that.  What happened there is that old behaviour
of removal-by-rename wrt d_path() used to be similar to that on unlink.
cd /tmp; touch foo; touch bar
exec 42<bar
mv foo bar
ls -l /proc/self/fd/42
would give you
lr-x------ 1 al al 64 Sep 26 23:44 /proc/self/fd/42 -> /tmp/bar (deleted)
Now it gives "/tmp/foo (deleted)".  The trouble being, the same goes for
/proc/*/exe.  If you upgraded a package and that had replaced a running binary,
you used to be able to find process still running that binary.  After the
upgrade.  And yes, it was an unreliable kludge and the value of that was
in the best case dubious, but there really are people who used to do it.
And it broke after we'd added RENAME_EXCHANGE support.  The old behaviour
of switch_names() in short names case used to be "copy the name/length
of target to source dentry, swap hash keys and piss on hash key of target
not matching target's name anymore - the sucker is unhashed anyway".  For
RENAME_EXCHANGE we certainly needed to swap the names in all cases -
precisely because both suckers are hashed in the end.  And since we had
done that in exchange case, it was simpler to do it in all cases.  Especially
since when either name had been a long one we'd always swapped them, so
anything relying on old behaviour had been unreliable anyway.

Except that it turns out that old behaviour (keep the last component of
victim on normal rename) was relied upon...  That ucking fugly patch
reverts the non-swapping renames to the old behaviour.  I don't like it
any more than you do - it *is* ugly as hell and I still can't swear that
we don't have a bogus codepath leading to d_rehash() of rename() victim
(which would break things very badly with the old behaviour).  Still,
it is a real-world userland regression.

Up to you, but I'm afraid that it's on the "we get to keep supporting that"
side of things.

Anyway, what I've got in vfs.git#for-linus right now seems to survive the
obvious tests so far, still running through full xfstests; please, take
a look at that pile.  The last one should go with you as author - it was
just faster to do the change manually than deal with git-am failure when
applying your patch.  I'll take the headers from your mail and update that
commit before sending the pull request.

Shortlog:
Al Viro (8):
      ufs: deal with nfsd/iget races
      pull rehashing and unlocking the target dentry into __d_materialise_dentry()
      don't open-code d_rehash() in d_materialise_unique()
      __d_move(): fold manipulations with ->d_child/->d_subdirs
      __d_materialise_dentry(): flip the order of arguments
      kill __d_materialise_dentry()
      fold unlocking the children into dentry_unlock_parents_for_move()
      fold swapping ->d_name.hash into switch_names()

Miklos Szeredi (2):
      shmem: fix nlink for rename overwrite directory
      fuse: honour max_read and max_write in direct_io mode

Diffstat:
 fs/dcache.c         |   85 +++++++++++----------------------------------------
 fs/direct-io.c      |    2 +-
 fs/fuse/file.c      |    1 +
 fs/ufs/ialloc.c     |    6 +++-
 fs/ufs/namei.c      |    4 +++
 include/linux/uio.h |    2 +-
 mm/iov_iter.c       |   14 ++++++---
 mm/shmem.c          |    4 ++-
 8 files changed, 42 insertions(+), 76 deletions(-)
