Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbaG3NIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 09:08:55 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:30059 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584AbaG3NIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 09:08:53 -0400
X-AuditID: cbfee61a-f79e46d00000134f-62-53d8ee624f23
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>,
        "'Changman Lee'" <cm224.lee@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <003901cf96ad$dbd17680$93746380$@samsung.com>
In-reply-to: <003901cf96ad$dbd17680$93746380$@samsung.com>
Subject: RE: [f2fs-dev] [PATCH] f2fs: reduce competition among node page writes
Date: Wed, 30 Jul 2014 21:07:49 +0800
Message-id: <00f601cfabf7$691af580$3b50e080$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Content-language: zh-cn
Thread-index: AQIDqdX3kbhQL0bQPBsk1Qmt1GnMiJtQmNGw
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t9jAd2kdzeCDWY8sLS4tq+RyeLJ+lnM
	FpcWuVvs2XuSxeLyrjlsDqwem1Z1snnsXvCZyaNvyypGj8+b5AJYorhsUlJzMstSi/TtErgy
	Fn59x1bwXKHiwalHTA2M36S6GDk5JARMJFpnrWCCsMUkLtxbzwZiCwksYpTou1fVxcgFZP9g
	lOh+388KkmATUJFY3vEfrEFEwE9i+v2vYA3MApkSc15PZoVotpR4tq6REcTmFLCS6J3WClYv
	LOAvMX/abDCbRUBVYtLlHywgNi9Q/e99f1ghbEGJH5PvsUDM1JJYv/M4E4QtL7F5zVtmiEMV
	JHacfc0IEReX2HjkFgvEPUYSbw7dYJvAKDQLyahZSEbNQjJqFpL2BYwsqxhFUwuSC4qT0nMN
	9YoTc4tL89L1kvNzNzGCo+GZ1A7GlQ0WhxgFOBiVeHhn/L8eLMSaWFZcmXuIUYKDWUmEt/Hp
	jWAh3pTEyqrUovz4otKc1OJDjNIcLErivAdarQOFBNITS1KzU1MLUotgskwcnFINjC3N7bEu
	WYK7daZ+f2V6YLFnkN2kQ/WhGxfUH62+++r8dD3XR11x6Rkdz+Yxn+1Pjy1/+N6GuTX7pdWh
	1XmndynbCxj13y4/+XPR/auuonNmd0z/+HTtBLNu49Cvt67J1M1hrVvnNjl9+g/mSSbrvh/c
	ID3vOFfu4X13Qxzu2InuNsu73ccgxKjEUpyRaKjFXFScCABkHS0nggIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaegeuk Changman,

> -----Original Message-----
> From: Chao Yu [mailto:chao2.yu@samsung.com]
> Sent: Thursday, July 03, 2014 6:59 PM
> To: Jaegeuk Kim; Changman Lee
> Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Subject: [f2fs-dev] [PATCH] f2fs: reduce competition among node page writes
> 
> We do not need to block on ->node_write among different node page writers e.g.
> fsync/flush, unless we have a node page writer from write_checkpoint.
> So it's better use rw_semaphore instead of mutex type for ->node_write to
> promote performance.

If you could have time to help explaining the problem of this patch, I will be
appreciated for that.

Another question is what is ->writepages in sbi used for? I'm not quite clear.

Thanks,

> 
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> ---
>  fs/f2fs/checkpoint.c |    6 +++---
>  fs/f2fs/f2fs.h       |    2 +-
>  fs/f2fs/node.c       |    4 ++--
>  fs/f2fs/super.c      |    2 +-
>  4 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
> index 0b4710c..eec406b 100644
> --- a/fs/f2fs/checkpoint.c
> +++ b/fs/f2fs/checkpoint.c
> @@ -714,10 +714,10 @@ retry_flush_dents:
>  	 * until finishing nat/sit flush.
>  	 */
>  retry_flush_nodes:
> -	mutex_lock(&sbi->node_write);
> +	down_write(&sbi->node_write);
> 
>  	if (get_pages(sbi, F2FS_DIRTY_NODES)) {
> -		mutex_unlock(&sbi->node_write);
> +		up_write(&sbi->node_write);
>  		sync_node_pages(sbi, 0, &wbc);
>  		goto retry_flush_nodes;
>  	}
> @@ -726,7 +726,7 @@ retry_flush_nodes:
> 
>  static void unblock_operations(struct f2fs_sb_info *sbi)
>  {
> -	mutex_unlock(&sbi->node_write);
> +	up_write(&sbi->node_write);
>  	f2fs_unlock_all(sbi);
>  }
> 
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index ae3b4ac..ca30b5a 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -444,7 +444,7 @@ struct f2fs_sb_info {
>  	struct inode *meta_inode;		/* cache meta blocks */
>  	struct mutex cp_mutex;			/* checkpoint procedure lock */
>  	struct rw_semaphore cp_rwsem;		/* blocking FS operations */
> -	struct mutex node_write;		/* locking node writes */
> +	struct rw_semaphore node_write;		/* locking node writes */
>  	struct mutex writepages;		/* mutex for writepages() */
>  	bool por_doing;				/* recovery is doing or not */
>  	wait_queue_head_t cp_wait;
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index a90f51d..7b5b5de 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -1231,12 +1231,12 @@ static int f2fs_write_node_page(struct page *page,
>  	if (wbc->for_reclaim)
>  		goto redirty_out;
> 
> -	mutex_lock(&sbi->node_write);
> +	down_read(&sbi->node_write);
>  	set_page_writeback(page);
>  	write_node_page(sbi, page, &fio, nid, ni.blk_addr, &new_addr);
>  	set_node_addr(sbi, &ni, new_addr, is_fsync_dnode(page));
>  	dec_page_count(sbi, F2FS_DIRTY_NODES);
> -	mutex_unlock(&sbi->node_write);
> +	up_read(&sbi->node_write);
>  	unlock_page(page);
>  	return 0;
> 
> diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
> index 8f96d93..bed9413 100644
> --- a/fs/f2fs/super.c
> +++ b/fs/f2fs/super.c
> @@ -947,7 +947,7 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
>  	mutex_init(&sbi->gc_mutex);
>  	mutex_init(&sbi->writepages);
>  	mutex_init(&sbi->cp_mutex);
> -	mutex_init(&sbi->node_write);
> +	init_rwsem(&sbi->node_write);
>  	sbi->por_doing = false;
>  	spin_lock_init(&sbi->stat_lock);
> 
> --
> 1.7.9.5
> 
> 
> 
> ------------------------------------------------------------------------------
> Open source business process management suite built on Java and Eclipse
> Turn processes into business applications with Bonita BPM Community Edition
> Quickly connect people, data, and systems into organized workflows
> Winner of BOSSIE, CODIE, OW2 and Gartner awards
> http://p.sf.net/sfu/Bonitasoft
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

