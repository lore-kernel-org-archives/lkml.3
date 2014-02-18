Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbaBRWGp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:06:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50350 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbaBRWGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:06:43 -0500
Date: Tue, 18 Feb 2014 14:06:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: <sougata@tuxera.com>
Cc: Christoph Hellwig <hch@lst.de>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Vyacheslav Dubeyko <slava@dubeyko.com>,
        "Joe Perches" <joe@perches.com>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: Re: [PATCH] hfsplus: fix concurrent acess of alloc_blocks
Message-Id: <20140218140642.fdc6a406f22de69bdf73e66e@linux-foundation.org>
In-Reply-To: <1392639647.29849.11.camel@ultrabook>
References: <1392639647.29849.11.camel@ultrabook>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Feb 2014 14:20:47 +0200 Sougata Santra <sougata@tuxera.com> wrote:

> 
> Concurrent access to alloc_blocks in hfsplus_inode_info is
> protected by extents_lock mutex. This patch fixes two
> instances where alloc_blocks modification was not protected
> with this lock. This fixes possible allocation bitmap
> corruption in race conditions while extending and truncating
> files.
> 
> ...
>
> --- a/fs/hfsplus/extents.c
> +++ b/fs/hfsplus/extents.c
> @@ -498,11 +498,13 @@ int hfsplus_file_extend(struct inode *inode)
>  			goto insert_extent;
>  	}
>  out:
> -	mutex_unlock(&hip->extents_lock);
>  	if (!res) {
>  		hip->alloc_blocks += len;
> +		mutex_unlock(&hip->extents_lock);
>  		hfsplus_mark_inode_dirty(inode, HFSPLUS_I_ALLOC_DIRTY);
> +		return 0;
>  	}
> +	mutex_unlock(&hip->extents_lock);
>  	return res;
>  

This looks OK.

> @@ -592,9 +594,9 @@ void hfsplus_file_truncate(struct inode *inode)
>  		hfs_brec_remove(&fd);
>  	}
>  	hfs_find_exit(&fd);
> -	mutex_unlock(&hip->extents_lock);
>  
>  	hip->alloc_blocks = blk_cnt;
> +	mutex_unlock(&hip->extents_lock);
>  out:
>  	hip->phys_size = inode->i_size;
>  	hip->fs_blocks = (inode->i_size + sb->s_blocksize - 1) >>

But this does not.  To provide locking for
hfsplus_inode_info.alloc_blocks, we must take the lock *before* taking
a local copy of ->alloc_blocks.

Please review:

--- a/fs/hfsplus/extents.c~hfsplus-fix-concurrent-acess-of-alloc_blocks-fix
+++ a/fs/hfsplus/extents.c
@@ -556,11 +556,13 @@ void hfsplus_file_truncate(struct inode
 
 	blk_cnt = (inode->i_size + HFSPLUS_SB(sb)->alloc_blksz - 1) >>
 			HFSPLUS_SB(sb)->alloc_blksz_shift;
+
+	mutex_lock(&hip->extents_lock);
+
 	alloc_cnt = hip->alloc_blocks;
 	if (blk_cnt == alloc_cnt)
-		goto out;
+		goto out_unlock;
 
-	mutex_lock(&hip->extents_lock);
 	res = hfs_find_init(HFSPLUS_SB(sb)->ext_tree, &fd);
 	if (res) {
 		mutex_unlock(&hip->extents_lock);
@@ -594,6 +596,7 @@ void hfsplus_file_truncate(struct inode
 	hfs_find_exit(&fd);
 
 	hip->alloc_blocks = blk_cnt;
+out_unlock:
 	mutex_unlock(&hip->extents_lock);
 out:
 	hip->phys_size = inode->i_size;
_

