Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760124Ab3GaPPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 11:15:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41718 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070Ab3GaPPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 11:15:43 -0400
Date: Wed, 31 Jul 2013 17:15:42 +0200
From: Jan Kara <jack@suse.cz>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, davej@redhat.com, viro@zeniv.linux.org.uk,
        jack@suse.cz, glommer@parallels.com
Subject: Re: [PATCH 07/11] writeback: periodically trim the writeback list
Message-ID: <20130731151542.GI22930@quack.suse.cz>
References: <1375244150-27296-1-git-send-email-david@fromorbit.com>
 <1375244150-27296-8-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375244150-27296-8-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 31-07-13 14:15:46, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Inodes are removed lazily from the bdi writeback list, so in the
> absence of sync(2) work inodes will build up on the bdi writback
> list even though they are no longer under IO. Use the periodic
> kupdate work check to remove inodes no longer under IO from the
> writeback list.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/fs-writeback.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 638f122..7c9bbf0 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -962,6 +962,23 @@ static long wb_check_background_flush(struct bdi_writeback *wb)
>  	return 0;
>  }
>  
> +/*
> + * clean out writeback list for all inodes that don't have IO in progress
> + */
> +static void wb_trim_writeback_list(struct bdi_writeback *wb)
> +{
> +	struct inode *inode;
> +	struct inode *tmp;
> +
> +	spin_lock(&wb->list_lock);
> +	list_for_each_entry_safe(inode, tmp, &wb->b_writeback, i_wb_list) {
> +		if (!mapping_tagged(inode->i_mapping, PAGECACHE_TAG_WRITEBACK))
> +			list_del_init(&inode->i_wb_list);
> +	}
   Oo, and here you manipulate i_wb_list without mapping->tree_lock so that
can race with the list_empty() check in bdi_mark_inode_writeback().

								Honza

> +	spin_unlock(&wb->list_lock);
> +
> +}
> +
>  static long wb_check_old_data_flush(struct bdi_writeback *wb)
>  {
>  	unsigned long expired;
> @@ -978,6 +995,8 @@ static long wb_check_old_data_flush(struct bdi_writeback *wb)
>  	if (time_before(jiffies, expired))
>  		return 0;
>  
> +	wb_trim_writeback_list(wb);
> +
>  	wb->last_old_flush = jiffies;
>  	nr_pages = get_nr_dirty_pages();
>  
> -- 
> 1.8.3.2
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
