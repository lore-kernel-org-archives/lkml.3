Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638Ab3J3Cdw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 22:33:52 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:61725 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab3J3Cdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 22:33:51 -0400
X-AuditID: 9c93017d-b7cd3ae000007ab3-e2-5270700d0d3b
Date: Wed, 30 Oct 2013 11:33:56 +0900
From: Minchan Kim <minchan@kernel.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: opw-kernel@googlegroups.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchand@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v7 2/3] Staging: zram: Fix decrement of variable by
 calling bdput()
Message-ID: <20131030023356.GB17013@bbox>
References: <cc16130b4e23207971139eff313a4ec71f51c187.1383087326.git.rashika.kheria@gmail.com>
 <c7dc0036457aa94707bdc17b1f475c88f35cdb07.1383087326.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c7dc0036457aa94707bdc17b1f475c88f35cdb07.1383087326.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 04:42:56AM +0530, Rashika Kheria wrote:
> As suggested by Jerome Marchand "The code in reset_store get the block device
> (bdget_disk()) but it does not put it (bdput()) when it's done using it.
> The usage count is therefor incremented but never decremented."
> 
> Hence, this patch introduces a call to bdput() to decrement the variable after usage.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> ---
> 
> This revision fixes the following issues of the previous revision-
> Handle more error cases
> 
>  drivers/staging/zram/zram_drv.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
> index d640a8f..592e760 100644
> --- a/drivers/staging/zram/zram_drv.c
> +++ b/drivers/staging/zram/zram_drv.c
> @@ -664,6 +664,9 @@ static ssize_t reset_store(struct device *dev,
>  
>  	/* Make sure all pending I/O is finished */
>  	fsync_bdev(bdev);
> +	bdput(bdev);
> +	bdput(bdev->bd_holders);
> +	bdput(do_reset);

I meant it.

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index e77fb6e..32f9a44 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -621,22 +621,30 @@ static ssize_t reset_store(struct device *dev,
 	bdev = bdget_disk(zram->disk, 0);
 
 	/* Do not reset an active device! */
-	if (bdev->bd_holders)
-		return -EBUSY;
+	if (bdev->bd_holders) {
+		ret = -EBUSY;
+		goto out;
+	}
 
 	ret = kstrtou16(buf, 10, &do_reset);
 	if (ret)
-		return ret;
+		goto out;
 
-	if (!do_reset)
-		return -EINVAL;
+	if (!do_reset) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	/* Make sure all pending I/O is finished */
-	if (bdev)
-		fsync_bdev(bdev);
+	fsync_bdev(bdev);
+	bdput(bdev);
 
 	zram_reset_device(zram);
 	return len;
+
+out:
+	bdput(bdev);
+	return ret;
 }
 
 static void __zram_make_request(struct zram *zram, struct bio *bio, int rw)

-- 
Kind regards,
Minchan Kim
