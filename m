Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbaG2Lc5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 07:32:57 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:36472 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947AbaG2Lc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 07:32:56 -0400
X-AuditID: cbfee61a-f79e46d00000134f-37-53d78666e553
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <1406328445-63707-1-git-send-email-jaegeuk@kernel.org>
 <1406328445-63707-4-git-send-email-jaegeuk@kernel.org>
In-reply-to: <1406328445-63707-4-git-send-email-jaegeuk@kernel.org>
Subject: RE: [f2fs-dev] [PATCH 04/11] f2fs: use radix_tree for ino management
Date: Tue, 29 Jul 2014 19:32:08 +0800
Message-id: <008001cfab20$d5e6ce50$81b46af0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Content-language: zh-cn
Thread-index: AQH0/sFA7oYZ7Fd/hcfctysO+ZeFcgLB2M6cm1YjIUA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9jQd20tuvBBrMfKlo8WT+L2eLSIneL
	PXtPslhc3jWHzYHFY9OqTjaP3Qs+M3l83iQXwBzFZZOSmpNZllqkb5fAlTGzL7ngrXLFpL0/
	mRsYm2W7GDk5JARMJB40X2aCsMUkLtxbz9bFyMUhJDCdUWLS7eNMEM4PRolraxsYQarYBFQk
	lnf8B+sQEVCT6N03BcxmFsiUmND/gh3EFhKoltg5+y0ziM0p4CxxfuJXsLiwgK/Eh1/HweIs
	AqoSR24/ApvJK2Ap8f/3PjYIW1Dix+R7LBAztSTW7zwONV9eYvMaiJkSAgoSO86+ZoSIi0ts
	PHKLBeIeK4n2z7dZJjAKzUIyahaSUbOQjJqFpH0BI8sqRtHUguSC4qT0XEO94sTc4tK8dL3k
	/NxNjODAfya1g3Flg8UhRgEORiUe3g1zrwULsSaWFVfmHmKU4GBWEuF9UX49WIg3JbGyKrUo
	P76oNCe1+BCjNAeLkjjvgVbrQCGB9MSS1OzU1ILUIpgsEwenVAPjdqWslls6kgdig++qc37y
	TktvPJR9t/Rpwc0K3lOmi5j6j/7+wrRvKnOGxZYvfeq7s/47i/n/23CO8XtwQXf0xpBZzdvu
	PwjzerPd1tyhhP0cl0hDHdO3Hc0Cv2dIC2Vf2LGnRvlKi8Fk/+1X0s6p90/Vjwyav/rz89dX
	Im+z2h9YVT/5zf92JZbijERDLeai4kQA101aRXgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

One comment as following.

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Saturday, July 26, 2014 6:47 AM
> To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Cc: Jaegeuk Kim
> Subject: [f2fs-dev] [PATCH 04/11] f2fs: use radix_tree for ino management
> 
> For better ino management, this patch replaces the data structure from list
> to radix tree.
> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

Reviewed-by: Chao Yu <chao2.yu@samsung.com>

> ---
>  fs/f2fs/checkpoint.c | 48 ++++++++++++++++++++++++++----------------------
>  fs/f2fs/f2fs.h       |  1 +
>  2 files changed, 27 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
> index f93d154..d35094a 100644
> --- a/fs/f2fs/checkpoint.c
> +++ b/fs/f2fs/checkpoint.c
> @@ -284,24 +284,26 @@ const struct address_space_operations f2fs_meta_aops = {
> 
>  static void __add_ino_entry(struct f2fs_sb_info *sbi, nid_t ino, int type)
>  {
> -	struct ino_entry *new, *e;
> -
> -	new = f2fs_kmem_cache_alloc(ino_entry_slab, GFP_ATOMIC);
> -	new->ino = ino;
> -
> +	struct ino_entry *e;
> +retry:
>  	spin_lock(&sbi->ino_lock[type]);
> -	list_for_each_entry(e, &sbi->ino_list[type], list) {
> -		if (e->ino == ino) {
> +
> +	e = radix_tree_lookup(&sbi->ino_root[type], ino);
> +	if (!e) {
> +		e = kmem_cache_alloc(ino_entry_slab, GFP_ATOMIC);
> +		if (!e) {
>  			spin_unlock(&sbi->ino_lock[type]);
> -			kmem_cache_free(ino_entry_slab, new);
> -			return;
> +			goto retry;
>  		}
> -		if (e->ino > ino)
> -			break;
> -	}
> +		if (radix_tree_insert(&sbi->ino_root[type], ino, e)) {
> +			spin_unlock(&sbi->ino_lock[type]);

we should add kmem_cache_free(ino_entry_slab, e) here to avoid memory leak.

> +			goto retry;
> +		}
> +		memset(e, 0, sizeof(struct ino_entry));
> +		e->ino = ino;
> 
> -	/* add new entry into list which is sorted by inode number */
> -	list_add_tail(&new->list, &e->list);
> +		list_add_tail(&e->list, &sbi->ino_list[type]);
> +	}
>  	spin_unlock(&sbi->ino_lock[type]);
>  }
> 
> @@ -310,14 +312,15 @@ static void __remove_ino_entry(struct f2fs_sb_info *sbi, nid_t ino, int
> type)
>  	struct ino_entry *e;
> 
>  	spin_lock(&sbi->ino_lock[type]);
> -	list_for_each_entry(e, &sbi->ino_list[type], list) {
> -		if (e->ino == ino) {
> -			list_del(&e->list);
> +	e = radix_tree_lookup(&sbi->ino_root[type], ino);
> +	if (e) {
> +		list_del(&e->list);
> +		radix_tree_delete(&sbi->ino_root[type], ino);
> +		if (type == ORPHAN_INO)
>  			sbi->n_orphans--;
> -			spin_unlock(&sbi->ino_lock[type]);
> -			kmem_cache_free(ino_entry_slab, e);
> -			return;
> -		}
> +		spin_unlock(&sbi->ino_lock[type]);
> +		kmem_cache_free(ino_entry_slab, e);
> +		return;
>  	}
>  	spin_unlock(&sbi->ino_lock[type]);
>  }
> @@ -346,7 +349,7 @@ void release_orphan_inode(struct f2fs_sb_info *sbi)
> 
>  void add_orphan_inode(struct f2fs_sb_info *sbi, nid_t ino)
>  {
> -	/* add new orphan entry into list which is sorted by inode number */
> +	/* add new orphan ino entry into list */
>  	__add_ino_entry(sbi, ino, ORPHAN_INO);
>  }
> 
> @@ -943,6 +946,7 @@ void init_ino_entry_info(struct f2fs_sb_info *sbi)
>  	int i;
> 
>  	for (i = 0; i < MAX_INO_ENTRY; i++) {
> +		INIT_RADIX_TREE(&sbi->ino_root[i], GFP_ATOMIC);
>  		spin_lock_init(&sbi->ino_lock[i]);
>  		INIT_LIST_HEAD(&sbi->ino_list[i]);
>  	}
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index b6fa6ec..4454caa 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -456,6 +456,7 @@ struct f2fs_sb_info {
>  	wait_queue_head_t cp_wait;
> 
>  	/* for inode management */
> +	struct radix_tree_root ino_root[MAX_INO_ENTRY];	/* ino entry array */
>  	spinlock_t ino_lock[MAX_INO_ENTRY];		/* for ino entry lock */
>  	struct list_head ino_list[MAX_INO_ENTRY];	/* inode list head */
> 
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

