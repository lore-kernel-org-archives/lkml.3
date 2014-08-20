Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbaHTJfG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 05:35:06 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:60769 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbaHTJfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 05:35:03 -0400
X-AuditID: cbfee61a-f79e46d00000134f-4e-53f46bc53c98
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <1408467177-69746-1-git-send-email-jaegeuk@kernel.org>
 <1408467177-69746-2-git-send-email-jaegeuk@kernel.org>
In-reply-to: <1408467177-69746-2-git-send-email-jaegeuk@kernel.org>
Subject: RE: [f2fs-dev] [PATCH 2/2] f2fs: trigger release_dirty_inode in
	f2fs_put_super
Date: Wed, 20 Aug 2014 17:33:58 +0800
Message-id: <007a01cfbc5a$035849f0$0a08ddd0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIRsEQNpbtGJR6jwHxlc6l54GvPMQILZQIOm0T0gTA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t9jAd2j2V+CDc71Gls8WT+L2eLSIneL
	PXtPslhc3jWHzYHFY9OqTjaP3Qs+M3l83iQXwBzFZZOSmpNZllqkb5fAldHb2cZa8Iy/4s2b
	/2wNjDN4uxg5OSQETCRmbF/JBmGLSVy4tx7MFhJYxCgx+b9BFyMXkP2DUWLurq3sIAk2ARWJ
	5R3/mUBsEQE1id59U8BsZoFMiQn9L9ghmqslFp/aztjFyMHBKeAsceWRMEhYWCBS4sOzfmYQ
	m0VAVWLv3cksIDavgKXEofbtULagxI/J91ggRmpJbN7WxAphy0tsXvOWGeJOBYkdZ18zQpxg
	JTHv9CtGiBpxiY1HbrFMYBSahWTULCSjZiEZNQtJywJGllWMoqkFyQXFSem5hnrFibnFpXnp
	esn5uZsYwWH/TGoH48oGi0OMAhyMSjy8Ctmfg4VYE8uKK3MPMUpwMCuJ8BYlfAkW4k1JrKxK
	LcqPLyrNSS0+xCjNwaIkznug1TpQSCA9sSQ1OzW1ILUIJsvEwSnVwLjqnkBgZHasweEbKmYT
	YzicViXML1zsYXr6Zr3R5VtRanHaRoJnPqhe1AtqZgns81xjxfuG4eu96mu1v1YZOZ94VNFw
	pe3oob7pCxYd/qX5zecRw7bFYhfsk1+1rLggsVJ34uXdO6ZevlA76ULSaVaJ688abmRN52LR
	UQtrv/juQ4HqpDfOgoVKLMUZiYZazEXFiQA0uwuHdwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Wednesday, August 20, 2014 12:53 AM
> To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Cc: Jaegeuk Kim
> Subject: [f2fs-dev] [PATCH 2/2] f2fs: trigger release_dirty_inode in f2fs_put_super
> 
> The generic_shutdown_super calls sync_filesystem, evict_inode, and then
> f2fs_put_super. In f2fs_evict_inode, we remain some dirty inode information
> so we should release them at f2fs_put_super.
> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

Looks good to me now, add this please:

Reviewed-by: Chao Yu <chao2.yu@samsung.com>

> ---
>  fs/f2fs/checkpoint.c | 2 +-
>  fs/f2fs/super.c      | 3 +++
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
> index 7e1c13b..f14af91 100644
> --- a/fs/f2fs/checkpoint.c
> +++ b/fs/f2fs/checkpoint.c
> @@ -348,7 +348,7 @@ bool exist_written_data(struct f2fs_sb_info *sbi, nid_t ino, int mode)
>  	return e ? true : false;
>  }
> 
> -static void release_dirty_inode(struct f2fs_sb_info *sbi)
> +void release_dirty_inode(struct f2fs_sb_info *sbi)
>  {
>  	struct ino_entry *e, *tmp;
>  	int i;
> diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
> index 60e3554..7a54779 100644
> --- a/fs/f2fs/super.c
> +++ b/fs/f2fs/super.c
> @@ -435,6 +435,9 @@ static void f2fs_put_super(struct super_block *sb)
>  	if (sbi->s_dirty)
>  		write_checkpoint(sbi, true);
> 
> +	/* normally superblock is clean, so we need to release this */
> +	release_dirty_inode(sbi);
> +
>  	iput(sbi->node_inode);
>  	iput(sbi->meta_inode);
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

