Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050AbaBSJgr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 04:36:47 -0500
Received: from nbl-ex10-fe01.nebula.fi ([188.117.32.121]:56242 "EHLO
	ex10.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751260AbaBSJgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 04:36:45 -0500
Message-ID: <1392802602.32597.2.camel@ultrabook>
Subject: Re: [PATCH] hfsplus: fix concurrent acess of alloc_blocks
From: Sougata Santra <sougata@tuxera.com>
Reply-To: <sougata@tuxera.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Hellwig <hch@lst.de>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Vyacheslav Dubeyko <slava@dubeyko.com>,
        "Joe Perches" <joe@perches.com>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>
Date: Wed, 19 Feb 2014 11:36:42 +0200
In-Reply-To: <20140218140642.fdc6a406f22de69bdf73e66e@linux-foundation.org>
References: <1392639647.29849.11.camel@ultrabook>
	 <20140218140642.fdc6a406f22de69bdf73e66e@linux-foundation.org>
Organization: Tuxera
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [194.100.106.164]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-18 at 14:06 -0800, Andrew Morton wrote:
> On Mon, 17 Feb 2014 14:20:47 +0200 Sougata Santra <sougata@tuxera.com> wrote:
> 
> > 
> > Concurrent access to alloc_blocks in hfsplus_inode_info is
> > protected by extents_lock mutex. This patch fixes two
> > instances where alloc_blocks modification was not protected
> > with this lock. This fixes possible allocation bitmap
> > corruption in race conditions while extending and truncating
> > files.
> > 
> > ...
> >
> > --- a/fs/hfsplus/extents.c
> > +++ b/fs/hfsplus/extents.c
> > @@ -498,11 +498,13 @@ int hfsplus_file_extend(struct inode *inode)
> >  			goto insert_extent;
> >  	}
> >  out:
> > -	mutex_unlock(&hip->extents_lock);
> >  	if (!res) {
> >  		hip->alloc_blocks += len;
> > +		mutex_unlock(&hip->extents_lock);
> >  		hfsplus_mark_inode_dirty(inode, HFSPLUS_I_ALLOC_DIRTY);
> > +		return 0;
> >  	}
> > +	mutex_unlock(&hip->extents_lock);
> >  	return res;
> >  
> 
> This looks OK.
> 
> > @@ -592,9 +594,9 @@ void hfsplus_file_truncate(struct inode *inode)
> >  		hfs_brec_remove(&fd);
> >  	}
> >  	hfs_find_exit(&fd);
> > -	mutex_unlock(&hip->extents_lock);
> >  
> >  	hip->alloc_blocks = blk_cnt;
> > +	mutex_unlock(&hip->extents_lock);
> >  out:
> >  	hip->phys_size = inode->i_size;
> >  	hip->fs_blocks = (inode->i_size + sb->s_blocksize - 1) >>
> 
> But this does not.  To provide locking for
> hfsplus_inode_info.alloc_blocks, we must take the lock *before* taking
> a local copy of ->alloc_blocks.
> 
> Please review:
> 
> --- a/fs/hfsplus/extents.c~hfsplus-fix-concurrent-acess-of-alloc_blocks-fix
> +++ a/fs/hfsplus/extents.c
> @@ -556,11 +556,13 @@ void hfsplus_file_truncate(struct inode
>  
>  	blk_cnt = (inode->i_size + HFSPLUS_SB(sb)->alloc_blksz - 1) >>
>  			HFSPLUS_SB(sb)->alloc_blksz_shift;
> +
> +	mutex_lock(&hip->extents_lock);
> +
>  	alloc_cnt = hip->alloc_blocks;
>  	if (blk_cnt == alloc_cnt)
> -		goto out;
> +		goto out_unlock;
>  
> -	mutex_lock(&hip->extents_lock);
>  	res = hfs_find_init(HFSPLUS_SB(sb)->ext_tree, &fd);
>  	if (res) {
>  		mutex_unlock(&hip->extents_lock);
> @@ -594,6 +596,7 @@ void hfsplus_file_truncate(struct inode
>  	hfs_find_exit(&fd);
>  
>  	hip->alloc_blocks = blk_cnt;
> +out_unlock:
>  	mutex_unlock(&hip->extents_lock);
>  out:
>  	hip->phys_size = inode->i_size;
> _
> 
This is good, Missed it. Thank you.

