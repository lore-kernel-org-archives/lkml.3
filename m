Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab3J3Kme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 06:42:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753614Ab3J3Kmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 06:42:32 -0400
Message-ID: <5270E27F.9080001@redhat.com>
Date: Wed, 30 Oct 2013 11:42:07 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rashika Kheria <rashika.kheria@gmail.com>
CC: opw-kernel@googlegroups.com, Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchand@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v7 1/3] Staging: zram: Fix access of NULL pointer
References: <20131019110539.GA25167@gmail.com> <cc16130b4e23207971139eff313a4ec71f51c187.1383087326.git.rashika.kheria@gmail.com>
In-Reply-To: <cc16130b4e23207971139eff313a4ec71f51c187.1383087326.git.rashika.kheria@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2013 12:10 AM, Rashika Kheria wrote:
> This patch fixes the bug in reset_store caused by accessing NULL pointer.
> 
> The bdev gets its value from bdget_disk() which could fail when memory
> pressure is severe and hence can return NULL because allocation of
> inode in bdget could fail.
> 
> Hence, this patch introduces a check for bdev to prevent reference to a
> NULL pointer in the later part of the code. It also removes unnecessary
> check of bdev for fsync_bdev().
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Acked-by: Jerome Marchand <jmarchan@redhat.com>

> ---
> 
> This patch fixes the following issues of the previous revision-
> Better Description
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
> 

