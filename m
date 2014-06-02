Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656AbaFBDaw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 23:30:52 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:28476 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753871AbaFBDau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 23:30:50 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmB3AJfui1N5LL1sPGdsb2JhbABZgweDRagQAQEBAQEBBpgbAYEPFwMBAQEBODWCJQEBBAEnExwjBQsIAxgJJQ8FJQMHGhOIOgfUEhcWhT+IfQeEQASZf5Z4Kw
Date: Mon, 2 Jun 2014 13:30:47 +1000
From: Dave Chinner <david@fromorbit.com>
To: Daniel Phillips <daniel@phunq.net>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [RFC][PATCH 2/2] tux3: Use writeback hook to remove duplicated
 core code
Message-ID: <20140602033047.GT14410@dastard>
References: <538B9DEE.20800@phunq.net>
 <538B9E58.4000108@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538B9E58.4000108@phunq.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 01, 2014 at 02:42:48PM -0700, Daniel Phillips wrote:
> Instead of re-implementing part of fs/fs-writeback.c, use a proposed
> net ->writeback super operation to drive delta writeback. For each
> inode that is cleaned, call inode_writeback_done(inode). For each
> inode that will be kept dirty in cache, call inode_writeback_touch
> so that the inode appears young to fs-writeback and does not trigger
> repeated ->writeback flushes.
> 
> Signed-off-by: Daniel Phillips <daniel@tux3.org>

I have not looked at the sanity of the tux3 writeback algorithm, so
I'm not commenting on whether it works or not. However, this caught
my eye:

>  static void __tux3_clear_dirty_inode(struct inode *inode, unsigned delta)
>  {
>      struct tux3_inode *tuxnode = tux_inode(inode);
> -    tux3_inode_wb_lock(inode);
>      spin_lock(&inode->i_lock);
>      spin_lock(&tuxnode->lock);
>      tux3_clear_dirty_inode_nolock(inode, delta, 0);
>      spin_unlock(&tuxnode->lock);
>      spin_unlock(&inode->i_lock);
> -    tux3_inode_wb_unlock(inode);
> +    inode_writeback_done(inode);
>  }

I get very worried whenever I see locks inside inode->i_lock. In
general, i_lock is supposed to be the innermost lock that is taken,
and there are very few exceptions to that - the inode LRU list is
one of the few.

I don't know what the tuxnode->lock is, but I found this:

 *     inode->i_lock
 *         tuxnode->lock (to protect tuxnode data)
 *             tuxnode->dirty_inodes_lock (for i_ddc->dirty_inodes,
 *                                         Note: timestamp can be updated
 *                                         outside inode->i_mutex)

and this:

 *     inode->i_lock
 *         tuxnode->lock
 *         sb->dirty_inodes_lock

Which indicates that you take a filesystem global lock a couple of
layers underneath the VFS per-inode i_lock. I'd suggest you want to
separate the use of the vfs inode ilock from the locking heirarchy
of the tux3 inode....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
