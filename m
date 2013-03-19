Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934330Ab3CSVYL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 17:24:11 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47570 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934314Ab3CSVYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 17:24:09 -0400
Date: Tue, 19 Mar 2013 21:24:01 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jan Kara <jack@suse.cz>, David Howells <dhowells@redhat.com>,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu,
        sedat.dilek@googlemail.com, hooanon05@yahoo.co.jp, mszeredi@suse.cz
Subject: Re: [PATCH 2/9] vfs: export do_splice_direct() to modules
Message-ID: <20130319212401.GJ21522@ZenIV.linux.org.uk>
References: <1363184193-1796-3-git-send-email-miklos@szeredi.hu>
 <1363184193-1796-1-git-send-email-miklos@szeredi.hu>
 <1944.1363525619@warthog.procyon.org.uk>
 <20130318153936.GB28508@quack.suse.cz>
 <20130318215333.GE21522@ZenIV.linux.org.uk>
 <20130318230103.GF21522@ZenIV.linux.org.uk>
 <20130319013805.GG21522@ZenIV.linux.org.uk>
 <CAJfpegt8Zi3f5VxWc0kGRFcra3x_rze8j6dKCCTb4t+ViMCVYA@mail.gmail.com>
 <20130319170324.GI21522@ZenIV.linux.org.uk>
 <CAJfpeguXYY4Ldbuq+1YXRhZZ_pPhnRzM=hU1qhK=YqCmzbjXLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpeguXYY4Ldbuq+1YXRhZZ_pPhnRzM=hU1qhK=YqCmzbjXLQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 07:32:42PM +0100, Miklos Szeredi wrote:

> >         * victim is negative => create a whiteout
> >         * victim is a directory, parent opaque => rmdir
> >         * victim is a non-directory, parent opaque => unlink
> >         * victim is positive, parent _not_ opaque => replace with whiteout
> >         * old_dir in case of ->rename() is opaque => normal rename
> >         * old_dir in case of ->rename() is not opaque => leave whiteout behind
> > Non-unioned => opaque, of course (nothing showing through it).
> >
> 
> I dunnow.  Overloading common paths with overlay/union specific things
> doesn't look very clean to me.

We certainly can add a couple of new methods; the question is, would that
buy us anything?  This ->rename_and_whiteout would be practically identical
to ->rename on most of filesystems; the only difference for something like
ext* is that instead of deleting the old directory entry in the end we
would change its inumber to 0 and type to 14.  Everything else would be
the same.  Moreover, turning a positive entry into a whiteout differs from
unlink/rmdir resp. in exactly the same way.  FWIW, creating a whiteout from
scratch might be better off as a separate method - it's closer to ->mknod()
and friends.  But whiteout from positive and whiteout-on-rename probably
isn't worth separating from the normal methods.  All we end up "overloading"
is actual removal of directory entry, which is a rather minor part of the
logics in those.

And merging ->unlink/->rmdir is definitely a good idea, regardless of anything
union-related; just look at the existing instances of both.

> > Getting good behaviour on rename interrupted by crash is going to be _very_
> > tricky with any strategy other than whiteouts-in-fs, AFAICS.
> >
> 
> One idea is to add a journal to the overlay itself (yeah, namespace issues).

... and extra complexity from hell.  If the underlying fs has a journal of
its own, we are getting all kinds of interesting interplay between those;
if not, replaying the journal in overlay will buy you nothing, since the
damage to underlying objects makes it all moot.

Layering is a very nice tool for quick prototyping; no arguments about that.
It allows to avoid modifying $BIGNUM filesystems and for something that
lives out of tree it's a very big benefit.  Once the thing is merged, though,
that benefit becomes much smaller; it still might make sense to implement
something as a layer, but some parts of that sucker may be better off as
fs primitives.  Hell, we could, in theory, implement xattrs as a layer;
just look at how reiserfs had done them.  We could do the same for hardlinks
(look at qnx4, if you wish to see that hack).  Of for symlinks (sysvfs).
Or for opened-and-unlinked files (sillyrename could be done as a generic
layer).  Or for permissions/ownership/arbitrary names (umsdos, and that
_was_ very similar to layering).  It's just that often an underlying fs
has a better way of doing that.  IMO whiteouts are in that class.
