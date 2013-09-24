Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340Ab3IXKMw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 06:12:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:1487 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752784Ab3IXKMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 06:12:50 -0400
X-IronPort-AV: E=Sophos;i="4.90,969,1371052800"; 
   d="scan'208";a="8606715"
Message-ID: <52416475.3090008@cn.fujitsu.com>
Date: Tue, 24 Sep 2013 18:07:49 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Chao Yu <chao2.yu@samsung.com>
CC: Kim Jaegeuk <jaegeuk.kim@gmail.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?GB2312?B?zLfmrQ==?= <shu.tan@samsung.com>
Subject: Re: [f2fs-dev] [PATCH RESEND] f2fs: remove unneeded write checkpoint
 in recover_fsync_data
References: <000201ceb8c5$3c983840$b5c8a8c0$@samsung.com>
In-Reply-To: <000201ceb8c5$3c983840$b5c8a8c0$@samsung.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/24 18:11:06,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/24 18:11:07,
	Serialize complete at 2013/09/24 18:11:07
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=GB2312
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2013 09:26 AM, Chao Yu wrote:

> Previously, recover_fsync_data still to write checkpoint when there is
> nothing to recover with normal umount image.
> It may reduce mount performance and flash memory lifetime, so let's remove
> it.
> 
> Signed-off-by: Tan Shu <shu.tan@samsung.com>
> Signed-off-by: Yu Chao <chao2.yu@samsung.com>

Reviewed-by: Gu Zheng <guz.fnst@cn.fujitsu.com>

> ---
> fs/f2fs/recovery.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
> index 51ef5ee..d43e4cd 100644
> --- a/fs/f2fs/recovery.c
> +++ b/fs/f2fs/recovery.c
> @@ -419,6 +419,7 @@ int recover_fsync_data(struct f2fs_sb_info *sbi)
>  {
>  	struct list_head inode_list;
>  	int err;
> +	int need_writecp = 0;
>  
>  	fsync_entry_slab = f2fs_kmem_cache_create("f2fs_fsync_inode_entry",
>  			sizeof(struct fsync_inode_entry), NULL);
> @@ -436,6 +437,8 @@ int recover_fsync_data(struct f2fs_sb_info *sbi)
>  	if (list_empty(&inode_list))
>  		goto out;
>  
> +	need_writecp = 1;
> +
>  	/* step #2: recover data */
>  	err = recover_data(sbi, &inode_list, CURSEG_WARM_NODE);
>  	BUG_ON(!list_empty(&inode_list));
> @@ -443,7 +446,7 @@ out:
>  	destroy_fsync_dnodes(&inode_list);
>  	kmem_cache_destroy(fsync_entry_slab);
>  	sbi->por_doing = 0;
> -	if (!err)
> +	if (!err && need_writecp)
>  		write_checkpoint(sbi, false);
>  	return err;
>  }
> ---
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


