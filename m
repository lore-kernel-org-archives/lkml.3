Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbaHSGmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 02:42:40 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:60006 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbaHSGmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 02:42:38 -0400
X-AuditID: cbfee61a-f79e46d00000134f-25-53f2f1d6f0ae
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <1407872967-26423-1-git-send-email-jaegeuk@kernel.org>
 <1407872967-26423-8-git-send-email-jaegeuk@kernel.org>
 <20140815215818.GB53769@jaegeuk-mac02.mot.com>
In-reply-to: <20140815215818.GB53769@jaegeuk-mac02.mot.com>
Subject: RE: [f2fs-dev] [PATCH 08/13 v2] f2fs: do checkpoint at	f2fs_put_super
Date: Tue, 19 Aug 2014 14:41:44 +0800
Message-id: <002e01cfbb78$bf297ab0$3d7c7010$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQG4wP7f0RrIWMfJUczB9r86/XcZWwFK/j/TAeW7RHab6+bDQA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsVy+t9jQd1rHz8FGxw9y23xZP0sZotLi9wt
	9uw9yWJxedccNgcWj02rOtk8di/4zOTxeZNcAHMUl01Kak5mWWqRvl0CV8bWRt6CiUIVNyet
	Zm5gbOLvYuTkkBAwkfj9/zU7hC0mceHeerYuRi4OIYHpjBKbfr5kgnB+MEr0bm9lAqliE1CR
	WN7xH8wWEVCT6N03BcxmFsiUmND/gh2iYQ2jxPZzO5lBEpwC1hKfH+9hAbGFBfwkLrZ/YgOx
	WQRUJRbt3coKYvMKWEqcWzCdCcIWlPgx+R4LxFAtic3bmlghbHmJzWveMkOcqiCx4+xrRogj
	nCRmLOtihqgRl9h45BbLBEahWUhGzUIyahaSUbOQtCxgZFnFKJpakFxQnJSea6hXnJhbXJqX
	rpecn7uJERz6z6R2MK5ssDjEKMDBqMTDq/DlY7AQa2JZcWXuIUYJDmYlEV7HF5+ChXhTEiur
	Uovy44tKc1KLDzFKc7AoifMeaLUOFBJITyxJzU5NLUgtgskycXBKNTBGVTb9tlByzFzg5p/v
	5N3YwBx59WjCis9bmvWV5yVk1bvz3p99SKzd4VJaW5/J+/fHvirrdP4R+n7w4mWV9avX1F7a
	m/xrgZTixRuFhQ/9YnJfLhUS0bEz2hSyJn8W16q2cvnQBqWcicFKbrGBhyQLNqfGCLYx7N9t
	JbLz9pMM4fxjjxxtM5RYijMSDbWYi4oTAZloAsx5AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaegeuk,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Saturday, August 16, 2014 5:58 AM
> To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Subject: Re: [f2fs-dev] [PATCH 08/13 v2] f2fs: do checkpoint at f2fs_put_super
> 
> Change log from v1:
>  o relocate F2FS_SET_SB_DIRT to avoid unnecessary checkpoints

In umount, we will encounter memory leak as we may skip releasing dirty inode
when IO error occurred in cp. Why not just invoking release_dirty_inode directly
in f2fs_put_super?

Thanks,
Yu

> 
> The generic_shutdown_super calls sync_filesystem, evict_inode, and then
> f2fs_put_super. In f2fs_evict_inode, we remain some dirty inode information
> so we should release them at f2fs_put_super.
> 
> But normally, it's more reasonable to set its superblock as dirty when
> evict_inode is called.
> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
>  fs/f2fs/checkpoint.c | 1 +
>  fs/f2fs/super.c      | 2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
> index 7e1c13b..01e1796 100644
> --- a/fs/f2fs/checkpoint.c
> +++ b/fs/f2fs/checkpoint.c
> @@ -330,6 +330,7 @@ void add_dirty_inode(struct f2fs_sb_info *sbi, nid_t ino, int type)
>  {
>  	/* add new dirty ino entry into list */
>  	__add_ino_entry(sbi, ino, type);
> +	F2FS_SET_SB_DIRT(sbi);
>  }
> 
>  void remove_dirty_inode(struct f2fs_sb_info *sbi, nid_t ino, int type)
> diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
> index 633315a..60e3554 100644
> --- a/fs/f2fs/super.c
> +++ b/fs/f2fs/super.c
> @@ -432,7 +432,7 @@ static void f2fs_put_super(struct super_block *sb)
>  	stop_gc_thread(sbi);
> 
>  	/* We don't need to do checkpoint when it's clean */
> -	if (sbi->s_dirty && get_pages(sbi, F2FS_DIRTY_NODES))
> +	if (sbi->s_dirty)
>  		write_checkpoint(sbi, true);
> 
>  	iput(sbi->node_inode);
> --
> 1.8.5.2 (Apple Git-48)
> 
> 
> 
> ------------------------------------------------------------------------------
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

