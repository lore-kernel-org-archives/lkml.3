Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab3JVCtF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 22:49:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:22023 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560Ab3JVCtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 22:49:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,544,1378882800"; 
   d="scan'208";a="420494552"
Date: Tue, 22 Oct 2013 10:45:48 +0800
From: Haicheng Li <haicheng.li@linux.intel.com>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Kim <jaegeuk.kim@samsung.com>,
        f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] f2fs: introduce f2fs_kmem_cache_alloc to hide the
 unfailed kmem cache allocation
Message-ID: <20131022024548.GA19268@hli22-desktop>
References: <5264D6C7.9000202@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5264D6C7.9000202@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks neat.

Reviewed-by: Haicheng Li <haicheng.li@linux.intel.com>

On Mon, Oct 21, 2013 at 03:24:55PM +0800, Gu Zheng wrote:
> Introduce the unfailed version of kmem_cache_alloc named f2fs_kmem_cache_alloc
> to hide the retry routine and make the code a bit cleaner.
> 
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> ---
>  fs/f2fs/checkpoint.c |   26 +++++++-------------------
>  fs/f2fs/f2fs.h       |   13 +++++++++++++
>  fs/f2fs/gc.c         |    8 ++------
>  fs/f2fs/node.c       |    6 +-----
>  4 files changed, 23 insertions(+), 30 deletions(-)
> 
> diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
> index 8d16071..6fb484c 100644
> --- a/fs/f2fs/checkpoint.c
> +++ b/fs/f2fs/checkpoint.c
> @@ -226,12 +226,8 @@ void add_orphan_inode(struct f2fs_sb_info *sbi, nid_t ino)
>  			break;
>  		orphan = NULL;
>  	}
> -retry:
> -	new = kmem_cache_alloc(orphan_entry_slab, GFP_ATOMIC);
> -	if (!new) {
> -		cond_resched();
> -		goto retry;
> -	}
> +
> +	new = f2fs_kmem_cache_alloc(orphan_entry_slab, GFP_ATOMIC);
>  	new->ino = ino;
>  
>  	/* add new_oentry into list which is sorted by inode number */
> @@ -484,12 +480,8 @@ void set_dirty_dir_page(struct inode *inode, struct page *page)
>  
>  	if (!S_ISDIR(inode->i_mode))
>  		return;
> -retry:
> -	new = kmem_cache_alloc(inode_entry_slab, GFP_NOFS);
> -	if (!new) {
> -		cond_resched();
> -		goto retry;
> -	}
> +
> +	new = f2fs_kmem_cache_alloc(inode_entry_slab, GFP_NOFS);
>  	new->inode = inode;
>  	INIT_LIST_HEAD(&new->list);
>  
> @@ -506,13 +498,9 @@ retry:
>  void add_dirty_dir_inode(struct inode *inode)
>  {
>  	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
> -	struct dir_inode_entry *new;
> -retry:
> -	new = kmem_cache_alloc(inode_entry_slab, GFP_NOFS);
> -	if (!new) {
> -		cond_resched();
> -		goto retry;
> -	}
> +	struct dir_inode_entry *new =
> +			f2fs_kmem_cache_alloc(inode_entry_slab, GFP_NOFS);
> +
>  	new->inode = inode;
>  	INIT_LIST_HEAD(&new->list);
>  
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index 171c52f..fa9ad03 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -787,6 +787,19 @@ static inline struct kmem_cache *f2fs_kmem_cache_create(const char *name,
>  	return kmem_cache_create(name, size, 0, SLAB_RECLAIM_ACCOUNT, ctor);
>  }
>  
> +static inline void *f2fs_kmem_cache_alloc(struct kmem_cache *cachep,
> +						gfp_t flags)
> +{
> +	void *entry = kmem_cache_alloc(cachep, flags);
> +retry:
> +	if (!entry) {
> +		cond_resched();
> +		goto retry;
> +	}
> +
> +	return entry;
> +}
> +
>  #define RAW_IS_INODE(p)	((p)->footer.nid == (p)->footer.ino)
>  
>  static inline bool IS_INODE(struct page *page)
> diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
> index fbad968..7914b92 100644
> --- a/fs/f2fs/gc.c
> +++ b/fs/f2fs/gc.c
> @@ -361,12 +361,8 @@ static void add_gc_inode(struct inode *inode, struct list_head *ilist)
>  		iput(inode);
>  		return;
>  	}
> -repeat:
> -	new_ie = kmem_cache_alloc(winode_slab, GFP_NOFS);
> -	if (!new_ie) {
> -		cond_resched();
> -		goto repeat;
> -	}
> +
> +	new_ie = f2fs_kmem_cache_alloc(winode_slab, GFP_NOFS);
>  	new_ie->inode = inode;
>  	list_add_tail(&new_ie->list, ilist);
>  }
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index ef80f79..fe3cf8e 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -1308,11 +1308,7 @@ static int add_free_nid(struct f2fs_nm_info *nm_i, nid_t nid, bool build)
>  	if (allocated)
>  		return 0;
>  retry:
> -	i = kmem_cache_alloc(free_nid_slab, GFP_NOFS);
> -	if (!i) {
> -		cond_resched();
> -		goto retry;
> -	}
> +	i = f2fs_kmem_cache_alloc(free_nid_slab, GFP_NOFS);
>  	i->nid = nid;
>  	i->state = NID_NEW;
>  
> -- 
> 1.7.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
