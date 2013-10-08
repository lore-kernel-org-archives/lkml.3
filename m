Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab3JHJmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 05:42:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:1444 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752143Ab3JHJmp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 05:42:45 -0400
X-IronPort-AV: E=Sophos;i="4.90,1056,1371052800"; 
   d="scan'208";a="8688789"
Message-ID: <5253D24E.3010309@cn.fujitsu.com>
Date: Tue, 08 Oct 2013 17:37:18 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: yuan.mark.zhong@samsung.com
CC: jaegeuk.kim@samsung.com, linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        shu.tan@samsung.com
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: avoid congestion_wait when do_checkpoint
 for better performance
References: <25944790.263941381221039729.JavaMail.weblogic@epml12>
In-Reply-To: <25944790.263941381221039729.JavaMail.weblogic@epml12>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/08 17:40:32,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/08 17:40:38
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yuan,
On 10/08/2013 04:30 PM, Yuan Zhong wrote:

> Previously, do_checkpoint() will call congestion_wait() for waiting the pages (previous submitted node/meta/data pages) to be written back.
> Because congestion_wait() will set a regular period (e.g. HZ / 50 ) for waiting.
> For this reason, there is a situation that after the pages have been written back, but the checkpoint thread still wait for congestion_wait to exit.

How do you confirm this issue? I suspect that the block-core does not have a wake-up mechanism
when the back device is uncongested.

> This is a problem here, especially, when sync a large number of small files or dirs.
> In order to avoid this, a wait_list is introduced, the checkpoint thread will be dropped into the wait_list if the pages have not been written back, and will be waked up by contrast.

Please pay some attention to the mail form, this mail is out of format in my mail client.

Regards,
Gu

> 
> Signed-off-by: Yuan Zhong <yuan.mark.zhong@samsung.com>
> ---  
>  fs/f2fs/checkpoint.c |    3 +--
>  fs/f2fs/f2fs.h       |   19 +++++++++++++++++++
>  fs/f2fs/segment.c    |    1 +
>  fs/f2fs/super.c      |    1 +
>  4 files changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
> index ca39442..5d69ae0 100644
> --- a/fs/f2fs/checkpoint.c
> +++ b/fs/f2fs/checkpoint.c
> @@ -758,8 +758,7 @@ static void do_checkpoint(struct f2fs_sb_info *sbi, bool is_umount)
>  	f2fs_put_page(cp_page, 1);
>  
>  	/* wait for previous submitted node/meta pages writeback */
> -	while (get_pages(sbi, F2FS_WRITEBACK))
> -		congestion_wait(BLK_RW_ASYNC, HZ / 50);
> +	f2fs_writeback_wait(sbi);
>  
>  	filemap_fdatawait_range(sbi->node_inode->i_mapping, 0, LONG_MAX);
>  	filemap_fdatawait_range(sbi->meta_inode->i_mapping, 0, LONG_MAX);
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index 7fd99d8..4b0d70e 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -18,6 +18,8 @@
>  #include <linux/crc32.h>
>  #include <linux/magic.h>
>  #include <linux/kobject.h>
> +#include <linux/wait.h>
> +#include <linux/sched.h>
>  
>  /*
>   * For mount options
> @@ -368,6 +370,7 @@ struct f2fs_sb_info {
>  	struct mutex fs_lock[NR_GLOBAL_LOCKS];	/* blocking FS operations */
>  	struct mutex node_write;		/* locking node writes */
>  	struct mutex writepages;		/* mutex for writepages() */
> +	wait_queue_head_t writeback_wqh;	/* wait_queue for writeback */
>  	unsigned char next_lock_num;		/* round-robin global locks */
>  	int por_doing;				/* recovery is doing or not */
>  	int on_build_free_nids;			/* build_free_nids is doing */
> @@ -961,6 +964,22 @@ static inline int f2fs_readonly(struct super_block *sb)
>  	return sb->s_flags & MS_RDONLY;
>  }
>  
> +static inline void f2fs_writeback_wait(struct f2fs_sb_info *sbi)
> +{
> +	DEFINE_WAIT(wait);
> +
> +	prepare_to_wait(&sbi->writeback_wqh, &wait, TASK_UNINTERRUPTIBLE);
> +	if (get_pages(sbi, F2FS_WRITEBACK))
> +		io_schedule();
> +	finish_wait(&sbi->writeback_wqh, &wait);
> +}
> +
> +static inline void f2fs_writeback_wake(struct f2fs_sb_info *sbi)
> +{
> +	if (!get_pages(sbi, F2FS_WRITEBACK))
> +		wake_up_all(&sbi->writeback_wqh);
> +}
> +
>  /*
>   * file.c
>   */
> diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
> index bd79bbe..0708aa9 100644
> --- a/fs/f2fs/segment.c
> +++ b/fs/f2fs/segment.c
> @@ -597,6 +597,7 @@ static void f2fs_end_io_write(struct bio *bio, int err)
>  
>  	if (p->is_sync)
>  		complete(p->wait);
> +	f2fs_writeback_wake(p->sbi);
>  	kfree(p);
>  	bio_put(bio);
>  }
> diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
> index 094ccc6..3ac6d85 100644
> --- a/fs/f2fs/super.c
> +++ b/fs/f2fs/super.c
> @@ -835,6 +835,7 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
>  	mutex_init(&sbi->gc_mutex);
>  	mutex_init(&sbi->writepages);
>  	mutex_init(&sbi->cp_mutex);
> +	init_waitqueue_head(&sbi->writeback_wqh);
>  	for (i = 0; i < NR_GLOBAL_LOCKS; i++)
>  		mutex_init(&sbi->fs_lock[i]);
>  	mutex_init(&sbi->node_write);N‹§²æìr¸›yúèšØb²X¬¶Ç§vØ^–)Þº{.nÇ+‰·¥Š{±‘êçzX§¶›¡Ü¨}©ž²Æ zÚ&j:+v‰¨¾«‘êçzZ+€Ê+zf£¢·hšˆ§~†­†Ûiÿûàz¹®w¥¢¸?™¨è­Ú&¢)ß¢f”ù^jÇ«y§m…á@A«a¶Úÿ0¶ìh®å’i


