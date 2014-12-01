Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710AbaLAWJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 17:09:20 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:35643 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932679AbaLAWJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 17:09:01 -0500
Date: Tue, 02 Dec 2014 07:08:55 +0900 (JST)
Message-Id: <20141202.070855.1111026133315369925.konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
        Andreas Rohner <andreas.rohner@gmx.net>
Subject: Re: [PATCH 1/3] nilfs2: avoid duplicate segment construction for
 fsync()
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <1417452107-6411-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1417452107-6411-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<1417452107-6411-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  2 Dec 2014 01:41:45 +0900, Ryusuke Konishi wrote:
> From: Andreas Rohner <andreas.rohner@gmx.net>
> 
> This patch removes filemap_write_and_wait_range() from
> nilfs_sync_file(), because it triggers a data segment construction by
> calling nilfs_writepages() with WB_SYNC_ALL. A data segment construction
> does not remove the inode from the i_dirty list and it does not clear
> the NILFS_I_DIRTY flag. Therefore nilfs_inode_dirty() still returns
> true, which leads to an unnecessary duplicate segment construction in
> nilfs_sync_file().
<snip>
> diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
> index e9e3325..1ad6bdf 100644
> --- a/fs/nilfs2/file.c
> +++ b/fs/nilfs2/file.c
> @@ -41,19 +41,14 @@ int nilfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
>  	struct inode *inode = file->f_mapping->host;
>  	int err;
>  
> -	err = filemap_write_and_wait_range(inode->i_mapping, start, end);
> -	if (err)
> -		return err;
> -	mutex_lock(&inode->i_mutex);
> -
> -	if (nilfs_inode_dirty(inode)) {
> -		if (datasync)
> -			err = nilfs_construct_dsync_segment(inode->i_sb, inode,
> -							    0, LLONG_MAX);
> -		else
> -			err = nilfs_construct_segment(inode->i_sb);
> -	}
> -	mutex_unlock(&inode->i_mutex);
> +	if (!nilfs_inode_dirty(inode))
> +		return 0;
> +
> +	if (datasync)
> +		err = nilfs_construct_dsync_segment(inode->i_sb, inode,
> +						    start, end);
> +	else
> +		err = nilfs_construct_segment(inode->i_sb);
>  
>  	nilfs = inode->i_sb->s_fs_info;
>  	if (!err)

I found this patch introduces another data integrity issue.  If
nilfs_inode_dirty() is not true, it returns without calling
nilfs_flush_device() and skips a disk cache flush.

Andreas made a revised patch to correct it.

Could you apply the following one instead ?

Regards,
Ryusuke Konishi
-----
From: Andreas Rohner <andreas.rohner@gmx.net>
Date: Mon, 1 Dec 2014 19:03:11 +0100
Subject: [PATCH] nilfs2: avoid duplicate segment construction for fsync()

This patch removes filemap_write_and_wait_range() from
nilfs_sync_file(), because it triggers a data segment construction by
calling nilfs_writepages() with WB_SYNC_ALL. A data segment construction
does not remove the inode from the i_dirty list and it does not clear
the NILFS_I_DIRTY flag. Therefore nilfs_inode_dirty() still returns
true, which leads to an unnecessary duplicate segment construction in
nilfs_sync_file().

A call to filemap_write_and_wait_range() is not needed, because NILFS2
does not rely on the generic writeback mechanisms. Instead it implements
its own mechanism to collect all dirty pages and write them into
segments. It is more efficient to initiate the segment construction
directly in nilfs_sync_file() without the detour over
filemap_write_and_wait_range().

Additionally the lock of i_mutex is not needed, because all code blocks
that are protected by i_mutex are also protected by a NILFS transaction:

Function                i_mutex     nilfs_transaction
------------------------------------------------------
nilfs_ioctl_setflags:   yes         yes
nilfs_fiemap:           yes         no
nilfs_write_begin:      yes         yes
nilfs_write_end:        yes         yes
nilfs_lookup:           yes         no
nilfs_create:           yes         yes
nilfs_link:             yes         yes
nilfs_mknod:            yes         yes
nilfs_symlink:          yes         yes
nilfs_mkdir:            yes         yes
nilfs_unlink:           yes         yes
nilfs_rmdir:            yes         yes
nilfs_rename:           yes         yes
nilfs_setattr:          yes         yes

For nilfs_lookup() i_mutex is held for the parent directory, to protect
it from modification. The segment construction does not modify directory
inodes, so no lock is needed.

nilfs_fiemap() reads the block layout on the disk, by using
nilfs_bmap_lookup_contig(). This is already protected by bmap->b_sem.

Signed-off-by: Andreas Rohner <andreas.rohner@gmx.net>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/file.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
index e9e3325..3a03e0a 100644
--- a/fs/nilfs2/file.c
+++ b/fs/nilfs2/file.c
@@ -39,21 +39,15 @@ int nilfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	 */
 	struct the_nilfs *nilfs;
 	struct inode *inode = file->f_mapping->host;
-	int err;
-
-	err = filemap_write_and_wait_range(inode->i_mapping, start, end);
-	if (err)
-		return err;
-	mutex_lock(&inode->i_mutex);
+	int err = 0;
 
 	if (nilfs_inode_dirty(inode)) {
 		if (datasync)
 			err = nilfs_construct_dsync_segment(inode->i_sb, inode,
-							    0, LLONG_MAX);
+							    start, end);
 		else
 			err = nilfs_construct_segment(inode->i_sb);
 	}
-	mutex_unlock(&inode->i_mutex);
 
 	nilfs = inode->i_sb->s_fs_info;
 	if (!err)
-- 
1.8.3.1


