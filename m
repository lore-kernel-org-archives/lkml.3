Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab3EMHGH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 03:06:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:5530 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754039Ab3EMHGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 03:06:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,659,1363158000"; 
   d="scan'208";a="240636166"
Date: Mon, 13 May 2013 15:05:56 +0800
From: Haicheng Li <haicheng.li@linux.intel.com>
To: Chris Fries <ccfries@gmail.com>
Cc: jaegeuk.kim@samsung.com, linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, rknize2@motorola.com,
        jason.hrycay@motorola.com
Subject: Re: [PATCH] f2fs: Remove BUG_ON in dec_valid_node_count
Message-ID: <20130513070556.GB21431@hli22-desktop>
References: <51906213.2020005@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51906213.2020005@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, May 12, 2013 at 10:46:27PM -0500, Chris Fries wrote:
> From: Chris Fries <C.Fries@motorola.com>
> 
> Panic loops while running LTP fsstress has been able to get
> a disk into two different panic loops from dec_valid_node_count.
> f2fs.h:714  BUG_ON(sbi->total_valid_node_count < count);

This is interesting catch.
from the code, dec_valid_node_count() is only called by truncate_node():
	dec_valid_node_count(sbi, dn->inode, 1);

So the failure in your test means that sbi->total_valid_node_count < 1,
i.e. equal to 0. This should be an unexpected status.

I think a better solution should be to avoid such over truncate_node situation.

How do you think?

> Once, it happens during recovery itself, and the disk would cause
> a panic every time it mounted.
> 
> Another time, it would happen during garbage collection, so the disk
> would cause a panic within 200 seconds of mounting.
> 
> Removing this BUG_ON hasn't shown any side effects, so let's take it
> out and monitor.
> 
> Signed-off-by: Chris Fries <C.Fries@motorola.com>
> 
> ---
>  fs/f2fs/f2fs.h | 18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index e80a87c..b8e9679 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -722,9 +722,21 @@ static inline void dec_valid_node_count(struct f2fs_sb_info *sbi,
>  {
>  	spin_lock(&sbi->stat_lock);
>  
> -	BUG_ON(sbi->total_valid_block_count < count);
> -	BUG_ON(sbi->total_valid_node_count < count);
> -	BUG_ON(inode->i_blocks < count);
> +	if (sbi->total_valid_block_count < count) {
> +		WARN(1, "F2FS: total_valid_block_count too small- %d vs %d\n",
> +			(unsigned int)sbi->total_valid_block_count, count);
> +		count = sbi->total_valid_block_count;
> +	}
> +	if (sbi->total_valid_node_count < count) {
> +		WARN(1, "F2FS: total_valid_node_count too small- %d vs %d\n",
> +			sbi->total_valid_node_count, count);
> +		count = sbi->total_valid_node_count;
> +	}
> +	if (inode->i_blocks < count) {
> +		WARN(1, "F2FS: inode->i_blocks too small - %d vs %d\n",
> +			(unsigned int)inode->i_blocks, count);
> +		count = sbi->total_valid_node_count;
> +	}
>  
>  	inode->i_blocks -= count;
>  	sbi->total_valid_node_count -= count;
> -- 
> 1.8.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
