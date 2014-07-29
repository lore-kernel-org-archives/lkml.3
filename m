Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbaG2LaN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 07:30:13 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:36150 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbaG2LaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 07:30:10 -0400
X-AuditID: cbfee61b-f79f86d00000144c-d0-53d785c0df16
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <1406328445-63707-1-git-send-email-jaegeuk@kernel.org>
 <1406328445-63707-2-git-send-email-jaegeuk@kernel.org>
In-reply-to: <1406328445-63707-2-git-send-email-jaegeuk@kernel.org>
Subject: RE: [f2fs-dev] [PATCH 02/11] f2fs: punch the core function for inode
	management
Date: Tue, 29 Jul 2014 19:29:24 +0800
Message-id: <007e01cfab20$7319fd60$594df820$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Content-language: zh-cn
Thread-index: AQH0/sFA7oYZ7Fd/hcfctysO+ZeFcgHFzkCem14SDQA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9jAd0DrdeDDY681Ld4sn4Ws8WlRe4W
	e/aeZLG4vGsOmwOLx6ZVnWweuxd8ZvL4vEkugDmKyyYlNSezLLVI3y6BK+PD6YksBduUKpqu
	zWdtYJwk08XIySEhYCJxaUkDC4QtJnHh3nq2LkYuDiGBRYwSl2bsgnJ+MEr8nH+GFaSKTUBF
	YnnHfyYQW0RATaJ33xQwm1kgU2JC/wt2EFtIoFri6ezrbCA2p4CzRNPHCYwgtrBAlETb3r9g
	c1gEVCX23N7O3MXIwcErYCnx/EEeSJhXQFDix+R7LBAjtSTW7zwONV5eYvOat8wQhypI7Dj7
	mhEiLi6x8cgtFohzrCTm3P7DNoFRaBaSUbOQjJqFZNQsJO0LGFlWMYqmFiQXFCel5xrpFSfm
	Fpfmpesl5+duYgQH/jPpHYyrGiwOMQpwMCrx8G6Yey1YiDWxrLgy9xCjBAezkgjvi/LrwUK8
	KYmVValF+fFFpTmpxYcYpTlYlMR5D7ZaBwoJpCeWpGanphakFsFkmTg4pRoYXV8d6Ply6/GU
	0+djdvhvZJe2Ne+IYj/ncYLb4dS3i7dkvgfOXfJbyOzeWSFLsXqzRUJnhKw9E0I+OZ7W/s65
	2v7Xavcap5MGlyy3PGv4ZrVqOeMJA2v7w1PX3VJS4Ayq79JS+iew9XdXMafX2eMrOc8vODUj
	Mur3w2+SM3k+ci3sUIpe1c2hqsRSnJFoqMVcVJwIAEievN94AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Saturday, July 26, 2014 6:47 AM
> To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Cc: Jaegeuk Kim
> Subject: [f2fs-dev] [PATCH 02/11] f2fs: punch the core function for inode management
> 
> This patch punches out the core functions to manage the inode numbers.
> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

Reviewed-by: Chao Yu <chao2.yu@samsung.com>

> ---
>  fs/f2fs/checkpoint.c | 81 ++++++++++++++++++++++++++++------------------------
>  1 file changed, 44 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
> index 0b4710c..3e3c2c3 100644
> --- a/fs/f2fs/checkpoint.c
> +++ b/fs/f2fs/checkpoint.c
> @@ -282,6 +282,47 @@ const struct address_space_operations f2fs_meta_aops = {
>  	.set_page_dirty	= f2fs_set_meta_page_dirty,
>  };
> 
> +static void __add_ino_entry(struct f2fs_sb_info *sbi, nid_t ino)
> +{
> +	struct list_head *head;
> +	struct ino_entry *new, *e;
> +
> +	new = f2fs_kmem_cache_alloc(orphan_entry_slab, GFP_ATOMIC);
> +	new->ino = ino;
> +
> +	spin_lock(&sbi->orphan_inode_lock);
> +	list_for_each_entry(e, &sbi->orphan_inode_list, list) {
> +		if (e->ino == ino) {
> +			spin_unlock(&sbi->orphan_inode_lock);
> +			kmem_cache_free(orphan_entry_slab, new);
> +			return;
> +		}
> +		if (e->ino > ino)
> +			break;
> +	}
> +
> +	/* add new entry into list which is sorted by inode number */
> +	list_add_tail(&new->list, &e->list);
> +	spin_unlock(&sbi->orphan_inode_lock);
> +}
> +
> +static void __remove_ino_entry(struct f2fs_sb_info *sbi, nid_t ino)
> +{
> +	struct ino_entry *e;
> +
> +	spin_lock(&sbi->orphan_inode_lock);
> +	list_for_each_entry(e, &sbi->orphan_inode_list, list) {
> +		if (e->ino == ino) {
> +			list_del(&e->list);
> +			sbi->n_orphans--;
> +			spin_unlock(&sbi->orphan_inode_lock);
> +			kmem_cache_free(orphan_entry_slab, e);
> +			return;
> +		}
> +	}
> +	spin_unlock(&sbi->orphan_inode_lock);
> +}
> +
>  int acquire_orphan_inode(struct f2fs_sb_info *sbi)
>  {
>  	int err = 0;
> @@ -306,48 +347,14 @@ void release_orphan_inode(struct f2fs_sb_info *sbi)
> 
>  void add_orphan_inode(struct f2fs_sb_info *sbi, nid_t ino)
>  {
> -	struct list_head *head;
> -	struct orphan_inode_entry *new, *orphan;
> -
> -	new = f2fs_kmem_cache_alloc(orphan_entry_slab, GFP_ATOMIC);
> -	new->ino = ino;
> -
> -	spin_lock(&sbi->orphan_inode_lock);
> -	head = &sbi->orphan_inode_list;
> -	list_for_each_entry(orphan, head, list) {
> -		if (orphan->ino == ino) {
> -			spin_unlock(&sbi->orphan_inode_lock);
> -			kmem_cache_free(orphan_entry_slab, new);
> -			return;
> -		}
> -
> -		if (orphan->ino > ino)
> -			break;
> -	}
> -
>  	/* add new orphan entry into list which is sorted by inode number */
> -	list_add_tail(&new->list, &orphan->list);
> -	spin_unlock(&sbi->orphan_inode_lock);
> +	__add_ino_entry(sbi, ino);
>  }
> 
>  void remove_orphan_inode(struct f2fs_sb_info *sbi, nid_t ino)
>  {
> -	struct list_head *head;
> -	struct orphan_inode_entry *orphan;
> -
> -	spin_lock(&sbi->orphan_inode_lock);
> -	head = &sbi->orphan_inode_list;
> -	list_for_each_entry(orphan, head, list) {
> -		if (orphan->ino == ino) {
> -			list_del(&orphan->list);
> -			f2fs_bug_on(sbi->n_orphans == 0);
> -			sbi->n_orphans--;
> -			spin_unlock(&sbi->orphan_inode_lock);
> -			kmem_cache_free(orphan_entry_slab, orphan);
> -			return;
> -		}
> -	}
> -	spin_unlock(&sbi->orphan_inode_lock);
> +	/* remove orphan entry from orphan list */
> +	__remove_ino_entry(sbi, ino);
>  }
> 
>  static void recover_orphan_inode(struct f2fs_sb_info *sbi, nid_t ino)
> --
> 1.8.5.2 (Apple Git-48)
> 
> 
> ------------------------------------------------------------------------------
> Want fast and easy access to all the code in your enterprise? Index and
> search up to 200,000 lines of code with a free copy of Black Duck
> Code Sight - the same software that powers the world's largest code
> search on Ohloh, the Black Duck Open Hub! Try it now.
> http://p.sf.net/sfu/bds
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

