Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626AbaKDRev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 12:34:51 -0500
Received: from mail-qg0-f52.google.com ([209.85.192.52]:46478 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaKDRet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 12:34:49 -0500
Date: Tue, 4 Nov 2014 12:34:43 -0500
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>, Mikulas Patocka <mpatocka@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH block/for-linus] writeback: fix a subtle race condition
 in I_DIRTY clearing
Message-ID: <20141104173443.GF14459@htj.dyndns.org>
References: <20141024193821.GA7453@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141024193821.GA7453@mtj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 03:38:21PM -0400, Tejun Heo wrote:
> After invoking ->dirty_inode(), __mark_inode_dirty() does smp_mb() and
> tests inode->i_state locklessly to see whether it already has all the
> necessary I_DIRTY bits set.  The comment above the barrier doesn't
> contain any useful information - memory barriers can't ensure "changes
> are seen by all cpus" by itself.
> 
> And it sure enough was broken.  Please consider the following
> scenario.
> 
>  CPU 0					CPU 1
>  -------------------------------------------------------------------------------
> 
> 					enters __writeback_single_inode()
> 					grabs inode->i_lock
> 					tests PAGECACHE_TAG_DIRTY which is clear
>  enters __set_page_dirty()
>  grabs mapping->tree_lock
>  sets PAGECACHE_TAG_DIRTY
>  releases mapping->tree_lock
>  leaves __set_page_dirty()
> 
>  enters __mark_inode_dirty()
>  smp_mb()
>  sees I_DIRTY_PAGES set
>  leaves __mark_inode_dirty()
> 					clears I_DIRTY_PAGES
> 					releases inode->i_lock
> 
> Now @inode has dirty pages w/ I_DIRTY_PAGES clear.  This doesn't seem
> to lead to an immediately critical problem because requeue_inode()
> later checks PAGECACHE_TAG_DIRTY instead of I_DIRTY_PAGES when
> deciding whether the inode needs to be requeued for IO and there are
> enough unintentional memory barriers inbetween, so while the inode
> ends up with inconsistent I_DIRTY_PAGES flag, it doesn't fall off the
> IO list.
> 
> The lack of explicit barrier may also theoretically affect the other
> I_DIRTY bits which deal with metadata dirtiness.  There is no
> guarantee that a strong enough barrier exists between
> I_DIRTY_[DATA]SYNC clearing and write_inode() writing out the dirtied
> inode.  Filesystem inode writeout path likely has enough stuff which
> can behave as full barrier but it's theoretically possible that the
> writeout may not see all the updates from ->dirty_inode().
> 
> Fix it by adding an explicit smp_mb() after I_DIRTY clearing.  Note
> that I_DIRTY_PAGES needs a special treatment as it always needs to be
> cleared to be interlocked with the lockless test on
> __mark_inode_dirty() side.  It's cleared unconditionally and
> reinstated after smp_mb() if the mapping still has dirty pages.
> 
> Also add comments explaining how and why the barriers are paired.
> 
> Lightly tested.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Mikulas Patocka <mpatocka@redhat.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: stable@vger.kernel.org

Jens, can you please route this one?

Thanks.

-- 
tejun
