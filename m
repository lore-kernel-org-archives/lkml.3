Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbaJNAlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 20:41:45 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38102 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837AbaJNAln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 20:41:43 -0400
Date: Tue, 14 Oct 2014 01:41:38 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] dealing with proc_ns_follow_link() and "namespace" dentries
Message-ID: <20141014004138.GY7996@ZenIV.linux.org.uk>
References: <20141013062945.GX7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141013062945.GX7996@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2014 at 07:29:45AM +0100, Al Viro wrote:

> there and get rid of pointless aliases.  Oh, and we get a decent chance to
> kill d_instantiate_unique(), which is also nice.  Or at least fold it into
> d_add_unique(), if we can't kill that sucker as well.  And if we manage to
> kill it outright, we get rid of __d_instantiate_unique() for free - in my
> local queue d_materialise_unique() had been subsumed by d_splice_alias(),
> getting rid of the other caller of __d_instantiate_unique().  We have *WAY*
> too many primitives in that area, and trimming that forest is definitely
> a good thing.

FWIW, looking at that only caller of d_add_unique(), I really think that
it's killable.

Call graph for that sucker is
d_add_unique()
    <- _nfs4_open_and_get_state
	<- _nfs4_do_open
	    <- nfs4_do_open
		<- nfs4_atomic_open
		    = nfs_rpc_ops.open_context
			<- nfs_atomic_open
			    = inode_operations.atomic_open
			<- nfs4_file_open
			    = file_operations.open
		<- nfs4_proc_create
		    = nfs_rpc_ops.create
			<- nfs_creat
			    = inode_operations.create

Now, to have file_operations.open called, we need dentry to be pinned down
and positive.  In that case d_add_unique() isn't called, obviously.

OTOH, inode_operations.create and inode_operations.atomic_open are called
with parent directory having its ->i_mutex held and we have every right to
just do d_splice_alias() in both cases.  IOW, d_add_unique() can be
simply killed, and with aforementioned change to fs/proc/namespaces.c we
can kill d_instantiate_unique() and __d_instantiate_unique() along with it.

OK, that drives the number of primitives further down...  Actually, I suspect
that a bunch of places calling d_add() in their ->lookup() instances should
call d_splice_alias() instead - it won't cost more unless the inode happens
to be a directory with existing aliases.  And to hell with "we should use
d_splice_alias() if it's exportable, no, make it d_materialise_unique() if
tree topology might change unexpectedly, but if neither is true we can just
use d_add() and return NULL" - it's too complicated for no good reason.
"Always use d_splice_alias() in lookups" make a lot more sense...

Oh, and I strongly suspect that d_instantiate() ought to be taught to act
the same way wrt directory aliases (i.e. relocate if one is found).  Which
kills d_instantiate_no_diralias() (only one caller for that one) and closes
very narrow nfsd races in ext2_mkdir() and friends...

We really have too many primitives in that area; in the beginning it was just
d_instantiate() for object creation (when dentry was already hashed) and
d_add() for lookups (when dentry was hashed in addition to being tied to
inode).  It served well for local never-exported filesystems, but once we
added knfsd (and then open-by-fhandle) the variants started to breed like
rabbits.  Filesystems with tree topology that might be silently changed
behind our backs made it only worse...  The real reason why we didn't just
change d_add()/d_instantiate() behaviour back then was that in "the inode
is a directory with existing aliases" case we need to go with another dentry
(after moving it in place of ours), which changes the calling conventions.
OTOH, in that case calling d_add() or d_instantiate() currently means a serious
bug - we end up with multiple aliases for a directory, which should never
happen.  Hell knows, maybe it's feasible to change d_add() and d_instantiate()
calling conventions and really fold all that shit back into them...
