Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536AbaK2KIr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 05:08:47 -0500
Received: from smtp2-g21.free.fr ([212.27.42.2]:28605 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbaK2KIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 05:08:45 -0500
Date: Sat, 29 Nov 2014 11:08:33 +0100
From: Sabrina Dubroca <sd@queasysnail.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jens Axboe <axboe@kernel.dk>, "Theodore Ts'o" <tytso@mit.edu>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Jeremiah Mahler <jmmahler@gmail.com>
Subject: Re: linux-next: manual merge of the block tree with the ext4 tree
Message-ID: <20141129100833.GA31892@kria>
References: <20141127145347.0083c0bc@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141127145347.0083c0bc@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

[adding Jeremiah Mahler to CC]

2014-11-27, 14:53:47 +1100, Stephen Rothwell wrote:
> Hi Jens,
> 
> Today's linux-next merge of the block tree got a conflict in
> fs/fs-writeback.c between commit ef7fdf5e8c87 ("vfs: add support for a
> lazytime mount option") from the ext4 tree and commit 9c6ac78eb352
> ("writeback: fix a subtle race condition in I_DIRTY clearing") from the
> block tree.
> 
> I fixed it up (I took a guess, plese check - see below) and can carry
> the fix as necessary (no action is required).
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc fs/fs-writeback.c
> index 3d87174408ae,2d609a5fbfea..000000000000
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@@ -482,14 -479,30 +482,30 @@@ __writeback_single_inode(struct inode *
>   	 * write_inode()
>   	 */
>   	spin_lock(&inode->i_lock);
> - 	/* Clear I_DIRTY_PAGES if we've written out all dirty pages */
> - 	if (!mapping_tagged(mapping, PAGECACHE_TAG_DIRTY))
> - 		inode->i_state &= ~I_DIRTY_PAGES;
> + 
>  -	dirty = inode->i_state & I_DIRTY;
>  -	inode->i_state &= ~I_DIRTY;
>  +	dirty = inode->i_state & I_DIRTY_INODE;
>  +	inode->i_state &= ~I_DIRTY_INODE;
> + 
> + 	/*
> + 	 * Paired with smp_mb() in __mark_inode_dirty().  This allows
> + 	 * __mark_inode_dirty() to test i_state without grabbing i_lock -
> + 	 * either they see the I_DIRTY bits cleared or we see the dirtied
> + 	 * inode.
> + 	 *
> + 	 * I_DIRTY_PAGES is always cleared together above even if @mapping
> + 	 * still has dirty pages.  The flag is reinstated after smp_mb() if
> + 	 * necessary.  This guarantees that either __mark_inode_dirty()
> + 	 * sees clear I_DIRTY_PAGES or we see PAGECACHE_TAG_DIRTY.
> + 	 */
> + 	smp_mb();
> + 
> + 	if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY))
> + 		inode->i_state |= I_DIRTY_PAGES;
> + 
>   	spin_unlock(&inode->i_lock);
> + 
>   	/* Don't write the inode if only I_DIRTY_PAGES was set */
>  -	if (dirty & (I_DIRTY_SYNC | I_DIRTY_DATASYNC)) {
>  +	if (dirty) {
>   		int err = write_inode(inode, wbc);
>   		if (ret == 0)
>   			ret = err;


I think there's a problem in your fix, Stephen.

I'm getting hangs at boot (strangely -- in QEMU -- only when booting
via grub, not when using -kernel) and during shutdown.  Jeremiah seems
to have the same problem and his bisection led to the merge commit:
https://lkml.org/lkml/2014/11/29/17

The following solves both issues for me.  I think it makes sense given
the #defines from ef7fdf5e8c87, since Tejun intended to clear
I_DIRTY_PAGES.


diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index b70e45f45afa..6b2510d97a0a 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -484,7 +484,7 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 	spin_lock(&inode->i_lock);
 
 	dirty = inode->i_state & I_DIRTY_INODE;
-	inode->i_state &= ~I_DIRTY_INODE;
+	inode->i_state &= ~I_DIRTY;
 
 	/*
 	 * Paired with smp_mb() in __mark_inode_dirty().  This allows


-- 
Thanks,
Sabrina
