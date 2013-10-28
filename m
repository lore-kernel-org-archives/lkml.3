Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674Ab3J1Npo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 09:45:44 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:44540 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756291Ab3J1Npn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 09:45:43 -0400
MIME-Version: 1.0
In-Reply-To: <cc16130b4e23207971139eff313a4ec71f51c187.1382962788.git.rashika.kheria@gmail.com>
References: <20131019110539.GA25167@gmail.com>
	<cc16130b4e23207971139eff313a4ec71f51c187.1382962788.git.rashika.kheria@gmail.com>
Date: Mon, 28 Oct 2013 21:45:42 +0800
Message-ID: <CAL1ERfPD7zhmuO6ZuwUcJzVshJ3vqQKAman_x27rTPaur4eEAw@mail.gmail.com>
Subject: Re: [PATCH v6 1/3] Staging: zram: Fix access of NULL pointer
From: Weijie Yang <weijie.yang.kh@gmail.com>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: opw-kernel@googlegroups.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Minchan Kim <minchan@kernel.org>, Jiang Liu <jiang.liu@huawei.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchand@redhat.com>,
        Linux-Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 8:21 PM, Rashika Kheria
<rashika.kheria@gmail.com> wrote:
> This patch fixes the bug in reset_store caused by accessing NULL pointer.
> Hence, It introduces a check for bdev. It also removes unnecessary check
> of bdev for fsync_bdev().
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
>         zram = dev_to_zram(dev);
>         bdev = bdget_disk(zram->disk, 0);
>
> +       if (!bdev)
> +               return -EBUSY;
> +

I am not sure how does it happen. Would you please make it clear to me?

Thanks

>         /* Do not reset an active device! */
>         if (bdev->bd_holders)
>                 return -EBUSY;
> @@ -660,8 +663,7 @@ static ssize_t reset_store(struct device *dev,
>                 return -EINVAL;
>
>         /* Make sure all pending I/O is finished */
> -       if (bdev)
> -               fsync_bdev(bdev);
> +       fsync_bdev(bdev);
>
>         zram_reset_device(zram, true);
>         return len;
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
