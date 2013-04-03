Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762528Ab3DCFyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 01:54:08 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:33137 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762503Ab3DCFyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 01:54:03 -0400
X-Greylist: delayed 16717 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Apr 2013 01:54:03 EDT
MIME-Version: 1.0
In-Reply-To: <1364799360-23145-8-git-send-email-jaegeuk.kim@samsung.com>
References: <1364799360-23145-1-git-send-email-jaegeuk.kim@samsung.com>
	<1364799360-23145-8-git-send-email-jaegeuk.kim@samsung.com>
Date: Wed, 3 Apr 2013 14:54:02 +0900
Message-ID: <CAKYAXd9cnu-4h0U+9Q1y4nLTbT-cm8eORLHtqMmFja_v=gZvmA@mail.gmail.com>
Subject: Re: [PATCH 8/9] f2fs: avoid race for summary information
From: Namjae Jeon <linkinjeon@gmail.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/1, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> In order to do GC more reliably, I'd like to lock the vicitm summary page
> until its GC is completed, and also prevent any checkpoint process.
>
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> ---
>  fs/f2fs/gc.c    | 8 +-------
>  fs/f2fs/node.c  | 2 +-
>  fs/f2fs/super.c | 7 +++++--
>  3 files changed, 7 insertions(+), 10 deletions(-)
>
> diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
> index 54aceb2..54ac13d 100644
> --- a/fs/f2fs/gc.c
> +++ b/fs/f2fs/gc.c
> @@ -641,12 +641,6 @@ static void do_garbage_collect(struct f2fs_sb_info
> *sbi, unsigned int segno,
>  	if (IS_ERR(sum_page))
>  		return;
>
> -	/*
> -	 * CP needs to lock sum_page. In this time, we don't need
> -	 * to lock this page, because this summary page is not gone anywhere.
> -	 * Also, this page is not gonna be updated before GC is done.
> -	 */
> -	unlock_page(sum_page);
>  	sum = page_address(sum_page);
>
>  	switch (GET_SUM_TYPE((&sum->footer))) {
> @@ -660,7 +654,7 @@ static void do_garbage_collect(struct f2fs_sb_info *sbi,
> unsigned int segno,
>  	stat_inc_seg_count(sbi, GET_SUM_TYPE((&sum->footer)));
>  	stat_inc_call_count(sbi->stat_info);
>
> -	f2fs_put_page(sum_page, 0);
> +	f2fs_put_page(sum_page, 1);
>  }
>
>  int f2fs_gc(struct f2fs_sb_info *sbi)
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index c5360b7..7555fb7 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -1148,7 +1148,7 @@ static int f2fs_write_node_pages(struct address_space
> *mapping,
>
>  	/* First check balancing cached NAT entries */
>  	if (try_to_free_nats(sbi, NAT_ENTRY_PER_BLOCK)) {
> -		write_checkpoint(sbi, false);
> +		f2fs_sync_fs(sbi->sb, true);
>  		return 0;
>  	}
>
> diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
> index ea325c8..161e6c6 100644
> --- a/fs/f2fs/super.c
> +++ b/fs/f2fs/super.c
> @@ -137,10 +137,13 @@ int f2fs_sync_fs(struct super_block *sb, int sync)
>  	if (!sbi->s_dirty && !get_pages(sbi, F2FS_DIRTY_NODES))
>  		return 0;
>
> -	if (sync)
> +	if (sync) {
> +		mutex_lock(&sbi->gc_mutex);
>  		write_checkpoint(sbi, false);
> -	else
> +		mutex_unlock(&sbi->gc_mutex);
> +	} else {
>  		f2fs_balance_fs(sbi);
> +	}
We can remove { } of else because single line code is used.
Reviewed-by: Namjae Jeon <namjae.jeon@samsung.com>

Thanks.
>
>  	return 0;
>  }
> --
> 1.8.1.3.566.gaa39828
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
