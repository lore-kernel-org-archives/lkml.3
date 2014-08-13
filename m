Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbaHMKWA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 06:22:00 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:41755 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbaHMKV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 06:21:58 -0400
X-AuditID: cbfee61a-f79e46d00000134f-5f-53eb3c2bdd1f
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <1407872967-26423-1-git-send-email-jaegeuk@kernel.org>
 <1407872967-26423-6-git-send-email-jaegeuk@kernel.org>
In-reply-to: <1407872967-26423-6-git-send-email-jaegeuk@kernel.org>
Subject: RE: [f2fs-dev] [PATCH 06/13] f2fs: fix to recover inline_xattr/data
 and	blocks
Date: Wed, 13 Aug 2014 18:20:44 +0800
Message-id: <009e01cfb6e0$58a98d30$09fca790$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQG4wP7f0RrIWMfJUczB9r86/XcZWwH+9LHfm+xGjuA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9jQV1tm9fBBt9+Sls8WT+L2eLSIneL
	PXtPslhc3jWHzYHFY9OqTjaP3Qs+M3l83iQXwBzFZZOSmpNZllqkb5fAlfG+dyFzwVq5ig2z
	ljE3MH6S6GLk5JAQMJGY+KebCcIWk7hwbz1bFyMXh5DAdEaJQ00LWCGcH4wSLTeXMINUsQmo
	SCzv+A/WISKgJtG7bwqYzSyQKTGh/wU7iC0kUC2xsW0imM0p4Cyx69gtsBphgUiJfbvnAdkc
	HCwCqhLrnoSBhHkFLCV2tX1ghbAFJX5MvscCMVJLYv3O41Dj5SU2r3nLDHGogsSOs68ZIU6w
	klh5eCpUjbjExiO3WCYwCs1CMmoWklGzkIyahaRlASPLKkbR1ILkguKk9FxDveLE3OLSvHS9
	5PzcTYzgwH8mtYNxZYPFIUYBDkYlHt4K3lfBQqyJZcWVuYcYJTiYlUR41xi9DhbiTUmsrEot
	yo8vKs1JLT7EKM3BoiTOe6DVOlBIID2xJDU7NbUgtQgmy8TBKdXAuHLDkY1tq+e9/dXL+3dX
	ScbV7RYOYsVq70J8fayl1YSdfklGcQZv63M7X2hbeSDrsanXOZ0b6+Ts36SdvzP1t5aU+Gr/
	TTf6kj0u7j518rLzZm3zE71zI2/ccO7/t9G8LzFhoqLRxsXrqueIfz/Q8cfIJEW6aIvAtvdf
	z/yRfaHSseBnlGx4jhJLcUaioRZzUXEiAHo17Tl4AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Wednesday, August 13, 2014 3:49 AM
> To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Cc: Jaegeuk Kim
> Subject: [f2fs-dev] [PATCH 06/13] f2fs: fix to recover inline_xattr/data and blocks
> 
> This patch fixes not to skip xattr recovery and inline xattr/data recovery
> order.
> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

Reviewed-by: Chao Yu <chao2.yu@samsung.com>

> ---
>  fs/f2fs/f2fs.h     |  2 +-
>  fs/f2fs/node.c     |  9 +--------
>  fs/f2fs/recovery.c | 13 +++++++++----
>  3 files changed, 11 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index 2e4aa3a..cc5ead1 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -1205,7 +1205,7 @@ void alloc_nid_failed(struct f2fs_sb_info *, nid_t);
>  void recover_node_page(struct f2fs_sb_info *, struct page *,
>  		struct f2fs_summary *, struct node_info *, block_t);
>  void recover_inline_xattr(struct inode *, struct page *);
> -bool recover_xattr_data(struct inode *, struct page *, block_t);
> +void recover_xattr_data(struct inode *, struct page *, block_t);
>  int recover_inode_page(struct f2fs_sb_info *, struct page *);
>  int restore_node_summary(struct f2fs_sb_info *, unsigned int,
>  				struct f2fs_summary_block *);
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index 151045f..c80e3d5 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -1557,9 +1557,6 @@ void recover_inline_xattr(struct inode *inode, struct page *page)
>  	struct page *ipage;
>  	struct f2fs_inode *ri;
> 
> -	if (!IS_INODE(page))
> -		return;
> -
>  	ipage = get_node_page(sbi, inode->i_ino);
>  	f2fs_bug_on(IS_ERR(ipage));
> 
> @@ -1580,16 +1577,13 @@ update_inode:
>  	f2fs_put_page(ipage, 1);
>  }
> 
> -bool recover_xattr_data(struct inode *inode, struct page *page, block_t blkaddr)
> +void recover_xattr_data(struct inode *inode, struct page *page, block_t blkaddr)
>  {
>  	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
>  	nid_t prev_xnid = F2FS_I(inode)->i_xattr_nid;
>  	nid_t new_xnid = nid_of_node(page);
>  	struct node_info ni;
> 
> -	if (!f2fs_has_xattr_block(ofs_of_node(page)))
> -		return false;
> -
>  	/* 1: invalidate the previous xattr nid */
>  	if (!prev_xnid)
>  		goto recover_xnid;
> @@ -1617,7 +1611,6 @@ recover_xnid:
>  	set_node_addr(sbi, &ni, blkaddr, false);
> 
>  	update_inode_page(inode);
> -	return true;
>  }
> 
>  int recover_inode_page(struct f2fs_sb_info *sbi, struct page *page)
> diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
> index cfb2aa9..d7b67b8 100644
> --- a/fs/f2fs/recovery.c
> +++ b/fs/f2fs/recovery.c
> @@ -302,14 +302,19 @@ static int do_recover_data(struct f2fs_sb_info *sbi, struct inode *inode,
>  	struct node_info ni;
>  	int err = 0, recovered = 0;
> 
> -	recover_inline_xattr(inode, page);
> -
> -	if (recover_inline_data(inode, page))
> +	/* step 1: recover xattr */
> +	if (IS_INODE(page)) {
> +		recover_inline_xattr(inode, page);
> +	} else if (f2fs_has_xattr_block(ofs_of_node(page))) {
> +		recover_xattr_data(inode, page, blkaddr);
>  		goto out;
> +	}
> 
> -	if (recover_xattr_data(inode, page, blkaddr))
> +	/* step 2: recover inline data */
> +	if (recover_inline_data(inode, page))
>  		goto out;
> 
> +	/* step 3: recover data indices */
>  	start = start_bidx_of_node(ofs_of_node(page), fi);
>  	end = start + ADDRS_PER_PAGE(page, fi);
> 
> --
> 1.8.5.2 (Apple Git-48)
> 
> 
> ------------------------------------------------------------------------------
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

