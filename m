Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbaIVJYO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 05:24:14 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:33833 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbaIVJYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 05:24:12 -0400
X-AuditID: cbfee61b-f79d76d0000024d6-eb-541feabbde1b
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: RE: [f2fs-dev] [PATCH 08/10] f2fs: remove redundant operation during
	roll-forward recovery
Date: Mon, 22 Sep 2014 17:22:27 +0800
Message-id: <006101cfd646$f53771a0$dfa654e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac/WRrGc+BYNytFlTcqPpJC6qlHO0w==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t9jAd3dr+RDDPYc47R4sn4Ws8WlRe4W
	e/aeZLG4vGsOmwOLx6ZVnWweuxd8ZvL4vEkugDmKyyYlNSezLLVI3y6BK+N/93bmgpmaFc13
	axsYJyp2MXJySAiYSHzc8YoRwhaTuHBvPVsXIxeHkMAiRonW27fBEkICPxglvk5RALHZBFQk
	lnf8ZwKxRQTUJHr3TQGzmQUyJSb0v2AHsYUFUiXurD4F1ssioCpx8vZcVhCbV8BS4vq7pYwQ
	tqDEj8n3WCB6tSTW7zwONUdeYvOat8wQBylI7Dj7mhFil57EibXr2SFqxCU2HrnFMoFRYBaS
	UbOQjJqFZNQsJC0LGFlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgSH8TPpHYyrGiwOMQpw
	MCrx8P5okQ8RYk0sK67MPcQowcGsJML79DlQiDclsbIqtSg/vqg0J7X4EKM0B4uSOO/BVutA
	IYH0xJLU7NTUgtQimCwTB6dUAyPD1oeykluzrFj8lszVy27edDleasH57OOzNn16X/pimcxH
	jv9eE5XPFcg03ng00d17w87qitWW1cXLNoj0hZxrWSt5f1rax4VWMwrt1sxyS+Q0fHNx17z7
	zvVNT38/r4sUaV55s2iKVZ1Q+uyZB+6sr4hKkfJi/Hae98PS4mwXkQIj9gAPzZlKLMUZiYZa
	zEXFiQDU65W8XwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Monday, September 15, 2014 6:14 AM
> To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Cc: Jaegeuk Kim
> Subject: [f2fs-dev] [PATCH 08/10] f2fs: remove redundant operation during roll-forward recovery
> 
> If same data is updated multiple times, we don't need to redo whole the
> operations.
> Let's just update the lastest one.

Reviewed-by: Chao Yu <chao2.yu@samsung.com>

And one comment as following.

> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
>  fs/f2fs/f2fs.h     |  4 +++-
>  fs/f2fs/recovery.c | 41 +++++++++++++++++------------------------
>  2 files changed, 20 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index 48d7d46..74dde99 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -137,7 +137,9 @@ struct discard_entry {
>  struct fsync_inode_entry {
>  	struct list_head list;	/* list head */
>  	struct inode *inode;	/* vfs inode pointer */
> -	block_t blkaddr;	/* block address locating the last inode */
> +	block_t blkaddr;	/* block address locating the last fsync */
> +	block_t last_dentry;	/* block address locating the last dentry */
> +	block_t last_inode;	/* block address locating the last inode */
>  };
> 
>  #define nats_in_cursum(sum)		(le16_to_cpu(sum->n_nats))
> diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
> index 6f7fbfa..95d9dc9 100644
> --- a/fs/f2fs/recovery.c
> +++ b/fs/f2fs/recovery.c
> @@ -66,7 +66,7 @@ static struct fsync_inode_entry *get_fsync_inode(struct list_head *head,
>  	return NULL;
>  }
> 
> -static int recover_dentry(struct page *ipage, struct inode *inode)
> +static int recover_dentry(struct inode *inode, struct page *ipage)
>  {
>  	struct f2fs_inode *raw_inode = F2FS_INODE(ipage);
>  	nid_t pino = le32_to_cpu(raw_inode->i_pino);
> @@ -140,7 +140,7 @@ out:
>  	return err;
>  }
> 
> -static void __recover_inode(struct inode *inode, struct page *page)
> +static void recover_inode(struct inode *inode, struct page *page)
>  {
>  	struct f2fs_inode *raw = F2FS_INODE(page);
> 
> @@ -152,21 +152,9 @@ static void __recover_inode(struct inode *inode, struct page *page)
>  	inode->i_atime.tv_nsec = le32_to_cpu(raw->i_mtime_nsec);
>  	inode->i_ctime.tv_nsec = le32_to_cpu(raw->i_ctime_nsec);
>  	inode->i_mtime.tv_nsec = le32_to_cpu(raw->i_mtime_nsec);
> -}
> -
> -static int recover_inode(struct inode *inode, struct page *node_page)
> -{
> -	if (!IS_INODE(node_page))
> -		return 0;
> -
> -	__recover_inode(inode, node_page);
> -
> -	if (is_dent_dnode(node_page))
> -		return recover_dentry(node_page, inode);
> 
>  	f2fs_msg(inode->i_sb, KERN_NOTICE, "recover_inode: ino = %x, name = %s",
> -			ino_of_node(node_page), F2FS_INODE(node_page)->i_name);
> -	return 0;
> +			ino_of_node(page), F2FS_INODE(page)->i_name);
>  }
> 
>  static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head *head)
> @@ -214,12 +202,11 @@ static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head
> *head)
>  			}
> 
>  			/* add this fsync inode to the list */
> -			entry = kmem_cache_alloc(fsync_entry_slab, GFP_NOFS);
> +			entry = kmem_cache_alloc(fsync_entry_slab, GFP_F2FS_ZERO);
>  			if (!entry) {
>  				err = -ENOMEM;
>  				break;
>  			}
> -
>  			/*
>  			 * CP | dnode(F) | inode(DF)
>  			 * For this case, we should not give up now.
> @@ -236,9 +223,11 @@ static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head
> *head)
>  		}
>  		entry->blkaddr = blkaddr;
> 
> -		err = recover_inode(entry->inode, page);
> -		if (err && err != -ENOENT)
> -			break;
> +		if (IS_INODE(page)) {
> +			entry->last_inode = blkaddr;
> +			if (is_dent_dnode(page))
> +				entry->last_dentry = blkaddr;
> +		}
>  next:
>  		/* check next segment */
>  		blkaddr = next_blkaddr_of_node(page);
> @@ -455,11 +444,15 @@ static int recover_data(struct f2fs_sb_info *sbi,
>  		/*
>  		 * inode(x) | CP | inode(x) | dnode(F)
>  		 * In this case, we can lose the latest inode(x).
> -		 * So, call __recover_inode for the inode update.
> +		 * So, call recover_inode for the inode update.
>  		 */
> -		if (IS_INODE(page))
> -			__recover_inode(entry->inode, page);
> -
> +		if (entry->last_inode == blkaddr)
> +			recover_inode(entry->inode, page);
> +		if (entry->last_dentry == blkaddr) {
> +			err = recover_dentry(entry->inode, page);
> +			if (err)

Need f2fs_put_page(page, 1);

> +				break;
> +		}
>  		err = do_recover_data(sbi, entry->inode, page, blkaddr);
>  		if (err)
>  			break;
> --
> 1.8.5.2 (Apple Git-48)
> 
> 
> ------------------------------------------------------------------------------
> Want excitement?
> Manually upgrade your production database.
> When you want reliability, choose Perforce
> Perforce version control. Predictably reliable.
> http://pubads.g.doubleclick.net/gampad/clk?id=157508191&iu=/4140/ostg.clktrk
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

