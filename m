Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab3HAIMp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 04:12:45 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43334 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab3HAIMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 04:12:38 -0400
Date: Thu, 1 Aug 2013 01:12:35 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, davej@redhat.com, viro@zeniv.linux.org.uk,
        jack@suse.cz, glommer@parallels.com
Subject: Re: [PATCH 02/11] inode: add IOP_NOTHASHED to avoid inode hash lock
 in evict
Message-ID: <20130801081235.GA7261@infradead.org>
References: <1375244150-27296-1-git-send-email-david@fromorbit.com>
 <1375244150-27296-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375244150-27296-3-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 02:15:41PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Some filesystems don't use the VFS inode hash and fake the fact they
> are hashed so that all the writeback code works correctly. However,
> this means the evict() path still tries to remove the inode from the
> hash, meaning that the inode_hash_lock() needs to be taken
> unnecessarily. Hence under certain workloads the inode_hash_lock can
> be contended even if the inode is never actually hashed.
> 
> To avoid this, add an inode opflag to allow inode_hash_remove() to
> avoid taking the hash lock on inodes have never actually been
> hashed.

Good idea, but I don't like how it's implemented.

First a formality: i_opflags really is for flags showing that inode
operations exist, not for addional bits.  Just use i_flags for it.

Second this is a hack hacking around a hack.  We just mark the inode
hashed so that writeback doesn't ignore it, and not we need to work
around the fact that we don't want an inode marked hashed from the
hashlist.

As the most simple version I'd suggest to just add an I_NEEDS_WRITEBACK
flag which gets set by __insert_inode_hash, and all the current users
of hlist_add_fake on i_hash, as well as the block devices that currently
have another special case in the writeback code.

Thinking about it I'm not even sure I_NEEDS_WRITEBACK is needed, no
that we have I_NEW as a marker a negative test for it should be
enough, but doing this might require some further research.

