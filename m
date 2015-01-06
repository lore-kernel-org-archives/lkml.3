Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbbAFTsl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:48:41 -0500
Received: from mail.kernel.org ([198.145.29.136]:45948 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753579AbbAFTsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 14:48:39 -0500
Date: Tue, 6 Jan 2015 11:48:34 -0800
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Chao Yu <chao2.yu@samsung.com>
Cc: Changman Lee <cm224.lee@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [f2fs-dev][PATCH] f2fs: fix wrong memory footprint statistics in
 debugfs
Message-ID: <20150106194834.GC54001@jaegeuk-mac02>
References: <009c01d0298c$946435e0$bd2ca1a0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <009c01d0298c$946435e0$bd2ca1a0$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chao,

On Tue, Jan 06, 2015 at 04:40:49PM +0800, Chao Yu wrote:
> Our value of memory footprint statistics showed in debugfs is not calculated
> correctly. Fix it in this patch.
> 
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> ---
>  fs/f2fs/debug.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/f2fs/debug.c b/fs/f2fs/debug.c
> index dd7835b..6aeaf46 100644
> --- a/fs/f2fs/debug.c
> +++ b/fs/f2fs/debug.c
> @@ -125,7 +125,7 @@ static void update_mem_info(struct f2fs_sb_info *sbi)
>  	int i;
>  
>  	if (si->base_mem)
> -		goto get_cache;
> +		goto get_dynamic_cache;
>  
>  	si->base_mem = sizeof(struct f2fs_sb_info) + sbi->sb->s_blocksize;
>  	si->base_mem += 2 * sizeof(struct f2fs_inode_info);
> @@ -161,13 +161,18 @@ static void update_mem_info(struct f2fs_sb_info *sbi)
>  	si->base_mem += sizeof(struct f2fs_nm_info);
>  	si->base_mem += __bitmap_size(sbi, NAT_BITMAP);
>  
> +get_dynamic_cache:
>  	/* build gc */
> -	si->base_mem += sizeof(struct f2fs_gc_kthread);
> +	if (sbi->gc_thread)
> +		si->base_mem += sizeof(struct f2fs_gc_kthread);
> +
> +	/* build merge flush thread */
> +	if (SM_I(sbi)->cmd_control_info)
> +		si->base_mem += sizeof(struct flush_cmd_control);

It seems base_mem increases repeatedly?

>  
> -get_cache:
>  	/* free nids */
> -	si->cache_mem = NM_I(sbi)->fcnt;
> -	si->cache_mem += NM_I(sbi)->nat_cnt;
> +	si->cache_mem = NM_I(sbi)->fcnt * sizeof(struct free_nid);
> +	si->cache_mem += NM_I(sbi)->nat_cnt * sizeof(struct nat_entry);

Oh, nice catch.

>  	npages = NODE_MAPPING(sbi)->nrpages;
>  	si->cache_mem += npages << PAGE_CACHE_SHIFT;
>  	npages = META_MAPPING(sbi)->nrpages;
> -- 
> 2.2.1
