Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab3HBBLh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 21:11:37 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:9672 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751022Ab3HBBLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 21:11:36 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgEFAH0G+1F5LPxHgWdsb2JhbABbhjK2d4UwgRsXDgEBFiYogiQBAQIDOhwjEAgDDgcDCSUPBSUDIROID7o7Fo9xB4QMA5deiiOKVSo
Date: Fri, 2 Aug 2013 11:11:33 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, davej@redhat.com, viro@zeniv.linux.org.uk,
        jack@suse.cz, glommer@parallels.com
Subject: Re: [PATCH 02/11] inode: add IOP_NOTHASHED to avoid inode hash lock
 in evict
Message-ID: <20130802011133.GT7118@dastard>
References: <1375244150-27296-1-git-send-email-david@fromorbit.com>
 <1375244150-27296-3-git-send-email-david@fromorbit.com>
 <20130801081235.GA7261@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130801081235.GA7261@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 01:12:35AM -0700, Christoph Hellwig wrote:
> On Wed, Jul 31, 2013 at 02:15:41PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Some filesystems don't use the VFS inode hash and fake the fact they
> > are hashed so that all the writeback code works correctly. However,
> > this means the evict() path still tries to remove the inode from the
> > hash, meaning that the inode_hash_lock() needs to be taken
> > unnecessarily. Hence under certain workloads the inode_hash_lock can
> > be contended even if the inode is never actually hashed.
> > 
> > To avoid this, add an inode opflag to allow inode_hash_remove() to
> > avoid taking the hash lock on inodes have never actually been
> > hashed.
> 
> Good idea, but I don't like how it's implemented.
> 
> First a formality: i_opflags really is for flags showing that inode
> operations exist, not for addional bits.  Just use i_flags for it.
> 
> Second this is a hack hacking around a hack.  We just mark the inode
> hashed so that writeback doesn't ignore it, and not we need to work
> around the fact that we don't want an inode marked hashed from the
> hashlist.
> 
> As the most simple version I'd suggest to just add an I_NEEDS_WRITEBACK
> flag which gets set by __insert_inode_hash, and all the current users
> of hlist_add_fake on i_hash, as well as the block devices that currently
> have another special case in the writeback code.

But that doesn't fix the problem of taking the hash lock in evict()
when it is not necessary. If everything sets I_NEEDS_WRITEBACK, and
we still fake hashing the inode, how are do we know that we don't
need to unhash it in evict()?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
