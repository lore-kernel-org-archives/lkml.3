Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944Ab3J2Ani (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 20:43:38 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:51307 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756755Ab3J2Anh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 20:43:37 -0400
X-AuditID: 9c93017e-b7ca6ae000000e8a-92-526f04b77a90
Date: Tue, 29 Oct 2013 09:43:38 +0900
From: Minchan Kim <minchan@kernel.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: opw-kernel@googlegroups.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchand@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 1/3] Staging: zram: Fix access of NULL pointer
Message-ID: <20131029004338.GB17038@bbox>
References: <20131019110539.GA25167@gmail.com>
 <cc16130b4e23207971139eff313a4ec71f51c187.1382962788.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc16130b4e23207971139eff313a4ec71f51c187.1382962788.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rashika,

On Mon, Oct 28, 2013 at 05:51:38PM +0530, Rashika Kheria wrote:
> This patch fixes the bug in reset_store caused by accessing NULL pointer.
> Hence, It introduces a check for bdev. It also removes unnecessary check
> of bdev for fsync_bdev().

It's better than old but I still want it more better.
First of all, I hope patch description is more clear in case of bugfix patch
because other maintainers from stable/distro or other people could understand
well so they could judge once again whether they need to backport or not.
If maintainer judge that it's not severe, even they couldn't backport.

Patch description includes followin as, at least.

1. When this bug happens?
2. What's the result of user POV?
3. How to fix it.

You were good for 2 and 3 but 1

I can help.

If memory pressure is severe, inode could be reclaimed.
In this case, bdget_disk can return NULL because allocation of inode
in bdget could fail.

I hope you could do better massage.

In addition, this bug have been for a long time so it deserves backporting to
stable tree. In such case, you could Cc stable tree with stable mark.
Please refer Documentation/stable_kernel_rules.txt and others patches
in LKML.

After this year kernel summit, it seems to change something rule for
marking stable but I thinks it's not solid so old rule still would be
valid.

Thanks!

> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> ---
> 
> This revision fixes the following issues of the previous revision-
> Seperating patches into Bug fix and Smatch fix 
> 
>  drivers/staging/zram/zram_drv.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
> index 2c4ed52..d640a8f 100644
> --- a/drivers/staging/zram/zram_drv.c
> +++ b/drivers/staging/zram/zram_drv.c
> @@ -648,6 +648,9 @@ static ssize_t reset_store(struct device *dev,
>  	zram = dev_to_zram(dev);
>  	bdev = bdget_disk(zram->disk, 0);
>  
> +	if (!bdev)
> +		return -EBUSY;
> +
>  	/* Do not reset an active device! */
>  	if (bdev->bd_holders)
>  		return -EBUSY;
> @@ -660,8 +663,7 @@ static ssize_t reset_store(struct device *dev,
>  		return -EINVAL;
>  
>  	/* Make sure all pending I/O is finished */
> -	if (bdev)
> -		fsync_bdev(bdev);
> +	fsync_bdev(bdev);
>  
>  	zram_reset_device(zram, true);
>  	return len;
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Kind regards,
Minchan Kim
