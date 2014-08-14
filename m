Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbaHNC6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 22:58:38 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:59024 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbaHNC6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 22:58:37 -0400
X-AuditID: cbfee61a-f79e46d00000134f-77-53ec25db972a
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <1407872967-26423-1-git-send-email-jaegeuk@kernel.org>
 <1407872967-26423-8-git-send-email-jaegeuk@kernel.org>
In-reply-to: <1407872967-26423-8-git-send-email-jaegeuk@kernel.org>
Subject: RE: [f2fs-dev] [PATCH 08/13] f2fs: do checkpoint at f2fs_put_super
Date: Thu, 14 Aug 2014 10:57:10 +0800
Message-id: <000401cfb76b$a3957b20$eac07160$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQG4wP7f0RrIWMfJUczB9r86/XcZWwFK/j/Tm/L2GnA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t9jQd3bqm+CDV5+FbZ4sn4Ws8WlRe4W
	e/aeZLG4vGsOmwOLx6ZVnWweuxd8ZvL4vEkugDmKyyYlNSezLLVI3y6BK2P9qQksBe1CFQuP
	PmZtYGzj72Lk4JAQMJH4MdO+i5ETyBSTuHBvPVsXIxeHkMB0Romrz7+ygySEBH4wSpyeogFi
	swmoSCzv+M8EYosIqEn07psCZjMLZEpM6H8BVV8t0d21hhXE5hRwltjw/ClYXFjAW2Lxv3lg
	9SwCqhI3d3Qzgti8ApYS966thrIFJX5MvscCMVNLYv3O41Dz5SU2r3nLDHGogsSOs68ZIW6w
	kvjZeZ0RokZcYuORWywTGIVmIRk1C8moWUhGzULSsoCRZRWjaGpBckFxUnquoV5xYm5xaV66
	XnJ+7iZGcNg/k9rBuLLB4hCjAAejEg+vR9TrYCHWxLLiytxDjBIczEoivMrMb4KFeFMSK6tS
	i/Lji0pzUosPMUpzsCiJ8x5otQ4UEkhPLEnNTk0tSC2CyTJxcEo1MOaUrOS7tFPl/KoXPOpT
	vGLXlDzx/zebOT311FM7i4dWDL3Z/0ou/cvZzf29eadD++P1nmUyTc4BPdH37Zu2vlmR86Yj
	I9j8085vvhb3ow/G5jGcWHXhbtS8rJbi6XXWzxPkLT//DTfe2Ssm0DVNVfF3XKOe7laTeUtj
	dzz+HCv3eOYV3ZhJJkosxRmJhlrMRcWJACa0gPN3AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaegeuk,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Wednesday, August 13, 2014 3:49 AM
> To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Cc: Jaegeuk Kim
> Subject: [f2fs-dev] [PATCH 08/13] f2fs: do checkpoint at f2fs_put_super
> 
> The generic_shutdown_super calls sync_filesystem, evict_inode, and then
> f2fs_put_super. In f2fs_evict_inode, we remain some dirty inode information
> so we should release them at f2fs_put_super.
> 
> But normally, it's more reasonable to set its superblock as dirty when
> evict_inode is called.

After applying this patch, when we mount and then umount f2fs image without
modification, we will write checkpoint in f2fs_put_super even though we have
no more dirty data to sync, it's not needed.

"some dirty inode information" you mentioned is inode information in ->ino_root of
sbi, right?

Regards,
Yu

> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
>  fs/f2fs/inode.c | 1 +
>  fs/f2fs/super.c | 2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
> index 2c39999..eeaf5aa 100644
> --- a/fs/f2fs/inode.c
> +++ b/fs/f2fs/inode.c
> @@ -303,6 +303,7 @@ no_delete:
>  		add_dirty_inode(sbi, inode->i_ino, APPEND_INO);
>  	if (is_inode_flag_set(F2FS_I(inode), FI_UPDATE_WRITE))
>  		add_dirty_inode(sbi, inode->i_ino, UPDATE_INO);
> +	F2FS_SET_SB_DIRT(sbi);
>  out_clear:
>  	clear_inode(inode);
>  }
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
> ------------------------------------------------------------------------------
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

