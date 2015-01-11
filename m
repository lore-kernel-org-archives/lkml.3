Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866AbbAKFfZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 00:35:25 -0500
Received: from mail.kernel.org ([198.145.29.136]:54831 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381AbbAKFfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 00:35:24 -0500
Date: Sat, 10 Jan 2015 21:35:21 -0800
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Chao Yu <chao2.yu@samsung.com>
Cc: "'Changman Lee'" <cm224.lee@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [f2fs-dev][PATCH] f2fs: fix wrong memory footprint statistics in
 debugfs
Message-ID: <20150111053521.GA92334@jaegeuk-mac02.hsd1.ca.comcast.net>
References: <009c01d0298c$946435e0$bd2ca1a0$@samsung.com>
 <20150106194834.GC54001@jaegeuk-mac02>
 <000201d02cce$70f628d0$52e27a70$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000201d02cce$70f628d0$52e27a70$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 08:09:52PM +0800, Chao Yu wrote:
> Hi Jaegeuk,
> 
> > -----Original Message-----
> > From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> > Sent: Wednesday, January 07, 2015 3:49 AM
> > To: Chao Yu
> > Cc: Changman Lee; linux-f2fs-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org
> > Subject: Re: [f2fs-dev][PATCH] f2fs: fix wrong memory footprint statistics in debugfs
> > 
> > Hi Chao,
> > 
> > On Tue, Jan 06, 2015 at 04:40:49PM +0800, Chao Yu wrote:
> > > Our value of memory footprint statistics showed in debugfs is not calculated
> > > correctly. Fix it in this patch.
> > >
> > > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > > ---
> > >  fs/f2fs/debug.c | 15 ++++++++++-----
> > >  1 file changed, 10 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/fs/f2fs/debug.c b/fs/f2fs/debug.c
> > > index dd7835b..6aeaf46 100644
> > > --- a/fs/f2fs/debug.c
> > > +++ b/fs/f2fs/debug.c
> > > @@ -125,7 +125,7 @@ static void update_mem_info(struct f2fs_sb_info *sbi)
> > >  	int i;
> > >
> > >  	if (si->base_mem)
> > > -		goto get_cache;
> > > +		goto get_dynamic_cache;
> > >
> > >  	si->base_mem = sizeof(struct f2fs_sb_info) + sbi->sb->s_blocksize;
> > >  	si->base_mem += 2 * sizeof(struct f2fs_inode_info);
> > > @@ -161,13 +161,18 @@ static void update_mem_info(struct f2fs_sb_info *sbi)
> > >  	si->base_mem += sizeof(struct f2fs_nm_info);
> > >  	si->base_mem += __bitmap_size(sbi, NAT_BITMAP);
> > >
> > > +get_dynamic_cache:
> > >  	/* build gc */
> > > -	si->base_mem += sizeof(struct f2fs_gc_kthread);
> > > +	if (sbi->gc_thread)
> > > +		si->base_mem += sizeof(struct f2fs_gc_kthread);
> > > +
> > > +	/* build merge flush thread */
> > > +	if (SM_I(sbi)->cmd_control_info)
> > > +		si->base_mem += sizeof(struct flush_cmd_control);
> > 
> > It seems base_mem increases repeatedly?
> 
> Right, my mistaken. How about counting memory of these two cache into cache_mem
> as following?

Looks good to me. :)
Thanks,

> 
> >From edfa0beaed83ebfec34b07bfcb5e8ce3cdcb0858 Mon Sep 17 00:00:00 2001
> From: Chao Yu <chao2.yu@samsung.com>
> Date: Sat, 10 Jan 2015 19:24:24 +0800
> Subject: [PATCH] f2fs: fix wrong memory footprint statistics in debugfs
> 
> Our value of memory footprint statistics showed in debugfs is not calculated
> correctly. Fix it in this patch.
> 
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> ---
>  fs/f2fs/debug.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/f2fs/debug.c b/fs/f2fs/debug.c
> index 1f0fb58..b45daab 100644
> --- a/fs/f2fs/debug.c
> +++ b/fs/f2fs/debug.c
> @@ -163,13 +163,20 @@ static void update_mem_info(struct f2fs_sb_info *sbi)
>  	si->base_mem += sizeof(struct f2fs_nm_info);
>  	si->base_mem += __bitmap_size(sbi, NAT_BITMAP);
>  
> +get_cache:
> +	si->cache_mem = 0;
> +
>  	/* build gc */
> -	si->base_mem += sizeof(struct f2fs_gc_kthread);
> +	if (sbi->gc_thread)
> +		si->cache_mem += sizeof(struct f2fs_gc_kthread);
> +
> +	/* build merge flush thread */
> +	if (SM_I(sbi)->cmd_control_info)
> +		si->cache_mem += sizeof(struct flush_cmd_control);
>  
> -get_cache:
>  	/* free nids */
> -	si->cache_mem = NM_I(sbi)->fcnt;
> -	si->cache_mem += NM_I(sbi)->nat_cnt;
> +	si->cache_mem += NM_I(sbi)->fcnt * sizeof(struct free_nid);
> +	si->cache_mem += NM_I(sbi)->nat_cnt * sizeof(struct nat_entry);
>  	npages = NODE_MAPPING(sbi)->nrpages;
>  	si->cache_mem += npages << PAGE_CACHE_SHIFT;
>  	npages = META_MAPPING(sbi)->nrpages;
> -- 
> 2.2.1
