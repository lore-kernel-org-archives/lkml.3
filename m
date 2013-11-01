Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341Ab3KAI5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 04:57:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43387 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485Ab3KAI5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 04:57:16 -0400
Message-ID: <52736C52.8080600@redhat.com>
Date: Fri, 01 Nov 2013 09:54:42 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rashika Kheria <rashika.kheria@gmail.com>
CC: opw-kernel@googlegroups.com, Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchand@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v9 2/2] Staging: zram: Fix decrement of variable by calling
 bdput()
References: <20131019110539.GA25167@gmail.com> <4fdb273ab0b1e7514f119d7e619ac708d2277d34.1383220461.git.rashika.kheria@gmail.com>
In-Reply-To: <4fdb273ab0b1e7514f119d7e619ac708d2277d34.1383220461.git.rashika.kheria@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2013 12:58 PM, Rashika Kheria wrote:
> As suggested by Jerome Marchand "The code in reset_store get the block device
The credit should actually go to Minchan. He found the bug. I merely
explained it.

> (bdget_disk()) but it does not put it (bdput()) when it's done using it.
> The usage count is therefore incremented but never decremented."
> 
> This patch also puts bdput() for all error cases.
> 
> Cc: stable@vger.kernel.org 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

This version finally looks good. Thanks for your effort.

Acked-by: Jerome Marchand <jmarchan@redhat.com>

> ---
> 
> This revision fixes the following issues of the previous revision-
> Proper error handling
> 
>  drivers/staging/zram/zram_drv.c |   19 ++++++++++++++-----
>  1 file changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
> index 012ba15..a1f8b1f 100644
> --- a/drivers/staging/zram/zram_drv.c
> +++ b/drivers/staging/zram/zram_drv.c
> @@ -652,21 +652,30 @@ static ssize_t reset_store(struct device *dev,
>  		return -ENOMEM;
>  
>  	/* Do not reset an active device! */
> -	if (bdev->bd_holders)
> -		return -EBUSY;
> +	if (bdev->bd_holders) {
> +		ret = -EBUSY;
> +		goto out;
> +	}
>  
>  	ret = kstrtou16(buf, 10, &do_reset);
>  	if (ret)
> -		return ret;
> +		goto out;
>  
> -	if (!do_reset)
> -		return -EINVAL;
> +	if (!do_reset) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
>  
>  	/* Make sure all pending I/O is finished */
>  	fsync_bdev(bdev);
> +	bdput(bdev);
>  
>  	zram_reset_device(zram, true);
>  	return len;
> +
> +out:	
> +	bdput(bdev);
> +	return ret;
>  }
>  
>  static void __zram_make_request(struct zram *zram, struct bio *bio, int rw)
> 

