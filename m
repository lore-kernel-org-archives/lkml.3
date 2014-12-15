Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780AbaLOI1W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 03:27:22 -0500
Received: from mail.kernel.org ([198.145.19.201]:36783 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbaLOI1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 03:27:20 -0500
Date: Mon, 15 Dec 2014 00:27:17 -0800
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Chao Yu <chao2.yu@samsung.com>
Cc: Changman Lee <cm224.lee@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [f2fs-dev][PATCH] f2fs: merge two uchar variable in struct
 nat_entry to reduce memory cost
Message-ID: <20141215082717.GA83773@jaegeuk-mac02.mot-mobility.com>
References: <001c01d012b6$a0fbaaa0$e2f2ffe0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001c01d012b6$a0fbaaa0$e2f2ffe0$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chao,

I found a bug in this patch.

In set_node_addr,

 	down_write(&nm_i->nat_tree_lock);
	e = __lookup_nat_cache(nm_i, ni->nid);
	if (!e) {
		e = grab_nat_entry(nm_i, ni->nid);
		e->ni = *ni;
		^^^^^^^^^^^^
		this line should not copy ni.flag.
		
		f2fs_bug_on(sbi, ni->blk_addr == NEW_ADDR);
	} else if (new_blkaddr == NEW_ADDR) {
		/*
		 * when nid is reallocated,
		 * previous nat entry can be remained in nat cache.
		 * So, reinitialize it with new information.
		 */
		e->ni = *ni;
		^^^^^^^^^^^^
		ditto.

		f2fs_bug_on(sbi, ni->blk_addr != NULL_ADDR);
	}

So, please add inline function in node.h like:

static inline void copy_node_info(dst, src)
{
	dst->nid = src->nid;
	dst->ino = src->ino;
	dst->blk_addr = src->blk_addr;
	dst->version = src->version;
	/* should not copy flag here */
}

Then let's use this function.

Thanks,

On Mon, Dec 08, 2014 at 03:13:49PM +0800, Chao Yu wrote:
> This patch moves one member of struct nat_entry: _flag_ to struct node_info,
> so _version_ in struct node_info and _flag_ with unsigned char type will merge
> to one 32-bit space in register/memory. Then the size of nat_entry will reduce
> its size from 28 bytes to 24 bytes and slab memory using by f2fs will be
> reduced.
> 
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> ---
>  fs/f2fs/node.h | 23 ++++++++++++-----------
>  1 file changed, 12 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/f2fs/node.h b/fs/f2fs/node.h
> index d10b644..27a7318 100644
> --- a/fs/f2fs/node.h
> +++ b/fs/f2fs/node.h
> @@ -29,6 +29,14 @@
>  /* return value for read_node_page */
>  #define LOCKED_PAGE	1
>  
> +/* For flag in struct node_info */
> +enum {
> +	IS_CHECKPOINTED,	/* is it checkpointed before? */
> +	HAS_FSYNCED_INODE,	/* is the inode fsynced before? */
> +	HAS_LAST_FSYNC,		/* has the latest node fsync mark? */
> +	IS_DIRTY,		/* this nat entry is dirty? */
> +};
> +
>  /*
>   * For node information
>   */
> @@ -37,18 +45,11 @@ struct node_info {
>  	nid_t ino;		/* inode number of the node's owner */
>  	block_t	blk_addr;	/* block address of the node */
>  	unsigned char version;	/* version of the node */
> -};
> -
> -enum {
> -	IS_CHECKPOINTED,	/* is it checkpointed before? */
> -	HAS_FSYNCED_INODE,	/* is the inode fsynced before? */
> -	HAS_LAST_FSYNC,		/* has the latest node fsync mark? */
> -	IS_DIRTY,		/* this nat entry is dirty? */
> +	unsigned char flag;	/* for node information bits */
>  };
>  
>  struct nat_entry {
>  	struct list_head list;	/* for clean or dirty nat list */
> -	unsigned char flag;	/* for node information bits */
>  	struct node_info ni;	/* in-memory node information */
>  };
>  
> @@ -68,15 +69,15 @@ static inline void set_nat_flag(struct nat_entry *ne,
>  {
>  	unsigned char mask = 0x01 << type;
>  	if (set)
> -		ne->flag |= mask;
> +		ne->ni.flag |= mask;
>  	else
> -		ne->flag &= ~mask;
> +		ne->ni.flag &= ~mask;
>  }
>  
>  static inline bool get_nat_flag(struct nat_entry *ne, unsigned int type)
>  {
>  	unsigned char mask = 0x01 << type;
> -	return ne->flag & mask;
> +	return ne->ni.flag & mask;
>  }
>  
>  static inline void nat_reset_flag(struct nat_entry *ne)
> -- 
> 2.1.2
